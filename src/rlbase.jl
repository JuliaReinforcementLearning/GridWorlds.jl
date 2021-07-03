module RLBaseGridWorldModule

import ..GridWorlds as GW
import ReinforcementLearningBase as RLBase

struct RLBaseGridWorld{E} <: RLBase.AbstractEnv
    env::E
end

Base.show(io::IO, mime::MIME"text/plain", env::RLBaseGridWorld{E}) where {E <: GW.AbstractGridWorldGame} = show(io, mime, env.env)

#####
##### SingleRoomUndirected
#####

RLBase.StateStyle(env::RLBaseGridWorld{E}) where {E <: GW.SingleRoomUndirectedModule.SingleRoomUndirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::RLBaseGridWorld{E}, ::RLBase.InternalState) where {E <: GW.SingleRoomUndirectedModule.SingleRoomUndirected} = nothing
RLBase.state(env::RLBaseGridWorld{E}, ::RLBase.InternalState) where {E <: GW.SingleRoomUndirectedModule.SingleRoomUndirected} = env.env.tile_map

RLBase.reset!(env::RLBaseGridWorld{E}) where {E <: GW.SingleRoomUndirectedModule.SingleRoomUndirected} = GW.reset!(env.env)

RLBase.action_space(env::RLBaseGridWorld{E}) where {E <: GW.SingleRoomUndirectedModule.SingleRoomUndirected} = 1:GW.SingleRoomUndirectedModule.NUM_ACTIONS
(env::RLBaseGridWorld{E})(action) where {E <: GW.SingleRoomUndirectedModule.SingleRoomUndirected} = GW.act!(env.env, action)

RLBase.reward(env::RLBaseGridWorld{E}) where {E <: GW.SingleRoomUndirectedModule.SingleRoomUndirected} = env.env.reward
RLBase.is_terminated(env::RLBaseGridWorld{E}) where {E <: GW.SingleRoomUndirectedModule.SingleRoomUndirected} = env.env.done

#####
##### SingleRoomDirected
#####

RLBase.StateStyle(env::RLBaseGridWorld{E}) where {E <: GW.SingleRoomDirectedModule.SingleRoomDirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::RLBaseGridWorld{E}, ::RLBase.InternalState) where {E <: GW.SingleRoomDirectedModule.SingleRoomDirected} = nothing
RLBase.state(env::RLBaseGridWorld{E}, ::RLBase.InternalState) where {E <: GW.SingleRoomDirectedModule.SingleRoomDirected} = env.env.env.tile_map

RLBase.reset!(env::RLBaseGridWorld{E}) where {E <: GW.SingleRoomDirectedModule.SingleRoomDirected} = GW.reset!(env.env)

RLBase.action_space(env::RLBaseGridWorld{E}) where {E <: GW.SingleRoomDirectedModule.SingleRoomDirected} = 1:GW.SingleRoomDirectedModule.NUM_ACTIONS
(env::RLBaseGridWorld{E})(action) where {E <: GW.SingleRoomDirectedModule.SingleRoomDirected} = GW.act!(env.env, action)

RLBase.reward(env::RLBaseGridWorld{E}) where {E <: GW.SingleRoomDirectedModule.SingleRoomDirected} = env.env.env.reward
RLBase.is_terminated(env::RLBaseGridWorld{E}) where {E <: GW.SingleRoomDirectedModule.SingleRoomDirected} = env.env.env.done

#####
##### GridRoomsUndirected
#####

RLBase.StateStyle(env::RLBaseGridWorld{E}) where {E <: GW.GridRoomsUndirectedModule.GridRoomsUndirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::RLBaseGridWorld{E}, ::RLBase.InternalState) where {E <: GW.GridRoomsUndirectedModule.GridRoomsUndirected} = nothing
RLBase.state(env::RLBaseGridWorld{E}, ::RLBase.InternalState) where {E <: GW.GridRoomsUndirectedModule.GridRoomsUndirected} = env.env.tile_map

RLBase.reset!(env::RLBaseGridWorld{E}) where {E <: GW.GridRoomsUndirectedModule.GridRoomsUndirected} = GW.reset!(env.env)

RLBase.action_space(env::RLBaseGridWorld{E}) where {E <: GW.GridRoomsUndirectedModule.GridRoomsUndirected} = 1:GW.GridRoomsUndirectedModule.NUM_ACTIONS
(env::RLBaseGridWorld{E})(action) where {E <: GW.GridRoomsUndirectedModule.GridRoomsUndirected} = GW.act!(env.env, action)

RLBase.reward(env::RLBaseGridWorld{E}) where {E <: GW.GridRoomsUndirectedModule.GridRoomsUndirected} = env.env.reward
RLBase.is_terminated(env::RLBaseGridWorld{E}) where {E <: GW.GridRoomsUndirectedModule.GridRoomsUndirected} = env.env.done

#####
##### GridRoomsDirected
#####

RLBase.StateStyle(env::RLBaseGridWorld{E}) where {E <: GW.GridRoomsDirectedModule.GridRoomsDirected} = RLBase.InternalState{Any}()
RLBase.state_space(env::RLBaseGridWorld{E}, ::RLBase.InternalState) where {E <: GW.GridRoomsDirectedModule.GridRoomsDirected} = nothing
RLBase.state(env::RLBaseGridWorld{E}, ::RLBase.InternalState) where {E <: GW.GridRoomsDirectedModule.GridRoomsDirected} = env.env.env.tile_map

RLBase.reset!(env::RLBaseGridWorld{E}) where {E <: GW.GridRoomsDirectedModule.GridRoomsDirected} = GW.reset!(env.env)

RLBase.action_space(env::RLBaseGridWorld{E}) where {E <: GW.GridRoomsDirectedModule.GridRoomsDirected} = 1:GW.GridRoomsDirectedModule.NUM_ACTIONS
(env::RLBaseGridWorld{E})(action) where {E <: GW.GridRoomsDirectedModule.GridRoomsDirected} = GW.act!(env.env, action)

RLBase.reward(env::RLBaseGridWorld{E}) where {E <: GW.GridRoomsDirectedModule.GridRoomsDirected} = env.env.env.reward
RLBase.is_terminated(env::RLBaseGridWorld{E}) where {E <: GW.GridRoomsDirectedModule.GridRoomsDirected} = env.env.env.done

end # module
