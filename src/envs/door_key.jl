mutable struct DoorKeyDirected{T, R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Agent, Wall, Goal, Door, Key}}
    agent_pos::CartesianIndex{2}
    agent_dir::AbstractDirection
    reward::T
    rng::R
    terminal_reward::T
    goal_pos::CartesianIndex{2}
    door_pos::CartesianIndex{2}
    key_pos::CartesianIndex{2}
    partition::CartesianIndices{2,Tuple{UnitRange{Int},UnitRange{Int}}}
    has_key::Bool
    done::Bool
end

@generate_getters(DoorKeyDirected)
@generate_setters(DoorKeyDirected)

mutable struct DoorKeyUndirected{T, R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Agent, Wall, Goal, Door, Key}}
    agent_pos::CartesianIndex{2}
    reward::T
    rng::R
    terminal_reward::T
    goal_pos::CartesianIndex{2}
    door_pos::CartesianIndex{2}
    key_pos::CartesianIndex{2}
    partition::CartesianIndices{2,Tuple{UnitRange{Int},UnitRange{Int}}}
    has_key::Bool
    done::Bool
end

@generate_getters(DoorKeyUndirected)
@generate_setters(DoorKeyUndirected)

#####
# Directed
#####

function DoorKeyDirected(; T = Float32, height = 8, width = 8, rng = Random.GLOBAL_RNG)
    objects = (AGENT, WALL, GOAL, DOOR, KEY)
    world = GridWorldBase(objects, height, width)

    room = Room(CartesianIndex(1, 1), height, width)
    place_room!(world, room)

    goal_pos = CartesianIndex(height - 1, width - 1)
    world[GOAL, goal_pos] = true

    agent_pos = CartesianIndex(2, 2)
    world[AGENT, agent_pos] = true

    door_pos = CartesianIndex(2, 3)
    world[DOOR, door_pos] = true

    partition = CartesianIndices((2:height-1, door_pos[2]:door_pos[2]))
    world[WALL, partition] .= true
    world[WALL, door_pos] = false

    key_pos = CartesianIndex(3, 2)
    world[KEY, key_pos] = true

    agent_dir = RIGHT
    reward = zero(T)
    terminal_reward = one(T)
    has_key = false
    done = false

    env = DoorKeyDirected(world, agent_pos, agent_dir, reward, rng, terminal_reward, goal_pos, door_pos, key_pos, partition, has_key, done)

    RLBase.reset!(env)

    return env
end

