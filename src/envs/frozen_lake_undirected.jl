module FrozenLakeUndirectedModule

import ..GridWorlds as GW
import Random
import ReinforcementLearningBase as RLBase
using AStarSearch

#####
##### game logic 
#####

const NUM_OBJECTS = 4
const AGENT = 1
const WALL = 2
const GOAL = 3
const HOLE = 4
const NUM_ACTIONS = 4

mutable struct FrozenLakeUndirected{R, RNG} <: GW.AbstractGridWorld
    tile_map::BitArray{3}
    map_name::String
    agent_position::CartesianIndex{2}
    reward::R
    rng::RNG
    done::Bool
    terminal_reward::R
    terminal_penalty::R
    goal_position::CartesianIndex{2}
    num_obstacles::Int
    obstacle_positions::Vector{CartesianIndex{2}}
    is_slippery::Bool
    randomize_start_end::Bool
end

function FrozenLakeUndirected(; map_name::String = "", R::Type = Float32, height::Int = 8, width::Int = 8, num_obstacles::Int = floor(Int, sqrt(height * width) / 2), rng = Random.GLOBAL_RNG, is_slippery::Bool = true, randomize_start_end::Bool = false)
    obstacle_positions = Array{CartesianIndex{2}}(undef, num_obstacles)
    if map_name == "6x6"
        height = 6
        width = 6
        num_obstacles = 4
        obstacle_positions = Array{CartesianIndex{2}}(undef, num_obstacles)
        obstacle_positions = [CartesianIndex(3, 3), CartesianIndex(3, 5), CartesianIndex(4, 5), CartesianIndex(5, 2)]
    elseif map_name == "10x10"
        height = 10
        width = 10
        num_obstacles = 10
        obstacle_positions = Array{CartesianIndex{2}}(undef, num_obstacles)
        obstacle_positions = [CartesianIndex(4, 5), CartesianIndex(5, 7), CartesianIndex(6, 5), CartesianIndex(7, 3), CartesianIndex(7, 4), CartesianIndex(7, 8), CartesianIndex(8, 3), CartesianIndex(8, 6), CartesianIndex(8, 8), CartesianIndex(9, 5)]
    elseif map_name != ""
        throw(ArgumentError("Unsupported map_name value: '$(map_name)'. Please use '6x6', '10x10', or undefined."))
    end

    tile_map = falses(NUM_OBJECTS, height, width)

    tile_map[WALL, 1, :] .= true
    tile_map[WALL, height, :] .= true
    tile_map[WALL, :, 1] .= true
    tile_map[WALL, :, width] .= true

    if randomize_start_end
        agent_position = CartesionIndex(rand(rng, [i for i in 2:height - 1]), rand(rng, [i for i in 2:width - 1]))

        #Find a goal that is not the same position as the start point
        goal_position = agent_position
        while agent_position == goal_position
            goal_position = CartesianIndex(rand(rng, [i for i in 2:height - 1]), rand(rng, [i for i in 2:width - 1]))
        end
    else
        agent_position = CartesianIndex(2, 2)
        goal_position = CartesianIndex(height - 1, width - 1)
    end

    tile_map[AGENT, agent_position] = true
    tile_map[GOAL, goal_position] = true

    if map_name == ""
        function get_neighbors(state::CartesianIndex)
            return_list = []
            for pos in [GW.move_up(state), GW.move_down(state), GW.move_left(state), GW.move_right(state)]
                    if !tile_map[WALL, pos] && !tile_map[HOLE, pos]
                        push!(return_list, pos)
                    end
            end
            return return_list
        end

        manhattan(a::CartesianIndex, b::CartesianIndex) = sum(abs.((b-a).I))
        is_goal(state::CartesianIndex, end_state::CartesianIndex) = state == end_state

        distance_heuristic(state::CartesianIndex, end_state::CartesianIndex) = manhattan(state, end_state)

        path_exists = false
        while !path_exists
            obstacle_positions = Array{CartesianIndex{2}}(undef, num_obstacles)
            for i in 1:num_obstacles
                obstacle_position = GW.sample_empty_position(rng, tile_map)
                obstacle_positions[i] = obstacle_position
            end
            tile_map = update_obstacles_on_map(tile_map, obstacle_positions)
            
            path_exists = astar(get_neighbors, agent_position, goal_position; heuristic = distance_heuristic, isgoal = is_goal).status == :success
            @debug "path_exists: $(path_exists)"
        end
    end

    tile_map = update_obstacles_on_map(tile_map, obstacle_positions)

    reward = zero(R)
    done = false
    terminal_reward = one(R)
    terminal_penalty = -one(R)

    env = FrozenLakeUndirected(tile_map, map_name, agent_position, reward, rng, done, terminal_reward, terminal_penalty, goal_position, num_obstacles, obstacle_positions, is_slippery, randomize_start_end)

    return env
