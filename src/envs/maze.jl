mutable struct MazeDirected{T, R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty, Wall, Goal}}
    agent_pos::CartesianIndex{2}
    agent_dir::AbstractDirection
    reward::T
    rng::R
    terminal_reward::T
    goal_pos::CartesianIndex{2}
    done::Bool
end

mutable struct MazeUndirected{T, R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty, Wall, Goal}}
    agent_pos::CartesianIndex{2}
    reward::T
    rng::R
    terminal_reward::T
    goal_pos::CartesianIndex{2}
    done::Bool
end

#####
# Directed
#####

"""
Maze generation uses the iterative implementation of randomized depth-first search from [Wikipedia](https://en.wikipedia.org/wiki/Maze_generation_algorithm#Iterative_implementation).
"""
function MazeDirected(; T = Float32, height = 9, width = 9, rng = Random.GLOBAL_RNG)
    @assert isodd(height) && isodd(width) "height and width must be odd numbers"
    vertical_range = 2:2:height-1
    horizontal_range = 2:2:width-1

    objects = (EMPTY, WALL, GOAL)
    world = GridWorldBase(objects, height, width)

    world[WALL, :, :] .= true
    for i in vertical_range, j in horizontal_range
        world[WALL, i, j] = false
        world[EMPTY, i, j] = true
    end

    goal_pos = CartesianIndex(height - 1, width - 1)
    world[GOAL, goal_pos] = true
    world[EMPTY, goal_pos] = false

    agent_pos = CartesianIndex(2, 2)
    agent_dir = RIGHT
    reward = zero(T)
    terminal_reward = one(T)
    done = false

    env = MazeDirected(world, agent_pos, agent_dir, reward, rng, terminal_reward, goal_pos, done)

    RLBase.reset!(env)

    return env
end

