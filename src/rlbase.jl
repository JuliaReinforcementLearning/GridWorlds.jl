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
RLBase.state(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.SingleRoomDirectedModule.SingleRoomDirected} = (env.env.env.tile_map, env.env.agent_direction)

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
RLBase.state(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.GridRoomsDirectedModule.GridRoomsDirected} = (env.env.env.tile_map, env.env.agent_direction)

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
RLBase.state(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.SequentialRoomsUndirectedModule.SequentialRoomsUndirected} = GW.SequentialRoomsUndirectedModule.get_small_tile_map(env.env.tile_map)

RLBase.reset!(env::RLBaseEnv{E}) where {E <: GW.SequentialRoomsUndirectedModule.SequentialRoomsUndirected} = GW.reset!(env.env)

RLBase.action_space(env::RLBaseEnv{E}) where {E <: GW.SequentialRoomsUndirectedModule.SequentialRoomsUndirected} = 1:GW.SequentialRoomsUndirectedModule.NUM_ACTIONS
(env::RLBaseEnv{E})(action) where {E <: GW.SequentialRoomsUndirectedModule.SequentialRoomsUndirected} = GW.act!(env.env, action)

RLBase.reward(env::RLBaseEnv{E}) where {E <: GW.SequentialRoomsUndirectedModule.SequentialRoomsUndirected} = env.env.reward
RLBase.is_terminated(env::RLBaseEnv{E}) where {E <: GW.SequentialRoomsUndirectedModule.SequentialRoomsUndirected} = env.env.done

#####
##### SequentialRoomsDirected
#####

RLBase.StateStyle(env::RLBaseEnv{E}) where {E <: GW.SequentialRoomsDirectedModule.SequentialRoomsDirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.SequentialRoomsDirectedModule.SequentialRoomsDirected} = nothing
RLBase.state(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.SequentialRoomsDirectedModule.SequentialRoomsDirected} = (GW.SequentialRoomsUndirectedModule.get_small_tile_map(env.env.env.tile_map), env.env.agent_direction)

RLBase.reset!(env::RLBaseEnv{E}) where {E <: GW.SequentialRoomsDirectedModule.SequentialRoomsDirected} = GW.reset!(env.env)

RLBase.action_space(env::RLBaseEnv{E}) where {E <: GW.SequentialRoomsDirectedModule.SequentialRoomsDirected} = 1:GW.SequentialRoomsDirectedModule.NUM_ACTIONS
(env::RLBaseEnv{E})(action) where {E <: GW.SequentialRoomsDirectedModule.SequentialRoomsDirected} = GW.act!(env.env, action)

RLBase.reward(env::RLBaseEnv{E}) where {E <: GW.SequentialRoomsDirectedModule.SequentialRoomsDirected} = env.env.env.reward
RLBase.is_terminated(env::RLBaseEnv{E}) where {E <: GW.SequentialRoomsDirectedModule.SequentialRoomsDirected} = env.env.env.done

#####
##### MazeUndirected
#####

RLBase.StateStyle(env::RLBaseEnv{E}) where {E <: GW.MazeUndirectedModule.MazeUndirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.MazeUndirectedModule.MazeUndirected} = nothing
RLBase.state(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.MazeUndirectedModule.MazeUndirected} = env.env.tile_map

RLBase.reset!(env::RLBaseEnv{E}) where {E <: GW.MazeUndirectedModule.MazeUndirected} = GW.reset!(env.env)

RLBase.action_space(env::RLBaseEnv{E}) where {E <: GW.MazeUndirectedModule.MazeUndirected} = 1:GW.MazeUndirectedModule.NUM_ACTIONS
(env::RLBaseEnv{E})(action) where {E <: GW.MazeUndirectedModule.MazeUndirected} = GW.act!(env.env, action)

RLBase.reward(env::RLBaseEnv{E}) where {E <: GW.MazeUndirectedModule.MazeUndirected} = env.env.reward
RLBase.is_terminated(env::RLBaseEnv{E}) where {E <: GW.MazeUndirectedModule.MazeUndirected} = env.env.done

#####
##### MazeDirected
#####

RLBase.StateStyle(env::RLBaseEnv{E}) where {E <: GW.MazeDirectedModule.MazeDirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.MazeDirectedModule.MazeDirected} = nothing
RLBase.state(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.MazeDirectedModule.MazeDirected} = (env.env.env.tile_map, env.env.agent_direction)

RLBase.reset!(env::RLBaseEnv{E}) where {E <: GW.MazeDirectedModule.MazeDirected} = GW.reset!(env.env)

RLBase.action_space(env::RLBaseEnv{E}) where {E <: GW.MazeDirectedModule.MazeDirected} = 1:GW.MazeDirectedModule.NUM_ACTIONS
(env::RLBaseEnv{E})(action) where {E <: GW.MazeDirectedModule.MazeDirected} = GW.act!(env.env, action)

RLBase.reward(env::RLBaseEnv{E}) where {E <: GW.MazeDirectedModule.MazeDirected} = env.env.env.reward
RLBase.is_terminated(env::RLBaseEnv{E}) where {E <: GW.MazeDirectedModule.MazeDirected} = env.env.env.done

#####
##### GoToTargetUndirected
#####

RLBase.StateStyle(env::RLBaseEnv{E}) where {E <: GW.GoToTargetUndirectedModule.GoToTargetUndirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.GoToTargetUndirectedModule.GoToTargetUndirected} = nothing
RLBase.state(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.GoToTargetUndirectedModule.GoToTargetUndirected} = (env.env.tile_map, env.env.target)

RLBase.reset!(env::RLBaseEnv{E}) where {E <: GW.GoToTargetUndirectedModule.GoToTargetUndirected} = GW.reset!(env.env)

RLBase.action_space(env::RLBaseEnv{E}) where {E <: GW.GoToTargetUndirectedModule.GoToTargetUndirected} = 1:GW.GoToTargetUndirectedModule.NUM_ACTIONS
(env::RLBaseEnv{E})(action) where {E <: GW.GoToTargetUndirectedModule.GoToTargetUndirected} = GW.act!(env.env, action)

RLBase.reward(env::RLBaseEnv{E}) where {E <: GW.GoToTargetUndirectedModule.GoToTargetUndirected} = env.env.reward
RLBase.is_terminated(env::RLBaseEnv{E}) where {E <: GW.GoToTargetUndirectedModule.GoToTargetUndirected} = env.env.done

end # module