end

function update_obstacles_on_map(tile_map, obstacle_positions)
    for position in obstacle_positions
        tile_map[HOLE, position] = true
    end
    return tile_map
end

function GW.reset!(env::FrozenLakeUndirected)
    tile_map = env.tile_map

    tile_map[AGENT, env.agent_position] = false

    agent_position = CartesianIndex(2, 2)
    env.agent_position = agent_position
    tile_map[AGENT, agent_position] = true

    env.reward = zero(env.reward)
    env.done = false

    return nothing
end

function GW.act!(env::FrozenLakeUndirected, action)
    @assert action in Base.OneTo(NUM_ACTIONS) "Invalid action $(action). Action must be in Base.OneTo($(NUM_ACTIONS))"

    tile_map = env.tile_map

    agent_position = env.agent_position

    is_slippery = env.is_slippery

    if action == 1
        new_agent_position = is_slippery ? rand((GW.move_up(agent_position), GW.move_left(agent_position), GW.move_right(agent_position))) : GW.move_up(agent_position)
    elseif action == 2
        new_agent_position = is_slippery ? rand((GW.move_down(agent_position), GW.move_left(agent_position), GW.move_right(agent_position))) : GW.move_down(agent_position)
    elseif action == 3
        new_agent_position = is_slippery ? rand((GW.move_left(agent_position), GW.move_up(agent_position), GW.move_down(agent_position))) : GW.move_left(agent_position)
    else
        new_agent_position = is_slippery ? rand((GW.move_right(agent_position), GW.move_up(agent_position), GW.move_down(agent_position))) : GW.move_right(agent_position)
    end

    if !tile_map[WALL, new_agent_position]
        tile_map[AGENT, agent_position] = false
        env.agent_position = new_agent_position
        tile_map[AGENT, new_agent_position] = true
    end

    if tile_map[GOAL, env.agent_position]
        env.reward = env.terminal_reward
        env.done = true
    elseif tile_map[HOLE, env.agent_position]
        env.reward = env.terminal_penalty
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

GW.get_height(env::FrozenLakeUndirected) = size(env.tile_map, 2)
GW.get_width(env::FrozenLakeUndirected) = size(env.tile_map, 3)

GW.get_action_names(env::FrozenLakeUndirected) = (:MOVE_UP, :MOVE_DOWN, :MOVE_LEFT, :MOVE_RIGHT)
GW.get_object_names(env::FrozenLakeUndirected) = (:AGENT, :WALL, :GOAL, :OBSTACLE)

function GW.get_pretty_tile_map(env::FrozenLakeUndirected, position::CartesianIndex{2})
    characters = ('☻', '█', '♥', '○', '⋅') 

    object = findfirst(@view env.tile_map[:, position])
    if isnothing(object)
        return characters[end]
    else
        return characters[object]
    end
end

function GW.get_pretty_sub_tile_map(env::FrozenLakeUndirected, window_size, position::CartesianIndex{2})
    tile_map = env.tile_map
    agent_position = env.agent_position

    characters = ('☻', '█', '♥', '○', '⋅')

    sub_tile_map = GW.get_sub_tile_map(tile_map, agent_position, window_size)

    object = findfirst(@view sub_tile_map[:, position])
    if isnothing(object)
        return characters[end]
    else
        return characters[object]
    end
end

function Base.show(io::IO, ::MIME"text/plain", env::FrozenLakeUndirected)
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

GW.get_action_keys(env::FrozenLakeUndirected) = ('w', 's', 'a', 'd')

#####
##### FrozenLakeUndirected
#####

RLBase.StateStyle(env::GW.RLBaseEnv{E}) where {E <: FrozenLakeUndirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: FrozenLakeUndirected} = nothing
RLBase.state(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: FrozenLakeUndirected} = env.env.tile_map

RLBase.reset!(env::GW.RLBaseEnv{E}) where {E <: FrozenLakeUndirected} = GW.reset!(env.env)

RLBase.action_space(env::GW.RLBaseEnv{E}) where {E <: FrozenLakeUndirected} = Base.OneTo(NUM_ACTIONS)
(env::GW.RLBaseEnv{E})(action) where {E <: FrozenLakeUndirected} = GW.act!(env.env, action)

RLBase.reward(env::GW.RLBaseEnv{E}) where {E <: FrozenLakeUndirected} = env.env.reward
RLBase.is_terminated(env::GW.RLBaseEnv{E}) where {E <: FrozenLakeUndirected} = env.env.done

end # module
