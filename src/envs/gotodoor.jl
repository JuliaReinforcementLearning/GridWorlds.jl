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
    target = rand(rng, doors)
    objects = (EMPTY, WALL, doors...)

    world = GridWorldBase(objects, n, n)
    world[EMPTY, :, :] .= true
    world[WALL, [1,n], 1:n] .= true
    world[EMPTY, [1,n], 1:n] .= false
    world[WALL, 1:n, [1,n]] .= true
    world[EMPTY, 1:n, [1,n]] .= false

    target_reward = 1.0
    penalty = -1.0

    door_pos = [CartesianIndex(rand(rng, 2:n-1),1), CartesianIndex(rand(rng, 2:n-1),n), CartesianIndex(1,rand(rng, 2:n-1)), CartesianIndex(n,rand(rng, 2:n-1))]
    rp = randperm(rng, length(door_pos))
    for (door, pos) in zip(doors, door_pos[rp])
        world[door, pos] = true
        world[WALL, pos] = false
    end

    GoToDoor(world, agent_start_pos, Agent(dir=RIGHT), target, target_reward, penalty, rng)
end

function (w::GoToDoor)(::MoveForward)
    dir = get_dir(w.agent)
    dest = dir(w.agent_pos)
    if dest ∈ CartesianIndices((size(w.world, 2), size(w.world, 3))) && !w.world[WALL,dest]
        w.agent_pos = dest
    end
    w
end
