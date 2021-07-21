const NUM_DIRECTIONS = 4
const RIGHT = 0
const UP = 1
const LEFT = 2
const DOWN = 3

turn_left(dir::Integer) = mod(dir + 1, NUM_DIRECTIONS)
turn_right(dir::Integer) = mod(dir - 1, NUM_DIRECTIONS)
