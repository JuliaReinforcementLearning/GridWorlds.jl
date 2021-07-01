module Play

import ..GridWorlds as GW
import REPL

const ESC = Char(0x1B)
const HIDE_CURSOR = ESC * "[?25l"
const SHOW_CURSOR = ESC * "[?25h"
const CLEAR_SCREEN = ESC * "[2J"
const MOVE_CURSOR_TO_ORIGIN = ESC * "[H"
const CLEAR_SCREEN_BEFORE_CURSOR = ESC * "[1J"
const EMPTY_SCREEN = CLEAR_SCREEN_BEFORE_CURSOR * MOVE_CURSOR_TO_ORIGIN

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

function replay(terminal::REPL.Terminals.UnixTerminal, file_name::AbstractString; frame_rate = Union{Nothing, Real} = nothing)
    terminal_out = terminal.out_stream
    delimiter = EMPTY_SCREEN
    frames = split(read(file_name, String), delimiter)
    num_frames = length(frames)

    if isnothing(frame_rate)
        terminal_in = terminal.in_stream
        REPL.Terminals.raw!(terminal, true)
        current_frame = 1
        try
            while true
                write(terminal_out, frames[current_frame])
                println(terminal_out)
                println(terminal_out, "replay key bindings: 'q': quit, 'f': go to first frame, 'n': go to next frame, 'p': go to previous frame")

                char = read(terminal_in, Char)

                if char == 'q'
                    write(terminal_out, SHOW_CURSOR)
                    REPL.Terminals.raw!(terminal, false)
                    return nothing
                elseif char == 'f'
                    current_frame = 1
                elseif char == 'n'
                    current_frame = mod1(current_frame + 1, num_frames)
                elseif char == 'p'
                    current_frame = mod1(current_frame - 1, num_frames)
                end

                write(terminal_out, EMPTY_SCREEN)
            end
        finally
            write(terminal_out, SHOW_CURSOR)
            REPL.Terminals.raw!(terminal, false)
            return nothing
        end
    else
        for frame in frames
            write(terminal_out, frame)
            sleep(1 / frame_rate)
            write(terminal_out, delimiter)
        end
    end

    return nothing
end

replay(file_name; frame_rate = nothing) = replay(REPL.TerminalMenus.terminal, file_name, frame_rate = frame_rate)

function play!(terminal::REPL.Terminals.UnixTerminal, env::GW.AbstractGridWorldGame; file_name::Union{Nothing, AbstractString} = nothing)
    REPL.Terminals.raw!(terminal, true)

    terminal_out = terminal.out_stream
    terminal_in = terminal.in_stream
    file = Play.open_maybe(file_name)

    write_io1_maybe_io2(terminal_out, file, CLEAR_SCREEN)
    write_io1_maybe_io2(terminal_out, file, MOVE_CURSOR_TO_ORIGIN)
    write_io1_maybe_io2(terminal_out, file, HIDE_CURSOR)

    action_keys = GW.get_action_keys(env)
    action_names = GW.get_action_names(env)
    key_bindings = "play key bindings: 'q': quit, 'r': reset!, $(action_keys): $(action_names)\n"

    try
        while true
            write_io1_maybe_io2(terminal_out, file, key_bindings)
            show_io1_maybe_io2(terminal_out, file, MIME("text/plain"), env)

            char = read(terminal_in, Char)

            if char == 'q'
                write_io1_maybe_io2(terminal_out, file, SHOW_CURSOR)
                close_maybe(file)
                REPL.Terminals.raw!(terminal, false)
                return nothing
            elseif char == 'r'
                GW.reset!(env)
            elseif char in action_keys
                GW.act!(env, findfirst(==(char), action_keys))
            end

            write_io1_maybe_io2(terminal_out, file, EMPTY_SCREEN)
            write_io1_maybe_io2(terminal_out, file, "Last character: $(char)\n")
        end
    finally
        write_io1_maybe_io2(terminal_out, file, SHOW_CURSOR)
        close_maybe(file)
        REPL.Terminals.raw!(terminal, false)
    end

    return nothing
end

play!(env::GW.AbstractGridWorldGame; file_name = nothing) = play!(REPL.TerminalMenus.terminal, env, file_name = file_name)

end # module
