export AbstractObject, Empty, Wall, Goal, Door, Key, Gem, Obstacle, Agent, Transportable, NonTransportable
export COLORS, EMPTY, WALL, GOAL, GEM, OBSTACLE, TRANSPORTABLE, NONTRANSPORTABLE
export get_char, get_color, get_dir, set_dir!, get_pos, set_pos!, istransportable, get_inventory_type, get_inventory, set_inventory!

import Crayons

const COLORS = (:red, :green, :blue, :magenta, :yellow, :white)

#####
# Objects
#####

abstract type AbstractObject end

Base.show(io::IO, object::AbstractObject) = print(io, Crayons.Crayon(foreground = get_color(object), reset = true), get_char(object))

struct Empty <: AbstractObject end
const EMPTY = Empty()
get_char(::Empty) = '⋅'
get_color(::Empty) = :white

struct Wall <: AbstractObject end
const WALL = Wall()
get_char(::Wall) = '█'
get_color(::Wall) = :white

struct Goal <: AbstractObject end
const GOAL = Goal()
get_char(::Goal) = '♥'
get_color(::Goal) = :red

struct Door{C} <: AbstractObject end
Door(c) = Door{c}()
get_char(::Door) = '⩎'
get_color(::Door{C}) where C = C

struct Key{C} <: AbstractObject end
Key(c) = Key{c}()
get_char(::Key) = '⚷'
get_color(::Key{C}) where C = C

struct Gem <: AbstractObject end
const GEM = Gem()
get_char(::Gem) = '♦'
get_color(::Gem) = :magenta

struct Obstacle <: AbstractObject end
const OBSTACLE = Obstacle()
get_char(::Obstacle) = '⊗'
get_color(::Obstacle) = :blue    

#####
# Agent
#####

mutable struct Agent{I} <: AbstractObject
    pos::CartesianIndex
    dir::Direction
    inventory::I
    color::Symbol
end

function Agent(; inventory_type = Union{Nothing, AbstractObject}, pos = CartesianIndex(1, 1), dir = RIGHT, inventory = nothing, color = :red)
    Agent{inventory_type}(pos, dir, inventory, color)
end

function get_char(agent::Agent)
    if     agent.dir === UP
        '↑'
    elseif agent.dir === DOWN
        '↓'
    elseif agent.dir === LEFT
        '←'
    elseif agent.dir === RIGHT
        '→'
    end
end

get_color(agent::Agent) = agent.color
get_dir(agent::Agent) = agent.dir
set_dir!(agent::Agent, dir::Direction) = agent.dir = dir
get_pos(agent::Agent) = agent.pos
set_pos!(agent::Agent, pos::CartesianIndex) = agent.pos = pos

get_inventory_type(agent::Agent{I}) where I = I
get_inventory(agent::Agent) = agent.inventory

function set_inventory!(agent::Agent, item)
    if isa(item, get_inventory_type(agent))
        agent.inventory = item
    else
        error("$item is not of type $(get_inventory_type(agent))")
    end
end

#####
# Pickup & Drop objects
#####

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
