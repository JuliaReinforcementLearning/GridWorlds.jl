module SokobanUndirectedModule

import ..GridWorlds as GW
import Random
import ReinforcementLearningBase as RLBase

#####
##### game logic
#####

const NUM_OBJECTS = 4
const AGENT = 1
const WALL = 2
const BOX = 3
const TARGET = 4
const NUM_ACTIONS = 4

struct LevelDataset
    characters::Array{Char, 3}
end

function LevelDataset(file::AbstractString)
    lines = readlines(file)

    height = 0
    width = 0
    num_levels = 0

    for i in 1 : length(lines)
        if lines[i] == ""
            height = i - 2
            width = length(lines[i - 1])
            num_levels = length(lines) ÷ (height + 2)
            break
        end
    end

    characters = Array{Char}(undef, height, width, num_levels)

    for k in 1 : num_levels
        for j in 1 : width
            for i in 1 : height
                characters[i, j, k] = lines[(k - 1) * (height + 2) + 1 + i][j]
            end
        end
    end

    return LevelDataset(characters)
end

"""
The dataset (000.txt) used is [boxoban-levels](https://github.com/deepmind/boxoban-levels/blob/master/medium/train/000.txt) (LICENSE file included along with 000.txt)

The following is the citation of the dataset:

@misc{boxobanlevels,
author = {Arthur Guez, Mehdi Mirza, Karol Gregor, Rishabh Kabra, Sebastien Racaniere, Theophane Weber, David Raposo, Adam Santoro, Laurent Orseau, Tom Eccles, Greg Wayne, David Silver, Timothy Lillicrap, Victor Valdes},
title = {An investigation of Model-free planning: boxoban levels},
howpublished= {https://github.com/deepmind/boxoban-levels/},
year = "2018",
}
"""
mutable struct SokobanUndirected{R, RNG} <: GW.AbstractGridWorld
    tile_map::BitArray{3}
    agent_position::CartesianIndex{2}
    reward::R
    rng::RNG
    done::Bool
    box_reward::R
    box_positions::Vector{CartesianIndex{2}}
    level_number::Int
    dataset::LevelDataset
end

function SokobanUndirected(; R = Float32, file = joinpath(dirname(functionloc(GW.eval)[1]), "envs/sokoban/boxoban-levels/medium/train/000.txt"), rng = Random.GLOBAL_RNG)
    dataset = LevelDataset(file)
    height, width, _ = size(dataset.characters)

    tile_map = falses(NUM_OBJECTS, height, width)
    agent_position = CartesianIndex(1, 1)

    reward = zero(R)
    done = false
    box_reward = one(R)
    box_positions = CartesianIndex{2}[]
    level_number = 1

    env = SokobanUndirected(tile_map, agent_position, reward, rng, done, box_reward, box_positions, level_number, dataset)

    GW.reset!(env)

    return env
end

function GW.reset!(env::SokobanUndirected)
    rng = env.rng
    num_levels = size(env.dataset.characters, 3)

    new_level_number = rand(rng, 1 : num_levels)

    set_level!(env, new_level_number)

    env.reward = zero(env.reward)
    env.done = false

    return nothing
end

