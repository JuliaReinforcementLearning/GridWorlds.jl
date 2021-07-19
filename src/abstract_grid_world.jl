abstract type AbstractGridWorldGame end

#####
##### Game logic methods
#####

reset!(env::AbstractGridWorldGame) = error("Method not implemented for $(typeof(env))")
act!(env::AbstractGridWorldGame) = error("Method not implemented for $(typeof(env))")

#####
##### Optional methods for pretty printing, playing, etc...
#####

get_tile_pretty_repr(env::AbstractGridWorldGame, i::Integer, j::Integer) = error("Method not implemented for $(typeof(env))")
get_action_keys(env::AbstractGridWorldGame) = error("Method not implemented for $(typeof(env))")
get_action_names(env::AbstractGridWorldGame) = error("Method not implemented for $(typeof(env))")
get_tile_map_height(env::AbstractGridWorldGame) = error("Method not implemented for $(typeof(env))")
get_tile_map_width(env::AbstractGridWorldGame) = error("Method not implemented for $(typeof(env))")

function get_tile_map_pretty_repr(env::AbstractGridWorldGame)
    height_tile_map = get_tile_map_height(env)
    width_tile_map = get_tile_map_width(env)

    str = ""

    for i in 1:height_tile_map
        for j in 1:width_tile_map
            str = str * get_tile_pretty_repr(env, i, j)
        end
        if i < height_tile_map
            str = str * "\n"
        end
    end

    return str
end

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
