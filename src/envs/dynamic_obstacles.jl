mutable struct DynamicObstaclesDirected{T, R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Agent, Wall, Obstacle, Goal}}
    agent_pos::CartesianIndex{2}
    agent_dir::AbstractDirection
    reward::T
    rng::R
    terminal_reward::T
    goal_pos::CartesianIndex{2}
    num_obstacles::Int
    obstacle_pos::Vector{CartesianIndex{2}}
    terminal_penalty::T
    done::Bool
end

@generate_getters(DynamicObstaclesDirected)
@generate_setters(DynamicObstaclesDirected)

mutable struct DynamicObstaclesUndirected{T, R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Agent, Wall, Obstacle, Goal}}
    agent_pos::CartesianIndex{2}
    reward::T
    rng::R
    terminal_reward::T
    goal_pos::CartesianIndex{2}
    num_obstacles::Int
    obstacle_pos::Vector{CartesianIndex{2}}
    terminal_penalty::T
    done::Bool
end

@generate_getters(DynamicObstaclesUndirected)
@generate_setters(DynamicObstaclesUndirected)

#####
# Directed
#####

function DynamicObstaclesDirected(; T = Float32, height = 8, width = 8, num_obstacles = floor(Int, sqrt(height * width) / 2), rng = Random.GLOBAL_RNG)
    objects = (AGENT, WALL, OBSTACLE, GOAL)
    world = GridWorldBase(objects, height, width)

    room = Room(CartesianIndex(1, 1), height, width)
    place_room!(world, room)

    goal_pos = CartesianIndex(height - 1, width - 1)
    world[GOAL, goal_pos] = true

    agent_pos = CartesianIndex(2, 2)
    world[AGENT, agent_pos] = true

    agent_dir = RIGHT
    reward = zero(T)
    terminal_reward = one(T)
    obstacle_pos = CartesianIndex{2}[]
    terminal_penalty = -one(T)
    done = false

    env = DynamicObstaclesDirected(world, agent_pos, agent_dir, reward, rng, terminal_reward, goal_pos, num_obstacles, obstacle_pos, terminal_penalty, done)

    RLBase.reset!(env)

    return env
end

