export MoveForward, TurnLeft, TurnRight
export MOVE_FORWARD, TURN_LEFT, TURN_RIGHT

#####
# Actions
#####

struct MoveForward end
const MOVE_FORWARD = MoveForward()

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
