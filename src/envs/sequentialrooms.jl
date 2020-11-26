export Room, SequentialRooms

struct Room
    region::CartesianIndices{2}
end

Room(origin, height, width) = Room(CartesianIndices((origin.I[1] : origin.I[1] + height - 1, origin.I[2] : origin.I[2] + width - 1)))

interior(room::Room) = room.region[2:end-1, 2:end-1]

function is_intersecting(room1::Room, room2::Room)
    intersection = intersect(interior(room1), room2.region)
    length(intersection) > 0 ? true : false
end

mutable struct SequentialRooms{R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty,Wall,Goal}}
    agent_pos::CartesianIndex{2}
    agent::Agent
    num_rooms::Int
    room_length_range::UnitRange{Int}
    rooms::Array{Room, 1}
    goal_reward::Float64
    reward::Float64
    rng::R
end

function SequentialRooms(;num_rooms = 3, room_length_range = 4:5, agent_start_dir = RIGHT, rng = Random.GLOBAL_RNG)
    objects = (EMPTY, WALL, GOAL)
    n = 2 * num_rooms * room_length_range.stop
    world = GridWorldBase(objects, n, n)

    goal_reward = 1.0
    reward = 0.0

    env = SequentialRooms(world, CartesianIndex(1, 1), Agent(dir = agent_start_dir), num_rooms, room_length_range, Room[], goal_reward, reward, rng)

    reset!(env, agent_start_dir = agent_start_dir)

    return env
end

function (env::SequentialRooms)(::MoveForward)
    env.reward = 0.0
    agent = get_agent(env)
    dir = get_agent_dir(env)
    pos = get_agent_pos(env)
    dest = dir(pos)
    if !env.world[WALL, dest]
        env.agent_pos = dest
        if env.world[GOAL, env.agent_pos]
            env.reward = env.goal_reward
        end
    end
    env
end

function RLBase.reset!(env::AbstractGridWorld; agent_start_dir = RIGHT)
    world = get_world(env)
    world[:, :, :] .= false
    env.agent_pos = CartesianIndex(1, 1)
    env.rooms = Room[]
    env.reward = 0.0

    agent = get_agent(env)
    set_dir!(agent, agent_start_dir)

    room = generate_first_room(env)
    push!(env.rooms, room)
    place_room!(world, room)

    tries = 1

    while tries < env.num_rooms
        candidate_rooms = generate_candidate_rooms(env)

        if length(candidate_rooms) > 0
            room = rand(env.rng, candidate_rooms)
            push!(env.rooms, room)
            place_room!(world, room)

            door_pos = rand(env.rng, intersect(env.rooms[end - 1].region, room.region)[2:end-1])
            world[WALL, door_pos] = false
            world[EMPTY, door_pos] = true
        end

        tries += 1
    end

    # shift the region and the rooms
    centered_world = get_centered_world(world)


    return env
end

function shifted_room(room::Room, new_global_origin::CartesianIndex{2})

    height = size(room.region, 1)
    width = size(room.region, 2)

    new_region = CartesianIndices((new_global_origin.I[1] : new_origin.I[1] + small_n - 1, new_origin.I[2] : new_origin.I[2] + small_n - 1))
end

function get_centered_world(world::GridWorldBase)
    small_n = size(world)[end] ÷ 2
    new_origin = get_new_origin(world)
    new_region = CartesianIndices((new_origin.I[1] : new_origin.I[1] + small_n - 1, new_origin.I[2] : new_origin.I[2] + small_n - 1))
    centered_world = GridWorldBase(get_object(world), small_n, small_n)
    centered_world[:, :, :] .= world[:, new_region]
    return centered_world
end

function get_bounding_region(world::GridWorldBase)
    all_wall_pos = findall(world[WALL, :, :])
    top_extreme = minimum(pos -> pos.I[1], all_wall_pos)
    bottom_extreme = maximum(pos -> pos.I[1], all_wall_pos)
    left_extreme = minimum(pos -> pos.I[2], all_wall_pos)
    right_extreme = maximum(pos -> pos.I[2], all_wall_pos)
    CartesianIndices((top_extreme:bottom_extreme, left_extreme:right_extreme))
end

function get_shift(world::GridWorldBase)
    bounding_region = get_bounding_region(world)
    small_n = size(world)[end] ÷ 2
    top_padding = (small_n - size(bounding_region, 1)) ÷ 2
    left_padding = (small_n - size(bounding_region, 2)) ÷ 2
    CartesianIndex(top_padding, left_padding)
end

function get_new_origin(world::GridWorldBase)
    shift = get_shift(world)
    bounding_region = get_bounding_region(world)
    new_origin = bounding_region[1, 1] - shift
    return new_origin
end

function generate_first_room(env::AbstractGridWorld)
    n = size(env.world)[end]
    origin = CartesianIndex(n ÷ 2 + 1, n ÷ 2 + 1)
    height = rand(env.rng, env.room_length_range)
    width = rand(env.rng, env.room_length_range)
    room = Room(origin, height, width)
    return room
end

function place_room!(world::GridWorldBase, room::Room)
    world[WALL, room.region] .= true
    world[WALL, interior(room)] .= false
    world[EMPTY, interior(room)] .= true
end

function generate_candidate_rooms(env::SequentialRooms)
    rooms = Room[]
    for height in env.room_length_range, width in env.room_length_range
        for dir in DIRECTIONS
            push!(rooms, generate_candidate_rooms(env, height, width, dir)...)
        end
    end

    return rooms
end

function generate_candidate_rooms(env::SequentialRooms, height::Int, width::Int, dir::Direction)
    rooms = Room[]
    origins = generate_candidate_origins(env.rooms[end], height, width, dir)
    for origin in origins
        room = Room(origin, height, width)
        if is_valid_room(env, room)
            push!(rooms, room)
        end
    end
    return rooms
end

function generate_candidate_origins(room::Room, height::Int, width::Int, dir::Up)
    i = room.region.indices[1].start - height + 1
    jj = room.region.indices[2].start - width + 3 : room.region.indices[2].stop - 2
    return CartesianIndices((i:i, jj))
end

function generate_candidate_origins(room::Room, height::Int, width::Int, dir::Down)
    i = room.region.indices[1].stop
    jj = room.region.indices[2].start - width + 3 : room.region.indices[2].stop - 2
    return CartesianIndices((i:i, jj))
end

function generate_candidate_origins(room::Room, height::Int, width::Int, dir::Left)
    ii = room.region.indices[1].start - height + 3 : room.region.indices[1].stop - 2
    j = room.region.indices[2].start - width + 1
    return CartesianIndices((ii, j:j))
end

function generate_candidate_origins(room::Room, height::Int, width::Int, dir::Right)
    ii = room.region.indices[1].start - height + 3 : room.region.indices[1].stop - 2
    j = room.region.indices[2].stop
    return CartesianIndices((ii, j:j))
end

function is_valid_room(env::SequentialRooms, room::Room)
    for r in env.rooms
        if is_intersecting(r, room)
            return false
        end
    end
    return true
end
