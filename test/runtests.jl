import GridWorlds as GW
import Random
import ReinforcementLearningBase as RLBase
import Test

const MAX_STEPS = 3000
const NUM_RESETS = 3

get_terminal_returns(env::GW.RLBaseEnv{E}) where {E <: GW.SingleRoomUndirectedModule.SingleRoomUndirected} = (env.env.terminal_reward,)
get_terminal_returns(env::GW.RLBaseEnv{E}) where {E <: GW.SingleRoomDirectedModule.SingleRoomDirected} = (env.env.env.terminal_reward,)

get_terminal_returns(env::GW.RLBaseEnv{E}) where {E <: GW.GridRoomsUndirectedModule.GridRoomsUndirected} = (env.env.terminal_reward,)
get_terminal_returns(env::GW.RLBaseEnv{E}) where {E <: GW.GridRoomsDirectedModule.GridRoomsDirected} = (env.env.env.terminal_reward,)

get_terminal_returns(env::GW.RLBaseEnv{E}) where {E <: GW.SequentialRoomsUndirectedModule.SequentialRoomsUndirected} = (env.env.terminal_reward,)
get_terminal_returns(env::GW.RLBaseEnv{E}) where {E <: GW.SequentialRoomsDirectedModule.SequentialRoomsDirected} = (env.env.env.terminal_reward,)

get_terminal_returns(env::GW.RLBaseEnv{E}) where {E <: GW.MazeUndirectedModule.MazeUndirected} = (env.env.terminal_reward,)
get_terminal_returns(env::GW.RLBaseEnv{E}) where {E <: GW.MazeDirectedModule.MazeDirected} = (env.env.env.terminal_reward,)

get_terminal_returns(env::GW.RLBaseEnv{E}) where {E <: GW.GoToTargetUndirectedModule.GoToTargetUndirected} = (env.env.terminal_reward, env.env.terminal_penalty)
get_terminal_returns(env::GW.RLBaseEnv{E}) where {E <: GW.GoToTargetDirectedModule.GoToTargetDirected} = (env.env.env.terminal_reward, env.env.env.terminal_penalty)

get_terminal_returns(env::GW.RLBaseEnv{E}) where {E <: GW.DoorKeyUndirectedModule.DoorKeyUndirected} = (env.env.terminal_reward,)
get_terminal_returns(env::GW.RLBaseEnv{E}) where {E <: GW.DoorKeyDirectedModule.DoorKeyDirected} = (env.env.env.terminal_reward,)

get_terminal_returns(env::GW.RLBaseEnv{E}) where {E <: GW.CollectGemsUndirectedModule.CollectGemsUndirected} = (env.env.gem_reward * env.env.num_gem_init,)
get_terminal_returns(env::GW.RLBaseEnv{E}) where {E <: GW.CollectGemsDirectedModule.CollectGemsDirected} = (env.env.env.gem_reward * env.env.env.num_gem_init,)
get_terminal_returns(env::GW.RLBaseEnv{E}) where {E <: GW.CollectGemsMultiAgentUndirectedModule.CollectGemsMultiAgentUndirected} = (env.env.num_gem_init * env.env.gem_reward,)

get_terminal_returns(env::GW.RLBaseEnv{E}) where {E <: GW.DynamicObstaclesUndirectedModule.DynamicObstaclesUndirected} = (env.env.terminal_reward, env.env.terminal_penalty)
get_terminal_returns(env::GW.RLBaseEnv{E}) where {E <: GW.DynamicObstaclesDirectedModule.DynamicObstaclesDirected} = (env.env.env.terminal_reward, env.env.env.terminal_penalty)

get_terminal_returns(env::GW.RLBaseEnv{E}) where {E <: GW.SokobanUndirectedModule.SokobanUndirected} = (typeof(env.env.reward)(length(env.env.box_positions)),)
get_terminal_returns(env::GW.RLBaseEnv{E}) where {E <: GW.SokobanDirectedModule.SokobanDirected} = (env.env.env.terminal_reward,)

get_terminal_returns(env::GW.RLBaseEnv{E}) where {E <: GW.CatcherModule.Catcher} = env.env.terminal_penalty : env.env.gem_reward : MAX_STEPS * env.env.gem_reward

get_terminal_returns(env::GW.RLBaseEnv{E}) where {E <: GW.TransportUndirectedModule.TransportUndirected} = (env.env.terminal_reward,)
get_terminal_returns(env::GW.RLBaseEnv{E}) where {E <: GW.TransportDirectedModule.TransportDirected} = (env.env.env.terminal_reward,)

get_terminal_returns(env::GW.RLBaseEnv{E}) where {E <: GW.FrozenLakeUndirectedModule.FrozenLakeUndirected} = (env.env.terminal_reward, env.env.terminal_penalty)

function is_valid_terminal_return(env::GW.RLBaseEnv{E}, terminal_return) where {E <: GW.SnakeModule.Snake}
    terminal_reward = env.env.terminal_reward
    terminal_penalty = env.env.terminal_penalty
    food_reward = env.env.food_reward
    _, height, width = size(env.env.tile_map)

    terminal_returns_win = terminal_reward : food_reward : terminal_reward + height * width * food_reward
    terminal_returns_lose = terminal_penalty : food_reward : terminal_penalty + height * width * food_reward

    if terminal_return in terminal_returns_win
        return true
    elseif terminal_return in terminal_returns_lose
        return true
    else
        return false
    end
end

Test.@testset "GridWorlds.jl" begin
    for Env in GW.ENVS
        Test.@testset "$(Env)" begin
            R = Float32
            env = GW.RLBaseEnv(Env(R = R))
            for _ in 1:NUM_RESETS
                RLBase.reset!(env)
                Test.@test RLBase.reward(env) == zero(R)
                Test.@test RLBase.is_terminated(env) == false

                total_reward = zero(R)
                for i in 1:MAX_STEPS
                    state = RLBase.state(env)
                    action = rand(RLBase.action_space(env))
                    env(action)
                    total_reward += RLBase.reward(env)

                    if RLBase.is_terminated(env)
                        if Env == GW.SnakeModule.Snake
                            is_valid_terminal_return(env, total_reward)
                        else
                            Test.@test total_reward in get_terminal_returns(env)
                        end

                        break
                    end

                    if i == MAX_STEPS
                        @info "$Env not terminated after MAX_STEPS = $MAX_STEPS"
                    end
                end
            end
        end
    end
end
