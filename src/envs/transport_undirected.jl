module TransportUndirectedModule

import ..GridWorlds as GW
import Random
import ReinforcementLearningBase as RLBase

#####
##### game logic
#####

const NUM_OBJECTS = 4
const AGENT = 1
const WALL = 2
const GEM = 3
const TARGET = 4
const NUM_ACTIONS = 6

mutable struct TransportUndirected{R, RNG} <: GW.AbstractGridWorld
    tile_map::BitArray{3}
    agent_position::CartesianIndex{2}
    reward::R
    rng::RNG
    done::Bool
    terminal_reward::R
    gem_position::CartesianIndex{2}
    target_position::CartesianIndex{2}
    has_gem::Bool
end

function TransportUndirected(; R = Float32, height = 8, width = 8, rng = Random.GLOBAL_RNG)
    tile_map = falses(NUM_OBJECTS, height, width)

    tile_map[WALL, 1, :] .= true
    tile_map[WALL, height, :] .= true
    tile_map[WALL, :, 1] .= true
    tile_map[WALL, :, width] .= true

    agent_position = GW.sample_empty_position(rng, tile_map)
    tile_map[AGENT, agent_position] = true

    gem_position = GW.sample_empty_position(rng, tile_map)
    tile_map[GEM, gem_position] = true

    target_position = GW.sample_empty_position(rng, tile_map)
    tile_map[TARGET, target_position] = true

    reward = zero(R)
    done = false
    terminal_reward = one(R)
    has_gem = false

    env = TransportUndirected(tile_map, agent_position, reward, rng, done, terminal_reward, gem_position, target_position, has_gem)

    GW.reset!(env)

    return env
end

function GW.reset!(env::TransportUndirected)
    tile_map = env.tile_map
    rng = env.rng

    tile_map[AGENT, env.agent_position] = false
    tile_map[GEM, env.gem_position] = false
    tile_map[TARGET, env.target_position] = false

    new_agent_position = GW.sample_empty_position(rng, tile_map)
    env.agent_position = new_agent_position
    tile_map[AGENT, new_agent_position] = true

    new_gem_position = GW.sample_empty_position(rng, tile_map)
    env.gem_position = new_gem_position
    tile_map[GEM, new_gem_position] = true

    new_target_position = GW.sample_empty_position(rng, tile_map)
    env.target_position = new_target_position
    tile_map[TARGET, new_target_position] = true

    env.reward = zero(env.reward)
    env.done = false

    return nothing
end

function GW.act!(env::TransportUndirected, action)
    @assert action in Base.OneTo(NUM_ACTIONS) "Invalid action $(action)"

    tile_map = env.tile_map

    agent_position = env.agent_position

    if action in 1:4
        if action == 1
            new_agent_position = CartesianIndex(GW.move_up(agent_position.I...))
        elseif action == 2
            new_agent_position = CartesianIndex(GW.move_down(agent_position.I...))
        elseif action == 3
            new_agent_position = CartesianIndex(GW.move_left(agent_position.I...))
        else
            new_agent_position = CartesianIndex(GW.move_right(agent_position.I...))
        end

        if !tile_map[WALL, new_agent_position]
            tile_map[AGENT, agent_position] = false
            env.agent_position = new_agent_position
            tile_map[AGENT, new_agent_position] = true
        end
    elseif action == 5 && tile_map[GEM, agent_position]
        tile_map[GEM, agent_position] = false
        env.has_gem = true
    elseif action == 6 && env.has_gem
        env.has_gem = false
        env.gem_position = agent_position
        tile_map[GEM, agent_position] = true
    end

    if tile_map[GEM, env.target_position]
        env.reward = env.terminal_reward
        env.done = true
    else
        env.reward = zero(env.reward)
        env.done = false
    end

    return nothing
end

#####
##### miscellaneous
#####

CHARACTERS = ('☻', '█', '♦', '✖', '⋅')

GW.get_height(env::TransportUndirected) = size(env.tile_map, 2)
GW.get_width(env::TransportUndirected) = size(env.tile_map, 3)

function GW.get_pretty_tile_map(env::TransportUndirected, i::Integer, j::Integer)
    object = findfirst(@view env.tile_map[:, i, j])
    if isnothing(object)
        return CHARACTERS[end]
    else
        return CHARACTERS[object]
    end
end

GW.get_action_keys(env::TransportUndirected) = ('w', 's', 'a', 'd', 'p', 'l')
GW.get_action_names(env::TransportUndirected) = (:MOVE_UP, :MOVE_DOWN, :MOVE_LEFT, :MOVE_RIGHT, :PICK_UP, :DROP)

function Base.show(io::IO, ::MIME"text/plain", env::TransportUndirected)
    str = GW.get_pretty_tile_map(env)
    str = str * "\nreward = $(env.reward)\ndone = $(env.done)\nhas_gem = $(env.has_gem)"
    print(io, str)
    return nothing
end

#####
##### RLBase API
#####

RLBase.StateStyle(env::GW.RLBaseEnv{E}) where {E <: TransportUndirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: TransportUndirected} = nothing
RLBase.state(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: TransportUndirected} = env.env.tile_map

RLBase.reset!(env::GW.RLBaseEnv{E}) where {E <: TransportUndirected} = GW.reset!(env.env)

RLBase.action_space(env::GW.RLBaseEnv{E}) where {E <: TransportUndirected} = Base.OneTo(NUM_ACTIONS)
(env::GW.RLBaseEnv{E})(action) where {E <: TransportUndirected} = GW.act!(env.env, action)

RLBase.reward(env::GW.RLBaseEnv{E}) where {E <: TransportUndirected} = env.env.reward
RLBase.is_terminated(env::GW.RLBaseEnv{E}) where {E <: TransportUndirected} = env.env.done

end # module
