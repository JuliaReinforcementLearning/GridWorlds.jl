abstract type AbstractObject end

struct Agent <: AbstractObject end
const AGENT = Agent()

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

struct Target1 <: AbstractObject end
const TARGET1 = Target1()

struct Target2 <: AbstractObject end
const TARGET2 = Target2()

struct Body <: AbstractObject end
const BODY = Body()

struct Food <: AbstractObject end
const FOOD = Food()

struct Basket <: AbstractObject end
const BASKET = Basket()

struct Ball <: AbstractObject end
const BALL = Ball()
