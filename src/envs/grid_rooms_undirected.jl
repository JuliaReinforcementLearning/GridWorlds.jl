module GridRoomsUndirectedModule

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

mutable struct GridRoomsUndirected{R, RNG} <: GW.AbstractGridWorld
    tile_map::BitArray{3}
    agent_position::CartesianIndex{2}
    reward::R
    rng::RNG
    done::Bool
    terminal_reward::R
    goal_position::CartesianIndex{2}
end

function GridRoomsUndirected(; R = Float32, grid_size = (2, 2), room_size = (5, 5), rng = Random.GLOBAL_RNG)
    @assert all(room_size .>= (4, 4)) "each element of room_size must be >= 4"
    height_grid, width_grid = grid_size
    height_room, width_room = room_size

    height_tile_map = height_room * height_grid - height_grid + 1
    width_tile_map = width_room * width_grid - width_grid + 1

    tile_map = falses(NUM_OBJECTS, height_tile_map, width_tile_map)

    for i in 1 : height_room - 1 : height_tile_map
        tile_map[WALL, i, :] .= true
    end

    for j in 1 : width_room - 1 : width_tile_map
        tile_map[WALL, :, j] .= true
    end

    for j in width_room ÷ 2 + 1 : width_room - 1 : width_tile_map - 1
        for i in height_room : height_room - 1 : height_tile_map - 1
            tile_map[WALL, i, j] = false
        end
    end

    for j in width_room : width_room - 1 : width_tile_map - 1
        for i in height_room ÷ 2 + 1 : height_room - 1 : height_tile_map - 1
            tile_map[WALL, i, j] = false
        end
    end

    agent_position = GW.sample_empty_position(rng, tile_map)
    tile_map[AGENT, agent_position] = true

    goal_position = GW.sample_empty_position(rng, tile_map)
    tile_map[GOAL, goal_position] = true

    reward = zero(R)
    done = false
    terminal_reward = one(R)

    env = GridRoomsUndirected(tile_map, agent_position, reward, rng, done, terminal_reward, goal_position)

    GW.reset!(env)

    return env
end

function GW.reset!(env::GridRoomsUndirected)
    tile_map = env.tile_map
    rng = env.rng

    _, height, width = size(tile_map)

    tile_map[AGENT, env.agent_position] = false
    tile_map[GOAL, env.goal_position] = false

    new_agent_position = GW.sample_empty_position(rng, tile_map)
    env.agent_position = new_agent_position
    tile_map[AGENT, new_agent_position] = true

    new_goal_position = GW.sample_empty_position(rng, tile_map)
    env.goal_position = new_goal_position
    tile_map[GOAL, new_goal_position] = true

    env.reward = zero(env.reward)
    env.done = false

    return nothing
end

function GW.act!(env::GridRoomsUndirected, action)
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

GW.get_height(env::GridRoomsUndirected) = size(env.tile_map, 2)
GW.get_width(env::GridRoomsUndirected) = size(env.tile_map, 3)

GW.get_action_names(env::GridRoomsUndirected) = (:MOVE_UP, :MOVE_DOWN, :MOVE_LEFT, :MOVE_RIGHT)
GW.get_object_names(env::GridRoomsUndirected) = (:AGENT, :WALL, :GOAL)

function GW.get_pretty_tile_map(env::GridRoomsUndirected, position::CartesianIndex{2})
    characters = ('☻', '█', '♥', '⋅')

    object = findfirst(@view env.tile_map[:, position])
    if isnothing(object)
        return characters[end]
    else
        return characters[object]
    end
end

function GW.get_pretty_sub_tile_map(env::GridRoomsUndirected, window_size, position::CartesianIndex{2})
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

function Base.show(io::IO, ::MIME"text/plain", env::GridRoomsUndirected)
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

GW.get_action_keys(env::GridRoomsUndirected) = ('w', 's', 'a', 'd')

#####
##### RLBase API
#####

RLBase.StateStyle(env::GW.RLBaseEnv{E}) where {E <: GridRoomsUndirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GridRoomsUndirected} = nothing
RLBase.state(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GridRoomsUndirected} = env.env.tile_map

RLBase.reset!(env::GW.RLBaseEnv{E}) where {E <: GridRoomsUndirected} = GW.reset!(env.env)

RLBase.action_space(env::GW.RLBaseEnv{E}) where {E <: GridRoomsUndirected} = Base.OneTo(NUM_ACTIONS)
(env::GW.RLBaseEnv{E})(action) where {E <: GridRoomsUndirected} = GW.act!(env.env, action)

RLBase.reward(env::GW.RLBaseEnv{E}) where {E <: GridRoomsUndirected} = env.env.reward
RLBase.is_terminated(env::GW.RLBaseEnv{E}) where {E <: GridRoomsUndirected} = env.env.done

end # module
