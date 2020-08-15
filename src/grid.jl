using MacroTools:@forward
using Random

#####
# Actions
#####

struct MoveForward end
const MOVE_FORWARD = MoveForward()

struct Up end
const UP = Up()
(x::Up)(p::CartesianIndex{2}) = p + CartesianIndex(-1, 0)

struct Down end
const DOWN = Down()
(x::Down)(p::CartesianIndex{2}) = p + CartesianIndex(1, 0)

struct Left end
const LEFT = Left()
(x::Left)(p::CartesianIndex{2}) = p + CartesianIndex(0, -1)

struct Right end
const RIGHT = Right()
(x::Right)(p::CartesianIndex{2}) = p + CartesianIndex(0, 1)

const LRUD = Union{Left, Right, Up, Down}

struct TurnClockwise end
const TURN_CLOCKWISE = TurnClockwise()
struct TurnCounterclockwise end
const TURN_COUNTERCLOCKWISE = TurnCounterclockwise()

(x::TurnClockwise)(::Left) = UP
(x::TurnClockwise)(::Up) = RIGHT
(x::TurnClockwise)(::Right) = DOWN
(x::TurnClockwise)(::Down) = LEFT
(x::TurnCounterclockwise)(::Left) = DOWN
(x::TurnCounterclockwise)(::Up) = LEFT
(x::TurnCounterclockwise)(::Right) = UP
(x::TurnCounterclockwise)(::Down) = RIGHT

#####
# Objects
#####
abstract type AbstractObject end

struct Empty <: AbstractObject end
const EMPTY = Empty()
struct Wall <: AbstractObject end
const WALL = Wall()
struct Agent <: AbstractObject end
const AGENT = Agent()
struct Goal <: AbstractObject end
const GOAL = Goal()

abstract type AbstractGridWorld end

struct GridWorldBase{O} <: AbstractArray{Bool, 3}
    world::BitArray{3}
    objects::O
end

function GridWorldBase(x::Int, y::Int, objects::Tuple{Vararg{AbstractObject}})
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

Base.setindex!(w::GridWorldBase, v::Bool, x::AbstractObject, I...) = setindex!(w.world, v, Base.to_index(w, x), I...)

function Base.setindex!(w::GridWorldBase, x::AbstractObject, I...)
    w[:, I...] .= false
    w[Base.to_index(w,x),I...] = true
end

function Base.setindex!(w::GridWorldBase, X::Tuple{Vararg{AbstractObject}}, I...)
    w[:, I...] .= false
    for x in X
        w[Base.to_index(w, x), I...] = true
    end
end

Base.getindex(w::GridWorldBase, x::AbstractObject, I...) = getindex(w.world, Base.to_index(w, x), I...)

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

Random.rand(f::Function, w::GridWorldBase, max_try=typemax(Int)) = rand(Random.GLOBAL_RNG, f, w, max_try)

function Random.rand(rng::AbstractRNG, f::Function, w::GridWorldBase, max_try=typemax(Int))
    inds = CartesianIndices((size(w, 2), size(w, 3)))
    for _ in 1:max_try
        pos = rand(rng, inds)
        f(view(w, :, pos)) && return pos
    end
    @warn "a rare case happened when sampling from GridWorldBase"
    return nothing
end

# coordinate transform for Makie.jl
transform(x::Int) = p -> CartesianIndex(p[2], x-p[1]+1)
