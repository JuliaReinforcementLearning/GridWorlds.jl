module DynamicObstaclesDirectedModule

import ..DynamicObstaclesUndirectedModule as DOUM
import ..GridWorlds as GW
import Random
import ReinforcementLearningBase as RLBase

#####
##### game logic
#####

const NUM_OBJECTS = DOUM.NUM_OBJECTS
const AGENT = DOUM.AGENT
const WALL = DOUM.WALL
const GOAL = DOUM.GOAL
const OBSTACLE = DOUM.OBSTACLE
const NUM_ACTIONS = 4

mutable struct DynamicObstaclesDirected{R, RNG} <: GW.AbstractGridWorldGame
    env::DOUM.DynamicObstaclesUndirected{R, RNG}
    agent_direction::Int
end

function DynamicObstaclesDirected(; R = Float32, height = 8, width = 8, num_obstacles = floor(Int, sqrt(height * width) / 2), rng = Random.GLOBAL_RNG)
    env = DOUM.DynamicObstaclesUndirected(R = R, height = height, width = width, num_obstacles = num_obstacles, rng = rng)
    agent_direction = rand(rng, 0:GW.NUM_DIRECTIONS-1)
    env = DynamicObstaclesDirected(env, agent_direction)
    GW.reset!(env)
    return env
end

function GW.reset!(env::DynamicObstaclesDirected)
    GW.reset!(env.env)
    env.agent_direction = rand(env.env.rng, 0:GW.NUM_DIRECTIONS-1)
    return nothing
end

function GW.act!(env::DynamicObstaclesDirected, action)
    inner_env = env.env
    tile_map = inner_env.tile_map
    DOUM.update_obstacles!(inner_env)

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
    elseif tile_map[OBSTACLE, inner_env.agent_position]
        inner_env.reward = inner_env.terminal_penalty
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

CHARACTERS = ('☻', '█', '♥', '⊗', '→', '↑', '←', '↓', '⋅')

GW.get_tile_map_height(env::DynamicObstaclesDirected) = size(env.env.tile_map, 2)
GW.get_tile_map_width(env::DynamicObstaclesDirected) = size(env.env.tile_map, 3)

function GW.get_tile_pretty_repr(env::DynamicObstaclesDirected, i::Integer, j::Integer)
    object = findfirst(@view env.env.tile_map[:, i, j])
    if isnothing(object)
        return CHARACTERS[end]
    elseif object == AGENT
        return CHARACTERS[NUM_OBJECTS + 1 + env.agent_direction]
    else
        return CHARACTERS[object]
    end
end

GW.get_action_keys(env::DynamicObstaclesDirected) = ('w', 's', 'a', 'd')
GW.get_action_names(env::DynamicObstaclesDirected) = (:MOVE_FORWARD, :MOVE_BACKWARD, :TURN_LEFT, :TURN_RIGHT)

function Base.show(io::IO, ::MIME"text/plain", env::DynamicObstaclesDirected)
    str = GW.get_tile_map_pretty_repr(env)
    str = str * "\nreward = $(env.env.reward)\ndone = $(env.env.done)"
    print(io, str)
    return nothing
end

#####
##### RLBase API
#####

RLBase.StateStyle(env::GW.RLBaseEnv{E}) where {E <: DynamicObstaclesDirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: DynamicObstaclesDirected} = nothing
RLBase.state(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: DynamicObstaclesDirected} = (env.env.env.tile_map, env.env.agent_direction)

RLBase.reset!(env::GW.RLBaseEnv{E}) where {E <: DynamicObstaclesDirected} = GW.reset!(env.env)

RLBase.action_space(env::GW.RLBaseEnv{E}) where {E <: DynamicObstaclesDirected} = 1:NUM_ACTIONS
(env::GW.RLBaseEnv{E})(action) where {E <: DynamicObstaclesDirected} = GW.act!(env.env, action)

RLBase.reward(env::GW.RLBaseEnv{E}) where {E <: DynamicObstaclesDirected} = env.env.env.reward
RLBase.is_terminated(env::GW.RLBaseEnv{E}) where {E <: DynamicObstaclesDirected} = env.env.env.done

end # module
