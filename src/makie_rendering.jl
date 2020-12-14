export play

using .Makie

get_transform(x::Int) = pos -> CartesianIndex(pos[2], x - pos[1] + 1)
get_center(pos, tile_size, transform) = (transform(pos).I .- (0.5,0.5)) .* reverse(tile_size)
get_box(pos, tile_size, transform) = FRect2D((transform(pos).I .- (1,1)) .* reverse(tile_size), reverse(tile_size))

get_markersize(object::AbstractObject, tile_size) = reverse(tile_size)
get_markersize(object::Empty, tile_size) = reverse(tile_size) ./ 5

function init_screen(env_node::Observable{<:AbstractGridWorld}; resolution = (720, 720))
    scene = Scene(resolution = resolution, raw = true, camera = campixel!)

    height = get_height(env_node[])
    width = get_width(env_node[])
    tile_inds = CartesianIndices((height, width))

    transform = get_transform(height)

    area = scene.px_area
    tile_size = @lift((widths($area)[2] / height, widths($area)[1] / width))

    # 1. paint background
    poly!(scene, area)
    scatter!(scene, @lift(map(x -> get_center(x, $tile_size, transform), filter(pos -> !any(get_world($env_node)[:, pos]), $tile_inds))), color = :white, marker = '~', markersize = @lift((reverse($tile_size) ./ 2)))

    # 2. paint each kind of object
    for object in get_objects(env_node[])
        scatter!(scene, @lift(broadcast(x -> get_center(x, $tile_size, transform), findall(get_world($env_node)[object, :, :]))), color = get_color(object), marker = get_char(object), markersize = @lift(get_markersize(object, $tile_size)))
    end

    # 3. paint agent's view
    view_boxes = @lift(map(pos -> get_box(pos, $tile_size, transform), filter(pos -> pos in tile_inds, get_agent_view_inds($env_node))))
    poly!(scene, view_boxes, color = "rgba(255,255,255,0.3)")

    # 4. paint agent
    agent = @lift(get_agent($env_node))
    agent_center = @lift(get_center(get_agent_pos($env_node), $tile_size, transform))
    scatter!(scene, agent_center, color = @lift(get_color($agent)), marker = @lift(get_char($agent)), markersize = @lift(get_markersize($agent, $tile_size)))

    display(scene)
    scene
end

function play(env::AbstractGridWorld;file_name=nothing,frame_rate=24)
    print("""
    Key bindings:
    ←: TurnLeft
    →: TurnRight
    ↑: MoveForward
    p: PickUp
    r: reset!
    q: Quit
    """)
    env_node = Node(env)
    scene = init_screen(env_node)
    is_quit = Ref(false)

    if !isnothing(file_name)
        vs = VideoStream(scene)
        recordframe!(vs)
    end

    on(scene.events.keyboardbuttons) do b
        if ispressed(b, Keyboard.left)
            env(TURN_LEFT)
            env_node[] = env
        elseif ispressed(b, Keyboard.right)
            env(TURN_RIGHT)
            env_node[] = env
        elseif ispressed(b, Keyboard.up)
            env(MOVE_FORWARD)
            env_node[] = env
        elseif ispressed(b, Keyboard.p)
            env(PICK_UP)
            env_node[] = env
        elseif ispressed(b, Keyboard.r)
            reset!(env)
            env_node[] = env
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
