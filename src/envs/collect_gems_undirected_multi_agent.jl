struct NumberedAgent{N} <: AbstractObject end

const COLORS = (:red, :green, :yellow, :blue)
get_char(::NumberedAgent) = '☻'
get_color(::NumberedAgent{N}) where {N} = COLORS[1 + mod(N, length(COLORS))]

mutable struct CollectGemsUndirectedMultiAgent{T, R, N, O} <: AbstractGridWorld
    world::GridWorldBase{O}
    agent_pos::Vector{CartesianIndex{2}}
    current_player_id::Int
    reward::T
    rng::R
    num_gem_init::Int
    num_gem_current::Int
    gem_reward::T
    gem_pos_init::Vector{CartesianIndex{2}}
    done::Bool
end

@generate_getters(CollectGemsUndirectedMultiAgent)
@generate_setters(CollectGemsUndirectedMultiAgent)
get_num_agents(::CollectGemsUndirectedMultiAgent{T, R, N}) where {T, R, N} = N

RLBase.StateStyle(::CollectGemsUndirectedMultiAgent) = RLBase.InternalState{Any}()
RLBase.state_space(env::CollectGemsUndirectedMultiAgent, ::RLBase.InternalState) = nothing
RLBase.state(env::CollectGemsUndirectedMultiAgent, ::RLBase.InternalState) = copy(get_grid(env))

RLBase.action_space(env::CollectGemsUndirectedMultiAgent) = UNDIRECTED_NAVIGATION_ACTIONS
RLBase.reward(env::CollectGemsUndirectedMultiAgent) = get_reward(env)
RLBase.is_terminated(env::CollectGemsUndirectedMultiAgent) = get_done(env)

RLBase.current_player(env::CollectGemsUndirectedMultiAgent) = NumberedAgent{env.current_player_id}()
RLBase.players(env::CollectGemsUndirectedMultiAgent{T, R, N}) where {T, R, N} = Tuple(NumberedAgent{i}() for i in 1:N)
RLBase.NumAgentStyle(env::CollectGemsUndirectedMultiAgent{T, R, N}) where {T, R, N} = RLBase.MultiAgent(N)

function CollectGemsUndirectedMultiAgent(; T = Float32, num_agents = 4, height = 8, width = 8, num_gem_init = floor(Int, sqrt(height * width)), rng = Random.GLOBAL_RNG)
    objects = (Tuple(NumberedAgent{i}() for i in 1:num_agents)..., WALL, GEM)
    world = GridWorldBase(objects, height, width)

    room = Room(CartesianIndex(1, 1), height, width)
    place_room!(world, room)

    agent_pos = fill(CartesianIndex(1, 1), (num_agents,))
    current_player_id = 1

    reward = zero(T)
    num_gem_current = num_gem_init
    gem_reward = one(T)
    gem_pos_init = fill(CartesianIndex(1, 1), (num_gem_init,))
    done = false

    env = CollectGemsUndirectedMultiAgent{T, typeof(rng), num_agents, typeof(objects)}(world, agent_pos, current_player_id, reward, rng, num_gem_init, num_gem_current, gem_reward, gem_pos_init, done)

    RLBase.reset!(env)

    return env
end

function RLBase.reset!(env::CollectGemsUndirectedMultiAgent{T}) where {T}
    world = get_world(env)
    height = get_height(world)
    width = get_width(world)
    rng = get_rng(env)
    agent_pos = get_agent_pos(env)
    num_agents = length(agent_pos)
    gem_pos_init = get_gem_pos_init(env)
    num_gem_init = get_num_gem_init(env)

    for (i, pos) in enumerate(agent_pos)
        world[NumberedAgent{i}(), pos] = false
    end

    for pos in gem_pos_init
        world[GEM, pos] = false
    end

    ii = Random.randperm(height - 2)[1:num_agents] .+ 1
    jj = Random.randperm(width - 2)[1:num_agents] .+ 1
    for k in 1:num_agents
        i = ii[k]
        j = jj[k]
        agent_pos[k] = CartesianIndex(i, j)
        world[NumberedAgent{k}(), i, j] = true
    end

    empty!(gem_pos_init)

    for i in 1:num_gem_init
        pos = rand(rng, pos -> !any(@view world[:, pos]), env)
        world[GEM, pos] = true
        push!(gem_pos_init, pos)
    end
    set_num_gem_current!(env, num_gem_init)

    current_player_id = 1
    set_reward!(env, zero(T))
    set_done!(env, false)

    return nothing
