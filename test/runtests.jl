using GridWorlds
using Test
using Random
using ReinforcementLearningBase

ENVS = [EmptyGridWorld, FourRooms, GoToDoor, DoorKey, CollectGems, DynamicObstacles, SequentialRooms]
ENVS_RLBASE = [EmptyGridWorld, FourRooms, GoToDoor, DoorKey, CollectGems, DynamicObstacles, SequentialRooms]
ACTIONS = [TURN_LEFT, TURN_RIGHT, MOVE_FORWARD]

@testset "GridWorlds.jl" begin
    for Env in ENVS
        @testset "$(Env)" begin
            env = Env()
            @test typeof(env.agent_pos) == CartesianIndex{2}
            @test typeof(env.agent.dir) <: LRUD
            @test size(env.world.grid, 1) == length(env.world.objects)
            @test 1 ≤ env.agent_pos[1] ≤ size(env.world.grid, 2)
            @test 1 ≤ env.agent_pos[2] ≤ size(env.world.grid, 3)

            for _=1:1000
                env = env(rand(ACTIONS))
                @test 1 ≤ env.agent_pos[1] ≤ size(env.world.grid, 2)
                @test 1 ≤ env.agent_pos[2] ≤ size(env.world.grid, 3)
                @test env.world[WALL, env.agent_pos] == false
                view = get_agent_view(env)
                @test typeof(view) <: BitArray{3}
                @test size(view,1) == length(env.world.objects)
                @test size(view,2) == 7
                @test size(view,3) == 7
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
