export EmptyGridWorld

mutable struct EmptyGridWorld <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty,Wall,Goal}}
    agent_pos::CartesianIndex{2}
    agent::Agent
    reward::Float64
end

function EmptyGridWorld(;n=8, agent_start_pos=CartesianIndex(2,2), agent_start_dir=RIGHT)
    objects = (EMPTY, WALL, GOAL)
    w = GridWorldBase(objects, n, n)
    w[EMPTY, 2:n-1, 2:n-1] .= true
    w[WALL, [1,n], 1:n] .= true
    w[WALL, 1:n, [1,n]] .= true
    w[GOAL, n-1, n-1] = true
    w[EMPTY, n-1, n-1] = false
    reward = 0.0
    EmptyGridWorld(w, agent_start_pos, Agent(dir=agent_start_dir), reward)
end

function (w::EmptyGridWorld)(::MoveForward)
    dir = get_dir(w.agent)
    dest = dir(w.agent_pos)
    w.reward = 0.0
    if !w.world[WALL, dest]
        w.agent_pos = dest
        if w.world[GOAL, w.agent_pos]
            w.reward = 1.0
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
