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

play!(terminal::REPL.Terminals.UnixTerminal, env::GW.AbstractGridWorld; file_name::Union{Nothing, AbstractString} = nothing) = error("play! method not implemented for $(typeof(env))")

play!(env::GW.AbstractGridWorld; file_name = nothing) = play!(REPL.TerminalMenus.terminal, env, file_name = file_name)

function replay(terminal::REPL.Terminals.UnixTerminal, file_name::AbstractString, frame_rate)
    terminal_out = terminal.out_stream
    delimiter = EMPTY_SCREEN
    frames = split(read(file_name, String), delimiter)
    for frame in frames
        write(terminal_out, frame)
        sleep(1 / frame_rate)
        write(terminal_out, delimiter)
    end

    return nothing
end

replay(file_name; frame_rate = 2) = replay(REPL.TerminalMenus.terminal, file_name, frame_rate)

end # module
