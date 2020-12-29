export AbstractGridWorld

abstract type AbstractGridWorld <: AbstractEnv end

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

Random.rand(rng::AbstractRNG, f::Function, env::AbstractGridWorld; max_try = 1000) = rand(rng, f, get_world(env), max_try = max_try)

#####
# Agent's view
#####

function get_agent_view_size(env::AbstractGridWorld)
    m = 2 * ceil(Int, get_height(env) / 4) + 1
    n = 2 * ceil(Int, get_width(env) / 4) + 1
    return (m, n)
end

get_agent_view_inds(env::AbstractGridWorld; agent_view_size = get_agent_view_size(env)) = get_agent_view_inds(get_agent_pos(env).I, agent_view_size, get_agent_dir(env))

function get_agent_view(env::AbstractGridWorld; agent_view_size = get_agent_view_size(env))
    agent_view = falses(get_num_objects(env), agent_view_size...)
    get_agent_view!(agent_view, env)
end

get_agent_view!(grid::BitArray{3}, env::AbstractGridWorld) = get_agent_view!(grid, get_world(env), get_agent_pos(env), get_agent_dir(env))

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
RLBase.state(env::AbstractGridWorld, ::RLBase.Observation, ::DefaultPlayer) = get_agent_view(env)
RLBase.state(env::AbstractGridWorld, ::RLBase.InternalState, ::DefaultPlayer) = (get_full_view(env), get_agent_dir(env))

const get_action_space = RLBase.action_space
RLBase.action_space(env::AbstractGridWorld, ::DefaultPlayer) = (MOVE_FORWARD, TURN_LEFT, TURN_RIGHT)

const get_reward = RLBase.reward
RLBase.reward(env::AbstractGridWorld, ::DefaultPlayer) = env.reward

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
    if is_terminated(env)
        set_reward!(env, env.terminal_reward)
    end

    return env
end
