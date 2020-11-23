export DynamicObstacles

using Random

mutable struct DynamicObstacles{R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty,Wall,Obstacle,Goal}}
    agent_pos::CartesianIndex{2}
    agent::Agent
    num_obstacles::Int
    obstacle_pos::Array{CartesianIndex{2},1}
    obstacle_reward::Float64
    goal_reward::Float64
    reward::Float64
    rng::R
end

function DynamicObstacles(;n = 8, agent_start_pos = CartesianIndex(2,2), agent_start_dir = RIGHT, goal_pos = CartesianIndex(n-1, n-1), num_obstacles = n-3, rng = Random.GLOBAL_RNG)
    objects = (EMPTY, WALL, OBSTACLE, GOAL)
    w = GridWorldBase(objects, n, n)

    w[WALL, [1,n], 1:n] .= true
    w[WALL, 1:n, [1,n]] .= true

    obstacle_pos = Array{CartesianIndex{2},1}(undef,num_obstacles)

    obstacle_reward = -1.0
    goal_reward = 1.0
    reward = 0.0

    env = DynamicObstacles(w, agent_start_pos, Agent(dir=agent_start_dir), num_obstacles, obstacle_pos, obstacle_reward, goal_reward, reward, rng)

    reset!(env, agent_start_pos = agent_start_pos, agent_start_dir = agent_start_dir, goal_pos = goal_pos)

    return env
end

iscollision(env::DynamicObstacles) = env.world[OBSTACLE, env.agent_pos]

function (env::DynamicObstacles)(::MoveForward)
    env.reward = 0.0
    update_obstacles!(env)
    dir = get_dir(env.agent) 
    dest = dir(env.agent_pos)
    if !env.world[WALL, dest]
        env.agent_pos = dest
    end
    if iscollision(env)
        env.reward = env.obstacle_reward
    end
    return env
end

function (env::DynamicObstacles)(action::Union{TurnRight, TurnLeft})
    env.reward = 0.0
    update_obstacles!(env)
    agent = get_agent(env)
    set_dir!(agent, action(get_dir(agent)))
    if iscollision(env)
        env.reward = env.obstacle_reward
    end
    return env
end

function valid_obstacle_dest(env::DynamicObstacles, pos::CartesianIndex{2})
    candidate_pos = [CartesianIndex(pos[1] + i, pos[2] + j) for i in [-1, 0, 1] for j in [-1, 0, 1]]
    filter(p -> env.world[EMPTY, p] || pos == p, candidate_pos)
end

function update_obstacles!(env::DynamicObstacles)
    for (i, pos) in enumerate(env.obstacle_pos)
        env.world[EMPTY, pos] = true
        env.world[OBSTACLE, pos] = false

        new_pos = rand(env.rng, valid_obstacle_dest(env, pos))
        env.obstacle_pos[i] = new_pos

        env.world[EMPTY, new_pos] = false
        env.world[OBSTACLE, new_pos] = true
    end
    return env
end

RLBase.get_terminal(env::DynamicObstacles) = iscollision(env) || env.world[GOAL, env.agent_pos]

function RLBase.reset!(env::DynamicObstacles; agent_start_pos = CartesianIndex(2, 2), agent_start_dir = RIGHT, goal_pos = CartesianIndex(size(env.world)[end] - 1, size(env.world)[end] - 1))

    n = size(env.world)[end]
    env.world[EMPTY, 2:n-1, 2:n-1] .= true
    env.world[GOAL, goal_pos] = true
    env.world[EMPTY, goal_pos] = false
    env.agent_pos = agent_start_pos
    agent = get_agent(env)
    set_dir!(agent, agent_start_dir)

    obstacles_placed = 0
    while obstacles_placed < env.num_obstacles
        pos = CartesianIndex(rand(env.rng, 2:n-1), rand(env.rng, 2:n-1))
        if (pos == env.agent_pos) || (env.world[OBSTACLE, pos] == true) || (pos == goal_pos)
            continue
        else
            env.world[OBSTACLE, pos] = true
            env.world[EMPTY, pos] = false
            obstacles_placed = obstacles_placed + 1
            env.obstacle_pos[obstacles_placed] = pos
        end
    end
    return env
end
