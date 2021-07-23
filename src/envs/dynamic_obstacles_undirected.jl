module DynamicObstaclesUndirectedModule

import ..GridWorlds as GW
import Random
import ReinforcementLearningBase as RLBase

#####
##### game logic
#####

const NUM_OBJECTS = 4
const AGENT = 1
const WALL = 2
const GOAL = 3
const OBSTACLE = 4
const NUM_ACTIONS = 4

mutable struct DynamicObstaclesUndirected{R, RNG} <: GW.AbstractGridWorld
    tile_map::BitArray{3}
    agent_position::CartesianIndex{2}
    reward::R
    rng::RNG
    done::Bool
    terminal_reward::R
    terminal_penalty::R
    goal_position::CartesianIndex{2}
    num_obstacles::Int
    obstacle_positions::Vector{CartesianIndex{2}}
end

function DynamicObstaclesUndirected(; R = Float32, height = 8, width = 8, num_obstacles = floor(Int, sqrt(height * width) / 2), rng = Random.GLOBAL_RNG)
    tile_map = falses(NUM_OBJECTS, height, width)

    tile_map[WALL, 1, :] .= true
    tile_map[WALL, height, :] .= true
    tile_map[WALL, :, 1] .= true
    tile_map[WALL, :, width] .= true

    agent_position = GW.sample_empty_position(rng, tile_map)
    tile_map[AGENT, agent_position] = true

    goal_position = GW.sample_empty_position(rng, tile_map)
    tile_map[GOAL, goal_position] = true

    obstacle_positions = Array{CartesianIndex{2}}(undef, num_obstacles)
    for i in 1:num_obstacles
        obstacle_position = GW.sample_empty_position(rng, tile_map)
        obstacle_positions[i] = obstacle_position
        tile_map[OBSTACLE, obstacle_position] = true
    end

    reward = zero(R)
    done = false
    terminal_reward = one(R)
    terminal_penalty = -one(R)

    env = DynamicObstaclesUndirected(tile_map, agent_position, reward, rng, done, terminal_reward, terminal_penalty, goal_position, num_obstacles, obstacle_positions)

    # GW.reset!(env)

    return env
end

function GW.reset!(env::DynamicObstaclesUndirected)
    tile_map = env.tile_map
    rng = env.rng

    tile_map[AGENT, env.agent_position] = false
    tile_map[GOAL, env.goal_position] = false

    for i in 1:env.num_obstacles
        tile_map[OBSTACLE, env.obstacle_positions[i]] = false
    end

    new_agent_position = GW.sample_empty_position(rng, tile_map)
    env.agent_position = new_agent_position
    tile_map[AGENT, new_agent_position] = true

    new_goal_position = GW.sample_empty_position(rng, tile_map)
    env.goal_position = new_goal_position
    tile_map[GOAL, new_goal_position] = true

    for i in 1:env.num_obstacles
        new_obstacle_position = GW.sample_empty_position(rng, tile_map)
        env.obstacle_positions[i] = new_obstacle_position
        tile_map[OBSTACLE, new_obstacle_position] = true
    end

    env.reward = zero(env.reward)
    env.done = false

    return nothing
end

function GW.act!(env::DynamicObstaclesUndirected, action)
    @assert action in Base.OneTo(NUM_ACTIONS) "Invalid action $(action). Action must be in Base.OneTo($(NUM_ACTIONS))"

    tile_map = env.tile_map
    update_obstacles!(env)

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
    elseif tile_map[OBSTACLE, env.agent_position]
        env.reward = env.terminal_penalty
        env.done = true
    else
        env.reward = zero(env.reward)
        env.done = false
    end

    return nothing
end

function update_obstacles!(env::DynamicObstaclesUndirected)
    tile_map = env.tile_map
    rng = env.rng

    for (i, position) in enumerate(env.obstacle_positions)
        tile_map[OBSTACLE, position] = false
        neighbors = (position, CartesianIndex(position[1] - 1, position[2]), CartesianIndex(position[1], position[2] - 1), CartesianIndex(position[1], position[2] + 1), CartesianIndex(position[1] + 1, position[2]))
        new_obstacle_position = rand(rng, neighbors)
        while tile_map[WALL, new_obstacle_position] || tile_map[GOAL, new_obstacle_position] || tile_map[OBSTACLE, new_obstacle_position]
            new_obstacle_position = rand(rng, neighbors)
        end
        env.obstacle_positions[i] = new_obstacle_position
        tile_map[OBSTACLE, new_obstacle_position] = true
    end
    
    return nothing
end

#####
##### miscellaneous
#####

GW.get_height(env::DynamicObstaclesUndirected) = size(env.tile_map, 2)
GW.get_width(env::DynamicObstaclesUndirected) = size(env.tile_map, 3)

GW.get_action_names(env::DynamicObstaclesUndirected) = (:MOVE_UP, :MOVE_DOWN, :MOVE_LEFT, :MOVE_RIGHT)
GW.get_object_names(env::DynamicObstaclesUndirected) = (:AGENT, :WALL, :GOAL, :OBSTACLE)

function GW.get_pretty_tile_map(env::DynamicObstaclesUndirected, position::CartesianIndex{2})
    characters = ('☻', '█', '♥', '⊗', '⋅')

    object = findfirst(@view env.tile_map[:, position])
    if isnothing(object)
        return characters[end]
    else
        return characters[object]
    end
end

function GW.get_pretty_sub_tile_map(env::DynamicObstaclesUndirected, window_size, position::CartesianIndex{2})
    tile_map = env.tile_map
    agent_position = env.agent_position

    characters = ('☻', '█', '♥', '⊗', '⋅')

    sub_tile_map = GW.get_sub_tile_map(tile_map, agent_position, window_size)

    object = findfirst(@view sub_tile_map[:, position])
    if isnothing(object)
        return characters[end]
    else
        return characters[object]
    end
end

function Base.show(io::IO, ::MIME"text/plain", env::DynamicObstaclesUndirected)
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

GW.get_action_keys(env::DynamicObstaclesUndirected) = ('w', 's', 'a', 'd')

#####
##### DynamicObstaclesUndirected
#####

RLBase.StateStyle(env::GW.RLBaseEnv{E}) where {E <: DynamicObstaclesUndirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: DynamicObstaclesUndirected} = nothing
RLBase.state(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: DynamicObstaclesUndirected} = env.env.tile_map

RLBase.reset!(env::GW.RLBaseEnv{E}) where {E <: DynamicObstaclesUndirected} = GW.reset!(env.env)

RLBase.action_space(env::GW.RLBaseEnv{E}) where {E <: DynamicObstaclesUndirected} = Base.OneTo(NUM_ACTIONS)
(env::GW.RLBaseEnv{E})(action) where {E <: DynamicObstaclesUndirected} = GW.act!(env.env, action)

RLBase.reward(env::GW.RLBaseEnv{E}) where {E <: DynamicObstaclesUndirected} = env.env.reward
RLBase.is_terminated(env::GW.RLBaseEnv{E}) where {E <: DynamicObstaclesUndirected} = env.env.done

end # module
