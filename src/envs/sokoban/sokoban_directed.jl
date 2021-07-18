module SokobanDirectedModule

import ..GridWorlds as GW
import Random
import ReinforcementLearningBase as RLBase
import ..SokobanUndirectedModule as SUM

mutable struct SokobanDirected{R, RNG} <: GW.AbstractGridWorldGame
    env::SUM.SokobanUndirected{R, RNG}
    agent_direction::Int
end

const NUM_OBJECTS = SUM.NUM_OBJECTS
const AGENT = SUM.AGENT
const WALL = SUM.WALL
const BOX = SUM.BOX
const TARGET = SUM.TARGET

CHARACTERS = ('☻', '█', '▒', '✖', '→', '↑', '←', '↓', '⋅')

GW.get_tile_map_height(env::SokobanDirected) = size(env.env.tile_map, 2)
GW.get_tile_map_width(env::SokobanDirected) = size(env.env.tile_map, 3)

function GW.get_tile_pretty_repr(env::SokobanDirected, i::Integer, j::Integer)
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
GW.get_action_keys(env::SokobanDirected) = ('w', 's', 'a', 'd')
GW.get_action_names(env::SokobanDirected) = (:MOVE_FORWARD, :MOVE_BACKWARD, :TURN_LEFT, :TURN_RIGHT)

function SokobanDirected(; R = Float32, file = joinpath(dirname(functionloc(GW.eval)[1]), "envs/sokoban/boxoban-levels/medium/train/000.txt"), rng = Random.GLOBAL_RNG)
    env = SUM.SokobanUndirected(R = R, file = file, rng = rng)
    agent_direction = rand(rng, 0:GW.NUM_DIRECTIONS-1)
    env = SokobanDirected(env, agent_direction)
    GW.reset!(env)
    return env
end

function GW.reset!(env::SokobanDirected)
    GW.reset!(env.env)
    env.agent_direction = rand(env.env.rng, 0:GW.NUM_DIRECTIONS-1)
    return nothing
end

function GW.act!(env::SokobanDirected, action)
    inner_env = env.env
    tile_map = inner_env.tile_map
    box_positions = inner_env.box_positions
    box_reward = inner_env.box_reward

    r1 = sum(pos -> tile_map[TARGET, pos], box_positions) * box_reward

    if (action == 1) || (action == 2)
        agent_position = inner_env.agent_position
        agent_direction = env.agent_direction

        if action == 1
            dest = CartesianIndex(GW.move_forward(agent_direction, agent_position.I...))
            beyond_dest = CartesianIndex(GW.move_forward(agent_direction, dest.I...))
        else
            dest = CartesianIndex(GW.move_backward(agent_direction, agent_position.I...))
            beyond_dest = CartesianIndex(GW.move_backward(agent_direction, dest.I...))
        end

        if !tile_map[WALL, dest]
            if !tile_map[BOX, dest]
                tile_map[AGENT, agent_position] = false
                inner_env.agent_position = dest
                tile_map[AGENT, dest] = true
            else
                if !tile_map[BOX, beyond_dest] && !tile_map[WALL, beyond_dest]
                    tile_map[BOX, dest] = false
                    tile_map[BOX, beyond_dest] = true

                    box_idx = findfirst(pos -> pos == dest, box_positions)
                    box_positions[box_idx] = beyond_dest
                    tile_map[AGENT, agent_position] = false
                    inner_env.agent_position = dest
                    tile_map[AGENT, dest] = true
                end
            end
        end
    elseif action == 3
        env.agent_direction = GW.turn_left(env.agent_direction)
    elseif action == 4
        env.agent_direction = GW.turn_right(env.agent_direction)
    else
        error("Invalid action $(action)")
    end

    inner_env.done = all(pos -> tile_map[TARGET, pos], box_positions)
    r2 = sum(pos -> tile_map[TARGET, pos], box_positions) * box_reward
    inner_env.reward = r2 - r1

    return nothing
end

function Base.show(io::IO, ::MIME"text/plain", env::SokobanDirected)
    str = GW.get_tile_map_pretty_repr(env)
    str = str * "\nreward = $(env.env.reward)\ndone = $(env.env.done)\nlevel_number = $(env.env.level_number)"
    print(io, str)
    return nothing
end

end # module
