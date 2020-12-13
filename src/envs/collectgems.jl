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

function CollectGems(; n = 8, rng = Random.GLOBAL_RNG)
    objects = (EMPTY, WALL, GEM)
    world = GridWorldBase(objects, n, n)
    room = Room(CartesianIndex(1, 1), n, n)
    place_room!(world, room)

    agent = Agent(pos = CartesianIndex(2, 2), dir = RIGHT)
    reward = 0.0
    num_gem_init = n
    num_gem_current = num_gem_init
    gem_reward = 1.0
    gem_pos = CartesianIndex{2}[]

    env = CollectGems(world, agent, reward, rng, num_gem_init, num_gem_current, gem_reward, gem_pos)

    reset!(env)

    return env
end

RLBase.get_terminal(env::CollectGems) = env.num_gem_current <= 0

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

function RLBase.reset!(env::CollectGems)
    world = get_world(env)
    n = get_width(env)
    rng = get_rng(env)

    for pos in env.gem_pos
        world[GEM, pos] = false
        world[EMPTY, pos] = true
    end

    env.gem_pos = CartesianIndex{2}[]
    for i in 1:env.num_gem_init
        pos = rand(rng, pos -> world[EMPTY, pos], world)
        world[GEM, pos] = true
        world[EMPTY, pos] = false
        push!(env.gem_pos, pos)
    end
    env.num_gem_current = env.num_gem_init

    agent_start_pos = rand(rng, pos -> world[EMPTY, pos], world)
    agent_start_dir = rand(rng, DIRECTIONS)

    set_agent_pos!(env, agent_start_pos)
    set_agent_dir!(env, agent_start_dir)

    set_reward!(env, 0.0)

    return env
end
