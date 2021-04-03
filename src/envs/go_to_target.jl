mutable struct GoToTargetDirected{T, R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Agent, Wall, Target1, Target2}}
    agent_pos::CartesianIndex{2}
    agent_dir::AbstractDirection
    reward::T
    rng::R
    target1_pos::CartesianIndex{2}
    target2_pos::CartesianIndex{2}
    target::Union{Target1, Target2}
    terminal_reward::T
    terminal_penalty::T
    done::Bool
end

@generate_getters(GoToTargetDirected)
@generate_setters(GoToTargetDirected)

mutable struct GoToTargetUndirected{T, R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Agent, Wall, Target1, Target2}}
    agent_pos::CartesianIndex{2}
    reward::T
    rng::R
    target1_pos::CartesianIndex{2}
    target2_pos::CartesianIndex{2}
    target::Union{Target1, Target2}
    terminal_reward::T
    terminal_penalty::T
    done::Bool
end

@generate_getters(GoToTargetUndirected)
@generate_setters(GoToTargetUndirected)

#####
# Directed
#####

function GoToTargetDirected(; T = Float32, height = 8, width = 8, rng = Random.GLOBAL_RNG)
    objects = (AGENT, WALL, TARGET1, TARGET2)
    world = GridWorldBase(objects, height, width)

    room = Room(CartesianIndex(1, 1), height, width)
    place_room!(world, room)

    target1_pos = CartesianIndex(height - 1, width - 1)
    world[TARGET1, target1_pos] = true
    target2_pos = CartesianIndex(height - 1, width - 2)
    world[TARGET2, target2_pos] = true

    agent_pos = CartesianIndex(2, 2)
    world[AGENT, agent_pos] = true

    agent_dir = RIGHT
    reward = zero(T)
    target = rand(rng, (TARGET1, TARGET2))
    terminal_reward = one(T)
    terminal_penalty = -one(T)
    done = false

    env = GoToTargetDirected(world, agent_pos, agent_dir, reward, rng, target1_pos, target2_pos, target, terminal_reward, terminal_penalty, done)

    RLBase.reset!(env)

    return env
end

