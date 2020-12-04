export EmptyGridWorld

mutable struct EmptyGridWorld <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty,Wall,Goal}}
    agent::Agent
    goal_reward::Float64
    reward::Float64
end

function EmptyGridWorld(; n = 8, agent_start_pos = CartesianIndex(2,2), agent_start_dir = RIGHT, goal_pos = CartesianIndex(n-1, n-1))
    objects = (EMPTY, WALL, GOAL)
    world = GridWorldBase(objects, n, n)

    world[WALL, [1,n], 1:n] .= true
    world[WALL, 1:n, [1,n]] .= true

    goal_reward = 1.0
    reward = 0.0

    env = EmptyGridWorld(world, Agent(dir = agent_start_dir, pos = agent_start_pos), goal_reward, reward)

    reset!(env, agent_start_pos = agent_start_pos, agent_start_dir = agent_start_dir, goal_pos = goal_pos)

    return env
end

function RLBase.reset!(env::EmptyGridWorld; agent_start_pos = CartesianIndex(2, 2), agent_start_dir = RIGHT, goal_pos = CartesianIndex(get_width(env) - 1, get_width(env) - 1))
    world = get_world(env)

    set_reward!(env, 0.0)

    set_agent_pos!(env, agent_start_pos)

    set_agent_dir!(env, agent_start_dir)

    world[GOAL, :, :] .= false
    world[GOAL, goal_pos] = true
    world[EMPTY, :, :] .= .!world[WALL, :, :]
    world[EMPTY, goal_pos] = false

    return env
end
