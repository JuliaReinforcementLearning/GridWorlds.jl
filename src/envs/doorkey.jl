export DoorKey

mutable struct DoorKey{W<:GridWorldBase, R} <: AbstractGridWorld
    world::W
    agent::Agent
    reward::Float64
    rng::R
    goal_reward::Float64
    goal_pos::CartesianIndex
    door_pos::CartesianIndex
    key_pos::CartesianIndex
end

function DoorKey(; n = 7, rng = Random.GLOBAL_RNG)
    door = Door(:yellow)
    key = Key(:yellow)
    objects = (EMPTY, WALL, GOAL, door, key)
    world = GridWorldBase(objects, n, n)
    room = Room(CartesianIndex(1, 1), n, n)
    place_room!(world, room)

    agent = Agent(pos = CartesianIndex(2, 2), dir = RIGHT)
    reward = 0.0
    goal_reward = 1.0
    goal_pos = CartesianIndex(n - 1, n - 1)
    door_pos = CartesianIndex(2, 3)
    key_pos = CartesianIndex(3, 2)

    env = DoorKey(world, agent, reward, rng, goal_reward, goal_pos, door_pos, key_pos)

    reset!(env)

    return env
end

RLBase.get_actions(env::DoorKey) = (MOVE_FORWARD, TURN_LEFT, TURN_RIGHT, PICK_UP)

function (env::DoorKey)(::MoveForward)
    world = get_world(env)
    objects = get_objects(env)
    agent = get_agent(env)

    door = objects[end - 1]
    key = objects[end]

    dir = get_agent_dir(env)
    dest = dir(get_agent_pos(env))

    if world[door, dest]
        if get_inventory(env) === key
            set_agent_pos!(env, dest)
        end
    elseif !world[WALL, dest]
        set_agent_pos!(env, dest)
    end

    set_reward!(env, 0.0)
    if world[GOAL, get_agent_pos(env)]
        set_reward!(env, env.goal_reward)
    end

    return env
end

function (env::DoorKey)(::Pickup)
    world = get_world(env)
    objects = get_objects(env)

    key = objects[end]
    agent_pos = get_agent_pos(env)

    if world[key, agent_pos] && isnothing(get_inventory(env))
        world[key, agent_pos] = false
        world[EMPTY, agent_pos] = true
        set_inventory!(env, key)
    end

    return env
end

function RLBase.reset!(env::DoorKey)
    world = get_world(env)
    n = get_width(env)
    rng = get_rng(env)

    objects = get_objects(env)
    door = objects[end - 1]
    key = objects[end]

    world[WALL, 2:n-1, env.door_pos[2]] .= false
    world[door, env.door_pos] = false
    world[EMPTY, 2:n-1, env.door_pos[2]] .= true

    if isnothing(get_inventory(env))
        world[key, env.key_pos] = false
        world[EMPTY, env.key_pos] = true
    end

    old_goal_pos = get_goal_pos(env)
    world[GOAL, old_goal_pos] = false
    world[EMPTY, old_goal_pos] = true

    new_door_pos = rand(rng, CartesianIndices((2:n-1, 3:n-2)))
    env.door_pos = new_door_pos
    world[door, new_door_pos] = true
    world[WALL, 2:n-1, new_door_pos[2]] .= true
    world[WALL, new_door_pos] = false
    world[EMPTY, 2:n-1, new_door_pos[2]] .= false

    left_region = CartesianIndices((2:n-1, 2:new_door_pos[2]-1))
    right_region = CartesianIndices((2:n-1, new_door_pos[2]+1:n-1))

    new_goal_pos = rand(rng, pos -> world[EMPTY, pos], right_region)
    set_goal_pos!(env, new_goal_pos)
    world[GOAL, new_goal_pos] = true
    world[EMPTY, new_goal_pos] = false

    new_key_pos = rand(rng, pos -> world[EMPTY, pos], left_region)
    env.key_pos = new_key_pos
    world[key, new_key_pos] = true
    world[EMPTY, new_key_pos] = false

    agent_start_pos = rand(rng, pos -> world[EMPTY, pos], left_region)
    agent_start_dir = rand(rng, DIRECTIONS)

    set_agent_pos!(env, agent_start_pos)
    set_agent_dir!(env, agent_start_dir)
    set_inventory!(env, nothing)

    set_reward!(env, 0.0)

    return env
end
