export Room

struct Room
    region::CartesianIndices{2}
end

Room(origin, height, width) = Room(CartesianIndices((origin.I[1] : origin.I[1] + height - 1, origin.I[2] : origin.I[2] + width - 1)))

interior(room::Room) = room.region[2:end-1, 2:end-1]

function is_intersecting(room1::Room, room2::Room)
    intersection = intersect(interior(room1), room2.region)
    length(intersection) > 0 ? true : false
end
