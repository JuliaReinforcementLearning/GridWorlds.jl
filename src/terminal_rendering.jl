using Crayons

get_background(env::AbstractGridWorld, pos::CartesianIndex{2}, ::Val{:agent_view}) = :dark_gray
get_background(env::AbstractGridWorld, pos::CartesianIndex{2}, ::Val{:full_view}) = pos in get_agent_view_inds(env) ? :dark_gray : :black

function print_grid(io::IO, env::AbstractGridWorld, view_type)
    world = get_world_with_agent(env, view_type = view_type)
    objects = get_objects(world)

    for i in 1:get_height(world)
        for j in 1:get_width(world)
            pos = CartesianIndex(i, j)
            idx = findfirst(world[:, pos])
            if isnothing(idx)
                object = nothing
                foreground = :white
                char = '_'
            else
                object = objects[idx]
                foreground = get_color(object)
                char = get_char(object)
            end
            print(io, Crayon(background = get_background(env, pos, Val{view_type}()), foreground = foreground, bold = true, reset = true), char)
        end
        println(io, Crayon(reset = true))
    end
end

function Base.show(io::IO, ::MIME"text/markdown", env::AbstractGridWorld)
    println(io, "Full View:")
    print_grid(io, env, :full_view)
    println(io)
    println(io, "Agent's View:")
    print_grid(io, env, :agent_view)
end
