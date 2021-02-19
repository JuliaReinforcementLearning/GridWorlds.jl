export Transport

mutable struct Transport{R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty, Wall, Basket, Ball}}
    agent::Agent
    reward::Float64
    rng::R
    terminal_reward::Float64
    ball_pos::CartesianIndex{2}
    basket_pos::CartesianIndex{2}
end

function Transport(; height = 8, width = 8, rng = Random.GLOBAL_RNG)
    objects = (EMPTY, WALL, BASKET, BALL)
    world = GridWorldBase(objects, height, width)
    room = Room(CartesianIndex(1, 1), height, width)
    place_room!(world, room)

    ball_pos = CartesianIndex(2, 3)
    world[BALL, ball_pos] = true
    world[EMPTY, ball_pos] = false

    basket_pos = CartesianIndex(height - 1, width - 1)
    world[BASKET, basket_pos] = true
    world[EMPTY, basket_pos] = false

    agent = Agent()

    reward = 0.0
    terminal_reward = 1.0

    env = Transport(world, agent, reward, rng, terminal_reward, ball_pos, basket_pos)

    RLBase.reset!(env)

    return env
end

RLBase.is_terminated(env::Transport) = get_world(env)[BALL, env.basket_pos]
RLBase.action_space(env::Transport, ::RLBase.DefaultPlayer, ::DirectedNavigation) = (DIRECTED_NAVIGATION_ACTIONS..., PICK_UP, DROP)
RLBase.action_space(env::Transport, ::RLBase.DefaultPlayer, ::UndirectedNavigation) = (UNDIRECTED_NAVIGATION_ACTIONS..., PICK_UP, DROP)

function (env::Transport)(action::AbstractMoveAction)
    world = get_world(env)

    dest = move(action, get_agent_dir(env), get_agent_pos(env))
    if !world[WALL, dest]
        set_agent_pos!(env, dest)
    end

    set_reward!(env, 0.0)

    return env
end

function (env::Transport)(::PickUp)
    world = get_world(env)

    agent_pos = get_agent_pos(env)

    if world[BALL, agent_pos] && isnothing(get_inventory(env))
        world[BALL, agent_pos] = false
        set_inventory!(env, BALL)
        if !world[BASKET, agent_pos]
            world[EMPTY, agent_pos] = true
        end
    end

    set_reward!(env, 0.0)

    return env
end

function (env::Transport)(::Drop)
    world = get_world(env)

    agent_pos = get_agent_pos(env)

    set_reward!(env, 0.0)

    if !isnothing(get_inventory(env))
        env.ball_pos = agent_pos
        world[BALL, agent_pos] = true
        world[EMPTY, agent_pos] = false
        set_inventory!(env, nothing)

        if RLBase.is_terminated(env)
            set_reward!(env, env.terminal_reward)
        end
    end

    return env
end

function RLBase.reset!(env::Transport)
    world = get_world(env)
    rng = get_rng(env)

    old_ball_pos = env.ball_pos
    world[BALL, old_ball_pos] = false
    world[EMPTY, old_ball_pos] = true

    old_basket_pos = env.basket_pos
    world[BASKET, old_basket_pos] = false
    world[EMPTY, old_basket_pos] = true

    new_ball_pos = rand(rng, pos -> world[EMPTY, pos], env)
    env.ball_pos = new_ball_pos
    world[BALL, new_ball_pos] = true
    world[EMPTY, new_ball_pos] = false

    new_basket_pos = rand(rng, pos -> world[EMPTY, pos], env)
    env.basket_pos = new_basket_pos
    world[BASKET, new_basket_pos] = true
    world[EMPTY, new_basket_pos] = false

    agent_start_pos = rand(rng, pos -> world[EMPTY, pos], env)
    agent_start_dir = get_agent_start_dir(env)

    set_agent_pos!(env, agent_start_pos)
    set_agent_dir!(env, agent_start_dir)
    set_inventory!(env, nothing)

    set_reward!(env, 0.0)

    return env
end
