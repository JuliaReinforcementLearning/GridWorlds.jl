export GridWorldBase
export get_grid, get_objects, get_num_objects, get_height, get_width, switch!, get_agent_view!

import MacroTools
import Random

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
    grid = BitArray{3}(undef, length(objects), height, width)
    fill!(grid, false)
    GridWorldBase(grid, objects)
end

get_grid(world::GridWorldBase) = world.grid
get_objects(world::GridWorldBase) = world.objects

get_num_objects(grid::BitArray{3}) = size(grid, 1)
get_height(grid::BitArray{3}) = size(grid, 2)
get_width(grid::BitArray{3}) = size(grid, 3)

get_num_objects(world::GridWorldBase) = world |> get_grid |> get_num_objects
get_height(world::GridWorldBase) = world |> get_grid |> get_height
get_width(world::GridWorldBase) = world |> get_grid |> get_width

MacroTools.@forward GridWorldBase.grid Base.size, Base.getindex, Base.setindex!

@generated function Base.to_index(::GridWorldBase{O}, object::X) where {X<:AbstractObject, O}
    i = findfirst(X .=== O.parameters)
    isnothing(i) && error("unknow object $object")
    :($i)
end

Base.getindex(world::GridWorldBase, object::AbstractObject, height::Int, width::Int) = getindex(get_grid(world), Base.to_index(world, object), height, width)
Base.getindex(world::GridWorldBase, object::AbstractObject, pos::CartesianIndex{2}) = getindex(world, object, pos[1], pos[2])
Base.getindex(world::GridWorldBase, object::AbstractObject, heights::Colon, widths::Colon) = getindex(get_grid(world), Base.to_index(world, object), heights, widths)

Base.setindex!(world::GridWorldBase, ispresent::Bool, object::AbstractObject, height::Int, width::Int) = setindex!(get_grid(world), ispresent, Base.to_index(world, object), height, width)
Base.setindex!(world::GridWorldBase, ispresent::Bool, object::AbstractObject, pos::CartesianIndex{2}) = setindex!(world, ispresent, object, pos[1], pos[2])

#####
# utils
#####

switch!(world::GridWorldBase, x, src::CartesianIndex{2}, dest::CartesianIndex{2}) = world[x, src], world[x, dest] = world[x, dest], world[x, src]

function switch!(world::GridWorldBase, src::CartesianIndex{2}, dest::CartesianIndex{2})
    for x in axes(world, 1)
        switch!(world, x, src, dest)
    end
end

function Random.rand(rng::AbstractRNG, f::Function, inds::Union{Vector{CartesianIndex{2}}, CartesianIndices{2}}; max_try::Int = 1000)
    for _ in 1:max_try
        pos = rand(rng, inds)
        if f(pos)
            return pos
        end
    end
    @warn "number of tries exceeded max_try = $max_try"
    return nothing
end

function Random.rand(rng::AbstractRNG, f::Function, world::GridWorldBase; max_try = 1000)
    inds = CartesianIndices((get_height(world), get_width(world)))
    rand(rng, f, inds, max_try = max_try)
end

#####
# get_agent_view
#####

get_agent_view_inds((i, j), (m, n), ::Left) = CartesianIndices((i-(n-1)÷2:i+(n-(n-1)÷2)-1, j-m+1:j))
get_agent_view_inds((i, j), (m, n), ::Right) = CartesianIndices((i-(n-1)÷2:i+(n-(n-1)÷2)-1, j:j+m-1))
get_agent_view_inds((i, j), (m, n), ::Up) = CartesianIndices((i-m+1:i, j-(n-1)÷2:j+(n-(n-1)÷2)-1))
get_agent_view_inds((i, j), (m, n), ::Down) = CartesianIndices((i:i+m-1, j-(n-1)÷2:j+(n-(n-1)÷2)-1))

ind_map((i,j), (m, n), ::Up) = (m-i+1, n-j+1)
ind_map((i,j), (m, n), ::Down) = (i,j)
ind_map((i,j), (m, n), ::Left) = (m-j+1, i)
ind_map((i,j), (m, n), ::Right) = (j, n-i+1)

function get_agent_view!(agent_view::AbstractArray{Bool,3}, grid::AbstractArray{Bool,3}, agent_pos::CartesianIndex{2}, dir::Direction)
    view_size = (get_height(agent_view), get_width(agent_view))
    grid_size = (get_height(grid), get_width(grid))
    inds = get_agent_view_inds(agent_pos.I, view_size, dir)
    valid_inds = CartesianIndices(grid_size)
    for ind in CartesianIndices(inds)
        if inds[ind] ∈ valid_inds
            agent_view[:, ind_map(ind.I, view_size, dir)...] .= grid[:, inds[ind]]
        end
    end
    return agent_view
end
