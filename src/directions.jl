const NUM_DIRECTIONS = 4
const RIGHT_DIRECTION = 0
const UP_DIRECTION = 1
const LEFT_DIRECTION = 2
const DOWN_DIRECTION = 3

turn_left(dir::Integer) = mod(dir + 1, NUM_DIRECTIONS)
turn_right(dir::Integer) = mod(dir - 1, NUM_DIRECTIONS)
