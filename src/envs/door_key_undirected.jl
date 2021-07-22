module DoorKeyUndirectedModule

import ..GridWorlds as GW
import Random
import ReinforcementLearningBase as RLBase

#####
##### game logic
#####

const NUM_OBJECTS = 5
const AGENT = 1
const WALL = 2
const GOAL = 3
const DOOR = 4
const KEY = 5
const NUM_ACTIONS = 5

mutable struct DoorKeyUndirected{R, RNG} <: GW.AbstractGridWorld
    tile_map::BitArray{3}
    agent_position::CartesianIndex{2}
    reward::R
    rng::RNG
    done::Bool
    terminal_reward::R
    goal_position::CartesianIndex{2}
    door_position::CartesianIndex{2}
    key_position::CartesianIndex{2}
    partition_dimension::Int
    has_key::Bool
end

function DoorKeyUndirected(; R = Float32, height = 8, width = 8, rng = Random.GLOBAL_RNG)
    tile_map = falses(NUM_OBJECTS, height, width)

    tile_map[WALL, 1, :] .= true
    tile_map[WALL, height, :] .= true
    tile_map[WALL, :, 1] .= true
    tile_map[WALL, :, width] .= true

    partition_dimension = 2

    door_position = CartesianIndex(2, 3)
    tile_map[WALL, 2 : height - 1, door_position[2]] .= true
    tile_map[WALL, door_position] = false
    tile_map[DOOR, door_position] = true

    agent_position = CartesianIndex(2, 2)
    tile_map[AGENT, agent_position] = true

    key_position = CartesianIndex(3, 2)
    tile_map[KEY, key_position] = true

    goal_position = CartesianIndex(height - 1, width - 1)
    tile_map[GOAL, goal_position] = true

    reward = zero(R)
    done = false
    terminal_reward = one(R)
    has_key = false

    env = DoorKeyUndirected(tile_map, agent_position, reward, rng, done, terminal_reward, goal_position, door_position, key_position, partition_dimension, has_key)

    GW.reset!(env)

    return env
end

function GW.reset!(env::DoorKeyUndirected)
    tile_map = env.tile_map
    rng = env.rng

    _, height, width = size(tile_map)

    tile_map[AGENT, env.agent_position] = false
    tile_map[GOAL, env.goal_position] = false
    tile_map[KEY, env.key_position] = false
    tile_map[DOOR, env.door_position] = false
    if env.partition_dimension == 1
        tile_map[WALL, env.door_position[1], 2 : width - 1] .= false
    else
        tile_map[WALL, 2 : height - 1, env.door_position[2]] .= false
    end

    new_partition_dimension = rand(rng, 1:2)
    env.partition_dimension = new_partition_dimension

    if new_partition_dimension == 1
        i_new_door_position = rand(rng, 3 : height - 2)
        j_new_door_position = rand(rng, 2 : width - 1)
        tile_map[WALL, i_new_door_position, :] .= true
        regions = (CartesianIndices((2 : i_new_door_position - 1, 2 : width - 1)), CartesianIndices((i_new_door_position + 1 : height - 1, 2 : width - 1)))
    else
        i_new_door_position = rand(rng, 2 : height - 1)
        j_new_door_position = rand(rng, 3 : width - 2)
        tile_map[WALL, :, j_new_door_position] .= true
        regions = (CartesianIndices((2 : height - 1, 2 : j_new_door_position - 1)), CartesianIndices((2 : height - 1, j_new_door_position + 1 : width - 1)))
    end

    new_door_position = CartesianIndex(i_new_door_position, j_new_door_position)
    env.door_position = new_door_position
    tile_map[WALL, i_new_door_position, j_new_door_position] = false
    tile_map[DOOR, i_new_door_position, j_new_door_position] = true

    new_agent_region = rand(rng, 1:2)
    if new_agent_region == 1
        new_agent_position, new_key_position = GW.sample_two_positions_without_replacement(rng, regions[1])
        new_goal_position = rand(rng, regions[2])
    else
        new_agent_position, new_key_position = GW.sample_two_positions_without_replacement(rng, regions[2])
        new_goal_position = rand(rng, regions[1])
    end

    env.agent_position = new_agent_position
    tile_map[AGENT, new_agent_position] = true

    env.key_position = new_key_position
    tile_map[KEY, new_key_position] = true

    env.goal_position = new_goal_position
    tile_map[GOAL, new_goal_position] = true

    env.reward = zero(env.reward)
    env.done = false
    env.has_key = false

    return nothing
end

