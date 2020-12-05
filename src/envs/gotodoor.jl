export GoToDoor

mutable struct GoToDoor{W<:GridWorldBase, R} <: AbstractGridWorld
    world::W
    agent::Agent
    reward::Float64
    rng::R
    target::Door
    target_reward::Float64
    penalty::Float64
end

function GoToDoor(; n = 8, agent_start_pos = CartesianIndex(2,2), agent_start_dir = RIGHT, rng = Random.GLOBAL_RNG)
    doors = [Door(c) for c in COLORS[1:4]]
    objects = (EMPTY, WALL, doors...)
    world = GridWorldBase(objects, n, n)
    agent = Agent(dir = agent_start_dir, pos = agent_start_pos)
    reward = 0.0
    target = doors[1]
    target_reward = 1.0
    penalty = -1.0

    env = GoToDoor(world, agent, reward, rng, target, target_reward, penalty)

    reset!(env, agent_start_pos = agent_start_pos, agent_start_dir = agent_start_dir)

    return env
end

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
            set_reward!(env, env.target_reward)
        else
            set_reward!(env, env.penalty)
        end
    end

    return env
end

RLBase.get_state(env::GoToDoor) = (get_agent_view(env), env.target)

RLBase.get_terminal(env::GoToDoor) = any([get_world(env)[object, get_agent_pos(env)] for object in get_objects(env)[end-3:end]])

function RLBase.reset!(env::GoToDoor; agent_start_pos = CartesianIndex(2, 2), agent_start_dir = RIGHT)
    world = get_world(env)
    n = get_width(env)
    rng = get_rng(env)

    world[:, :, :] .= false
    world[WALL, [1,n], 1:n] .= true
    world[WALL, 1:n, [1,n]] .= true
    world[EMPTY, 2:n-1, 2:n-1] .= true
    
    doors = get_objects(env)[end-3:end]
    env.target = rand(rng, doors)

    door_pos = [CartesianIndex(rand(rng, 2:n-1), 1),
                CartesianIndex(rand(rng, 2:n-1), n),
                CartesianIndex(1, rand(rng, 2:n-1)),
                CartesianIndex(n, rand(rng, 2:n-1))]

    rp = randperm(rng, length(door_pos))

    for (door, pos) in zip(doors, door_pos[rp])
        world[door, pos] = true
        world[WALL, pos] = false
    end

    set_agent_pos!(env, agent_start_pos)
    set_agent_dir!(env, agent_start_dir)

    set_reward!(env, 0.0)

    return env
end
