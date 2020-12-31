export AbstractGridWorldAction, MoveForward, TurnLeft, TurnRight, MoveUp, MoveDown, MoveLeft, MoveRight, PickUp, Drop
export MOVE_FORWARD, TURN_LEFT, TURN_RIGHT, MOVE_UP, MOVE_DOWN, MOVE_LEFT, MOVE_RIGHT, PICK_UP, DROP

abstract type AbstractGridWorldAction end

struct MoveForward <: AbstractGridWorldAction end
const MOVE_FORWARD = MoveForward()

struct TurnLeft <: AbstractGridWorldAction end
const TURN_LEFT = TurnLeft()
turn(::TurnLeft, ::Up) = LEFT
turn(::TurnLeft, ::Down) = RIGHT
turn(::TurnLeft, ::Left) = DOWN
turn(::TurnLeft, ::Right) = UP

struct TurnRight <: AbstractGridWorldAction end
const TURN_RIGHT = TurnRight()
turn(::TurnRight, ::Up) = RIGHT
turn(::TurnRight, ::Down) = LEFT
turn(::TurnRight, ::Left) = UP
turn(::TurnRight, ::Right) = DOWN

struct MoveUp <: AbstractGridWorldAction end
const MOVE_UP = MoveUp()
move(::MoveUp, pos::CartesianIndex{2}) = move(UP, pos)

struct MoveDown <: AbstractGridWorldAction end
const MOVE_DOWN = MoveDown()
move(::MoveDown, pos::CartesianIndex{2}) = move(DOWN, pos)

struct MoveLeft <: AbstractGridWorldAction end
const MOVE_LEFT = MoveLeft()
move(::MoveLeft, pos::CartesianIndex{2}) = move(LEFT, pos)

struct MoveRight <: AbstractGridWorldAction end
const MOVE_RIGHT = MoveRight()
move(::MoveRight, pos::CartesianIndex{2}) = move(RIGHT, pos)

struct PickUp <: AbstractGridWorldAction end
const PICK_UP = PickUp()

struct Drop <: AbstractGridWorldAction end
const DROP = Drop()

const DIRECTED_NAVIGATION_ACTIONS = (MOVE_FORWARD, TURN_LEFT, TURN_RIGHT)
const UNDIRECTED_NAVIGATION_ACTIONS = (MOVE_UP, MOVE_DOWN, MOVE_LEFT, MOVE_RIGHT)
