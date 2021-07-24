abstract type AbstractGridWorld end

#####
##### Game logic methods
#####

reset!(env::AbstractGridWorld) = error("Method not implemented for $(typeof(env))")
act!(env::AbstractGridWorld, action) = error("Method not implemented for $(typeof(env))")

#####
##### Optional methods for pretty printing, playing, etc...
#####

get_pretty_tile_map(env::AbstractGridWorld, position::CartesianIndex{2}) = error("Method not implemented for $(typeof(env))")
get_pretty_sub_tile_map(env::AbstractGridWorld, position::CartesianIndex{2}) = error("Method not implemented for $(typeof(env))")
get_action_keys(env::AbstractGridWorld) = error("Method not implemented for $(typeof(env))")
get_action_names(env::AbstractGridWorld) = error("Method not implemented for $(typeof(env))")
get_object_names(env::AbstractGridWorld) = error("Method not implemented for $(typeof(env))")
get_height(env::AbstractGridWorld) = error("Method not implemented for $(typeof(env))")
get_width(env::AbstractGridWorld) = error("Method not implemented for $(typeof(env))")

function get_pretty_tile_map(env::AbstractGridWorld)
    height = get_height(env)
    width = get_width(env)

    str = ""

    for i in 1:height
        for j in 1:width
            str = str * get_pretty_tile_map(env, CartesianIndex(i, j))
        end
        if i < height
            str = str * "\n"
        end
    end

    return str
end

function get_window_size(env::AbstractGridWorld)
    height = get_height(env)
    width = get_width(env)
    return (2 * (height ÷ 4) + 1, 2 * (width ÷ 4) + 1)
end

function get_pretty_sub_tile_map(env::AbstractGridWorld, window_size)
    height, width = window_size

    str = ""

    for i in 1:height
        for j in 1:width
            str = str * get_pretty_sub_tile_map(env, window_size, CartesianIndex(i, j))
        end
        if i < height
            str = str * "\n"
        end
    end

    return str
end

#####
##### Sub tile map
#####

function get_window_region((i, j), (m, n))
    temp1 = m ÷ 2
    temp2 = i - temp1
    temp3 = n ÷ 2
    temp4 = j - temp3
    return CartesianIndices((temp2 : temp2 + m - 1, temp4 : temp4 + n - 1))
end

function get_sub_tile_map(tile_map, position, window_size)
    num_objects = size(tile_map, 1)
    sub_tile_map = falses(num_objects, window_size...)
    get_sub_tile_map!(sub_tile_map, tile_map, position, window_size)
    return sub_tile_map
end

function get_sub_tile_map!(sub_tile_map, tile_map, position, window_size)
    _, height, width = size(tile_map)

    window_region = get_window_region(position.I, window_size)

    valid_region = CartesianIndices((1 : height, 1 : width))

    @views for key in keys(window_region)
        pos = window_region[key]
        if pos in valid_region
            sub_tile_map[:, key] .= tile_map[:, pos]
        end
    end

    return nothing
end

function get_window_region((i, j), (m, n), direction)
    if direction == RIGHT
        temp1 = n - 1
        temp2 = temp1 ÷ 2
        temp3 = i - temp2
        return CartesianIndices((temp3 : temp3 + temp1, j : j + m - 1))
    elseif direction == UP
        temp1 = n - 1
        temp2 = temp1 ÷ 2
        temp3 = j - temp2
        return CartesianIndices((i - m + 1 : i, temp3 : temp3 + temp1))
    elseif direction == LEFT
        temp1 = n - 1
        temp2 = temp1 ÷ 2
        temp3 = i - temp2
        return CartesianIndices((temp3 : temp3 + temp1, j - m + 1 : j))
    else
        temp1 = n - 1
        temp2 = temp1 ÷ 2
        temp3 = j - temp2
        return CartesianIndices((i : i + m - 1, temp3 : temp3 + temp1))
    end
end

function map_index((i,j), (m, n), direction)
    if direction == RIGHT
        return (j, n-i+1)
    elseif direction == UP
        return (m-i+1, n-j+1)
    elseif direction == LEFT
        return (m-j+1, i)
    else
        return (i,j)
    end
end

function get_sub_tile_map(tile_map, position, window_size, direction)
    num_objects = size(tile_map, 1)
    sub_tile_map = falses(num_objects, window_size...)
    get_sub_tile_map!(sub_tile_map, tile_map, position, window_size, direction)
    return sub_tile_map
end

function get_sub_tile_map!(sub_tile_map, tile_map, position, window_size, direction)
    _, height, width = size(tile_map)

    window_region = get_window_region(position.I, window_size, direction)

    valid_region = CartesianIndices((1 : height, 1 : width))

    @views for key in keys(window_region)
        pos = window_region[key]
        if pos in valid_region
            sub_tile_map[:, map_index(key.I, window_size, direction)...] .= tile_map[:, pos]
        end
    end

    return nothing
end

#####
##### sampling tile map positions
#####

function sample_empty_position(rng, tile_map, region, max_tries)
    position = rand(rng, region)

    for i in 1:max_tries
        if any(@view tile_map[:, position])
            position = rand(rng, region)
        else
            return position
        end
    end

    @warn "Could not sample an empty position in max_tries = $(max_tries). Returning non-empty position: $(position)"

    return position
end

function sample_empty_position(rng, tile_map, region)
    max_tries = 1024 * length(region)
    position = sample_empty_position(rng, tile_map, region, max_tries)
    return position
end

function sample_empty_position(rng, tile_map, max_tries::Integer)
    _, height, width = size(tile_map)
    region = CartesianIndices((1 : height, 1 : width))
    position = sample_empty_position(rng, tile_map, region, max_tries)
    return position
end

function sample_empty_position(rng, tile_map)
    _, height, width = size(tile_map)
    region = CartesianIndices((1 : height, 1 : width))
    max_tries = 1024 * height * width
    position = sample_empty_position(rng, tile_map, region, max_tries)
    return position
end

function sample_two_positions_without_replacement(rng, region)
    position1 = rand(rng, region)
    position2 = rand(rng, region)

    while position1 == position2
        position2 = rand(rng, region)
    end

    return position1, position2
end
