struct Room
    region::CartesianIndices{2,Tuple{UnitRange{Int},UnitRange{Int}}}
end

Room(origin, height, width) = Room(CartesianIndices((origin.I[1] : origin.I[1] + height - 1, origin.I[2] : origin.I[2] + width - 1)))

get_origin(region::CartesianIndices{2}) = region[1, 1]
get_origin(room::Room) = get_origin(room.region)

get_interior(room::Room) = CartesianIndices((room.region.indices[1].start + 1 : room.region.indices[1].stop - 1,
                                             room.region.indices[2].start + 1 : room.region.indices[2].stop - 1))

function is_intersecting(room1::Room, room2::Room)
    intersection = intersect(get_interior(room1), room2.region)
    length(intersection) > 0 ? true : false
end

place_room!(env::AbstractGridWorld, room::Room) = place_room!(get_world(env), room)

function place_room!(world::GridWorldBase, room::Room)
    top = room.region.indices[1].start
    bottom = room.region.indices[1].stop
    left = room.region.indices[2].start
    right = room.region.indices[2].stop

    world[WALL, top, left:right] .= true
    world[WALL, bottom, left:right] .= true
    world[WALL, top:bottom, left] .= true
    world[WALL, top:bottom, right] .= true
end

function sample_two_positions_without_replacement(rng, region)
    position1 = rand(rng, region)
    position2 = rand(rng, region)

    while position1 == position2
        position2 = rand(rng, region)
    end

    return position1, position2
end

include("empty_room.jl")
include("grid_rooms.jl")
include("sequential_rooms.jl")
include("maze.jl")
include("go_to_target.jl")
include("door_key.jl")
include("collect_gems.jl")
include("dynamic_obstacles.jl")
include("sokoban/sokoban.jl")
include("snake.jl")
include("catcher.jl")
include("transport.jl")
include("collect_gems_undirected_multi_agent.jl")
include("single_room.jl")
