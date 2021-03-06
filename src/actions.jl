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

move_up(i::Integer, j::Integer) = (i - 1, j)
move_down(i::Integer, j::Integer) = (i + 1, j)
move_left(i::Integer, j::Integer) = (i, j - 1)
move_right(i::Integer, j::Integer) = (i, j + 1)
no_move(i::Integer, j::Integer) = (i, j)

function move_forward(dir::Integer, i::Integer, j::Integer)
    if dir == UP_DIRECTION
        return move_up(i, j)
    elseif dir == DOWN_DIRECTION
        return move_down(i, j)
    elseif dir == LEFT_DIRECTION
        return move_left(i, j)
    elseif dir == RIGHT_DIRECTION
        return move_right(i, j)
    else
        return no_move(i, j)
    end
end

function move_backward(dir::Integer, i::Integer, j::Integer)
    if dir == UP_DIRECTION
        return move_down(i, j)
    elseif dir == DOWN_DIRECTION
        return move_up(i, j)
    elseif dir == LEFT_DIRECTION
        return move_right(i, j)
    elseif dir == RIGHT_DIRECTION
        return move_left(i, j)
    else
        return no_move(i, j)
    end
end
