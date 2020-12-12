export EmptyGridWorld

mutable struct EmptyGridWorld{R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty, Wall, Goal}}
    agent::Agent
    reward::Float64
    rng::R
    goal_reward::Float64
    goal_pos::CartesianIndex
end

function EmptyGridWorld(; height = 8, width = 8, agent_start_pos = CartesianIndex(2, 2), agent_start_dir = RIGHT, goal_pos = CartesianIndex(height - 1, width - 1), rng = Random.GLOBAL_RNG)
    objects = (EMPTY, WALL, GOAL)
    world = GridWorldBase(objects, height, width)
    room = Room(CartesianIndex(1, 1), height, width)
    place_room!(world, room)
    agent = Agent(pos = agent_start_pos, dir = agent_start_dir)
    reward = 0.0
    goal_reward = 1.0

    env = EmptyGridWorld(world, agent, reward, rng, goal_reward, goal_pos)

    reset!(env, agent_start_pos = agent_start_pos, agent_start_dir = agent_start_dir, goal_pos = goal_pos)

    return env
end

function RLBase.reset!(env::EmptyGridWorld; agent_start_pos = CartesianIndex(2, 2), agent_start_dir = RIGHT, goal_pos = CartesianIndex(get_height(env) - 1, get_width(env) - 1))
    world = get_world(env)

    old_goal_pos = get_goal_pos(env)
    world[GOAL, old_goal_pos] = false
    world[EMPTY, old_goal_pos] = true

    set_goal_pos!(env, goal_pos)
    world[GOAL, goal_pos] = true
    world[EMPTY, goal_pos] = false

    set_agent_pos!(env, agent_start_pos)
    set_agent_dir!(env, agent_start_dir)

    set_reward!(env, 0.0)

    return env
end
