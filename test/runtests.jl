using GridWorlds
using Test
using Random
using ReinforcementLearningBase

# ENVS = [EmptyRoom, GridRooms, SequentialRooms, Maze, GoToDoor, DoorKey, CollectGems, DynamicObstacles, Sokoban, Snake, Catcher, Transport]
ENVS = [EmptyRoom, GridRooms, SequentialRooms, Maze, CollectGems, DynamicObstacles, Sokoban, Catcher]

MAX_STEPS = 3000
NUM_RESETS = 3

get_terminal_returns(env::EmptyRoom) = (env.terminal_reward,)
get_terminal_returns(env::GridRooms) = (env.terminal_reward,)
get_terminal_returns(env::SequentialRooms) = (env.terminal_reward,)
get_terminal_returns(env::Maze) = (env.terminal_reward,)
get_terminal_returns(env::CollectGems) = (env.num_gem_init * env.gem_reward,)
get_terminal_returns(env::DynamicObstacles) = (env.terminal_reward, env.terminal_penalty)
get_terminal_returns(env::Sokoban) = (GridWorlds.get_reward_type(env)(length(env.box_pos)),)
get_terminal_returns(env::Catcher) = env.terminal_reward:env.ball_reward:MAX_STEPS*env.ball_reward

@testset "GridWorlds.jl" begin
    for Env in ENVS
        for NAVIGATION in (GridWorlds.DIRECTED_NAVIGATION, GridWorlds.UNDIRECTED_NAVIGATION)
            if Env == Catcher && NAVIGATION == GridWorlds.DIRECTED_NAVIGATION
                continue
            end
            GridWorlds.get_navigation_style(::Env) = NAVIGATION
            @testset "$(NAVIGATION) $(Env)" begin
                env = Env()
                for _ in 1:NUM_RESETS
                    reset!(env)
                    @test reward(env) == zero(GridWorlds.get_reward_type(env))
                    @test is_terminated(env) == false

                    total_reward = zero(GridWorlds.get_reward_type(env))
                    for i in 1:MAX_STEPS
                        action = rand(action_space(env))
                        env(action)
                        total_reward += reward(env)

                        @test 1 ≤ GW.get_agent_pos(env)[1] ≤ GW.get_height(env)
                        @test 1 ≤ GW.get_agent_pos(env)[2] ≤ GW.get_width(env)

                        if is_terminated(env)
                            @test total_reward in get_terminal_returns(env)
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
end
