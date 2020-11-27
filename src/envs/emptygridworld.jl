export EmptyGridWorld

mutable struct EmptyGridWorld <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty,Wall,Goal}}
    agent_pos::CartesianIndex{2}
    agent::Agent
    goal_reward::Float64
    reward::Float64
end

function EmptyGridWorld(;n = 8, agent_start_pos = CartesianIndex(2,2), agent_start_dir = RIGHT, goal_pos = CartesianIndex(n-1, n-1))
    objects = (EMPTY, WALL, GOAL)
    world = GridWorldBase(objects, n, n)

    world[WALL, [1,n], 1:n] .= true
    world[WALL, 1:n, [1,n]] .= true

    goal_reward = 1.0
    reward = 0.0

    env = EmptyGridWorld(world, agent_start_pos, Agent(dir = agent_start_dir), goal_reward, reward)

    reset!(env, agent_start_pos = agent_start_pos, agent_start_dir = agent_start_dir, goal_pos = goal_pos)

    return env
end

function (env::EmptyGridWorld)(::MoveForward)
    env.reward = 0.0
    world = get_world(env)
    agent = get_agent(env)
    dir = get_dir(agent)
    dest = dir(get_agent_pos(env))
    if !world[WALL, dest]
        env.agent_pos = dest
        if world[GOAL, env.agent_pos]
            env.reward = env.goal_reward
        end
    end
    return env
end

RLBase.get_terminal(env::EmptyGridWorld) = get_world(env)[GOAL, get_agent_pos(env)]

function RLBase.reset!(env::EmptyGridWorld; agent_start_pos = CartesianIndex(2, 2), agent_start_dir = RIGHT, goal_pos = CartesianIndex(size(env.world)[end] - 1, size(env.world)[end] - 1))
    env.reward = 0.0
    world = get_world(env)
    env.agent_pos = agent_start_pos
    agent = get_agent(env)
    set_dir!(agent, agent_start_dir)

    world[EMPTY, :, :] .= .!world[WALL, :, :]
    world[GOAL, goal_pos] = true
    world[EMPTY, goal_pos] = false

    return env
end
