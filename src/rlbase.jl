struct RLBaseEnv{E} <: RLBase.AbstractEnv
    env::E
end

Base.show(io::IO, mime::MIME"text/plain", env::RLBaseEnv{E}) where {E <: AbstractGridWorld} = show(io, mime, env.env)

play!(terminal::REPL.Terminals.UnixTerminal, env::RLBaseEnv{E}, file_name::Union{Nothing, AbstractString}, frame_start_delimiter::Union{Nothing, AbstractString}) where {E <: AbstractGridWorld} = play!(terminal, env.env, file_name, frame_start_delimiter)
play!(env::RLBaseEnv{E}; file_name = nothing, frame_start_delimiter = nothing) where {E <: AbstractGridWorld} = play!(REPL.TerminalMenus.terminal, env.env, file_name, frame_start_delimiter)
