module SequentialRoomsUndirectedModule

import ..GridWorlds as GW
import Random
import ReinforcementLearningBase as RLBase

struct Room{I}
    region::CartesianIndices{2,Tuple{UnitRange{I},UnitRange{I}}}
end

Room(top_left, height, width) = Room(CartesianIndices((top_left.I[1] : top_left.I[1] + height - 1, top_left.I[2] : top_left.I[2] + width - 1)))

get_top_left(region::CartesianIndices{2}) = region[1, 1]
get_top_left(room::Room) = get_top_left(room.region)

get_bottom_right(region::CartesianIndices{2}) = region[1, 1]
get_bottom_right(room::Room) = get_bottom_right(room.region)

get_interior(room::Room) = CartesianIndices((room.region.indices[1].start + 1 : room.region.indices[1].stop - 1,
                                             room.region.indices[2].start + 1 : room.region.indices[2].stop - 1))

function is_separate(region1::CartesianIndices, region2::CartesianIndices)
    top_left_region1 = region1[1, 1]
    min_i_region1, min_j_region1 = top_left_region1.I
    bottom_right_region1 = region1[end, end]
    max_i_region1, max_j_region1 = bottom_right_region1.I

    top_left_region2 = region2[1, 1]
    min_i_region2, min_j_region2 = top_left_region2.I
    bottom_right_region2 = region2[end, end]
    max_i_region2, max_j_region2 = bottom_right_region2.I

    return (max_i_region1 < min_i_region2) || (max_i_region2 < min_i_region1) || (max_j_region1 < min_j_region2) || (max_j_region2 < min_j_region1)
end

is_separate(room1::Room, room2::Room) = is_separate(get_interior(room1), room2.region)

function place_room!(tile_map, room::Room)
    top = room.region.indices[1].start
    bottom = room.region.indices[1].stop
    left = room.region.indices[2].start
    right = room.region.indices[2].stop

    tile_map[WALL, top, left:right] .= true
    tile_map[WALL, bottom, left:right] .= true
    tile_map[WALL, top:bottom, left] .= true
    tile_map[WALL, top:bottom, right] .= true

    return nothing
end

mutable struct SequentialRoomsUndirected{R, RNG} <: GW.AbstractGridWorldGame
    tile_map::BitArray{3}
    agent_position::CartesianIndex{2}
    reward::R
    rng::RNG
    done::Bool
    terminal_reward::R
    goal_position::CartesianIndex{2}
    range_height_room::UnitRange{Int}
    range_width_room::UnitRange{Int}
    num_rooms::Int
    rooms::Array{Room{Int}, 1}
end

const NUM_OBJECTS = 3
const AGENT = 1
const WALL = 2
const GOAL = 3

CHARACTERS = ('☻', '█', '♥', '⋅')

GW.get_tile_map_height(env::SequentialRoomsUndirected) = size(env.tile_map, 2)
GW.get_tile_map_width(env::SequentialRoomsUndirected) = size(env.tile_map, 3)

function GW.get_tile_pretty_repr(env::SequentialRoomsUndirected, i::Integer, j::Integer)
    object = findfirst(@view env.tile_map[:, i, j])
    if isnothing(object)
        return CHARACTERS[end]
    else
        return CHARACTERS[object]
    end
end

const NUM_ACTIONS = 4
GW.get_action_keys(env::SequentialRoomsUndirected) = ('w', 's', 'a', 'd')
GW.get_action_names(env::SequentialRoomsUndirected) = (:MOVE_UP, :MOVE_DOWN, :MOVE_LEFT, :MOVE_RIGHT)

function SequentialRoomsUndirected(; R = Float32, num_rooms = 3, range_height_room = 4:6, range_width_room = 7:9, rng = Random.GLOBAL_RNG)
    height_tile_map = 2 * num_rooms * range_height_room.stop
    width_tile_map = 2 * num_rooms * range_width_room.stop
    tile_map = BitArray(undef, NUM_OBJECTS, height_tile_map, width_tile_map)

    agent_position = CartesianIndex(1, 1)
    goal_position = CartesianIndex(height_tile_map, width_tile_map)

    reward = zero(R)
    done = false
    terminal_reward = one(R)

    rooms = Array{Room{Int}}(undef, num_rooms)

    env = SequentialRoomsUndirected(tile_map, agent_position, reward, rng, done, terminal_reward, goal_position, range_height_room, range_width_room, num_rooms, rooms)

    GW.reset!(env)

    return env
end