function GW.act!(env::DoorKeyUndirected, action)
    tile_map = env.tile_map

    if action == 1
        new_agent_position = CartesianIndex(GW.move_up(env.agent_position.I...))
        if !(tile_map[DOOR, new_agent_position] || tile_map[WALL, new_agent_position]) || (tile_map[DOOR, new_agent_position] && env.has_key)
            tile_map[AGENT, env.agent_position] = false
            env.agent_position = new_agent_position
            tile_map[AGENT, new_agent_position] = true
        end
    elseif action == 2
        new_agent_position = CartesianIndex(GW.move_down(env.agent_position.I...))
        if !(tile_map[DOOR, new_agent_position] || tile_map[WALL, new_agent_position]) || (tile_map[DOOR, new_agent_position] && env.has_key)
            tile_map[AGENT, env.agent_position] = false
            env.agent_position = new_agent_position
            tile_map[AGENT, new_agent_position] = true
        end
    elseif action == 3
        new_agent_position = CartesianIndex(GW.move_left(env.agent_position.I...))
        if !(tile_map[DOOR, new_agent_position] || tile_map[WALL, new_agent_position]) || (tile_map[DOOR, new_agent_position] && env.has_key)
            tile_map[AGENT, env.agent_position] = false
            env.agent_position = new_agent_position
            tile_map[AGENT, new_agent_position] = true
        end
    elseif action == 4
        new_agent_position = CartesianIndex(GW.move_right(env.agent_position.I...))
        if !(tile_map[DOOR, new_agent_position] || tile_map[WALL, new_agent_position]) || (tile_map[DOOR, new_agent_position] && env.has_key)
            tile_map[AGENT, env.agent_position] = false
            env.agent_position = new_agent_position
            tile_map[AGENT, new_agent_position] = true
        end
    else
        if tile_map[KEY, env.agent_position]
            env.has_key = true
            tile_map[KEY, env.agent_position] = false
        end
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

GW.get_height(env::DoorKeyUndirected) = size(env.tile_map, 2)
GW.get_width(env::DoorKeyUndirected) = size(env.tile_map, 3)

GW.get_action_names(env::DoorKeyUndirected) = (:MOVE_UP, :MOVE_DOWN, :MOVE_LEFT, :MOVE_RIGHT, :PICK_UP)
GW.get_object_names(env::DoorKeyUndirected) = (:AGENT, :WALL, :GOAL, :DOOR, :KEY)

function GW.get_pretty_tile_map(env::DoorKeyUndirected, position::CartesianIndex{2})
    characters = ('☻', '█', '♥', '▒', '⚷', '⋅')

    object = findfirst(@view env.tile_map[:, position])
    if isnothing(object)
        return characters[end]
    else
        return characters[object]
    end
end

function GW.get_pretty_sub_tile_map(env::DoorKeyUndirected, window_size, position::CartesianIndex{2})
    tile_map = env.tile_map
    agent_position = env.agent_position

    characters = ('☻', '█', '♥', '▒', '⚷', '⋅')

    sub_tile_map = GW.get_sub_tile_map(tile_map, agent_position, window_size)

    object = findfirst(@view sub_tile_map[:, position])
    if isnothing(object)
        return characters[end]
    else
        return characters[object]
    end
end

function Base.show(io::IO, ::MIME"text/plain", env::DoorKeyUndirected)
    str = "tile_map:\n"
    str = str * GW.get_pretty_tile_map(env)
    str = str * "\nsub_tile_map:\n"
    str = str * GW.get_pretty_sub_tile_map(env, GW.get_window_size(env))
    str = str * "\nreward: $(env.reward)"
    str = str * "\ndone: $(env.done)"
    str = str * "\nhas_key: $(env.has_key)"
    str = str * "\naction_names: $(GW.get_action_names(env))"
    str = str * "\nobject_names: $(GW.get_object_names(env))"
    print(io, str)
    return nothing
end

GW.get_action_keys(env::DoorKeyUndirected) = ('w', 's', 'a', 'd', 'p')

#####
##### RLBase API
#####

RLBase.StateStyle(env::GW.RLBaseEnv{E}) where {E <: DoorKeyUndirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: DoorKeyUndirected} = nothing
RLBase.state(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: DoorKeyUndirected} = env.env.tile_map

RLBase.reset!(env::GW.RLBaseEnv{E}) where {E <: DoorKeyUndirected} = GW.reset!(env.env)

RLBase.action_space(env::GW.RLBaseEnv{E}) where {E <: DoorKeyUndirected} = Base.OneTo(NUM_ACTIONS)
(env::GW.RLBaseEnv{E})(action) where {E <: DoorKeyUndirected} = GW.act!(env.env, action)

RLBase.reward(env::GW.RLBaseEnv{E}) where {E <: DoorKeyUndirected} = env.env.reward
RLBase.is_terminated(env::GW.RLBaseEnv{E}) where {E <: DoorKeyUndirected} = env.env.done

end # module
