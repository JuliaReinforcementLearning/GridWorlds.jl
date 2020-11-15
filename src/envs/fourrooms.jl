export FourRooms

mutable struct FourRooms <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty,Wall,Goal}}
    agent_pos::CartesianIndex{2}
    agent::Agent
    goal_reward::Float64
    reward::Float64
end

function FourRooms(;n=9, agent_start_pos=CartesianIndex(2,2), agent_start_dir=RIGHT, goal_pos=CartesianIndex(n-1, n-1))
    objects = (EMPTY, WALL, GOAL)
    world = GridWorldBase(objects, n, n)

    world[WALL, [1,n], 1:n] .= true
    world[WALL, 1:n, [1,n]] .= true
    world[WALL, ceil(Int,n/2), vcat(2:ceil(Int,n/4)-1,ceil(Int,n/4)+1:ceil(Int,n/2)-1,ceil(Int,n/2):ceil(Int,3*n/4)-1,ceil(Int,3*n/4)+1:n)] .= true
    world[WALL, vcat(2:ceil(Int,n/4)-1,ceil(Int,n/4)+1:ceil(Int,n/2)-1,ceil(Int,n/2):ceil(Int,3*n/4)-1,ceil(Int,3*n/4)+1:n), ceil(Int,n/2)] .= true
    world[EMPTY, :, :] .= .!world[WALL, :, :]
    world[GOAL, goal_pos] = true
    world[EMPTY, goal_pos] = false

    goal_reward = 1.0
    reward = 0.0

    env = FourRooms(world,agent_start_pos,Agent(dir=RIGHT), goal_reward, reward)

    reset!(env, agent_start_pos = agent_start_pos, agent_start_dir = agent_start_dir, goal_pos = goal_pos)

    return env
end

function (w::FourRooms)(::MoveForward)
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

function (w::FourRooms)(action::Union{TurnRight, TurnLeft})
    w.reward = 0.0
    agent = get_agent(w)
    set_dir!(agent, action(get_dir(agent)))
    w
end

RLBase.get_terminal(w::FourRooms) = w.world[GOAL, w.agent_pos]

RLBase.get_reward(w::FourRooms) = w.reward

function RLBase.reset!(w::FourRooms; agent_start_pos = CartesianIndex(2, 2), agent_start_dir = RIGHT, goal_pos = CartesianIndex(size(w.world[end]) - 1, size(w.world)[end] - 1))
    n = size(w.world)[end]
    w.reward = 0.0
    w.agent_pos = agent_start_pos
    agent = get_agent(w)
    set_dir!(agent, agent_start_dir)

    w.world[GOAL, :, :] .= false
    w.world[GOAL, goal_pos] = true
    w.world[EMPTY, :, :] .= .!w.world[WALL, :, :]
    w.world[EMPTY, goal_pos] = false
    return w
end
