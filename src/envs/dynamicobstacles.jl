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

iscollision(w::DynamicObstacles) = w.world[OBSTACLE, w.agent_pos]

function (w::DynamicObstacles)(::MoveForward)
    w.reward = 0.0
    update_obstacles!(w)
    dir = get_dir(w.agent) 
    dest = dir(w.agent_pos)
    if !w.world[WALL, dest]
        w.agent_pos = dest
    end
    if iscollision(w)
        w.reward = w.obstacle_reward
    end
    w
end

function (w::DynamicObstacles)(action::Union{TurnRight, TurnLeft})
    w.reward = 0.0
    update_obstacles!(w)
    agent = get_agent(w)
    set_dir!(agent, action(get_dir(agent)))
    if iscollision(w)
        w.reward = w.obstacle_reward
    end
    w
end

function valid_obstacle_dest(w::DynamicObstacles, pos::CartesianIndex{2})
    candidate_pos = [CartesianIndex(pos[1] + i, pos[2] + j) for i in [-1, 0, 1] for j in [-1, 0, 1]]
    filter(p -> w.world[EMPTY, p] || pos == p, candidate_pos)
end

function update_obstacles!(w::DynamicObstacles)
    for (i, pos) in enumerate(w.obstacle_pos)
        w.world[EMPTY, pos] = true
        w.world[OBSTACLE, pos] = false

        new_pos = rand(w.rng, valid_obstacle_dest(w, pos))
        w.obstacle_pos[i] = new_pos

        w.world[EMPTY, new_pos] = false
        w.world[OBSTACLE, new_pos] = true
    end
end

RLBase.get_terminal(w::DynamicObstacles) = iscollision(w) || w.world[GOAL, w.agent_pos]

RLBase.get_reward(w::DynamicObstacles) = w.reward

function RLBase.reset!(w::DynamicObstacles; agent_start_pos = CartesianIndex(2, 2), agent_start_dir = RIGHT, goal_pos = CartesianIndex(size(w.world)[end] - 1, size(w.world)[end] - 1))

    n = size(w.world)[end]
    w.world[EMPTY, 2:n-1, 2:n-1] .= true
    w.world[GOAL, goal_pos] = true
    w.world[EMPTY, goal_pos] = false
    w.agent_pos = agent_start_pos
    agent = get_agent(w)
    set_dir!(agent, agent_start_dir)

    obstacles_placed = 0
    while obstacles_placed < w.num_obstacles
        pos = CartesianIndex(rand(w.rng, 2:n-1), rand(w.rng, 2:n-1))
        if (pos == w.agent_pos) || (w.world[OBSTACLE, pos] == true) || (pos == goal_pos)
            continue
        else
            w.world[OBSTACLE, pos] = true
            w.world[EMPTY, pos] = false
            obstacles_placed = obstacles_placed + 1
            w.obstacle_pos[obstacles_placed] = pos
        end
    end
    return w
end
