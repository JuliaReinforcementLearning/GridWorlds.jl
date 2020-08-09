export EmptyGridWorld

mutable struct EmptyGridWorld
    world::GridWorldBase{Tuple{Empty,Wall,Goal}}
    agent_pos::CartesianIndex{2}
    agent_direction::LRUD
end

function EmptyGridWorld(;n=8, agent_start_pos=CartesianIndex(2,2), agent_view_size=7)
    objects = (EMPTY, WALL, GOAL)
    world = GridWorldBase(n, n, objects)
    world[EMPTY, 2:n-1, 2:n-1] .= true
    world[WALL, [1,n], 1:n] .= true
    world[WALL, 1:n, [1,n]] .= true
    world[GOAL, n-1, n-1] = true
    EmptyGridWorld(world, agent_start_pos, RIGHT)
end

(w::EmptyGridWorld)(a::Union{TurnClockwise, TurnCounterclockwise}) = w.agent_direction = a(w.agent_direction)

function (w::EmptyGridWorld)(::MoveForward)
    dest = w.agent_direction(w.agent_pos)
    if !w.world[WALL, dest]
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

#####
# Visualization
#####

using Makie

function init_screen(w::Observable{<:EmptyGridWorld}; resolution=(1000,1000))
    scene = Scene(resolution = resolution, raw = true, camera = campixel!)

    area = scene.px_area
    poly!(scene, area)

    grid_size = @lift((widths($area)[1] / size($w.world, 2), widths($area)[2] / size($w.world, 3)))
    T = transform(size(w[].world, 2))

    # 1. paint walls
    walls = @lift(findall(selectdim($w.world, 1, Base.to_index($w.world, WALL))))
    wall_boxes = @lift([FRect2D((T(w).I .- (1,1)) .* $grid_size , $grid_size) for w in $walls])
    poly!(scene, wall_boxes, color=:gray)

    # 2. paint goal
    goals = @lift(findall(selectdim($w.world, 1, Base.to_index($w.world, GOAL))))
    goal_boxes = @lift([FRect2D((T(w).I .- (1,1)) .* $grid_size , $grid_size) for w in $goals])
    poly!(scene, goal_boxes, color=:green)

    # 3. paint agent
    agent_marker = @lift if $w.agent_direction === UP
        '▲'
    elseif $w.agent_direction === DOWN
        '▼'
    elseif $w.agent_direction === LEFT
        '◀'
    elseif $w.agent_direction === RIGHT
        '▶'
    else
        error("unknown direction")
    end

    agent_position = @lift((T($w.agent_pos).I .- (0.5, 0.5)).* $grid_size)
    scatter!(scene, agent_position, color=:red, marker=agent_marker, markersize=@lift(minimum($grid_size)))

    display(scene)
    scene
end