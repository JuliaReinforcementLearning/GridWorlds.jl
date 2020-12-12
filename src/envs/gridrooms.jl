export GridRooms

mutable struct GridRooms{R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty, Wall, Goal}}
    agent::Agent
    reward::Float64
    rng::R
    goal_reward::Float64
    grid_size::Tuple{Int, Int}
    room_size::Tuple{Int, Int}
end

function GridRooms(; grid_size = (2, 2), room_size = (5, 5), agent_start_pos = CartesianIndex(2, 2), agent_start_dir = RIGHT, rng = Random.GLOBAL_RNG)
    grid_height = grid_size[1]
    grid_width = grid_size[2]
    room_height = room_size[1]
    room_width = room_size[2]

    height = room_height * grid_height - grid_height + 1
    width = room_width * grid_width - grid_width + 1
    objects = (EMPTY, WALL, GOAL)
    world = GridWorldBase(objects, height, width)
    agent = Agent(pos = agent_start_pos, dir = agent_start_dir)
    reward = 0.0
    goal_reward = 1.0

    env = GridRooms(world, agent, reward, rng, goal_reward, grid_size, room_size)

    reset!(env, agent_start_pos = agent_start_pos, agent_start_dir = agent_start_dir)

    return env
end

function RLBase.reset!(env::GridRooms; agent_start_pos = CartesianIndex(2, 2), agent_start_dir = RIGHT)
    world = get_world(env)
    height = get_height(env)
    width = get_width(env)

    origins = get_room_origins(env)

    for origin in origins
        room = Room(origin, env.room_size[1], env.room_size[2])
        add_room!(env, room)

        world[WALL, room.region[(end + 1) ÷ 2, 1]] = false
        world[EMPTY, room.region[(end + 1) ÷ 2, 1]] = true
        world[WALL, room.region[(end + 1) ÷ 2, end]] = false
        world[EMPTY, room.region[(end + 1) ÷ 2, end]] = true
        world[WALL, room.region[1, (end + 1) ÷ 2]] = false
        world[EMPTY, room.region[1, (end + 1) ÷ 2]] = true
        world[WALL, room.region[end, (end + 1) ÷ 2]] = false
        world[EMPTY, room.region[end, (end + 1) ÷ 2]] = true
    end

    world[WALL, [1, height], :] .= true
    world[EMPTY, [1, height], :] .= false
    world[WALL, :, [1, width]] .= true
    world[EMPTY, :, [1, width]] .= false

    goal_pos = CartesianIndex(height - 1, width - 1)
    world[GOAL, goal_pos] = true
    world[EMPTY, goal_pos] = false

    set_agent_pos!(env, agent_start_pos)
    set_agent_dir!(env, agent_start_dir)

    set_reward!(env, 0.0)

    return env
end

function get_room_origins(env::GridRooms)
    grid_height = env.grid_size[1]
    grid_width = env.grid_size[2]
    room_height = env.room_size[1]
    room_width = env.room_size[2]
    vertical_steps = 1 : room_height - 1 : get_height(env) - room_height + 1
    horizontal_steps = 1 : room_width - 1 : get_width(env) - room_width + 1
    origins = [CartesianIndex(i, j) for i in vertical_steps for j in horizontal_steps]
    return origins
end
