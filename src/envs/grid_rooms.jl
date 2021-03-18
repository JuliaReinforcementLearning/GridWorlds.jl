mutable struct GridRoomsDirected{T, R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty, Wall, Goal}}
    agent_pos::CartesianIndex{2}
    agent_dir::AbstractDirection
    reward::T
    rng::R
    terminal_reward::T
    goal_pos::CartesianIndex{2}
    done::Bool
end

mutable struct GridRoomsUndirected{T, R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty, Wall, Goal}}
    agent_pos::CartesianIndex{2}
    reward::T
    rng::R
    terminal_reward::T
    goal_pos::CartesianIndex{2}
    done::Bool
end

#####
# Directed
#####

function GridRoomsDirected(; T = Float32, grid_size = (2, 2), room_size = (5, 5), rng = Random.GLOBAL_RNG)
    grid_height = grid_size[1]
    grid_width = grid_size[2]
    room_height = room_size[1]
    room_width = room_size[2]

    height = room_height * grid_height - grid_height + 1
    width = room_width * grid_width - grid_width + 1
    objects = (EMPTY, WALL, GOAL)
    world = GridWorldBase(objects, height, width)

    origins = get_room_origins(grid_size, room_size)

    for origin in origins
        room = Room(origin, room_height, room_width)
        place_room!(world, room)

        world[WALL, room.region[(end + 1) ÷ 2, 1]] = false
        world[EMPTY, room.region[(end + 1) ÷ 2, 1]] = true
        world[WALL, room.region[(end + 1) ÷ 2, end]] = false
        world[EMPTY, room.region[(end + 1) ÷ 2, end]] = true
        world[WALL, room.region[1, (end + 1) ÷ 2]] = false
        world[EMPTY, room.region[1, (end + 1) ÷ 2]] = true
        world[WALL, room.region[end, (end + 1) ÷ 2]] = false
        world[EMPTY, room.region[end, (end + 1) ÷ 2]] = true
    end

    world[WALL, [1, height], :] .= true
    world[EMPTY, [1, height], :] .= false
    world[WALL, :, [1, width]] .= true
    world[EMPTY, :, [1, width]] .= false

    agent_pos = CartesianIndex(2, 2)
    agent_dir = RIGHT
    reward = zero(T)
    terminal_reward = one(T)
    goal_pos = CartesianIndex(height - 1, width - 1)
    done = false

    env = GridRoomsDirected(world, agent_pos, agent_dir, reward, rng, terminal_reward, goal_pos, done)

    RLBase.reset!(env)

    return env
end

