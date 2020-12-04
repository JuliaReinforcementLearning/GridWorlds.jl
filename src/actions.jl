export AbstractGridWorldAction, MoveForward, TurnLeft, TurnRight, Pickup, Drop
export MOVE_FORWARD, TURN_LEFT, TURN_RIGHT, PICK_UP, DROP

abstract type AbstractGridWorldAction end

struct MoveForward <: AbstractGridWorldAction end
const MOVE_FORWARD = MoveForward()

struct TurnRight <: AbstractGridWorldAction end
const TURN_RIGHT = TurnRight()

struct TurnLeft <: AbstractGridWorldAction end
const TURN_LEFT = TurnLeft()

(x::TurnRight)(::Left) = UP
(x::TurnRight)(::Up) = RIGHT
(x::TurnRight)(::Right) = DOWN
(x::TurnRight)(::Down) = LEFT
(x::TurnLeft)(::Left) = DOWN
(x::TurnLeft)(::Up) = LEFT
(x::TurnLeft)(::Right) = UP
(x::TurnLeft)(::Down) = RIGHT

struct Pickup <: AbstractGridWorldAction end
const PICK_UP = Pickup()

struct Drop <: AbstractGridWorldAction end
const DROP = Drop()
