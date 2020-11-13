export DynamicObstacles
using Random

mutable struct DynamicObstacles{R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty,Wall,Obstacle,Goal}}
    agent_pos::CartesianIndex{2}
    agent::Agent
    num_obstacle::Int
    obs_pos_array::Array{CartesianIndex{2},1}
    rng::R
end

function DynamicObstacles(;n = 8, agent_start_pos = CartesianIndex(2,2), agent_start_dir = RIGHT, goal_pos = CartesianIndex(n-1, n-1), num_obstacle = n-3, rng = Random.GLOBAL_RNG)
    objects = (EMPTY, WALL, OBSTACLE, GOAL)
    w = GridWorldBase(objects, n, n)

    w[WALL, [1,n], 1:n] .= true
    w[WALL, 1:n, [1,n]] .= true

    obs_pos_array = Array{CartesianIndex{2},1}(undef,num_obstacle)

    env = DynamicObstacles(w, agent_start_pos, Agent(dir=agent_start_dir), num_obstacle, obs_pos_array, rng)

    reset!(env, agent_start_pos = agent_start_pos, agent_start_dir = agent_start_dir, goal_pos = goal_pos)

    return env
end

function (w::DynamicObstacles)(::MoveForward)
    dir = get_dir(w.agent) 
    dest = dir(w.agent_pos)
    if !w.world[WALL, dest]
        update_obstacles!(w)
        w.agent_pos = dest
    end
    w
end

function valid_obstacle_dest(w::DynamicObstacles, pos::CartesianIndex{2})
    candidate_pos = [CartesianIndex(pos[1] + i, pos[2] + j) for i in [-1, 0, 1] for j in [-1, 0, 1]]
    filter(p -> w.world[EMPTY, p] || pos == p || w.agent_pos == p, candidate_pos)
end

function update_obstacles!(w::DynamicObstacles)
    for (i, pos) in enumerate(w.obs_pos_array)
        w.world[EMPTY, pos] = true
        w.world[OBSTACLE, pos] = false

        new_pos = rand(w.rng, valid_obstacle_dest(w, pos))
        w.obs_pos_array[i] = new_pos

        w.world[EMPTY, new_pos] = false
        w.world[OBSTACLE, new_pos] = true
    end
end

RLBase.get_terminal(w::DynamicObstacles) = w.world[OBSTACLE, w.agent_pos] || w.world[GOAL, w.agent_pos]

function RLBase.reset!(w::DynamicObstacles; agent_start_pos = CartesianIndex(2, 2), agent_start_dir = RIGHT, goal_pos = CartesianIndex(size(w.world)[end] - 1, size(w.world)[end] - 1))

    n = size(w.world)[end]
    w.world[EMPTY, 2:n-1, 2:n-1] .= true
    w.world[GOAL, n-1, n-1] = true
    w.world[EMPTY, n-1, n-1] = false

    obstacles_placed = 0
    while obstacles_placed < w.num_obstacle
        obs_pos = CartesianIndex(rand(w.rng, 2:n-1), rand(w.rng, 2:n-1))
        if (obs_pos == agent_start_pos) || (w.world[OBSTACLE, obs_pos] == true) || (obs_pos == CartesianIndex(n-1,n-1))
            continue
        else
            w.world[OBSTACLE, obs_pos] = true
            w.world[EMPTY, obs_pos] = false
            obstacles_placed = obstacles_placed + 1
            w.obs_pos_array[obstacles_placed] = obs_pos
        end
    end
    return w
end
