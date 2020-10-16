export GridWorldBase

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

get_object(w::GridWorldBase) = w.objects

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
Base.getindex(w::GridWorldBase, o::AbstractObject, x::Colon, y::Colon) = getindex(w.world, Base.to_index(w, o), x, y)

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
# Occlusion
#####

radius(x, y) = √(x^2 + y^2)
radius(p::Tuple) = radius(p[1], p[2])
theta(x, y) = x == 0 ? sign(y)*π/2 : atan(y, x)
theta(p::Tuple) = theta(p[1], p[2])

struct PolarCoord
    θ::AbstractFloat
    r::AbstractFloat
end
PolarCoord(θ::Real, r::Real) = PolarCoord((θ + (r<0 && π)) % 2π, abs(r))
PolarCoord(p::Tuple) = PolarCoord(theta(p), radius(p))
PolarCoord(p::CartesianIndex) = PolarCoord(Tuple(p))

struct Shadow
    minθ::AbstractFloat
    maxθ::AbstractFloat
    r::AbstractFloat
end
function Shadow(p::CartesianIndex)
    r = radius(Tuple(p))
    corners = [(p[1]+x, p[2]+y) for x in -.5:.5, y in -.5:.5]
    corners = theta.(corners)
    Shadow(minimum(corners), maximum(corners), r)
end

"""
returns a 2D array of boolean values, where `true` represents an index which is
occluded by the shadow `s` evaluating `v`
"""
function (s::Shadow)(v::CartesianIndices)
    polar = PolarCoord.(v)
    f(x) = x.r > s.r && s.minθ <= x.θ <= s.maxθ
    f.(polar)
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

function get_agent_view!(v::AbstractArray{Bool,3}, a::AbstractArray{Bool,3}, p::CartesianIndex, dir::LRUD)
    view_size = (size(v, 2), size(v, 3))
    grid_size = (size(a,2),size(a,3))
    inds = get_agent_view_inds(p.I, view_size, dir)
    valid_inds = CartesianIndices(grid_size)
    for ind in CartesianIndices(inds)
        if inds[ind] ∈ valid_inds
            v[:, ind_map(ind.I, view_size, dir)...] .= a[:, inds[ind]]
        end
    end

    v
end