RLBase.state_space(env::GridRoomsDirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = nothing
RLBase.state(env::GridRoomsDirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = get_agent_view(env)
RLBase.action_space(env::GridRoomsDirected, ::RLBase.DefaultPlayer) = DIRECTED_NAVIGATION_ACTIONS
RLBase.reward(env::GridRoomsDirected, ::RLBase.DefaultPlayer) = get_reward(env)
RLBase.is_terminated(env::GridRoomsDirected) = get_done(env)

function RLBase.reset!(env::GridRoomsDirected{T}) where {T}
    world = get_world(env)
    rng = get_rng(env)

    old_goal_pos = get_goal_pos(env)
    world[GOAL, old_goal_pos] = false
    world[EMPTY, old_goal_pos] = true

    new_goal_pos = rand(rng, pos -> world[EMPTY, pos], env)

    set_goal_pos!(env, new_goal_pos)
    world[GOAL, new_goal_pos] = true
    world[EMPTY, new_goal_pos] = false

    agent_start_pos = rand(rng, pos -> world[EMPTY, pos], env)
    agent_start_dir = rand(rng, DIRECTIONS)

    set_agent_pos!(env, agent_start_pos)
    set_agent_dir!(env, agent_start_dir)

    set_reward!(env, zero(T))
    set_done!(env, false)

    return env
end

function (env::GridRoomsDirected{T})(action::AbstractTurnAction) where {T}
    dir = get_agent_dir(env)
    new_dir = turn(action, dir)
    set_agent_dir!(env, new_dir)
    world = get_world(env)

    if world[GOAL, get_agent_pos(env)]
        set_done!(env, true)
        set_reward!(env, env.terminal_reward)
    else
        set_done!(env, false)
        set_reward!(env, zero(T))
    end

    return env
end

function (env::GridRoomsDirected{T})(action::AbstractMoveAction) where {T}
    world = get_world(env)

    dest = move(action, get_agent_dir(env), get_agent_pos(env))
    if !world[WALL, dest]
        set_agent_pos!(env, dest)
    end

    if world[GOAL, get_agent_pos(env)]
        set_done!(env, true)
        set_reward!(env, env.terminal_reward)
    else
        set_done!(env, false)
        set_reward!(env, zero(T))
    end

    return env
end

#####
# Undirected
#####

function GridRoomsUndirected(; T = Float32, grid_size = (2, 2), room_size = (5, 5), rng = Random.GLOBAL_RNG)
    grid_height = grid_size[1]
    grid_width = grid_size[2]
    room_height = room_size[1]
    room_width = room_size[2]

    height = room_height * grid_height - grid_height + 1
    width = room_width * grid_width - grid_width + 1
    objects = (EMPTY, WALL, GOAL)
    world = GridWorldBase(objects, height, width)

    origins = get_room_origins(grid_size, room_size)

    for origin in origins
        room = Room(origin, room_height, room_width)
        place_room!(world, room)

        world[WALL, room.region[(end + 1) ÷ 2, 1]] = false
        world[EMPTY, room.region[(end + 1) ÷ 2, 1]] = true
        world[WALL, room.region[(end + 1) ÷ 2, end]] = false
        world[EMPTY, room.region[(end + 1) ÷ 2, end]] = true
        world[WALL, room.region[1, (end + 1) ÷ 2]] = false
        world[EMPTY, room.region[1, (end + 1) ÷ 2]] = true
        world[WALL, room.region[end, (end + 1) ÷ 2]] = false
        world[EMPTY, room.region[end, (end + 1) ÷ 2]] = true
    end

    world[WALL, [1, height], :] .= true
    world[EMPTY, [1, height], :] .= false
    world[WALL, :, [1, width]] .= true
    world[EMPTY, :, [1, width]] .= false

    agent_pos = CartesianIndex(2, 2)
    reward = zero(T)
    terminal_reward = one(T)
    goal_pos = CartesianIndex(height - 1, width - 1)
    done = false

    env = GridRoomsUndirected(world, agent_pos, reward, rng, terminal_reward, goal_pos, done)

    RLBase.reset!(env)

    return env
end

RLBase.state_space(env::GridRoomsUndirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = nothing
RLBase.state(env::GridRoomsUndirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = get_grid(get_world(env), get_agent_view_size(env), get_agent_pos(env))
RLBase.action_space(env::GridRoomsUndirected, player::RLBase.DefaultPlayer) = UNDIRECTED_NAVIGATION_ACTIONS
RLBase.reward(env::GridRoomsUndirected, ::RLBase.DefaultPlayer) = get_reward(env)
RLBase.is_terminated(env::GridRoomsUndirected) = get_done(env)

function RLBase.reset!(env::GridRoomsUndirected{T}) where {T}
    world = get_world(env)
    rng = get_rng(env)

    old_goal_pos = get_goal_pos(env)
    world[GOAL, old_goal_pos] = false
    world[EMPTY, old_goal_pos] = true

    new_goal_pos = rand(rng, pos -> world[EMPTY, pos], env)

    set_goal_pos!(env, new_goal_pos)
    world[GOAL, new_goal_pos] = true
    world[EMPTY, new_goal_pos] = false

    agent_start_pos = rand(rng, pos -> world[EMPTY, pos], env)
    set_agent_pos!(env, agent_start_pos)

    set_reward!(env, zero(T))
    set_done!(env, false)

    return env
end

function (env::GridRoomsUndirected{T})(action::AbstractMoveAction) where {T}
    world = get_world(env)

    dest = move(action, get_agent_pos(env))
    if !world[WALL, dest]
        set_agent_pos!(env, dest)
    end

    if world[GOAL, get_agent_pos(env)]
        set_done!(env, true)
        set_reward!(env, env.terminal_reward)
    else
        set_done!(env, false)
        set_reward!(env, zero(T))
    end

    return env
end

#####
# Common
#####

function get_room_origins(grid_size, room_size)
    grid_height = grid_size[1]
    grid_width = grid_size[2]
    room_height = room_size[1]
    room_width = room_size[2]

    vertical_steps = 1 : room_height - 1 : 1 + (grid_height - 1) * (room_height - 1)
    horizontal_steps = 1 : room_width - 1 : 1 + (grid_width - 1) * (room_width - 1)

    return [CartesianIndex(i, j) for i in vertical_steps for j in horizontal_steps]
end
