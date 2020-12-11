export play

using .Makie

# coordinate transform for Makie.jl
get_transform(x::Int) = pos -> CartesianIndex(pos[2], x - pos[1] + 1)

get_markersize(object::Nothing, tile_size) = reverse(tile_size) ./ 2
get_markersize(object::AbstractObject, tile_size) = reverse(tile_size)
get_markersize(object::Empty, tile_size) = reverse(tile_size) ./ 5

function init_screen(env_node::Observable{<:AbstractGridWorld}; resolution = (1000, 1000))
    scene = Scene(resolution = resolution, raw = true, camera = campixel!)
    area = scene.px_area

    height = get_height(env_node[])
    width = get_width(env_node[])

    tile_inds = CartesianIndices((height, width))
    tile_size = @lift((widths($area)[1] / get_height($env_node), widths($area)[2] / get_width($env_node)))
    @show tile_size.val

    transform = get_transform(get_height(env_node[]))
    boxes(pos, tile_size) = [FRect2D((transform(p).I .- (1,1)) .* reverse(tile_size), reverse(tile_size)) for p in pos]
    centers(pos, tile_size) = [(transform(p).I .- (0.5,0.5)) .* reverse(tile_size) for p in pos]

    # 1. paint background
    poly!(scene, area)

    # 2. paint each kind of object
    for object in get_objects(env_node[])
        scatter!(scene, @lift(centers(findall($env_node.world[object, :, :]), $tile_size)), color = get_color(object), marker = get_char(object), markersize = @lift(get_markersize(object, $tile_size)))
    end

    # 3. paint agent's view
    view_boxes = @lift(boxes([p for p in get_agent_view_inds($env_node) if p ∈ tile_inds], $tile_size))
    poly!(scene, view_boxes, color = "rgba(255,255,255,0.2)")

    # 4. paint agent
    agent = @lift(get_agent($env_node))
    agent_center = @lift(centers([get_agent_pos($env_node)], $tile_size)[1])
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
