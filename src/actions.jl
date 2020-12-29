export AbstractGridWorldAction, MoveForward, TurnLeft, TurnRight, MoveUp, MoveDown, MoveLeft, MoveRight, PickUp, Drop
export MOVE_FORWARD, TURN_LEFT, TURN_RIGHT, MOVE_UP, MOVE_DOWN, MOVE_LEFT, MOVE_RIGHT, PICK_UP, DROP

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

struct MoveUp <: AbstractGridWorldAction end
const MOVE_UP = MoveUp()
(::MoveUp)(p::CartesianIndex{2}) = UP(p)
move(::MoveUp, pos::CartesianIndex{2}) = move(UP, pos)

struct MoveDown <: AbstractGridWorldAction end
const MOVE_DOWN = MoveDown()
(::MoveDown)(p::CartesianIndex{2}) = DOWN(p)
move(::MoveDown, pos::CartesianIndex{2}) = move(DOWN, pos)

struct MoveLeft <: AbstractGridWorldAction end
const MOVE_LEFT = MoveLeft()
(::MoveLeft)(p::CartesianIndex{2}) = LEFT(p)
move(::MoveLeft, pos::CartesianIndex{2}) = move(LEFT, pos)

struct MoveRight <: AbstractGridWorldAction end
const MOVE_RIGHT = MoveRight()
(::MoveRight)(p::CartesianIndex{2}) = RIGHT(p)
move(::MoveRight, pos::CartesianIndex{2}) = move(RIGHT, pos)

struct PickUp <: AbstractGridWorldAction end
const PICK_UP = PickUp()

struct Drop <: AbstractGridWorldAction end
const DROP = Drop()
