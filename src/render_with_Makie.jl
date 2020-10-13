export play

using Colors

# coordinate transform for Makie.jl
transform(x::Int) = p -> CartesianIndex(p[2], x-p[1]+1)

using .Makie

function init_screen(w::Observable{<:AbstractGridWorld}; resolution=(1000,1000))
    scene = Scene(resolution = resolution, raw = true, camera = campixel!)

    area = scene.px_area
    grid_size = size(w[].world)[2:3]
    grid_inds = CartesianIndices(grid_size)
    tile_size = @lift((widths($area)[1] / size($w.world, 2), widths($area)[2] / size($w.world, 3)))
    T = transform(size(w[].world, 2))
    boxes(pos, s) = [FRect2D((T(p).I .- (1,1)) .* s, s) for p in pos]
    centers(pos, s) = [(T(p).I .- (0.5,0.5)) .* s for p in pos]

    # 1. paint background
    poly!(scene, area)

    # 2. paint each kind of object
    for o in get_object(w[])
        if o !== EMPTY
            scatter!(scene, @lift(centers(findall($w.world[o,:,:]), $tile_size)), color=get_color(o), marker=convert(Char, o), markersize=@lift(minimum($tile_size)))
        end
    end

    # 3. paint stroke
    poly!(scene, @lift(boxes(vec(grid_inds), $tile_size)), color=:transparent, strokecolor = :lightgray, strokewidth = 4)

    # 3. paint agent's view
    view_boxes = @lift boxes([p for p in get_agent_view_inds($w) if p ∈ grid_inds], $tile_size)
    poly!(scene, view_boxes, color="rgba(255,255,255,0.2)")

    # 4. paint agent
    agent = @lift(get_agent($w))
    agent_position = @lift((T(get_agent_pos($w)).I .- (0.5, 0.5)).* $tile_size)
    scatter!(scene, agent_position, color=@lift(get_color($agent)), marker=@lift(convert(Char, $agent)), markersize=@lift(minimum($tile_size)))

    display(scene)
    scene
end

function play(environment::AbstractGridWorld;file_name=nothing,frame_rate=24)
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

    if !isnothing(file_name)
        vs = VideoStream(scene)
        recordframe!(vs)
    end

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
        isnothing(file_name) || recordframe!(vs)
    end

    try
        while !is_quit[]
            sleep(0.5)
        end
    catch
    end
    isnothing(file_name) || save(file_name, vs;framerate=frame_rate)
    Makie.GLMakie.destroy!(Makie.GLMakie.global_gl_screen())
end
