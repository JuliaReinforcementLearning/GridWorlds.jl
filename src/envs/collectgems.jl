export CollectGems

mutable struct CollectGems <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty,Wall,Gem}}
    agent_pos::CartesianIndex{2}
    agent::Agent
    num_gem_init::Int
    num_gem_current::Int
    gem_reward::Float64
    reward::Float64
    rng
end

function CollectGems(;n=8, agent_start_pos=CartesianIndex(2,2), agent_start_dir=RIGHT, rng=Random.GLOBAL_RNG)
    objects = (EMPTY, WALL, GEM)
    w = GridWorldBase(objects, n, n)

    w[WALL, [1,n], 1:n] .= true
    w[WALL, 1:n, [1,n]] .= true

    num_gem_init = n - 1
    num_gem_current = num_gem_init

    gem_reward = 1.0
    reward = 0.0

    env = CollectGems(w, agent_start_pos, Agent(dir=agent_start_dir), num_gem_init, num_gem_current, gem_reward, reward, rng)

    reset!(env)

    return env

end

function (w::CollectGems)(::MoveForward)
    dir = get_dir(w.agent)
    dest = dir(w.agent_pos)
    w.reward = 0.0
    if !w.world[WALL, dest]
        w.agent_pos = dest
        if w.world[GEM, dest]
            w.world[GEM, dest] = false
            w.world[EMPTY, dest] = true
            w.num_gem_current = w.num_gem_current - 1
            w.reward = w.gem_reward
        end
    end
    w
end

function (w::CollectGems)(action::Union{TurnRight, TurnLeft})
    w.reward = 0.0
    agent = get_agent(w)
    set_dir!(agent, action(get_dir(agent)))
    w
end

RLBase.get_terminal(w::CollectGems) = w.num_gem_current <= 0

RLBase.get_reward(w::CollectGems) = w.reward

function RLBase.reset!(w::CollectGems)

    n = size(w.world)[end]
    w.world[EMPTY, 2:n-1, 2:n-1] .= true
    w.world[GEM, 1:n, 1:n] .= false
    w.num_gem_current = w.num_gem_init

    w.reward = 0.0
    w.agent_pos = CartesianIndex(2, 2)
    w.agent.dir = RIGHT

    gem_placed = 0
    while gem_placed < w.num_gem_init
        gem_pos = CartesianIndex(rand(w.rng, 2:n-1), rand(w.rng, 2:n-1))
        if (gem_pos == w.agent_pos) || (w.world[GEM, gem_pos] == true)
            continue
        else
            w.world[GEM, gem_pos] = true
            w.world[EMPTY, gem_pos] = false
            gem_placed = gem_placed + 1
        end
    end

    return w
end
