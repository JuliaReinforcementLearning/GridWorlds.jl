module SingleRoomDirectedModule

import ..GridWorlds as GW
import Random
import ReinforcementLearningBase as RLBase
import ..SingleRoomUndirectedModule as SRUM

#####
##### game logic
#####

const NUM_OBJECTS = SRUM.NUM_OBJECTS
const AGENT = SRUM.AGENT
const WALL = SRUM.WALL
const GOAL = SRUM.GOAL
const NUM_ACTIONS = 4

mutable struct SingleRoomDirected{R, RNG} <: GW.AbstractGridWorldGame
    env::SRUM.SingleRoomUndirected{R, RNG}
    agent_direction::Int
end

function SingleRoomDirected(; R = Float32, height = 8, width = 8, rng = Random.GLOBAL_RNG)
    env = SRUM.SingleRoomUndirected(R = R, height = height, width = width, rng = rng)
    agent_direction = rand(rng, 0:GW.NUM_DIRECTIONS-1)
    env = SingleRoomDirected(env, agent_direction)
    GW.reset!(env)
    return env
end

function GW.reset!(env::SingleRoomDirected)
    GW.reset!(env.env)
    env.agent_direction = rand(env.env.rng, 0:GW.NUM_DIRECTIONS-1)
    return nothing
end

function GW.act!(env::SingleRoomDirected, action)
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

#####
##### miscellaneous
#####

CHARACTERS = ('☻', '█', '♥', '→', '↑', '←', '↓', '⋅')

GW.get_tile_map_height(env::SingleRoomDirected) = size(env.env.tile_map, 2)
GW.get_tile_map_width(env::SingleRoomDirected) = size(env.env.tile_map, 3)

function GW.get_tile_pretty_repr(env::SingleRoomDirected, i::Integer, j::Integer)
    object = findfirst(@view env.env.tile_map[:, i, j])
    if isnothing(object)
        return CHARACTERS[end]
    elseif object == AGENT
        return CHARACTERS[NUM_OBJECTS + 1 + env.agent_direction]
    else
        return CHARACTERS[object]
    end
end

function GW.get_sub_tile_map_pretty_repr(env::SingleRoomDirected, window_size, position::CartesianIndex{2})
    tile_map = env.env.tile_map
    agent_position = env.env.agent_position
    agent_direction = env.agent_direction

    sub_tile_map = GW.get_sub_tile_map(tile_map, agent_position, window_size, agent_direction)

    object = findfirst(@view sub_tile_map[:, position])
    if isnothing(object)
        return CHARACTERS[end]
    elseif object == AGENT
        return '↓'
    else
        return CHARACTERS[object]
    end
end

GW.get_action_keys(env::SingleRoomDirected) = ('w', 's', 'a', 'd')
GW.get_action_names(env::SingleRoomDirected) = (:MOVE_FORWARD, :MOVE_BACKWARD, :TURN_LEFT, :TURN_RIGHT)

function Base.show(io::IO, ::MIME"text/plain", env::SingleRoomDirected)
    str = "tile_map:\n"
    str = str * GW.get_tile_map_pretty_repr(env)
    str = str * "\nsub_tile_map:\n"
    str = str * GW.get_sub_tile_map_pretty_repr(env, GW.get_window_size(env))
    str = str * "\nreward = $(env.env.reward)\ndone = $(env.env.done)"
    print(io, str)
    return nothing
end

#####
##### RLBase API
#####

RLBase.StateStyle(env::GW.RLBaseEnv{E}) where {E <: SingleRoomDirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: SingleRoomDirected} = nothing
RLBase.state(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: SingleRoomDirected} = (env.env.env.tile_map, env.env.agent_direction)

RLBase.reset!(env::GW.RLBaseEnv{E}) where {E <: SingleRoomDirected} = GW.reset!(env.env)

RLBase.action_space(env::GW.RLBaseEnv{E}) where {E <: SingleRoomDirected} = 1:NUM_ACTIONS
(env::GW.RLBaseEnv{E})(action) where {E <: SingleRoomDirected} = GW.act!(env.env, action)

RLBase.reward(env::GW.RLBaseEnv{E}) where {E <: SingleRoomDirected} = env.env.env.reward
RLBase.is_terminated(env::GW.RLBaseEnv{E}) where {E <: SingleRoomDirected} = env.env.env.done

end # module
