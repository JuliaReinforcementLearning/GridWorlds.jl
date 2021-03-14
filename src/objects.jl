#####
# Objects
#####

abstract type AbstractObject end

struct Empty <: AbstractObject end
const EMPTY = Empty()

struct Wall <: AbstractObject end
const WALL = Wall()

struct Goal <: AbstractObject end
const GOAL = Goal()

struct Door <: AbstractObject end
const DOOR = Door()

struct Key <: AbstractObject end
const KEY = Key()

struct Gem <: AbstractObject end
const GEM = Gem()

struct Obstacle <: AbstractObject end
const OBSTACLE = Obstacle()

struct Box <: AbstractObject end
const BOX = Box()

struct Target <: AbstractObject end
const TARGET = Target()

struct Body <: AbstractObject end
const BODY = Body()

struct Food <: AbstractObject end
const FOOD = Food()

struct Basket <: AbstractObject end
const BASKET = Basket()

struct Ball <: AbstractObject end
const BALL = Ball()

#####
# Agent
#####

mutable struct Agent <: AbstractObject
    pos::CartesianIndex{2}
    dir::AbstractDirection
end

Agent() =  Agent(CartesianIndex(2, 2), RIGHT)

get_dir(agent::Agent) = agent.dir
set_dir!(agent::Agent, dir::AbstractDirection) = agent.dir = dir
get_pos(agent::Agent) = agent.pos
set_pos!(agent::Agent, pos::CartesianIndex{2}) = agent.pos = pos
