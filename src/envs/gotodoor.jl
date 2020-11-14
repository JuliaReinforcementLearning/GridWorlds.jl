export GoToDoor

using Random

mutable struct GoToDoor{W<:GridWorldBase, R} <: AbstractGridWorld
    world::W
    agent_pos::CartesianIndex{2}
    agent::Agent
    target::Door
    target_reward::Float64
    penalty::Float64
    reward::Float64
    rng::R
end

function GoToDoor(;n=8, agent_start_pos=CartesianIndex(2,2), rng=Random.GLOBAL_RNG)
    doors = [Door(c) for c in COLORS[1:4]]
    objects = (EMPTY, WALL, doors...)

    world = GridWorldBase(objects, n, n)

    world[EMPTY, 2:n-1, 2:n-1] .= true

    target_reward = 1.0
    penalty = -1.0
    reward = 0.0

    env = GoToDoor(world, agent_start_pos, Agent(dir=RIGHT), doors[begin], target_reward, penalty, reward, rng)

    reset!(env)

    return env
end

function (w::GoToDoor)(::MoveForward)
    w.reward = 0.0
    dir = get_dir(w.agent)
    dest = dir(w.agent_pos)
    if dest ∈ CartesianIndices((size(w.world, 2), size(w.world, 3))) && !w.world[WALL,dest]
        w.agent_pos = dest
        if w.world[w.target, w.agent_pos]
            w.reward = w.target_reward
        elseif any([w.world[x, w.agent_pos] for x in w.world.objects[end-3:end] if x != w.target])
            w.reward = w.penalty
        end
    end
    w
end

function (w::GoToDoor)(action::Union{TurnRight, TurnLeft})
    w.reward = 0.0
    agent = get_agent(w)
    set_dir!(agent, action(get_dir(agent)))
    w
end

RLBase.get_reward(w::GoToDoor) = w.reward

function RLBase.reset!(w::GoToDoor)
    n = size(w.world)[end]

    w.world[WALL, [1,n], 1:n] .= true
    w.world[WALL, 1:n, [1,n]] .= true

    doors = w.world.objects[end-3:end]
    for door in doors
        w.world[door, :, :] .= false
    end

    w.target = rand(w.rng, doors)
    w.reward = 0.0

    door_pos = [CartesianIndex(rand(w.rng, 2:n-1),1),
                CartesianIndex(rand(w.rng, 2:n-1),n),
                CartesianIndex(1,rand(w.rng, 2:n-1)),
                CartesianIndex(n,rand(w.rng, 2:n-1))]

    rp = randperm(w.rng, length(door_pos))

    for (door, pos) in zip(doors, door_pos[rp])
        w.world[door, pos] = true
        w.world[WALL, pos] = false
    end

    w
end
