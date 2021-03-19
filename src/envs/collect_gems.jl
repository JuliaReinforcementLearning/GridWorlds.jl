mutable struct CollectGemsDirected{T, R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty, Wall, Gem}}
    agent_pos::CartesianIndex{2}
    agent_dir::AbstractDirection
    reward::T
    rng::R
    num_gem_init::Int
    num_gem_current::Int
    gem_reward::T
    gem_pos::Vector{CartesianIndex{2}}
    done::Bool
end

@generate_getters(CollectGemsDirected)
@generate_setters(CollectGemsDirected)

mutable struct CollectGemsUndirected{T, R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty, Wall, Gem}}
    agent_pos::CartesianIndex{2}
    reward::T
    rng::R
    num_gem_init::Int
    num_gem_current::Int
    gem_reward::T
    gem_pos::Vector{CartesianIndex{2}}
    done::Bool
end

@generate_getters(CollectGemsUndirected)
@generate_setters(CollectGemsUndirected)

#####
# Directed
#####

function CollectGemsDirected(; T = Float32, height = 8, width = 8, num_gem_init = floor(Int, sqrt(height * width)), rng = Random.GLOBAL_RNG)
    objects = (EMPTY, WALL, GEM)
    world = GridWorldBase(objects, height, width)
    room = Room(CartesianIndex(1, 1), height, width)
    place_room!(world, room)

    agent_pos = CartesianIndex(2, 2)
    agent_dir = RIGHT
    reward = zero(T)
    num_gem_current = num_gem_init
    gem_reward = one(T)
    gem_pos = CartesianIndex{2}[]
    done = false

    env = CollectGemsDirected(world, agent_pos, agent_dir, reward, rng, num_gem_init, num_gem_current, gem_reward, gem_pos, done)

    RLBase.reset!(env)

    return env
end

function (env::CollectGemsDirected{T})(action::AbstractMoveAction) where {T}
    world = get_world(env)

    dest = move(action, get_agent_dir(env), get_agent_pos(env))
    if !world[WALL, dest]
        set_agent_pos!(env, dest)
    end

    set_done!(env, env.num_gem_current <= 0)

    set_reward!(env, zero(T))
    agent_pos = get_agent_pos(env)
    if world[GEM, agent_pos]
        world[GEM, agent_pos] = false
        world[EMPTY, agent_pos] = true
        env.num_gem_current = env.num_gem_current - 1
        set_reward!(env, env.gem_reward)
    end

    return env
end

function (env::CollectGemsDirected{T})(action::AbstractTurnAction) where {T}
    dir = get_agent_dir(env)
    new_dir = turn(action, dir)
    set_agent_dir!(env, new_dir)
    world = get_world(env)

    set_done!(env, env.num_gem_current <= 0)
    set_reward!(env, zero(T))

    return env
end

RLBase.state_space(env::CollectGemsDirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = nothing
RLBase.state(env::CollectGemsDirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = get_agent_view(env)
RLBase.action_space(env::CollectGemsDirected, ::RLBase.DefaultPlayer) = DIRECTED_NAVIGATION_ACTIONS
RLBase.reward(env::CollectGemsDirected, ::RLBase.DefaultPlayer) = get_reward(env)
RLBase.is_terminated(env::CollectGemsDirected) = get_done(env)

function RLBase.reset!(env::CollectGemsDirected{T}) where {T}
    world = get_world(env)
    rng = get_rng(env)

    for pos in env.gem_pos
        world[GEM, pos] = false
        world[EMPTY, pos] = true
    end

    env.gem_pos = CartesianIndex{2}[]
    for i in 1:env.num_gem_init
        pos = rand(rng, pos -> world[EMPTY, pos], env)
        world[GEM, pos] = true
        world[EMPTY, pos] = false
        push!(env.gem_pos, pos)
    end
    env.num_gem_current = env.num_gem_init

    agent_start_pos = rand(rng, pos -> world[EMPTY, pos], env)
    agent_start_dir = rand(rng, DIRECTIONS)

    set_agent_pos!(env, agent_start_pos)
    set_agent_dir!(env, agent_start_dir)

    set_reward!(env, zero(T))
    set_done!(env, false)

    return env
end

#####
# Undirected
#####

RLBase.state_space(env::CollectGemsUndirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = nothing
RLBase.state(env::CollectGemsUndirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = get_grid(get_world(env), get_agent_view_size(env), get_agent_pos(env))
RLBase.action_space(env::CollectGemsUndirected, player::RLBase.DefaultPlayer) = UNDIRECTED_NAVIGATION_ACTIONS
RLBase.reward(env::CollectGemsUndirected, ::RLBase.DefaultPlayer) = get_reward(env)
RLBase.is_terminated(env::CollectGemsUndirected) = get_done(env)

function CollectGemsUndirected(; T = Float32, height = 8, width = 8, num_gem_init = floor(Int, sqrt(height * width)), rng = Random.GLOBAL_RNG)
    objects = (EMPTY, WALL, GEM)
    world = GridWorldBase(objects, height, width)
    room = Room(CartesianIndex(1, 1), height, width)
    place_room!(world, room)

    agent_pos = CartesianIndex(2, 2)
    reward = zero(T)
    num_gem_current = num_gem_init
    gem_reward = one(T)
    gem_pos = CartesianIndex{2}[]
    done = false

    env = CollectGemsUndirected(world, agent_pos, reward, rng, num_gem_init, num_gem_current, gem_reward, gem_pos, done)

    RLBase.reset!(env)

    return env
end

function (env::CollectGemsUndirected{T})(action::AbstractMoveAction) where {T}
    world = get_world(env)

    dest = move(action, get_agent_pos(env))
    if !world[WALL, dest]
        set_agent_pos!(env, dest)
    end

    set_done!(env, env.num_gem_current <= 0)

    set_reward!(env, zero(T))
    agent_pos = get_agent_pos(env)
    if world[GEM, agent_pos]
        world[GEM, agent_pos] = false
        world[EMPTY, agent_pos] = true
        env.num_gem_current = env.num_gem_current - 1
        set_reward!(env, env.gem_reward)
    end

    return env
end

function RLBase.reset!(env::CollectGemsUndirected{T}) where {T}
    world = get_world(env)
    rng = get_rng(env)

    for pos in env.gem_pos
        world[GEM, pos] = false
        world[EMPTY, pos] = true
    end

    env.gem_pos = CartesianIndex{2}[]
    for i in 1:env.num_gem_init
        pos = rand(rng, pos -> world[EMPTY, pos], env)
        world[GEM, pos] = true
        world[EMPTY, pos] = false
        push!(env.gem_pos, pos)
    end
    env.num_gem_current = env.num_gem_init

    agent_start_pos = rand(rng, pos -> world[EMPTY, pos], env)
    set_agent_pos!(env, agent_start_pos)

    set_reward!(env, zero(T))
    set_done!(env, false)

    return env
end
