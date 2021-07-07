module DoorKeyUndirectedModule

import ..GridWorlds as GW
import Random
import ReinforcementLearningBase as RLBase

mutable struct DoorKeyUndirected{R, RNG} <: GW.AbstractGridWorldGame
    tile_map::BitArray{3}
    agent_position::CartesianIndex{2}
    reward::R
    rng::RNG
    done::Bool
    terminal_reward::R
    goal_position::CartesianIndex{2}
    door_position::CartesianIndex{2}
    key_position::CartesianIndex{2}
    partition_dimension::Int
    has_key::Bool
end

const NUM_OBJECTS = 5
const AGENT = 1
const WALL = 2
const GOAL = 3
const DOOR = 4
const KEY = 5

CHARACTERS = ('☻', '█', '♥', '▒', '⚷', '⋅')

GW.get_tile_map_height(env::DoorKeyUndirected) = size(env.tile_map, 2)
GW.get_tile_map_width(env::DoorKeyUndirected) = size(env.tile_map, 3)

function GW.get_tile_pretty_repr(env::DoorKeyUndirected, i::Integer, j::Integer)
    object = findfirst(@view env.tile_map[:, i, j])
    if isnothing(object)
        return CHARACTERS[end]
    else
        return CHARACTERS[object]
    end
end

const NUM_ACTIONS = 5
GW.get_action_keys(env::DoorKeyUndirected) = ('w', 's', 'a', 'd', 'p')
GW.get_action_names(env::DoorKeyUndirected) = (:MOVE_UP, :MOVE_DOWN, :MOVE_LEFT, :MOVE_RIGHT, :PICK_UP)

function DoorKeyUndirected(; R = Float32, height = 8, width = 8, rng = Random.GLOBAL_RNG)
    tile_map = falses(NUM_OBJECTS, height, width)

    tile_map[WALL, 1, :] .= true
    tile_map[WALL, height, :] .= true
    tile_map[WALL, :, 1] .= true
    tile_map[WALL, :, width] .= true

    partition_dimension = 2

    door_position = CartesianIndex(2, 3)
    tile_map[WALL, 2 : height - 1, door_position[2]] .= true
    tile_map[WALL, door_position] = false
    tile_map[DOOR, door_position] = true

    agent_position = CartesianIndex(2, 2)
    tile_map[AGENT, agent_position] = true

    key_position = CartesianIndex(3, 2)
    tile_map[KEY, key_position] = true

    goal_position = CartesianIndex(height - 1, width - 1)
    tile_map[GOAL, goal_position] = true

    reward = zero(R)
    done = false
    terminal_reward = one(R)
    has_key = false

    env = DoorKeyUndirected(tile_map, agent_position, reward, rng, done, terminal_reward, goal_position, door_position, key_position, partition_dimension, has_key)

    GW.reset!(env)

    return env
end

function GW.reset!(env::DoorKeyUndirected)
    tile_map = env.tile_map
    rng = env.rng

    _, height, width = size(tile_map)

    tile_map[AGENT, env.agent_position] = false
    tile_map[GOAL, env.goal_position] = false
    tile_map[KEY, env.key_position] = false
    tile_map[DOOR, env.door_position] = false
    if env.partition_dimension == 1
        tile_map[WALL, env.door_position[1], 2 : width - 1] .= false
    else
        tile_map[WALL, 2 : height - 1, env.door_position[2]] .= false
    end

    new_partition_dimension = rand(rng, 1:2)
    env.partition_dimension = new_partition_dimension

    if new_partition_dimension == 1
        i_new_door_position = rand(rng, 3 : height - 2)
        j_new_door_position = rand(rng, 2 : width - 1)
        tile_map[WALL, i_new_door_position, :] .= true
        regions = (CartesianIndices((2 : i_new_door_position - 1, 2 : width - 1)), CartesianIndices((i_new_door_position + 1 : height - 1, 2 : width - 1)))
    else
        i_new_door_position = rand(rng, 2 : height - 1)
        j_new_door_position = rand(rng, 3 : width - 2)
        tile_map[WALL, :, j_new_door_position] .= true
        regions = (CartesianIndices((2 : height - 1, 2 : j_new_door_position - 1)), CartesianIndices((2 : height - 1, j_new_door_position + 1 : width - 1)))
    end

    new_door_position = CartesianIndex(i_new_door_position, j_new_door_position)
    env.door_position = new_door_position
    tile_map[WALL, i_new_door_position, j_new_door_position] = false
    tile_map[DOOR, i_new_door_position, j_new_door_position] = true

    new_agent_region = rand(rng, 1:2)
    if new_agent_region == 1
        new_agent_position, new_key_position = GW.sample_two_positions_without_replacement(rng, regions[1])
        new_goal_position = rand(rng, regions[2])
    else
        new_agent_position, new_key_position = GW.sample_two_positions_without_replacement(rng, regions[2])
        new_goal_position = rand(rng, regions[1])
    end

    env.agent_position = new_agent_position
    tile_map[AGENT, new_agent_position] = true

    env.key_position = new_key_position
    tile_map[KEY, new_key_position] = true

    env.goal_position = new_goal_position
    tile_map[GOAL, new_goal_position] = true

    env.reward = zero(env.reward)
    env.done = false
    env.has_key = false

    return nothing
end

function GW.act!(env::DoorKeyUndirected, action)
    tile_map = env.tile_map

    if action == 1
        new_agent_position = CartesianIndex(GW.move_up(env.agent_position.I...))
        if !(tile_map[DOOR, new_agent_position] || tile_map[WALL, new_agent_position]) || (tile_map[DOOR, new_agent_position] && env.has_key)
            tile_map[AGENT, env.agent_position] = false
            env.agent_position = new_agent_position
            tile_map[AGENT, new_agent_position] = true
        end
    elseif action == 2
        new_agent_position = CartesianIndex(GW.move_down(env.agent_position.I...))
        if !(tile_map[DOOR, new_agent_position] || tile_map[WALL, new_agent_position]) || (tile_map[DOOR, new_agent_position] && env.has_key)
            tile_map[AGENT, env.agent_position] = false
            env.agent_position = new_agent_position
            tile_map[AGENT, new_agent_position] = true
        end
    elseif action == 3
        new_agent_position = CartesianIndex(GW.move_left(env.agent_position.I...))
        if !(tile_map[DOOR, new_agent_position] || tile_map[WALL, new_agent_position]) || (tile_map[DOOR, new_agent_position] && env.has_key)
            tile_map[AGENT, env.agent_position] = false
            env.agent_position = new_agent_position
            tile_map[AGENT, new_agent_position] = true
        end
    elseif action == 4
        new_agent_position = CartesianIndex(GW.move_right(env.agent_position.I...))
        if !(tile_map[DOOR, new_agent_position] || tile_map[WALL, new_agent_position]) || (tile_map[DOOR, new_agent_position] && env.has_key)
            tile_map[AGENT, env.agent_position] = false
            env.agent_position = new_agent_position
            tile_map[AGENT, new_agent_position] = true
        end
    else
        if tile_map[KEY, env.agent_position]
            env.has_key = true
            tile_map[KEY, env.agent_position] = false
        end
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

function Base.show(io::IO, ::MIME"text/plain", env::DoorKeyUndirected)
    str = GW.get_tile_map_pretty_repr(env)
    str = str * "\nreward = $(env.reward)\ndone = $(env.done)"
    print(io, str)
    return nothing
end

end # module
