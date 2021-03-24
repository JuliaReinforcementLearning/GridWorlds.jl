get_char(::Nothing) = '⋅'
get_color(::Nothing) = :white

get_char(::Agent) = '☻'
get_char(::Agent, ::Up) = '↑'
get_char(::Agent, ::Down) = '↓'
get_char(::Agent, ::Left) = '←'
get_char(::Agent, ::Right) = '→'
get_color(::Agent) = :red

get_char(::Wall) = '█'
get_color(::Wall) = :white

get_char(::Goal) = '♥'
get_color(::Goal) = :red

get_char(::Door) = '⩎'
get_color(::Door) = :yellow

get_char(::Key) = '⚷'
get_color(::Key) = :yellow

get_char(::Gem) = '♦'
get_color(::Gem) = :magenta

get_char(::Obstacle) = '⊗'
get_color(::Obstacle) = :blue

get_char(::Box) = '▒'
get_color(::Box) = :yellow

get_char(::Target) = '✖'
get_color(::Target) = :red

get_char(::Body) = '█'
get_color(::Body) = :green

get_char(::Food) = '♦'
get_color(::Food) = :yellow

get_char(::Basket) = '⊔'
get_color(::Basket) = :red

get_char(::Ball) = '∘'
get_color(::Ball) = :yellow

#####
# GridWorldBase
#####

function get_first_object(grid::AbstractArray{Bool, 3}, objects, pos::CartesianIndex{2})
    idx = findfirst(grid[:, pos])
    if isnothing(idx)
        return nothing
    else
        return objects[idx]
    end
end

function get_render_data(world::GridWorldBase, pos::CartesianIndex{2})
    grid = get_grid(world)
    objects = get_objects(world)

    object = get_first_object(grid, objects, pos)
    background = :black
    foreground = get_color(object)
    char = get_char(object)

    return background, foreground, char
end

function get_render_data(world::GridWorldBase, pos::CartesianIndex{2}, layer)
    if world[layer, pos]
        object = get_objects(world)[layer]
        return :black, get_color(object), get_char(object)
    else
        return :black, get_color(nothing), get_char(nothing)
    end
end

function render(io::IO, ::MIME"text/plain", world)
    for i in 1:get_height(world)
        for j in 1:get_width(world)
            pos = CartesianIndex(i, j)
            background, foreground, char = get_render_data(world, pos)
            print(io, Crayons.Crayon(background = background, foreground = foreground, bold = true, reset = true), char)
        end
        println(io, Crayons.Crayon(reset = true))
    end
end

function render_layers(io::IO, ::MIME"text/plain", world)
    objects = get_objects(world)
    for (layer, object) in enumerate(objects)
        println("layer = $layer, object = $object")
        for i in 1:get_height(world)
            for j in 1:get_width(world)
                pos = CartesianIndex(i, j)
                background, foreground, char = get_render_data(world, pos, layer)
                print(io, Crayons.Crayon(background = background, foreground = foreground, bold = true, reset = true), char)
            end
            println(io, Crayons.Crayon(reset = true))
        end
    end
end

#####
# AbstractGridWorld
#####

function get_render_data(env::AbstractGridWorld, pos::CartesianIndex{2})
    grid = get_grid(env)
    objects = get_objects(env)

    object = get_first_object(grid, objects, pos)
    background = :black
    foreground = get_color(object)
    char = get_char(object)

    if hasfield(typeof(env), :agent_pos)
        agent_pos = get_agent_pos(env)
        if hasfield(typeof(env), :agent_dir)
            agent_dir = get_agent_dir(env)
            if object === AGENT
                char = get_char(object, agent_dir)
            end
            if pos in get_grid_inds(agent_pos.I, get_half_size(env), agent_dir)
                background = :dark_gray
            end
        else
            if pos in get_grid_inds(agent_pos.I, get_half_size(env))
                background = :dark_gray
            end
        end
    end

    return background, foreground, char
end

function get_render_data(env::AbstractGridWorld, pos::CartesianIndex{2}, layer)
    world = get_world(env)
    grid = get_grid(world)

    object = nothing
    background = :black
    foreground = get_color(nothing)
    char = get_char(nothing)
    if world[layer, pos]
        object = get_objects(world)[layer]
        foreground = get_color(object)
        char = get_char(object)
    end

    if hasfield(typeof(env), :agent_pos)
        agent_pos = get_agent_pos(env)
        if hasfield(typeof(env), :agent_dir)
            agent_dir = get_agent_dir(env)
            if object === AGENT
                char = get_char(object, agent_dir)
            end
            if pos in get_grid_inds(agent_pos.I, get_half_size(env), agent_dir)
                background = :dark_gray
            end
        else
            if pos in get_grid_inds(agent_pos.I, get_half_size(env))
                background = :dark_gray
            end
        end
    end

    return background, foreground, char
end
