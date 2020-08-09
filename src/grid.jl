using MacroTools:@forward

const UP = CartesianIndex(-1,0)
const DOWN = CartesianIndex(1,0)
const LEFT = CartesianIndex(0, -1)
const RIGHT = CartesianIndex(0, 1)

abstract type AbstractObject end

struct Empty <: AbstractObject end
const EMPTY = Empty()
struct Wall <: AbstractObject end
const WALL = Wall()
struct Agent <: AbstractObject end
const AGENT = Agent()

struct GridWorldBase{O} <: AbstractArray{Bool, 3}
    world::BitArray{3}
    objects::O
end

function GridWorldBase(x::Int, y::Int, objects::AbstractObject...)
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

Base.setindex!(w::GridWorldBase, v::Bool, x::AbstractObject, I::CartesianIndex{2}) = setindex!(w.world, v, Base.to_index(w, x), I)

function Base.setindex!(w::GridWorldBase, x::AbstractObject, I::CartesianIndex{2})
    w[:, I] .= false
    w[Base.to_index(w,x),I] = true
end

function Base.setindex!(w::GridWorldBase, X::Tuple{Vararg{AbstractObject}}, I::CartesianIndex{2})
    w[:, I] .= false
    for x in X
        w[Base.to_index(w, x), I] = true
    end
end

Base.getindex(w::GridWorldBase, x::AbstractObject, I::CartesianIndex{2}) = getindex(w.world, Base.to_index(w, x), I)

function switch!(world::GridWorldBase, x::AbstractObject, src::CartesianIndex{2}, dest::CartesianIndex{2})
    world[x, src], world[x, dest] = world[x, dest], world[x, src]
end

function switch!(world::GridWorldBase, X::Tuple{Vararg{AbstractObject}}, src::CartesianIndex{2}, dest::CartesianIndex{2})
    for x in X
        switch!(world, x, src, dest)
    end
end

function switch!(world::GridWorldBase, src::CartesianIndex{2}, dest::CartesianIndex{2})
    switch!(world, world.objects, src, dest)
end
