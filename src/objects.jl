export COLORS, EMPTY, WALL, GOAL, GEM, OBSTACLE
export AbstractObject, Empty, Wall, Goal, Door, Key, Gem, Obstacle, Agent
export get_color, get_dir, set_dir!

using Crayons
using Colors

const COLORS = (:red, :green, :blue, :magenta, :yellow, :white)

#####
# Objects
#####

abstract type AbstractObject end

Base.show(io::IO, object::AbstractObject) = print(io, Crayon(foreground = get_color(object), reset = true), convert(Char, object))

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

struct Obstacle <: AbstractObject end
const OBSTACLE = Obstacle()
Base.convert(::Type{Char}, ::Obstacle) = '⊗'
get_color(::Obstacle) = :blue    

#####
# Agent
#####

Base.@kwdef mutable struct Agent <: AbstractObject
    color::Symbol=:red
    dir::Direction
    inventory::Union{Nothing, AbstractObject, Vector}=nothing
end

function Base.convert(::Type{Char}, a::Agent)
    if     a.dir === UP
        '↑'
    elseif a.dir === DOWN
        '↓'
    elseif a.dir === LEFT
        '←'
    elseif a.dir === RIGHT
        '→'
    end
end

get_color(agent::Agent) = agent.color
get_dir(agent::Agent) = agent.dir
set_dir!(agent::Agent, dir) = agent.dir = dir

struct Transportable end
const TRANSPORTABLE = Transportable()

struct NonTransportable end
const NONTRANSPORTABLE = NonTransportable()

istransportable(::Type{<:AbstractObject}) = NONTRANSPORTABLE
istransportable(::Type{<:Key}) = TRANSPORTABLE
istransportable(::Type{Gem}) = TRANSPORTABLE
istransportable(x::AbstractObject) = istransportable(typeof(x))

(x::Pickup)(a::Agent, o) = x(istransportable(o), a, o)

(::Pickup)(::NonTransportable, a::Agent, o::AbstractObject) = false

function (::Pickup)(::Transportable, a::Agent, o::AbstractObject) 
    if isnothing(a.inventory)
        a.inventory = o
        true
    elseif a.inventory isa Vector
        i = findfirst(isnothing, a.v)
        if isnothing(i)
            false
        else
            a.inventory[i] = o
            true
        end
    else
        false
    end
end

function (::Drop)(a::Agent)
    if isnothing(a.inventory)
        nothing
    elseif a.inventory isa AbstractObject
        x = a.inventory
        a.inventory = nothing
        x
    elseif a.inventory isa Vector
        i = findlast(x -> x isa AbstractObject, a.inventory)
        if isnothing(i)
            nothing
        else
            x = a.inventory[i]
            a.inventory[i] = nothing
            x
        end
    else
        @error "unknown inventory type $(a.inventory)"
    end
end
