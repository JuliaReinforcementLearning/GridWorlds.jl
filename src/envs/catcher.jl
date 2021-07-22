module CatcherModule

import ..GridWorlds as GW
import Random
import ReinforcementLearningBase as RLBase

#####
##### game logic
#####

const NUM_OBJECTS = 2
const AGENT = 1
const GEM = 2
const NUM_ACTIONS = 3

mutable struct Catcher{R, RNG} <: GW.AbstractGridWorld
    tile_map::BitArray{3}
    agent_position::CartesianIndex{2}
    reward::R
    rng::RNG
    done::Bool
    gem_position::CartesianIndex{2}
    gem_reward::R
    terminal_penalty::R
end

function Catcher(; R = Float32, height = 8, width = 8, rng = Random.GLOBAL_RNG)
    tile_map = falses(NUM_OBJECTS, height, width)

    gem_position = CartesianIndex(1, 1)
    tile_map[GEM, gem_position] = true

    agent_position = CartesianIndex(height, 1)
    tile_map[AGENT, agent_position] = true

    reward = zero(R)
    done = false
    gem_reward = one(R)
    terminal_penalty = -one(R)

    env = Catcher(tile_map, agent_position, reward, rng, done, gem_position, gem_reward, terminal_penalty)

    GW.reset!(env)

    return env
end

function GW.reset!(env::Catcher)
    tile_map = env.tile_map
    rng = env.rng

    _, height, width = size(tile_map)

    tile_map[AGENT, env.agent_position] = false
    tile_map[GEM, env.gem_position] = false

    new_gem_position = CartesianIndex(1, rand(rng, 1:width))
    env.gem_position = new_gem_position
    tile_map[GEM, new_gem_position] = true

    new_agent_position = CartesianIndex(height, rand(rng, 1:width))
    env.agent_position = new_agent_position
    tile_map[AGENT, new_agent_position] = true

    env.reward = zero(env.reward)
    env.done = false

    return nothing
end

function GW.act!(env::Catcher, action)
    tile_map = env.tile_map
    rng = env.rng
    _, height, width = size(tile_map)

    if action == 1
        if env.agent_position[2] == 1
            new_agent_position = env.agent_position
        else
            new_agent_position = CartesianIndex(GW.move_left(env.agent_position.I...))
        end
    elseif action == 2
        if env.agent_position[2] == width
            new_agent_position = env.agent_position
        else
            new_agent_position = CartesianIndex(GW.move_right(env.agent_position.I...))
        end
    elseif action == 3
        new_agent_position = env.agent_position
    else
        error("Invalid action $(action)")
    end

    tile_map[AGENT, env.agent_position] = false
    env.agent_position = new_agent_position
    tile_map[AGENT, new_agent_position] = true

    if env.gem_position[1] == height
        new_gem_position = CartesianIndex(1, rand(rng, 1 : width))
    else
        new_gem_position = CartesianIndex(GW.move_down(env.gem_position.I...))
    end

    tile_map[GEM, env.gem_position] = false
    env.gem_position = new_gem_position
    tile_map[GEM, new_gem_position] = true

    if new_gem_position[1] == height
        if new_gem_position[2] == new_agent_position[2]
            env.done = false
            env.reward = env.gem_reward
        else
            env.done = true
            env.reward = env.terminal_penalty
        end
    else
        env.done = false
        env.reward = zero(env.reward)
    end

    return nothing
end

#####
##### miscellaneous
#####

CHARACTERS = ('☻', '♦', '⋅')

GW.get_height(env::Catcher) = size(env.tile_map, 2)
GW.get_width(env::Catcher) = size(env.tile_map, 3)

function GW.get_pretty_tile_map(env::Catcher, i::Integer, j::Integer)
    object = findfirst(@view env.tile_map[:, i, j])
    if isnothing(object)
        return CHARACTERS[end]
    else
        return CHARACTERS[object]
    end
end

GW.get_action_keys(env::Catcher) = ('a', 'd', 's')
GW.get_action_names(env::Catcher) = (:MOVE_LEFT, :MOVE_RIGHT, :NO_MOVE)

function Base.show(io::IO, ::MIME"text/plain", env::Catcher)
    str = GW.get_pretty_tile_map(env)
    str = str * "\nreward = $(env.reward)\ndone = $(env.done)"
    print(io, str)
    return nothing
end

#####
##### RLBase API
#####

RLBase.StateStyle(env::GW.RLBaseEnv{E}) where {E <: Catcher} = RLBase.InternalState{Any}()
RLBase.state_space(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: Catcher} = nothing
RLBase.state(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: Catcher} = env.env.tile_map

RLBase.reset!(env::GW.RLBaseEnv{E}) where {E <: Catcher} = GW.reset!(env.env)

RLBase.action_space(env::GW.RLBaseEnv{E}) where {E <: Catcher} = Base.OneTo(NUM_ACTIONS)
(env::GW.RLBaseEnv{E})(action) where {E <: Catcher} = GW.act!(env.env, action)

RLBase.reward(env::GW.RLBaseEnv{E}) where {E <: Catcher} = env.env.reward
RLBase.is_terminated(env::GW.RLBaseEnv{E}) where {E <: Catcher} = env.env.done

end # module
