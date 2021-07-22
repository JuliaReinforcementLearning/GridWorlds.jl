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

mutable struct DynamicObstaclesDirected{R, RNG} <: GW.AbstractGridWorld
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

GW.get_height(env::DynamicObstaclesDirected) = GW.get_height(env.env)
GW.get_width(env::DynamicObstaclesDirected) = GW.get_width(env.env)

GW.get_action_names(env::DynamicObstaclesDirected) = (:MOVE_FORWARD, :MOVE_BACKWARD, :TURN_LEFT, :TURN_RIGHT)
GW.get_object_names(env::DynamicObstaclesDirected) = GW.get_object_names(env.env)

function GW.get_pretty_tile_map(env::DynamicObstaclesDirected, position::CartesianIndex{2})
    characters = ('☻', '█', '♥', '⊗', '→', '↑', '←', '↓', '⋅')

    object = findfirst(@view env.env.tile_map[:, position])
    if isnothing(object)
        return characters[end]
    elseif object == AGENT
        return characters[NUM_OBJECTS + 1 + env.agent_direction]
    else
        return characters[object]
    end
end

function GW.get_pretty_sub_tile_map(env::DynamicObstaclesDirected, window_size, position::CartesianIndex{2})
    tile_map = env.env.tile_map
    agent_position = env.env.agent_position
    agent_direction = env.agent_direction

    characters = ('☻', '█', '♥', '⊗', '→', '↑', '←', '↓', '⋅')

    sub_tile_map = GW.get_sub_tile_map(tile_map, agent_position, window_size, agent_direction)

    object = findfirst(@view sub_tile_map[:, position])
    if isnothing(object)
        return characters[end]
    elseif object == AGENT
        return '↓'
    else
        return characters[object]
    end
end

function Base.show(io::IO, ::MIME"text/plain", env::DynamicObstaclesDirected)
    str = "tile_map:\n"
    str = str * GW.get_pretty_tile_map(env)
    str = str * "\nsub_tile_map:\n"
    str = str * GW.get_pretty_sub_tile_map(env, GW.get_window_size(env))
    str = str * "\nreward: $(env.env.reward)"
    str = str * "\ndone: $(env.env.done)"
    str = str * "\naction_names: $(GW.get_action_names(env))"
    str = str * "\nobject_names: $(GW.get_object_names(env))"
    print(io, str)
    return nothing
end

GW.get_action_keys(env::DynamicObstaclesDirected) = ('w', 's', 'a', 'd')

#####
##### RLBase API
#####

RLBase.StateStyle(env::GW.RLBaseEnv{E}) where {E <: DynamicObstaclesDirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: DynamicObstaclesDirected} = nothing
RLBase.state(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: DynamicObstaclesDirected} = (env.env.env.tile_map, env.env.agent_direction)

RLBase.reset!(env::GW.RLBaseEnv{E}) where {E <: DynamicObstaclesDirected} = GW.reset!(env.env)

RLBase.action_space(env::GW.RLBaseEnv{E}) where {E <: DynamicObstaclesDirected} = Base.OneTo(NUM_ACTIONS)
(env::GW.RLBaseEnv{E})(action) where {E <: DynamicObstaclesDirected} = GW.act!(env.env, action)

RLBase.reward(env::GW.RLBaseEnv{E}) where {E <: DynamicObstaclesDirected} = env.env.env.reward
RLBase.is_terminated(env::GW.RLBaseEnv{E}) where {E <: DynamicObstaclesDirected} = env.env.env.done

end # module
