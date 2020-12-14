export GoToDoor

mutable struct GoToDoor{W<:GridWorldBase, R} <: AbstractGridWorld
    world::W
    agent::Agent
    reward::Float64
    rng::R
    door_pos::Dict{Door, CartesianIndex{2}}
    target::Door
    terminal_reward::Float64
    terminal_penalty::Float64
end

function GoToDoor(; height = 8, width = 8, rng = Random.GLOBAL_RNG)
    doors = [Door(c) for c in COLORS[1:4]]
    objects = (EMPTY, WALL, doors...)
    world = GridWorldBase(objects, height, width)
    room = Room(CartesianIndex(1, 1), height, width)
    place_room!(world, room)

    agent = Agent()
    reward = 0.0
    door_pos = Dict(zip(doors, generate_door_pos(rng, height, width)))
    for (door, pos) in door_pos
        world[door, pos] = true
        world[WALL, pos] = false
    end
    target = rand(rng, doors)
    terminal_reward = 1.0
    terminal_penalty = -1.0

    env = GoToDoor(world, agent, reward, rng, door_pos, target, terminal_reward, terminal_penalty)

    reset!(env)

    return env
end

RLBase.get_state(env::GoToDoor) = (get_agent_view(env), env.target)

RLBase.get_terminal(env::GoToDoor) = get_agent_pos(env) in values(env.door_pos)

function (env::GoToDoor)(::MoveForward)
    world = get_world(env)

    dir = get_agent_dir(env)
    dest = dir(get_agent_pos(env))
    if dest ∈ CartesianIndices((get_height(env), get_width(env))) && !world[WALL, dest]
        set_agent_pos!(env, dest)
    end

    set_reward!(env, 0.0)
    if get_terminal(env)
        if world[env.target, get_agent_pos(env)]
            set_reward!(env, env.terminal_reward)
        else
            set_reward!(env, env.terminal_penalty)
        end
    end

    return env
end

function RLBase.reset!(env::GoToDoor)
    world = get_world(env)
    height = get_height(env)
    width = get_width(env)
    rng = get_rng(env)

    for (door, pos) in env.door_pos
        world[door, pos] = false
        world[WALL, pos] = true
    end

    env.door_pos = Dict(zip(keys(env.door_pos), generate_door_pos(rng, height, width)))
    for (door, pos) in env.door_pos
        world[door, pos] = true
        world[WALL, pos] = false
    end

    env.target = rand(rng, keys(env.door_pos))

    agent_start_pos = rand(rng, pos -> world[EMPTY, pos], world)
    agent_start_dir = rand(rng, DIRECTIONS)

    set_agent_pos!(env, agent_start_pos)
    set_agent_dir!(env, agent_start_dir)

    set_reward!(env, 0.0)

    return env
end

function generate_door_pos(rng::AbstractRNG, height::Int, width::Int)
    door_pos = [CartesianIndex(rand(rng, 2:height-1), 1),
                CartesianIndex(rand(rng, 2:height-1), width),
                CartesianIndex(1, rand(rng, 2:width-1)),
                CartesianIndex(height, rand(rng, 2:width-1))]
    return shuffle(rng, door_pos)
end
