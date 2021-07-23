module MazeUndirectedModule

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

mutable struct MazeUndirected{R, RNG} <: GW.AbstractGridWorld
    tile_map::BitArray{3}
    agent_position::CartesianIndex{2}
    reward::R
    rng::RNG
    done::Bool
    terminal_reward::R
    goal_position::CartesianIndex{2}
end

function MazeUndirected(; R = Float32, height = 9, width = 9, rng = Random.GLOBAL_RNG)
    @assert isodd(height) && isodd(width) "height and width must be odd numbers"

    tile_map = falses(NUM_OBJECTS, height, width)

    tile_map[WALL, :, :] .= true
    for j in 2 : 2 : width - 1
        for i in 2 : 2 : height - 1
            tile_map[WALL, i, j] = false
        end
    end

    agent_position = CartesianIndex(2, 2)
    tile_map[AGENT, agent_position] = true

    goal_position = CartesianIndex(height - 1, width - 1)
    tile_map[GOAL, goal_position] = true

    reward = zero(R)
    done = false
    terminal_reward = one(R)

    env = MazeUndirected(tile_map, agent_position, reward, rng, done, terminal_reward, goal_position)

    GW.reset!(env)

    return env
end

function GW.reset!(env::MazeUndirected)
    tile_map = env.tile_map
    rng = env.rng
    _, height, width = size(tile_map)

    tile_map[AGENT, env.agent_position] = false
    tile_map[GOAL, env.goal_position] = false

    tile_map[WALL, :, :] .= true
    for j in 2 : 2 : width - 1
        for i in 2 : 2 : height - 1
            tile_map[WALL, i, j] = false
        end
    end

    generate_maze!(env)

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

function GW.act!(env::MazeUndirected, action)
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

function generate_maze!(env::MazeUndirected)
    tile_map = env.tile_map
    rng = env.rng
    _, height, width = size(tile_map)

    vertical_range = 2:2:height-1
    horizontal_range = 2:2:width-1

    visited = falses(height, width)
    stack = CartesianIndex{2}[]

    first_cell = CartesianIndex(rand(rng, vertical_range), rand(rng, horizontal_range))
    visited[first_cell] = true
    push!(stack, first_cell)

    valid_neighbors = CartesianIndex{2}[]

    while !isempty(stack)
        current_cell = pop!(stack)

        i, j = current_cell.I
        all_neighbors = (CartesianIndex(i - 2, j), CartesianIndex(i, j - 2), CartesianIndex(i, j + 2), CartesianIndex(i + 2, j))

        empty!(valid_neighbors)
        for neighbor in all_neighbors
            if (neighbor.I[1] in vertical_range) && (neighbor.I[2] in horizontal_range) && !visited[neighbor]
                push!(valid_neighbors, neighbor)
            end
        end

        if length(valid_neighbors) > 0
            push!(stack, current_cell)

            next_cell = rand(rng, valid_neighbors)

            mid_pos = CartesianIndex((current_cell.I .+ next_cell.I) .÷ 2)
            tile_map[WALL, mid_pos] = false

            visited[next_cell] = true
            push!(stack, next_cell)
        end
    end

    return nothing
end

#####
##### miscellaneous
#####

GW.get_height(env::MazeUndirected) = size(env.tile_map, 2)
GW.get_width(env::MazeUndirected) = size(env.tile_map, 3)

GW.get_action_names(env::MazeUndirected) = (:MOVE_UP, :MOVE_DOWN, :MOVE_LEFT, :MOVE_RIGHT)
GW.get_object_names(env::MazeUndirected) = (:AGENT, :WALL, :GOAL)

function GW.get_pretty_tile_map(env::MazeUndirected, position::CartesianIndex{2})
    characters = ('☻', '█', '♥', '⋅')

    object = findfirst(@view env.tile_map[:, position])
    if isnothing(object)
        return characters[end]
    else
        return characters[object]
    end
end

function GW.get_pretty_sub_tile_map(env::MazeUndirected, window_size, position::CartesianIndex{2})
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

function Base.show(io::IO, ::MIME"text/plain", env::MazeUndirected)
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

GW.get_action_keys(env::MazeUndirected) = ('w', 's', 'a', 'd')

#####
##### RLBase API
#####

RLBase.StateStyle(env::GW.RLBaseEnv{E}) where {E <: MazeUndirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: MazeUndirected} = nothing
RLBase.state(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: MazeUndirected} = env.env.tile_map

RLBase.reset!(env::GW.RLBaseEnv{E}) where {E <: MazeUndirected} = GW.reset!(env.env)

RLBase.action_space(env::GW.RLBaseEnv{E}) where {E <: MazeUndirected} = Base.OneTo(NUM_ACTIONS)
(env::GW.RLBaseEnv{E})(action) where {E <: MazeUndirected} = GW.act!(env.env, action)

RLBase.reward(env::GW.RLBaseEnv{E}) where {E <: MazeUndirected} = env.env.reward
RLBase.is_terminated(env::GW.RLBaseEnv{E}) where {E <: MazeUndirected} = env.env.done

end # module
