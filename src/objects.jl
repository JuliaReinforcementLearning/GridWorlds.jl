export COLORS, MOVE_FORWARD, TURN_LEFT, TURN_RIGHT, UP, DOWN, LEFT, RIGHT, LRUD, EMPTY, WALL, GOAL, GEM
export MoveForward, AbstractObject, Empty, Wall, Goal, Door, Gem, Agent
export get_color

using Crayons
using Colors

const COLORS = (:red, :green, :blue, :magenta, :yellow, :white)

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

struct TurnRight end
const TURN_RIGHT = TurnRight()
struct TurnLeft end
const TURN_LEFT = TurnLeft()

(x::TurnRight)(::Left) = UP
(x::TurnRight)(::Up) = RIGHT
(x::TurnRight)(::Right) = DOWN
(x::TurnRight)(::Down) = LEFT
(x::TurnLeft)(::Left) = DOWN
(x::TurnLeft)(::Up) = LEFT
(x::TurnLeft)(::Right) = UP
(x::TurnLeft)(::Down) = RIGHT

#####
# Objects
#####

abstract type AbstractObject end

Base.show(io::IO, x::AbstractObject) = print(io, Crayon(foreground=get_color(x), reset=true), convert(Char, x))

struct Empty <: AbstractObject end
const EMPTY = Empty()
Base.convert(::Type{Char}, ::Empty) = '⋅'
get_color(::Empty) = :white

struct Wall <: AbstractObject end
const WALL = Wall()
Base.convert(::Type{Char}, ::Wall) = '█'
get_color(::Wall) = :white

struct Goal <: AbstractObject end
const GOAL = Goal()
Base.convert(::Type{Char}, ::Goal) = '♥'
get_color(::Goal) = :red

struct Door{C} <: AbstractObject end
Door(c) = Door{c}()
Base.convert(::Type{Char}, ::Door) = '⩎'
get_color(::Door{C}) where C = C

struct Key{C} <: AbstractObject end
Key(c) = Key{c}()
Base.convert(::Type{Char}, ::Key) = '⚷'
get_color(::Key{C}) where C = C

struct Gem <: AbstractObject end
const GEM = Gem()
Base.convert(::Type{Char}, ::Gem) = '♦'
get_color(::Gem) = :magenta

abstract type AbstractAgent <: AbstractObject end

Base.@kwdef mutable struct Agent <: AbstractAgent
    color::Symbol=:red
    dir::LRUD
    inv::Union{AbstractObject, Nothing}=nothing
end

Base.@kwdef mutable struct Array_agent <: AbstractAgent
    color::Symbol=:red
    dir::LRUD
    inv::Vector{Union{AbstractObject, Nothing}}=[]
end
function Array_agent(dir::LRUD, len::Integer; color::Symbol=:red)
    Array_agent(color, dir, Vector{Union{AbstractObject, Nothing}}(nothing, len))
end

function Base.convert(::Type{Char}, a::AbstractAgent)
    if        a.dir === UP
        '↑'
    elseif  a.dir === DOWN
        '↓'
    elseif  a.dir === LEFT
        '←'
    elseif a.dir === RIGHT
        '→'
    end
end
get_color(a::AbstractAgent) = a.color
get_dir(a::AbstractAgent) = a.dir
set_dir!(a::AbstractAgent, d) = a.dir = d

#####
# Pick Up and Drop
#####

struct Transportable end
struct Nontransportable end
const TRANSPORTABLE = Transportable()
const NONTRANSPORTABLE = Nontransportable()
istransportable(::Type{<:Key}) = TRANSPORTABLE
istransportable(::Type{Gem}) = TRANSPORTABLE
istransportable(x::AbstractObject) = istransportable(typeof(x))

struct Pickup end
const PICKUP = Pickup()

struct Drop end
const DROP = Drop()

(::Pickup)(a::AbstractAgent, o::T) where T = PICKUP(istransportable(T), a, o)
function (::Pickup)(::Transportable, a::Agent, o::AbstractObject) 
    if a.inv == nothing
        a.inv = o
        return true
    end
    return false
end
function (::Pickup)(::Transportable, a::Array_agent, o::AbstractObject) 
    for (i, v) in enumerate(a.inv) # Picked up objects go into the first empty index
        if v == nothing
            a.inv[i] = o
            return true
        end
    end
    return false
end
pickup(::Nontransportable, a::AbstractAgent, o::AbstractObject) = nothing

function (::Drop)(a::Agent)
    if a.inv != nothing
        x = a.inv
        a.inv = nothing
        return x
    end
    return nothing
end
function (::Drop)(a::Array_agent)
    for (i, v) in Iterators.reverse(enumerate(a.inv)) # Most recently picked up objects are dropped first
        if typeof(v)<:AbstractObject
            a.inv[i] = nothing
            return v
        end
    end
    return nothing
end
