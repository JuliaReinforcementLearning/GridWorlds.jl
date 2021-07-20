module CollectGemsMultiAgentUndirectedModule

import ..GridWorlds as GW
import Random

mutable struct CollectGemsMultiAgentUndirected{R, RNG} <: GW.AbstractGridWorldGame
    tile_map::BitArray{3}
    agent_positions::Vector{CartesianIndex{2}}
    current_agent::Int
    reward::R
    rng::RNG
    done::Bool
    num_gem_init::Int
    num_gem_current::Int
    gem_reward::R
    gem_positions::Vector{CartesianIndex{2}}
end

GW.get_tile_map_height(env::CollectGemsMultiAgentUndirected) = size(env.tile_map, 2)
GW.get_tile_map_width(env::CollectGemsMultiAgentUndirected) = size(env.tile_map, 3)

function GW.get_tile_pretty_repr(env::CollectGemsMultiAgentUndirected, i::Integer, j::Integer)
    tile_map = env.tile_map
    object = findfirst(@view tile_map[:, i, j])
    num_agents = size(tile_map, 1) - 2

    if isnothing(object)
        return "⋅"
    elseif object in 1 : num_agents
        return "$(object)"
    elseif object == num_agents + 1
        return "█"
    else
        return "♦"
    end
end

const NUM_ACTIONS = 4
GW.get_action_keys(env::CollectGemsMultiAgentUndirected) = ('w', 's', 'a', 'd')
GW.get_action_names(env::CollectGemsMultiAgentUndirected) = (:MOVE_UP, :MOVE_DOWN, :MOVE_LEFT, :MOVE_RIGHT)

function CollectGemsMultiAgentUndirected(; R = Float32, height = 8, width = 8, num_gem_init = floor(Int, sqrt(height * width)), num_agents = 4, rng = Random.GLOBAL_RNG)
    tile_map = falses(num_agents + 2, height, width)
    WALL = num_agents + 1
    GEM = num_agents + 2

    tile_map[WALL, 1, :] .= true
    tile_map[WALL, height, :] .= true
    tile_map[WALL, :, 1] .= true
    tile_map[WALL, :, width] .= true

    agent_positions = Array{CartesianIndex{2}}(undef, num_agents)
    for i in 1 : num_agents
        agent_position = GW.sample_empty_position(rng, tile_map)
        agent_positions[i] = agent_position
        tile_map[i, agent_position] = true
    end

    gem_positions = Array{CartesianIndex{2}}(undef, num_gem_init)
    for i in 1 : num_gem_init
        gem_position = GW.sample_empty_position(rng, tile_map)
        gem_positions[i] = gem_position
        tile_map[GEM, gem_position] = true
    end

    reward = zero(R)
    done = false
    gem_reward = one(R)
    num_gem_current = num_gem_init
    current_agent = 1

    env = CollectGemsMultiAgentUndirected(tile_map, agent_positions, current_agent, reward, rng, done, num_gem_init, num_gem_current, gem_reward, gem_positions)

    GW.reset!(env)

    return env
end

function GW.reset!(env::CollectGemsMultiAgentUndirected)
    tile_map = env.tile_map
    rng = env.rng
    agent_positions = env.agent_positions
    gem_positions = env.gem_positions
    num_agents = length(agent_positions)
    WALL = num_agents + 1
    GEM = num_agents + 2

    for i in 1 : num_agents
        tile_map[i, agent_positions[i]] = false
    end

    for i in 1 : env.num_gem_init
        tile_map[GEM, gem_positions[i]] = false
    end

    for i in 1 : num_agents
        agent_position = GW.sample_empty_position(rng, tile_map)
        agent_positions[i] = agent_position
        tile_map[i, agent_position] = true
    end

    for i in 1 : env.num_gem_init
        gem_position = GW.sample_empty_position(rng, tile_map)
        gem_positions[i] = gem_position
        tile_map[GEM, gem_position] = true
    end

    env.reward = zero(env.reward)
    env.done = false
    env.num_gem_current = env.num_gem_init

    return nothing
end

function GW.act!(env::CollectGemsMultiAgentUndirected, action)
    @assert action in 1:NUM_ACTIONS "Invalid action $(action)"

    tile_map = env.tile_map
    agent_positions = env.agent_positions
    num_agents = length(agent_positions)
    current_agent = env.current_agent
    agent_position = agent_positions[current_agent]

    WALL = num_agents + 1
    GEM = num_agents + 2

    if action == 1
        new_agent_position = CartesianIndex(GW.move_up(agent_position.I...))
    elseif action == 2
        new_agent_position = CartesianIndex(GW.move_down(agent_position.I...))
    elseif action == 3
        new_agent_position = CartesianIndex(GW.move_left(agent_position.I...))
    else
        new_agent_position = CartesianIndex(GW.move_right(agent_position.I...))
    end

    if !any(@view tile_map[1 : num_agents + 1, new_agent_position]) # assuming WALL = num_agents + 1
        tile_map[current_agent, agent_position] = false
        agent_positions[current_agent] = new_agent_position
        tile_map[current_agent, new_agent_position] = true
    end

    agent_position = agent_positions[current_agent]

    env.reward = zero(env.reward)
    if tile_map[GEM, agent_position]
        tile_map[GEM, agent_position] = false
        env.num_gem_current -= 1
        env.reward = env.gem_reward
    end

    env.done = env.num_gem_current <= 0

    if current_agent == num_agents
        env.current_agent = 1
    else
        env.current_agent = current_agent + 1
    end

    return nothing
end

function Base.show(io::IO, ::MIME"text/plain", env::CollectGemsMultiAgentUndirected)
    str = GW.get_tile_map_pretty_repr(env)
    str = str * "\nreward = $(env.reward)\ndone = $(env.done)\ncurrent_agent = $(env.current_agent)"
    print(io, str)
    return nothing
end

end # module
