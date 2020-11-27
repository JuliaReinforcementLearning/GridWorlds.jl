export GoToDoor

using Random

mutable struct GoToDoor{W<:GridWorldBase, R} <: AbstractGridWorld
    world::W
    agent_pos::CartesianIndex{2}
    agent::Agent
    target::Door
    target_reward::Float64
    penalty::Float64
    reward::Float64
    rng::R
end

function GoToDoor(; n = 8, agent_start_pos = CartesianIndex(2,2), rng = Random.GLOBAL_RNG)
    doors = [Door(c) for c in COLORS[1:4]]
    objects = (EMPTY, WALL, doors...)

    world = GridWorldBase(objects, n, n)

    world[EMPTY, 2:n-1, 2:n-1] .= true

    target_reward = 1.0
    penalty = -1.0
    reward = 0.0

    env = GoToDoor(world, agent_start_pos, Agent(dir = RIGHT), doors[1], target_reward, penalty, reward, rng)

    reset!(env)

    return env
end

function (env::GoToDoor)(::MoveForward)
    world = get_world(env)
    agent = get_agent(env)

    env.reward = 0.0

    dir = get_dir(agent)
    dest = dir(get_agent_pos(env))

    if dest ∈ CartesianIndices((size(world, 2), size(world, 3))) && !world[WALL,dest]
        env.agent_pos = dest
        if get_terminal(env)
            if world[env.target, get_agent_pos(env)]
                env.reward = env.target_reward
            else
                env.reward = env.penalty
            end
        end
    end
    return env
end

RLBase.get_state(env::GoToDoor) = (get_agent_view(env), env.target)

RLBase.get_terminal(env::GoToDoor) = any([get_world(env)[x, env.agent_pos] for x in get_object(env)[end-3:end]])

function RLBase.reset!(env::GoToDoor)
    world = get_world(env)

    n = size(world)[end]

    world[WALL, [1,n], 1:n] .= true
    world[WALL, 1:n, [1,n]] .= true

    doors = get_object(env)[end-3:end]
    for door in doors
        world[door, :, :] .= false
    end

    env.target = rand(env.rng, doors)
    env.reward = 0.0

    door_pos = [CartesianIndex(rand(env.rng, 2:n-1),1),
                CartesianIndex(rand(env.rng, 2:n-1),n),
                CartesianIndex(1,rand(env.rng, 2:n-1)),
                CartesianIndex(n,rand(env.rng, 2:n-1))]

    rp = randperm(env.rng, length(door_pos))

    for (door, pos) in zip(doors, door_pos[rp])
        world[door, pos] = true
        world[WALL, pos] = false
    end

    return env
end
