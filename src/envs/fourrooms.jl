export FourRooms

mutable struct FourRooms <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty,Wall,Goal}}
    agent_pos::CartesianIndex{2}
    agent::Agent
    goal_reward::Float64
    reward::Float64
end

function FourRooms(;n=9, agent_start_pos=CartesianIndex(2,2))
    objects = (EMPTY, WALL, GOAL)
    world = GridWorldBase(objects, n,n)
    world[EMPTY, 2:n-1, 2:n-1] .= true
    world[WALL, [1,n], 1:n] .= true
    world[WALL, 1:n, [1,n]] .= true
    world[WALL, ceil(Int,n/2), vcat(2:ceil(Int,n/4)-1,ceil(Int,n/4)+1:ceil(Int,n/2)-1,ceil(Int,n/2):ceil(Int,3*n/4)-1,ceil(Int,3*n/4)+1:n)] .= true
    world[EMPTY, ceil(Int,n/2), vcat(2:ceil(Int,n/4)-1,ceil(Int,n/4)+1:ceil(Int,n/2)-1,ceil(Int,n/2):ceil(Int,3*n/4)-1,ceil(Int,3*n/4)+1:n)] .= false
    world[WALL, vcat(2:ceil(Int,n/4)-1,ceil(Int,n/4)+1:ceil(Int,n/2)-1,ceil(Int,n/2):ceil(Int,3*n/4)-1,ceil(Int,3*n/4)+1:n), ceil(Int,n/2)] .= true
    world[EMPTY, vcat(2:ceil(Int,n/4)-1,ceil(Int,n/4)+1:ceil(Int,n/2)-1,ceil(Int,n/2):ceil(Int,3*n/4)-1,ceil(Int,3*n/4)+1:n), ceil(Int,n/2)] .= false
    world[GOAL, n-1, n-1] = true
    world[EMPTY, n-1, n-1] = false
    goal_reward = 1.0
    reward = 0.0
    FourRooms(world,agent_start_pos,Agent(dir=RIGHT), goal_reward, reward)
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

function RLBase.reset!(w::FourRooms)
    w.reward = 0.0
    w.agent_pos = CartesianIndex(2, 2)
    w.agent.dir = RIGHT
    return w
end
