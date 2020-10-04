export GoToDoor

using Random

mutable struct GoToDoor{W<:GridWorldBase} <: AbstractGridWorld
    world::W
    agent_pos::CartesianIndex{2}
    agent::Agent
end

function GoToDoor(;n=8, agent_start_pos=CartesianIndex(2,2), rng=Random.GLOBAL_RNG)
    objects = (EMPTY, WALL, (Door(c) for c in COLORS)...)
    world = GridWorldBase(objects, n, n)
    world[EMPTY, :, :] .= true
    world[WALL, [1,n], 1:n] .= true
    world[EMPTY, [1,n], 1:n] .= false
    world[WALL, 1:n, [1,n]] .= true
    world[EMPTY, 1:n, [1,n]] .= false

    door_pos = [(rand(rng, 2:n-1),1), (rand(rng, 2:n-1),n), (1,rand(rng, 2:n-1)), (n,rand(rng, 2:n-1))]
    door_colors = COLORS[randperm(rng, length(COLORS))][1:length(door_pos)]
    for (c, p) in zip(door_colors, door_pos)
        world[Door(c), p...] = true
        world[WALL, p...] = false
    end
    GoToDoor(world, agent_start_pos, Agent(dir=RIGHT))
end

function (w::GoToDoor)(::MoveForward)
    dir = get_dir(w.agent)
    dest = dir(w.agent_pos)
    if dest ∈ CartesianIndices((size(w.world, 2), size(w.world, 3))) && !w.world[WALL,dest]
        w.agent_pos = dest
    end
    w
end