function GW.act!(env::SokobanUndirected, action)
    tile_map = env.tile_map
    box_positions = env.box_positions
    box_reward = env.box_reward

    r1 = sum(pos -> tile_map[TARGET, pos], box_positions) * box_reward
    agent_position = env.agent_position

    if action == 1
        dest = CartesianIndex(GW.move_up(agent_position.I...))
        beyond_dest = CartesianIndex(GW.move_up(dest.I...))
    elseif action == 2
        dest = CartesianIndex(GW.move_down(agent_position.I...))
        beyond_dest = CartesianIndex(GW.move_down(dest.I...))
    elseif action == 3
        dest = CartesianIndex(GW.move_left(agent_position.I...))
        beyond_dest = CartesianIndex(GW.move_left(dest.I...))
    elseif action == 4
        dest = CartesianIndex(GW.move_right(agent_position.I...))
        beyond_dest = CartesianIndex(GW.move_right(dest.I...))
    else
        error("Invalid action $(action)")
    end

    if !tile_map[WALL, dest]
        if !tile_map[BOX, dest]
            tile_map[AGENT, agent_position] = false
            env.agent_position = dest
            tile_map[AGENT, dest] = true
        else
            if !tile_map[BOX, beyond_dest] && !tile_map[WALL, beyond_dest]
                tile_map[BOX, dest] = false
                tile_map[BOX, beyond_dest] = true

                box_idx = findfirst(pos -> pos == dest, box_positions)
                box_positions[box_idx] = beyond_dest
                tile_map[AGENT, agent_position] = false
                env.agent_position = dest
                tile_map[AGENT, dest] = true
            end
        end
    end

    env.done = all(pos -> tile_map[TARGET, pos], box_positions)
    r2 = sum(pos -> tile_map[TARGET, pos], box_positions) * box_reward
    env.reward = r2 - r1

    return nothing
end

function set_level!(env::SokobanUndirected, level_number::Int)
    tile_map = env.tile_map
    characters = env.dataset.characters
    box_positions = env.box_positions

    fill!(tile_map, false)
    empty!(env.box_positions)

    env.level_number = level_number

    height, width, num_levels = size(characters)

    for j in 1 : width
        for i in 1 : height
            char = characters[i, j, level_number]
            if char === '@'
                tile_map[AGENT, i, j] = true
                env.agent_position = CartesianIndex(i, j)
            elseif char === '#'
                tile_map[WALL, i, j] = true
            elseif char === '$'
                tile_map[BOX, i, j] = true
                push!(box_positions, CartesianIndex(i, j))
            elseif char === '.'
                tile_map[TARGET, i, j] = true
            end
        end
    end

    return nothing
end

#####
##### miscellaneous
#####

CHARACTERS = ('☻', '█', '▒', '✖', '⋅')

GW.get_height(env::SokobanUndirected) = size(env.tile_map, 2)
GW.get_width(env::SokobanUndirected) = size(env.tile_map, 3)

function GW.get_tile_pretty_repr(env::SokobanUndirected, i::Integer, j::Integer)
    object = findfirst(@view env.tile_map[:, i, j])
    if isnothing(object)
        return CHARACTERS[end]
    else
        return CHARACTERS[object]
    end
end

GW.get_action_keys(env::SokobanUndirected) = ('w', 's', 'a', 'd')
GW.get_action_names(env::SokobanUndirected) = (:MOVE_UP, :MOVE_DOWN, :MOVE_LEFT, :MOVE_RIGHT)

function Base.show(io::IO, ::MIME"text/plain", env::SokobanUndirected)
    str = GW.get_tile_map_pretty_repr(env)
    str = str * "\nreward = $(env.reward)\ndone = $(env.done)\nlevel_number = $(env.level_number)"
    print(io, str)
    return nothing
end

#####
##### RLBase API
#####

RLBase.StateStyle(env::GW.RLBaseEnv{E}) where {E <: SokobanUndirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: SokobanUndirected} = nothing
RLBase.state(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: SokobanUndirected} = env.env.tile_map

RLBase.reset!(env::GW.RLBaseEnv{E}) where {E <: SokobanUndirected} = GW.reset!(env.env)

RLBase.action_space(env::GW.RLBaseEnv{E}) where {E <: SokobanUndirected} = Base.OneTo(NUM_ACTIONS)
(env::GW.RLBaseEnv{E})(action) where {E <: SokobanUndirected} = GW.act!(env.env, action)

RLBase.reward(env::GW.RLBaseEnv{E}) where {E <: SokobanUndirected} = env.env.reward
RLBase.is_terminated(env::GW.RLBaseEnv{E}) where {E <: SokobanUndirected} = env.env.done

end # module
