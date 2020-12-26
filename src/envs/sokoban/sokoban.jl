export SimpleSokoban

const CHAR_TO_OBJECT = Dict(
                            '@' => DIRECTION_LESS_AGENT,
                            ' ' => EMPTY,
                            '#' => WALL,
                            '$' => BOX,
                            '.' => TARGET,
)

"""
The dataset (000.txt) used is [boxoban-levels](https://github.com/deepmind/boxoban-levels/blob/master/medium/train/000.txt)
The following is the citation of the dataset:
@misc{boxobanlevels,
author = {Arthur Guez, Mehdi Mirza, Karol Gregor, Rishabh Kabra, Sebastien Racaniere, Theophane Weber, David Raposo, Adam Santoro, Laurent Orseau, Tom Eccles, Greg Wayne, David Silver, Timothy Lillicrap, Victor Valdes},
title = {An investigation of Model-free planning: boxoban levels},
howpublished= {https://github.com/deepmind/boxoban-levels/},
year = "2018",
}
"""
struct LevelDataset
    contents::Vector{String}
end

function get_level(dataset::LevelDataset, n::Int)
    start = 12 * n + 2
    finish = 12 * n + 11
    return dataset.contents[start:finish]
end

mutable struct SimpleSokoban{R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{DirectionLessAgent, Empty, Wall, Box, Target}}
    agent::Agent
    reward::Float64
    rng::R
    dataset::LevelDataset
end

function SimpleSokoban(; file = joinpath(dirname(pathof(@__MODULE__)), "envs/sokoban/000.txt"), rng = Random.GLOBAL_RNG)
    dataset = LevelDataset(readlines(file))
    level = get_level(dataset, 0)
    height = length(level)
    width = length(level[1])

    objects = (DIRECTION_LESS_AGENT, EMPTY, WALL, BOX, TARGET)
    world = GridWorldBase(objects, height, width)

    agent = Agent()
    reward = 0.0

    env = SimpleSokoban(world, agent, reward, rng, dataset)

    reset!(env)

    return env
end

RLBase.StateStyle(env::SimpleSokoban) = RLBase.InternalState{Any}()
RLBase.state(env::SimpleSokoban, ::RLBase.InternalState, ::DefaultPlayer) = get_grid(env)

RLBase.action_space(env::SimpleSokoban, ::DefaultPlayer) = (MOVE_UP, MOVE_DOWN, MOVE_LEFT, MOVE_RIGHT)

function RLBase.reset!(env::SimpleSokoban, level::Vector{String})
    env[:, :, :] .= false

    for i in 1:length(level)
        for j in 1:length(level[1])
            object = CHAR_TO_OBJECT[level[i][j]]
            if object == DIRECTION_LESS_AGENT
                set_agent_pos!(env, CartesianIndex(i, j))
            end
            env[object, i, j] = true
        end
    end
end

function RLBase.reset!(env::SimpleSokoban)
    rng = get_rng(env)

    level_num = rand(rng, 0:999)
    level = get_level(env.dataset, level_num)
    reset!(env, level)

    set_reward!(env, 0.0)

    return env
end
