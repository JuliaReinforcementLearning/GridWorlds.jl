export GoToDoor

mutable struct GoToDoor <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty,Wall,Door,typeCOLORS...}}
    agent_pos::CartesianIndex{2}
    agent_dir::LRUD
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

(w::GoToDoor)(a::Union{TurnClockwise, TurnCounterclockwise}) = w.agent_dir = a(w.agent_dir)

function (w::GoToDoor)(::MoveForward)
    dest = w.agent_dir(w.agent_pos)
    if !(1≤dest[1]≤size(w.world)[1] && 1≤dest[2]≤size(w.world)[2])
        return
    end
    if !w.world[dest, WALL]
        w.agent_pos = dest
    end
end