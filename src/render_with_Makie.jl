export play

# coordinate transform for Makie.jl
transform(x::Int) = p -> CartesianIndex(p[3], x-p[2]+1)

using Makie

function init_screen(w::Observable{<:AbstractGridWorld}; resolution=(1000,1000))
    scene = Scene(resolution = resolution, raw = true, camera = campixel!)

    area = scene.px_area
    poly!(scene, area)

    grid_size = @lift((widths($area)[1] / size($w.world, 2), widths($area)[2] / size($w.world, 3)))
    T = transform(size(w[].world, 1))

    # 1. paint walls
    if WALL in w[].world.objects
        walls = @lift(findall(view($w.world, Base.to_index($w.world, WALL), :, :)))
        wall_boxes = @lift([FRect2D((T(w).I .- (1,1)) .* $grid_size , $grid_size) for w in $walls])
        poly!(scene, wall_boxes, color=:gray)
    end

    # 2. paint goal
    if GOAL in w[].world.objects
        goals = @lift(findall(view($w.world, Base.to_index($w.world, GOAL), :, :)))
        goal_boxes = @lift([FRect2D((T(w).I .- (1,1)) .* $grid_size , $grid_size) for w in $goals])
        poly!(scene, goal_boxes, color=:green)
    end

    # 3. paint doors
    if DOOR in w[].world.objects
        doors = @lift(findall(view($w.world, Base.to_index($w.world, DOOR), :, :)))
        world_colors = [x for x in $w.objects if x isa AbstractColor]
        world_colors_inds = [Base.to_index(w[].world, c) for c in world_colors]
        for d in doors[]
            c = w[].objects[findfirst(x -> x isa AbstractColor, @view(w[].world[:, d]))]
            scatter!(scene, @lift((T(d).I .- (0.5, 0.5)).* $grid_size), color=:red, marker='🚪' , markersize=@lift(minimum($grid_size)))
        end
    end

    # 4. paint agent
    agent_marker = @lift if $w.agent_dir === UP
        '▲'
    elseif $w.agent_dir === DOWN
        '▼'
    elseif $w.agent_dir === LEFT
        '◀'
    elseif $w.agent_dir === RIGHT
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
    ←: TurnLeft
    →: TurnRight
    ↑: MoveForward
    q: Quit
    """)
    w = environment
    w_node = Node(w)
    scene = init_screen(w_node)
    is_quit = Ref(false)

    on(scene.events.keyboardbuttons) do b
        if ispressed(b, Keyboard.left)
            w(TURN_LEFT)
            w_node[] = w
        elseif ispressed(b, Keyboard.right)
            w(TURN_RIGHT)
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
