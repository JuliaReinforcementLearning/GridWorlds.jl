module SingleRoomUndirectedModule

import ..GridWorlds as GW
import Random
import ReinforcementLearningBase as RLBase

mutable struct SingleRoomUndirected{R, RNG} <: GW.AbstractGridWorld
    tile_map::BitArray{3}
    agent_position::CartesianIndex{2}
    reward::R
    rng::RNG
    done::Bool
    terminal_reward::R
    goal_position::CartesianIndex{2}
end

const NUM_OBJECTS = 3
const AGENT = 1
const WALL = 2
const GOAL = 3
GW.get_characters(env::SingleRoomUndirected) = ('☻', '█', '♥', '⋅')

const NUM_ACTIONS = 4
GW.get_action_keys(env::SingleRoomUndirected) = ('w', 's', 'a', 'd')
GW.get_action_names(env::SingleRoomUndirected) = (:MOVE_UP, :MOVE_DOWN, :MOVE_LEFT, :MOVE_RIGHT)

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

    num_objects, height, width = size(tile_map)
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
##### RLBase API
#####

RLBase.StateStyle(env::SingleRoomUndirected) = RLBase.InternalState{Any}()
RLBase.state_space(env::SingleRoomUndirected, ::RLBase.InternalState) = nothing
RLBase.state(env::SingleRoomUndirected, ::RLBase.InternalState) = env.tile_map

RLBase.action_space(env::SingleRoomUndirected) = 1:NUM_ACTIONS
RLBase.reward(env::SingleRoomUndirected) = env.reward
RLBase.is_terminated(env::SingleRoomUndirected) = env.done
RLBase.reset!(env::SingleRoomUndirected{R}) where {R} = GW.reset!(env)

(env::SingleRoomUndirected)(action) = GW.act!(env, action)

end # module
