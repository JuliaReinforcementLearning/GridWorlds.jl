module SequentialRoomsDirectedModule

import ..GridWorlds as GW
import Random
import ReinforcementLearningBase as RLBase
import ..SequentialRoomsUndirectedModule as SRUM

#####
##### game logic
#####

const NUM_OBJECTS = SRUM.NUM_OBJECTS
const AGENT = SRUM.AGENT
const WALL = SRUM.WALL
const GOAL = SRUM.GOAL
const NUM_ACTIONS = 4

mutable struct SequentialRoomsDirected{R, RNG} <: GW.AbstractGridWorld
    env::SRUM.SequentialRoomsUndirected{R, RNG}
    agent_direction::Int
end

function SequentialRoomsDirected(; R = Float32, num_rooms = 3, range_height_room = 4:6, range_width_room = 7:9, rng = Random.GLOBAL_RNG)
    env = SRUM.SequentialRoomsUndirected(R = R, num_rooms = num_rooms, range_height_room = range_height_room, range_width_room = range_width_room, rng = rng)
    agent_direction = rand(rng, 0:GW.NUM_DIRECTIONS-1)
    env = SequentialRoomsDirected(env, agent_direction)
    GW.reset!(env)
    return env
end

function GW.reset!(env::SequentialRoomsDirected)
    GW.reset!(env.env)
    env.agent_direction = rand(env.env.rng, 0:GW.NUM_DIRECTIONS-1)
    return nothing
end

function GW.act!(env::SequentialRoomsDirected, action)
    @assert action in Base.OneTo(NUM_ACTIONS) "Invalid action $(action). Action must be in Base.OneTo($(NUM_ACTIONS))"

    inner_env = env.env
    tile_map = inner_env.tile_map
    agent_position = inner_env.agent_position
    agent_direction = env.agent_direction

    if action in Base.OneTo(2)
        if action == 1
            new_agent_position = GW.move_forward(agent_position, agent_direction)
        else
            new_agent_position = GW.move_backward(agent_position, agent_direction)
        end

        if !tile_map[WALL, new_agent_position]
            tile_map[AGENT, agent_position] = false
            inner_env.agent_position = new_agent_position
            tile_map[AGENT, new_agent_position] = true
        end
    elseif action == 3
        env.agent_direction = GW.turn_left(agent_direction)
    else
        env.agent_direction = GW.turn_right(agent_direction)
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

GW.get_height(env::SequentialRoomsDirected) = GW.get_height(env.env)
GW.get_width(env::SequentialRoomsDirected) = GW.get_width(env.env)

GW.get_action_names(env::SequentialRoomsDirected) = (:MOVE_FORWARD, :MOVE_BACKWARD, :TURN_LEFT, :TURN_RIGHT)
GW.get_object_names(env::SequentialRoomsDirected) = GW.get_object_names(env.env)

function Base.show(io::IO, ::MIME"text/plain", env::SequentialRoomsDirected)
    tile_map = env.env.tile_map
    small_tile_map = SRUM.get_small_tile_map(tile_map)

    characters = ('☻', '█', '♥', '→', '↑', '←', '↓', '⋅')

    _, height_small_tile_map, width_small_tile_map = size(small_tile_map)

    str = "tile_map:\n"

    for i in 1:height_small_tile_map
        for j in 1:width_small_tile_map
            object = findfirst(@view small_tile_map[:, i, j])
            if isnothing(object)
                char = characters[end]
            elseif object == AGENT
                char = characters[NUM_OBJECTS + 1 + env.agent_direction]
            else
                char = characters[object]
            end
            str = str * char
        end

        if i < height_small_tile_map
            str = str * "\n"
        end
    end

    str = str * "\nreward: $(env.env.reward)"
    str = str * "\ndone: $(env.env.done)"
    str = str * "\naction_names: $(GW.get_action_names(env))"
    str = str * "\nobject_names: $(GW.get_object_names(env))"
    print(io, str)
    return nothing
end

GW.get_action_keys(env::SequentialRoomsDirected) = ('w', 's', 'a', 'd')

#####
##### RLBase API
#####

RLBase.StateStyle(env::GW.RLBaseEnv{E}) where {E <: SequentialRoomsDirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: SequentialRoomsDirected} = nothing
RLBase.state(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: SequentialRoomsDirected} = (SRUM.get_small_tile_map(env.env.env.tile_map), env.env.agent_direction)

RLBase.reset!(env::GW.RLBaseEnv{E}) where {E <: SequentialRoomsDirected} = GW.reset!(env.env)

RLBase.action_space(env::GW.RLBaseEnv{E}) where {E <: SequentialRoomsDirected} = Base.OneTo(NUM_ACTIONS)
(env::GW.RLBaseEnv{E})(action) where {E <: SequentialRoomsDirected} = GW.act!(env.env, action)

RLBase.reward(env::GW.RLBaseEnv{E}) where {E <: SequentialRoomsDirected} = env.env.env.reward
RLBase.is_terminated(env::GW.RLBaseEnv{E}) where {E <: SequentialRoomsDirected} = env.env.env.done

end # module
