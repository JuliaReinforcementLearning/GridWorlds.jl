export Room

#####
# Room struct
#####

struct Room
    region::CartesianIndices{2}
end

Room(origin, height, width) = Room(CartesianIndices((origin.I[1] : origin.I[1] + height - 1, origin.I[2] : origin.I[2] + width - 1)))

get_origin(region::CartesianIndices{2}) = region[1, 1]
get_origin(room::Room) = get_origin(room.region)

# get_interior(room::Room) = room.region[2:end-1, 2:end-1]
get_interior(room::Room) = CartesianIndices((room.region.indices[1].start + 1 : room.region.indices[1].stop - 1,
                                             room.region.indices[2].start + 1 : room.region.indices[2].stop - 1))

function is_intersecting(room1::Room, room2::Room)
    intersection = intersect(get_interior(room1), room2.region)
    length(intersection) > 0 ? true : false
end

place_room!(env::AbstractGridWorld, room::Room) = place_room!(get_world(env), room)

function place_room!(world::GridWorldBase, room::Room)
    world[WALL, room.region] .= true
    world[WALL, get_interior(room)] .= false
    world[EMPTY, get_interior(room)] .= true
end
