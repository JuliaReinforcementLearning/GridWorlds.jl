export AbstractDirection, Up, Down, Left, Right, Direction
export UP, DOWN, LEFT, RIGHT, DIRECTIONS

abstract type AbstractDirection end

struct Up <: AbstractDirection end
const UP = Up()
(x::Up)(p::CartesianIndex{2}) = p + CartesianIndex(-1, 0)

struct Down <: AbstractDirection end
const DOWN = Down()
(x::Down)(p::CartesianIndex{2}) = p + CartesianIndex(1, 0)

struct Left <: AbstractDirection end
const LEFT = Left()
(x::Left)(p::CartesianIndex{2}) = p + CartesianIndex(0, -1)

struct Right <: AbstractDirection end
const RIGHT = Right()
(x::Right)(p::CartesianIndex{2}) = p + CartesianIndex(0, 1)

const Direction = Union{Up, Down, Left, Right}
const DIRECTIONS = (UP, DOWN, LEFT, RIGHT)
