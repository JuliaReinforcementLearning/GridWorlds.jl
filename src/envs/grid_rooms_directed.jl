module GridRoomsDirectedModule

import ..GridRoomsUndirectedModule as GRUM
import ..GridWorlds as GW
import Random
import ReinforcementLearningBase as RLBase

#####
##### game logic
#####

const NUM_OBJECTS = GRUM.NUM_OBJECTS
const AGENT = GRUM.AGENT
const WALL = GRUM.WALL
const GOAL = GRUM.GOAL
const NUM_ACTIONS = 4

mutable struct GridRoomsDirected{R, RNG} <: GW.AbstractGridWorld
    env::GRUM.GridRoomsUndirected{R, RNG}
    agent_direction::Int
end

function GridRoomsDirected(; R = Float32, grid_size = (2, 2), room_size = (5, 5), rng = Random.GLOBAL_RNG)
    env = GRUM.GridRoomsUndirected(R = R, grid_size = grid_size, room_size = room_size, rng = rng)
    agent_direction = rand(rng, 0:GW.NUM_DIRECTIONS-1)
    env = GridRoomsDirected(env, agent_direction)
    GW.reset!(env)
    return env
end

function GW.reset!(env::GridRoomsDirected)
    GW.reset!(env.env)
    env.agent_direction = rand(env.env.rng, 0:GW.NUM_DIRECTIONS-1)
    return nothing
end

function GW.act!(env::GridRoomsDirected, action)
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

    if tile_map[GOAL, inner_env.agent_position]
        inner_env.reward = inner_env.terminal_reward
        inner_env.done = true
    else
        inner_env.reward = zero(inner_env.reward)
        inner_env.done = false
    end

    return nothing
end

#####
##### miscellaneous
#####

CHARACTERS = ('☻', '█', '♥', '→', '↑', '←', '↓', '⋅')

GW.get_height(env::GridRoomsDirected) = size(env.env.tile_map, 2)
GW.get_width(env::GridRoomsDirected) = size(env.env.tile_map, 3)

function GW.get_tile_pretty_repr(env::GridRoomsDirected, i::Integer, j::Integer)
    object = findfirst(@view env.env.tile_map[:, i, j])
    if isnothing(object)
        return CHARACTERS[end]
    elseif object == AGENT
        return CHARACTERS[NUM_OBJECTS + 1 + env.agent_direction]
    else
        return CHARACTERS[object]
    end
end

GW.get_action_keys(env::GridRoomsDirected) = ('w', 's', 'a', 'd')
GW.get_action_names(env::GridRoomsDirected) = (:MOVE_FORWARD, :MOVE_BACKWARD, :TURN_LEFT, :TURN_RIGHT)

function Base.show(io::IO, ::MIME"text/plain", env::GridRoomsDirected)
    str = GW.get_tile_map_pretty_repr(env)
    str = str * "\nreward = $(env.env.reward)\ndone = $(env.env.done)"
    print(io, str)
    return nothing
end

#####
##### RLBase API
#####

RLBase.StateStyle(env::GW.RLBaseEnv{E}) where {E <: GridRoomsDirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GridRoomsDirected} = nothing
RLBase.state(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GridRoomsDirected} = (env.env.env.tile_map, env.env.agent_direction)

RLBase.reset!(env::GW.RLBaseEnv{E}) where {E <: GridRoomsDirected} = GW.reset!(env.env)

RLBase.action_space(env::GW.RLBaseEnv{E}) where {E <: GridRoomsDirected} = Base.OneTo(NUM_ACTIONS)
(env::GW.RLBaseEnv{E})(action) where {E <: GridRoomsDirected} = GW.act!(env.env, action)

RLBase.reward(env::GW.RLBaseEnv{E}) where {E <: GridRoomsDirected} = env.env.env.reward
RLBase.is_terminated(env::GW.RLBaseEnv{E}) where {E <: GridRoomsDirected} = env.env.env.done

end # module
