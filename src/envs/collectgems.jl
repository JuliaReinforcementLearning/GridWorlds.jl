export CollectGems

mutable struct CollectGems{R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty,Wall,Gem}}
    agent::Agent
    reward::Float64
    rng::R
    num_gem_init::Int
    num_gem_current::Int
    gem_reward::Float64
end

function CollectGems(; n = 8, agent_start_pos = CartesianIndex(2,2), agent_start_dir = RIGHT, rng = Random.GLOBAL_RNG)
    objects = (EMPTY, WALL, GEM)
    world = GridWorldBase(objects, n, n)
    agent = Agent(dir = agent_start_dir, pos = agent_start_pos)
    reward = 0.0
    num_gem_init = n - 1
    num_gem_current = num_gem_init
    gem_reward = 1.0

    env = CollectGems(world, agent, reward, rng, num_gem_init, num_gem_current, gem_reward)

    reset!(env, agent_start_pos = agent_start_pos, agent_start_dir = agent_start_dir)

    return env
end

function (env::CollectGems)(::MoveForward)
    world = get_world(env)

    dir = get_agent_dir(env)
    dest = dir(get_agent_pos(env))
    if !world[WALL, dest]
        set_agent_pos!(env, dest)
    end

    set_reward!(env, 0.0)
    agent_pos = get_agent_pos(env)
    if world[GEM, agent_pos]
        world[GEM, agent_pos] = false
        world[EMPTY, agent_pos] = true
        env.num_gem_current = env.num_gem_current - 1
        set_reward!(env, env.gem_reward)
    end

    return env
end

RLBase.get_terminal(env::CollectGems) = env.num_gem_current <= 0

function RLBase.reset!(env::CollectGems; agent_start_pos = CartesianIndex(2, 2), agent_start_dir = RIGHT)
    world = get_world(env)
    n = get_width(env)
    rng = get_rng(env)

    world[:, :, :] .= false
    world[WALL, [1,n], 1:n] .= true
    world[WALL, 1:n, [1,n]] .= true
    world[EMPTY, 2:n-1, 2:n-1] .= true

    env.num_gem_current = env.num_gem_init

    gem_placed = 0
    while gem_placed < env.num_gem_init
        gem_pos = CartesianIndex(rand(rng, 2:n-1), rand(rng, 2:n-1))
        if (gem_pos == get_agent_pos(env)) || (world[GEM, gem_pos] == true)
            continue
        else
            world[GEM, gem_pos] = true
            world[EMPTY, gem_pos] = false
            gem_placed = gem_placed + 1
        end
    end

    set_agent_pos!(env, agent_start_pos)
    set_agent_dir!(env, agent_start_dir)

    set_reward!(env, 0.0)

    return env
end
