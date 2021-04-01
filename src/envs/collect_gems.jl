mutable struct CollectGemsDirected{T, R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Agent, Wall, Gem}}
    agent_pos::CartesianIndex{2}
    agent_dir::AbstractDirection
    reward::T
    rng::R
    num_gem_init::Int
    num_gem_current::Int
    gem_reward::T
    gem_pos_init::Vector{CartesianIndex{2}}
    done::Bool
end

@generate_getters(CollectGemsDirected)
@generate_setters(CollectGemsDirected)

mutable struct CollectGemsUndirected{T, R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Agent, Wall, Gem}}
    agent_pos::CartesianIndex{2}
    reward::T
    rng::R
    num_gem_init::Int
    num_gem_current::Int
    gem_reward::T
    gem_pos_init::Vector{CartesianIndex{2}}
    done::Bool
end

@generate_getters(CollectGemsUndirected)
@generate_setters(CollectGemsUndirected)

#####
# Directed
#####

function CollectGemsDirected(; T = Float32, height = 8, width = 8, num_gem_init = floor(Int, sqrt(height * width)), rng = Random.GLOBAL_RNG)
    objects = (AGENT, WALL, GEM)
    world = GridWorldBase(objects, height, width)

    room = Room(CartesianIndex(1, 1), height, width)
    place_room!(world, room)

    agent_pos = CartesianIndex(2, 2)
    world[AGENT, agent_pos] = true

    agent_dir = RIGHT
    reward = zero(T)
    num_gem_current = num_gem_init
    gem_reward = one(T)
    gem_pos_init = CartesianIndex{2}[]
    done = false

    env = CollectGemsDirected(world, agent_pos, agent_dir, reward, rng, num_gem_init, num_gem_current, gem_reward, gem_pos_init, done)

    RLBase.reset!(env)

    return env
end

