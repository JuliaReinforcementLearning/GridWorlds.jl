abstract type AbstractDirection end

struct Up <: AbstractDirection end
const UP = Up()
move(::Up, pos::CartesianIndex{2}) = pos + CartesianIndex(-1, 0)

struct Down <: AbstractDirection end
const DOWN = Down()
move(::Down, pos::CartesianIndex{2}) = pos + CartesianIndex(1, 0)

struct Left <: AbstractDirection end
const LEFT = Left()
move(::Left, pos::CartesianIndex{2}) = pos + CartesianIndex(0, -1)

struct Right <: AbstractDirection end
const RIGHT = Right()
move(::Right, pos::CartesianIndex{2}) = pos + CartesianIndex(0, 1)

const DIRECTIONS = (UP, DOWN, LEFT, RIGHT)

const NUM_DIRECTIONS = 4
const RIGHT_DIRECTION = 0
const UP_DIRECTION = 1
const LEFT_DIRECTION = 2
const DOWN_DIRECTION = 3

turn_left(dir::Integer) = mod(dir + 1, NUM_DIRECTIONS)
turn_right(dir::Integer) = mod(dir - 1, NUM_DIRECTIONS)
