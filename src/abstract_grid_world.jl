export AbstractGridWorld

abstract type AbstractGridWorld <: RLBase.AbstractEnv end

get_world(env::AbstractGridWorld) = env.world
set_world!(env::AbstractGridWorld, world::GridWorldBase) = env.world = world
@forward AbstractGridWorld.world get_grid, get_objects, get_num_objects, get_height, get_width

get_agent_pos(env::AbstractGridWorld) = env.agent_pos
set_agent_pos!(env::AbstractGridWorld, pos::CartesianIndex{2}) = env.agent_pos = pos
get_agent_dir(env::AbstractGridWorld) = env.agent_dir
set_agent_dir!(env::AbstractGridWorld, dir::AbstractDirection) = env.agent_dir = dir

get_reward(env::AbstractGridWorld) = env.reward
set_reward!(env::AbstractGridWorld, reward) = env.reward = reward

get_done(env::AbstractGridWorld) = env.done
set_done!(env::AbstractGridWorld, done) = env.done = done

get_rng(env::AbstractGridWorld) = env.rng

get_goal_pos(env::AbstractGridWorld) = env.goal_pos
set_goal_pos!(env::AbstractGridWorld, pos::CartesianIndex{2}) = env.goal_pos = pos

Random.rand(rng::Random.AbstractRNG, f::Function, env::AbstractGridWorld; max_try = 1000) = rand(rng, f, get_world(env), max_try = max_try)

#####
# Agent's view
#####

get_agent_view_size(env::AbstractGridWorld) = (2 * (get_height(env) ÷ 4) + 1, 2 * (get_width(env) ÷ 4) + 1)

get_agent_view_inds(env::AbstractGridWorld) = get_grid_inds(get_agent_pos(env).I, get_agent_view_size(env), get_agent_dir(env))

get_agent_view(env::AbstractGridWorld) = get_grid(get_world(env), get_agent_view_size(env), get_agent_pos(env), get_agent_dir(env))

get_agent_view!(agent_view::AbstractArray{Bool, 3}, env::AbstractGridWorld) = get_grid!(agent_view, get_world(env), get_agent_pos(env), get_agent_dir(env))

function get_grid_with_agent_layer(env::AbstractGridWorld)
    grid = get_grid(env)
    agent_layer = falses(1, get_height(env), get_width(env))
    agent_layer[1, get_agent_pos(env)] = true
    return cat(agent_layer, grid, dims = 1)
end

show_agent_char(env::AbstractGridWorld) = true
