export AbstractDirection, Up, Down, Left, Right
export UP, DOWN, LEFT, RIGHT, DIRECTIONS

abstract type AbstractDirection end

struct Up <: AbstractDirection end
const UP = Up()
(x::Up)(p::CartesianIndex{2}) = p + CartesianIndex(-1, 0)
move(::Up, pos::CartesianIndex{2}) = pos + CartesianIndex(-1, 0)

struct Down <: AbstractDirection end
const DOWN = Down()
(x::Down)(p::CartesianIndex{2}) = p + CartesianIndex(1, 0)
move(::Down, pos::CartesianIndex{2}) = pos + CartesianIndex(1, 0)

struct Left <: AbstractDirection end
const LEFT = Left()
(x::Left)(p::CartesianIndex{2}) = p + CartesianIndex(0, -1)
move(::Left, pos::CartesianIndex{2}) = pos + CartesianIndex(0, -1)

struct Right <: AbstractDirection end
const RIGHT = Right()
(x::Right)(p::CartesianIndex{2}) = p + CartesianIndex(0, 1)
move(::Right, pos::CartesianIndex{2}) = pos + CartesianIndex(0, 1)

const DIRECTIONS = (UP, DOWN, LEFT, RIGHT)
