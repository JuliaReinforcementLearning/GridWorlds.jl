using GridWorlds
using Test
using Random
using ReinforcementLearningBase

ENVS = [EmptyRoom, GridRooms, SequentialRooms, GoToDoor, DoorKey, CollectGems, DynamicObstacles]

MAX_STEPS = 3000
NUM_RESETS = 3

get_terminal_rewards(env::Union{EmptyRoom, GridRooms, SequentialRooms, DoorKey}) = (env.terminal_reward,)
get_terminal_rewards(env::DynamicObstacles) = (env.terminal_reward, env.terminal_penalty)
get_terminal_rewards(env::CollectGems) = (env.num_gem_init * env.gem_reward,)
get_terminal_rewards(env::GoToDoor) = (env.terminal_reward, env.terminal_penalty)

@testset "GridWorlds.jl" begin
    for Env in ENVS
        @testset "$(Env)" begin
            env = Env()
            for _ in 1:NUM_RESETS
                reset!(env)
                @test get_reward(env) == 0.0
                @test get_terminal(env) == false
                if Env == GoToDoor
                    @test get_state(env) == (get_agent_view(env), env.target)
                else
                    @test get_state(env) == get_agent_view(env)
                end

                total_reward = 0.0
                for i in 1:MAX_STEPS
                    action = rand(get_actions(env))
                    env(action)
                    total_reward += get_reward(env)

                    @test 1 ≤ get_agent_pos(env)[1] ≤ get_height(env)
                    @test 1 ≤ get_agent_pos(env)[2] ≤ get_width(env)
                    @test get_world(env)[WALL, get_agent_pos(env)] == false

                    if get_terminal(env)
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
