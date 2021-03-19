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

get_grid_inds((i, j), (m, n)) = CartesianIndices((i-m÷2:i-m÷2+m-1, j-n÷2:j-n÷2+n-1))
get_grid_inds((i, j), (m, n), ::Up) = CartesianIndices((i-m+1:i, j-(n-1)÷2:j+(n-(n-1)÷2)-1))
get_grid_inds((i, j), (m, n), ::Down) = CartesianIndices((i:i+m-1, j-(n-1)÷2:j+(n-(n-1)÷2)-1))
get_grid_inds((i, j), (m, n), ::Left) = CartesianIndices((i-(n-1)÷2:i+(n-(n-1)÷2)-1, j-m+1:j))
get_grid_inds((i, j), (m, n), ::Right) = CartesianIndices((i-(n-1)÷2:i+(n-(n-1)÷2)-1, j:j+m-1))

map_ind((i,j), (m, n), ::Up) = (m-i+1, n-j+1)
map_ind((i,j), (m, n), ::Down) = (i,j)
map_ind((i,j), (m, n), ::Left) = (m-j+1, i)
map_ind((i,j), (m, n), ::Right) = (j, n-i+1)

function get_grid(src_grid::AbstractArray{Bool, 3}, window_size, pos::CartesianIndex{2}, dir::AbstractDirection)
    dest_grid = falses(get_num_objects(src_grid), window_size...)
    get_grid!(dest_grid, src_grid, pos, dir)
    return dest_grid
end

function get_grid!(dest_grid::AbstractArray{Bool, 3}, src_grid::AbstractArray{Bool, 3}, pos::CartesianIndex{2}, dir::AbstractDirection)
    window_size = (get_height(dest_grid), get_width(dest_grid))
    window_inds = get_grid_inds(pos.I, window_size, dir)

    valid_inds = CartesianIndices((get_height(src_grid), get_width(src_grid)))

    for ind in CartesianIndices(window_inds)
        pos = window_inds[ind]
        if pos ∈ valid_inds
            dest_grid[:, map_ind(ind.I, window_size, dir)...] .= src_grid[:, pos]
        end
    end

    return dest_grid
end

function get_grid(src_grid::AbstractArray{Bool, 3}, window_size, pos::CartesianIndex{2})
    dest_grid = falses(get_num_objects(src_grid), window_size...)
    get_grid!(dest_grid, src_grid, pos)
    return dest_grid
end

function get_grid!(dest_grid::AbstractArray{Bool, 3}, src_grid::AbstractArray{Bool, 3}, pos::CartesianIndex{2})
    window_size = (get_height(dest_grid), get_width(dest_grid))
    window_inds = get_grid_inds(pos.I, window_size)

    valid_inds = CartesianIndices((get_height(src_grid), get_width(src_grid)))

    for ind in CartesianIndices(window_inds)
        pos = window_inds[ind]
        if pos ∈ valid_inds
            dest_grid[:, ind.I...] .= src_grid[:, pos]
        end
    end

    return dest_grid
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
    return nothing
end

function Random.rand(rng::Random.AbstractRNG, f::Function, world::GridWorldBase; max_try = 1000)
    inds = CartesianIndices((get_height(world), get_width(world)))
    rand(rng, f, inds, max_try = max_try)
end
