export MultiRoom, MultiRoomN2S4, MultiRoomN4S5, MultiRoomN6

using Random

mutable struct MultiRoom{W<:GridWorldBase, R} <: AbstractGridWorld
    world::W
    agent_pos::CartesianIndex{2}
    agent::Agent
    goal_reward::Float64
    reward::Float64
    roomlist::AbstractArray
    rng::R
end

mutable struct Room
    top::CartesianIndex{2}
    size::CartesianIndex{2}
    entry_door::CartesianIndex{2}
    exit_door::CartesianIndex{2}
end

function place_rooms!( n, numleft, roomlist, minsize, maxsize, entry_doorwall, entry_doorpos, rng=Random.GLOBAL_RNG)
    sizex = rand(rng, minsize:maxsize)
    sizey = rand(rng, minsize:maxsize)
    
    if length(roomlist) == 0
        top = entry_doorpos
    elseif entry_doorwall == 0 #RIGHT
        top = CartesianIndex(entry_doorpos[1]-sizex+1, rand(rng, entry_doorpos[2]-sizey+2:entry_doorpos[2]-1))
    elseif entry_doorwall == 1 #BOTTOM
        top = CartesianIndex(rand(rng, entry_doorpos[1]-sizex+2:entry_doorpos[1]-1), entry_doorpos[2]-sizey+1)
    elseif entry_doorwall == 2 #LEFT
        top = CartesianIndex(entry_doorpos[1], rand(rng, entry_doorpos[2]-sizey+2:entry_doorpos[2]-1))
    elseif entry_doorwall == 3 #TOP
        top = CartesianIndex(rand(rng, entry_doorpos[1]-sizex+2:entry_doorpos[1]-1), entry_doorpos[2])
    else
        return false
    end
    
    if !(1 ≤ top[1] ≤ n-sizex && 1 ≤ top[2] ≤ n-sizey)
        return false
    end

    for room in roomlist[1:length(roomlist)-1]
        non_overlap = top[1]+sizex < room.top[1] || room.top[1] + room.size[1] ≤ top[1] || top[2]+sizey < room.top[2] || room.top[2] + room.size[2] ≤ top[2]
        if !non_overlap
            return false
        end
    end
    push!(roomlist, Room(top, CartesianIndex(sizex,sizey), entry_doorpos, CartesianIndex(-1,-1)))

    if numleft == 1
        return true
    end

    for i=1:8
        wallset = deleteat!([0,1,2,3], entry_doorwall+1)
        exit_doorwall = rand(rng, wallset)
        next_entrywall = (exit_doorwall + 2) % 4
        if exit_doorwall == 0
            exit_doorpos = CartesianIndex(top[1]+sizex-1,top[2]+rand(rng, 1:sizey-2))
        elseif exit_doorwall == 1
            exit_doorpos = CartesianIndex(top[1]+rand(rng, 1:sizex-2),top[2]+sizey-1)
        elseif exit_doorwall == 2
            exit_doorpos = CartesianIndex(top[1],top[2]+rand(rng, 1:sizey-2))
        elseif exit_doorwall == 3
            exit_doorpos = CartesianIndex(top[1]+rand(rng, 1:sizex-2),top[2])
        else
            return false
        end
        success = place_rooms!(n, numleft-1, roomlist, minsize,  maxsize, next_entrywall, exit_doorpos)
        if success 
            break 
        end
    end
    return true
end

function MultiRoom(;n=25, minrooms=2, maxrooms=4, maxsize=10, rng=Random.GLOBAL_RNG)
    objects = (EMPTY, WALL, GOAL, (Door(c) for c in COLORS)...)
    world = GridWorldBase(objects, n, n)
    world[EMPTY, :, :] .= true
    numrooms = rand(rng, minrooms:maxrooms)
    roomlist = []
    while length(roomlist) < numrooms
        cur_roomlist = []
        entry_doorpos = CartesianIndex(rand(rng, 1:n-2),rand(rng, 1:n-2))
        place_rooms!(n, numrooms, cur_roomlist, 4, maxsize, 2, entry_doorpos)
        if length(cur_roomlist) > length(roomlist)
            roomlist = cur_roomlist
        end
    end

    door_colors = COLORS[randperm(rng, length(COLORS))][1:length(roomlist)-1]
    for (i, room) in enumerate(roomlist)
        sizex, sizey = Tuple(room.size)
        world[WALL, room.top[1]:room.top[1]+sizex-1, [room.top[2],room.top[2]+sizey-1]] .= true
        world[EMPTY, room.top[1]:room.top[1]+sizex-1, [room.top[2],room.top[2]+sizey-1]] .= false
        
        world[WALL, [room.top[1],room.top[1]+sizex-1], room.top[2]:room.top[2]+sizey-1] .= true
        world[EMPTY, [room.top[1],room.top[1]+sizex-1], room.top[2]:room.top[2]+sizey-1] .= false

        if i>1
            world[Door(door_colors[i-1]), room.entry_door] = true
            world[WALL, room.entry_door] = false
            world[EMPTY, room.entry_door] = false
            roomlist[i-1].exit_door = room.entry_door
        end
    end
    f_room, l_room = roomlist[1], roomlist[length(roomlist)]
    agent_start_pos = f_room.top + CartesianIndex(rand(rng, 2:f_room.size[1]-2), rand(rng, 2:f_room.size[2]-2))
    agent_start_dir = rand(rng, DIRECTIONS)
    goal = l_room.top + CartesianIndex(rand(rng, 2:l_room.size[1]-2), rand(rng, 2:l_room.size[2]-2))

    world[EMPTY, goal] = false
    world[GOAL, goal] = true

    goal_reward = 1.0
    reward = 0.0

    env = MultiRoom(world, agent_start_pos, Agent(dir=RIGHT), goal_reward, reward, roomlist, rng)
    reset!(env)
    return env
end

function (w::MultiRoom)(::MoveForward)
    dir = get_dir(w.agent)
    dest = dir(w.agent_pos)
    w.reward = 0.0
    if !w.world[WALL, dest]
        w.agent_pos = dest
        if w.world[GOAL, w.agent_pos]
            w.reward = w.goal_reward
        end
    end
    w
end

MultiRoomN2S4() = MultiRoom(minrooms=2,maxrooms=2,maxsize=4)
MultiRoomN4S5() = MultiRoom(minrooms=4,maxrooms=4,maxsize=5)
MultiRoomN6() = MultiRoom(minrooms=6,maxrooms=6)

RLBase.get_terminal(w::MultiRoom) = w.world[GOAL, w.agent_pos]

function RLBase.reset!(w::MultiRoom)
    f_room, l_room = w.roomlist[1], w.roomlist[length(w.roomlist)]
    rng = w.rng
    agent_start_pos = f_room.top + CartesianIndex(rand(rng, 2:f_room.size[1]-2), rand(rng, 2:f_room.size[2]-2))
    agent_start_dir = rand(rng, DIRECTIONS)
    goal_pos = l_room.top + CartesianIndex(rand(rng, 2:l_room.size[1]-2), rand(rng, 2:l_room.size[2]-2))

    n = size(w.world)[end]
    w.reward = 0.0
    w.agent_pos = agent_start_pos
    agent = get_agent(w)
    set_dir!(agent, agent_start_dir)

    w.world[GOAL, :, :] .= false
    w.world[GOAL, goal_pos] = true
    w.world[EMPTY, :, :] .= .!w.world[WALL, :, :]
    w.world[EMPTY, goal_pos] = false
    return w
end
