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

#####
##### GoToTargetDirected
#####

RLBase.StateStyle(env::RLBaseEnv{E}) where {E <: GW.GoToTargetDirectedModule.GoToTargetDirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.GoToTargetDirectedModule.GoToTargetDirected} = nothing
RLBase.state(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.GoToTargetDirectedModule.GoToTargetDirected} = (env.env.env.tile_map, env.env.env.target, env.env.agent_direction)

RLBase.reset!(env::RLBaseEnv{E}) where {E <: GW.GoToTargetDirectedModule.GoToTargetDirected} = GW.reset!(env.env)

RLBase.action_space(env::RLBaseEnv{E}) where {E <: GW.GoToTargetDirectedModule.GoToTargetDirected} = 1:GW.GoToTargetDirectedModule.NUM_ACTIONS
(env::RLBaseEnv{E})(action) where {E <: GW.GoToTargetDirectedModule.GoToTargetDirected} = GW.act!(env.env, action)

RLBase.reward(env::RLBaseEnv{E}) where {E <: GW.GoToTargetDirectedModule.GoToTargetDirected} = env.env.env.reward
RLBase.is_terminated(env::RLBaseEnv{E}) where {E <: GW.GoToTargetDirectedModule.GoToTargetDirected} = env.env.env.done

#####
##### DoorKeyUndirected
#####

RLBase.StateStyle(env::RLBaseEnv{E}) where {E <: GW.DoorKeyUndirectedModule.DoorKeyUndirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.DoorKeyUndirectedModule.DoorKeyUndirected} = nothing
RLBase.state(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.DoorKeyUndirectedModule.DoorKeyUndirected} = env.env.tile_map

RLBase.reset!(env::RLBaseEnv{E}) where {E <: GW.DoorKeyUndirectedModule.DoorKeyUndirected} = GW.reset!(env.env)

RLBase.action_space(env::RLBaseEnv{E}) where {E <: GW.DoorKeyUndirectedModule.DoorKeyUndirected} = 1:GW.DoorKeyUndirectedModule.NUM_ACTIONS
(env::RLBaseEnv{E})(action) where {E <: GW.DoorKeyUndirectedModule.DoorKeyUndirected} = GW.act!(env.env, action)

RLBase.reward(env::RLBaseEnv{E}) where {E <: GW.DoorKeyUndirectedModule.DoorKeyUndirected} = env.env.reward
RLBase.is_terminated(env::RLBaseEnv{E}) where {E <: GW.DoorKeyUndirectedModule.DoorKeyUndirected} = env.env.done

#####
##### DoorKeyDirected
#####

RLBase.StateStyle(env::RLBaseEnv{E}) where {E <: GW.DoorKeyDirectedModule.DoorKeyDirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.DoorKeyDirectedModule.DoorKeyDirected} = nothing
RLBase.state(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.DoorKeyDirectedModule.DoorKeyDirected} = (env.env.env.tile_map, env.env.agent_direction)

RLBase.reset!(env::RLBaseEnv{E}) where {E <: GW.DoorKeyDirectedModule.DoorKeyDirected} = GW.reset!(env.env)

RLBase.action_space(env::RLBaseEnv{E}) where {E <: GW.DoorKeyDirectedModule.DoorKeyDirected} = 1:GW.DoorKeyDirectedModule.NUM_ACTIONS
(env::RLBaseEnv{E})(action) where {E <: GW.DoorKeyDirectedModule.DoorKeyDirected} = GW.act!(env.env, action)

RLBase.reward(env::RLBaseEnv{E}) where {E <: GW.DoorKeyDirectedModule.DoorKeyDirected} = env.env.env.reward
RLBase.is_terminated(env::RLBaseEnv{E}) where {E <: GW.DoorKeyDirectedModule.DoorKeyDirected} = env.env.env.done

#####
##### CollectGemsUndirected
#####

RLBase.StateStyle(env::RLBaseEnv{E}) where {E <: GW.CollectGemsUndirectedModule.CollectGemsUndirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.CollectGemsUndirectedModule.CollectGemsUndirected} = nothing
RLBase.state(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.CollectGemsUndirectedModule.CollectGemsUndirected} = env.env.tile_map

RLBase.reset!(env::RLBaseEnv{E}) where {E <: GW.CollectGemsUndirectedModule.CollectGemsUndirected} = GW.reset!(env.env)

RLBase.action_space(env::RLBaseEnv{E}) where {E <: GW.CollectGemsUndirectedModule.CollectGemsUndirected} = 1:GW.CollectGemsUndirectedModule.NUM_ACTIONS
(env::RLBaseEnv{E})(action) where {E <: GW.CollectGemsUndirectedModule.CollectGemsUndirected} = GW.act!(env.env, action)

