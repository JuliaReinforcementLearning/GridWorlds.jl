export DynamicObstacles

mutable struct DynamicObstacles{R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty, Wall, Obstacle, Goal}}
    agent::Agent
    reward::Float64
    rng::R
    terminal_reward::Float64
    goal_pos::CartesianIndex{2}
    num_obstacles::Int
    obstacle_pos::Vector{CartesianIndex{2}}
    terminal_penalty::Float64
end

function DynamicObstacles(; height = 8, width = 8, num_obstacles = floor(Int, sqrt(height * width) / 2), rng = Random.GLOBAL_RNG)
    objects = (EMPTY, WALL, OBSTACLE, GOAL)
    world = GridWorldBase(objects, height, width)
    room = Room(CartesianIndex(1, 1), height, width)
    place_room!(world, room)

    goal_pos = CartesianIndex(height - 1, width - 1)
    world[GOAL, goal_pos] = true
    world[EMPTY, goal_pos] = false

    agent = Agent()
    reward = 0.0
    terminal_reward = 1.0
    obstacle_pos = CartesianIndex{2}[]
    terminal_penalty = -1.0

    env = DynamicObstacles(world, agent, reward, rng, terminal_reward, goal_pos, num_obstacles, obstacle_pos, terminal_penalty)

    reset!(env)

    return env
end

iscollision(env::DynamicObstacles) = get_world(env)[OBSTACLE, get_agent_pos(env)]

function (env::DynamicObstacles)(::MoveForward)
    world = get_world(env)
    update_obstacles!(env)

    dir = get_agent_dir(env)
    dest = move(dir, get_agent_pos(env))
    if !world[WALL, dest]
        set_agent_pos!(env, dest)
    end

    set_reward!(env, 0.0)
    if world[GOAL, get_agent_pos(env)]
        set_reward!(env, env.terminal_reward)
    elseif iscollision(env)
        set_reward!(env, env.terminal_penalty)
    end

    return env
end

function (env::DynamicObstacles)(action::Union{TurnRight, TurnLeft})
    world = get_world(env)
    update_obstacles!(env)

    dir = get_agent_dir(env)
    new_dir = turn(action, dir)
    set_agent_dir!(env, new_dir)

    set_reward!(env, 0.0)
    if world[GOAL, get_agent_pos(env)]
        set_reward!(env, env.terminal_reward)
    elseif iscollision(env)
        set_reward!(env, env.terminal_penalty)
    end

    return env
end

function valid_obstacle_dest(env::DynamicObstacles, pos::CartesianIndex{2})
    world = get_world(env)
    candidate_pos = [CartesianIndex(pos[1] + i, pos[2] + j) for i in [-1, 0, 1] for j in [-1, 0, 1]]
    filter(p -> (world[EMPTY, p] || p == pos), candidate_pos)
end

function update_obstacles!(env::DynamicObstacles)
    world = get_world(env)
    for (i, pos) in enumerate(env.obstacle_pos)
        world[OBSTACLE, pos] = false
        world[EMPTY, pos] = true

        new_pos = rand(get_rng(env), valid_obstacle_dest(env, pos))
        env.obstacle_pos[i] = new_pos

        world[OBSTACLE, new_pos] = true
        world[EMPTY, new_pos] = false
    end
    
    return env
end

RLBase.is_terminated(env::DynamicObstacles) = iscollision(env) || get_world(env)[GOAL, get_agent_pos(env)]

function RLBase.reset!(env::DynamicObstacles)
    world = get_world(env)
    rng = get_rng(env)

    for pos in env.obstacle_pos
        world[OBSTACLE, pos] = false
        world[EMPTY, pos] = true
    end

    old_goal_pos = get_goal_pos(env)
    world[GOAL, old_goal_pos] = false
    world[EMPTY, old_goal_pos] = true

    new_goal_pos = rand(rng, pos -> world[EMPTY, pos], env)

    set_goal_pos!(env, new_goal_pos)
    world[GOAL, new_goal_pos] = true
    world[EMPTY, new_goal_pos] = false

    env.obstacle_pos = CartesianIndex{2}[]

    for i in 1:env.num_obstacles
        pos = rand(rng, pos -> world[EMPTY, pos], env)
        world[OBSTACLE, pos] = true
        world[EMPTY, pos] = false
        push!(env.obstacle_pos, pos)
    end

    agent_start_pos = rand(rng, pos -> world[EMPTY, pos], env)
    agent_start_dir = rand(rng, DIRECTIONS)

    set_agent_pos!(env, agent_start_pos)
    set_agent_dir!(env, agent_start_dir)

    set_reward!(env, 0.0)

    return env
end
