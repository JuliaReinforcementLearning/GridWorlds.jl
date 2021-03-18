import GridWorlds
import GridWorlds: GW
import Test
import Random
import ReinforcementLearningBase
import ReinforcementLearningBase: RLBase

# ENVS = [EmptyRoom, GridRooms, SequentialRooms, Maze, GoToDoor, DoorKey, CollectGems, DynamicObstacles, Sokoban, Snake, Catcher, Transport]
ENVS = [GW.EmptyRoomDirected,
        GW.EmptyRoomUndirected,
        GW.GridRoomsDirected,
        GW.SequentialRoomsUndirected,
        GW.SequentialRoomsDirected,
        GW.SequentialRoomsUndirected,
        GW.MazeDirected,
        GW.MazeUndirected,
        GW.CollectGemsDirected,
        GW.CollectGemsUndirected,
        GW.DynamicObstaclesDirected,
        GW.DynamicObstaclesUndirected,
        GW.SokobanDirected,
        GW.SokobanUndirected,
        GW.Catcher,
       ]

const MAX_STEPS = 3000
const NUM_RESETS = 3

get_terminal_returns(env::GW.EmptyRoomDirected) = (env.terminal_reward,)
get_terminal_returns(env::GW.EmptyRoomUndirected) = (env.terminal_reward,)
get_terminal_returns(env::GW.GridRoomsDirected) = (env.terminal_reward,)
get_terminal_returns(env::GW.GridRoomsUndirected) = (env.terminal_reward,)
get_terminal_returns(env::GW.SequentialRoomsDirected) = (env.terminal_reward,)
get_terminal_returns(env::GW.SequentialRoomsUndirected) = (env.terminal_reward,)
get_terminal_returns(env::GW.MazeDirected) = (env.terminal_reward,)
get_terminal_returns(env::GW.MazeUndirected) = (env.terminal_reward,)
get_terminal_returns(env::GW.CollectGemsDirected) = (env.num_gem_init * env.gem_reward,)
get_terminal_returns(env::GW.CollectGemsUndirected) = (env.num_gem_init * env.gem_reward,)
get_terminal_returns(env::GW.DynamicObstaclesDirected) = (env.terminal_reward, env.terminal_penalty)
get_terminal_returns(env::GW.DynamicObstaclesUndirected) = (env.terminal_reward, env.terminal_penalty)
get_terminal_returns(env::GW.SokobanDirected{T}) where {T} = (T(length(env.box_pos)),)
get_terminal_returns(env::GW.SokobanUndirected{T}) where {T} = (T(length(env.box_pos)),)
get_terminal_returns(env::GW.Catcher) = env.terminal_reward:env.ball_reward:MAX_STEPS*env.ball_reward

Test.@testset "GridWorlds.jl" begin
    for Env in ENVS
        Test.@testset "$(Env)" begin
            T = Float32
            env = Env(T = T)
            for _ in 1:NUM_RESETS
                RLBase.reset!(env)
                Test.@test RLBase.reward(env) == zero(T)
                Test.@test RLBase.is_terminated(env) == false

                total_reward = zero(T)
                for i in 1:MAX_STEPS
                    action = rand(RLBase.action_space(env))
                    env(action)
                    total_reward += RLBase.reward(env)

                    Test.@test 1 ≤ GW.get_agent_pos(env)[1] ≤ GW.get_height(env)
                    Test.@test 1 ≤ GW.get_agent_pos(env)[2] ≤ GW.get_width(env)

                    if RLBase.is_terminated(env)
                        Test.@test total_reward in get_terminal_returns(env)
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
