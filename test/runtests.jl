using GridWorlds
using Test
using Random
using ReinforcementLearningBase

ENVS = [EmptyRoom, GridRooms, SequentialRooms, GoToDoor, DoorKey, CollectGems, DynamicObstacles, Sokoban]

MAX_STEPS = 3000
NUM_RESETS = 3

get_terminal_rewards(env::EmptyRoom) = (env.terminal_reward,)
get_terminal_rewards(env::GridRooms) = (env.terminal_reward,)
get_terminal_rewards(env::SequentialRooms) = (env.terminal_reward,)
get_terminal_rewards(env::GoToDoor) = (env.terminal_reward, env.terminal_penalty)
get_terminal_rewards(env::DoorKey) = (env.terminal_reward,)
get_terminal_rewards(env::CollectGems) = (env.num_gem_init * env.gem_reward,)
get_terminal_rewards(env::DynamicObstacles) = (env.terminal_reward, env.terminal_penalty)
get_terminal_rewards(env::Sokoban) = (1.0,)

@testset "GridWorlds.jl" begin
    for Env in ENVS
        @testset "$(Env)" begin
            env = Env()
            for _ in 1:NUM_RESETS
                reset!(env)
                @test reward(env) == 0.0
                @test is_terminated(env) == false
                if Env == GoToDoor
                    @test state(env) == (GW.get_agent_view(env), env.target)
                elseif Env == Sokoban
                    @test state(env) == GW.get_grid(env)
                else
                    @test state(env) == GW.get_agent_view(env)
                end

                total_reward = 0.0
                for i in 1:MAX_STEPS
                    action = rand(action_space(env))
                    env(action)
                    total_reward += reward(env)

                    @test 1 ≤ GW.get_agent_pos(env)[1] ≤ GW.get_height(env)
                    @test 1 ≤ GW.get_agent_pos(env)[2] ≤ GW.get_width(env)
                    @test GW.get_world(env)[GW.WALL, GW.get_agent_pos(env)] == false

                    if is_terminated(env)
                        @test total_reward in get_terminal_rewards(env)
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
