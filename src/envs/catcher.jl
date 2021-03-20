mutable struct Catcher{T, R} <: AbstractGridWorld
    world::GridWorldBase{Tuple{Agent, Ball}}
    agent_pos::CartesianIndex{2}
    reward::T
    rng::R
    terminal_reward::T
    ball_reward::T
    ball_pos::CartesianIndex{2}
    done::Bool
end

@generate_getters(Catcher)
@generate_setters(Catcher)

function Catcher(; T = Float32, height = 8, width = 8, rng = Random.GLOBAL_RNG)
    objects = (AGENT, BALL)
    world = GridWorldBase(objects, height, width)

    ball_pos = CartesianIndex(1, 1)
    world[BALL, ball_pos] = true

    agent_pos = CartesianIndex(height, 1)
    world[AGENT, agent_pos] = true

    reward = zero(T)
    terminal_reward = -one(T)
    ball_reward = one(T)
    done = false

    env = Catcher(world, agent_pos, reward, rng, terminal_reward, ball_reward, ball_pos, done)

    RLBase.reset!(env)

    return env
end

RLBase.StateStyle(env::Catcher) = RLBase.InternalState{Any}()

RLBase.state_space(env::Catcher, ::RLBase.Observation, ::RLBase.DefaultPlayer) = nothing
const CATCHER_LAYERS = SA.SVector(1)
RLBase.state(env::Catcher, ::RLBase.Observation, ::RLBase.DefaultPlayer) = get_grid(get_world(env), get_agent_pos(env), get_half_size(env), CATCHER_LAYERS)

RLBase.state_space(env::Catcher, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = nothing
RLBase.state(env::Catcher, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = copy(get_grid(env))

RLBase.action_space(env::Catcher, player::RLBase.DefaultPlayer) = (MOVE_LEFT, MOVE_RIGHT, NO_MOVE)
RLBase.reward(env::Catcher, ::RLBase.DefaultPlayer) = get_reward(env)
RLBase.is_terminated(env::Catcher) = get_done(env)

function RLBase.reset!(env::Catcher{T}) where {T}
    world = get_world(env)
    rng = get_rng(env)
    height = get_height(env)
    width = get_width(env)

    world[AGENT, get_agent_pos(env)] = false
    world[BALL, get_ball_pos(env)] = false

    new_ball_pos = CartesianIndex(1, rand(rng, 1:width))
    set_ball_pos!(env, new_ball_pos)
    world[BALL, new_ball_pos] = true

    agent_start_pos = CartesianIndex(height, rand(rng, 1:width))
    world[AGENT, agent_start_pos] = true
    set_agent_pos!(env, agent_start_pos)

    set_reward!(env, zero(T))
    set_done!(env, false)

    return nothing
end

function (env::Catcher{T})(action::Union{MoveLeft, MoveRight, NoMove}) where {T}
    world = get_world(env)
    height = get_height(env)

    old_agent_pos = get_agent_pos(env)
    world[AGENT, old_agent_pos] = false
    new_agent_pos = wrap_agent(env, move(action, old_agent_pos))
    set_agent_pos!(env, new_agent_pos)
    world[AGENT, new_agent_pos] = true

    old_ball_pos = get_ball_pos(env)
    world[BALL, old_ball_pos] = false
    new_ball_pos = wrap_ball(env, move(DOWN, old_ball_pos))
    set_ball_pos!(env, new_ball_pos)
    world[BALL, new_ball_pos] = true

    if new_ball_pos[1] == height
        if new_ball_pos[2] == new_agent_pos[2]
            set_done!(env, false)
            set_reward!(env, env.ball_reward)
        else
            set_done!(env, true)
            set_reward!(env, get_terminal_reward(env))
        end
    else
        set_done!(env, false)
        set_reward!(env, zero(T))
    end

    return nothing
end

function wrap_ball(env::Catcher, pos::CartesianIndex{2})
    height = get_height(env)
    width = get_width(env)
    rng = get_rng(env)
    i = pos[1]

    if i > height
        return CartesianIndex(1, rand(rng, 1:width))
    else
        return pos
    end
end

function wrap_agent(env::Catcher, pos::CartesianIndex{2})
    height = get_height(env)
    width = get_width(env)
    i = pos[1]
    j = pos[2]

    if j < 1
        return CartesianIndex(i, width)
    elseif j > width
        return CartesianIndex(i, 1)
    else
        return pos
    end
end
