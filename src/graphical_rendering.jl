import .Makie

get_transform(x::Int) = pos -> CartesianIndex(pos[2], x - pos[1] + 1)
get_center(pos, tile_size, transform) = (transform(pos).I .- (0.5,0.5)) .* reverse(tile_size)
get_box(pos, tile_size, transform) = Makie.FRect2D((transform(pos).I .- (1,1)) .* reverse(tile_size), reverse(tile_size))

get_markersize(object::AbstractObject, tile_size) = reverse(tile_size)

function init_screen(env_node::Makie.Observable{E}; resolution = (720, 720)) where {E<:AbstractGridWorld}
    scene = Makie.Scene(resolution = resolution, raw = true, camera = Makie.campixel!)

    height = get_height(env_node[])
    width = get_width(env_node[])
    tile_inds = CartesianIndices((height, width))

    transform = get_transform(height)

    area = scene.px_area
    tile_size = Makie.@lift((Makie.widths($area)[2] / height, Makie.widths($area)[1] / width))

    # 1. paint background
    Makie.poly!(scene, area)
    Makie.scatter!(scene, Makie.@lift(map(x -> get_center(x, $tile_size, transform), filter(pos -> !any(get_world($env_node)[:, pos]), $tile_inds))), color = :white, marker = '⋅', markersize = Makie.@lift((reverse($tile_size) ./ 5)))

    # 2. paint each kind of object
    for object in reverse(get_objects(env_node[]))
        if object === AGENT
            if hasfield(E, :agent_dir)
                Makie.scatter!(scene, Makie.@lift(broadcast(x -> get_center(x, $tile_size, transform), findall(get_world($env_node)[object, :, :]))), color = get_color(object), marker = Makie.@lift(get_char(object, get_agent_dir($env_node))), markersize = Makie.@lift(get_markersize(object, $tile_size)))
            else
                Makie.scatter!(scene, Makie.@lift(broadcast(x -> get_center(x, $tile_size, transform), findall(get_world($env_node)[object, :, :]))), color = get_color(object), marker = get_char(object), markersize = Makie.@lift(get_markersize(object, $tile_size)))
            end
        else
            Makie.scatter!(scene, Makie.@lift(broadcast(x -> get_center(x, $tile_size, transform), findall(get_world($env_node)[object, :, :]))), color = get_color(object), marker = get_char(object), markersize = Makie.@lift(get_markersize(object, $tile_size)))
        end
    end

    # 3. paint agent's view
    if isa(RLBase.StateStyle(env_node[]), RLBase.Observation) && !(isa(env_node[], Snake))
        if hasfield(E, :agent_dir)
            view_boxes = Makie.@lift(map(pos -> get_box(pos, $tile_size, transform), filter(pos -> pos in tile_inds, get_grid_inds(get_agent_pos($env_node).I, get_half_size($env_node), get_agent_dir($env_node)))))
            Makie.poly!(scene, view_boxes, color = "rgba(255,255,255,0.3)")
        else
            view_boxes = Makie.@lift(map(pos -> get_box(pos, $tile_size, transform), filter(pos -> pos in tile_inds, get_grid_inds(get_agent_pos($env_node).I, get_half_size($env_node)))))
            Makie.poly!(scene, view_boxes, color = "rgba(255,255,255,0.3)")
        end
    end

    return scene
end

function play(env::AbstractGridWorld;file_name=nothing,frame_rate=24)
    print("""
    Key bindings:
    ←: TurnLeft
    →: TurnRight
    ↑: MoveForward
    w: MoveUp
    s: MoveDown
    a: MoveLeft
    d: MoveRight
    n: NoMove
    p: PickUp
    o: Drop
    r: reset!
    q: Quit
    """)
    env_node = Makie.Node(env)
    scene = init_screen(env_node)
    Makie.display(scene)
    is_quit = Ref(false)

    if !isnothing(file_name)
        vs = Makie.VideoStream(scene)
        Makie.recordframe!(vs)
    end

    Makie.on(scene.events.keyboardbuttons) do b
        if Makie.ispressed(b, Makie.Keyboard.left)
            env(TURN_LEFT)
            env_node[] = env
        elseif Makie.ispressed(b, Makie.Keyboard.right)
            env(TURN_RIGHT)
            env_node[] = env
        elseif Makie.ispressed(b, Makie.Keyboard.up)
            env(MOVE_FORWARD)
            env_node[] = env
        elseif Makie.ispressed(b, Makie.Keyboard.w)
            env(MOVE_UP)
            env_node[] = env
        elseif Makie.ispressed(b, Makie.Keyboard.s)
            env(MOVE_DOWN)
            env_node[] = env
        elseif Makie.ispressed(b, Makie.Keyboard.a)
            env(MOVE_LEFT)
            env_node[] = env
        elseif Makie.ispressed(b, Makie.Keyboard.d)
            env(MOVE_RIGHT)
            env_node[] = env
        elseif Makie.ispressed(b, Makie.Keyboard.n)
            env(NO_MOVE)
            env_node[] = env
        elseif Makie.ispressed(b, Makie.Keyboard.p)
            env(PICK_UP)
            env_node[] = env
        elseif Makie.ispressed(b, Makie.Keyboard.o)
            env(DROP)
            env_node[] = env
        elseif Makie.ispressed(b, Makie.Keyboard.r)
            RLBase.reset!(env)
            env_node[] = env
        elseif Makie.ispressed(b, Makie.Keyboard.q)
            is_quit[] = true
        end
        @show b
        @show RLBase.reward(env)
        @show RLBase.is_terminated(env)
        isnothing(file_name) || Makie.recordframe!(vs)
    end

    try
        while !is_quit[]
            sleep(0.5)
        end
    catch
    end
    isnothing(file_name) || Makie.save(file_name, vs;framerate=frame_rate)
    Makie.GLMakie.destroy!(Makie.GLMakie.global_gl_screen())
end