RLBase.state_space(env::MazeDirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = nothing
RLBase.state(env::MazeDirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = get_agent_view(env)
RLBase.action_space(env::MazeDirected, ::RLBase.DefaultPlayer) = DIRECTED_NAVIGATION_ACTIONS
RLBase.reward(env::MazeDirected, ::RLBase.DefaultPlayer) = get_reward(env)
RLBase.is_terminated(env::MazeDirected) = get_done(env)

function RLBase.reset!(env::MazeDirected{T}) where {T}
    world = get_world(env)
    rng = get_rng(env)
    height = get_height(env)
    width = get_width(env)

    vertical_range = 2:2:height-1
    horizontal_range = 2:2:width-1

    old_goal_pos = get_goal_pos(env)
    world[GOAL, old_goal_pos] = false
    world[EMPTY, old_goal_pos] = true

    world[WALL, :, :] .= true
    world[EMPTY, :, :] .= false
    for i in vertical_range, j in horizontal_range
        world[WALL, i, j] = false
        world[EMPTY, i, j] = true
    end

    generate_maze!(env)

    new_goal_pos = rand(rng, pos -> world[EMPTY, pos], env)

    set_goal_pos!(env, new_goal_pos)
    world[GOAL, new_goal_pos] = true
    world[EMPTY, new_goal_pos] = false

    agent_start_pos = rand(rng, pos -> world[EMPTY, pos], env)
    agent_start_dir = rand(rng, DIRECTIONS)

    set_agent_pos!(env, agent_start_pos)
    set_agent_dir!(env, agent_start_dir)

    set_reward!(env, zero(T))
    set_done!(env, false)

    return env
end

function (env::MazeDirected{T})(action::AbstractTurnAction) where {T}
    dir = get_agent_dir(env)
    new_dir = turn(action, dir)
    set_agent_dir!(env, new_dir)
    world = get_world(env)

    if world[GOAL, get_agent_pos(env)]
        set_done!(env, true)
        set_reward!(env, env.terminal_reward)
    else
        set_done!(env, false)
        set_reward!(env, zero(T))
    end

    return env
end

function (env::MazeDirected{T})(action::AbstractMoveAction) where {T}
    world = get_world(env)

    dest = move(action, get_agent_dir(env), get_agent_pos(env))
    if !world[WALL, dest]
        set_agent_pos!(env, dest)
    end

    if world[GOAL, get_agent_pos(env)]
        set_done!(env, true)
        set_reward!(env, env.terminal_reward)
    else
        set_done!(env, false)
        set_reward!(env, zero(T))
    end

    return env
end

#####
# Undirected
#####

"""
Maze generation uses the iterative implementation of randomized depth-first search from [Wikipedia](https://en.wikipedia.org/wiki/Maze_generation_algorithm#Iterative_implementation).
"""
function MazeUndirected(; T = Float32, height = 9, width = 9, rng = Random.GLOBAL_RNG)
    @assert isodd(height) && isodd(width) "height and width must be odd numbers"
    vertical_range = 2:2:height-1
    horizontal_range = 2:2:width-1

    objects = (EMPTY, WALL, GOAL)
    world = GridWorldBase(objects, height, width)

    world[WALL, :, :] .= true
    for i in vertical_range, j in horizontal_range
        world[WALL, i, j] = false
        world[EMPTY, i, j] = true
    end

    goal_pos = CartesianIndex(height - 1, width - 1)
    world[GOAL, goal_pos] = true
    world[EMPTY, goal_pos] = false

    agent_pos = CartesianIndex(2, 2)
    reward = zero(T)
    terminal_reward = one(T)
    done = false

    env = MazeUndirected(world, agent_pos, reward, rng, terminal_reward, goal_pos, done)

    RLBase.reset!(env)

    return env
end

RLBase.state_space(env::MazeUndirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = nothing
RLBase.state(env::MazeUndirected, ::RLBase.Observation, ::RLBase.DefaultPlayer) = get_grid(get_world(env), get_agent_view_size(env), get_agent_pos(env))
RLBase.action_space(env::MazeUndirected, player::RLBase.DefaultPlayer) = UNDIRECTED_NAVIGATION_ACTIONS
RLBase.reward(env::MazeUndirected, ::RLBase.DefaultPlayer) = get_reward(env)
RLBase.is_terminated(env::MazeUndirected) = get_done(env)

function RLBase.reset!(env::MazeUndirected{T}) where {T}
    world = get_world(env)
    rng = get_rng(env)
    height = get_height(env)
    width = get_width(env)

    vertical_range = 2:2:height-1
    horizontal_range = 2:2:width-1

    old_goal_pos = get_goal_pos(env)
    world[GOAL, old_goal_pos] = false
    world[EMPTY, old_goal_pos] = true

    world[WALL, :, :] .= true
    world[EMPTY, :, :] .= false
    for i in vertical_range, j in horizontal_range
        world[WALL, i, j] = false
        world[EMPTY, i, j] = true
    end

    generate_maze!(env)

    new_goal_pos = rand(rng, pos -> world[EMPTY, pos], env)

    set_goal_pos!(env, new_goal_pos)
    world[GOAL, new_goal_pos] = true
    world[EMPTY, new_goal_pos] = false

    agent_start_pos = rand(rng, pos -> world[EMPTY, pos], env)
    set_agent_pos!(env, agent_start_pos)

    set_reward!(env, zero(T))
    set_done!(env, false)

    return env
end

function (env::MazeUndirected{T})(action::AbstractMoveAction) where {T}
    world = get_world(env)

    dest = move(action, get_agent_pos(env))
    if !world[WALL, dest]
        set_agent_pos!(env, dest)
    end

    if world[GOAL, get_agent_pos(env)]
        set_done!(env, true)
        set_reward!(env, env.terminal_reward)
    else
        set_done!(env, false)
        set_reward!(env, zero(T))
    end

    return env
end

#####
# Common
#####

function get_candidate_neighbors(pos::CartesianIndex{2})
    shifts = ((-2, 0), (0, -2), (0, 2), (2, 0))
    return map(shift -> CartesianIndex(pos.I .+ shift), shifts)
end

function generate_maze!(env::Union{MazeDirected, MazeUndirected})
    world = get_world(env)
    rng = get_rng(env)
    height = get_height(env)
    width = get_width(env)

    vertical_range = 2:2:height-1
    horizontal_range = 2:2:width-1

    visited = falses(height, width)
    stack = DS.Stack{CartesianIndex{2}}()

    first_cell = CartesianIndex(rand(rng, vertical_range), rand(rng, horizontal_range))
    visited[first_cell] = true
    push!(stack, first_cell)

    while !isempty(stack)
        current_cell = pop!(stack)
        candidate_neighbors = get_candidate_neighbors(current_cell)
        neighbors = filter(pos -> (pos.I[1] in vertical_range) && (pos.I[2] in horizontal_range), candidate_neighbors)
        unvisited_neighbors = filter(pos -> !visited[pos], neighbors)
        if length(unvisited_neighbors) > 0
            push!(stack, current_cell)

            next_cell = rand(rng, unvisited_neighbors)

            mid_pos = CartesianIndex((current_cell.I .+ next_cell.I) .÷ 2)
            world[WALL, mid_pos] = false
            world[EMPTY, mid_pos] = true

            visited[next_cell] = true
            push!(stack, next_cell)
        end
    end

    return env
end
