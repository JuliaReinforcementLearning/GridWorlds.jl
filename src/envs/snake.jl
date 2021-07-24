module SnakeModule

import DataStructures as DS
import ..GridWorlds as GW
import Random
import ReinforcementLearningBase as RLBase

#####
##### game logic
#####

const NUM_OBJECTS = 4
const AGENT = 1
const WALL = 2
const BODY = 3
const FOOD = 4
const NUM_ACTIONS = 4

mutable struct Snake{R, RNG} <: GW.AbstractGridWorld
    tile_map::BitArray{3}
    agent_position::CartesianIndex{2}
    reward::R
    rng::RNG
    done::Bool
    terminal_reward::R
    terminal_penalty::R
    food_reward::R
    food_position::CartesianIndex{2}
    body::DS.Queue{CartesianIndex{2}}
end

function Snake(; R = Float32, height = 8, width = 8, rng = Random.GLOBAL_RNG)
    tile_map = falses(NUM_OBJECTS, height, width)

    tile_map[WALL, 1, :] .= true
    tile_map[WALL, height, :] .= true
    tile_map[WALL, :, 1] .= true
    tile_map[WALL, :, width] .= true

    agent_position = GW.sample_empty_position(rng, tile_map)
    tile_map[AGENT, agent_position] = true
    body = DS.Queue{CartesianIndex{2}}()
    DS.enqueue!(body, agent_position)
    tile_map[BODY, agent_position] = true

    food_position = GW.sample_empty_position(rng, tile_map)
    tile_map[FOOD, food_position] = true

    reward = zero(R)
    food_reward = one(R)
    terminal_reward = convert(R, height * width)
    terminal_penalty = convert(R, -height * width)
    done = false

    env = Snake(tile_map, agent_position, reward, rng, done, terminal_reward, terminal_penalty, food_reward, food_position, body)

    GW.reset!(env)

    return env
end

function GW.reset!(env::Snake)
    tile_map = env.tile_map
    rng = env.rng
    body = env.body

    tile_map[AGENT, env.agent_position] = false
    tile_map[FOOD, env.food_position] = false

    for i in 1:length(body)
        pos = DS.dequeue!(body)
        tile_map[BODY, pos] = false
    end

    new_agent_position = GW.sample_empty_position(rng, tile_map)
    env.agent_position = new_agent_position
    tile_map[AGENT, new_agent_position] = true
    DS.enqueue!(body, new_agent_position)
    tile_map[BODY, new_agent_position] = true

    new_food_position = GW.sample_empty_position(rng, tile_map)
    env.food_position = new_food_position
    tile_map[FOOD, new_food_position] = true

    env.reward = zero(env.reward)
    env.done = false

    return nothing
end

function GW.act!(env::Snake, action)
    @assert action in Base.OneTo(NUM_ACTIONS) "Invalid action $(action). Action must be in Base.OneTo($(NUM_ACTIONS))"

    tile_map = env.tile_map
    rng = env.rng
    body = env.body
    _, height, width = size(tile_map)
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

    if (tile_map[WALL, new_agent_position] || tile_map[BODY, new_agent_position])
        env.reward = env.terminal_penalty
        env.done = true
    elseif tile_map[FOOD, new_agent_position]
        tile_map[AGENT, agent_position] = false
        env.agent_position = new_agent_position
        tile_map[AGENT, new_agent_position] = true

        DS.enqueue!(body, new_agent_position)
        tile_map[BODY, new_agent_position] = true

        tile_map[FOOD, new_agent_position] = false

        if length(body) == (height - 2) * (width - 2)
            env.reward = env.food_reward + env.terminal_reward
            env.done = true
        else
            new_food_position = GW.sample_empty_position(rng, tile_map)
            env.food_position = new_food_position
            tile_map[FOOD, new_food_position] = true

            env.reward = env.food_reward
            env.done = false
        end
    else
        tile_map[AGENT, agent_position] = false
        env.agent_position = new_agent_position
        tile_map[AGENT, new_agent_position] = true

        DS.enqueue!(body, new_agent_position)
        tile_map[BODY, new_agent_position] = true

        last_position = DS.dequeue!(body)
        tile_map[BODY, last_position] = false

        env.reward = zero(env.reward)
        env.done = false
    end

    return nothing
end

#####
##### miscellaneous
#####

GW.get_height(env::Snake) = size(env.tile_map, 2)
GW.get_width(env::Snake) = size(env.tile_map, 3)

GW.get_action_names(env::Snake) = (:MOVE_UP, :MOVE_DOWN, :MOVE_LEFT, :MOVE_RIGHT)
GW.get_object_names(env::Snake) = (:AGENT, :WALL, :BODY, :FOOD)

function GW.get_pretty_tile_map(env::Snake, position::CartesianIndex{2})
    characters = ('☻', '█', '∘', '♦', '⋅')

    object = findfirst(@view env.tile_map[:, position])
    if isnothing(object)
        return characters[end]
    else
        return characters[object]
    end
end

function GW.get_pretty_sub_tile_map(env::Snake, window_size, position::CartesianIndex{2})
    tile_map = env.tile_map
    agent_position = env.agent_position

    characters = ('☻', '█', '∘', '♦', '⋅')

    sub_tile_map = GW.get_sub_tile_map(tile_map, agent_position, window_size)

    object = findfirst(@view sub_tile_map[:, position])
    if isnothing(object)
        return characters[end]
    else
        return characters[object]
    end
end

function Base.show(io::IO, ::MIME"text/plain", env::Snake)
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

GW.get_action_keys(env::Snake) = ('w', 's', 'a', 'd')

#####
##### RLBase API
#####

RLBase.StateStyle(env::GW.RLBaseEnv{E}) where {E <: Snake} = RLBase.Observation{Any}()
RLBase.state_space(env::GW.RLBaseEnv{E}, ::RLBase.Observation) where {E <: Snake} = nothing
RLBase.state(env::GW.RLBaseEnv{E}, ::RLBase.Observation) where {E <: Snake} = env.env.tile_map

RLBase.reset!(env::GW.RLBaseEnv{E}) where {E <: Snake} = GW.reset!(env.env)

RLBase.action_space(env::GW.RLBaseEnv{E}) where {E <: Snake} = Base.OneTo(NUM_ACTIONS)
(env::GW.RLBaseEnv{E})(action) where {E <: Snake} = GW.act!(env.env, action)

RLBase.reward(env::GW.RLBaseEnv{E}) where {E <: Snake} = env.env.reward
RLBase.is_terminated(env::GW.RLBaseEnv{E}) where {E <: Snake} = env.env.done

end # module