function GW.reset!(env::SequentialRoomsUndirected)
    tile_map = env.tile_map
    rng = env.rng

    _, height_tile_map, width_tile_map = size(tile_map)
    tile_map[:, :, :] .= false

    first_room = generate_first_room(env)
    env.rooms[1] = first_room
    place_room!(tile_map, first_room)

    for i in 2:env.num_rooms
        candidate_rooms = generate_candidate_rooms(env, i)

        if length(candidate_rooms) > 0
            room = rand(rng, candidate_rooms)
            place_room!(tile_map, room)
            env.rooms[i] = room

            door_pos = rand(rng, intersect(env.rooms[i - 1].region, room.region)[2:end-1])
            tile_map[WALL, door_pos] = false
        end
    end

    tile_map[AGENT, env.agent_position] = false
    tile_map[GOAL, env.goal_position] = false

    new_agent_position = rand(rng, get_interior(env.rooms[1]))
    env.agent_position = new_agent_position
    tile_map[AGENT, new_agent_position] = true

    new_goal_position = rand(rng, get_interior(env.rooms[end]))
    env.goal_position = new_goal_position
    tile_map[GOAL, new_goal_position] = true

    env.reward = zero(env.reward)
    env.done = false

    return nothing
end

function GW.act!(env::SequentialRoomsUndirected, action)
    tile_map = env.tile_map

    if action == 1
        new_agent_position = CartesianIndex(GW.move_up(env.agent_position.I...))
    elseif action == 2
        new_agent_position = CartesianIndex(GW.move_down(env.agent_position.I...))
    elseif action == 3
        new_agent_position = CartesianIndex(GW.move_left(env.agent_position.I...))
    elseif action == 4
        new_agent_position = CartesianIndex(GW.move_right(env.agent_position.I...))
    end

    if !tile_map[WALL, new_agent_position]
        tile_map[AGENT, env.agent_position] = false
        env.agent_position = new_agent_position
        tile_map[AGENT, new_agent_position] = true
    end

    if tile_map[GOAL, env.agent_position]
        env.reward = env.terminal_reward
        env.done = true
    else
        env.reward = zero(env.reward)
        env.done = false
    end

    return nothing
end

function Base.show(io::IO, ::MIME"text/plain", env::SequentialRoomsUndirected)
    str = GW.get_tile_map_pretty_repr(env)
    str = str * "\nreward = $(env.reward)\ndone = $(env.done)"
    print(io, str)
    return nothing
end

function generate_first_room(env::SequentialRoomsUndirected)
    _, height_tile_map, width_tile_map = size(env.tile_map)
    origin = CartesianIndex(height_tile_map ÷ 2 + 1, width_tile_map ÷ 2 + 1)
    height_room = rand(env.rng, env.range_height_room)
    width_room = rand(env.rng, env.range_width_room)
    return Room(origin, height_room, width_room)
end

function generate_candidate_rooms(env::SequentialRoomsUndirected, room_id::Integer)
    candidate_rooms = Array{eltype(env.rooms), 1}()
    base_room = env.rooms[room_id - 1]

    for height in env.range_height_room
        for width in env.range_width_room
            for direction in 0:GW.NUM_DIRECTIONS-1

                if direction == GW.UP_DIRECTION
                    i = base_room.region.indices[1].start - height + 1
                    jj = base_room.region.indices[2].start - width + 3 : base_room.region.indices[2].stop - 2
                    origins = CartesianIndices((i:i, jj))
                elseif direction == GW.DOWN_DIRECTION
                    i = base_room.region.indices[1].stop
                    jj = base_room.region.indices[2].start - width + 3 : base_room.region.indices[2].stop - 2
                    origins = CartesianIndices((i:i, jj))
                elseif direction == GW.LEFT_DIRECTION
                    ii = base_room.region.indices[1].start - height + 3 : base_room.region.indices[1].stop - 2
                    j = base_room.region.indices[2].start - width + 1
                    origins = CartesianIndices((ii, j:j))
                else direction == GW.RIGHT_DIRECTION
                    ii = base_room.region.indices[1].start - height + 3 : base_room.region.indices[1].stop - 2
                    j = base_room.region.indices[2].stop
                    origins = CartesianIndices((ii, j:j))
                end

                for origin in origins
                    room = Room(origin, height, width)
                    if all(x -> is_separate(x, room), @view env.rooms[1:room_id-1])
                        push!(candidate_rooms, room)
                    end
                end

            end
        end
    end

    return candidate_rooms
end

end # module
