module SingleRoomUndirectedModule

import ..GridWorlds as GW
import Random

mutable struct SingleRoomUndirected{R, RNG} <: GW.AbstractGridWorldGame
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

CHARACTERS = ('☻', '█', '♥', '⋅')

GW.get_tile_map_height(env::SingleRoomUndirected) = size(env.tile_map, 2)
GW.get_tile_map_width(env::SingleRoomUndirected) = size(env.tile_map, 3)

function GW.get_tile_pretty_repr(env::SingleRoomUndirected, i::Integer, j::Integer)
    object = findfirst(@view env.tile_map[:, i, j])
    if isnothing(object)
        return CHARACTERS[end]
    else
        return CHARACTERS[object]
    end
end

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

function Base.show(io::IO, ::MIME"text/plain", env::SingleRoomUndirected)
    str = GW.get_tile_map_pretty_repr(env)
    str = str * "\nreward = $(env.reward)\ndone = $(env.done)"
    print(io, str)
    return nothing
end

end # module
