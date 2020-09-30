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

const COLORS = (RED,GREEN,BLUE,PURPLE,YELLOW,GREY)

