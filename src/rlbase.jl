struct RLBaseEnv{E} <: RLBase.AbstractEnv
    env::E
end

Base.show(io::IO, mime::MIME"text/plain", env::RLBaseEnv{E}) where {E <: AbstractGridWorldGame} = show(io, mime, env.env)
Play.play!(terminal::REPL.Terminals.UnixTerminal, env::RLBaseEnv{E}; file_name::Union{Nothing, AbstractString} = nothing) where {E <: AbstractGridWorldGame} = Play.play!(terminal, env.env, file_name = file_name)
Play.play!(env::RLBaseEnv{E}; file_name = nothing) where {E <: AbstractGridWorldGame} = Play.play!(REPL.TerminalMenus.terminal, env.env, file_name = file_name)
get_action_names(env::RLBaseEnv{E}) where {E <: AbstractGridWorldGame} = get_action_names(env.env)
