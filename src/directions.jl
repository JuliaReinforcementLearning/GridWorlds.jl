export AbstractDirection, Up, Down, Left, Right
export UP, DOWN, LEFT, RIGHT, DIRECTIONS

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
