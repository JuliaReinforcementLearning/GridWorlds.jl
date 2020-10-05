export EmptyGridWorld

mutable struct EmptyGridWorld <: AbstractGridWorld
    world::GridWorldBase{Tuple{Agent, Empty, Wall, Goal}}
    agent_pos::CartesianIndex{2}
    agent::Agent
end

function EmptyGridWorld(;n=8, agent_start_pos=CartesianIndex(2,2), agent_start_dir=RIGHT)
    agent = Agent(dir=agent_start_dir)
    objects = (agent, EMPTY, WALL, GOAL)
    w = GridWorldBase(objects, n, n)

    w[EMPTY, 2:n-1, 2:n-1] .= true
    w[WALL, [1,n], 1:n] .= true
    w[WALL, 1:n, [1,n]] .= true

    w[agent, agent_start_pos] = true
    w[EMPTY, agent_start_pos] = false

    w[GOAL, n-1, n-1] = true
    w[EMPTY, n-1, n-1] = false

    EmptyGridWorld(w, agent_start_pos, agent)
end

function (w::EmptyGridWorld)(::MoveForward)
    dir = get_dir(w.agent)
    dest = dir(w.agent_pos)
    if !w.world[WALL, dest]
        w.world[w.agent, w.agent_pos] = false
        if !any(w.world[:, w.agent_pos])
            w.world[EMPTY, w.agent_pos] = true
        end
        w.agent_pos = dest
        w.world[w.agent, w.agent_pos] = true
        w.world[EMPTY, w.agent_pos] = false
    end
    w
end
