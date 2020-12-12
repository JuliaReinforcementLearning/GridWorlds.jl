using GridWorlds
using Test
using Random
using ReinforcementLearningBase

ENVS = [EmptyGridWorld, FourRooms, GoToDoor, DoorKey, CollectGems, DynamicObstacles, SequentialRooms]
ENVS_RLBASE = [EmptyGridWorld, FourRooms, GoToDoor, DoorKey, CollectGems, DynamicObstacles, SequentialRooms]

@testset "GridWorlds.jl" begin
    for Env in ENVS
        @testset "$(Env)" begin
            env = Env()
            @test typeof(get_agent_pos(env)) == CartesianIndex{2}
            @test typeof(get_agent_dir(env)) <: Direction
            @test size(get_grid(env), 1) == length(get_objects(env))
            @test 1 ≤ get_agent_pos(env)[1] ≤ get_height(env)
            @test 1 ≤ get_agent_pos(env)[2] ≤ get_width(env)

            for _=1:1000
                env = env(rand(get_actions(env)))
                @test 1 ≤ get_agent_pos(env)[1] ≤ get_height(env)
                @test 1 ≤ get_agent_pos(env)[2] ≤ get_width(env)
                @test get_world(env)[WALL, get_agent_pos(env)] == false
                view = get_agent_view(env)
                @test typeof(view) <: BitArray{3}
                @test size(view, 1) == length(get_objects(env))
            end
        end
    end

    for Env in ENVS_RLBASE
        @testset "$(Env) RLBase API" begin
            env = Env()

            @test get_reward(env) == 0.0
            @test get_terminal(env) == false
            if Env == GoToDoor
                @test get_state(env) == (get_agent_view(env), env.target)
            else
                @test get_state(env) == get_agent_view(env)
            end

            π = RandomPolicy(env)
            total_reward = 0.0

            while !get_terminal(env)
                action = π(env)
                env(action)
                total_reward += get_reward(env)
            end

            if Env == CollectGems
                @test total_reward == env.num_gem_init * env.gem_reward
            elseif Env == EmptyGridWorld || Env == FourRooms || Env == DoorKey || Env == SequentialRooms
                @test total_reward == env.goal_reward
            elseif Env == GoToDoor
                @test (total_reward == env.target_reward || total_reward == env.penalty)
            elseif Env == DynamicObstacles
                @test (total_reward == env.obstacle_reward || total_reward == env.goal_reward)
            end
        end
    end
end
