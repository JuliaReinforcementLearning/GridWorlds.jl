module SequentialRoomsDirectedModule

import ..GridWorlds as GW
import Random
import ReinforcementLearningBase as RLBase
import ..SequentialRoomsUndirectedModule as SRUM

mutable struct SequentialRoomsDirected{R, RNG} <: GW.AbstractGridWorldGame
    env::SRUM.SequentialRoomsUndirected{R, RNG}
    agent_direction::Int
end

const NUM_OBJECTS = SRUM.NUM_OBJECTS
const AGENT = SRUM.AGENT
const WALL = SRUM.WALL
const GOAL = SRUM.GOAL

CHARACTERS = ('☻', '█', '♥', '→', '↑', '←', '↓', '⋅')

GW.get_tile_map_height(env::SequentialRoomsDirected) = size(env.env.tile_map, 2)
GW.get_tile_map_width(env::SequentialRoomsDirected) = size(env.env.tile_map, 3)

function GW.get_tile_pretty_repr(env::SequentialRoomsDirected, i::Integer, j::Integer)
    object = findfirst(@view env.env.tile_map[:, i, j])
    if isnothing(object)
        return CHARACTERS[end]
    elseif object == AGENT
        return CHARACTERS[NUM_OBJECTS + 1 + env.agent_direction]
    else
        return CHARACTERS[object]
    end
end

const NUM_ACTIONS = 4
GW.get_action_keys(env::SequentialRoomsDirected) = ('w', 's', 'a', 'd')
GW.get_action_names(env::SequentialRoomsDirected) = (:MOVE_FORWARD, :MOVE_BACKWARD, :TURN_LEFT, :TURN_RIGHT)

function SequentialRoomsDirected(; R = Float32, num_rooms = 3, range_height_room = 4:6, range_width_room = 7:9, rng = Random.GLOBAL_RNG)
    env = SRUM.SequentialRoomsUndirected(R = R, num_rooms = num_rooms, range_height_room = range_height_room, range_width_room = range_width_room, rng = rng)
    agent_direction = rand(rng, 0:GW.NUM_DIRECTIONS-1)
    env = SequentialRoomsDirected(env, agent_direction)
    GW.reset!(env)
    return env
end

function GW.reset!(env::SequentialRoomsDirected)
    GW.reset!(env.env)
    env.agent_direction = rand(env.env.rng, 0:GW.NUM_DIRECTIONS-1)
    return nothing
end

function GW.act!(env::SequentialRoomsDirected, action)
    inner_env = env.env
    tile_map = inner_env.tile_map

    if action == 1
        agent_position = inner_env.agent_position
        agent_direction = env.agent_direction
        new_agent_position = CartesianIndex(GW.move_forward(agent_direction, agent_position.I...))
        if !tile_map[WALL, new_agent_position]
            tile_map[AGENT, agent_position] = false
            inner_env.agent_position = new_agent_position
            tile_map[AGENT, new_agent_position] = true
        end
    elseif action == 2
        agent_position = inner_env.agent_position
        agent_direction = env.agent_direction
        new_agent_position = CartesianIndex(GW.move_backward(agent_direction, agent_position.I...))
        if !tile_map[WALL, new_agent_position]
            tile_map[AGENT, agent_position] = false
            inner_env.agent_position = new_agent_position
            tile_map[AGENT, new_agent_position] = true
        end
    elseif action == 3
        env.agent_direction = GW.turn_left(env.agent_direction)
    elseif action == 4
        env.agent_direction = GW.turn_right(env.agent_direction)
    end

    if tile_map[GOAL, inner_env.agent_position]
        inner_env.reward = inner_env.terminal_reward
        inner_env.done = true
    else
        inner_env.reward = zero(inner_env.reward)
        inner_env.done = false
    end

    return nothing
end

function Base.show(io::IO, ::MIME"text/plain", env::SequentialRoomsDirected)
    str = GW.get_tile_map_pretty_repr(env)
    str = str * "\nreward = $(env.env.reward)\ndone = $(env.env.done)"
    print(io, str)
    return nothing
end

end # module
