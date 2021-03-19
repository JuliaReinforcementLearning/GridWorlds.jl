mutable struct EmptyRoomDirected{T, R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty, Wall, Goal}}
    agent_pos::CartesianIndex{2}
    agent_dir::AbstractDirection
    reward::T
    rng::R
    terminal_reward::T
    goal_pos::CartesianIndex{2}
    done::Bool
end

@generate_getters(EmptyRoomDirected)
@generate_setters(EmptyRoomDirected)

mutable struct EmptyRoomUndirected{T, R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty, Wall, Goal}}
    agent_pos::CartesianIndex{2}
    reward::T
    rng::R
    terminal_reward::T
    goal_pos::CartesianIndex{2}
    done::Bool
end

@generate_getters(EmptyRoomUndirected)
@generate_setters(EmptyRoomUndirected)

#####
# Directed
#####

function EmptyRoomDirected(; T = Float32, height = 8, width = 8, rng = Random.GLOBAL_RNG)
    objects = (EMPTY, WALL, GOAL)
    world = GridWorldBase(objects, height, width)
    room = Room(CartesianIndex(1, 1), height, width)
    place_room!(world, room)

    goal_pos = CartesianIndex(height - 1, width - 1)
    world[GOAL, goal_pos] = true
    world[EMPTY, goal_pos] = false

    agent_pos = CartesianIndex(2, 2)
    agent_dir = RIGHT
    reward = zero(T)
    terminal_reward = one(T)
    done = false

    env = EmptyRoomDirected(world, agent_pos, agent_dir, reward, rng, terminal_reward, goal_pos, done)

    RLBase.reset!(env)

    return env
end

RLBase.state_space(env::EmptyRoomDirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = nothing
RLBase.state(env::EmptyRoomDirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = get_agent_view(env)
RLBase.action_space(env::EmptyRoomDirected, ::RLBase.DefaultPlayer) = DIRECTED_NAVIGATION_ACTIONS
RLBase.reward(env::EmptyRoomDirected, ::RLBase.DefaultPlayer) = get_reward(env)
RLBase.is_terminated(env::EmptyRoomDirected) = get_done(env)

function RLBase.reset!(env::EmptyRoomDirected{T}) where {T}
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

function (env::EmptyRoomDirected{T})(action::AbstractTurnAction) where {T}
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

function (env::EmptyRoomDirected{T})(action::AbstractMoveAction) where {T}
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

function EmptyRoomUndirected(; T = Float32, height = 8, width = 8, rng = Random.GLOBAL_RNG)
    objects = (EMPTY, WALL, GOAL)
    world = GridWorldBase(objects, height, width)
    room = Room(CartesianIndex(1, 1), height, width)
    place_room!(world, room)

    goal_pos = CartesianIndex(height - 1, width - 1)
    world[GOAL, goal_pos] = true
    world[EMPTY, goal_pos] = false

    agent_pos = CartesianIndex(2, 2)
    reward = zero(T)
    terminal_reward = one(T)
    done = false

    env = EmptyRoomUndirected(world, agent_pos, reward, rng, terminal_reward, goal_pos, done)

    RLBase.reset!(env)

    return env
end

RLBase.state_space(env::EmptyRoomUndirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = nothing
RLBase.state(env::EmptyRoomUndirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = get_grid(get_world(env), get_agent_view_size(env), get_agent_pos(env))
RLBase.action_space(env::EmptyRoomUndirected, player::RLBase.DefaultPlayer) = UNDIRECTED_NAVIGATION_ACTIONS
RLBase.reward(env::EmptyRoomUndirected, ::RLBase.DefaultPlayer) = get_reward(env)
RLBase.is_terminated(env::EmptyRoomUndirected) = get_done(env)

function RLBase.reset!(env::EmptyRoomUndirected{T}) where {T}
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

function (env::EmptyRoomUndirected{T})(action::AbstractMoveAction) where {T}
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
