export EmptyGridWorld

mutable struct EmptyGridWorld <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty,Wall,Goal}}
    agent_pos::CartesianIndex{2}
    agent_direction::LRUD
end

function EmptyGridWorld(;n=8, agent_start_pos=CartesianIndex(2,2), agent_view_size=7)
    objects = (EMPTY, WALL, GOAL)
    world = GridWorldBase(n, n, objects)
    world[2:n-1, 2:n-1, EMPTY] .= true
    world[[1,n], 1:n, WALL] .= true
    world[1:n, [1,n], WALL] .= true
    world[n-1, n-1, GOAL] = true
    EmptyGridWorld(world, agent_start_pos, RIGHT)
end

(w::EmptyGridWorld)(a::Union{TurnClockwise, TurnCounterclockwise}) = w.agent_direction = a(w.agent_direction)

function (w::EmptyGridWorld)(::MoveForward)
    dest = w.agent_direction(w.agent_pos)
    if !w.world[dest, WALL]
        w.agent_pos = dest
    end
end

# TODO:
# update w.agent_view
# https://github.com/maximecb/gym-minigrid/blob/master/gym_minigrid/minigrid.py#L1165
function get_agent_view(w::EmptyGridWorld)
end

function get_agent_view!(buf::BitArray{3}, w)
end
