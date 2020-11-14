export GoToDoor

using Random

mutable struct GoToDoor{W<:GridWorldBase, R} <: AbstractGridWorld
    world::W
    agent_pos::CartesianIndex{2}
    agent::Agent
    target::Door
    target_reward::Float64
    penalty::Float64
    rng::R
end

function GoToDoor(;n=8, agent_start_pos=CartesianIndex(2,2), rng=Random.GLOBAL_RNG)
    doors = [Door(c) for c in COLORS[1:4]]
    objects = (EMPTY, WALL, doors...)

    world = GridWorldBase(objects, n, n)

    world[EMPTY, 2:n-1, 2:n-1] .= true

    target_reward = 1.0
    penalty = -1.0

    env = GoToDoor(world, agent_start_pos, Agent(dir=RIGHT), doors[begin], target_reward, penalty, rng)

    reset!(env)

    return env
end

function (w::GoToDoor)(::MoveForward)
    dir = get_dir(w.agent)
    dest = dir(w.agent_pos)
    if dest ∈ CartesianIndices((size(w.world, 2), size(w.world, 3))) && !w.world[WALL,dest]
        w.agent_pos = dest
    end
    w
end

function RLBase.reset!(w::GoToDoor)
    n = size(w.world)[end]

    w.world[WALL, [1,n], 1:n] .= true
    w.world[WALL, 1:n, [1,n]] .= true

    doors = w.world.objects[end-3:end]
    for door in doors
        w.world[door, :, :] .= false
    end

    w.target = rand(w.rng, doors)

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
