export play

using Makie

color2value = Dict{Union{typeCOLORS...}, Symbol}(
    RED    => :red,
    GREEN  => :green,
    BLUE   => :blue,
    PURPLE => :purple,
    YELLOW => :yellow,
    GREY   => :gray
)

function init_screen(w::Observable{<:AbstractGridWorld}; resolution=(1000,1000))
    scene = Scene(resolution = resolution, raw = true, camera = campixel!)

    area = scene.px_area
    poly!(scene, area)

    grid_size = @lift((widths($area)[1] / size($w.world, 1), widths($area)[2] / size($w.world, 2)))
    T = transform(size(w[].world, 1))

    # 1. paint walls
    walls = @lift(findall(selectdim($w.world, 3, Base.to_index($w.world, WALL))))
    wall_boxes = @lift([FRect2D((T(w).I .- (1,1)) .* $grid_size , $grid_size) for w in $walls])
    poly!(scene, wall_boxes, color=:gray)

    # 2. paint goal
    if GOAL in w[].world.objects
        goals = @lift(findall(selectdim($w.world, 3, Base.to_index($w.world, GOAL))))
        goal_boxes = @lift([FRect2D((T(w).I .- (1,1)) .* $grid_size , $grid_size) for w in $goals])
        poly!(scene, goal_boxes, color=:green)
    end

    # 3. paint doors
    if DOOR in w[].world.objects
        doors = @lift(findall(selectdim($w.world, 3, Base.to_index($w.world, DOOR))))
        for (x,y) in (p->Tuple(p)).(doors[])
            color = findlast(selectdim(selectdim(w[].world,1,x),1,y))-Base.to_index(w[].world, COLORS[1])+1
            color = color2value[COLORS[color]]
            door_box = @lift(FRect2D((T((x,y)).I .- (1,1)) .* $grid_size , $grid_size))
            poly!(scene, door_box, color=color)
        end
    end

    # 4. paint agent
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

function play(environment::AbstractGridWorld)
    print("""
    Key bindings:
    ←: TurnCounterclockwise
    →: TurnClockwise
    ↑: MoveForward
    q: Quit
    """)
    w = environment
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
