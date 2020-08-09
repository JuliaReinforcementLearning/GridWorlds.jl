mutable struct EmptyGridWorld
    world::GridWorldBase{Tuple{Empty,Wall}}
    agent_pos::CartesianIndex{2}
    agent_view::BitArray{3}
    agent_direction::CartesianIndex{2}
end

function EmptyGridWorld(;n=8, agent_start_pos=CartesianIndex(2,2), agent_view_size=7)
    world = GridWorldBase(n, n, EMPTY, WALL)
    world[EMPTY, 2:n-1, 2:n-1] .= true
    world[WALL, [1,n], 1:n] .= true
    world[WALL, 1:n, [1,n]] .= true
    agent_view = BitArray{3}(undef, 3, agent_view_size, agent_view_size)
    EmptyGridWorld(world, agent_start_pos, agent_view, RIGHT)
end

"""
    (w::EmptyGridWorld)([UP,DOWN,LEFT,RIGHT])

Return `true` if action is executed successfully, otherwise return `false`.
"""
function (w::EmptyGridWorld)(action::CartesianIndex{2})
    dest = w.agent_pos + action
    if w.world[WALL, dest]
        false
    else
        # TODO:
        # update w.agent_view
        # https://github.com/maximecb/gym-minigrid/blob/master/gym_minigrid/minigrid.py#L1165
        w.agent_pos = dest
        w.agent_direction = action
        true
    end
end
