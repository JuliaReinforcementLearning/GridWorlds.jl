module DynamicObstaclesUndirectedModule

import ..GridWorlds as GW
import Random

mutable struct DynamicObstaclesUndirected{R, RNG} <: GW.AbstractGridWorldGame
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

const NUM_OBJECTS = 4
const AGENT = 1
const WALL = 2
const GOAL = 3
const OBSTACLE = 4

CHARACTERS = ('☻', '█', '♥', '⊗', '⋅')

GW.get_tile_map_height(env::DynamicObstaclesUndirected) = size(env.tile_map, 2)
GW.get_tile_map_width(env::DynamicObstaclesUndirected) = size(env.tile_map, 3)

function GW.get_tile_pretty_repr(env::DynamicObstaclesUndirected, i::Integer, j::Integer)
    object = findfirst(@view env.tile_map[:, i, j])
    if isnothing(object)
        return CHARACTERS[end]
    else
        return CHARACTERS[object]
    end
end

const NUM_ACTIONS = 4
GW.get_action_keys(env::DynamicObstaclesUndirected) = ('w', 's', 'a', 'd')
GW.get_action_names(env::DynamicObstaclesUndirected) = (:MOVE_UP, :MOVE_DOWN, :MOVE_LEFT, :MOVE_RIGHT)

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
    tile_map = env.tile_map
    update_obstacles!(env)

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

function Base.show(io::IO, ::MIME"text/plain", env::DynamicObstaclesUndirected)
    str = GW.get_tile_map_pretty_repr(env)
    str = str * "\nreward = $(env.reward)\ndone = $(env.done)"
    print(io, str)
    return nothing
end

end # module
