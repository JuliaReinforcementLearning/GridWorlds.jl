using Crayons

get_background(env::AbstractGridWorld, pos::CartesianIndex{2}, ::Val{:agent_view}) = :dark_gray
get_background(env::AbstractGridWorld, pos::CartesianIndex{2}, ::Val{:full_view}) = pos in get_agent_view_inds(env) ? :dark_gray : :black

function print_grid(io::IO, env::AbstractGridWorld, view_type)
    grid = get_grid(env, Val{view_type}())
    agent = get_agent(env, Val{view_type}())
    agent_pos = get_agent_pos(env, Val{view_type}())
    agent_layer = get_agent_layer(grid, agent_pos)
    grid = cat(agent_layer, grid, dims = 1)

    objects = (agent, get_objects(env)...)

    for i in 1:size(grid, 2)
        for j in 1:size(grid, 3)
            pos = CartesianIndex(i, j)
            idx = findfirst(grid[:, pos])
            if isnothing(idx)
                o = nothing
                foreground = :white
                c = '_'
            else
                o = objects[idx]
                foreground = get_color(o)
                c = get_char(o)
            end
            print(io, Crayon(background = get_background(env, pos, Val{view_type}()), foreground = foreground, bold = true, reset = true), c)
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
