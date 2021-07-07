module DoorKeyDirectedModule

import ..GridWorlds as GW
import Random
import ReinforcementLearningBase as RLBase
import ..DoorKeyUndirectedModule as DKUM

mutable struct DoorKeyDirected{R, RNG} <: GW.AbstractGridWorldGame
    env::DKUM.DoorKeyUndirected{R, RNG}
    agent_direction::Int
end

const NUM_OBJECTS = DKUM.NUM_OBJECTS
const AGENT = DKUM.AGENT
const WALL = DKUM.WALL
const GOAL = DKUM.GOAL
const DOOR = DKUM.DOOR
const KEY = DKUM.KEY

CHARACTERS = ('☻', '█', '♥', '▒', '⚷', '→', '↑', '←', '↓', '⋅')

GW.get_tile_map_height(env::DoorKeyDirected) = size(env.env.tile_map, 2)
GW.get_tile_map_width(env::DoorKeyDirected) = size(env.env.tile_map, 3)

function GW.get_tile_pretty_repr(env::DoorKeyDirected, i::Integer, j::Integer)
    object = findfirst(@view env.env.tile_map[:, i, j])
    if isnothing(object)
        return CHARACTERS[end]
    elseif object == AGENT
        return CHARACTERS[NUM_OBJECTS + 1 + env.agent_direction]
    else
        return CHARACTERS[object]
    end
end

const NUM_ACTIONS = 5
GW.get_action_keys(env::DoorKeyDirected) = ('w', 's', 'a', 'd', 'p')
GW.get_action_names(env::DoorKeyDirected) = (:MOVE_FORWARD, :MOVE_BACKWARD, :TURN_LEFT, :TURN_RIGHT, :PICK_UP)

function DoorKeyDirected(; R = Float32, height = 8, width = 8, rng = Random.GLOBAL_RNG)
    env = DKUM.DoorKeyUndirected(R = R, height = height, width = width, rng = rng)
    agent_direction = rand(rng, 0:GW.NUM_DIRECTIONS-1)
    env = DoorKeyDirected(env, agent_direction)
    GW.reset!(env)
    return env
end

function GW.reset!(env::DoorKeyDirected)
    GW.reset!(env.env)
    env.agent_direction = rand(env.env.rng, 0:GW.NUM_DIRECTIONS-1)
    return nothing
end

function GW.act!(env::DoorKeyDirected, action)
    inner_env = env.env
    tile_map = inner_env.tile_map

    if action == 1
        agent_position = inner_env.agent_position
        agent_direction = env.agent_direction
        new_agent_position = CartesianIndex(GW.move_forward(agent_direction, agent_position.I...))
        if !(tile_map[DOOR, new_agent_position] || tile_map[WALL, new_agent_position]) || (tile_map[DOOR, new_agent_position] && inner_env.has_key)
            tile_map[AGENT, agent_position] = false
            inner_env.agent_position = new_agent_position
            tile_map[AGENT, new_agent_position] = true
        end
    elseif action == 2
        agent_position = inner_env.agent_position
        agent_direction = env.agent_direction
        new_agent_position = CartesianIndex(GW.move_backward(agent_direction, agent_position.I...))
        if !(tile_map[DOOR, new_agent_position] || tile_map[WALL, new_agent_position]) || (tile_map[DOOR, new_agent_position] && inner_env.has_key)
            tile_map[AGENT, agent_position] = false
            inner_env.agent_position = new_agent_position
            tile_map[AGENT, new_agent_position] = true
        end
    elseif action == 3
        env.agent_direction = GW.turn_left(env.agent_direction)
    elseif action == 4
        env.agent_direction = GW.turn_right(env.agent_direction)
    else
        if tile_map[KEY, inner_env.agent_position]
            inner_env.has_key = true
            tile_map[KEY, inner_env.agent_position] = false
        end
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

function Base.show(io::IO, ::MIME"text/plain", env::DoorKeyDirected)
    str = GW.get_tile_map_pretty_repr(env)
    str = str * "\nreward = $(env.env.reward)\ndone = $(env.env.done)"
    print(io, str)
    return nothing
end

end # module
