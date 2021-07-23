module CollectGemsUndirectedModule

import ..GridWorlds as GW
import Random
import ReinforcementLearningBase as RLBase

#####
##### game logic
#####

const NUM_OBJECTS = 3
const AGENT = 1
const WALL = 2
const GEM = 3
const NUM_ACTIONS = 4

mutable struct CollectGemsUndirected{R, RNG} <: GW.AbstractGridWorld
    tile_map::BitArray{3}
    agent_position::CartesianIndex{2}
    reward::R
    rng::RNG
    done::Bool
    num_gem_init::Int
    num_gem_current::Int
    gem_reward::R
    init_gem_positions::Vector{CartesianIndex{2}}
end

function CollectGemsUndirected(; R = Float32, height = 8, width = 8, num_gem_init = floor(Int, sqrt(height * width)), rng = Random.GLOBAL_RNG)
    tile_map = falses(NUM_OBJECTS, height, width)

    inner_area = CartesianIndices((2 : height - 1, 2 : width - 1))

    tile_map[WALL, 1, :] .= true
    tile_map[WALL, height, :] .= true
    tile_map[WALL, :, 1] .= true
    tile_map[WALL, :, width] .= true

    agent_position = GW.sample_empty_position(rng, tile_map)
    tile_map[AGENT, agent_position] = true

    init_gem_positions = Array{CartesianIndex{2}}(undef, num_gem_init)
    for i in 1:num_gem_init
        gem_position = GW.sample_empty_position(rng, tile_map)
        init_gem_positions[i] = gem_position
        tile_map[GEM, gem_position] = true
    end

    reward = zero(R)
    done = false
    gem_reward = one(R)
    num_gem_current = num_gem_init

    env = CollectGemsUndirected(tile_map, agent_position, reward, rng, done, num_gem_init, num_gem_current, gem_reward, init_gem_positions)

    GW.reset!(env)

    return env
end

function GW.reset!(env::CollectGemsUndirected)
    tile_map = env.tile_map
    rng = env.rng

    tile_map[AGENT, env.agent_position] = false
    for i in 1:env.num_gem_init
        tile_map[GEM, env.init_gem_positions[i]] = false
    end

    new_agent_position = GW.sample_empty_position(rng, tile_map)
    env.agent_position = new_agent_position
    tile_map[AGENT, new_agent_position] = true

    for i in 1:env.num_gem_init
        new_gem_position = GW.sample_empty_position(rng, tile_map)
        env.init_gem_positions[i] = new_gem_position
        tile_map[GEM, new_gem_position] = true
    end

    env.reward = zero(env.reward)
    env.done = false
    env.num_gem_current = env.num_gem_init

    return nothing
end

function GW.act!(env::CollectGemsUndirected, action)
    @assert action in Base.OneTo(NUM_ACTIONS) "Invalid action $(action). Action must be in Base.OneTo($(NUM_ACTIONS))"

    tile_map = env.tile_map
    agent_position = env.agent_position

    if action == 1
        new_agent_position = GW.move_up(agent_position)
    elseif action == 2
        new_agent_position = GW.move_down(agent_position)
    elseif action == 3
        new_agent_position = GW.move_left(agent_position)
    else
        new_agent_position = GW.move_right(agent_position)
    end

    if !tile_map[WALL, new_agent_position]
        tile_map[AGENT, agent_position] = false
        env.agent_position = new_agent_position
        tile_map[AGENT, new_agent_position] = true
    end

    env.reward = zero(env.reward)
    if tile_map[GEM, env.agent_position]
        tile_map[GEM, env.agent_position] = false
        env.num_gem_current -= 1
        env.reward = env.gem_reward
    end

    env.done = env.num_gem_current <= 0

    return nothing
end

#####
##### miscellaneous
#####

GW.get_height(env::CollectGemsUndirected) = size(env.tile_map, 2)
GW.get_width(env::CollectGemsUndirected) = size(env.tile_map, 3)

GW.get_action_names(env::CollectGemsUndirected) = (:MOVE_UP, :MOVE_DOWN, :MOVE_LEFT, :MOVE_RIGHT)
GW.get_object_names(env::CollectGemsUndirected) = (:AGENT, :WALL, :GEM)

function GW.get_pretty_tile_map(env::CollectGemsUndirected, position::CartesianIndex{2})
    characters = ('☻', '█', '♦', '⋅')

    object = findfirst(@view env.tile_map[:, position])
    if isnothing(object)
        return characters[end]
    else
        return characters[object]
    end
end

function GW.get_pretty_sub_tile_map(env::CollectGemsUndirected, window_size, position::CartesianIndex{2})
    tile_map = env.tile_map
    agent_position = env.agent_position

    characters = ('☻', '█', '♦', '⋅')

    sub_tile_map = GW.get_sub_tile_map(tile_map, agent_position, window_size)

    object = findfirst(@view sub_tile_map[:, position])
    if isnothing(object)
        return characters[end]
    else
        return characters[object]
    end
end

function Base.show(io::IO, ::MIME"text/plain", env::CollectGemsUndirected)
    str = "tile_map:\n"
    str = str * GW.get_pretty_tile_map(env)
    str = str * "\nsub_tile_map:\n"
    str = str * GW.get_pretty_sub_tile_map(env, GW.get_window_size(env))
    str = str * "\nreward: $(env.reward)\ndone: $(env.done)"
    str = str * "\naction_names: $(GW.get_action_names(env))"
    str = str * "\nobject_names: $(GW.get_object_names(env))"
    print(io, str)
    return nothing
end

GW.get_action_keys(env::CollectGemsUndirected) = ('w', 's', 'a', 'd')

#####
##### RLBase API
#####

RLBase.StateStyle(env::GW.RLBaseEnv{E}) where {E <: CollectGemsUndirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: CollectGemsUndirected} = nothing
RLBase.state(env::GW.RLBaseEnv{E}, ::RLBase.InternalState) where {E <: CollectGemsUndirected} = env.env.tile_map

RLBase.reset!(env::GW.RLBaseEnv{E}) where {E <: CollectGemsUndirected} = GW.reset!(env.env)

RLBase.action_space(env::GW.RLBaseEnv{E}) where {E <: CollectGemsUndirected} = Base.OneTo(NUM_ACTIONS)
(env::GW.RLBaseEnv{E})(action) where {E <: CollectGemsUndirected} = GW.act!(env.env, action)

RLBase.reward(env::GW.RLBaseEnv{E}) where {E <: CollectGemsUndirected} = env.env.reward
RLBase.is_terminated(env::GW.RLBaseEnv{E}) where {E <: CollectGemsUndirected} = env.env.done

end # module
