export FourRooms

mutable struct FourRooms
    world::GridWorldBase{Tuple{Empty,Wall,Goal}}
    agent_pos::CartesianIndex{2}
    agent_direction::LRUD
end

function FourRooms(;n=30, agent_start_pos=CartesianIndex(2,2), agent_view_size=7)
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

function get_agent_view(w::FourRooms)
end

function get_agent_view!(buf::BitArray{3}, w)
end

using Makie

function init_screen(w::Observable{<:FourRooms}; resolution=(1000,1000))
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

function play(::Val{:FourRooms})
    print("""
    Key bindings:
    ←: TurnCounterclockwise
    →: TurnClockwise
    ↑: MoveForward
    q: Quit
    """)
    w = FourRooms()
    w_node = Node(w)
    scene = init_screen(w_node)
    is_quit = Ref(false)

    on(scene.events.keyboardbuttons) do b
        if ispressed(b, Keyboard.left)
            w(TURN_COUNTERCLOCKWISE)
            w_node[] = w
        elseif ispressed(b, Keyboard.right)
            w(TURN_CLOCKWISE)
            w_node[] = w
        elseif ispressed(b, Keyboard.up)
            w(MOVE_FORWARD)
            w_node[] = w
        elseif ispressed(b, Keyboard.q)
            is_quit[] = true
        end
    end

    while !is_quit[]
        sleep(0.5)
    end
end
