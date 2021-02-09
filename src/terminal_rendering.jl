get_grid(env::AbstractGridWorld, ::Val{:global}) = get_grid(env)
get_grid(env::AbstractGridWorld, ::Val{:local}) = get_agent_view(env)

get_agent_pos(env::AbstractGridWorld, ::Val{:global}) = get_agent_pos(env)
get_agent_pos(env::AbstractGridWorld, view_type_val::Val{:local}) = get_agent_pos(env, view_type_val, get_navigation_style(env))
get_agent_pos(env::AbstractGridWorld, view_type_val::Val{:local}, ::DirectedNavigation) = CartesianIndex(1, get_width(get_grid(env, view_type_val)) ÷ 2 + 1)
function get_agent_pos(env::AbstractGridWorld, view_type_val::Val{:local}, ::UndirectedNavigation)
    grid = get_grid(env, view_type_val)
    CartesianIndex(get_height(grid) ÷ 2 + 1, get_width(grid) ÷ 2 + 1)
end

get_agent_char(env::AbstractGridWorld, ::Val{:global}) = get_char(get_agent(env))
get_agent_char(env::AbstractGridWorld, view_type_val::Val{:local}) = get_agent_char(env, view_type_val, get_navigation_style(env))
get_agent_char(env::AbstractGridWorld, ::Val{:local}, ::DirectedNavigation) = get_char(Agent, DOWN)
get_agent_char(env::AbstractGridWorld, ::Val{:local}, ::UndirectedNavigation) = get_char(get_agent(env))

get_background(env::AbstractGridWorld, ::Val{:global}, pos::CartesianIndex{2}) = pos in get_agent_view_inds(env) ? :dark_gray : :black
get_background(env::AbstractGridWorld, ::Val{:local}, pos::CartesianIndex{2}) = :dark_gray

get_color(::Nothing) = :white
get_char(::Nothing) = '~'

function get_first_object(grid::AbstractArray{Bool, 3}, objects, pos::CartesianIndex{2})
    idx = findfirst(grid[:, pos])
    if isnothing(idx)
        return nothing
    else
        return objects[idx]
    end
end

function Base.show(io::IO, ::MIME"text/plain", env::AbstractGridWorld, view_type::Symbol)
    view_type_val = Val{view_type}()
    grid = get_grid(env, view_type_val)
    objects = get_objects(env)

    render_agent_char = show_agent_char(env)

    for i in 1:get_height(grid)
        for j in 1:get_width(grid)
            pos = CartesianIndex(i, j)
            if render_agent_char && pos == get_agent_pos(env, view_type_val)
                agent_char = get_agent_char(env, view_type_val)
                agent_color = get_color(get_agent(env))
                print(io, Crayons.Crayon(background = get_background(env, view_type_val, pos), foreground = agent_color, bold = true, reset = true), agent_char)
            else
                object = get_first_object(grid, objects, pos)
                print(io, Crayons.Crayon(background = get_background(env, view_type_val, pos), foreground = get_color(object), bold = true, reset = true), get_char(object))
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

function Base.show(io::IO, mime::MIME"text/plain", env::AbstractGridWorld)
    println(io, "Global view:")
    show(io, mime, env, :global)
    println(io)
    println(io, "Local view:")
    show(io, mime, env, :local)
    println(io)
    println(io, "RLBase.reward(env): $(RLBase.reward(env))")
    println(io, "RLBase.is_terminated(env): $(RLBase.is_terminated(env))")
end
