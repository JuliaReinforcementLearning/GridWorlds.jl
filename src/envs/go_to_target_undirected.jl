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
    @assert action in Base.OneTo(NUM_ACTIONS) "Invalid action $(action). Action must be in Base.OneTo($(NUM_ACTIONS))"

    tile_map = env.tile_map
    agent_position = env.agent_position

    if action == 1
        new_agent_position = GW.move_up(agent_position)
    elseif action == 2
        new_agent_position = GW.move_down(agent_position)
    elseif action == 3
        new_agent_position = GW.move_left(agent_position)
    else
        new_agent_position = GW.move_right(agent_position)
    end

    if !tile_map[WALL, new_agent_position]
        tile_map[AGENT, agent_position] = false
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

GW.get_height(env::GoToTargetUndirected) = size(env.tile_map, 2)
GW.get_width(env::GoToTargetUndirected) = size(env.tile_map, 3)

GW.get_action_names(env::GoToTargetUndirected) = (:MOVE_UP, :MOVE_DOWN, :MOVE_LEFT, :MOVE_RIGHT)
GW.get_object_names(env::GoToTargetUndirected) = (:AGENT, :WALL, :TARGET1, :TARGET2)

function GW.get_pretty_tile_map(env::GoToTargetUndirected, position::CartesianIndex{2})
    characters = ('☻', '█', '✖', '♦', '⋅')

    object = findfirst(@view env.tile_map[:, position])
    if isnothing(object)
        return characters[end]
    else
        return characters[object]
    end
end

function GW.get_pretty_sub_tile_map(env::GoToTargetUndirected, window_size, position::CartesianIndex{2})
    tile_map = env.tile_map
    agent_position = env.agent_position

    characters = ('☻', '█', '✖', '♦', '⋅')

    sub_tile_map = GW.get_sub_tile_map(tile_map, agent_position, window_size)

    object = findfirst(@view sub_tile_map[:, position])
    if isnothing(object)
        return characters[end]
    else
        return characters[object]
    end
end

function Base.show(io::IO, ::MIME"text/plain", env::GoToTargetUndirected)
    characters = ('☻', '█', '✖', '♦', '⋅')

    str = "tile_map:\n"
    str = str * GW.get_pretty_tile_map(env)
    str = str * "\nsub_tile_map:\n"
    str = str * GW.get_pretty_sub_tile_map(env, GW.get_window_size(env))
    str = str * "\nreward: $(env.reward)"
    str = str * "\ndone: $(env.done)"
    str = str * "\ntarget = $(env.target) ($(characters[2 + env.target]))"
    str = str * "\naction_names: $(GW.get_action_names(env))"
    str = str * "\nobject_names: $(GW.get_object_names(env))"
    print(io, str)
    return nothing
end

GW.get_action_keys(env::GoToTargetUndirected) = ('w', 's', 'a', 'd')

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
