export MultiRoom, MultiRoomN2S4, MultiRoomN4S5, MultiRoomN6

using Random

mutable struct MultiRoom{W<:GridWorldBase} <: AbstractGridWorld
    world::W
    agent_pos::CartesianIndex{2}
    agent::Agent
end

mutable struct Room
    top::CartesianIndex{2}
    size::CartesianIndex{2}
    entryDoor::CartesianIndex{2}
    exitDoor::CartesianIndex{2}
end

function placeRooms!( n, numLeft, roomList, minSize, maxSize, entryDoorWall, entryDoorPos, rng=Random.GLOBAL_RNG)
    sizeX = rand(rng, minSize:maxSize)
    sizeY = rand(rng, minSize:maxSize)
    
    if length(roomList) == 0
        top = entryDoorPos
    elseif entryDoorWall == 0 #RIGHT
        top = CartesianIndex(entryDoorPos[1]-sizeX+1, rand(rng, entryDoorPos[2]-sizeY+2:entryDoorPos[2]))
    elseif entryDoorWall == 1 #BOTTOM
        top = CartesianIndex(rand(rng, entryDoorPos[1]-sizeX+2:entryDoorPos[1]), entryDoorPos[2]-sizeY+1)
    elseif entryDoorWall == 2 #LEFT
        top = CartesianIndex(entryDoorPos[1], rand(rng, entryDoorPos[2]-sizeY+2:entryDoorPos[2]))
    elseif entryDoorWall == 3 #TOP
        top = CartesianIndex(rand(rng, entryDoorPos[1]-sizeX+2:entryDoorPos[1]), entryDoorPos[2])
    else
        return false
    end
    
    if !(1 ≤ top[1] ≤ n-sizeX+1 && 1 ≤ top[2] ≤ n-sizeY+1)
        return false
    end

    for room in roomList
        nonOverlap = top[1]+sizeX < room.top[1] || room.top[1] + room.size[1] ≤ top[1] || top[2]+sizeY < room.top[2] || room.top[2] + room.size[2] ≤ top[2]
        if !nonOverlap
            return false
        end
    end
    push!(roomList, Room(top, CartesianIndex(sizeX,sizeY), entryDoorPos, CartesianIndex(-1,-1)))

    if numLeft == 1
        return True
    end

    for i=1:8
        wallSet = deleteat!([0,1,2,3], entryDoorWall+1)
        exitDoorWall = rand(rng, wallSet)
        nextEntryWall = (exitDoorWall + 2) % 4
        if exitDoorWall == 0
            exitDoorPos = CartesianIndex(top[1]+sizeX-1,top[2]+rand(rng, 1:sizeY-1))
        elseif exitDoorWall == 1
            exitDoorPos = CartesianIndex(top[1]+rand(rng, 1:sizeX-1),top[2]+sizeY-1)
        elseif exitDoorWall == 2
            exitDoorPos = CartesianIndex(top[1],top[2]+rand(rng, 1:sizeY-1))
        elseif exitDoorWall == 3
            exitDoorPos = CartesianIndex(top[1]+rand(rng, 1:sizeX-1),top[2])
        else
            return false
        end
        success = placeRooms!(n, numLeft-1, roomList, minSize,  maxSize, nextEntryWall, exitDoorPos)
        if success break end
    end
    return true
end

function MultiRoom(;n=25, minRooms=2, maxRooms=4, maxSize=10, rng=Random.GLOBAL_RNG)
    objects = (EMPTY, WALL, GOAL, (Door(c) for c in COLORS)...)
    world = GridWorldBase(objects, n, n)
    world[EMPTY, :, :] .= true
    numRooms = rand(rng, minRooms:maxRooms)
    roomList = []
    while length(roomList) < numRooms
        curRoomList = []
        entryDoorPos = CartesianIndex(rand(rng, 1:n-1),rand(rng, 1:n-1))
        placeRooms!(n, numRooms, curRoomList, 4, maxSize, 3, entryDoorPos)
        if length(curRoomList) > length(roomList)
            roomList = curRoomList
        end
    end

    door_colors = COLORS[randperm(rng, length(COLORS))][1:length(roomList)-1]
    for (i, room) in enumerate(roomList)
        world[WALL, [room.top[2],room.top[2]+room.size[2]-1], room.top[1]:room.top[1]+room.size[1]-1] .=true
        world[EMPTY, [room.top[2],room.top[2]+room.size[2]-1], room.top[1]:room.top[1]+room.size[1]-1] .=false
        if i>1
            world[Door(door_colors[i-1]), room.entryDoor] = true
            world[WALL, room.entryDoor] = false
            roomList[i-1].exitDoor = room.entryDoor
        end
    end

    agent_start_pos = CartesianIndex(roomList[1].top[2]+roomList[1].size[2]/2, roomList[1].top[1]+roomList[1].size[2]/2)
    goal = CartesianIndex(roomList[length(roomlist)].top[2]+roomList[length(roomlist)].size[2]/2, roomList[length(roomlist)].top[1]+roomList[length(roomlist)].size[2]/2)

    world[EMPTY, goal] = false
    world[GOAL, goal] = true

    MultiRoom(world, agent_start_pos, Agent(dir=RIGHT))
end

function (w::MultiRoom)(::MoveForward)
    dir = get_dir(w.agent)
    dest = dir(w.agent_pos)
    if !w.world[WALL, dest]
        w.agent_pos = dest
    end
    w
end

MultiRoomN2S4() = MultiRoom(minRooms=2,maxRooms=2,maxSize=4)
MultiRoomN4S5() = MultiRoom(minRooms=4,maxRooms=4,maxSize=5)
MultiRoomN6() = MultiRoom(minRooms=6,maxRooms=6)
