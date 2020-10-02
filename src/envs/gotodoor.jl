export GoToDoor

using Random

mutable struct GoToDoor <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty,Wall,Door,typeof(COLORS).parameters...}}
    agent_pos::CartesianIndex{2}
    agent_dir::LRUD
end

function GoToDoor(;n=8, agent_start_pos=CartesianIndex(2,2), rng=Random.GLOBAL_RNG)
    objects = (EMPTY, WALL, DOOR, COLORS...)
    world = GridWorldBase(objects, n, n)
    world[WALL, [1,n], 1:n] .= true
    world[WALL, 1:n, [1,n]] .= true

    door_pos = [(rand(rng, 2:n-1),1), (rand(rng, 2:n-1),n), (1,rand(rng, 2:n-1)), (n,rand(rng, 2:n-1))]
    door_colors = COLORS[randperm(rng, length(COLORS))][1:length(door_pos)]
    for (c, p) in zip(door_colors, door_pos)
        world[DOOR, p...] = true
        world[WALL, p...] = false
        world[c, p...] = true
    end
    GoToDoor(world, agent_start_pos, RIGHT)
end

function (w::GoToDoor)(a::Union{TurnRight, TurnLeft})
    w.agent_dir = a(w.agent_dir)
    w
end

function (w::GoToDoor)(::MoveForward)
    dest = w.agent_dir(w.agent_pos)
    if !w.world[WALL,dest]
        w.agent_pos = dest
    end
    w
end