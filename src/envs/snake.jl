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

mutable struct Snake{R, RNG} <: GW.AbstractGridWorldGame
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
    tile_map = env.tile_map
    rng = env.rng
    body = env.body
    _, height, width = size(tile_map)

    if action == 1
        dest = CartesianIndex(GW.move_up(env.agent_position.I...))
    elseif action == 2
        dest = CartesianIndex(GW.move_down(env.agent_position.I...))
    elseif action == 3
        dest = CartesianIndex(GW.move_left(env.agent_position.I...))
    elseif action == 4
        dest = CartesianIndex(GW.move_right(env.agent_position.I...))
    else
        error("Invalid action $(action)")
    end

    if (tile_map[WALL, dest] || tile_map[BODY, dest])
        env.reward = env.terminal_penalty
        env.done = true
    elseif tile_map[FOOD, dest]
        tile_map[AGENT, env.agent_position] = false
        env.agent_position = dest
        tile_map[AGENT, dest] = true

        DS.enqueue!(body, dest)
        tile_map[BODY, dest] = true

        tile_map[FOOD, dest] = false

        if length(body) == (height - 2) * (width - 2)
            env.reward = env.food_reward + env.terminal_reward
            env.done = true
        else
            new_food_position = GW.sample_empty_position(rng, tile_map, 100 * height * width)
            env.food_position = new_food_position
            tile_map[FOOD, new_food_position] = true

            env.reward = env.food_reward
            env.done = false
        end
    else
        tile_map[AGENT, env.agent_position] = false
        env.agent_position = dest
        tile_map[AGENT, dest] = true

        DS.enqueue!(body, dest)
        tile_map[BODY, dest] = true

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

CHARACTERS = ('☻', '█', '∘', '♦', '⋅')

GW.get_tile_map_height(env::Snake) = size(env.tile_map, 2)
GW.get_tile_map_width(env::Snake) = size(env.tile_map, 3)

function GW.get_tile_pretty_repr(env::Snake, i::Integer, j::Integer)
    object = findfirst(@view env.tile_map[:, i, j])
    if isnothing(object)
        return CHARACTERS[end]
    else
        return CHARACTERS[object]
    end
end

GW.get_action_keys(env::Snake) = ('w', 's', 'a', 'd')
GW.get_action_names(env::Snake) = (:MOVE_UP, :MOVE_DOWN, :MOVE_LEFT, :MOVE_RIGHT)

function Base.show(io::IO, ::MIME"text/plain", env::Snake)
    str = GW.get_tile_map_pretty_repr(env)
    str = str * "\nreward = $(env.reward)\ndone = $(env.done)"
    print(io, str)
    return nothing
end

#####
##### RLBase API
#####

RLBase.StateStyle(env::GW.RLBaseEnv{E}) where {E <: Snake} = RLBase.Observation{Any}()
RLBase.state_space(env::GW.RLBaseEnv{E}, ::RLBase.Observation) where {E <: Snake} = nothing
RLBase.state(env::GW.RLBaseEnv{E}, ::RLBase.Observation) where {E <: Snake} = env.env.tile_map

RLBase.reset!(env::GW.RLBaseEnv{E}) where {E <: Snake} = GW.reset!(env.env)

RLBase.action_space(env::GW.RLBaseEnv{E}) where {E <: Snake} = 1:NUM_ACTIONS
(env::GW.RLBaseEnv{E})(action) where {E <: Snake} = GW.act!(env.env, action)

RLBase.reward(env::GW.RLBaseEnv{E}) where {E <: Snake} = env.env.reward
RLBase.is_terminated(env::GW.RLBaseEnv{E}) where {E <: Snake} = env.env.done

end # module
