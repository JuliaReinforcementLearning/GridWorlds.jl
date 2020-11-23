export get_agent_view, AbstractGridWorld
export get_actions
abstract type AbstractGridWorld <: AbstractEnv end

function get_agent_view end
function get_agent end

Base.convert(::Type{GridWorldBase}, env::AbstractGridWorld) = env.world
get_object(env::AbstractGridWorld) = get_object(convert(GridWorldBase, env))
get_object(env::AbstractGridWorld, x::Type{<:AbstractObject}) = filter(o -> o isa x, get_object(env))
get_object(env::AbstractGridWorld, x::Type{Agent}) = env.agent
get_pos(env::AbstractGridWorld, ::Type{Agent}) = env.agent_pos

get_agent(env::AbstractGridWorld) = get_object(env, Agent)
get_agent_pos(env::AbstractGridWorld) = get_pos(env, Agent)
get_agent_dir(env::AbstractGridWorld) = env |> get_agent |> get_dir

function get_agent_view(env::AbstractGridWorld, agent_view_size=(7,7))
    w = convert(GridWorldBase, env)
    v = BitArray{3}(undef, size(w, 1), agent_view_size...)
    fill!(v, false)
    get_agent_view!(v, env)
end

get_agent_view_inds(env::AbstractGridWorld, s=(7,7)) = get_agent_view_inds(get_agent_pos(env).I, s, get_agent_dir(env))

get_agent_view!(v::BitArray{3}, env::AbstractGridWorld) = get_agent_view!(v, convert(GridWorldBase, env), get_agent_pos(env), get_agent_dir(env))

#####
# RLBase defaults
#####

RLBase.DefaultStateStyle(env::AbstractGridWorld) = RLBase.PartialObservation{Array}()

RLBase.get_state(env::AbstractGridWorld, ::RLBase.PartialObservation{Array}, args...) = get_agent_view(env)

RLBase.get_actions(env::AbstractGridWorld) = (MOVE_FORWARD, TURN_LEFT, TURN_RIGHT)

RLBase.get_reward(env::AbstractGridWorld) = env.reward

function (env::AbstractGridWorld)(action::Union{TurnRight, TurnLeft})
    env.reward = 0.0
    agent = get_agent(env)
    set_dir!(agent, action(get_dir(agent)))
    env
end
