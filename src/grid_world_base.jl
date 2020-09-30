using MacroTools:@forward
using Random

"""
    GridWorldBase{O} <: AbstractArray{Bool, 3}

A basic representation of grid world.
The first dimension uses multi-hot encoding to encode objects in a tile.
The second and third dimension means the height and width of the grid.
"""
struct GridWorldBase{O} <: AbstractArray{Bool, 3}
    world::BitArray{3}
    objects::O
end

function GridWorldBase(objects::Tuple{Vararg{AbstractObject}}, x::Int, y::Int)
    world = BitArray{3}(undef, length(objects), x, y)
    fill!(world, false)
    GridWorldBase(world, objects)
end

@forward GridWorldBase.world Base.size, Base.getindex, Base.setindex!

@generated function Base.to_index(::GridWorldBase{O}, x::X) where {X<:AbstractObject, O}
    i = findfirst(X .=== O.parameters)
    isnothing(i) && error("unknow object $x")
    :($i)
end

Base.setindex!(w::GridWorldBase, v::Bool, o::AbstractObject, x::Int, y::Int) = setindex!(w.world, v, Base.to_index(w, o), x, y)
Base.setindex!(w::GridWorldBase, v::Bool, o::AbstractObject, i::CartesianIndex{2}) = setindex!(w, v, o, i[1], i[2])

Base.getindex(w::GridWorldBase, o::AbstractObject, x::Int, y::Int) = getindex(w.world, Base.to_index(w, o), x, y)
Base.getindex(w::GridWorldBase, o::AbstractObject, i::CartesianIndex{2}) = getindex(w, o, i[1], i[2])

#####
# utils
#####

switch!(world::GridWorldBase, x, src::CartesianIndex{2}, dest::CartesianIndex{2}) = world[x, src], world[x, dest] = world[x, dest], world[x, src]

function switch!(world::GridWorldBase, src::CartesianIndex{2}, dest::CartesianIndex{2})
    for x in axes(world, 1)
        switch!(world, x, src, dest)
    end
end

function Random.rand(f::Function, w::GridWorldBase; max_try=typemax(Int), rng=Random.GLOBAL_RNG)
    inds = CartesianIndices((size(w, 2), size(w, 3)))
    for _ in 1:max_try
        pos = rand(rng, inds)
        f(view(w, :, pos)) && return pos
    end
    @warn "a rare case happened when sampling from GridWorldBase"
    return nothing
end

#####
# get_agent_view
#####

"""
⇤m⇥
■■S⤒
■■←n
■■■⤓
"""
function get_agent_view!(v::AbstractArray{Bool,3}, a::AbstractArray{Bool,3}, p::CartesianIndex, ::Left)
    fill!(v, false)
    l, m, n = size(v)
    start = p + CartesianIndex(-(n-1)÷2,0)
    valid_inds = CartesianIndices((size(a,2),size(a,3)))
    for j in 0:n-1
        for i in 0:m-1
            cur = start+CartesianIndex(j, -i)
            if cur ∈ valid_inds
                for k in 1:l
                    v[k, i+1,j+1] = a[k, cur]
                end
            end
        end
    end
    v
end

"""
⤒■■■
n→■■
⤓S■■
 ⇤m⇥
"""
function get_agent_view!(v::AbstractArray{Bool,3}, a::AbstractArray{Bool,3}, p::CartesianIndex, ::Right)
    fill!(v, false)
    l, m, n = size(v)
    start = p + CartesianIndex((n-1)÷2,0)
    valid_inds = CartesianIndices((size(a,2),size(a,3)))
    for j in 0:n-1
        for i in 0:m-1
            cur = start+CartesianIndex(-j, i)
            if cur ∈ valid_inds
                for k in 1:l
                    v[k, i+1,j+1] = a[k, cur]
                end
            end
        end
    end
    v
end

"""
■■■⤒
■■■m
■↑S⤓
⇤n⇥
"""
function get_agent_view!(v::AbstractArray{Bool,3}, a::AbstractArray{Bool,3}, p::CartesianIndex, ::Up)
    fill!(v, false)
    l, m, n = size(v)
    start = p + CartesianIndex(0, (n-1)÷2)
    valid_inds = CartesianIndices((size(a,2),size(a,3)))
    for j in 0:n-1
        for i in 0:m-1
            cur = start+CartesianIndex(-i,-j)
            if cur ∈ valid_inds
                for k in 1:l
                    v[k, i+1,j+1] = a[k, cur]
                end
            end
        end
    end
    v
end

"""
 ⇤n⇥
⤒S↓■
m■■■
⤓■■■
"""
function get_agent_view!(v::AbstractArray{Bool,3}, a::AbstractArray{Bool,3}, p::CartesianIndex, ::Down)
    fill!(v, false)
    l, m, n = size(v)
    start = p + CartesianIndex(0, -(n-1)÷2)
    valid_inds = CartesianIndices((size(a,2),size(a,3)))
    for j in 0:n-1
        for i in 0:m-1
            cur = start+CartesianIndex(i,j)
            if cur ∈ valid_inds
                for k in 1:l
                    v[k, i+1,j+1] = a[k, cur]
                end
            end
        end
    end
    v
end