RLBase.state_space(env::CollectGemsDirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = nothing
const COLLECT_GEMS_DIRECTED_LAYERS = SA.SVector(2, 3)
RLBase.state(env::CollectGemsDirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = get_grid(get_world(env), get_agent_pos(env), get_agent_dir(env), get_half_size(env), COLLECT_GEMS_DIRECTED_LAYERS)

RLBase.state_space(env::CollectGemsDirected, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = nothing
RLBase.state(env::CollectGemsDirected, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = (copy(get_grid(env)), get_agent_dir(env))

RLBase.action_space(env::CollectGemsDirected, ::RLBase.DefaultPlayer) = DIRECTED_NAVIGATION_ACTIONS
RLBase.reward(env::CollectGemsDirected, ::RLBase.DefaultPlayer) = get_reward(env)
RLBase.is_terminated(env::CollectGemsDirected) = get_done(env)

function RLBase.reset!(env::CollectGemsDirected{T}) where {T}
    world = get_world(env)
    rng = get_rng(env)
    gem_pos_init = get_gem_pos_init(env)
    num_gem_init = get_num_gem_init(env)

    world[AGENT, get_agent_pos(env)] = false
    map(pos -> world[GEM, pos] = false, gem_pos_init)
    empty!(gem_pos_init)

    for i in 1:num_gem_init
        pos = rand(rng, pos -> !any(@view world[:, pos]), env)
        world[GEM, pos] = true
        push!(gem_pos_init, pos)
    end
    set_num_gem_current!(env, num_gem_init)

    agent_start_pos = rand(rng, pos -> !any(@view world[:, pos]), env)
    set_agent_pos!(env, agent_start_pos)
    world[AGENT, agent_start_pos] = true

    set_agent_dir!(env, rand(rng, DIRECTIONS))

    set_reward!(env, zero(T))
    set_done!(env, false)

    return nothing
end

function (env::CollectGemsDirected{T})(action::AbstractTurnAction) where {T}
    new_dir = turn(action, get_agent_dir(env))
    set_agent_dir!(env, new_dir)
    world = get_world(env)

    set_done!(env, get_num_gem_current(env) <= 0)
    set_reward!(env, zero(T))

    return nothing
end

function (env::CollectGemsDirected{T})(action::AbstractMoveAction) where {T}
    world = get_world(env)

    agent_pos = get_agent_pos(env)
    dest = move(action, get_agent_dir(env), agent_pos)
    if !world[WALL, dest]
        world[AGENT, agent_pos] = false
        set_agent_pos!(env, dest)
        world[AGENT, dest] = true
    end

    set_reward!(env, zero(T))
    agent_pos = get_agent_pos(env)
    if world[GEM, agent_pos]
        world[GEM, agent_pos] = false
        set_num_gem_current!(env, get_num_gem_current(env) - 1)
        set_reward!(env, get_gem_reward(env))
    end

    set_done!(env, get_num_gem_current(env) <= 0)

    return nothing
end

#####
# Undirected
#####

RLBase.state_space(env::CollectGemsUndirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = nothing
const COLLECT_GEMS_UNDIRECTED_LAYERS = SA.SVector(2, 3)
RLBase.state(env::CollectGemsUndirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = get_grid(get_world(env), get_agent_pos(env), get_half_size(env), COLLECT_GEMS_UNDIRECTED_LAYERS)

RLBase.state_space(env::CollectGemsUndirected, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = nothing
RLBase.state(env::CollectGemsUndirected, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = copy(get_grid(env))

RLBase.action_space(env::CollectGemsUndirected, player::RLBase.DefaultPlayer) = UNDIRECTED_NAVIGATION_ACTIONS
RLBase.reward(env::CollectGemsUndirected, ::RLBase.DefaultPlayer) = get_reward(env)
RLBase.is_terminated(env::CollectGemsUndirected) = get_done(env)

function CollectGemsUndirected(; T = Float32, height = 8, width = 8, num_gem_init = floor(Int, sqrt(height * width)), rng = Random.GLOBAL_RNG)
    objects = (AGENT, WALL, GEM)
    world = GridWorldBase(objects, height, width)

    room = Room(CartesianIndex(1, 1), height, width)
    place_room!(world, room)

    agent_pos = CartesianIndex(2, 2)
    world[AGENT, agent_pos] = true

    reward = zero(T)
    num_gem_current = num_gem_init
    gem_reward = one(T)
    gem_pos_init = CartesianIndex{2}[]
    done = false

    env = CollectGemsUndirected(world, agent_pos, reward, rng, num_gem_init, num_gem_current, gem_reward, gem_pos_init, done)

    RLBase.reset!(env)

    return env
end

function RLBase.reset!(env::CollectGemsUndirected{T}) where {T}
    world = get_world(env)
    rng = get_rng(env)
    gem_pos_init = get_gem_pos_init(env)
    num_gem_init = get_num_gem_init(env)

    world[AGENT, get_agent_pos(env)] = false
    map(pos -> world[GEM, pos] = false, gem_pos_init)
    empty!(gem_pos_init)

    for i in 1:num_gem_init
        pos = rand(rng, pos -> !any(@view world[:, pos]), env)
        world[GEM, pos] = true
        push!(gem_pos_init, pos)
    end
    set_num_gem_current!(env, num_gem_init)

    agent_start_pos = rand(rng, pos -> !any(@view world[:, pos]), env)
    set_agent_pos!(env, agent_start_pos)
    world[AGENT, agent_start_pos] = true

    set_reward!(env, zero(T))
    set_done!(env, false)

    return nothing
end

function (env::CollectGemsUndirected{T})(action::AbstractMoveAction) where {T}
    world = get_world(env)

    agent_pos = get_agent_pos(env)
    dest = move(action, agent_pos)
    if !world[WALL, dest]
        world[AGENT, agent_pos] = false
        set_agent_pos!(env, dest)
        world[AGENT, dest] = true
    end

    set_reward!(env, zero(T))
    agent_pos = get_agent_pos(env)
    if world[GEM, agent_pos]
        world[GEM, agent_pos] = false
        set_num_gem_current!(env, get_num_gem_current(env) - 1)
        set_reward!(env, get_gem_reward(env))
    end

    set_done!(env, get_num_gem_current(env) <= 0)

    return nothing
end
