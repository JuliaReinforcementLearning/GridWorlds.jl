mutable struct SequentialRoomsDirected{T, R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Agent, Wall, Goal}}
    agent_pos::CartesianIndex{2}
    agent_dir::AbstractDirection
    reward::T
    rng::R
    terminal_reward::T
    num_rooms::Int
    room_length_range::UnitRange{Int}
    rooms::Array{Room, 1}
    done::Bool
end

@generate_getters(SequentialRoomsDirected)
@generate_setters(SequentialRoomsDirected)

mutable struct SequentialRoomsUndirected{T, R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Agent, Wall, Goal}}
    agent_pos::CartesianIndex{2}
    reward::T
    rng::R
    terminal_reward::T
    num_rooms::Int
    room_length_range::UnitRange{Int}
    rooms::Array{Room, 1}
    done::Bool
end

@generate_getters(SequentialRoomsUndirected)
@generate_setters(SequentialRoomsUndirected)

#####
# Directed
#####

function SequentialRoomsDirected(; T = Float32, num_rooms = 3, room_length_range = 4:6, rng = Random.GLOBAL_RNG)
    objects = (AGENT, WALL, GOAL)
    big_n = 2 * num_rooms * room_length_range.stop
    world = GridWorldBase(objects, big_n, big_n)
    agent_pos = CartesianIndex(2, 2)
    agent_dir = RIGHT
    reward = zero(T)
    terminal_reward = one(T)
    done = false

    env = SequentialRoomsDirected(world, agent_pos, agent_dir, reward, rng, terminal_reward, num_rooms, room_length_range, Room[], done)

    RLBase.reset!(env)

    return env
end