RLBase.state_space(env::GoToTargetDirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = nothing
const GO_TO_TARGET_DIRECTED_LAYERS = SA.SVector(2, 3, 4)
RLBase.state(env::GoToTargetDirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = get_grid(get_world(env), get_agent_pos(env), get_agent_dir(env), get_half_size(env), GO_TO_TARGET_DIRECTED_LAYERS)

RLBase.state_space(env::GoToTargetDirected, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = nothing
RLBase.state(env::GoToTargetDirected, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = (copy(get_grid(env)), get_agent_dir(env))

RLBase.action_space(env::GoToTargetDirected, ::RLBase.DefaultPlayer) = DIRECTED_NAVIGATION_ACTIONS
RLBase.reward(env::GoToTargetDirected, ::RLBase.DefaultPlayer) = get_reward(env)
RLBase.is_terminated(env::GoToTargetDirected) = get_done(env)

function RLBase.reset!(env::GoToTargetDirected{T}) where {T}
    world = get_world(env)
    rng = get_rng(env)

    world[AGENT, get_agent_pos(env)] = false
    world[TARGET1, get_target1_pos(env)] = false
    world[TARGET2, get_target2_pos(env)] = false

    new_target1_pos = rand(rng, pos -> !any(@view world[:, pos]), env)
    set_target1_pos!(env, new_target1_pos)
    world[TARGET1, new_target1_pos] = true

    new_target2_pos = rand(rng, pos -> !any(@view world[:, pos]), env)
    set_target2_pos!(env, new_target2_pos)
    world[TARGET2, new_target2_pos] = true

    new_agent_pos = rand(rng, pos -> !any(@view world[:, pos]), env)
    set_agent_pos!(env, new_agent_pos)
    world[AGENT, new_agent_pos] = true

    set_agent_dir!(env, rand(rng, DIRECTIONS))

    set_target!(env, rand(rng, (TARGET1, TARGET2)))
    set_reward!(env, zero(T))
    set_done!(env, false)

    return nothing
end

function (env::GoToTargetDirected{T})(action::AbstractTurnAction) where {T}
    new_dir = turn(action, get_agent_dir(env))
    set_agent_dir!(env, new_dir)
    world = get_world(env)
    target = get_target(env)
    agent_pos = get_agent_pos(env)

    if world[TARGET1, agent_pos] || world[TARGET2, agent_pos]
        set_done!(env, true)
        if world[target, agent_pos]
            set_reward!(env, get_terminal_reward(env))
        else
            set_reward!(env, get_terminal_penalty(env))
        end
    else
        set_done!(env, false)
        set_reward!(env, zero(T))
    end

    return nothing
end

function (env::GoToTargetDirected{T})(action::AbstractMoveAction) where {T}
    world = get_world(env)
    target = get_target(env)

    agent_pos = get_agent_pos(env)
    dest = move(action, get_agent_dir(env), agent_pos)
    if !world[WALL, dest]
        world[AGENT, agent_pos] = false
        set_agent_pos!(env, dest)
        world[AGENT, dest] = true
    end

    agent_pos = get_agent_pos(env)
    if world[TARGET1, agent_pos] || world[TARGET2, agent_pos]
        set_done!(env, true)
        if world[target, agent_pos]
            set_reward!(env, get_terminal_reward(env))
        else
            set_reward!(env, get_terminal_penalty(env))
        end
    else
        set_done!(env, false)
        set_reward!(env, zero(T))
    end

    return nothing
end

#####
# Undirected
#####

function GoToTargetUndirected(; T = Float32, height = 8, width = 8, rng = Random.GLOBAL_RNG)
    objects = (AGENT, WALL, TARGET1, TARGET2)
    world = GridWorldBase(objects, height, width)

    room = Room(CartesianIndex(1, 1), height, width)
    place_room!(world, room)

    target1_pos = CartesianIndex(height - 1, width - 1)
    world[TARGET1, target1_pos] = true
    target2_pos = CartesianIndex(height - 1, width - 2)
    world[TARGET2, target2_pos] = true

    agent_pos = CartesianIndex(2, 2)
    world[AGENT, agent_pos] = true

    reward = zero(T)
    target = rand(rng, (TARGET1, TARGET2))
    terminal_reward = one(T)
    terminal_penalty = -one(T)
    done = false

    env = GoToTargetUndirected(world, agent_pos, reward, rng, target1_pos, target2_pos, target, terminal_reward, terminal_penalty, done)

    RLBase.reset!(env)

    return env
end

RLBase.state_space(env::GoToTargetUndirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = nothing
const GO_TO_TARGET_UNDIRECTED_LAYERS = SA.SVector(2, 3, 4)
RLBase.state(env::GoToTargetUndirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = get_grid(get_world(env), get_agent_pos(env), get_half_size(env), GO_TO_TARGET_UNDIRECTED_LAYERS)

RLBase.state_space(env::GoToTargetUndirected, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = nothing
RLBase.state(env::GoToTargetUndirected, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = copy(get_grid(env))

RLBase.action_space(env::GoToTargetUndirected, player::RLBase.DefaultPlayer) = UNDIRECTED_NAVIGATION_ACTIONS
RLBase.reward(env::GoToTargetUndirected, ::RLBase.DefaultPlayer) = get_reward(env)
RLBase.is_terminated(env::GoToTargetUndirected) = get_done(env)

function RLBase.reset!(env::GoToTargetUndirected{T}) where {T}
    world = get_world(env)
    rng = get_rng(env)

    world[AGENT, get_agent_pos(env)] = false
    world[TARGET1, get_target1_pos(env)] = false
    world[TARGET2, get_target2_pos(env)] = false

    new_target1_pos = rand(rng, pos -> !any(@view world[:, pos]), env)
    set_target1_pos!(env, new_target1_pos)
    world[TARGET1, new_target1_pos] = true

    new_target2_pos = rand(rng, pos -> !any(@view world[:, pos]), env)
    set_target2_pos!(env, new_target2_pos)
    world[TARGET2, new_target2_pos] = true

    new_agent_pos = rand(rng, pos -> !any(@view world[:, pos]), env)
    set_agent_pos!(env, new_agent_pos)
    world[AGENT, new_agent_pos] = true

    set_target!(env, rand(rng, (TARGET1, TARGET2)))
    set_reward!(env, zero(T))
    set_done!(env, false)

    return nothing
end

function (env::GoToTargetUndirected{T})(action::AbstractMoveAction) where {T}
    world = get_world(env)
    target = get_target(env)

    agent_pos = get_agent_pos(env)
    dest = move(action, agent_pos)
    if !world[WALL, dest]
        world[AGENT, agent_pos] = false
        set_agent_pos!(env, dest)
        world[AGENT, dest] = true
    end

    agent_pos = get_agent_pos(env)
    if world[TARGET1, agent_pos] || world[TARGET2, agent_pos]
        set_done!(env, true)
        if world[target, agent_pos]
            set_reward!(env, get_terminal_reward(env))
        else
            set_reward!(env, get_terminal_penalty(env))
        end
    else
        set_done!(env, false)
        set_reward!(env, zero(T))
    end

    return nothing
end
