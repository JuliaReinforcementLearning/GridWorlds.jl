export EmptyGridWorld

mutable struct EmptyGridWorld <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty,Wall,Goal}}
    agent_pos::CartesianIndex{2}
    agent_dir::LRUD
    agent_view::BitArray{3}
end

function EmptyGridWorld(;n=8, agent_view_size=7, agent_start_pos=CartesianIndex(2,2), agent_start_dir=RIGHT)
    objects = (EMPTY, WALL, GOAL)
    w = GridWorldBase(objects, n, n)
    w[EMPTY, 2:n-1, 2:n-1] .= true
    w[WALL, [1,n], 1:n] .= true
    w[WALL, 1:n, [1,n]] .= true
    w[GOAL, n-1, n-1] = true
    w[EMPTY, n-1, n-1] = false
    v = BitArray{3}(undef, length(objects), agent_view_size, agent_view_size)
    fill!(v, false)
    get_agent_view!(v, w, agent_start_pos, agent_start_dir)
    EmptyGridWorld(w, agent_start_pos, agent_start_dir, v)
end

function (w::EmptyGridWorld)(a::Union{TurnClockwise, TurnCounterclockwise})
    w.agent_dir = a(w.agent_dir)
    get_agent_view!(w.agent_view, w.world, w.agent_pos, w.agent_dir)
end

function (w::EmptyGridWorld)(::MoveForward)
    dest = w.agent_dir(w.agent_pos)
    if !w.world[WALL, dest]
        w.agent_pos = dest
    end
    get_agent_view!(w.agent_view, w.world, w.agent_pos, w.agent_dir)
end
