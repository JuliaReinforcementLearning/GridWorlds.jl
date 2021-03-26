mutable struct Snake{T, R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Agent, Wall, Body, Food}}
    agent_pos::CartesianIndex{2}
    reward::T
    rng::R
    body::DS.Queue{CartesianIndex{2}}
    food_reward::T
    food_pos::CartesianIndex{2}
    terminal_reward::T
    terminal_penalty::T
    done::Bool
end

@generate_getters(Snake)
@generate_setters(Snake)

function Snake(; T = Float32, height = 8, width = 8, rng = Random.GLOBAL_RNG)
    objects = (AGENT, WALL, BODY, FOOD)
    world = GridWorldBase(objects, height, width)

    room = Room(CartesianIndex(1, 1), height, width)
    place_room!(world, room)

    food_pos = CartesianIndex(height - 1, width - 1)
    world[FOOD, food_pos] = true

    agent_pos = CartesianIndex(2, 2)
    world[AGENT, agent_pos] = true

    body = DS.Queue{CartesianIndex{2}}()
    DS.enqueue!(body, agent_pos)
    world[BODY, agent_pos] = true

    reward = zero(T)
    food_reward = one(T)
    terminal_reward = convert(T, height * width)
    terminal_penalty = convert(T, -height * width)
    done = false

    env = Snake(world, agent_pos, reward, rng, body, food_reward, food_pos, terminal_reward, terminal_penalty, done)

    RLBase.reset!(env)

    return env
end

RLBase.state_space(env::Snake, ::RLBase.Observation, ::RLBase.DefaultPlayer) = nothing
const SNAKE_LAYERS = SA.SVector(2, 3, 4)
RLBase.state(env::Snake, ::RLBase.Observation, ::RLBase.DefaultPlayer) = get_grid(get_world(env), get_agent_pos(env), get_half_size(env), SNAKE_LAYERS)

RLBase.action_space(env::Snake, player::RLBase.DefaultPlayer) = UNDIRECTED_NAVIGATION_ACTIONS
RLBase.reward(env::Snake, ::RLBase.DefaultPlayer) = get_reward(env)
RLBase.is_terminated(env::Snake) = get_done(env)

function RLBase.reset!(env::Snake{T}) where {T}
    world = get_world(env)
    rng = get_rng(env)
    body = get_body(env)

    world[AGENT, get_agent_pos(env)] = false
    world[FOOD, get_food_pos(env)] = false

    for i in 1:length(body)
        pos = DS.dequeue!(body)
        world[BODY, pos] = false
    end

    new_food_pos = rand(rng, pos -> !any(@view world[:, pos]), env)
    set_food_pos!(env, new_food_pos)
    world[FOOD, new_food_pos] = true

    new_agent_pos = rand(rng, pos -> !any(@view world[:, pos]), env)
    set_agent_pos!(env, new_agent_pos)
    world[AGENT, new_agent_pos] = true

    DS.enqueue!(body, new_agent_pos)
    world[BODY, new_agent_pos] = true

    set_reward!(env, zero(T))
    set_done!(env, false)

    return nothing
end

function (env::Snake{T})(action::AbstractMoveAction) where {T}
    world = get_world(env)
    height = get_height(env)
    width = get_width(env)
    rng = get_rng(env)
    body = get_body(env)

    agent_pos = get_agent_pos(env)
    dest = move(action, agent_pos)

    if (world[WALL, dest] || world[BODY, dest])
        set_reward!(env, get_terminal_penalty(env))
        set_done!(env, true)
    elseif world[FOOD, dest]
        world[AGENT, agent_pos] = false
        set_agent_pos!(env, dest)
        world[AGENT, dest] = true

        DS.enqueue!(body, dest)
        world[BODY, dest] = true

        world[FOOD, dest] = false

        if length(body) == (height - 2) * (width - 2)
            set_reward!(env, get_food_reward(env) + get_terminal_reward(env))
            set_done!(env, true)
        else
            new_food_pos = rand(rng, pos -> !any(@view world[:, pos]), env, max_try = 100 * height * width)
            set_food_pos!(env, new_food_pos)
            world[FOOD, new_food_pos] = true

            set_reward!(env, get_food_reward(env))
            set_done!(env, false)
        end
    else
        world[AGENT, agent_pos] = false
        set_agent_pos!(env, dest)
        world[AGENT, dest] = true

        DS.enqueue!(body, dest)
        world[BODY, dest] = true

        last_pos = DS.dequeue!(body)
        world[BODY, last_pos] = false

        set_reward!(env, zero(T))
        set_done!(env, false)
    end

    return nothing
end