RLBase.state_space(env::DoorKeyDirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = nothing
const DOOR_KEY_DIRECTED_LAYERS = SA.SVector(2, 3, 4, 5)
RLBase.state(env::DoorKeyDirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = get_grid(get_world(env), get_agent_pos(env), get_agent_dir(env), get_half_size(env), DOOR_KEY_DIRECTED_LAYERS)

RLBase.state_space(env::DoorKeyDirected, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = nothing
RLBase.state(env::DoorKeyDirected, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = (copy(get_grid(env)), get_agent_dir(env))

RLBase.action_space(env::DoorKeyDirected, ::RLBase.DefaultPlayer) = (DIRECTED_NAVIGATION_ACTIONS..., PICK_UP)
RLBase.reward(env::DoorKeyDirected, ::RLBase.DefaultPlayer) = get_reward(env)
RLBase.is_terminated(env::DoorKeyDirected) = get_done(env)

function RLBase.reset!(env::DoorKeyDirected{T}) where {T}
    world = get_world(env)
    height = get_height(env)
    width = get_width(env)
    rng = get_rng(env)

    world[AGENT, get_agent_pos(env)] = false
    world[WALL, get_partition(env)] .= false
    world[GOAL, get_goal_pos(env)] = false
    world[DOOR, get_door_pos(env)] = false
    world[KEY, get_key_pos(env)] = false

    new_door_pos, new_partition, region1, region2 = generate_partition(rng, height, width)
    region1, region2 = Random.shuffle(SA.SVector(region1, region2))

    set_door_pos!(env, new_door_pos)
    world[DOOR, new_door_pos] = true

    set_partition!(env, new_partition)
    world[WALL, new_partition] .= true
    world[WALL, new_door_pos] = false

    new_goal_pos = rand(rng, pos -> !any(@view world[:, pos]), region2)
    set_goal_pos!(env, new_goal_pos)
    world[GOAL, new_goal_pos] = true

    new_key_pos = rand(rng, pos -> !any(@view world[:, pos]), region1)
    set_key_pos!(env, new_key_pos)
    world[KEY, new_key_pos] = true

    new_agent_pos = rand(rng, pos -> !any(@view world[:, pos]), region1)
    set_agent_pos!(env, new_agent_pos)
    world[AGENT, new_agent_pos] = true

    set_agent_dir!(env, rand(rng, DIRECTIONS))

    set_reward!(env, zero(T))
    set_has_key!(env, false)
    set_done!(env, false)

    return nothing
end

function (env::DoorKeyDirected{T})(action::AbstractTurnAction) where {T}
    new_dir = turn(action, get_agent_dir(env))
    set_agent_dir!(env, new_dir)
    world = get_world(env)

    if world[GOAL, get_agent_pos(env)]
        set_done!(env, true)
        set_reward!(env, get_terminal_reward(env))
    else
        set_done!(env, false)
        set_reward!(env, zero(T))
    end

    return nothing
end

function (env::DoorKeyDirected{T})(action::AbstractMoveAction) where {T}
    world = get_world(env)

    agent_pos = get_agent_pos(env)
    dest = move(action, get_agent_dir(env), agent_pos)
    if !(world[DOOR, dest] || world[WALL, dest]) || (world[DOOR, dest] && get_has_key(env))
        world[AGENT, agent_pos] = false
        set_agent_pos!(env, dest)
        world[AGENT, dest] = true
    end

    if world[GOAL, get_agent_pos(env)]
        set_done!(env, true)
        set_reward!(env, get_terminal_reward(env))
    else
        set_done!(env, false)
        set_reward!(env, zero(T))
    end

    return nothing
end

#####
# Undirected
#####

function DoorKeyUndirected(; T = Float32, height = 8, width = 8, rng = Random.GLOBAL_RNG)
    objects = (AGENT, WALL, GOAL, DOOR, KEY)
    world = GridWorldBase(objects, height, width)

    room = Room(CartesianIndex(1, 1), height, width)
    place_room!(world, room)

    goal_pos = CartesianIndex(height - 1, width - 1)
    world[GOAL, goal_pos] = true

    agent_pos = CartesianIndex(2, 2)
    world[AGENT, agent_pos] = true

    door_pos = CartesianIndex(2, 3)
    world[DOOR, door_pos] = true

    partition = CartesianIndices((2:height-1, door_pos[2]:door_pos[2]))
    world[WALL, partition] .= true
    world[WALL, door_pos] = false

    key_pos = CartesianIndex(3, 2)
    world[KEY, key_pos] = true

    reward = zero(T)
    terminal_reward = one(T)
    has_key = false
    done = false

    env = DoorKeyUndirected(world, agent_pos, reward, rng, terminal_reward, goal_pos, door_pos, key_pos, partition, has_key, done)

    RLBase.reset!(env)

    return env
end

RLBase.state_space(env::DoorKeyUndirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = nothing
const DOOR_KEY_UNDIRECTED_LAYERS = SA.SVector(2, 3, 4, 5)
RLBase.state(env::DoorKeyUndirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = get_grid(get_world(env), get_agent_pos(env), get_half_size(env), DOOR_KEY_UNDIRECTED_LAYERS)

RLBase.state_space(env::DoorKeyUndirected, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = nothing
RLBase.state(env::DoorKeyUndirected, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = copy(get_grid(env))

RLBase.action_space(env::DoorKeyUndirected, player::RLBase.DefaultPlayer) = (UNDIRECTED_NAVIGATION_ACTIONS..., PICK_UP)
RLBase.reward(env::DoorKeyUndirected, ::RLBase.DefaultPlayer) = get_reward(env)
RLBase.is_terminated(env::DoorKeyUndirected) = get_done(env)

function RLBase.reset!(env::DoorKeyUndirected{T}) where {T}
    world = get_world(env)
    height = get_height(env)
    width = get_width(env)
    rng = get_rng(env)

    world[AGENT, get_agent_pos(env)] = false
    world[WALL, get_partition(env)] .= false
    world[GOAL, get_goal_pos(env)] = false
    world[DOOR, get_door_pos(env)] = false
    world[KEY, get_key_pos(env)] = false

    new_door_pos, new_partition, region1, region2 = generate_partition(rng, height, width)
    region1, region2 = Random.shuffle(SA.SVector(region1, region2))

    set_door_pos!(env, new_door_pos)
    world[DOOR, new_door_pos] = true

    set_partition!(env, new_partition)
    world[WALL, new_partition] .= true
    world[WALL, new_door_pos] = false

    new_goal_pos = rand(rng, pos -> !any(@view world[:, pos]), region2)
    set_goal_pos!(env, new_goal_pos)
    world[GOAL, new_goal_pos] = true

    new_key_pos = rand(rng, pos -> !any(@view world[:, pos]), region1)
    set_key_pos!(env, new_key_pos)
    world[KEY, new_key_pos] = true

    new_agent_pos = rand(rng, pos -> !any(@view world[:, pos]), region1)
    set_agent_pos!(env, new_agent_pos)
    world[AGENT, new_agent_pos] = true

    set_reward!(env, zero(T))
    set_has_key!(env, false)
    set_done!(env, false)

    return nothing
end

function (env::DoorKeyUndirected{T})(action::AbstractMoveAction) where {T}
    world = get_world(env)

    agent_pos = get_agent_pos(env)
    dest = move(action, agent_pos)
    if !(world[DOOR, dest] || world[WALL, dest]) || (world[DOOR, dest] && get_has_key(env))
        world[AGENT, agent_pos] = false
        set_agent_pos!(env, dest)
        world[AGENT, dest] = true
    end

    if world[GOAL, get_agent_pos(env)]
        set_done!(env, true)
        set_reward!(env, get_terminal_reward(env))
    else
        set_done!(env, false)
        set_reward!(env, zero(T))
    end

    return nothing
end

#####
# Common
#####

function generate_partition(rng, height, width)
    if rand(rng) < 0.5
        # vertical partition
        door_pos = rand(rng, CartesianIndices((2:height-1, 3:width-2)))
        partition = CartesianIndices((2:height-1, door_pos[2]:door_pos[2]))
        region1 = CartesianIndices((2:height-1, 2:door_pos[2]-1))
        region2 = CartesianIndices((2:height-1, door_pos[2]+1:width-1))
        return door_pos, partition, region1, region2
    else
        # horizontal partition
        door_pos = rand(rng, CartesianIndices((3:height-2, 2:width-1)))
        partition = CartesianIndices((door_pos[1]:door_pos[1], 2:width-1))
        region1 = CartesianIndices((2:door_pos[1]-1, 2:width-1))
        region2 = CartesianIndices((door_pos[1]+1:height-1, 2:width-1))
        return door_pos, partition, region1, region2
    end
end

function (env::Union{DoorKeyDirected{T}, DoorKeyUndirected{T}})(::PickUp) where {T}
    world = get_world(env)
    agent_pos = get_agent_pos(env)

    if world[KEY, agent_pos]
        set_has_key!(env, true)
        world[KEY, agent_pos] = false
    end

    if world[GOAL, get_agent_pos(env)]
        set_done!(env, true)
        set_reward!(env, get_terminal_reward(env))
    else
        set_done!(env, false)
        set_reward!(env, zero(T))
    end

    return nothing
end
