export DoorKey

using Random

mutable struct DoorKey{W<:GridWorldBase} <: AbstractGridWorld
    world::W
    agent_pos::CartesianIndex{2}
    agent::Agent
end

function DoorKey(;n=7, agent_start_pos=CartesianIndex(2,2), rng=Random.GLOBAL_RNG)
    door = Door(:yellow)
    key = Key(:yellow)
    objects = (EMPTY, WALL, GOAL, door, key)
    world = GridWorldBase(objects, n, n)

    world[WALL, [1,n], 1:n] .= true
    world[WALL, 1:n, [1,n]] .= true
    world[GOAL, n-1, n-1] = true

    door_pos = CartesianIndex(rand(rng, 2:n-1), (n + 1) ÷ 2)
    world[WALL, :, door_pos[2]] .= true
    world[door, door_pos] = true
    world[WALL, door_pos] = false

    key_pos = CartesianIndex(rand(rng, 2:n-1), rand(rng, 2:door_pos[2]-1))
    while key_pos == agent_start_pos
        key_pos = CartesianIndex(rand(rng, 2:n-1), rand(rng, 2:door_pos[2]-1))
    end
    world[key, key_pos] = true

    world[EMPTY, :, :] .= .!(.|((world[x, :, :] for x in [WALL, GOAL, door, key])...))

    DoorKey(world, agent_start_pos, Agent(;dir=RIGHT))
end

function (w::DoorKey)(::MoveForward)
    dir = get_dir(w.agent)
    dest = dir(w.agent_pos)

    if w.world[Key(:yellow), dest]
        if PICK_UP(w.agent, Key(:yellow))
            w.world[Key(:yellow), dest] = false
            w.world[EMPTY, dest] = true
        end
        w.agent_pos = dest
    elseif w.world[Door(:yellow), dest] && w.agent.inventory !== Key(:yellow)
        nothing
    elseif w.world[Door(:yellow), dest] && w.agent.inventory === Key(:yellow)
        w.agent_pos = dest
    elseif dest ∈ CartesianIndices((size(w.world, 2), size(w.world, 3))) && !w.world[WALL,dest]
        w.agent_pos = dest
    end

    w
end
