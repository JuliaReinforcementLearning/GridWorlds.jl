export Up, Down, Left, Right
export UP, DOWN, LEFT, RIGHT, LRUD, DIRECTIONS

#####
# Directions
#####

struct Up end
const UP = Up()
(x::Up)(p::CartesianIndex{2}) = p + CartesianIndex(-1, 0)

struct Down end
const DOWN = Down()
(x::Down)(p::CartesianIndex{2}) = p + CartesianIndex(1, 0)

struct Left end
const LEFT = Left()
(x::Left)(p::CartesianIndex{2}) = p + CartesianIndex(0, -1)

struct Right end
const RIGHT = Right()
(x::Right)(p::CartesianIndex{2}) = p + CartesianIndex(0, 1)

const LRUD = Union{Left, Right, Up, Down}
const DIRECTIONS = [UP, DOWN, LEFT, RIGHT]
