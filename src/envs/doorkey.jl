export DoorKey

using Random

mutable struct DoorKey{W<:GridWorldBase} <: AbstractGridWorld
    world::W
    agent_pos::CartesianIndex{2}
    agent::Agent
    has_key::Bool
end

function DoorKey(;n=8, agent_start_pos=CartesianIndex(2,2), rng=Random.GLOBAL_RNG)
    objects = (EMPTY, WALL, GOAL, Door(:yellow), Key(:yellow))
    world = GridWorldBase(objects, n, n)
    world[EMPTY, 2:n-1, 2:n-1] .= true
    world[WALL, [1,n], 1:n] .= true
    world[WALL, 1:n, [1,n]] .= true
    world[EMPTY, n-1, n-1] = false
    world[GOAL, n-1, n-1] = true

    split_idx = rand(3:n-2)
    world[WALL, 1:n, split_idx] .= true
    world[EMPTY, 1:n, split_idx] .= false
    door_idx = rand(2:n-1)
    world[Door(:yellow), door_idx, split_idx] = true
    world[WALL, door_idx, split_idx] = false

    key_pos = CartesianIndex(rand(2:n-2), rand(2:split_idx-1))
    if key_pos == CartesianIndex(2,2)
        key_pos = CartesianIndex(3,2)
    end
    world[EMPTY, key_pos] = false
    world[Key(:yellow), key_pos] = true

    DoorKey(world, agent_start_pos, Agent(dir=RIGHT),false)
end

function (w::DoorKey)(::MoveForward)
    dir = get_dir(w.agent)
    dest = dir(w.agent_pos)

    if w.world[Key(:yellow), dest]
        w.has_key = true
        w.world[Key(:yellow), dest] = false
        w.world[EMPTY, dest] = true
        w.agent_pos = dest
    elseif w.world[Door(:yellow), dest] && w.has_key
        w.agent_pos = dest
    elseif w.world[Door(:yellow), dest] && !w.has_key
        nothing
    elseif dest ∈ CartesianIndices((size(w.world, 2), size(w.world, 3))) && !w.world[WALL,dest]
        w.agent_pos = dest
    end

    w
end
