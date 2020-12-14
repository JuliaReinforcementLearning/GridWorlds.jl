export AbstractGridWorldAction, MoveForward, TurnLeft, TurnRight, PickUp, Drop
export MOVE_FORWARD, TURN_LEFT, TURN_RIGHT, PICK_UP, DROP

abstract type AbstractGridWorldAction end

struct MoveForward <: AbstractGridWorldAction end
const MOVE_FORWARD = MoveForward()

struct TurnLeft <: AbstractGridWorldAction end
const TURN_LEFT = TurnLeft()

(x::TurnLeft)(::Up) = LEFT
(x::TurnLeft)(::Down) = RIGHT
(x::TurnLeft)(::Left) = DOWN
(x::TurnLeft)(::Right) = UP

struct TurnRight <: AbstractGridWorldAction end
const TURN_RIGHT = TurnRight()

(x::TurnRight)(::Up) = RIGHT
(x::TurnRight)(::Down) = LEFT
(x::TurnRight)(::Left) = UP
(x::TurnRight)(::Right) = DOWN

struct PickUp <: AbstractGridWorldAction end
const PICK_UP = PickUp()

struct Drop <: AbstractGridWorldAction end
const DROP = Drop()
