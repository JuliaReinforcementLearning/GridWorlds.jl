export AbstractGridWorld
export get_world, get_grid, get_objects, get_height, get_width, get_agent, get_agent_pos, get_agent_dir, get_agent_view, get_agent_view!, get_full_view
export set_world!, set_agent!, set_agent_pos!, set_agent_dir!, set_reward!

abstract type AbstractGridWorld <: AbstractEnv end

#####
# useful getter and setter methods
#####

get_world(env::AbstractGridWorld) = env.world
set_world!(env::AbstractGridWorld, world::GridWorldBase) = env.world = world

get_grid(env::AbstractGridWorld, ::Val{:full_view}) = env |> get_world |> get_grid
get_grid(env::AbstractGridWorld, ::Val{:agent_view}) = get_agent_view(env)
get_grid(env::AbstractGridWorld; view_type::Symbol = :full_view) = get_grid(env, Val{view_type}())

get_objects(env::AbstractGridWorld) = env |> get_world |> get_objects

get_height(env::AbstractGridWorld) = size(get_world(env), 2)
get_width(env::AbstractGridWorld) = size(get_world(env), 3)

get_agent(env::AbstractGridWorld, ::Val{:full_view}) = env.agent
get_agent(env::AbstractGridWorld, ::Val{:agent_view}) = Agent(dir = DOWN)
get_agent(env::AbstractGridWorld; view_type::Symbol = :full_view) = get_agent(env, Val{view_type}())
set_agent!(env::AbstractGridWorld, agent::Agent) = env.agent = agent

get_agent_pos(env::AbstractGridWorld, ::Val{:full_view}) = env.agent_pos
get_agent_pos(env::AbstractGridWorld, ::Val{:agent_view}) = CartesianIndex(1, size(get_grid(env, Val{:agent_view}()), 3) ÷ 2 + 1)
get_agent_pos(env::AbstractGridWorld; view_type::Symbol = :full_view) = get_agent_pos(env, Val{view_type}())
set_agent_pos!(env::AbstractGridWorld, pos::CartesianIndex{2}) = env.agent_pos = pos

get_agent_dir(env::AbstractGridWorld, ::Val{:full_view}) = env |> get_agent |> get_dir
get_agent_dir(env::AbstractGridWorld, ::Val{:agent_view}) = DOWN
get_agent_dir(env::AbstractGridWorld; view_type::Symbol = :full_view) = get_agent_dir(env, Val{view_type}())
set_agent_dir!(env::AbstractGridWorld, dir::Direction) = set_dir!(get_agent(env), dir)

function get_agent_view(env::AbstractGridWorld, agent_view_size = (7,7))
    world = get_world(env)
    agent_view = BitArray{3}(undef, size(world, 1), agent_view_size...)
    fill!(agent_view, false)
    get_agent_view!(agent_view, env)
end

get_agent_view_inds(env::AbstractGridWorld, agent_view_size = (7,7)) = get_agent_view_inds(get_agent_pos(env).I, agent_view_size, get_agent_dir(env))

get_agent_view!(grid::BitArray{3}, env::AbstractGridWorld) = get_agent_view!(grid, get_world(env), get_agent_pos(env), get_agent_dir(env))

function get_agent_layer(grid::BitArray{3}, agent_pos::CartesianIndex{2})
    dims = size(grid)[2:end]
    agent_layer = falses(1, dims...)
    agent_layer[1, agent_pos] = true
    return agent_layer
end

function get_full_view(env::AbstractGridWorld)
    grid = get_grid(env)
    agent_layer = get_agent_layer(grid, get_agent_pos(env))
    return cat(agent_layer, grid, dims = 1)
end

set_reward!(env::AbstractGridWorld, reward) = env.reward = reward

#####
# RLBase API defaults
#####

RLBase.DefaultStateStyle(env::AbstractGridWorld) = RLBase.PartialObservation{Array}()

RLBase.get_state(env::AbstractGridWorld, ::RLBase.PartialObservation{Array}, args...) = get_agent_view(env)

RLBase.get_state(env::AbstractGridWorld, ::RLBase.Observation{Array}, args...) = (get_full_view(env), get_agent_dir(env))

RLBase.get_actions(env::AbstractGridWorld) = (MOVE_FORWARD, TURN_LEFT, TURN_RIGHT)

RLBase.get_reward(env::AbstractGridWorld) = env.reward

RLBase.get_terminal(env::AbstractGridWorld) = get_world(env)[GOAL, get_agent_pos(env)]

function (env::AbstractGridWorld)(action::Union{TurnRight, TurnLeft})
    set_reward!(env, 0.0)
    dir = get_agent_dir(env)
    set_agent_dir!(env, action(dir))
    return env
end

function (env::AbstractGridWorld)(::MoveForward)
    world = get_world(env)

    set_reward!(env, 0.0)

    dir = get_agent_dir(env)
    dest = dir(get_agent_pos(env))

    if !world[WALL, dest]
        set_agent_pos!(env, dest)
        if world[GOAL, get_agent_pos(env)]
            set_reward!(env, env.goal_reward)
        end
    end

    return env
end
