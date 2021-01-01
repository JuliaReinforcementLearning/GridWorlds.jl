export AbstractGridWorld

abstract type AbstractGridWorld <: RLBase.AbstractEnv end

#####
# Useful getters and setters
#####

get_world(env::AbstractGridWorld) = env.world
set_world!(env::AbstractGridWorld, world::GridWorldBase) = env.world = world
@forward AbstractGridWorld.world get_grid, get_objects, get_num_objects, get_height, get_width

get_agent(env::AbstractGridWorld) = env.agent
set_agent!(env::AbstractGridWorld, agent::Agent) = env.agent = agent
get_agent_pos(env::AbstractGridWorld) = env |> get_agent |> get_pos
set_agent_pos!(env::AbstractGridWorld, pos::CartesianIndex{2}) = set_pos!(get_agent(env), pos)
get_agent_dir(env::AbstractGridWorld) = env |> get_agent |> get_dir
set_agent_dir!(env::AbstractGridWorld, dir::AbstractDirection) = set_dir!(get_agent(env), dir)
@forward AbstractGridWorld.agent get_inventory_type, get_inventory, set_inventory!

set_reward!(env::AbstractGridWorld, reward) = env.reward = reward

get_rng(env::AbstractGridWorld) = env.rng

get_goal_pos(env::AbstractGridWorld) = env.goal_pos
set_goal_pos!(env::AbstractGridWorld, pos::CartesianIndex{2}) = env.goal_pos = pos

Random.rand(rng::Random.AbstractRNG, f::Function, env::AbstractGridWorld; max_try = 1000) = rand(rng, f, get_world(env), max_try = max_try)

#####
# Agent direction style trait
#####

abstract type AbstractNavigationStyle end

struct DirectedNavigation <: AbstractNavigationStyle end
const DIRECTED_NAVIGATION = DirectedNavigation()

struct UndirectedNavigation <: AbstractNavigationStyle end
const UNDIRECTED_NAVIGATION = UndirectedNavigation()

get_navigation_style(env::AbstractGridWorld) = get_navigation_style(typeof(env))
get_navigation_style(::Type{<:AbstractGridWorld}) = DIRECTED_NAVIGATION

get_agent_start_dir(env::AbstractGridWorld) = get_agent_start_dir(env, get_navigation_style(env))
get_agent_start_dir(env::AbstractGridWorld, ::DirectedNavigation) = rand(get_rng(env), DIRECTIONS)
get_agent_start_dir(env::AbstractGridWorld, ::UndirectedNavigation) = CENTER

#####
# Agent's view
#####

function get_agent_view_size(env::AbstractGridWorld)
    m = 2 * ceil(Int, get_height(env) / 4) + 1
    n = 2 * ceil(Int, get_width(env) / 4) + 1
    return (m, n)
end

get_agent_view_inds(env::AbstractGridWorld) = get_agent_view_inds(get_agent_pos(env).I, get_agent_view_size(env), get_agent_dir(env))

get_agent_view(env::AbstractGridWorld) = get_agent_view(get_world(env), get_agent_view_size(env), get_agent_pos(env), get_agent_dir(env))

get_agent_view!(agent_view::AbstractArray{Bool, 3}, env::AbstractGridWorld) = get_agent_view!(agent_view, get_world(env), get_agent_pos(env), get_agent_dir(env))

#####
# Full view
#####

function get_agent_layer(grid::BitArray{3}, agent_pos::CartesianIndex{2})
    dims = size(grid)[2:end]
    agent_layer = falses(1, dims...)
    agent_layer[1, agent_pos] = true
    return agent_layer
end

function get_full_view(env::AbstractGridWorld)
    grid = get_grid(env)
    agent_layer = get_agent_layer(grid, get_agent_pos(env))
    return cat(agent_layer, grid, dims = 1)
end

#####
# RLBase API defaults
#####

const get_state = RLBase.state
RLBase.state(env::AbstractGridWorld, ss::RLBase.AbstractStateStyle, player::RLBase.DefaultPlayer) = RLBase.state(env, ss, player, get_navigation_style(env))
RLBase.state(env::AbstractGridWorld, ::RLBase.Observation, ::RLBase.DefaultPlayer) = get_agent_view(env)
RLBase.state(env::AbstractGridWorld, ::RLBase.InternalState, ::RLBase.DefaultPlayer, ::DirectedNavigation) = (get_full_view(env), get_agent_dir(env))
RLBase.state(env::AbstractGridWorld, ::RLBase.InternalState, ::RLBase.DefaultPlayer, ::UndirectedNavigation) = get_full_view(env)

const get_action_space = RLBase.action_space
RLBase.action_space(env::AbstractGridWorld, player::RLBase.DefaultPlayer) = RLBase.action_space(env, player, get_navigation_style(env))
RLBase.action_space(env::AbstractGridWorld, player::RLBase.DefaultPlayer, ::DirectedNavigation) = DIRECTED_NAVIGATION_ACTIONS
RLBase.action_space(env::AbstractGridWorld, player::RLBase.DefaultPlayer, ::UndirectedNavigation) = UNDIRECTED_NAVIGATION_ACTIONS

const get_reward = RLBase.reward
RLBase.reward(env::AbstractGridWorld, ::RLBase.DefaultPlayer) = env.reward

RLBase.is_terminated(env::AbstractGridWorld) = get_world(env)[GOAL, get_agent_pos(env)]

function (env::AbstractGridWorld)(action::Union{TurnRight, TurnLeft})
    dir = get_agent_dir(env)
    new_dir = turn(action, dir)
    set_agent_dir!(env, new_dir)

    set_reward!(env, 0.0)

    return env
end

function (env::AbstractGridWorld)(::MoveForward)
    world = get_world(env)

    dir = get_agent_dir(env)
    dest = move(dir, get_agent_pos(env))
    if !world[WALL, dest]
        set_agent_pos!(env, dest)
    end

    set_reward!(env, 0.0)
    if RLBase.is_terminated(env)
        set_reward!(env, env.terminal_reward)
    end

    return env
end

function (env::AbstractGridWorld)(action::Union{MoveUp, MoveDown, MoveLeft, MoveRight})
    world = get_world(env)

    dest = move(action, get_agent_pos(env))
    if !world[WALL, dest]
        set_agent_pos!(env, dest)
    end

    set_reward!(env, 0.0)
    if RLBase.is_terminated(env)
        set_reward!(env, env.terminal_reward)
    end

    return env
end
