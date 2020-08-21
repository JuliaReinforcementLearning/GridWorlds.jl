using MacroTools:@forward
using Random
using StatsBase

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
struct DOOR <: AbstractObject end
struct Door <: AbstractObject end
const DOOR = Door()

####
# Colors
####
abstract type Color <: AbstractObject end

struct Red <: Color end
const RED = Red()
struct Green <: Color end
const GREEN = Green()
struct Blue <: Color end
const BLUE = Blue()
struct Purple <: Color end
const PURPLE = Purple()
struct Yellow <: Color end
const YELLOW = Yellow()
struct Grey <: Color end
const GREY = Grey()

const COLORS = [RED,GREEN,BLUE,PURPLE,YELLOW,GREY]

abstract type AbstractGridWorld end

struct GridWorldBase{O} <: AbstractArray{Bool, 3}
    world::BitArray{3}
    objects::O
end

function GridWorldBase(x::Int, y::Int, objects::Tuple{Vararg{AbstractObject}})
    world = BitArray{3}(undef, x, y, length(objects))
    fill!(world, false)
    GridWorldBase(world, objects)
end

@forward GridWorldBase.world Base.size, Base.getindex, Base.setindex!

@generated function Base.to_index(::GridWorldBase{O}, x::X) where {X<:AbstractObject, O}
    i = findfirst(X .=== O.parameters)
    isnothing(i) && error("unknow object $x")
    :($i)
end



Base.setindex!(w::GridWorldBase, v::Bool, x::Int, y::Int, o::AbstractObject) = setindex!(w.world, v, x, y, Base.to_index(w, o))
Base.setindex!(w::GridWorldBase, v::Bool, i::CartesianIndex{2}, o::AbstractObject) = setindex!(w.world, v, i[1], i[2], Base.to_index(w, o))

function Base.setindex!(w::GridWorldBase, x::Int, y::Int, o::AbstractObject)
    w[x,y, :] .= false
    w[x,y, Base.to_index(w,x)] = true
end

function Base.setindex!(w::GridWorldBase, X::Tuple{Vararg{AbstractObject}}, I...)
    w[x,y, :] .= false
    for x in X
        w[x,y, Base.to_index(w, x)] = true
    end
end

Base.getindex(w::GridWorldBase, x::Int, y::Int, o::AbstractObject) = getindex(w.world, x, y, Base.to_index(w, o) )
Base.getindex(w::GridWorldBase, i::CartesianIndex{2}, o::AbstractObject) = getindex(w.world, i[1], i[2], Base.to_index(w, o) )

function switch!(world::GridWorldBase, x::AbstractObject, src::CartesianIndex{2}, dest::CartesianIndex{2})
    world[src, x], world[dest, x] = world[dest, x], world[src, x]
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
