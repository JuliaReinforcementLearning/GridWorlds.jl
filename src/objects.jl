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
Base.show(io::IO, x::Tuple{<:AbstractObject}) = show(io, x[1])

struct Empty <: AbstractObject end
const EMPTY = Empty()
Base.show(io::IO, x::Empty) = print(io, '⋅')

struct Wall <: AbstractObject end
const WALL = Wall()
Base.show(io::IO, x::Wall) = print(io, '█')

struct Agent <: AbstractObject end
const AGENT = Agent()
Base.show(io::IO, x::Tuple{Agent,Up}) = print(io, '↑')
Base.show(io::IO, x::Tuple{Agent,Down}) = print(io, '↓')
Base.show(io::IO, x::Tuple{Agent,Left}) = print(io, '←')
Base.show(io::IO, x::Tuple{Agent,Right}) = print(io, '→')

struct Goal <: AbstractObject end
const GOAL = Goal()
Base.show(io::IO, x::Goal) = print(io, '♡')

struct Door <: AbstractObject end
const DOOR = Door()
Base.show(io::IO, x::Door) = print(io, '🚪')

####
# Colors
####
abstract type AbstractColor <: AbstractObject end

struct Red <: AbstractColor end
const RED = Red()
Base.convert(Symbol, ::Red) = :red

struct Green <: AbstractColor end
const GREEN = Green()
Base.convert(Symbol, ::Green) = :green

struct Blue <: AbstractColor end
const BLUE = Blue()
Base.convert(Symbol, ::Blue) = :blue

struct Purple <: AbstractColor end
const PURPLE = Purple()
Base.convert(Symbol, ::Purple) = :purple

struct Yellow <: AbstractColor end
const YELLOW = Yellow()
Base.convert(Symbol, ::Yellow) = :yellow

struct Grey <: AbstractColor end
const GREY = Grey()
Base.convert(Symbol, ::Grey) = :grey
