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
mutable struct SokobanDirected{T, R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Agent, Wall, Box, Target}}
    agent_pos::CartesianIndex{2}
    agent_dir::AbstractDirection
    reward::T
    rng::R
    dataset::LevelDataset
    box_pos::Vector{CartesianIndex{2}}
    target_pos::Vector{CartesianIndex{2}}
    done::Bool
end

@generate_getters(SokobanDirected)
@generate_setters(SokobanDirected)

mutable struct SokobanUndirected{T, R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Agent, Wall, Box, Target}}
    agent_pos::CartesianIndex{2}
    reward::T
    rng::R
    dataset::LevelDataset
    box_pos::Vector{CartesianIndex{2}}
    target_pos::Vector{CartesianIndex{2}}
    done::Bool
end

@generate_getters(SokobanUndirected)
@generate_setters(SokobanUndirected)

#####
# Directed
#####

function SokobanDirected(; T = Float32, file = joinpath(dirname(pathof(@__MODULE__)), "envs/sokoban/boxoban-levels/medium/train/000.txt"), rng = Random.GLOBAL_RNG)
    dataset = LevelDataset(readlines(file))
    level = get_level(dataset, 0)
    height = length(level)
    width = length(level[1])

    objects = (AGENT, WALL, BOX, TARGET)
    world = GridWorldBase(objects, height, width)

    agent_pos = CartesianIndex(2, 2)
    world[AGENT, agent_pos] = true

    agent_dir = RIGHT
    reward = zero(T)

    box_pos = CartesianIndex{2}[]
    target_pos = CartesianIndex{2}[]
    done = false

    env = SokobanDirected(world, agent_pos, agent_dir, reward, rng, dataset, box_pos, target_pos, done)

    RLBase.reset!(env)

    return env
end

RLBase.StateStyle(env::SokobanDirected) = RLBase.InternalState{Any}()

