module TransportDirectedModule

import ..GridWorlds as GW
import Random
import ReinforcementLearningBase as RLBase
import ..TransportUndirectedModule as TUM

#####
##### game logic
#####

const NUM_OBJECTS = TUM.NUM_OBJECTS
const AGENT = TUM.AGENT
const WALL = TUM.WALL
const GEM = TUM.GEM
const TARGET = TUM.TARGET
const NUM_ACTIONS = 6

mutable struct TransportDirected{R, RNG} <: GW.AbstractGridWorld
    env::TUM.TransportUndirected{R, RNG}
    agent_direction::Int
end

function TransportDirected(; R = Float32, height = 8, width = 8, rng = Random.GLOBAL_RNG)
    env = TUM.TransportUndirected(R = R, height = height, width = width, rng = rng)
    agent_direction = rand(rng, 0:GW.NUM_DIRECTIONS-1)
    env = TransportDirected(env, agent_direction)
    GW.reset!(env)
    return env
end

function GW.reset!(env::TransportDirected)
    GW.reset!(env.env)
    env.agent_direction = rand(env.env.rng, 0:GW.NUM_DIRECTIONS-1)
    return nothing
end

function GW.act!(env::TransportDirected, action)
    @assert action in Base.OneTo(NUM_ACTIONS) "Invalid action $(action). Action must be in Base.OneTo($(NUM_ACTIONS))"

    inner_env = env.env
    tile_map = inner_env.tile_map
    agent_position = inner_env.agent_position
    agent_direction = env.agent_direction

    if action in Base.OneTo(2)
        if action == 1
            new_agent_position = GW.move_forward(agent_position, agent_direction)
        else
            new_agent_position = GW.move_backward(agent_position, agent_direction)
        end

        if !tile_map[WALL, new_agent_position]
            tile_map[AGENT, agent_position] = false
            inner_env.agent_position = new_agent_position
            tile_map[AGENT, new_agent_position] = true
        end
    elseif action == 3
        env.agent_direction = GW.turn_left(agent_direction)
    elseif action == 4
        env.agent_direction = GW.turn_right(agent_direction)
    elseif action == 5
        if tile_map[GEM, agent_position]
            tile_map[GEM, agent_position] = false
            inner_env.has_gem = true
        end
    else
        if inner_env.has_gem
            inner_env.has_gem = false
            inner_env.gem_position = agent_position
            tile_map[GEM, agent_position] = true
        end
    end

    if tile_map[GEM, inner_env.target_position]
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

GW.get_height(env::TransportDirected) = GW.get_height(env.env)
GW.get_width(env::TransportDirected) = GW.get_width(env.env)

GW.get_action_names(env::TransportDirected) = (:MOVE_FORWARD, :MOVE_BACKWARD, :TURN_LEFT, :TURN_RIGHT, :PICK_UP, :DROP)
GW.get_object_names(env::TransportDirected) = GW.get_object_names(env.env)

function GW.get_pretty_tile_map(env::TransportDirected, position::CartesianIndex{2})
    characters = ('☻', '█', '♦', '✖', '→', '↑', '←', '↓', '⋅')

    object = findfirst(@view env.env.tile_map[:, position])
    if isnothing(object)
        return characters[end]
    elseif object == AGENT
        return characters[NUM_OBJECTS + 1 + env.agent_direction]
    else
        return characters[object]
    end
end

function GW.get_pretty_sub_tile_map(env::TransportDirected, window_size, position::CartesianIndex{2})
    tile_map = env.env.tile_map
    agent_position = env.env.agent_position
    agent_direction = env.agent_direction

    characters = ('☻', '█', '♦', '✖', '→', '↑', '←', '↓', '⋅')

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

function Base.show(io::IO, ::MIME"text/plain", env::TransportDirected)
    str = "tile_map:\n"
    str = str * GW.get_pretty_tile_map(env)
    str = str * "\nsub_tile_map:\n"
    str = str * GW.get_pretty_sub_tile_map(env, GW.get_window_size(env))
    str = str * "\nreward: $(env.env.reward)"
    str = str * "\ndone: $(env.env.done)"
    str = str * "\nhas_gem: $(env.env.has_gem)"
    str = str * "\naction_names: $(GW.get_action_names(env))"
    str = str * "\nobject_names: $(GW.get_object_names(env))"
    print(io, str)
    return nothing
end

GW.get_action_keys(env::TransportDirected) = ('w', 's', 'a', 'd', 'p', 'l')

#####
##### RLBase API
#####

RLBase.StateStyle(env::GW.RLBaseEnv{E}) where {E <: TransportDirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: TransportDirected} = nothing
RLBase.state(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: TransportDirected} = (env.env.env.tile_map, env.env.agent_direction)

RLBase.reset!(env::GW.RLBaseEnv{E}) where {E <: TransportDirected} = GW.reset!(env.env)

RLBase.action_space(env::GW.RLBaseEnv{E}) where {E <: TransportDirected} = Base.OneTo(NUM_ACTIONS)
(env::GW.RLBaseEnv{E})(action) where {E <: TransportDirected} = GW.act!(env.env, action)

RLBase.reward(env::GW.RLBaseEnv{E}) where {E <: TransportDirected} = env.env.env.reward
RLBase.is_terminated(env::GW.RLBaseEnv{E}) where {E <: TransportDirected} = env.env.env.done

end # module
