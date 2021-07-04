module RLBaseEnvModule

import ..GridWorlds as GW
import ..Play
import REPL
import ReinforcementLearningBase as RLBase

struct RLBaseEnv{E} <: RLBase.AbstractEnv
    env::E
end

Base.show(io::IO, mime::MIME"text/plain", env::RLBaseEnv{E}) where {E <: GW.AbstractGridWorldGame} = show(io, mime, env.env)
Play.play!(terminal::REPL.Terminals.UnixTerminal, env::RLBaseEnv{E}; file_name::Union{Nothing, AbstractString} = nothing) where {E <: GW.AbstractGridWorldGame} = Play.play!(terminal, env.env, file_name = file_name)
Play.play!(env::RLBaseEnv{E}; file_name = nothing) where {E <: GW.AbstractGridWorldGame} = Play.play!(REPL.TerminalMenus.terminal, env.env, file_name = file_name)

#####
##### SingleRoomUndirected
#####

RLBase.StateStyle(env::RLBaseEnv{E}) where {E <: GW.SingleRoomUndirectedModule.SingleRoomUndirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.SingleRoomUndirectedModule.SingleRoomUndirected} = nothing
RLBase.state(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.SingleRoomUndirectedModule.SingleRoomUndirected} = env.env.tile_map

RLBase.reset!(env::RLBaseEnv{E}) where {E <: GW.SingleRoomUndirectedModule.SingleRoomUndirected} = GW.reset!(env.env)

RLBase.action_space(env::RLBaseEnv{E}) where {E <: GW.SingleRoomUndirectedModule.SingleRoomUndirected} = 1:GW.SingleRoomUndirectedModule.NUM_ACTIONS
(env::RLBaseEnv{E})(action) where {E <: GW.SingleRoomUndirectedModule.SingleRoomUndirected} = GW.act!(env.env, action)

RLBase.reward(env::RLBaseEnv{E}) where {E <: GW.SingleRoomUndirectedModule.SingleRoomUndirected} = env.env.reward
RLBase.is_terminated(env::RLBaseEnv{E}) where {E <: GW.SingleRoomUndirectedModule.SingleRoomUndirected} = env.env.done

#####
##### SingleRoomDirected
#####

RLBase.StateStyle(env::RLBaseEnv{E}) where {E <: GW.SingleRoomDirectedModule.SingleRoomDirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.SingleRoomDirectedModule.SingleRoomDirected} = nothing
RLBase.state(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.SingleRoomDirectedModule.SingleRoomDirected} = env.env.env.tile_map

RLBase.reset!(env::RLBaseEnv{E}) where {E <: GW.SingleRoomDirectedModule.SingleRoomDirected} = GW.reset!(env.env)

RLBase.action_space(env::RLBaseEnv{E}) where {E <: GW.SingleRoomDirectedModule.SingleRoomDirected} = 1:GW.SingleRoomDirectedModule.NUM_ACTIONS
(env::RLBaseEnv{E})(action) where {E <: GW.SingleRoomDirectedModule.SingleRoomDirected} = GW.act!(env.env, action)

RLBase.reward(env::RLBaseEnv{E}) where {E <: GW.SingleRoomDirectedModule.SingleRoomDirected} = env.env.env.reward
RLBase.is_terminated(env::RLBaseEnv{E}) where {E <: GW.SingleRoomDirectedModule.SingleRoomDirected} = env.env.env.done

#####
##### GridRoomsUndirected
#####

RLBase.StateStyle(env::RLBaseEnv{E}) where {E <: GW.GridRoomsUndirectedModule.GridRoomsUndirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.GridRoomsUndirectedModule.GridRoomsUndirected} = nothing
RLBase.state(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.GridRoomsUndirectedModule.GridRoomsUndirected} = env.env.tile_map

RLBase.reset!(env::RLBaseEnv{E}) where {E <: GW.GridRoomsUndirectedModule.GridRoomsUndirected} = GW.reset!(env.env)

RLBase.action_space(env::RLBaseEnv{E}) where {E <: GW.GridRoomsUndirectedModule.GridRoomsUndirected} = 1:GW.GridRoomsUndirectedModule.NUM_ACTIONS
(env::RLBaseEnv{E})(action) where {E <: GW.GridRoomsUndirectedModule.GridRoomsUndirected} = GW.act!(env.env, action)

RLBase.reward(env::RLBaseEnv{E}) where {E <: GW.GridRoomsUndirectedModule.GridRoomsUndirected} = env.env.reward
RLBase.is_terminated(env::RLBaseEnv{E}) where {E <: GW.GridRoomsUndirectedModule.GridRoomsUndirected} = env.env.done

#####
##### GridRoomsDirected
#####

RLBase.StateStyle(env::RLBaseEnv{E}) where {E <: GW.GridRoomsDirectedModule.GridRoomsDirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.GridRoomsDirectedModule.GridRoomsDirected} = nothing
RLBase.state(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.GridRoomsDirectedModule.GridRoomsDirected} = env.env.env.tile_map

RLBase.reset!(env::RLBaseEnv{E}) where {E <: GW.GridRoomsDirectedModule.GridRoomsDirected} = GW.reset!(env.env)

RLBase.action_space(env::RLBaseEnv{E}) where {E <: GW.GridRoomsDirectedModule.GridRoomsDirected} = 1:GW.GridRoomsDirectedModule.NUM_ACTIONS
(env::RLBaseEnv{E})(action) where {E <: GW.GridRoomsDirectedModule.GridRoomsDirected} = GW.act!(env.env, action)

RLBase.reward(env::RLBaseEnv{E}) where {E <: GW.GridRoomsDirectedModule.GridRoomsDirected} = env.env.env.reward
RLBase.is_terminated(env::RLBaseEnv{E}) where {E <: GW.GridRoomsDirectedModule.GridRoomsDirected} = env.env.env.done

#####
##### SequentialRoomsUndirected
#####

RLBase.StateStyle(env::RLBaseEnv{E}) where {E <: GW.SequentialRoomsUndirectedModule.SequentialRoomsUndirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.SequentialRoomsUndirectedModule.SequentialRoomsUndirected} = nothing
RLBase.state(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.SequentialRoomsUndirectedModule.SequentialRoomsUndirected} = env.env.tile_map

RLBase.reset!(env::RLBaseEnv{E}) where {E <: GW.SequentialRoomsUndirectedModule.SequentialRoomsUndirected} = GW.reset!(env.env)

RLBase.action_space(env::RLBaseEnv{E}) where {E <: GW.SequentialRoomsUndirectedModule.SequentialRoomsUndirected} = 1:GW.SequentialRoomsUndirectedModule.NUM_ACTIONS
(env::RLBaseEnv{E})(action) where {E <: GW.SequentialRoomsUndirectedModule.SequentialRoomsUndirected} = GW.act!(env.env, action)

RLBase.reward(env::RLBaseEnv{E}) where {E <: GW.SequentialRoomsUndirectedModule.SequentialRoomsUndirected} = env.env.reward
RLBase.is_terminated(env::RLBaseEnv{E}) where {E <: GW.SequentialRoomsUndirectedModule.SequentialRoomsUndirected} = env.env.done

end # module
