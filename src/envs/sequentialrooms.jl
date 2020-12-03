export Room, SequentialRooms

#####
# Room struct
#####

struct Room
    region::CartesianIndices{2}
end

Room(origin, height, width) = Room(CartesianIndices((origin.I[1] : origin.I[1] + height - 1, origin.I[2] : origin.I[2] + width - 1)))

get_origin(region::CartesianIndices{2}) = region[1, 1]
get_origin(room::Room) = get_origin(room.region)

get_interior(room::Room) = room.region[2:end-1, 2:end-1]

function is_intersecting(room1::Room, room2::Room)
    intersection = intersect(get_interior(room1), room2.region)
    length(intersection) > 0 ? true : false
end

#####
# Environment struct
#####

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

function SequentialRooms(; num_rooms = 3, room_length_range = 4:6, agent_start_dir = RIGHT, rng = Random.GLOBAL_RNG)
    objects = (EMPTY, WALL, GOAL)
    big_n = 2 * num_rooms * room_length_range.stop
    world = GridWorldBase(objects, big_n, big_n)

    goal_reward = 1.0
    reward = 0.0

    env = SequentialRooms(world, CartesianIndex(1, 1), Agent(dir = agent_start_dir), num_rooms, room_length_range, Room[], goal_reward, reward, rng)

    reset!(env, agent_start_dir = agent_start_dir)

    return env
end

#####
# RLBase API
#####

RLBase.get_terminal(env::SequentialRooms) = get_world(env)[GOAL, get_agent_pos(env)]

function RLBase.reset!(env::AbstractGridWorld; agent_start_dir = RIGHT)
    world = get_world(env)

    world[:, :, :] .= false

    set_agent_pos!(env, CartesianIndex(1, 1))

    env.rooms = Room[]

    set_reward!(env, 0.0)

    set_agent_dir!(env, agent_start_dir)

    room = generate_first_room(env)
    add_room!(env, room)

    tries = 1

    while tries < env.num_rooms
        candidate_rooms = generate_candidate_rooms(env)

        if length(candidate_rooms) > 0
            room = rand(env.rng, candidate_rooms)
            add_room!(env, room)

            door_pos = rand(env.rng, intersect(env.rooms[end - 1].region, room.region)[2:end-1])
            world[WALL, door_pos] = false
            world[EMPTY, door_pos] = true
        end

        tries += 1
    end

    # create a compact world
    centered_world = get_centered_world(world)
    shift_rooms!(env)
    set_world!(env, centered_world)

    # add the agent randomly in the first room
    set_agent_pos!(env, rand(env.rng, get_interior(env.rooms[1])))

    # add the GOAL randomly in the last room
    world = get_world(env)
    goal_pos = rand(env.rng, get_interior(env.rooms[end]))
    while goal_pos == env.agent_pos
        goal_pos = rand(env.rng, get_interior(env.rooms[end]))
    end
    world[GOAL, goal_pos] = true
    world[EMPTY, goal_pos] = false

    return env
end

#####
# Room generation and placement
#####

function generate_first_room(env::AbstractGridWorld)
    big_n = get_width(env)
    origin = CartesianIndex(big_n ÷ 2 + 1, big_n ÷ 2 + 1)
    height = rand(env.rng, env.room_length_range)
    width = rand(env.rng, env.room_length_range)
    room = Room(origin, height, width)
    return room
end

function add_room!(env::AbstractGridWorld, room::Room)
    world = get_world(env)
    world[WALL, room.region] .= true
    world[WALL, get_interior(room)] .= false
    world[EMPTY, get_interior(room)] .= true
    push!(env.rooms, room)
end

is_valid_room(env::SequentialRooms, room::Room) = !any(x -> is_intersecting(room, x), env.rooms)

function generate_candidate_rooms(env::SequentialRooms)
    rooms = Room[]
    for height in env.room_length_range, width in env.room_length_range, dir in DIRECTIONS
        push!(rooms, generate_candidate_rooms(env, height, width, dir)...)
    end
    return rooms
end

function generate_candidate_rooms(env::SequentialRooms, height::Int, width::Int, dir::Direction)
    origins = generate_candidate_origins(env.rooms[end], height, width, dir)
    rooms = map(x -> Room(x, height, width), origins)
    valid_rooms = filter(x -> is_valid_room(env, x), rooms)
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

#####
# World centering
#####

function get_bounding_region(world::GridWorldBase)
    all_wall_pos = findall(world[WALL, :, :])
    top_extreme = minimum(pos -> pos.I[1], all_wall_pos)
    bottom_extreme = maximum(pos -> pos.I[1], all_wall_pos)
    left_extreme = minimum(pos -> pos.I[2], all_wall_pos)
    right_extreme = maximum(pos -> pos.I[2], all_wall_pos)
    CartesianIndices((top_extreme:bottom_extreme, left_extreme:right_extreme))
end

function get_padding(world::GridWorldBase)
    bounding_region = get_bounding_region(world)
    small_n = get_width(world) ÷ 2
    top_padding = (small_n - size(bounding_region, 1)) ÷ 2
    left_padding = (small_n - size(bounding_region, 2)) ÷ 2
    CartesianIndex(top_padding, left_padding)
end

function get_new_global_origin(world::GridWorldBase)
    padding = get_padding(world)
    bounding_region = get_bounding_region(world)
    return get_origin(bounding_region) - padding
end

function shift_rooms!(env::AbstractGridWorld)
    world = get_world(env)
    new_global_origin = get_new_global_origin(world)
    for (i, room) in enumerate(env.rooms)
        env.rooms[i] = shifted_room(room, new_global_origin)
    end
end

function shifted_room(room::Room, new_global_origin::CartesianIndex{2})
    height = size(room.region, 1)
    width = size(room.region, 2)
    new_room_origin = get_origin(room) - new_global_origin + CartesianIndex(1, 1)
    Room(new_room_origin, height, width)
end

function get_centered_world(world::GridWorldBase)
    small_n = get_width(world) ÷ 2
    new_global_origin = get_new_global_origin(world)
    new_global_region = CartesianIndices((new_global_origin.I[1] : new_global_origin.I[1] + small_n - 1, new_global_origin.I[2] : new_global_origin.I[2] + small_n - 1))
    centered_world = GridWorldBase(get_objects(world), small_n, small_n)
    centered_world[:, :, :] .= world[:, new_global_region]
    return centered_world
end
