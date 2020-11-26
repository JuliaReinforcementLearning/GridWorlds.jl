export Room, SequentialRooms

struct Room
    region::CartesianIndices{2}
end

Room(origin, height, width) = Room(CartesianIndices((origin.I[1] : origin.I[1] + height - 1, origin.I[2] : origin.I[2] + width - 1)))

interior(room::Room) = room.region[2:end-1, 2:end-1]

function is_intersecting(room1::Room, room2::Room)
    intersection = intersect(interior(room1), room2.region)
    length(intersection) > 0 ? true : false
end

mutable struct SequentialRooms{R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty,Wall,Goal}}
    agent_pos::CartesianIndex{2}
    agent::Agent
    num_rooms::Int
    room_length_range::UnitRange{Int}
    rooms::Array{Room, 1}
    goal_reward::Float64
    reward::Float64
    rng::R
end

function SequentialRooms(;num_rooms = 3, room_length_range = 4:8, agent_start_dir = RIGHT, rng = Random.GLOBAL_RNG)
    objects = (EMPTY, WALL, GOAL)
    n = num_rooms * room_length_range.stop
    world = GridWorldBase(objects, n, n)

    goal_reward = 1.0
    reward = 0.0

    env = SequentialRooms(world, CartesianIndex(1, 1), Agent(dir = agent_start_dir), num_rooms, room_length_range, Room[], goal_reward, reward, rng)

    return env
end

function (env::SequentialRooms)(::MoveForward)
    env.reward = 0.0
    agent = get_agent(env)
    dir = get_agent_dir(env)
    pos = get_agent_pos(env)
    dest = dir(pos)
    if !env.world[WALL, dest]
        env.agent_pos = dest
        if env.world[GOAL, env.agent_pos]
            env.reward = env.goal_reward
        end
    end
    env
end
