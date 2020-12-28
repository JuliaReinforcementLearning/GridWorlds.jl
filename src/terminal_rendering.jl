get_grid(env::AbstractGridWorld, ::Val{:full_view}) = get_grid(env)
get_grid(env::AbstractGridWorld, ::Val{:agent_view}) = get_agent_view(env)

get_agent_pos(env::AbstractGridWorld, ::Val{:full_view}) = get_agent_pos(env)
get_agent_pos(env::AbstractGridWorld, ::Val{:agent_view}) = CartesianIndex(1, size(get_grid(env, Val{:agent_view}()), 3) ÷ 2 + 1)

get_agent_dir(env::AbstractGridWorld, ::Val{:full_view}) = get_agent_dir(env)
get_agent_dir(env::AbstractGridWorld, ::Val{:agent_view}) = DOWN

get_background(env::AbstractGridWorld, pos::CartesianIndex{2}, ::Val{:full_view}) = pos in get_agent_view_inds(env) ? :dark_gray : :black
get_background(env::AbstractGridWorld, pos::CartesianIndex{2}, ::Val{:agent_view}) = :dark_gray

get_color(::Nothing) = :white
get_char(::Nothing) = '~'

function get_first_object(grid::BitArray{3}, objects, pos::CartesianIndex{2})
    idx = findfirst(grid[:, pos])
    if isnothing(idx)
        return nothing
    else
        return objects[idx]
    end
end

function print_grid(io::IO, env::AbstractGridWorld, view_type)
    grid = get_grid(env, Val{view_type}())
    objects = get_objects(env)

    agent = get_agent(env)
    agent_pos = get_agent_pos(env, Val{view_type}())
    agent_dir = get_agent_dir(env, Val{view_type}())
    agent_char = get_char(agent, agent_dir)
    agent_color = get_color(agent)

    for i in 1:get_height(grid)
        for j in 1:get_width(grid)
            pos = CartesianIndex(i, j)
            if pos == agent_pos
                print(io, Crayons.Crayon(background = get_background(env, pos, Val{view_type}()), foreground = agent_color, bold = true, reset = true), agent_char)
            else
                object = get_first_object(grid, objects, pos)
                print(io, Crayons.Crayon(background = get_background(env, pos, Val{view_type}()), foreground = get_color(object), bold = true, reset = true), get_char(object))
            end
        end
        println(io, Crayons.Crayon(reset = true))
    end
end

function Base.show(io::IO, ::MIME"text/plain", world::GridWorldBase)
    grid = get_grid(world)
    objects = get_objects(world)

    for i in 1:get_height(grid)
        for j in 1:get_width(grid)
            pos = CartesianIndex(i, j)
            object = get_first_object(grid, objects, pos)
            print(io, Crayons.Crayon(background = :black, foreground = get_color(object), bold = true, reset = true), get_char(object))
        end
        println(io, Crayons.Crayon(reset = true))
    end
end

function Base.show(io::IO, ::MIME"text/markdown", env::AbstractGridWorld)
    println(io, "Full View:")
    print_grid(io, env, :full_view)
    println(io)
    println(io, "Agent's View:")
    print_grid(io, env, :agent_view)
end

Base.show(io::IO, mime::MIME"text/plain", env::Sokoban) = show(io, mime, get_world(env))
