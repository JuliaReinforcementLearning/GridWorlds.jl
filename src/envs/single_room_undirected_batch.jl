module ModuleSingleRoomUndirectedBatch

import Crayons
import ..GridWorlds as GW
import ..Play
import Random
import REPL
import ReinforcementLearningBase as RLBase
import StatsBase as SB

const MOVE_UP = 1
const MOVE_DOWN = 2
const MOVE_LEFT = 3
const MOVE_RIGHT = 4

const AGENT = 1
const WALL = 2
const GOAL = 3

const DUMMY_CHARACTER = '⋅'
const CHARACTERS = ('☻', '█', '♥')
const FOREGROUND_COLORS = (:light_red, :white, :light_red)

function move(action::Integer, i, j)
    if action == MOVE_UP
        return i - 1, j
    elseif action == MOVE_DOWN
        return i + 1, j
    elseif action == MOVE_LEFT
        return i, j - 1
    elseif action == MOVE_RIGHT
        return i, j + 1
    end
end

struct SingleRoomUndirectedBatch{I, R, RNG} <: GW.AbstractGridWorld
    tile_map::BitArray{4}
    agent_position::Array{I, 2}
    reward::Array{R, 1}
    rng::Array{RNG, 1}
    done::BitArray{1}
    terminal_reward::R
    goal_position::Array{I, 2}
end

function SingleRoomUndirectedBatch(; I = Int32, R = Float32, num_envs = 2, height = 8, width = 8, rng = [Random.MersenneTwister() for i in 1:num_envs])
    tile_map = BitArray(undef, num_envs, 3, height, width)
    agent_position = Array{I}(undef, num_envs, 2)
    reward = Array{R}(undef, num_envs)
    done = BitArray(undef, num_envs)
    goal_position = Array{I}(undef, num_envs, 2)
    terminal_reward = one(R)

    inner_area = CartesianIndices((2 : height - 1, 2 : width - 1))

    for env_id in 1:num_envs
        tile_map[env_id, :, :, :] .= false
        tile_map[env_id, WALL, 1, :] .= true
        tile_map[env_id, WALL, height, :] .= true
        tile_map[env_id, WALL, :, 1] .= true
        tile_map[env_id, WALL, :, width] .= true

        random_positions = SB.sample(rng[env_id], inner_area, 2, replace = false)

        agent_position[env_id, 1] = random_positions[1][1]
        agent_position[env_id, 2] = random_positions[1][2]
        tile_map[env_id, AGENT, random_positions[1]] = true

        goal_position[env_id, 1] = random_positions[2][1]
        goal_position[env_id, 2] = random_positions[2][2]
        tile_map[env_id, GOAL, random_positions[2]] = true

        reward[env_id] = zero(R)
        done[env_id] = false
    end

    env = SingleRoomUndirectedBatch(tile_map, agent_position, reward, rng, done, terminal_reward, goal_position)

    RLBase.reset!(env, force = true)

    return env
end

