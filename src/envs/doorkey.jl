export DoorKey

using Random

mutable struct DoorKey{W<:GridWorldBase, R} <: AbstractGridWorld
    world::W
    agent_pos::CartesianIndex{2}
    agent::Agent
    goal_reward::Float64
    reward::Float64
    rng::R
end

function DoorKey(;n = 7, agent_start_pos = CartesianIndex(2,2), agent_start_dir = RIGHT, goal_pos = CartesianIndex(n-1, n-1), rng = Random.GLOBAL_RNG)
    door = Door(:yellow)
    key = Key(:yellow)
    objects = (EMPTY, WALL, GOAL, door, key)
    world = GridWorldBase(objects, n, n)

    world[WALL, [1,n], 1:n] .= true
    world[WALL, 1:n, [1,n]] .= true
    world[GOAL, n-1, n-1] = true

    goal_reward = 1.0
    reward = 0.0

    env = DoorKey(world, agent_start_pos, Agent(;dir = agent_start_dir), goal_reward, reward, rng)

    reset!(env, agent_start_pos = agent_start_pos, agent_start_dir = agent_start_dir, goal_pos = goal_pos)

    return env
end

function (w::DoorKey)(::MoveForward)
    w.reward = 0.0
    door = w.world.objects[end - 1]
    key = w.world.objects[end]
    dir = get_dir(w.agent)
    dest = dir(w.agent_pos)

    if w.world[key, dest]
        if PICK_UP(w.agent, key)
            w.world[key, dest] = false
            w.world[EMPTY, dest] = true
        end
        w.agent_pos = dest
    elseif w.world[door, dest] && w.agent.inventory !== key
        nothing
    elseif w.world[door, dest] && w.agent.inventory === key
        w.agent_pos = dest
    elseif !w.world[WALL,dest]
        w.agent_pos = dest
        if w.world[GOAL, w.agent_pos]
            w.reward = w.goal_reward
        end
    end

    w
end

function (w::DoorKey)(action::Union{TurnRight, TurnLeft})
    w.reward = 0.0
    agent = get_agent(w)
    set_dir!(agent, action(get_dir(agent)))
    w
end

RLBase.get_reward(w::DoorKey) = w.reward

RLBase.get_terminal(w::DoorKey) = w.world[GOAL, w.agent_pos]

function RLBase.reset!(w::DoorKey; agent_start_pos = CartesianIndex(2, 2), agent_start_dir = RIGHT, goal_pos = CartesianIndex(size(w.world)[end] - 1, size(w.world)[end] - 1))
    n = size(w.world)[end]
    door = w.world.objects[end - 1]
    key = w.world.objects[end]
    w.reward = 0.0
    w.agent_pos = agent_start_pos
    agent = get_agent(w)
    set_dir!(agent, agent_start_dir)

    door_pos = CartesianIndex(rand(w.rng, 2:n-1), rand(w.rng, 3:n-2))
    @assert agent_start_pos[2] < door_pos[2] "Agent should start on the left side of the door"
    @assert goal_pos[2] > door_pos[2] "Goal should be placed on the right side of the door"
    w.world[WALL, :, door_pos[2]] .= true
    w.world[door, door_pos] = true
    w.world[WALL, door_pos] = false

    key_pos = CartesianIndex(rand(w.rng, 2:n-1), rand(w.rng, 2:door_pos[2]-1))
    while key_pos == agent_start_pos
        key_pos = CartesianIndex(rand(w.rng, 2:n-1), rand(w.rng, 2:door_pos[2]-1))
    end
    w.world[key, key_pos] = true

    w.world[EMPTY, :, :] .= .!(.|((w.world[x, :, :] for x in [WALL, GOAL, door, key])...))
end
