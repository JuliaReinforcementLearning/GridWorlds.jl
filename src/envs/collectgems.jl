export CollectGems

mutable struct CollectGems{R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty, Wall, Gem}}
    agent::Agent
    reward::Float64
    rng::R
    num_gem_init::Int
    num_gem_current::Int
    gem_reward::Float64
    gem_pos::Vector{CartesianIndex{2}}
end

function CollectGems(; height = 8, width = 8, num_gem_init = floor(Int, sqrt(height * width)), rng = Random.GLOBAL_RNG)
    objects = (EMPTY, WALL, GEM)
    world = GridWorldBase(objects, height, width)
    room = Room(CartesianIndex(1, 1), height, width)
    place_room!(world, room)

    agent = Agent()
    reward = 0.0
    num_gem_current = num_gem_init
    gem_reward = 1.0
    gem_pos = CartesianIndex{2}[]

    env = CollectGems(world, agent, reward, rng, num_gem_init, num_gem_current, gem_reward, gem_pos)

    reset!(env)

    return env
end

RLBase.is_terminated(env::CollectGems) = env.num_gem_current <= 0

function (env::CollectGems)(::MoveForward)
    dir = get_agent_dir(env)
    dest = dir(get_agent_pos(env))
    if !env[WALL, dest]
        set_agent_pos!(env, dest)
    end

    set_reward!(env, 0.0)
    agent_pos = get_agent_pos(env)
    if env[GEM, agent_pos]
        env[GEM, agent_pos] = false
        env[EMPTY, agent_pos] = true
        env.num_gem_current = env.num_gem_current - 1
        set_reward!(env, env.gem_reward)
    end

    return env
end

function RLBase.reset!(env::CollectGems)
    rng = get_rng(env)

    for pos in env.gem_pos
        env[GEM, pos] = false
        env[EMPTY, pos] = true
    end

    env.gem_pos = CartesianIndex{2}[]
    for i in 1:env.num_gem_init
        pos = rand(rng, pos -> env[EMPTY, pos], env)
        env[GEM, pos] = true
        env[EMPTY, pos] = false
        push!(env.gem_pos, pos)
    end
    env.num_gem_current = env.num_gem_init

    agent_start_pos = rand(rng, pos -> env[EMPTY, pos], env)
    agent_start_dir = rand(rng, DIRECTIONS)

    set_agent_pos!(env, agent_start_pos)
    set_agent_dir!(env, agent_start_dir)

    set_reward!(env, 0.0)

    return env
end