RLBase.state_space(env::SingleRoomUndirectedBatch, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = nothing
RLBase.state(env::SingleRoomUndirectedBatch, ::RLBase.InternalState, ::RLBase.DefaultPlayer) = copy(env.tile_map)

RLBase.action_space(env::SingleRoomUndirectedBatch, player::RLBase.DefaultPlayer) = (MOVE_UP, MOVE_DOWN, MOVE_LEFT, MOVE_RIGHT)
RLBase.reward(env::SingleRoomUndirectedBatch, ::RLBase.DefaultPlayer) = env.reward
RLBase.is_terminated(env::SingleRoomUndirectedBatch) = env.done

function RLBase.reset!(env::SingleRoomUndirectedBatch{I, R}; force = false) where {I, R}
    tile_map = env.tile_map
    agent_position = env.agent_position
    goal_position = env.goal_position
    reward = env.reward
    done = env.done
    rng = env.rng

    num_envs = size(tile_map, 1)
    inner_area = CartesianIndices((2 : size(tile_map, 3) - 1, 2 : size(tile_map, 4) - 1))

    for env_id in 1:num_envs
        if force || done[env_id]
            tile_map[env_id, AGENT, agent_position[env_id, 1], agent_position[env_id, 2]] = false
            tile_map[env_id, GOAL, goal_position[env_id, 1], goal_position[env_id, 2]] = false

            random_positions = SB.sample(rng[env_id], inner_area, 2, replace = false)

            agent_position[env_id, 1] = random_positions[1][1]
            agent_position[env_id, 2] = random_positions[1][2]
            tile_map[env_id, AGENT, random_positions[1]] = true

            goal_position[env_id, 1] = random_positions[2][1]
            goal_position[env_id, 2] = random_positions[2][2]
            tile_map[env_id, GOAL, random_positions[2]] = true

            reward[env_id] = zero(R)
            done[env_id] = false
        end
    end

    return nothing
end

function (env::SingleRoomUndirectedBatch{I, R})(action::Vector) where {I, R}
    tile_map = env.tile_map
    agent_position = env.agent_position
    goal_position = env.goal_position
    reward = env.reward
    done = env.done
    rng = env.rng
    terminal_reward = env.terminal_reward

    num_envs = size(tile_map, 1)

    for env_id in 1:num_envs
        current_position_i = agent_position[env_id, 1]
        current_position_j = agent_position[env_id, 2]
        next_position_i, next_position_j = move(action[env_id], current_position_i, current_position_j)

        if !tile_map[env_id, WALL, next_position_i, next_position_j]
            tile_map[env_id, AGENT, current_position_i, current_position_j] = false
            agent_position[env_id, 1] = next_position_i
            agent_position[env_id, 2] = next_position_j
            tile_map[env_id, AGENT, next_position_i, next_position_j] = true
        end

        new_current_position_i = agent_position[env_id, 1]
        new_current_position_j = agent_position[env_id, 2]

        if tile_map[env_id, GOAL, new_current_position_i, new_current_position_j]
            done[env_id] = true
            reward[env_id] = terminal_reward
        else
            done[env_id] = false
            reward[env_id] = zero(R)
        end
    end

    return nothing
end

function Base.show(io::IO, ::MIME"text/plain", env::SingleRoomUndirectedBatch)
    tile_map = env.tile_map
    reward = env.reward
    done = env.done

    num_envs, num_objects, height, width = size(tile_map)

    print(io, "objects = ")
    for i in 1 : length(CHARACTERS)
        print(io, Crayons.Crayon(foreground = FOREGROUND_COLORS[i]), CHARACTERS[i], Crayons.Crayon(reset = true))
        if i < length(CHARACTERS)
            print(io, ", ")
        else
            print(io, "\n")
        end
    end
    println(io, "dummy character = ", DUMMY_CHARACTER)

    for env_id in 1:num_envs
        println(io)
        println(io, "env_id = ", env_id)
        for i in 1:height
            for j in 1:width
                idx = findfirst(@view tile_map[env_id, :, i, j])
                if isnothing(idx)
                    print(io, DUMMY_CHARACTER)
                else
                    print(io, Crayons.Crayon(foreground = FOREGROUND_COLORS[idx]), CHARACTERS[idx], Crayons.Crayon(reset = true))
                end
            end

            println(io)
        end

        println(io, "reward = ", reward[env_id])
        println(io, "done = ", done[env_id])
    end

    return nothing
end

get_string_key_bindings(env::GW.AbstractGridWorld) = """Key bindings:
                                                     'q': quit
                                                     'r': RLBase.reset!(env)
                                                     'w': MOVE_UP
                                                     's': MOVE_DOWN
                                                     'a': MOVE_LEFT
                                                     'd': MOVE_RIGHT
                                                     """

function play!(terminal::REPL.Terminals.UnixTerminal, env::SingleRoomUndirectedBatch; file_name::Union{Nothing, AbstractString} = nothing)
    REPL.Terminals.raw!(terminal, true)

    terminal_out = terminal.out_stream
    terminal_in = terminal.in_stream
    file = Play.open_maybe(file_name)

    Play.write_io1_maybe_io2(terminal_out, file, Play.CLEAR_SCREEN)
    Play.write_io1_maybe_io2(terminal_out, file, Play.MOVE_CURSOR_TO_ORIGIN)
    Play.write_io1_maybe_io2(terminal_out, file, Play.HIDE_CURSOR)

    num_envs = size(env.tile_map, 1)
    chars = Array{Char}(undef, num_envs)

    action_chars = ('w', 's', 'a', 'd')

    char_to_action = Dict('w' => MOVE_UP,
                          's' => MOVE_DOWN,
                          'a' => MOVE_LEFT,
                          'd' => MOVE_RIGHT,
                         )

    action = Array{Int}(undef, num_envs)

    try
        while true
            Play.write_io1_maybe_io2(terminal_out, file, get_string_key_bindings(env))
            Play.show_io1_maybe_io2(terminal_out, file, MIME("text/plain"), env)

            for i in 1:num_envs
                chars[i] = read(terminal_in, Char)
            end

            Play.write_io1_maybe_io2(terminal_out, file, Play.EMPTY_SCREEN)

            if 'q' in chars
                Play.write_io1_maybe_io2(terminal_out, file, Play.SHOW_CURSOR)
                Play.close_maybe(file)
                REPL.Terminals.raw!(terminal, false)
                return nothing
            elseif 'r' in chars
                RLBase.reset!(env)
            elseif all(char -> char in action_chars, chars)
                for i in 1:num_envs
                    action[i] = char_to_action[chars[i]]
                end
                env(action)
            else
                @warn "No procedure exists for this character sequence: $chars"
            end

            Play.write_io1_maybe_io2(terminal_out, file, "Last character sequence = $(chars)\n")
        end
    finally
        Play.write_io1_maybe_io2(terminal_out, file, Play.SHOW_CURSOR)
        Play.close_maybe(file)
        REPL.Terminals.raw!(terminal, false)
    end

    return nothing
end

play!(env::SingleRoomUndirectedBatch; file_name = nothing) = play!(REPL.TerminalMenus.terminal, env, file_name = file_name)

end # module
