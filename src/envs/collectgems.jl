export CollectGems

mutable struct CollectGems{R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty,Wall,Gem}}
    agent_pos::CartesianIndex{2}
    agent::Agent
    num_gem_init::Int
    num_gem_current::Int
    gem_reward::Float64
    reward::Float64
    rng::R
end

function CollectGems(; n = 8, agent_start_pos = CartesianIndex(2,2), agent_start_dir = RIGHT, rng = Random.GLOBAL_RNG)
    objects = (EMPTY, WALL, GEM)
    world = GridWorldBase(objects, n, n)

    world[WALL, [1,n], 1:n] .= true
    world[WALL, 1:n, [1,n]] .= true

    num_gem_init = n - 1
    num_gem_current = num_gem_init

    gem_reward = 1.0
    reward = 0.0

    env = CollectGems(world, agent_start_pos, Agent(dir = agent_start_dir), num_gem_init, num_gem_current, gem_reward, reward, rng)

    reset!(env, agent_start_pos = agent_start_pos, agent_start_dir = agent_start_dir)

    return env
end

function (env::CollectGems)(::MoveForward)
    world = get_world(env)

    env.reward = 0.0

    dir = get_agent_dir(env)
    dest = dir(get_agent_pos(env))

    if !world[WALL, dest]
        env.agent_pos = dest
        if world[GEM, dest]
            world[GEM, dest] = false
            world[EMPTY, dest] = true
            env.num_gem_current = env.num_gem_current - 1
            env.reward = env.gem_reward
        end
    end

    return env
end

RLBase.get_terminal(env::CollectGems) = env.num_gem_current <= 0

function RLBase.reset!(env::CollectGems; agent_start_pos = CartesianIndex(2, 2), agent_start_dir = RIGHT)
    world = get_world(env)

    n = size(world)[end]
    world[EMPTY, 2:n-1, 2:n-1] .= true
    world[GEM, 1:n, 1:n] .= false

    env.num_gem_current = env.num_gem_init

    env.reward = 0.0

    env.agent_pos = agent_start_pos

    set_dir!(get_agent(env), agent_start_dir)

    gem_placed = 0
    while gem_placed < env.num_gem_init
        gem_pos = CartesianIndex(rand(env.rng, 2:n-1), rand(env.rng, 2:n-1))
        if (gem_pos == get_agent_pos(env)) || (world[GEM, gem_pos] == true)
            continue
        else
            world[GEM, gem_pos] = true
            world[EMPTY, gem_pos] = false
            gem_placed = gem_placed + 1
        end
    end

    return env
end
