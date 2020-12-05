export FourRooms

mutable struct FourRooms{R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty, Wall, Goal}}
    agent::Agent
    reward::Float64
    rng::R
    goal_reward::Float64
end

function FourRooms(; n = 9, agent_start_pos = CartesianIndex(2, 2), agent_start_dir = RIGHT, goal_pos = CartesianIndex(n - 1, n - 1), rng = Random.GLOBAL_RNG)
    objects = (EMPTY, WALL, GOAL)
    world = GridWorldBase(objects, n, n)
    agent = Agent(pos = agent_start_pos, dir = agent_start_dir)
    reward = 0.0
    goal_reward = 1.0

    env = FourRooms(world, agent, reward, rng, goal_reward)

    reset!(env, agent_start_pos = agent_start_pos, agent_start_dir = agent_start_dir, goal_pos = goal_pos)

    return env
end

function RLBase.reset!(env::FourRooms; agent_start_pos = CartesianIndex(2, 2), agent_start_dir = RIGHT, goal_pos = CartesianIndex(get_width(env) - 1, get_width(env) - 1))
    world = get_world(env)
    n = get_width(env)

    world[:, :, :] .= false
    world[WALL, [1, n], :] .= true
    world[WALL, :, [1, n]] .= true
    world[WALL, ceil(Int, n/2), vcat(2:ceil(Int, n/4)-1, ceil(Int, n/4)+1:ceil(Int, n/2)-1, ceil(Int, n/2):ceil(Int, 3*n/4)-1, ceil(Int, 3*n/4)+1:n)] .= true
    world[WALL, vcat(2:ceil(Int, n/4)-1, ceil(Int, n/4)+1:ceil(Int, n/2)-1, ceil(Int, n/2):ceil(Int, 3*n/4)-1, ceil(Int, 3*n/4)+1:n), ceil(Int, n/2)] .= true
    world[EMPTY, :, :] .= .!world[WALL, :, :]
    world[GOAL, goal_pos] = true
    world[EMPTY, goal_pos] = false

    set_agent_pos!(env, agent_start_pos)
    set_agent_dir!(env, agent_start_dir)

    set_reward!(env, 0.0)

    return env
end
