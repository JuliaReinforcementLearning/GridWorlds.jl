module GoToTargetDirectedModule

import ..GoToTargetUndirectedModule as GTTUM
import ..GridWorlds as GW
import Random

mutable struct GoToTargetDirected{R, RNG} <: GW.AbstractGridWorldGame
    env::GTTUM.GoToTargetUndirected{R, RNG}
    agent_direction::Int
end

const NUM_OBJECTS = GTTUM.NUM_OBJECTS
const AGENT = GTTUM.AGENT
const WALL = GTTUM.WALL
const TARGET1 = GTTUM.TARGET1
const TARGET2 = GTTUM.TARGET2

CHARACTERS = ('☻', '█', '✖', '♦', '→', '↑', '←', '↓', '⋅')

GW.get_tile_map_height(env::GoToTargetDirected) = size(env.env.tile_map, 2)
GW.get_tile_map_width(env::GoToTargetDirected) = size(env.env.tile_map, 3)

function GW.get_tile_pretty_repr(env::GoToTargetDirected, i::Integer, j::Integer)
    object = findfirst(@view env.env.tile_map[:, i, j])
    if isnothing(object)
        return CHARACTERS[end]
    elseif object == AGENT
        return CHARACTERS[NUM_OBJECTS + 1 + env.agent_direction]
    else
        return CHARACTERS[object]
    end
end

const NUM_ACTIONS = 4
GW.get_action_keys(env::GoToTargetDirected) = ('w', 's', 'a', 'd')
GW.get_action_names(env::GoToTargetDirected) = (:MOVE_FORWARD, :MOVE_BACKWARD, :TURN_LEFT, :TURN_RIGHT)

function GoToTargetDirected(; R = Float32, height = 8, width = 8, rng = Random.GLOBAL_RNG)
    env = GTTUM.GoToTargetUndirected(R = R, height = height, width = width, rng = rng)
    agent_direction = rand(rng, 0:GW.NUM_DIRECTIONS-1)
    env = GoToTargetDirected(env, agent_direction)
    GW.reset!(env)
    return env
end

function GW.reset!(env::GoToTargetDirected)
    GW.reset!(env.env)
    env.agent_direction = rand(env.env.rng, 0:GW.NUM_DIRECTIONS-1)
    return nothing
end

function GW.act!(env::GoToTargetDirected, action)
    inner_env = env.env
    tile_map = inner_env.tile_map

    if action == 1
        agent_position = inner_env.agent_position
        agent_direction = env.agent_direction
        new_agent_position = CartesianIndex(GW.move_forward(agent_direction, agent_position.I...))
        if !tile_map[WALL, new_agent_position]
            tile_map[AGENT, agent_position] = false
            inner_env.agent_position = new_agent_position
            tile_map[AGENT, new_agent_position] = true
        end
    elseif action == 2
        agent_position = inner_env.agent_position
        agent_direction = env.agent_direction
        new_agent_position = CartesianIndex(GW.move_backward(agent_direction, agent_position.I...))
        if !tile_map[WALL, new_agent_position]
            tile_map[AGENT, agent_position] = false
            inner_env.agent_position = new_agent_position
            tile_map[AGENT, new_agent_position] = true
        end
    elseif action == 3
        env.agent_direction = GW.turn_left(env.agent_direction)
    elseif action == 4
        env.agent_direction = GW.turn_right(env.agent_direction)
    end

    agent_position = inner_env.agent_position
    if tile_map[TARGET1, agent_position] || tile_map[TARGET2, agent_position]
        inner_env.done = true
        if tile_map[2 + inner_env.target, agent_position]
            inner_env.reward = inner_env.terminal_reward
        else
            inner_env.reward = inner_env.terminal_penalty
        end
    else
        inner_env.done = false
        inner_env.reward = zero(inner_env.reward)
    end
    # if tile_map[GOAL, inner_env.agent_position]
        # inner_env.reward = inner_env.terminal_reward
        # inner_env.done = true
    # else
        # inner_env.reward = zero(inner_env.reward)
        # inner_env.done = false
    # end

    return nothing
end

function Base.show(io::IO, ::MIME"text/plain", env::GoToTargetDirected)
    str = GW.get_tile_map_pretty_repr(env)
    str = str * "\nreward = $(env.env.reward)\ndone = $(env.env.done)\ntarget = $(env.env.target) ($(CHARACTERS[2 + env.env.target]))"
    print(io, str)
    return nothing
end

end # module
