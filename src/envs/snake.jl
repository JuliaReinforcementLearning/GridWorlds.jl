export Snake

mutable struct Snake{R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty, Wall, Body, Food}}
    agent::Agent
    reward::Float64
    rng::R
    terminated::Bool
    food_reward::Float64
    food_pos::CartesianIndex{2}
end

function Snake(; height = 8, width = 8, rng = Random.GLOBAL_RNG)
    objects = (EMPTY, WALL, BODY, FOOD)
    world = GridWorldBase(objects, height, width)
    room = Room(CartesianIndex(1, 1), height, width)
    place_room!(world, room)

    food_pos = CartesianIndex(height - 1, width - 1)
    world[FOOD, food_pos] = true
    world[EMPTY, food_pos] = false

    agent_start_pos = CartesianIndex(2, 2)
    body = DS.Queue{CartesianIndex{2}}()
    DS.enqueue!(body, agent_start_pos)
    world[BODY, agent_start_pos] = true
    world[EMPTY, agent_start_pos] = false
    agent_start_dir = CENTER
    agent = Agent(inventory_type = typeof(body), inventory = body, pos = agent_start_pos, dir = agent_start_dir)

    reward = 0.0
    terminated = false
    food_reward = 1.0

    env = Snake(world, agent, reward, rng, terminated, food_reward, food_pos)

    RLBase.reset!(env)

    return env
end

RLBase.StateStyle(env::Snake) = RLBase.InternalState{Any}()
get_navigation_style(::Snake) = UNDIRECTED_NAVIGATION

RLBase.is_terminated(env::Snake) = env.terminated

function (env::Snake)(action::AbstractMoveAction)
    world = get_world(env)
    rng = get_rng(env)
    body = get_inventory(env)

    dest = move(action, get_agent_dir(env), get_agent_pos(env))

    if world[EMPTY, dest]
        set_agent_pos!(env, dest)

        DS.enqueue!(body, dest)
        world[BODY, dest] = true
        world[EMPTY, dest] = false

        last_pos = DS.dequeue!(body)
        world[BODY, last_pos] = false
        world[EMPTY, last_pos] = true

        set_reward!(env, 0.0)

    elseif world[FOOD, dest]
        set_agent_pos!(env, dest)

        DS.enqueue!(body, dest)
        world[BODY, dest] = true
        world[FOOD, dest] = false

        food_pos = rand(rng, pos -> world[EMPTY, pos], env)
        env.food_pos = food_pos
        world[FOOD, food_pos] = true
        world[EMPTY, food_pos] = false

        set_reward!(env, env.food_reward)

    else
        env.terminated = true
        set_reward!(env, 0.0)

    end

    return env
end

function RLBase.reset!(env::Snake)
    world = get_world(env)
    rng = get_rng(env)
    body = get_inventory(env)

    old_food_pos = env.food_pos
    world[FOOD, old_food_pos] = false
    world[EMPTY, old_food_pos] = true

    for i in 1:length(body)
        pos = DS.dequeue!(body)
        world[BODY, pos] = false
        world[EMPTY, pos] = true
    end

    new_food_pos = rand(rng, pos -> world[EMPTY, pos], env)
    env.food_pos = new_food_pos
    world[FOOD, new_food_pos] = true
    world[EMPTY, new_food_pos] = false

    agent_start_pos = rand(rng, pos -> world[EMPTY, pos], env)
    world[BODY, agent_start_pos] = true
    world[EMPTY, agent_start_pos] = false
    DS.enqueue!(body, agent_start_pos)
    agent_start_dir = get_agent_start_dir(env)

    set_agent_pos!(env, agent_start_pos)
    set_agent_dir!(env, agent_start_dir)

    set_reward!(env, 0.0)
    env.terminated = false

    return env
end
