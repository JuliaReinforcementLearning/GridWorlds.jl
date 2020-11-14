export EmptyGridWorld

mutable struct EmptyGridWorld <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty,Wall,Goal}}
    agent_pos::CartesianIndex{2}
    agent::Agent
    goal_reward::Float64
    reward::Float64
end

function EmptyGridWorld(;n=8, agent_start_pos=CartesianIndex(2,2), agent_start_dir=RIGHT, goal_pos = CartesianIndex(n-1, n-1))
    objects = (EMPTY, WALL, GOAL)
    w = GridWorldBase(objects, n, n)

    w[WALL, [1,n], 1:n] .= true
    w[WALL, 1:n, [1,n]] .= true
    goal_reward = 1.0
    reward = 0.0

    env = EmptyGridWorld(w, agent_start_pos, Agent(dir=agent_start_dir), goal_reward, reward)

    reset!(env, agent_start_pos = agent_start_pos, agent_start_dir = agent_start_dir, goal_pos = goal_pos)

    return env

end

function (w::EmptyGridWorld)(::MoveForward)
    dir = get_dir(w.agent)
    dest = dir(w.agent_pos)
    w.reward = 0.0
    if !w.world[WALL, dest]
        w.agent_pos = dest
        if w.world[GOAL, w.agent_pos]
            w.reward = w.goal_reward
        end
    end
    w
end

function (w::EmptyGridWorld)(action::Union{TurnRight, TurnLeft})
    w.reward = 0.0
    agent = get_agent(w)
    set_dir!(agent, action(get_dir(agent)))
    w
end

RLBase.get_terminal(w::EmptyGridWorld) = w.world[GOAL, w.agent_pos]

RLBase.get_reward(w::EmptyGridWorld) = w.reward

function RLBase.reset!(w::EmptyGridWorld; agent_start_pos = CartesianIndex(2, 2), agent_start_dir = RIGHT, goal_pos = CartesianIndex(size(w.world)[end] - 1, size(w.world)[end] - 1))

    w.reward = 0.0
    w.agent_pos = agent_start_pos
    w.agent.dir = agent_start_dir

    w.world[EMPTY, :, :] .= .!w.world[WALL, :, :]
    w.world[GOAL, goal_pos] = true
    w.world[EMPTY, goal_pos] = false

    return w
end
