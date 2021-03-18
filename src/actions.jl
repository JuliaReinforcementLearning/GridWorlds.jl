export AbstractGridWorldAction, MoveForward, TurnLeft, TurnRight, MoveUp, MoveDown, MoveLeft, MoveRight, PickUp, Drop
export MOVE_FORWARD, TURN_LEFT, TURN_RIGHT, MOVE_UP, MOVE_DOWN, MOVE_LEFT, MOVE_RIGHT, PICK_UP, DROP

abstract type AbstractGridWorldAction end

abstract type AbstractMoveAction <: AbstractGridWorldAction end
abstract type AbstractTurnAction <: AbstractGridWorldAction end

struct MoveForward <: AbstractMoveAction end
const MOVE_FORWARD = MoveForward()
move(::MoveForward, dir::AbstractDirection, pos::CartesianIndex{2}) = move(dir, pos)

struct MoveUp <: AbstractMoveAction end
const MOVE_UP = MoveUp()
move(::MoveUp, pos::CartesianIndex{2}) = move(UP, pos)
move(action::MoveUp, dir::AbstractDirection, pos::CartesianIndex{2}) = move(action, pos)

struct MoveDown <: AbstractMoveAction end
const MOVE_DOWN = MoveDown()
move(::MoveDown, pos::CartesianIndex{2}) = move(DOWN, pos)
move(action::MoveDown, dir::AbstractDirection, pos::CartesianIndex{2}) = move(action, pos)

struct MoveLeft <: AbstractMoveAction end
const MOVE_LEFT = MoveLeft()
move(::MoveLeft, pos::CartesianIndex{2}) = move(LEFT, pos)
move(action::MoveLeft, dir::AbstractDirection, pos::CartesianIndex{2}) = move(action, pos)

struct MoveRight <: AbstractMoveAction end
const MOVE_RIGHT = MoveRight()
move(::MoveRight, pos::CartesianIndex{2}) = move(RIGHT, pos)
move(action::MoveRight, dir::AbstractDirection, pos::CartesianIndex{2}) = move(action, pos)

struct NoMove <: AbstractMoveAction end
const NO_MOVE = NoMove()
move(::NoMove, pos::CartesianIndex{2}) = pos
move(action::NoMove, dir::AbstractDirection, pos::CartesianIndex{2}) = move(action, pos)

struct TurnLeft <: AbstractTurnAction end
const TURN_LEFT = TurnLeft()
turn(::TurnLeft, ::Up) = LEFT
turn(::TurnLeft, ::Down) = RIGHT
turn(::TurnLeft, ::Left) = DOWN
turn(::TurnLeft, ::Right) = UP

struct TurnRight <: AbstractTurnAction end
const TURN_RIGHT = TurnRight()
turn(::TurnRight, ::Up) = RIGHT
turn(::TurnRight, ::Down) = LEFT
turn(::TurnRight, ::Left) = UP
turn(::TurnRight, ::Right) = DOWN

struct PickUp <: AbstractGridWorldAction end
const PICK_UP = PickUp()

struct Drop <: AbstractGridWorldAction end
const DROP = Drop()

const DIRECTED_NAVIGATION_ACTIONS = (MOVE_FORWARD, TURN_LEFT, TURN_RIGHT)
const UNDIRECTED_NAVIGATION_ACTIONS = (MOVE_UP, MOVE_DOWN, MOVE_LEFT, MOVE_RIGHT)
