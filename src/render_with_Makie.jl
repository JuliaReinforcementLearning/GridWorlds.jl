export play

using Colors

# coordinate transform for Makie.jl
transform(x::Int) = p -> CartesianIndex(p[2], x-p[1]+1)

using Makie

function init_screen(w::Observable{<:AbstractGridWorld}; resolution=(1000,1000))
    scene = Scene(resolution = resolution, raw = true, camera = campixel!)

    area = scene.px_area
    poly!(scene, area)

    grid_size = @lift((widths($area)[1] / size($w.world, 2), widths($area)[2] / size($w.world, 3)))
    T = transform(size(w[].world, 2))

    # 0. paint view
    view_boxes = @lift([FRect2D((T(x).I .- (1,1)) .* $grid_size , $grid_size) for x in get_agent_view_inds($w) if x ∈ CartesianIndices((size($w.world, 2), size($w.world, 3)))])
    poly!(scene, view_boxes, color=:dimgrey)

    # 1. paint walls
    if WALL in get_object(w[])
        walls = @lift(findall(view($w.world, Base.to_index($w.world, WALL), :, :)))
        wall_boxes = @lift([FRect2D((T(w).I .- (1,1)) .* $grid_size , $grid_size) for w in $walls])
        poly!(scene, wall_boxes, color=:darkgray)
    end

    # 2. paint goal
    if GOAL in get_object(w[])
        goal_pos = @lift(findall(view($w.world, Base.to_index($w.world, GOAL), :, :)))
        goal_centers = @lift([(T(p).I .- (0.5,0.5)) .* $grid_size for p in $goal_pos])
        scatter!(scene, goal_centers, color=get_color(GOAL), marker=convert(Char, GOAL), markersize=@lift(minimum($grid_size)))
    end

    # 3. paint doors
    # if DOOR in get_object(w[])
    #     doors = @lift(findall(view($w.world, Base.to_index($w.world, DOOR), :, :)))
    #     world_colors = [x for x in w[].objects if x isa AbstractColor]
    #     world_colors_inds = [Base.to_index(w[].world, c) for c in world_colors]
    #     for d in doors[]
    #         c = w[].objects[findfirst(x -> x isa AbstractColor, @view(w[].world[:, d]))]
    #         scatter!(scene, @lift((T(d).I .- (0.5, 0.5)).* $grid_size), color=:red, marker='🚪' , markersize=@lift(minimum($grid_size)))
    #     end
    # end

    # 4. paint agent
    agent = @lift(get_agent($w))
    agent_position = @lift((T(get_agent_pos($w)).I .- (0.5, 0.5)).* $grid_size)
    scatter!(scene, agent_position, color=@lift(get_color($agent)), marker=@lift(convert(Char, $agent)), markersize=@lift(minimum($grid_size)))

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
