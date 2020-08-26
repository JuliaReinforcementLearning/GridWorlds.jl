export GoToDoor

mutable struct GoToDoor <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty,Wall,Door,typeCOLORS...}}
    agent_pos::CartesianIndex{2}
    agent_direction::LRUD
end

function GoToDoor(;n=8, agent_start_pos=CartesianIndex(2,2), agent_view_size=7)
    objects = (EMPTY, WALL, DOOR, COLORS...)
    world = GridWorldBase(n, n, objects)
    world[[1,n], 1:n, WALL] .= true
    world[1:n, [1,n], WALL] .= true

    door_pos = [(rand(2:n-1),1), (rand(2:n-1),n), (1,rand(2:n-1)), (n,rand(2:n-1))]
    door_colors = []
    for (x,y) in door_pos
        color = rand(COLORS)
        while color in door_colors
            color = rand(COLORS)
        end
        world[x,y,DOOR] = true
        world[x,y,WALL] = false
        world[x,y,color] = true
        push!(door_colors, color)
    end
    GoToDoor(world, agent_start_pos, RIGHT)
end

(w::GoToDoor)(a::Union{TurnClockwise, TurnCounterclockwise}) = w.agent_direction = a(w.agent_direction)

function (w::GoToDoor)(::MoveForward)
    dest = w.agent_direction(w.agent_pos)
    if !w.world[dest, WALL]
        w.agent_pos = dest
    end
end

# TODO:
# update w.agent_view
# https://github.com/maximecb/gym-minigrid/blob/master/gym_minigrid/minigrid.py#L1165
function get_agent_view(w::GoToDoor)
end

function get_agent_view!(buf::BitArray{3}, w)
end
