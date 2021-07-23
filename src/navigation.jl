const NUM_DIRECTIONS = 4
const RIGHT = 0
const UP = 1
const LEFT = 2
const DOWN = 3

turn_left(direction::Integer) = mod(direction + 1, NUM_DIRECTIONS)
turn_right(direction::Integer) = mod(direction - 1, NUM_DIRECTIONS)

move_up(position::CartesianIndex{2}) = CartesianIndex(position[1] - 1, position[2])
move_down(position::CartesianIndex{2}) = CartesianIndex(position[1] + 1, position[2])
move_left(position::CartesianIndex{2}) = CartesianIndex(position[1], position[2] - 1)
move_right(position::CartesianIndex{2}) = CartesianIndex(position[1], position[2] + 1)

function move_forward(position::CartesianIndex{2}, direction::Integer)
    if direction == UP
        return move_up(position)
    elseif direction == DOWN
        return move_down(position)
    elseif direction == LEFT
        return move_left(position)
    else direction == RIGHT
        return move_right(position)
    end
end

function move_backward(position::CartesianIndex{2}, direction::Integer)
    if direction == UP
        return move_down(position)
    elseif direction == DOWN
        return move_up(position)
    elseif direction == LEFT
        return move_right(position)
    else direction == RIGHT
        return move_left(position)
    end
end