RLBase.state_space(env::SokobanDirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = nothing
const SOKOBAN_DIRECTED_LAYERS = SA.SVector(2, 3, 4)
RLBase.state(env::SokobanDirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = get_grid(get_world(env), get_agent_pos(env), get_agent_dir(env), get_half_size(env), SOKOBAN_DIRECTED_LAYERS)

RLBase.state_space(env::SokobanDirected, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = nothing
RLBase.state(env::SokobanDirected, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = (copy(get_grid(env)), get_agent_dir(env))

RLBase.action_space(env::SokobanDirected, ::RLBase.DefaultPlayer) = DIRECTED_NAVIGATION_ACTIONS
RLBase.reward(env::SokobanDirected, ::RLBase.DefaultPlayer) = get_reward(env)
RLBase.is_terminated(env::SokobanDirected) = get_done(env)

function RLBase.reset!(env::SokobanDirected{T}) where {T}
    rng = get_rng(env)
    world = get_world(env)

    world[:, :, :] .= false
    env.box_pos = CartesianIndex{2}[]
    env.target_pos = CartesianIndex{2}[]

    level_num = rand(rng, 0:999)
    level = get_level(env.dataset, level_num)

    set_level!(env, level)

    set_agent_dir!(env, RIGHT)

    set_reward!(env, zero(T))
    set_done!(env, false)

    return nothing
end

function (env::SokobanDirected{T})(action::AbstractTurnAction) where {T}
    new_dir = turn(action, get_agent_dir(env))
    set_agent_dir!(env, new_dir)
    world = get_world(env)

    set_done!(env, all(pos -> get_world(env)[TARGET, pos], env.box_pos))
    set_reward!(env, zero(T))

    return nothing
end

function (env::SokobanDirected{T})(action::AbstractMoveAction) where {T}
    world = get_world(env)

    r1 = sum(pos -> world[TARGET, pos], env.box_pos) # can just use get_reward(env) here?
    agent_pos = get_agent_pos(env)
    dir = get_agent_dir(env)
    dest = move(action, dir, agent_pos)
    if !world[WALL, dest]
        beyond_dest = move(action, dir, dest)
        if !world[BOX, dest]
            world[AGENT, agent_pos] = false
            set_agent_pos!(env, dest)
            world[AGENT, dest] = true
        else
            if !world[BOX, beyond_dest] && !world[WALL, beyond_dest]
                world[BOX, dest] = false
                world[BOX, beyond_dest] = true

                idx = findfirst(pos -> pos == dest, env.box_pos)
                env.box_pos[idx] = beyond_dest
                world[AGENT, agent_pos] = false
                set_agent_pos!(env, dest)
                world[AGENT, dest] = true
            end
        end
    end

    set_done!(env, all(pos -> get_world(env)[TARGET, pos], env.box_pos))
    r2 = sum(pos -> world[TARGET, pos], env.box_pos)
    set_reward!(env, convert(T, r2 - r1))

    return nothing
end

function set_level!(env::SokobanDirected, level::Vector{String})
    world = get_world(env)
    for i in 1:length(level), j in 1:length(level[1])
        pos = CartesianIndex(i, j)
        char = level[i][j]

        if char === '@'
            set_agent_pos!(env, pos)
            world[AGENT, pos] = true
            set_agent_dir!(env, RIGHT)
        elseif char === '#'
            world[WALL, pos] = true
        elseif char === '$'
            push!(env.box_pos, pos)
            world[BOX, pos] = true
        elseif char === '.'
            push!(env.target_pos, pos)
            world[TARGET, pos] = true
        end
    end

    return nothing
end

#####
# Undirected
#####

function SokobanUndirected(; T = Float32, file = joinpath(dirname(pathof(@__MODULE__)), "envs/sokoban/boxoban-levels/medium/train/000.txt"), rng = Random.GLOBAL_RNG)
    dataset = LevelDataset(readlines(file))
    level = get_level(dataset, 0)
    height = length(level)
    width = length(level[1])

    objects = (AGENT, WALL, BOX, TARGET)
    world = GridWorldBase(objects, height, width)

    agent_pos = CartesianIndex(2, 2)
    world[AGENT, agent_pos] = true

    reward = zero(T)

    box_pos = CartesianIndex{2}[]
    target_pos = CartesianIndex{2}[]
    done = false

    env = SokobanUndirected(world, agent_pos, reward, rng, dataset, box_pos, target_pos, done)

    RLBase.reset!(env)

    return env
end

RLBase.StateStyle(env::SokobanUndirected) = RLBase.InternalState{Any}()

RLBase.state_space(env::SokobanUndirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = nothing
const SOKOBAN_UNDIRECTED_LAYERS = SA.SVector(2, 3, 4)
RLBase.state(env::SokobanUndirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = get_grid(get_world(env), get_agent_pos(env), get_half_size(env), SOKOBAN_UNDIRECTED_LAYERS)

RLBase.state_space(env::SokobanUndirected, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = nothing
RLBase.state(env::SokobanUndirected, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = copy(get_grid(env))

RLBase.action_space(env::SokobanUndirected, player::RLBase.DefaultPlayer) = UNDIRECTED_NAVIGATION_ACTIONS
RLBase.reward(env::SokobanUndirected, ::RLBase.DefaultPlayer) = get_reward(env)
RLBase.is_terminated(env::SokobanUndirected) = get_done(env)

function RLBase.reset!(env::SokobanUndirected{T}) where {T}
    rng = get_rng(env)
    world = get_world(env)

    world[:, :, :] .= false
    env.box_pos = CartesianIndex{2}[]
    env.target_pos = CartesianIndex{2}[]

    level_num = rand(rng, 0:999)
    level = get_level(env.dataset, level_num)

    set_level!(env, level)

    set_reward!(env, zero(T))
    set_done!(env, false)

    return nothing
end

function (env::SokobanUndirected{T})(action::AbstractMoveAction) where {T}
    world = get_world(env)

    r1 = sum(pos -> world[TARGET, pos], env.box_pos) # can just use get_reward(env) here?
    agent_pos = get_agent_pos(env)
    dest = move(action, agent_pos)
    if !world[WALL, dest]
        beyond_dest = move(action, dest)
        if !world[BOX, dest]
            world[AGENT, agent_pos] = false
            set_agent_pos!(env, dest)
            world[AGENT, dest] = true
        else
            if !world[BOX, beyond_dest] && !world[WALL, beyond_dest]
                world[BOX, dest] = false
                world[BOX, beyond_dest] = true

                idx = findfirst(pos -> pos == dest, env.box_pos)
                env.box_pos[idx] = beyond_dest
                world[AGENT, agent_pos] = false
                set_agent_pos!(env, dest)
                world[AGENT, dest] = true
            end
        end
    end

    set_done!(env, all(pos -> get_world(env)[TARGET, pos], env.box_pos))
    r2 = sum(pos -> world[TARGET, pos], env.box_pos)
    set_reward!(env, convert(T, r2 - r1))

    return nothing
end

function set_level!(env::SokobanUndirected, level::Vector{String})
    world = get_world(env)
    for i in 1:length(level), j in 1:length(level[1])
        pos = CartesianIndex(i, j)
        char = level[i][j]

        if char === '@'
            set_agent_pos!(env, pos)
            world[AGENT, pos] = true
        elseif char === '#'
            world[WALL, pos] = true
        elseif char === '$'
            push!(env.box_pos, pos)
            world[BOX, pos] = true
        elseif char === '.'
            push!(env.target_pos, pos)
            world[TARGET, pos] = true
        end
    end

    return nothing
end
