using GridWorlds
using Test
using Random
using ReinforcementLearningBase

ENVS = [EmptyGridWorld, FourRooms, GoToDoor, DoorKey, CollectGems, DynamicObstacles]
ENVS_RLBASE = [EmptyGridWorld, FourRooms, CollectGems]
ACTIONS = [TURN_LEFT, TURN_RIGHT, MOVE_FORWARD]

@testset "GridWorlds.jl" begin
    for env in ENVS
        @testset "$(env)" begin
            w = env()
            @test typeof(w.agent_pos) == CartesianIndex{2}
            @test typeof(w.agent.dir) <: LRUD
            @test size(w.world.world, 1) == length(w.world.objects)
            @test 1 ≤ w.agent_pos[1] ≤ size(w.world.world, 2)
            @test 1 ≤ w.agent_pos[2] ≤ size(w.world.world, 3)

            for _=1:1000
                w = w(rand(ACTIONS))
                @test 1 ≤ w.agent_pos[1] ≤ size(w.world.world, 2)
                @test 1 ≤ w.agent_pos[2] ≤ size(w.world.world, 3)
                @test w.world[WALL, w.agent_pos] == false
                view = get_agent_view(w)
                @test typeof(view) <: BitArray{3}
                @test size(view,1) == length(w.world.objects)
                @test size(view,2) == 7
                @test size(view,3) == 7
            end
        end
    end

    for env in ENVS_RLBASE
        @testset "$(env) RLBase API" begin
            w = env()

            @test get_reward(w) == 0.0
            @test get_terminal(w) == false
            @test get_state(w) == get_agent_view(w)

            π = RandomPolicy(w)
            total_reward = 0.0

            while !get_terminal(w)
                action = π(w)
                w(action)
                total_reward += get_reward(w)
            end

            if env == CollectGems
                @test total_reward == w.num_gem_init * w.gem_reward
            elseif env == EmptyGridWorld || env == FourRooms
                @test total_reward == w.goal_reward
            end
        end
    end
end