end

function (env::CollectGemsUndirectedMultiAgent{T, R, N})(action::AbstractMoveAction) where {T, R, N}
    world = get_world(env)

    current_player_id = get_current_player_id(env)

    agent_pos = get_agent_pos(env)
    current_agent_pos = agent_pos[current_player_id]
    current_agent = NumberedAgent{current_player_id}()

    dest = move(action, current_agent_pos)
    if !(world[WALL, dest] || any(world[1:N, dest]))
        world[current_agent, current_agent_pos] = false
        agent_pos[current_player_id] = dest
        world[current_agent, dest] = true
    end

    set_reward!(env, zero(T))
    current_agent_pos = agent_pos[current_player_id]
    if world[GEM, current_agent_pos]
        world[GEM, current_agent_pos] = false
        set_num_gem_current!(env, get_num_gem_current(env) - 1)
        set_reward!(env, get_gem_reward(env))
    end

    if env.current_player_id == N
        set_current_player_id!(env, 1)
    else
        set_current_player_id!(env, env.current_player_id + 1)
    end
    set_done!(env, get_num_gem_current(env) <= 0)

    return nothing
end

#####
##### play
#####

function Base.show(io::IO, ::MIME"text/plain", env::CollectGemsUndirectedMultiAgent)
    height = GW.get_height(env)
    width = GW.get_width(env)

    for i in 1:height
        for j in 1:width
            pos = CartesianIndex(i, j)
            background, foreground, char = GW.get_render_data(env.world, pos)
            print(io, Crayons.Crayon(background = background, foreground = foreground, bold = true, reset = true), char, Crayons.Crayon(reset = true))
        end

        println(io)
    end

    return nothing
end

function play_repl!(terminal::REPL.Terminals.UnixTerminal, env::CollectGemsUndirectedMultiAgent{T, R, N}) where {T, R, N}

    raw_mode_enabled = try
        REPL.Terminals.raw!(terminal, true)
        true
    catch err
        @warn("Unable to enter raw mode: $err")
        false
    end

    REPL.Terminals.clear(terminal)

    print(terminal.out_stream, "\x1b[?25l") # hide cursor

    try
        while true

            println(terminal.out_stream, "$(typeof(env))")
            println(terminal.out_stream,
                    """Key bindings:
                    'q': quit
                    'r': RLBase.reset!(env)
                    'w': env(MOVE_UP)
                    's': env(MOVE_DOWN)
                    'a': env(MOVE_LEFT)
                    'd': env(MOVE_RIGHT)
                    """,
                   )
            for i in 1:N
                agent = NumberedAgent{i}()
                println(terminal.out_stream, "player $i = ", Crayons.Crayon(foreground = get_color(agent), bold = true, reset = true), get_char(agent), Crayons.Crayon(reset = true))
            end
            show(terminal.out_stream, MIME("text/plain"), env)
            println(terminal.out_stream, "reward = ", RLBase.reward(env))
            println(terminal.out_stream, "done = ", RLBase.is_terminated(env))
            println(terminal.out_stream, "current_player_id = ", env.current_player_id)

            c = read(terminal.in_stream, Char)

            REPL.Terminals.clear(terminal)

            if c == 'q'
                if raw_mode_enabled
                    print(terminal.out_stream, "\x1b[?25h") # unhide cursor
                    REPL.Terminals.raw!(terminal, false)
                end
                return nothing
            elseif c == 'r'
                RLBase.reset!(env)
            elseif c == 'w'
                env(MOVE_UP)
            elseif c == 's'
                env(MOVE_DOWN)
            elseif c == 'a'
                env(MOVE_LEFT)
            elseif c == 'd'
                env(MOVE_RIGHT)
            else
                println(terminal.out_stream, "You pressed $c. No keybinding exists for this key.")
            end
        end
    finally # always disable raw mode
        if raw_mode_enabled
            print(terminal.out_stream, "\x1b[?25h") # unhide cursor
            REPL.Terminals.raw!(terminal, false)
        end
    end

    return nothing
end

play_repl!(env::CollectGemsUndirectedMultiAgent) = play_repl!(REPL.TerminalMenus.terminal, env)
