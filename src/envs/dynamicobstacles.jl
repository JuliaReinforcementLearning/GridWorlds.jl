export DynamicObstacles

mutable struct DynamicObstacles{R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty, Wall, Obstacle, Goal}}
    agent::Agent
    reward::Float64
    rng::R
    goal_reward::Float64
    num_obstacles::Int
    obstacle_pos::Array{CartesianIndex{2},1}
    obstacle_reward::Float64
end

function DynamicObstacles(; n = 8, agent_start_pos = CartesianIndex(2,2), agent_start_dir = RIGHT, goal_pos = CartesianIndex(n-1, n-1), num_obstacles = n-3, rng = Random.GLOBAL_RNG)
    objects = (EMPTY, WALL, OBSTACLE, GOAL)
    world = GridWorldBase(objects, n, n)
    agent = Agent(pos = agent_start_pos, dir = agent_start_dir)
    reward = 0.0
    goal_reward = 1.0
    obstacle_pos = Array{CartesianIndex{2}, 1}(undef, num_obstacles)
    obstacle_reward = -1.0

    env = DynamicObstacles(world, agent, reward, rng, goal_reward, num_obstacles, obstacle_pos, obstacle_reward)

    reset!(env, agent_start_pos = agent_start_pos, agent_start_dir = agent_start_dir, goal_pos = goal_pos)

    return env
end

iscollision(env::DynamicObstacles) = get_world(env)[OBSTACLE, get_agent_pos(env)]

function (env::DynamicObstacles)(::MoveForward)
    world = get_world(env)

    update_obstacles!(env)

    dir = get_agent_dir(env)
    dest = dir(get_agent_pos(env))
    if !world[WALL, dest]
        set_agent_pos!(env, dest)
    end

    set_reward!(env, 0.0)
    if iscollision(env)
        set_reward!(env, env.obstacle_reward)
    end

    return env
end

function (env::DynamicObstacles)(action::Union{TurnRight, TurnLeft})
    update_obstacles!(env)

    set_dir!(get_agent(env), action(get_agent_dir(env)))

    set_reward!(env, 0.0)
    if iscollision(env)
        set_reward!(env, env.obstacle_reward)
    end

    return env
end

function valid_obstacle_dest(env::DynamicObstacles, pos::CartesianIndex{2})
    candidate_pos = [CartesianIndex(pos[1] + i, pos[2] + j) for i in [-1, 0, 1] for j in [-1, 0, 1]]
    filter(p -> get_world(env)[EMPTY, p] || pos == p, candidate_pos)
end

function update_obstacles!(env::DynamicObstacles)
    world = get_world(env)

    for (i, pos) in enumerate(env.obstacle_pos)
        world[EMPTY, pos] = true
        world[OBSTACLE, pos] = false

        new_pos = rand(get_rng(env), valid_obstacle_dest(env, pos))
        env.obstacle_pos[i] = new_pos

        world[EMPTY, new_pos] = false
        world[OBSTACLE, new_pos] = true
    end
    
    return env
end

RLBase.get_terminal(env::DynamicObstacles) = iscollision(env) || get_world(env)[GOAL, get_agent_pos(env)]

function RLBase.reset!(env::DynamicObstacles; agent_start_pos = CartesianIndex(2, 2), agent_start_dir = RIGHT, goal_pos = CartesianIndex(get_width(env) - 1, get_width(env) - 1))
    world = get_world(env)
    n = get_width(env)
    rng = get_rng(env)

    world[:, :, :] .= false
    world[WALL, [1,n], 1:n] .= true
    world[WALL, 1:n, [1,n]] .= true
    world[EMPTY, 2:n-1, 2:n-1] .= true
    world[GOAL, goal_pos] = true
    world[EMPTY, goal_pos] = false

    env.obstacle_pos = Array{CartesianIndex{2}, 1}[]
    obstacles_placed = 0
    while obstacles_placed < env.num_obstacles
        pos = CartesianIndex(rand(rng, 2:n-1), rand(rng, 2:n-1))
        if (pos == agent_start_pos) || (world[OBSTACLE, pos] == true) || (pos == goal_pos)
            continue
        else
            world[OBSTACLE, pos] = true
            world[EMPTY, pos] = false
            obstacles_placed += 1
            push!(env.obstacle_pos, pos)
        end
    end

    set_agent_pos!(env, agent_start_pos)
    set_agent_dir!(env, agent_start_dir)

    set_reward!(env, 0.0)

    return env
end
