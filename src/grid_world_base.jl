"""
    GridWorldBase{O} <: AbstractArray{Bool, 3}

A basic representation of grid world.
The first dimension uses multi-hot encoding to encode objects in a tile.
The second and third dimensions correspond to the height and width of the grid respectively.
"""
struct GridWorldBase{O} <: AbstractArray{Bool, 3}
    grid::BitArray{3}
    objects::O
end

function GridWorldBase(objects::Tuple{Vararg{AbstractObject}}, height::Int, width::Int)
    grid = falses(length(objects), height, width)
    GridWorldBase(grid, objects)
end

get_grid(world::GridWorldBase) = world.grid
get_objects(world::GridWorldBase) = world.objects

get_num_objects(grid::AbstractArray{Bool, 3}) = size(grid, 1)
get_height(grid::AbstractArray{Bool, 3}) = size(grid, 2)
get_width(grid::AbstractArray{Bool, 3}) = size(grid, 3)

#####
# Indexing of GridWorldBase objects
#####

@forward GridWorldBase.grid Base.size, Base.getindex, Base.setindex!

@generated function Base.to_index(::GridWorldBase{O}, object::X) where {X<:AbstractObject, O}
    i = findfirst(X .=== O.parameters)
    isnothing(i) && error("unknow object $object")
    :($i)
end

Base.getindex(world::GridWorldBase, object::AbstractObject, args...) = getindex(get_grid(world), Base.to_index(world, object), args...)
Base.setindex!(world::GridWorldBase, value::Bool, object::AbstractObject, args...) = setindex!(get_grid(world), value, Base.to_index(world, object), args...)

#####
# methods for agent view
#####

function get_grid_inds((i, j), (m, n))
    temp1 = m ÷ 2
    temp2 = i - temp1
    temp3 = n ÷ 2
    temp4 = j - temp3
    return CartesianIndices((temp2 : temp2 + m - 1, temp4 : temp4 + n - 1))
end

function get_grid_inds((i, j), (m, n), ::Up)
    temp1 = n - 1
    temp2 = temp1 ÷ 2
    temp3 = j - temp2
    return CartesianIndices((i - m + 1 : i, temp3 : temp3 + temp1))
end

function get_grid_inds((i, j), (m, n), ::Down)
    temp1 = n - 1
    temp2 = temp1 ÷ 2
    temp3 = j - temp2
    return CartesianIndices((i : i + m - 1, temp3 : temp3 + temp1))
end

function get_grid_inds((i, j), (m, n), ::Left)
    temp1 = n - 1
    temp2 = temp1 ÷ 2
    temp3 = i - temp2
    return CartesianIndices((temp3 : temp3 + temp1, j - m + 1 : j))
end

function get_grid_inds((i, j), (m, n), ::Right)
    temp1 = n - 1
    temp2 = temp1 ÷ 2
    temp3 = i - temp2
    return CartesianIndices((temp3 : temp3 + temp1, j : j + m - 1))
end

map_ind((i,j), (m, n), ::Up) = (m-i+1, n-j+1)
map_ind((i,j), (m, n), ::Down) = (i,j)
map_ind((i,j), (m, n), ::Left) = (m-j+1, i)
map_ind((i,j), (m, n), ::Right) = (j, n-i+1)

function get_grid(src_grid::AbstractArray{Bool, 3}, pos::CartesianIndex{2}, dir::AbstractDirection, window_size, layers)
    dest_grid = falses(length(layers), window_size...)
    get_grid!(dest_grid, src_grid, pos, dir, window_size, layers)
    return dest_grid
end

function get_grid!(dest_grid::AbstractArray{Bool, 3}, src_grid::AbstractArray{Bool, 3}, pos::CartesianIndex{2}, dir::AbstractDirection, window_size, layers)
    window_inds = get_grid_inds(pos.I, window_size, dir)

    valid_inds = CartesianIndices((get_height(src_grid), get_width(src_grid)))

    @views for ind in CartesianIndices(window_inds)
        pos = window_inds[ind]
        if pos ∈ valid_inds
            dest_grid[:, map_ind(ind.I, window_size, dir)...] .= src_grid[layers, pos]
        end
    end

    return nothing
end

function get_grid(src_grid::AbstractArray{Bool, 3}, pos::CartesianIndex{2}, window_size, layers)
    dest_grid = falses(length(layers), window_size...)
    get_grid!(dest_grid, src_grid, pos, window_size, layers)
    return dest_grid
end

function get_grid!(dest_grid::AbstractArray{Bool, 3}, src_grid::AbstractArray{Bool, 3}, pos::CartesianIndex{2}, window_size, layers)
    window_inds = get_grid_inds(pos.I, window_size)

    valid_inds = CartesianIndices((get_height(src_grid), get_width(src_grid)))

    @views for ind in CartesianIndices(window_inds)
        pos = window_inds[ind]
        if pos ∈ valid_inds
            dest_grid[:, ind.I...] .= src_grid[layers, pos]
        end
    end

    return nothing
end

#####
# utils
#####

function Random.rand(rng::Random.AbstractRNG, f::Function, inds::Union{Vector{CartesianIndex{2}}, CartesianIndices{2}}; max_try::Int = 1000)
    for _ in 1:max_try
        pos = rand(rng, inds)
        if f(pos)
            return pos
        end
    end
    @warn "number of tries exceeded max_try = $max_try"
    return inds[1]
end

function Random.rand(rng::Random.AbstractRNG, f::Function, world::GridWorldBase; max_try = 1000)
    inds = CartesianIndices((get_height(world), get_width(world)))
    rand(rng, f, inds, max_try = max_try)
end
