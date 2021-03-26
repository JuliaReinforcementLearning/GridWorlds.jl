mutable struct TransportDirected{T, R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Agent, Wall, Box, Ball}}
    agent_pos::CartesianIndex{2}
    agent_dir::AbstractDirection
    reward::T
    rng::R
    terminal_reward::T
    ball_pos::CartesianIndex{2}
    box_pos::CartesianIndex{2}
    has_ball::Bool
    done::Bool
end

@generate_getters(TransportDirected)
@generate_setters(TransportDirected)

mutable struct TransportUndirected{T, R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Agent, Wall, Box, Ball}}
    agent_pos::CartesianIndex{2}
    reward::T
    rng::R
    terminal_reward::T
    ball_pos::CartesianIndex{2}
    box_pos::CartesianIndex{2}
    has_ball::Bool
    done::Bool
end

@generate_getters(TransportUndirected)
@generate_setters(TransportUndirected)

#####
# Directed
#####

function TransportDirected(; T = Float32, height = 8, width = 8, rng = Random.GLOBAL_RNG)
    objects = (AGENT, WALL, BOX, BALL)
    world = GridWorldBase(objects, height, width)

    room = Room(CartesianIndex(1, 1), height, width)
    place_room!(world, room)

    box_pos = CartesianIndex(height - 1, width - 1)
    world[BOX, box_pos] = true

    ball_pos = CartesianIndex(2, 3)
    world[BALL, ball_pos] = true

    agent_pos = CartesianIndex(2, 2)
    world[AGENT, agent_pos] = true

    agent_dir = RIGHT
    reward = zero(T)
    terminal_reward = one(T)
    has_ball = false
    done = false

    env = TransportDirected(world, agent_pos, agent_dir, reward, rng, terminal_reward, ball_pos, box_pos, has_ball, done)

    RLBase.reset!(env)

    return env
end

