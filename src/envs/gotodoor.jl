export GoToDoor

mutable struct GoToDoor <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty,Wall,Goal,Door,Color...}}
    agent_pos::CartesianIndex{2}
    agent_direction::LRUD
end

function GoToDoor(;n=8, agent_start_pos=CartesianIndex(2,2), agent_view_size=7)
    objects = (EMPTY, WALL, DOOR, COLORS...)
    world = GridWorldBase(n, n, objects)
    world[WALL, [1,n], 1:n] .= true
    world[WALL, 1:n, [1,n]] .= true

    door_pos = [(rand(2:n-1),1), (rand(2:n-1),n), (1,rand(2:n-1)), (n,rand(2:n-1))]
    door_colors = []
    for (x,y) in door_pos
        color = rand(COLORS)
        while color in door_colors
            color = rand(COLORS)
        end
        world[DOOR,x,y] = true
        world[color,x,y] = true
        push!(door_colors, color)
    end
    GoToDoor(world, agent_start_pos, RIGHT)
end

(w::GoToDoor)(a::Union{TurnClockwise, TurnCounterclockwise}) = w.agent_direction = a(w.agent_direction)

function (w::GoToDoor)(::MoveForward)
    dest = w.agent_direction(w.agent_pos)
    if !w.world[WALL, dest]
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
