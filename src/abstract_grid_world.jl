export AbstractGridWorld
export get_objects, get_world, get_grid, get_agent, get_agent_pos, get_agent_dir, get_agent_view, get_full_view

abstract type AbstractGridWorld <: AbstractEnv end

#####
# useful getter methods
#####

get_world(env::AbstractGridWorld) = env.world

get_grid(env::AbstractGridWorld, ::Val{:full_view}) = env |> get_world |> get_grid
get_grid(env::AbstractGridWorld, ::Val{:agent_view}) = get_agent_view(env)
get_grid(env::AbstractGridWorld; view_type::Symbol = :full_view) = get_grid(env, Val{view_type}())

get_objects(env::AbstractGridWorld) = env |> get_world |> get_objects

get_height(env::AbstractGridWorld) = size(get_world(env), 2)
get_width(env::AbstractGridWorld) = size(get_world(env), 3)

get_agent(env::AbstractGridWorld, ::Val{:full_view}) = env.agent
get_agent(env::AbstractGridWorld, ::Val{:agent_view}) = Agent(dir = DOWN)
get_agent(env::AbstractGridWorld; view_type::Symbol = :full_view) = get_agent(env, Val{view_type}())

get_agent_pos(env::AbstractGridWorld, ::Val{:full_view}) = env.agent_pos
get_agent_pos(env::AbstractGridWorld, ::Val{:agent_view}) = CartesianIndex(1, size(get_grid(env, Val{:agent_view}()), 3) ÷ 2 + 1)
get_agent_pos(env::AbstractGridWorld; view_type::Symbol = :full_view) = get_agent_pos(env, Val{view_type}())

get_agent_dir(env::AbstractGridWorld, ::Val{:full_view}) = env |> get_agent |> get_dir
get_agent_dir(env::AbstractGridWorld, ::Val{:agent_view}) = DOWN
get_agent_dir(env::AbstractGridWorld; view_type::Symbol = :full_view) = get_agent_dir(env, Val{view_type}())

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

#####
# RLBase API defaults
#####

RLBase.DefaultStateStyle(env::AbstractGridWorld) = RLBase.PartialObservation{Array}()

RLBase.get_state(env::AbstractGridWorld, ::RLBase.PartialObservation{Array}, args...) = get_agent_view(env)

RLBase.get_state(env::AbstractGridWorld, ::RLBase.Observation{Array}, args...) = (get_full_view(env), get_agent_dir(env))

RLBase.get_actions(env::AbstractGridWorld) = (MOVE_FORWARD, TURN_LEFT, TURN_RIGHT)

RLBase.get_reward(env::AbstractGridWorld) = env.reward

function (env::AbstractGridWorld)(action::Union{TurnRight, TurnLeft})
    env.reward = 0.0
    agent = get_agent(env)
    set_dir!(agent, action(get_dir(agent)))
    env
end
