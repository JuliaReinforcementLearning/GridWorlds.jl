get_background(env::AbstractGridWorld, pos::CartesianIndex{2}, ::Val{:agent_view}) = :dark_gray
get_background(env::AbstractGridWorld, pos::CartesianIndex{2}, ::Val{:full_view}) = pos in get_agent_view_inds(env) ? :dark_gray : :black

get_color(::Nothing) = :white
get_char(::Nothing) = '~'

function get_first_object(world::GridWorldBase, pos::CartesianIndex{2})
    objects = get_objects(world)
    idx = findfirst(world[:, pos])
    if isnothing(idx)
        return nothing
    else
        return objects[idx]
    end
end

function print_grid(io::IO, env::AbstractGridWorld, view_type)
    world = get_world_with_agent(env, view_type = view_type)
    objects = get_objects(world)

    for i in 1:get_height(world)
        for j in 1:get_width(world)
            pos = CartesianIndex(i, j)
            object = get_first_object(world, pos)
            print(io, Crayons.Crayon(background = get_background(env, pos, Val{view_type}()), foreground = get_color(object), bold = true, reset = true), get_char(object))
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
