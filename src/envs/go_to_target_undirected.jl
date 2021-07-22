module GoToTargetUndirectedModule

import ..GridWorlds as GW
import Random
import ReinforcementLearningBase as RLBase

#####
##### game logic
#####

const NUM_OBJECTS = 4
const AGENT = 1
const WALL = 2
const TARGET1 = 3
const TARGET2 = 4
const NUM_ACTIONS = 4

mutable struct GoToTargetUndirected{R, RNG} <: GW.AbstractGridWorld
    tile_map::BitArray{3}
    agent_position::CartesianIndex{2}
    reward::R
    rng::RNG
    done::Bool
    terminal_reward::R
    terminal_penalty::R
    target::Int
    target1_position::CartesianIndex{2}
    target2_position::CartesianIndex{2}
end

function GoToTargetUndirected(; R = Float32, height = 8, width = 8, rng = Random.GLOBAL_RNG)
    tile_map = falses(NUM_OBJECTS, height, width)

    inner_area = CartesianIndices((2 : height - 1, 2 : width - 1))

    tile_map[WALL, 1, :] .= true
    tile_map[WALL, height, :] .= true
    tile_map[WALL, :, 1] .= true
    tile_map[WALL, :, width] .= true

    agent_position = GW.sample_empty_position(rng, tile_map)
    tile_map[AGENT, agent_position] = true

    target1_position = GW.sample_empty_position(rng, tile_map)
    tile_map[TARGET1, target1_position] = true

    target2_position = GW.sample_empty_position(rng, tile_map)
    tile_map[TARGET2, target2_position] = true

    reward = zero(R)
    done = false
    terminal_reward = one(R)
    terminal_penalty = -one(R)
    target = rand(rng, 1:2)

    env = GoToTargetUndirected(tile_map, agent_position, reward, rng, done, terminal_reward, terminal_penalty, target, target1_position, target2_position)

    GW.reset!(env)

    return env
end

function GW.reset!(env::GoToTargetUndirected)
    tile_map = env.tile_map
    rng = env.rng

    tile_map[AGENT, env.agent_position] = false
    tile_map[TARGET1, env.target1_position] = false
    tile_map[TARGET2, env.target2_position] = false

    new_agent_position = GW.sample_empty_position(rng, tile_map)
    env.agent_position = new_agent_position
    tile_map[AGENT, new_agent_position] = true

    new_target1_position = GW.sample_empty_position(rng, tile_map)
    env.target1_position = new_target1_position
    tile_map[TARGET1, new_target1_position] = true

    new_target2_position = GW.sample_empty_position(rng, tile_map)
    env.target2_position = new_target2_position
    tile_map[TARGET2, new_target2_position] = true

    env.target = rand(rng, 1:2)
    env.reward = zero(env.reward)
    env.done = false

    return nothing
end

function GW.act!(env::GoToTargetUndirected, action)
    tile_map = env.tile_map

    if action == 1
        new_agent_position = CartesianIndex(GW.move_up(env.agent_position.I...))
    elseif action == 2
        new_agent_position = CartesianIndex(GW.move_down(env.agent_position.I...))
    elseif action == 3
        new_agent_position = CartesianIndex(GW.move_left(env.agent_position.I...))
    elseif action == 4
        new_agent_position = CartesianIndex(GW.move_right(env.agent_position.I...))
    end

    if !tile_map[WALL, new_agent_position]
        tile_map[AGENT, env.agent_position] = false
        env.agent_position = new_agent_position
        tile_map[AGENT, new_agent_position] = true
    end

    agent_position = env.agent_position
    if tile_map[TARGET1, agent_position] || tile_map[TARGET2, agent_position]
        env.done = true
        if tile_map[2 + env.target, agent_position]
            env.reward = env.terminal_reward
        else
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

CHARACTERS = ('☻', '█', '✖', '♦', '⋅')

GW.get_tile_map_height(env::GoToTargetUndirected) = size(env.tile_map, 2)
GW.get_tile_map_width(env::GoToTargetUndirected) = size(env.tile_map, 3)

function GW.get_tile_pretty_repr(env::GoToTargetUndirected, i::Integer, j::Integer)
    object = findfirst(@view env.tile_map[:, i, j])
    if isnothing(object)
        return CHARACTERS[end]
    else
        return CHARACTERS[object]
    end
end

GW.get_action_keys(env::GoToTargetUndirected) = ('w', 's', 'a', 'd')
GW.get_action_names(env::GoToTargetUndirected) = (:MOVE_UP, :MOVE_DOWN, :MOVE_LEFT, :MOVE_RIGHT)

function Base.show(io::IO, ::MIME"text/plain", env::GoToTargetUndirected)
    str = GW.get_tile_map_pretty_repr(env)
    str = str * "\nreward = $(env.reward)\ndone = $(env.done)\ntarget = $(env.target) ($(CHARACTERS[2 + env.target]))"
    print(io, str)
    return nothing
end

#####
##### RLBase API
#####

RLBase.StateStyle(env::GW.RLBaseEnv{E}) where {E <: GoToTargetUndirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GoToTargetUndirected} = nothing
RLBase.state(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GoToTargetUndirected} = (env.env.tile_map, env.env.target)

RLBase.reset!(env::GW.RLBaseEnv{E}) where {E <: GoToTargetUndirected} = GW.reset!(env.env)

RLBase.action_space(env::GW.RLBaseEnv{E}) where {E <: GoToTargetUndirected} = Base.OneTo(NUM_ACTIONS)
(env::GW.RLBaseEnv{E})(action) where {E <: GoToTargetUndirected} = GW.act!(env.env, action)

RLBase.reward(env::GW.RLBaseEnv{E}) where {E <: GoToTargetUndirected} = env.env.reward
RLBase.is_terminated(env::GW.RLBaseEnv{E}) where {E <: GoToTargetUndirected} = env.env.done

end # module
