module CollectGemsDirectedModule

import ..CollectGemsUndirectedModule as CGUM
import ..GridWorlds as GW
import Random
import ReinforcementLearningBase as RLBase

#####
##### game logic
#####

const NUM_OBJECTS = CGUM.NUM_OBJECTS
const AGENT = CGUM.AGENT
const WALL = CGUM.WALL
const GEM = CGUM.GEM
const NUM_ACTIONS = 4

mutable struct CollectGemsDirected{R, RNG} <: GW.AbstractGridWorld
    env::CGUM.CollectGemsUndirected{R, RNG}
    agent_direction::Int
end

function CollectGemsDirected(; R = Float32, height = 8, width = 8, num_gem_init = floor(Int, sqrt(height * width)), rng = Random.GLOBAL_RNG)
    env = CGUM.CollectGemsUndirected(R = R, height = height, width = width, num_gem_init = num_gem_init, rng = rng)
    agent_direction = rand(rng, 0:GW.NUM_DIRECTIONS-1)
    env = CollectGemsDirected(env, agent_direction)
    GW.reset!(env)
    return env
end

function GW.reset!(env::CollectGemsDirected)
    GW.reset!(env.env)
    env.agent_direction = rand(env.env.rng, 0:GW.NUM_DIRECTIONS-1)
    return nothing
end

function GW.act!(env::CollectGemsDirected, action)
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

    inner_env.reward = zero(inner_env.reward)
    if tile_map[GEM, inner_env.agent_position]
        tile_map[GEM, inner_env.agent_position] = false
        inner_env.num_gem_current -= 1
        inner_env.reward = inner_env.gem_reward
    end

    inner_env.done = inner_env.num_gem_current <= 0

    return nothing
end

#####
##### miscellaneous
#####

CHARACTERS = ('☻', '█', '♦', '→', '↑', '←', '↓', '⋅')

GW.get_height(env::CollectGemsDirected) = size(env.env.tile_map, 2)
GW.get_width(env::CollectGemsDirected) = size(env.env.tile_map, 3)

function GW.get_pretty_tile_map(env::CollectGemsDirected, i::Integer, j::Integer)
    object = findfirst(@view env.env.tile_map[:, i, j])
    if isnothing(object)
        return CHARACTERS[end]
    elseif object == AGENT
        return CHARACTERS[NUM_OBJECTS + 1 + env.agent_direction]
    else
        return CHARACTERS[object]
    end
end

GW.get_action_keys(env::CollectGemsDirected) = ('w', 's', 'a', 'd')
GW.get_action_names(env::CollectGemsDirected) = (:MOVE_FORWARD, :MOVE_BACKWARD, :TURN_LEFT, :TURN_RIGHT)

function Base.show(io::IO, ::MIME"text/plain", env::CollectGemsDirected)
    str = GW.get_pretty_tile_map(env)
    str = str * "\nreward = $(env.env.reward)\ndone = $(env.env.done)"
    print(io, str)
    return nothing
end

#####
##### RLBase API
#####

RLBase.StateStyle(env::GW.RLBaseEnv{E}) where {E <: CollectGemsDirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: CollectGemsDirected} = nothing
RLBase.state(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: CollectGemsDirected} = (env.env.env.tile_map, env.env.agent_direction)

RLBase.reset!(env::GW.RLBaseEnv{E}) where {E <: CollectGemsDirected} = GW.reset!(env.env)

RLBase.action_space(env::GW.RLBaseEnv{E}) where {E <: CollectGemsDirected} = Base.OneTo(NUM_ACTIONS)
(env::GW.RLBaseEnv{E})(action) where {E <: CollectGemsDirected} = GW.act!(env.env, action)

RLBase.reward(env::GW.RLBaseEnv{E}) where {E <: CollectGemsDirected} = env.env.env.reward
RLBase.is_terminated(env::GW.RLBaseEnv{E}) where {E <: CollectGemsDirected} = env.env.env.done

end # module
