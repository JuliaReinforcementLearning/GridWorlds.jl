using GridWorlds
using Test
using Random

ENVS = [EmptyGridWorld, FourRooms, GoToDoor]
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
    @testset "grid_world_base.jl" begin
        grid = CartesianIndices((-3:3, 0:6))
        soln = 
        [[1,1,1,1,1,1,1]
         [1,1,1,1,1,1,1]
         [1,1,1,1,1,1,1]
         [1,1,1,1,1,1,1]
         [1,1,1,1,0,0,1]
         [0,0,1,1,0,0,1]
         [0,1,1,1,0,0,0]]
         
        s = GridWorlds.Shadow(CartesianIndex((1,3)))
        println("minθ:$(s.minθ)|maxθ:$(s.maxθ)|r:$(s.r)")
        println(s(grid))
        println("($(GridWorlds.theta(3,4)), $(GridWorlds.radius(3,4)))")
        println(s(CartesianIndices((3:3, 5:5))))
    end
end
