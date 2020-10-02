export FourRooms

mutable struct FourRooms <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty,Wall,Goal}}
    agent_pos::CartesianIndex{2}
    agent_dir::LRUD
end

function FourRooms(;n=19, agent_start_pos=CartesianIndex(2,2))
    objects = (EMPTY, WALL, GOAL)
    world = GridWorldBase(objects, n,n)
    world[EMPTY, 2:n-1, 2:n-1] .= true
    world[WALL, [1,n], 1:n] .= true
    world[WALL, 1:n, [1,n]] .= true
    world[WALL, ceil(Int,n/2), vcat(2:ceil(Int,n/4)-1,ceil(Int,n/4)+1:ceil(Int,n/2)-1,ceil(Int,n/2):ceil(Int,3*n/4)-1,ceil(Int,3*n/4)+1:n)] .= true
    world[EMPTY, ceil(Int,n/2), vcat(2:ceil(Int,n/4)-1,ceil(Int,n/4)+1:ceil(Int,n/2)-1,ceil(Int,n/2):ceil(Int,3*n/4)-1,ceil(Int,3*n/4)+1:n)] .= false
    world[WALL, vcat(2:ceil(Int,n/4)-1,ceil(Int,n/4)+1:ceil(Int,n/2)-1,ceil(Int,n/2):ceil(Int,3*n/4)-1,ceil(Int,3*n/4)+1:n), ceil(Int,n/2)] .= true
    world[EMPTY, vcat(2:ceil(Int,n/4)-1,ceil(Int,n/4)+1:ceil(Int,n/2)-1,ceil(Int,n/2):ceil(Int,3*n/4)-1,ceil(Int,3*n/4)+1:n), ceil(Int,n/2)] .= false
    world[GOAL, n-1, n-1] = true
    world[EMPTY, n-1, n-1] = false
    FourRooms(world,agent_start_pos,RIGHT)
end

function (w::FourRooms)(a::Union{TurnRight, TurnLeft})
    w.agent_dir = a(w.agent_dir)
    w
end

function (w::FourRooms)(::MoveForward)
    dest = w.agent_dir(w.agent_pos)
    if !w.world[WALL, dest]
        w.agent_pos = dest
    end
    w
end
