export CollectGems

mutable struct CollectGems <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty,Wall,Gem}}
    agent_pos::CartesianIndex{2}
    agent::Agent
    num_gem_init::Int
    num_gem_current::Int
    gem_reward::Float64
    default_reward::Float64
    r::Float64
end

function CollectGems(;n=8, agent_start_pos=CartesianIndex(2,2), agent_start_dir=RIGHT)
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
        gem_pos = CartesianIndex(rand(2:n-1), rand(2:n-1))
        if (gem_pos == agent_start_pos) || (w[GEM, gem_pos] == true)
            continue
        else
            w[GEM, gem_pos] = true
            w[EMPTY, gem_pos] = false
            gem_placed = gem_placed + 1
        end
    end

    gem_reward = 1.0
    default_reward = 0.0
    r = default_reward

    CollectGems(w, agent_start_pos, Agent(dir=agent_start_dir), num_gem_init, num_gem_current, gem_reward, default_reward, r)
end

function (w::CollectGems)(::MoveForward)
    dir = get_dir(w.agent)
    dest = dir(w.agent_pos)
    w.r = w.default_reward
    if !w.world[WALL, dest]
        w.agent_pos = dest
        if w.world[GEM, dest]
            w.world[GEM, dest] = false
            w.world[EMPTY, dest] = true
            w.num_gem_current = w.num_gem_current - 1
            w.r = w.gem_reward
        end
    end
    w
end

function (w::CollectGems)(action::Union{TurnRight, TurnLeft})
    w.r = w.default_reward
    agent = get_agent(w)
    set_dir!(agent, action(get_dir(agent)))
    w
end

function get_terminal(w::CollectGems)
    return w.num_gem_current <= 0
end

get_reward(w::CollectGems) = w.r
