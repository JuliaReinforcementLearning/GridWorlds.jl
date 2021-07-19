function sample_empty_position(rng, tile_map, max_tries = 1024)
    _, height, width = size(tile_map)
    position = CartesianIndex(rand(rng, 1:height), rand(rng, 1:width))

    for i in 1:1000
        if any(@view tile_map[:, position])
            position = CartesianIndex(rand(rng, 1:height), rand(rng, 1:width))
        else
            return position
        end
    end

    @warn "Returning non-empty position: $(position)"

    return position
end

function sample_two_positions_without_replacement(rng, region)
    position1 = rand(rng, region)
    position2 = rand(rng, region)

    while position1 == position2
        position2 = rand(rng, region)
    end

    return position1, position2
end

include("single_room_undirected.jl")
include("single_room_directed.jl")
include("grid_rooms_undirected.jl")
include("grid_rooms_directed.jl")
include("sequential_rooms_undirected.jl")
include("sequential_rooms_directed.jl")
include("maze_undirected.jl")
include("maze_directed.jl")
include("go_to_target_undirected.jl")
include("go_to_target_directed.jl")
include("door_key_undirected.jl")
include("door_key_directed.jl")
include("collect_gems_undirected.jl")
include("collect_gems_directed.jl")
include("dynamic_obstacles_undirected.jl")
include("dynamic_obstacles_directed.jl")
include("sokoban/sokoban_undirected.jl")
include("sokoban/sokoban_directed.jl")
include("snake.jl")
include("catcher.jl")
include("transport_undirected.jl")
include("transport_directed.jl")
include("collect_gems_multi_agent_undirected.jl")
