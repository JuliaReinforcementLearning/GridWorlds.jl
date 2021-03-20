mutable struct EmptyRoomDirected{T, R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Agent, Wall, Goal}}
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
    world::GridWorldBase{Tuple{Agent, Wall, Goal}}
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
    objects = (AGENT, WALL, GOAL)
    world = GridWorldBase(objects, height, width)

    room = Room(CartesianIndex(1, 1), height, width)
    place_room!(world, room)

    goal_pos = CartesianIndex(height - 1, width - 1)
    world[GOAL, goal_pos] = true

    agent_pos = CartesianIndex(2, 2)
    world[AGENT, agent_pos] = true

    agent_dir = RIGHT
    reward = zero(T)
    terminal_reward = one(T)
    done = false

    env = EmptyRoomDirected(world, agent_pos, agent_dir, reward, rng, terminal_reward, goal_pos, done)

    RLBase.reset!(env)

    return env
end

RLBase.state_space(env::EmptyRoomDirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = nothing
const EMPTY_ROOM_DIRECTED_LAYERS = SA.SVector(2, 3)
RLBase.state(env::EmptyRoomDirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = get_grid(get_world(env), get_agent_pos(env), get_agent_dir(env), get_half_size(env), EMPTY_ROOM_DIRECTED_LAYERS)

RLBase.state_space(env::EmptyRoomDirected, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = nothing
RLBase.state(env::EmptyRoomDirected, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = (copy(get_grid(env)), get_agent_dir(env))

RLBase.action_space(env::EmptyRoomDirected, ::RLBase.DefaultPlayer) = DIRECTED_NAVIGATION_ACTIONS
RLBase.reward(env::EmptyRoomDirected, ::RLBase.DefaultPlayer) = get_reward(env)
RLBase.is_terminated(env::EmptyRoomDirected) = get_done(env)

function RLBase.reset!(env::EmptyRoomDirected{T}) where {T}
    world = get_world(env)
    rng = get_rng(env)

    world[AGENT, get_agent_pos(env)] = false
    world[GOAL, get_goal_pos(env)] = false

    new_goal_pos = rand(rng, pos -> !any(@view world[:, pos]), env)
    set_goal_pos!(env, new_goal_pos)
    world[GOAL, new_goal_pos] = true

    new_agent_pos = rand(rng, pos -> !any(@view world[:, pos]), env)
    set_agent_pos!(env, new_agent_pos)
    world[AGENT, new_agent_pos] = true

    set_agent_dir!(env, rand(rng, DIRECTIONS))

    set_reward!(env, zero(T))
    set_done!(env, false)

    return nothing
end

function (env::EmptyRoomDirected{T})(action::AbstractTurnAction) where {T}
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

function (env::EmptyRoomDirected{T})(action::AbstractMoveAction) where {T}
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

function EmptyRoomUndirected(; T = Float32, height = 8, width = 8, rng = Random.GLOBAL_RNG)
    objects = (AGENT, WALL, GOAL)
    world = GridWorldBase(objects, height, width)

    room = Room(CartesianIndex(1, 1), height, width)
    place_room!(world, room)

    goal_pos = CartesianIndex(height - 1, width - 1)
    world[GOAL, goal_pos] = true

    agent_pos = CartesianIndex(2, 2)
    world[AGENT, agent_pos] = true

    reward = zero(T)
    terminal_reward = one(T)
    done = false

    env = EmptyRoomUndirected(world, agent_pos, reward, rng, terminal_reward, goal_pos, done)

    RLBase.reset!(env)

    return env
end

RLBase.state_space(env::EmptyRoomUndirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = nothing
const EMPTY_ROOM_UNDIRECTED_LAYERS = SA.SVector(2, 3)
RLBase.state(env::EmptyRoomUndirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = get_grid(get_world(env), get_agent_pos(env), get_half_size(env), EMPTY_ROOM_UNDIRECTED_LAYERS)

RLBase.state_space(env::EmptyRoomUndirected, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = nothing
RLBase.state(env::EmptyRoomUndirected, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = copy(get_grid(env))

RLBase.action_space(env::EmptyRoomUndirected, player::RLBase.DefaultPlayer) = UNDIRECTED_NAVIGATION_ACTIONS
RLBase.reward(env::EmptyRoomUndirected, ::RLBase.DefaultPlayer) = get_reward(env)
RLBase.is_terminated(env::EmptyRoomUndirected) = get_done(env)

function RLBase.reset!(env::EmptyRoomUndirected{T}) where {T}
    world = get_world(env)
    rng = get_rng(env)

    world[AGENT, get_agent_pos(env)] = false
    world[GOAL, get_goal_pos(env)] = false

    new_goal_pos = rand(rng, pos -> !any(@view world[:, pos]), env)
    set_goal_pos!(env, new_goal_pos)
    world[GOAL, new_goal_pos] = true

    new_agent_pos = rand(rng, pos -> !any(@view world[:, pos]), env)
    set_agent_pos!(env, new_agent_pos)
    world[AGENT, new_agent_pos] = true

    set_reward!(env, zero(T))
    set_done!(env, false)

    return nothing
end

function (env::EmptyRoomUndirected{T})(action::AbstractMoveAction) where {T}
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
