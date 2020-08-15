export FourRooms

mutable struct FourRooms <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty,Wall,Goal}}
    agent_pos::CartesianIndex{2}
    agent_direction::LRUD
end

function FourRooms(;n=19, agent_start_pos=CartesianIndex(2,2))
    objects = (EMPTY, WALL, GOAL)
    world = GridWorldBase(n,n,objects)
    world[EMPTY, 2:n-1, 2:n-1] .= true
    world[WALL, [1,n], 1:n] .= true
    world[WALL, 1:n, [1,n]] .= true
    world[WALL, ceil(Int,n/2), vcat(2:ceil(Int,n/4)-1,ceil(Int,n/4)+1:ceil(Int,n/2)-1,ceil(Int,n/2):ceil(Int,3*n/4)-1,ceil(Int,3*n/4)+1:n)] .= true
    world[WALL, vcat(2:ceil(Int,n/4)-1,ceil(Int,n/4)+1:ceil(Int,n/2)-1,ceil(Int,n/2):ceil(Int,3*n/4)-1,ceil(Int,3*n/4)+1:n), ceil(Int,n/2)] .= true
    world[GOAL, n-1, n-1] = true
    FourRooms(world,agent_start_pos,RIGHT)
end

(w::FourRooms)(a::Union{TurnClockwise, TurnCounterclockwise}) = w.agent_direction = a(w.agent_direction)

function (w::FourRooms)(::MoveForward)
    dest = w.agent_direction(w.agent_pos)
    if !w.world[WALL, dest]
        w.agent_pos = dest
    end
end

function get_agent_view(w::FourRooms, agent_view_size=7)
end

function get_agent_view!(buf::BitArray{3}, w)
end
