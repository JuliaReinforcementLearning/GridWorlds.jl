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

function GoToDoor(;n=8, agent_start_pos=CartesianIndex(2,2), rng=Random.GLOBAL_RNG)
    doors = [Door(c) for c in COLORS[1:4]]
    objects = (EMPTY, WALL, doors...)

    world = GridWorldBase(objects, n, n)

    world[EMPTY, 2:n-1, 2:n-1] .= true

    target_reward = 1.0
    penalty = -1.0
    reward = 0.0

    env = GoToDoor(world, agent_start_pos, Agent(dir=RIGHT), doors[begin], target_reward, penalty, reward, rng)

    reset!(env)

    return env
end

function (env::GoToDoor)(::MoveForward)
    env.reward = 0.0
    dir = get_dir(env.agent)
    dest = dir(env.agent_pos)
    if dest ∈ CartesianIndices((size(env.world, 2), size(env.world, 3))) && !env.world[WALL,dest]
        env.agent_pos = dest
        if get_terminal(env)
            if env.world[env.target, env.agent_pos]
                env.reward = env.target_reward
            else
                env.reward = env.penalty
            end
        end
    end
    env
end

RLBase.get_state(env::GoToDoor) = (get_agent_view(env), env.target)

RLBase.get_terminal(env::GoToDoor) = any([env.world[x, env.agent_pos] for x in env.world.objects[end-3:end]])

function RLBase.reset!(env::GoToDoor)
    n = size(env.world)[end]

    env.world[WALL, [1,n], 1:n] .= true
    env.world[WALL, 1:n, [1,n]] .= true

    doors = env.world.objects[end-3:end]
    for door in doors
        env.world[door, :, :] .= false
    end

    env.target = rand(env.rng, doors)
    env.reward = 0.0

    door_pos = [CartesianIndex(rand(env.rng, 2:n-1),1),
                CartesianIndex(rand(env.rng, 2:n-1),n),
                CartesianIndex(1,rand(env.rng, 2:n-1)),
                CartesianIndex(n,rand(env.rng, 2:n-1))]

    rp = randperm(env.rng, length(door_pos))

    for (door, pos) in zip(doors, door_pos[rp])
        env.world[door, pos] = true
        env.world[WALL, pos] = false
    end

    env
end
