export GridRooms

mutable struct GridRooms{T, R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty, Wall, Goal}}
    agent_pos::CartesianIndex{2}
    agent_dir::AbstractDirection
    reward::T
    rng::R
    terminal_reward::T
    goal_pos::CartesianIndex{2}
    done::Bool
end

get_reward_type(env::GridRooms{T}) where {T} = T

function GridRooms(; T = Float32, grid_size = (2, 2), room_size = (5, 5), rng = Random.GLOBAL_RNG)
    grid_height = grid_size[1]
    grid_width = grid_size[2]
    room_height = room_size[1]
    room_width = room_size[2]

    height = room_height * grid_height - grid_height + 1
    width = room_width * grid_width - grid_width + 1
    objects = (EMPTY, WALL, GOAL)
    world = GridWorldBase(objects, height, width)

    origins = get_room_origins(grid_size, room_size)

    for origin in origins
        room = Room(origin, room_height, room_width)
        place_room!(world, room)

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

    agent_pos = CartesianIndex(2, 2)
    agent_dir = RIGHT
    reward = zero(T)
    terminal_reward = one(T)
    goal_pos = CartesianIndex(height - 1, width - 1)
    done = false

    env = GridRooms(world, agent_pos, agent_dir, reward, rng, terminal_reward, goal_pos, done)

    RLBase.reset!(env)

    return env
end

function get_room_origins(grid_size, room_size)
    grid_height = grid_size[1]
    grid_width = grid_size[2]
    room_height = room_size[1]
    room_width = room_size[2]

    vertical_steps = 1 : room_height - 1 : 1 + (grid_height - 1) * (room_height - 1)
    horizontal_steps = 1 : room_width - 1 : 1 + (grid_width - 1) * (room_width - 1)

    return [CartesianIndex(i, j) for i in vertical_steps for j in horizontal_steps]
end

function RLBase.reset!(env::GridRooms{T}) where {T}
    world = get_world(env)
    rng = get_rng(env)

    old_goal_pos = get_goal_pos(env)
    world[GOAL, old_goal_pos] = false
    world[EMPTY, old_goal_pos] = true

    new_goal_pos = rand(rng, pos -> world[EMPTY, pos], env)

    set_goal_pos!(env, new_goal_pos)
    world[GOAL, new_goal_pos] = true
    world[EMPTY, new_goal_pos] = false

    agent_start_pos = rand(rng, pos -> world[EMPTY, pos], env)
    agent_start_dir = get_agent_start_dir(env)

    set_agent_pos!(env, agent_start_pos)
    set_agent_dir!(env, agent_start_dir)

    set_reward!(env, zero(T))
    set_done!(env, false)

    return env
end
