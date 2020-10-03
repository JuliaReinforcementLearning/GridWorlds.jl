export EmptyGridWorld

mutable struct EmptyGridWorld <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty,Wall,Goal}}
    agent_pos::CartesianIndex{2}
    agent::Agent
end

function EmptyGridWorld(;n=8, agent_start_pos=CartesianIndex(2,2), agent_start_dir=RIGHT)
    objects = (EMPTY, WALL, GOAL)
    w = GridWorldBase(objects, n, n)
    w[EMPTY, 2:n-1, 2:n-1] .= true
    w[WALL, [1,n], 1:n] .= true
    w[WALL, 1:n, [1,n]] .= true
    w[GOAL, n-1, n-1] = true
    w[EMPTY, n-1, n-1] = false
    EmptyGridWorld(w, agent_start_pos, Agent(dir=agent_start_dir))
end

function (w::EmptyGridWorld)(::MoveForward)
    dir = get_dir(w.agent)
    dest = dir(w.agent_pos)
    if !w.world[WALL, dest]
        w.agent_pos = dest
    end
    w
end
