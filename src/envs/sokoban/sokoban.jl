export Sokoban

const CHAR_TO_OBJECT = Dict(
                            '@' => DIRECTION_LESS_AGENT,
                            ' ' => EMPTY,
                            '#' => WALL,
                            '$' => BOX,
                            '.' => TARGET,
)

struct LevelDataset
    contents::Vector{String}
end

function get_level(dataset::LevelDataset, n::Int)
    start = 12 * n + 2
    finish = 12 * n + 11
    return dataset.contents[start:finish]
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

The dataset file can be updated by creating suitable [hook](https://github.com/JuliaReinforcementLearning/ReinforcementLearningCore.jl/blob/master/src/core/hooks.jl)
"""
mutable struct Sokoban{R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{DirectionLessAgent, Empty, Wall, Box, Target}}
    agent::Agent
    reward::Float64
    rng::R
    dataset::LevelDataset
    box_pos::Vector{CartesianIndex{2}}
    target_pos::Vector{CartesianIndex{2}}
end

function Sokoban(; file = joinpath(dirname(pathof(@__MODULE__)), "envs/sokoban/000.txt"), rng = Random.GLOBAL_RNG)
    dataset = LevelDataset(readlines(file))
    level = get_level(dataset, 0)
    height = length(level)
    width = length(level[1])

    objects = (DIRECTION_LESS_AGENT, EMPTY, WALL, BOX, TARGET)
    world = GridWorldBase(objects, height, width)

    agent = Agent()
    reward = 0.0

    box_pos = CartesianIndex{2}[]
    target_pos = CartesianIndex{2}[]

    env = Sokoban(world, agent, reward, rng, dataset, box_pos, target_pos)

    reset!(env)

    return env
end

get_full_view(env::Sokoban) = get_grid(env)
RLBase.StateStyle(env::Sokoban) = RLBase.InternalState{Any}()
RLBase.state(env::Sokoban, ::RLBase.InternalState, ::DefaultPlayer) = get_full_view(env)

RLBase.action_space(env::Sokoban, ::DefaultPlayer) = (MOVE_UP, MOVE_DOWN, MOVE_LEFT, MOVE_RIGHT)

RLBase.is_terminated(env::Sokoban) = all(pos -> get_world(env)[TARGET, pos], env.box_pos)

function (env::AbstractGridWorld)(action::Union{MoveUp, MoveDown, MoveLeft, MoveRight})
    world = get_world(env)

    r1 = sum(pos -> world[TARGET, pos], env.box_pos)
    agent_pos = get_agent_pos(env)
    dest = action(agent_pos)
    if !world[WALL, dest]
        beyond_dest = action(dest)
        if !world[BOX, dest]
            world[DIRECTION_LESS_AGENT, agent_pos] = false
            world[DIRECTION_LESS_AGENT, dest] = true
            if world[EMPTY, dest]
                world[EMPTY, dest] = false
            end
            if !world[TARGET, agent_pos]
                world[EMPTY, agent_pos] = true
            end
            set_agent_pos!(env, dest)
        else
            if !world[BOX, beyond_dest] && (world[EMPTY, beyond_dest] || world[TARGET, beyond_dest])
                world[DIRECTION_LESS_AGENT, agent_pos] = false
                world[DIRECTION_LESS_AGENT, dest] = true
                world[BOX, dest] = false
                world[BOX, beyond_dest] = true
                idx = findfirst(pos -> pos == dest, env.box_pos)
                env.box_pos[idx] = beyond_dest
                if world[EMPTY, beyond_dest]
                    world[EMPTY, beyond_dest] = false
                end
                if !world[TARGET, agent_pos]
                    world[EMPTY, agent_pos] = true
                end
                set_agent_pos!(env, dest)
            end
        end
    end

    r2 = sum(pos -> world[TARGET, pos], env.box_pos)
    set_reward!(env, r2 - r1)

    return env
end

function set_level!(env::Sokoban, level::Vector{String})
    world = get_world(env)
    for i in 1:length(level)
        for j in 1:length(level[1])
            pos = CartesianIndex(i, j)
            object = CHAR_TO_OBJECT[level[i][j]]
            world[object, pos] = true

            if object === DIRECTION_LESS_AGENT
                set_agent_pos!(env, pos)
            elseif object === BOX
                push!(env.box_pos, pos)
            elseif object === TARGET
                push!(env.target_pos, pos)
            end
        end
    end

    return env
end

function RLBase.reset!(env::Sokoban)
    rng = get_rng(env)
    world = get_world(env)

    world[:, :, :] .= false
    env.box_pos = CartesianIndex{2}[]
    env.target_pos = CartesianIndex{2}[]

    level_num = rand(rng, 0:999)
    level = get_level(env.dataset, level_num)

    set_level!(env, level)

    set_reward!(env, 0.0)

    return env
end
