export CollectGems

mutable struct CollectGems <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty,Wall,Gem}}
    agent_pos::CartesianIndex{2}
    agent::Agent
    num_gem_init::Int
    num_gem_current::Int
end

function CollectGems(;n=8, agent_start_pos=CartesianIndex(2,2), agent_start_dir=RIGHT, rng=Random.GLOBAL_RNG)
    objects = (EMPTY, WALL, GEM)
    w = GridWorldBase(objects, n, n)

    w[EMPTY, 2:n-1, 2:n-1] .= true
    w[WALL, [1,n], 1:n] .= true
    w[WALL, 1:n, [1,n]] .= true

    w[GEM, 1:n, 1:n] .= false
    num_gem_init = n - 1
    num_gem_current = num_gem_init

    gem_placed = 0
    while gem_placed < num_gem_init
        gem_pos = CartesianIndex(rand(rng, 2:n-1), rand(rng, 2:n-1))
        if (gem_pos == agent_start_pos) || (w[GEM, gem_pos] == true)
            continue
        else
            w[GEM, gem_pos] = true
            w[EMPTY, gem_pos] = false
            gem_placed = gem_placed + 1
        end
    end

    CollectGems(w, agent_start_pos, Agent(dir=agent_start_dir), num_gem_init, num_gem_current)
end

function (w::CollectGems)(::MoveForward)
    dir = get_dir(w.agent)
    dest = dir(w.agent_pos)
    if !w.world[WALL, dest]
        w.agent_pos = dest
        if w.world[GEM, dest]
            w.world[GEM, dest] = false
            w.world[EMPTY, dest] = true
            w.num_gem_current = w.num_gem_current - 1
        end
    end
    w
end
