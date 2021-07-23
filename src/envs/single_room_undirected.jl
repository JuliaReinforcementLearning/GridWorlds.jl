module SingleRoomUndirectedModule

import ..GridWorlds as GW
import Random
import ReinforcementLearningBase as RLBase

#####
##### game logic
#####

const NUM_OBJECTS = 3
const AGENT = 1
const WALL = 2
const GOAL = 3
const NUM_ACTIONS = 4

mutable struct SingleRoomUndirected{R, RNG} <: GW.AbstractGridWorld
    tile_map::BitArray{3}
    agent_position::CartesianIndex{2}
    reward::R
    rng::RNG
    done::Bool
    terminal_reward::R
    goal_position::CartesianIndex{2}
end

function SingleRoomUndirected(; R = Float32, height = 8, width = 8, rng = Random.GLOBAL_RNG)
    tile_map = BitArray(undef, NUM_OBJECTS, height, width)

    inner_area = CartesianIndices((2 : height - 1, 2 : width - 1))

    tile_map[:, :, :] .= false
    tile_map[WALL, 1, :] .= true
    tile_map[WALL, height, :] .= true
    tile_map[WALL, :, 1] .= true
    tile_map[WALL, :, width] .= true

    agent_position, goal_position = GW.sample_two_positions_without_replacement(rng, inner_area)

    tile_map[AGENT, agent_position] = true
    tile_map[GOAL, goal_position] = true

    reward = zero(R)
    done = false
    terminal_reward = one(R)

    env = SingleRoomUndirected(tile_map, agent_position, reward, rng, done, terminal_reward, goal_position)

    GW.reset!(env)

    return env
end

function GW.reset!(env::SingleRoomUndirected)
    tile_map = env.tile_map
    rng = env.rng

    _, height, width = size(tile_map)
    inner_area = CartesianIndices((2 : height - 1, 2 : width - 1))

    tile_map[AGENT, env.agent_position] = false
    tile_map[GOAL, env.goal_position] = false

    new_agent_position, new_goal_position = GW.sample_two_positions_without_replacement(rng, inner_area)

    env.agent_position = new_agent_position
    tile_map[AGENT, new_agent_position] = true

    env.goal_position = new_goal_position
    tile_map[GOAL, new_goal_position] = true

    env.reward = zero(env.reward)
    env.done = false

    return nothing
end

function GW.act!(env::SingleRoomUndirected, action)
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

    if tile_map[GOAL, env.agent_position]
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

GW.get_height(env::SingleRoomUndirected) = size(env.tile_map, 2)
GW.get_width(env::SingleRoomUndirected) = size(env.tile_map, 3)

GW.get_action_names(env::SingleRoomUndirected) = (:MOVE_UP, :MOVE_DOWN, :MOVE_LEFT, :MOVE_RIGHT)
GW.get_object_names(env::SingleRoomUndirected) = (:AGENT, :WALL, :GOAL)

function GW.get_pretty_tile_map(env::SingleRoomUndirected, position::CartesianIndex{2})
    characters = ('☻', '█', '♥', '⋅')

    object = findfirst(@view env.tile_map[:, position])
    if isnothing(object)
        return characters[end]
    else
        return characters[object]
    end
end

function GW.get_pretty_sub_tile_map(env::SingleRoomUndirected, window_size, position::CartesianIndex{2})
    tile_map = env.tile_map
    agent_position = env.agent_position

    characters = ('☻', '█', '♥', '⋅')

    sub_tile_map = GW.get_sub_tile_map(tile_map, agent_position, window_size)

    object = findfirst(@view sub_tile_map[:, position])
    if isnothing(object)
        return characters[end]
    else
        return characters[object]
    end
end

function Base.show(io::IO, ::MIME"text/plain", env::SingleRoomUndirected)
    str = "tile_map:\n"
    str = str * GW.get_pretty_tile_map(env)
    str = str * "\nsub_tile_map:\n"
    str = str * GW.get_pretty_sub_tile_map(env, GW.get_window_size(env))
    str = str * "\nreward: $(env.reward)"
    str = str * "\ndone: $(env.done)"
    str = str * "\naction_names: $(GW.get_action_names(env))"
    str = str * "\nobject_names: $(GW.get_object_names(env))"
    print(io, str)
    return nothing
end

GW.get_action_keys(env::SingleRoomUndirected) = ('w', 's', 'a', 'd')

#####
##### RLBase API
#####

RLBase.StateStyle(env::GW.RLBaseEnv{E}) where {E <: SingleRoomUndirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: SingleRoomUndirected} = nothing
RLBase.state(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: SingleRoomUndirected} = env.env.tile_map

RLBase.reset!(env::GW.RLBaseEnv{E}) where {E <: SingleRoomUndirected} = GW.reset!(env.env)

RLBase.action_space(env::GW.RLBaseEnv{E}) where {E <: SingleRoomUndirected} = Base.OneTo(NUM_ACTIONS)
(env::GW.RLBaseEnv{E})(action) where {E <: SingleRoomUndirected} = GW.act!(env.env, action)

RLBase.reward(env::GW.RLBaseEnv{E}) where {E <: SingleRoomUndirected} = env.env.reward
RLBase.is_terminated(env::GW.RLBaseEnv{E}) where {E <: SingleRoomUndirected} = env.env.done

end # module
