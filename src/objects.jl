export COLORS, EMPTY, WALL, GOAL, GEM
export AbstractObject, Empty, Wall, Goal, Door, Key, Gem, Agent
export get_color, get_dir, set_dir!

using Crayons
using Colors

const COLORS = (:red, :green, :blue, :magenta, :yellow, :white)

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

#####
# Agent
#####

mutable struct Agent{I<:Union{Nothing, AbstractObject, Vector}} <: AbstractObject
    color::Symbol
    dir::LRUD
    inventory::I
end

Agent(;dir::LRUD, inventory=nothing, color::Symbol=:red) = Agent(color, dir, inventory)

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

get_color(a::Agent) = a.color
get_dir(a::Agent) = a.dir
set_dir!(a::Agent, d) = a.dir = d

struct Transportable end
struct Nontransportable end
const TRANSPORTABLE = Transportable()
const NONTRANSPORTABLE = Nontransportable()
istransportable(::Type{<:Key}) = TRANSPORTABLE
istransportable(::Type{Gem}) = TRANSPORTABLE
istransportable(x::AbstractObject) = istransportable(typeof(x))

(a::Pickup)(a::Agent, o) = a(istransportable(o), a, o)

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
    if isnothing(a.inv)
        nothing
    elseif a.inv isa AbstractObject
        x = a.inv
        a.inv = nothing
        x
    elseif a.inv isa Vector
        i = findlast(x -> x isa AbstractObject, a.inv)
        if isnothing(i)
            nothing
        else
            x = a.inv[i]
            a.inv[i] = nothing
            x
        end
    else
        @error "unknown inventory type $(a.inv)"
    end
end