RLBase.state_space(env::SequentialRoomsDirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = nothing
RLBase.state(env::SequentialRoomsDirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = get_agent_view(env)

RLBase.state_space(env::SequentialRoomsDirected, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = nothing
RLBase.state(env::SequentialRoomsDirected, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = (get_grid(env), get_agent_dir(env))

RLBase.action_space(env::SequentialRoomsDirected, ::RLBase.DefaultPlayer) = DIRECTED_NAVIGATION_ACTIONS
RLBase.reward(env::SequentialRoomsDirected, ::RLBase.DefaultPlayer) = get_reward(env)
RLBase.is_terminated(env::SequentialRoomsDirected) = get_done(env)

function RLBase.reset!(env::SequentialRoomsDirected{T}) where {T}
    big_n = 2 * env.num_rooms * env.room_length_range.stop
    world = GridWorldBase(get_objects(env), big_n, big_n)
    set_world!(env, world)

    rng = get_rng(env)

    env.rooms = Room[]

    room = generate_first_room(env)
    place_room!(env, room)
    push!(env.rooms, room)

    tries = 1

    while tries < env.num_rooms
        candidate_rooms = generate_candidate_rooms(env)

        if length(candidate_rooms) > 0
            room = rand(rng, candidate_rooms)
            place_room!(env, room)
            push!(env.rooms, room)

            door_pos = rand(rng, intersect(env.rooms[end - 1].region, room.region)[2:end-1])
            world[WALL, door_pos] = false
        end

        tries += 1
    end

    # create a compact world
    centered_world = get_centered_world(world)
    shift_rooms!(env)
    set_world!(env, centered_world)
    world = get_world(env)

    # add the GOAL randomly in the last room
    goal_pos = rand(rng, get_interior(env.rooms[end]))
    while goal_pos == get_agent_pos(env)
        goal_pos = rand(rng, get_interior(env.rooms[end]))
    end
    world[GOAL, goal_pos] = true

    # add the agent randomly in the first room
    agent_start_pos = rand(rng, get_interior(env.rooms[1]))
    set_agent_pos!(env, agent_start_pos)
    world[AGENT, agent_start_pos] = true

    set_agent_dir!(env, rand(rng, DIRECTIONS))

    set_reward!(env, zero(T))
    set_done!(env, false)

    return nothing
end

function (env::SequentialRoomsDirected{T})(action::AbstractTurnAction) where {T}
    new_dir = turn(action, get_agent_dir(env))
    set_agent_dir!(env, new_dir)
    world = get_world(env)

    if world[GOAL, get_agent_pos(env)]
        set_done!(env, true)
        set_reward!(env, get_terminal_reward(env))
    else
        set_done!(env, false)
        set_reward!(env, zero(T))
    end

    return nothing
end

function (env::SequentialRoomsDirected{T})(action::AbstractMoveAction) where {T}
    world = get_world(env)

    agent_pos = get_agent_pos(env)
    dest = move(action, get_agent_dir(env), agent_pos)

    if !world[WALL, dest]
        world[AGENT, agent_pos] = false
        set_agent_pos!(env, dest)
        world[AGENT, dest] = true
    end

    if world[GOAL, get_agent_pos(env)]
        set_done!(env, true)
        set_reward!(env, get_terminal_reward(env))
    else
        set_done!(env, false)
        set_reward!(env, zero(T))
    end

    return nothing
end

#####
# Undirected
#####

function SequentialRoomsUndirected(; T = Float32, num_rooms = 3, room_length_range = 4:6, rng = Random.GLOBAL_RNG)
    objects = (AGENT, WALL, GOAL)
    big_n = 2 * num_rooms * room_length_range.stop
    world = GridWorldBase(objects, big_n, big_n)
    agent_pos = CartesianIndex(2, 2)
    reward = zero(T)
    terminal_reward = one(T)
    done = false

    env = SequentialRoomsUndirected(world, agent_pos, reward, rng, terminal_reward, num_rooms, room_length_range, Room[], done)

    RLBase.reset!(env)

    return env
end

RLBase.state_space(env::SequentialRoomsUndirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = nothing
RLBase.state(env::SequentialRoomsUndirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = get_grid(get_world(env), get_agent_view_size(env), get_agent_pos(env))

RLBase.state_space(env::SequentialRoomsUndirected, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = nothing
RLBase.state(env::SequentialRoomsUndirected, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = get_grid(env)

RLBase.action_space(env::SequentialRoomsUndirected, player::RLBase.DefaultPlayer) = UNDIRECTED_NAVIGATION_ACTIONS
RLBase.reward(env::SequentialRoomsUndirected, ::RLBase.DefaultPlayer) = get_reward(env)
RLBase.is_terminated(env::SequentialRoomsUndirected) = get_done(env)

function RLBase.reset!(env::SequentialRoomsUndirected{T}) where {T}
    big_n = 2 * env.num_rooms * env.room_length_range.stop
    world = GridWorldBase(get_objects(env), big_n, big_n)
    set_world!(env, world)

    rng = get_rng(env)

    env.rooms = Room[]

    room = generate_first_room(env)
    place_room!(env, room)
    push!(env.rooms, room)

    tries = 1

    while tries < env.num_rooms
        candidate_rooms = generate_candidate_rooms(env)

        if length(candidate_rooms) > 0
            room = rand(rng, candidate_rooms)
            place_room!(env, room)
            push!(env.rooms, room)

            door_pos = rand(rng, intersect(env.rooms[end - 1].region, room.region)[2:end-1])
            world[WALL, door_pos] = false
        end

        tries += 1
    end

    # create a compact world
    centered_world = get_centered_world(world)
    shift_rooms!(env)
    set_world!(env, centered_world)
    world = get_world(env)

    # add the GOAL randomly in the last room
    goal_pos = rand(rng, get_interior(env.rooms[end]))
    while goal_pos == get_agent_pos(env)
        goal_pos = rand(rng, get_interior(env.rooms[end]))
    end
    world[GOAL, goal_pos] = true

    # add the agent randomly in the first room
    agent_start_pos = rand(rng, get_interior(env.rooms[1]))
    set_agent_pos!(env, agent_start_pos)
    world[AGENT, agent_start_pos] = true

    set_reward!(env, zero(T))
    set_done!(env, false)

    return nothing
end

function (env::SequentialRoomsUndirected{T})(action::AbstractMoveAction) where {T}
    world = get_world(env)

    agent_pos = get_agent_pos(env)
    dest = move(action, agent_pos)

    if !world[WALL, dest]
        world[AGENT, agent_pos] = false
        set_agent_pos!(env, dest)
        world[AGENT, dest] = true
    end

    if world[GOAL, get_agent_pos(env)]
        set_done!(env, true)
        set_reward!(env, get_terminal_reward(env))
    else
        set_done!(env, false)
        set_reward!(env, zero(T))
    end

    return nothing
end

#####
# Common
#####

#####
# Room generation and placement
#####

function generate_first_room(env::Union{SequentialRoomsDirected, SequentialRoomsUndirected})
    big_n = get_width(env)
    rng = get_rng(env)
    origin = CartesianIndex(big_n ÷ 2 + 1, big_n ÷ 2 + 1)
    height = rand(rng, env.room_length_range)
    width = rand(rng, env.room_length_range)
    room = Room(origin, height, width)
    return room
end

is_valid_room(env::Union{SequentialRoomsDirected, SequentialRoomsUndirected}, room::Room) = !any(x -> is_intersecting(room, x), env.rooms)

function generate_candidate_rooms(env::Union{SequentialRoomsDirected, SequentialRoomsUndirected})
    rooms = Room[]
    for height in env.room_length_range, width in env.room_length_range, dir in DIRECTIONS
        push!(rooms, generate_candidate_rooms(env, height, width, dir)...)
    end
    return rooms
end

function generate_candidate_rooms(env::Union{SequentialRoomsDirected, SequentialRoomsUndirected}, height::Int, width::Int, dir::AbstractDirection)
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

function shift_rooms!(env::Union{SequentialRoomsDirected, SequentialRoomsUndirected})
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