RLBase.state_space(env::DynamicObstaclesDirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = nothing
RLBase.state(env::DynamicObstaclesDirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = get_agent_view(env)

RLBase.state_space(env::DynamicObstaclesDirected, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = nothing
RLBase.state(env::DynamicObstaclesDirected, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = (get_grid(env), get_agent_dir(env))

RLBase.action_space(env::DynamicObstaclesDirected, ::RLBase.DefaultPlayer) = DIRECTED_NAVIGATION_ACTIONS
RLBase.reward(env::DynamicObstaclesDirected, ::RLBase.DefaultPlayer) = get_reward(env)
RLBase.is_terminated(env::DynamicObstaclesDirected) = get_done(env)

function RLBase.reset!(env::DynamicObstaclesDirected{T}) where {T}
    world = get_world(env)
    rng = get_rng(env)

    for pos in env.obstacle_pos
        world[OBSTACLE, pos] = false
    end

    world[AGENT, get_agent_pos(env)] = false
    world[GOAL, get_goal_pos(env)] = false

    new_goal_pos = rand(rng, pos -> !any(@view world[:, pos]), env)
    set_goal_pos!(env, new_goal_pos)
    world[GOAL, new_goal_pos] = true

    env.obstacle_pos = CartesianIndex{2}[]

    for i in 1:env.num_obstacles
        pos = rand(rng, pos -> !any(@view world[:, pos]), env)
        world[OBSTACLE, pos] = true
        push!(env.obstacle_pos, pos)
    end

    agent_start_pos = rand(rng, pos -> !any(@view world[:, pos]), env)
    set_agent_pos!(env, agent_start_pos)
    world[AGENT, agent_start_pos] = true

    set_agent_dir!(env, rand(rng, DIRECTIONS))

    set_reward!(env, zero(T))
    set_done!(env, false)

    return env
end

function (env::DynamicObstaclesDirected{T})(action::AbstractTurnAction) where {T}
    world = get_world(env)
    update_obstacles!(env)

    new_dir = turn(action, get_agent_dir(env))
    set_agent_dir!(env, new_dir)

    if world[GOAL, get_agent_pos(env)]
        set_done!(env, true)
        set_reward!(env, get_terminal_reward(env))
    elseif iscollision(env)
        set_done!(env, true)
        set_reward!(env, get_terminal_penalty(env))
    else
        set_done!(env, false)
        set_reward!(env, zero(T))
    end

    return env
end

function (env::DynamicObstaclesDirected{T})(action::AbstractMoveAction) where {T}
    world = get_world(env)
    update_obstacles!(env)

    agent_pos = get_agent_pos(env)
    dest = move(action, get_agent_dir(env), agent_pos)
    if !world[WALL, dest]
        world[AGENT, agent_pos] = false
        set_agent_pos!(env, dest)
        world[AGENT, dest] = true
    end

    if world[GOAL, get_agent_pos(env)]
        set_done!(env, true)
        set_reward!(env, get_terminal_reward(env))
    elseif iscollision(env)
        set_done!(env, true)
        set_reward!(env, get_terminal_penalty(env))
    else
        set_done!(env, false)
        set_reward!(env, zero(T))
    end

    return env
end

#####
# Undirected
#####

function DynamicObstaclesUndirected(; T = Float32, height = 8, width = 8, num_obstacles = floor(Int, sqrt(height * width) / 2), rng = Random.GLOBAL_RNG)
    objects = (AGENT, WALL, OBSTACLE, GOAL)
    world = GridWorldBase(objects, height, width)

    room = Room(CartesianIndex(1, 1), height, width)
    place_room!(world, room)

    goal_pos = CartesianIndex(height - 1, width - 1)
    world[GOAL, goal_pos] = true

    agent_pos = CartesianIndex(2, 2)
    world[AGENT, agent_pos] = true

    reward = zero(T)
    terminal_reward = one(T)
    obstacle_pos = CartesianIndex{2}[]
    terminal_penalty = -one(T)
    done = false

    env = DynamicObstaclesUndirected(world, agent_pos, reward, rng, terminal_reward, goal_pos, num_obstacles, obstacle_pos, terminal_penalty, done)

    RLBase.reset!(env)

    return env
end

RLBase.state_space(env::DynamicObstaclesUndirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = nothing
RLBase.state(env::DynamicObstaclesUndirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = get_grid(get_world(env), get_agent_view_size(env), get_agent_pos(env))

RLBase.state_space(env::DynamicObstaclesUndirected, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = nothing
RLBase.state(env::DynamicObstaclesUndirected, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = get_grid(env)

RLBase.action_space(env::DynamicObstaclesUndirected, player::RLBase.DefaultPlayer) = UNDIRECTED_NAVIGATION_ACTIONS
RLBase.reward(env::DynamicObstaclesUndirected, ::RLBase.DefaultPlayer) = get_reward(env)
RLBase.is_terminated(env::DynamicObstaclesUndirected) = get_done(env)

function RLBase.reset!(env::DynamicObstaclesUndirected{T}) where {T}
    world = get_world(env)
    rng = get_rng(env)

    for pos in env.obstacle_pos
        world[OBSTACLE, pos] = false
    end

    world[AGENT, get_agent_pos(env)] = false
    world[GOAL, get_goal_pos(env)] = false

    new_goal_pos = rand(rng, pos -> !any(@view world[:, pos]), env)
    set_goal_pos!(env, new_goal_pos)
    world[GOAL, new_goal_pos] = true

    env.obstacle_pos = CartesianIndex{2}[]

    for i in 1:env.num_obstacles
        pos = rand(rng, pos -> !any(@view world[:, pos]), env)
        world[OBSTACLE, pos] = true
        push!(env.obstacle_pos, pos)
    end

    agent_start_pos = rand(rng, pos -> !any(@view world[:, pos]), env)
    set_agent_pos!(env, agent_start_pos)
    world[AGENT, agent_start_pos] = true

    set_reward!(env, zero(T))
    set_done!(env, false)

    return env
end

function (env::DynamicObstaclesUndirected{T})(action::AbstractMoveAction) where {T}
    world = get_world(env)
    update_obstacles!(env)

    agent_pos = get_agent_pos(env)
    dest = move(action, agent_pos)
    if !world[WALL, dest]
        world[AGENT, agent_pos] = false
        set_agent_pos!(env, dest)
        world[AGENT, dest] = true
    end

    if world[GOAL, get_agent_pos(env)]
        set_done!(env, true)
        set_reward!(env, get_terminal_reward(env))
    elseif iscollision(env)
        set_done!(env, true)
        set_reward!(env, get_terminal_penalty(env))
    else
        set_done!(env, false)
        set_reward!(env, zero(T))
    end

    return env
end

#####
# Common
#####

iscollision(env::Union{DynamicObstaclesDirected, DynamicObstaclesUndirected}) = get_world(env)[OBSTACLE, get_agent_pos(env)]

function valid_obstacle_dest(env::Union{DynamicObstaclesDirected, DynamicObstaclesUndirected}, pos::CartesianIndex{2})
    world = get_world(env)
    shifts = (-1, 0, 1)
    candidate_pos = [CartesianIndex(pos[1] + i, pos[2] + j) for i in shifts for j in shifts]
    return filter(p -> (!any(@view world[:, p]) || p == pos), candidate_pos)
end

function update_obstacles!(env::Union{DynamicObstaclesDirected, DynamicObstaclesUndirected})
    world = get_world(env)
    rng = get_rng(env)
    for (i, pos) in enumerate(env.obstacle_pos)
        world[OBSTACLE, pos] = false
        new_pos = rand(rng, valid_obstacle_dest(env, pos))
        env.obstacle_pos[i] = new_pos
        world[OBSTACLE, new_pos] = true
    end
    
    return env
end