RLBase.reward(env::RLBaseEnv{E}) where {E <: GW.CollectGemsUndirectedModule.CollectGemsUndirected} = env.env.reward
RLBase.is_terminated(env::RLBaseEnv{E}) where {E <: GW.CollectGemsUndirectedModule.CollectGemsUndirected} = env.env.done

#####
##### CollectGemsDirected
#####

RLBase.StateStyle(env::RLBaseEnv{E}) where {E <: GW.CollectGemsDirectedModule.CollectGemsDirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.CollectGemsDirectedModule.CollectGemsDirected} = nothing
RLBase.state(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.CollectGemsDirectedModule.CollectGemsDirected} = (env.env.env.tile_map, env.env.agent_direction)

RLBase.reset!(env::RLBaseEnv{E}) where {E <: GW.CollectGemsDirectedModule.CollectGemsDirected} = GW.reset!(env.env)

RLBase.action_space(env::RLBaseEnv{E}) where {E <: GW.CollectGemsDirectedModule.CollectGemsDirected} = 1:GW.CollectGemsDirectedModule.NUM_ACTIONS
(env::RLBaseEnv{E})(action) where {E <: GW.CollectGemsDirectedModule.CollectGemsDirected} = GW.act!(env.env, action)

RLBase.reward(env::RLBaseEnv{E}) where {E <: GW.CollectGemsDirectedModule.CollectGemsDirected} = env.env.env.reward
RLBase.is_terminated(env::RLBaseEnv{E}) where {E <: GW.CollectGemsDirectedModule.CollectGemsDirected} = env.env.env.done

#####
##### DynamicObstaclesUndirected
#####

RLBase.StateStyle(env::RLBaseEnv{E}) where {E <: GW.DynamicObstaclesUndirectedModule.DynamicObstaclesUndirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.DynamicObstaclesUndirectedModule.DynamicObstaclesUndirected} = nothing
RLBase.state(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.DynamicObstaclesUndirectedModule.DynamicObstaclesUndirected} = env.env.tile_map

RLBase.reset!(env::RLBaseEnv{E}) where {E <: GW.DynamicObstaclesUndirectedModule.DynamicObstaclesUndirected} = GW.reset!(env.env)

RLBase.action_space(env::RLBaseEnv{E}) where {E <: GW.DynamicObstaclesUndirectedModule.DynamicObstaclesUndirected} = 1:GW.DynamicObstaclesUndirectedModule.NUM_ACTIONS
(env::RLBaseEnv{E})(action) where {E <: GW.DynamicObstaclesUndirectedModule.DynamicObstaclesUndirected} = GW.act!(env.env, action)

RLBase.reward(env::RLBaseEnv{E}) where {E <: GW.DynamicObstaclesUndirectedModule.DynamicObstaclesUndirected} = env.env.reward
RLBase.is_terminated(env::RLBaseEnv{E}) where {E <: GW.DynamicObstaclesUndirectedModule.DynamicObstaclesUndirected} = env.env.done

#####
##### DynamicObstaclesDirected
#####

RLBase.StateStyle(env::RLBaseEnv{E}) where {E <: GW.DynamicObstaclesDirectedModule.DynamicObstaclesDirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.DynamicObstaclesDirectedModule.DynamicObstaclesDirected} = nothing
RLBase.state(env::RLBaseEnv{E}, ::RLBase.InternalState) where {E <: GW.DynamicObstaclesDirectedModule.DynamicObstaclesDirected} = (env.env.env.tile_map, env.env.agent_direction)

RLBase.reset!(env::RLBaseEnv{E}) where {E <: GW.DynamicObstaclesDirectedModule.DynamicObstaclesDirected} = GW.reset!(env.env)

RLBase.action_space(env::RLBaseEnv{E}) where {E <: GW.DynamicObstaclesDirectedModule.DynamicObstaclesDirected} = 1:GW.DynamicObstaclesDirectedModule.NUM_ACTIONS
(env::RLBaseEnv{E})(action) where {E <: GW.DynamicObstaclesDirectedModule.DynamicObstaclesDirected} = GW.act!(env.env, action)

RLBase.reward(env::RLBaseEnv{E}) where {E <: GW.DynamicObstaclesDirectedModule.DynamicObstaclesDirected} = env.env.env.reward
RLBase.is_terminated(env::RLBaseEnv{E}) where {E <: GW.DynamicObstaclesDirectedModule.DynamicObstaclesDirected} = env.env.env.done

end # module
