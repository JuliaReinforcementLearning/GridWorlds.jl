export DynamicObstacles

using Random

mutable struct DynamicObstacles <: AbstractGridWorld
    world::GridWorldBase{Tuple{Empty,Wall,Obstacle,Goal}}
    agent_pos::CartesianIndex{2}
    agent::Agent
    num_obstacle::Int
    obs_pos_array::Array{CartesianIndex{2},1}
end

function DynamicObstacles(;n=8, agent_start_pos=CartesianIndex(2,2), agent_start_dir=RIGHT)
    objects = (EMPTY, WALL, OBSTACLE, GOAL)
    w = GridWorldBase(objects, n, n)

    w[EMPTY, 2:n-1, 2:n-1] .= true
    w[WALL, [1,n], 1:n] .= true
    w[WALL, 1:n, [1,n]] .= true
    w[GOAL, n-1, n-1] = true
    w[EMPTY, n-1, n-1] = false

    w[OBSTACLE,1:n,1:n] .= false
    #num obstacles is n-3 only for n=5 or n=6, it need not be a function of n otherwise
    num_obstacle = n-3
    
    obs_pos_array = Array{CartesianIndex{2},1}(undef,num_obstacle)
    
    obstacles_placed = 0
    while obstacles_placed < num_obstacle
        obs_pos = CartesianIndex(rand(2:n-1), rand(2:n-1))
        if (obs_pos == agent_start_pos) || (w[OBSTACLE, obs_pos] == true)
            continue
        else
            
            w[OBSTACLE, obs_pos] = true
            w[EMPTY, obs_pos] = false
            obstacles_placed = obstacles_placed + 1
            obs_pos_array[obstacles_placed] = obs_pos
            
        end
    end


    DynamicObstacles(w, agent_start_pos, Agent(dir=agent_start_dir), num_obstacle, obs_pos_array)
end

function (w::DynamicObstacles)(::MoveForward)
    dir = get_dir(w.agent) 
    dest = dir(w.agent_pos)
    if !w.world[WALL, dest]
        #if w.world[OBSTACLE, dest]
        #    #end the game
        #    println("You crashed")
        #else
        obstacles_replaced = 0
        while obstacles_replaced < w.num_obstacle
            old_pos = w.obs_pos_array[obstacles_replaced+1]
            next_pos = CartesianIndex(old_pos[1]+rand([-1,1]),old_pos[2]+rand([-1,1])) 
            if w.world[WALL, next_pos] 
                continue
            else
                flag = 0
                for i = obstacles_replaced:0
                    if (i < obstacles_replaced) && (w.obs_pos_array[i+1]==next_pos)
                        flag = 1
                        break
                    end
                end
                if flag == 1
                    continue
                    println("obstacles are overlapping")
                else
                    w.obs_pos_array[obstacles_replaced+1] = next_pos
                    w.world[OBSTACLE, next_pos] = true
                    w.world[OBSTACLE, old_pos] = false
                    w.world[EMPTY, next_pos] = false
                    w.world[EMPTY, old_pos] = true
                    obstacles_replaced += 1  
            
                end
            end   
        end
        if w.world[OBSTACLE, dest]
            #end the game
            println("You crashed")
        end
        #end    
        w.agent_pos = dest
    end
    w
end



