export FourRooms

mutable struct FourRooms{R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty,Wall,Goal}}
    agent::Agent
    goal_reward::Float64
    reward::Float64
    rng::R
end

function FourRooms(; n = 9, agent_start_pos = CartesianIndex(2, 2), agent_start_dir = RIGHT, goal_pos = CartesianIndex(n - 1, n - 1), rng = Random.GLOBAL_RNG)
    objects = (EMPTY, WALL, GOAL)
    world = GridWorldBase(objects, n, n)

    world[WALL, [1,n], 1:n] .= true
    world[WALL, 1:n, [1,n]] .= true
    world[WALL, ceil(Int,n/2), vcat(2:ceil(Int,n/4)-1,ceil(Int,n/4)+1:ceil(Int,n/2)-1,ceil(Int,n/2):ceil(Int,3*n/4)-1,ceil(Int,3*n/4)+1:n)] .= true
    world[WALL, vcat(2:ceil(Int,n/4)-1,ceil(Int,n/4)+1:ceil(Int,n/2)-1,ceil(Int,n/2):ceil(Int,3*n/4)-1,ceil(Int,3*n/4)+1:n), ceil(Int,n/2)] .= true
    world[EMPTY, :, :] .= .!world[WALL, :, :]
    world[GOAL, goal_pos] = true
    world[EMPTY, goal_pos] = false

    goal_reward = 1.0
    reward = 0.0

    env = FourRooms(world, Agent(dir = RIGHT, pos = agent_start_pos), goal_reward, reward, rng)

    reset!(env, agent_start_pos = agent_start_pos, agent_start_dir = agent_start_dir, goal_pos = goal_pos)

    return env
end

function RLBase.reset!(env::FourRooms; agent_start_pos = CartesianIndex(2, 2), agent_start_dir = RIGHT, goal_pos = CartesianIndex(get_width(env) - 1, get_width(env) - 1))
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
