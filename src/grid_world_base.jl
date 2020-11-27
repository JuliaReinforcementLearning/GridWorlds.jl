export GridWorldBase
export get_objects

using MacroTools:@forward
using Random

"""
    GridWorldBase{O} <: AbstractArray{Bool, 3}

A basic representation of grid world.
The first dimension uses multi-hot encoding to encode objects in a tile.
The second and third dimension means the height and width of the grid.
"""
struct GridWorldBase{O} <: AbstractArray{Bool, 3}
    grid::BitArray{3}
    objects::O
end

get_grid(world::GridWorldBase) = world.grid
get_objects(world::GridWorldBase) = world.objects

function GridWorldBase(objects::Tuple{Vararg{AbstractObject}}, height::Int, width::Int)
    grid = BitArray{3}(undef, length(objects), height, width)
    fill!(grid, false)
    GridWorldBase(grid, objects)
end

@forward GridWorldBase.grid Base.size, Base.getindex, Base.setindex!

@generated function Base.to_index(::GridWorldBase{O}, object::X) where {X<:AbstractObject, O}
    i = findfirst(X .=== O.parameters)
    isnothing(i) && error("unknow object $object")
    :($i)
end

Base.setindex!(world::GridWorldBase, ispresent::Bool, object::AbstractObject, height::Int, width::Int) = setindex!(world.grid, ispresent, Base.to_index(world, object), height, width)
Base.setindex!(world::GridWorldBase, ispresent::Bool, object::AbstractObject, pos::CartesianIndex{2}) = setindex!(world, ispresent, object, pos[1], pos[2])

Base.getindex(world::GridWorldBase, object::AbstractObject, height::Int, width::Int) = getindex(world.grid, Base.to_index(world, object), height, width)
Base.getindex(world::GridWorldBase, object::AbstractObject, pos::CartesianIndex{2}) = getindex(world, object, pos[1], pos[2])
Base.getindex(world::GridWorldBase, object::AbstractObject, heights::Colon, widths::Colon) = getindex(world.grid, Base.to_index(world, object), heights, widths)

#####
# utils
#####

switch!(world::GridWorldBase, x, src::CartesianIndex{2}, dest::CartesianIndex{2}) = world[x, src], world[x, dest] = world[x, dest], world[x, src]

function switch!(world::GridWorldBase, src::CartesianIndex{2}, dest::CartesianIndex{2})
    for x in axes(world, 1)
        switch!(world, x, src, dest)
    end
end

function Random.rand(f::Function, world::GridWorldBase; max_try = typemax(Int), rng=Random.GLOBAL_RNG)
    inds = CartesianIndices((size(world, 2), size(world, 3)))
    for _ in 1:max_try
        pos = rand(rng, inds)
        f(view(world, :, pos)) && return pos
    end
    @warn "a rare case happened when sampling from GridWorldBase"
    return nothing
end

#####
# get_agent_view
#####

get_agent_view_inds((i, j), (m, n), ::Left) = CartesianIndices((i-(n-1)÷2:i+(n-(n-1)÷2)-1, j-m+1:j))
get_agent_view_inds((i, j), (m, n), ::Right) = CartesianIndices((i-(n-1)÷2:i+(n-(n-1)÷2)-1, j:j+m-1))
get_agent_view_inds((i, j), (m, n), ::Up) = CartesianIndices((i-m+1:i, j-(n-1)÷2:j+(n-(n-1)÷2)-1))
get_agent_view_inds((i, j), (m, n), ::Down) = CartesianIndices((i:i+m-1, j-(n-1)÷2:j+(n-(n-1)÷2)-1))

ind_map((i,j), (m, n), ::Left) = (m-j+1, i)
ind_map((i,j), (m, n), ::Right) = (j, n-i+1)
ind_map((i,j), (m, n), ::Up) = (m-i+1, n-j+1)
ind_map((i,j), (m, n), ::Down) = (i,j)

function get_agent_view!(agent_view::AbstractArray{Bool,3}, grid::AbstractArray{Bool,3}, agent_pos::CartesianIndex{2}, dir::Direction)
    view_size = (size(agent_view, 2), size(agent_view, 3))
    grid_size = (size(grid,2),size(grid,3))
    inds = get_agent_view_inds(agent_pos.I, view_size, dir)
    valid_inds = CartesianIndices(grid_size)
    for ind in CartesianIndices(inds)
        if inds[ind] ∈ valid_inds
            agent_view[:, ind_map(ind.I, view_size, dir)...] .= grid[:, inds[ind]]
        end
    end
    agent_view
end
