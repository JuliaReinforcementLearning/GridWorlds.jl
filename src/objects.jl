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
abstract type Item <: AbstractObject end

# Placeholder for empty inventory
struct Null <: Item end
const NULL = Null()

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

struct Key{C} <: Item end
Key(c) = Key{c}()
Base.convert(::Type{Char}, ::Key) = '⚷'
get_color(::Key{C}) where C = C

struct Gem <: Item end
const GEM = Gem()
Base.convert(::Type{Char}, ::Gem) = '♦'
get_color(::Gem) = :magenta

Base.@kwdef mutable struct Agent <: AbstractObject
    color::Symbol=:red
    dir::LRUD
    inv::Item=NULL
end
function Base.convert(::Type{Char}, a::Agent)
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
get_color(a::Agent) = a.color
get_dir(a::Agent) = a.dir
set_dir!(a::Agent, d) = a.dir = d

#####
# Pick Up and Drop
#####

function pickup(a::Agent, o::Item) 
    if a.Item == NULL 
        a.Item = o
        return true
    end
    return false
end
pickup(a::Agent, o::AbstractObject) = nothing

function drop(a::Agent)
    if a.item != NULL
        x = a.item
        a.item = NULL
        return x
    end
    return nothing
end