RLBase.state_space(env::TransportDirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = nothing
const TRANSPORT_DIRECTED_LAYERS = SA.SVector(2, 3, 4)
RLBase.state(env::TransportDirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = get_grid(get_world(env), get_agent_pos(env), get_agent_dir(env), get_half_size(env), TRANSPORT_DIRECTED_LAYERS)

RLBase.state_space(env::TransportDirected, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = nothing
RLBase.state(env::TransportDirected, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = (copy(get_grid(env)), get_agent_dir(env))

RLBase.action_space(env::TransportDirected, ::RLBase.DefaultPlayer) = (DIRECTED_NAVIGATION_ACTIONS..., PICK_UP, DROP)
RLBase.reward(env::TransportDirected, ::RLBase.DefaultPlayer) = get_reward(env)
RLBase.is_terminated(env::TransportDirected) = get_done(env)

function RLBase.reset!(env::TransportDirected{T}) where {T}
    world = get_world(env)
    rng = get_rng(env)

    world[AGENT, get_agent_pos(env)] = false
    world[BOX, get_box_pos(env)] = false
    world[BALL, get_ball_pos(env)] = false

    new_box_pos = rand(rng, pos -> !any(@view world[:, pos]), env)
    set_box_pos!(env, new_box_pos)
    world[BOX, new_box_pos] = true

    new_ball_pos = rand(rng, pos -> !any(@view world[:, pos]), env)
    set_ball_pos!(env, new_ball_pos)
    world[BALL, new_ball_pos] = true

    new_agent_pos = rand(rng, pos -> !any(@view world[:, pos]), env)
    set_agent_pos!(env, new_agent_pos)
    world[AGENT, new_agent_pos] = true

    set_agent_dir!(env, rand(rng, DIRECTIONS))

    set_reward!(env, zero(T))
    set_has_ball!(env, false)
    set_done!(env, false)

    return nothing
end

function (env::TransportDirected{T})(action::AbstractTurnAction) where {T}
    new_dir = turn(action, get_agent_dir(env))
    set_agent_dir!(env, new_dir)
    world = get_world(env)

    if world[BALL, get_box_pos(env)]
        set_done!(env, true)
        set_reward!(env, get_terminal_reward(env))
    else
        set_done!(env, false)
        set_reward!(env, zero(T))
    end

    return nothing
end

function (env::TransportDirected{T})(action::AbstractMoveAction) where {T}
    world = get_world(env)

    agent_pos = get_agent_pos(env)
    dest = move(action, get_agent_dir(env), agent_pos)
    if !world[WALL, dest]
        world[AGENT, agent_pos] = false
        set_agent_pos!(env, dest)
        world[AGENT, dest] = true
    end

    if world[BALL, get_box_pos(env)]
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

function TransportUndirected(; T = Float32, height = 8, width = 8, rng = Random.GLOBAL_RNG)
    objects = (AGENT, WALL, BOX, BALL)
    world = GridWorldBase(objects, height, width)

    room = Room(CartesianIndex(1, 1), height, width)
    place_room!(world, room)

    box_pos = CartesianIndex(height - 1, width - 1)
    world[BOX, box_pos] = true

    ball_pos = CartesianIndex(2, 3)
    world[BALL, ball_pos] = true

    agent_pos = CartesianIndex(2, 2)
    world[AGENT, agent_pos] = true

    reward = zero(T)
    terminal_reward = one(T)
    has_ball = false
    done = false

    env = TransportUndirected(world, agent_pos, reward, rng, terminal_reward, ball_pos, box_pos, has_ball, done)

    RLBase.reset!(env)

    return env
end

RLBase.state_space(env::TransportUndirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = nothing
const TRANSPORT_UNDIRECTED_LAYERS = SA.SVector(2, 3, 4)
RLBase.state(env::TransportUndirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = get_grid(get_world(env), get_agent_pos(env), get_half_size(env), TRANSPORT_UNDIRECTED_LAYERS)

RLBase.state_space(env::TransportUndirected, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = nothing
RLBase.state(env::TransportUndirected, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = copy(get_grid(env))

RLBase.action_space(env::TransportUndirected, player::RLBase.DefaultPlayer) = (UNDIRECTED_NAVIGATION_ACTIONS..., PICK_UP, DROP)
RLBase.reward(env::TransportUndirected, ::RLBase.DefaultPlayer) = get_reward(env)
RLBase.is_terminated(env::TransportUndirected) = get_done(env)

function RLBase.reset!(env::TransportUndirected{T}) where {T}
    world = get_world(env)
    rng = get_rng(env)

    world[AGENT, get_agent_pos(env)] = false
    world[BOX, get_box_pos(env)] = false
    world[BALL, get_ball_pos(env)] = false

    new_box_pos = rand(rng, pos -> !any(@view world[:, pos]), env)
    set_box_pos!(env, new_box_pos)
    world[BOX, new_box_pos] = true

    new_ball_pos = rand(rng, pos -> !any(@view world[:, pos]), env)
    set_ball_pos!(env, new_ball_pos)
    world[BALL, new_ball_pos] = true

    new_agent_pos = rand(rng, pos -> !any(@view world[:, pos]), env)
    set_agent_pos!(env, new_agent_pos)
    world[AGENT, new_agent_pos] = true

    set_reward!(env, zero(T))
    set_has_ball!(env, false)
    set_done!(env, false)

    return nothing
end

function (env::TransportUndirected{T})(action::AbstractMoveAction) where {T}
    world = get_world(env)

    agent_pos = get_agent_pos(env)
    dest = move(action, agent_pos)
    if !world[WALL, dest]
        world[AGENT, agent_pos] = false
        set_agent_pos!(env, dest)
        world[AGENT, dest] = true
    end

    if world[BALL, get_box_pos(env)]
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

function (env::Union{TransportDirected{T}, TransportUndirected{T}})(::PickUp) where {T}
    world = get_world(env)
    agent_pos = get_agent_pos(env)

    if world[BALL, agent_pos]
        world[BALL, agent_pos] = false
        set_has_ball!(env, true)
    end

    if world[BALL, get_box_pos(env)]
        set_done!(env, true)
        set_reward!(env, get_terminal_reward(env))
    else
        set_done!(env, false)
        set_reward!(env, zero(T))
    end

    return nothing
end

function (env::Union{TransportDirected{T}, TransportUndirected{T}})(::Drop) where {T}
    world = get_world(env)
    agent_pos = get_agent_pos(env)

    if get_has_ball(env)
        set_has_ball!(env, false)
        world[BALL, agent_pos] = true
    end

    if world[BALL, get_box_pos(env)]
        set_done!(env, true)
        set_reward!(env, get_terminal_reward(env))
    else
        set_done!(env, false)
        set_reward!(env, zero(T))
    end

    return nothing
end
