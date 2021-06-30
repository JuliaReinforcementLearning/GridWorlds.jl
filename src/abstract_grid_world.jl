abstract type AbstractGridWorld <: RLBase.AbstractEnv end

@forward AbstractGridWorld.world get_grid, get_objects, get_num_objects, get_height, get_width
get_half_size(env::AbstractGridWorld) = (2 * (get_height(env) ÷ 4) + 1, 2 * (get_width(env) ÷ 4) + 1)

Random.rand(rng::Random.AbstractRNG, f::Function, env::AbstractGridWorld; max_try = 1000) = rand(rng, f, get_world(env), max_try = max_try)

reset!(env::AbstractGridWorld) = error("Method not implemented for $(typeof(env))")
act!(env::AbstractGridWorld) = error("Method not implemented for $(typeof(env))")
get_characters(env::AbstractGridWorld) = error("Method not implemented for $(typeof(env))")
get_action_keys(env::AbstractGridWorld) = error("Method not implemented for $(typeof(env))")
get_action_names(env::AbstractGridWorld) = error("Method not implemented for $(typeof(env))")

function get_tile_map_string(tile_map, characters)
    num_objects, height, width = size(tile_map)

    str = ""

    for i in 1:height
        for j in 1:width
            object = findfirst(@view tile_map[:, i, j])
            if isnothing(object)
                str = str * characters[end]
            else
                str = str * characters[object]
            end
        end

        str = str * "\n"
    end

    return str
end

function get_show_string(env::AbstractGridWorld)
    tile_map = env.tile_map
    characters = get_characters(env)
    str = get_tile_map_string(tile_map, characters)
    str = str * "reward = $(env.reward)\ndone = $(env.done)"
    return str
end

Base.show(io::IO, ::MIME"text/plain", env::AbstractGridWorld) = print(io, get_show_string(env))

#####
# utils
#####

macro generate_getters(type)
    T = getfield(__module__, type)::Union{Type,DataType}
    defs = Expr(:block)
    for field in fieldnames(T)
        get = Symbol(:get_, field)
        qn = QuoteNode(field)
        push!(defs.args, :($(esc(get))(instance::$type) = getfield(instance, $qn)))
    end
    return defs
end

macro generate_setters(type)
    T = getfield(__module__, type)::Union{Type,DataType}
    defs = Expr(:block)
    for field in fieldnames(T)
        set = Symbol(:set_, field, :!)
        qn = QuoteNode(field)
        push!(defs.args, :($(esc(set))(instance::$type, x) = setfield!(instance, $qn, x)))
    end
    return defs
end
