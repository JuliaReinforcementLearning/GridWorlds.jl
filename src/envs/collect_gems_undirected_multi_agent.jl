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

const ESC = Char(0x1B)

function Base.show(io::IO, ::MIME"text/plain", env::CollectGemsUndirectedMultiAgent)
    height = GW.get_height(env)
    width = GW.get_width(env)
    num_agents = get_num_agents(env)

    for i in 1:height
        for j in 1:width
            pos = CartesianIndex(i, j)
            background, foreground, char = GW.get_render_data(env.world, pos)
            print(io, Crayons.Crayon(background = background, foreground = foreground, bold = true, reset = true), char, Crayons.Crayon(reset = true))
        end

        println(io)
    end

    for i in 1:num_agents
        agent = NumberedAgent{i}()
        println(io, "player $i = ", Crayons.Crayon(foreground = get_color(agent), bold = true, reset = true), get_char(agent), Crayons.Crayon(reset = true))
    end
    println(io, "current_player_id = ", env.current_player_id)
    println(io, "$(typeof(env))")
    println(io, "reward = ", env.reward)
    println(io, "done = ", env.done)

    return nothing
end

open_maybe(file_name::AbstractString) = open(file_name, "w")
open_maybe(::Nothing) = nothing

close_maybe(io::IO) = close(io)
close_maybe(io::Nothing) = nothing

write_maybe(io::IO, content) = write(io, content)
write_maybe(io::Nothing, content) = 0
write_io1_maybe_io2(io1::IO, io2::Union{Nothing, IO}, content) = write(io1, content) + write_maybe(io2, content)

show_maybe(io::IO, mime::MIME, content) = show(io, mime, content)
show_maybe(io::Nothing, mime::MIME, content) = nothing
function show_io1_maybe_io2(io1::IO, io2::Union{Nothing, IO}, mime::MIME, content)
    show(io1, mime, content)
    show_maybe(io2, mime, content)
end

get_string_hide_cursor() = ESC * "[?25l"
get_string_show_cursor() = ESC * "[?25h"
get_string_clear_screen() = ESC * "[2J"
get_string_move_cursor_to_origin() = ESC * "[H"
get_string_clear_screen_before_cursor() = ESC * "[1J"
get_string_empty_screen() = get_string_clear_screen_before_cursor() * get_string_move_cursor_to_origin()
get_string_key_bindings(env::CollectGemsUndirectedMultiAgent) = """Key bindings:
                                                                'q': quit
                                                                'r': RLBase.reset!(env)
                                                                'w': env(MOVE_UP)
                                                                's': env(MOVE_DOWN)
                                                                'a': env(MOVE_LEFT)
                                                                'd': env(MOVE_RIGHT)
                                                                """

function play!(terminal::REPL.Terminals.UnixTerminal, env::CollectGemsUndirectedMultiAgent; file_name::Union{Nothing, AbstractString} = nothing)
    REPL.Terminals.raw!(terminal, true)

    terminal_out = terminal.out_stream
    terminal_in = terminal.in_stream
    file = open_maybe(file_name)

    write_io1_maybe_io2(terminal_out, file, get_string_clear_screen())
    write_io1_maybe_io2(terminal_out, file, get_string_move_cursor_to_origin())
    write_io1_maybe_io2(terminal_out, file, get_string_hide_cursor())

    try
        while true
            write_io1_maybe_io2(terminal_out, file, get_string_key_bindings(env))
            show_io1_maybe_io2(terminal_out, file, MIME("text/plain"), env)

            char = read(terminal_in, Char)

            write_io1_maybe_io2(terminal_out, file, get_string_empty_screen())

            if char == 'q'
                write_io1_maybe_io2(terminal_out, file, get_string_show_cursor())
                close_maybe(file)
                REPL.Terminals.raw!(terminal, false)
                return nothing
            elseif char == 'r'
                RLBase.reset!(env)
            elseif char == 'w'
                env(GW.MOVE_UP)
            elseif char == 's'
                env(GW.MOVE_DOWN)
            elseif char == 'a'
                env(GW.MOVE_LEFT)
            elseif char == 'd'
                env(GW.MOVE_RIGHT)
            else
                @warn "No keybinding exists for $char"
            end

            write_io1_maybe_io2(terminal_out, file, "Last character read = " * char * "\n")
        end
    finally
        write_io1_maybe_io2(terminal_out, file, get_string_show_cursor())
        close_maybe(file)
        REPL.Terminals.raw!(terminal, false)
    end

    return nothing
end

play!(env::CollectGemsUndirectedMultiAgent; file_name = nothing) = play!(REPL.TerminalMenus.terminal, env, file_name = file_name)

function replay(terminal::REPL.Terminals.UnixTerminal, file_name::AbstractString, frame_rate)
    terminal_out = terminal.out_stream
    delimiter = get_string_empty_screen()
    frames = split(read(file_name, String), delimiter)
    for frame in frames
        write(terminal_out, frame)
        sleep(1 / frame_rate)
        write(terminal_out, delimiter)
    end

    return nothing
end

replay(file_name; frame_rate = 2) = replay(REPL.TerminalMenus.terminal, file_name, frame_rate)
