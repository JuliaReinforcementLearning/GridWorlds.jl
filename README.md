# GridWorlds

A package for creating grid world environments for reinforcement learning in Julia. This package is designed to be lightweight and fast.

This package is inspired by [gym-minigrid](https://github.com/maximecb/gym-minigrid). In order to cite this package, please refer to the file `CITATION.bib`. Starring the repository on GitHub is also appreciated. For benchmarks, refer to `benchmark/benchmarks.md`.

**Important note:** This package is undergoing heavy internal redesign. This README reflects the new design (some visualizations might be oudated). The README for the last released version (`0.4.0`) can be found [here](https://github.com/JuliaReinforcementLearning/GridWorlds.jl/tree/c0e86bb6c33819f0e4a4cefe0284d985d0474ed3).

## Table of contents:

* [Getting Started](#getting-started)
* [Playing and Recording](#playing-and-recording)

[List of Environments](#list-of-environments)
1. [SingleRoomUndirected](#singleroomundirected)
1. [SingleRoomDirected](#singleroomdirected)
1. [GridRoomsUndirected](#gridroomsundirected)
1. [GridRoomsDirected](#gridroomsdirected)
1. [SequentialRoomsUndirected](#sequentialroomsundirected)
1. [SequentialRoomsDirected](#sequentialroomsdirected)
1. [MazeUndirected](#mazeundirected)
1. [MazeDirected](#mazedirected)
1. [GoToTargetUndirected](#gototargetundirected)
1. [GoToTargetDirected](#gototargetdirected)
1. [DoorKeyUndirected](#doorkeyundirected)
1. [DoorKeyDirected](#doorkeydirected)
1. [CollectGemsUndirected](#collectgemsundirected)
1. [CollectGemsDirected](#collectgemsdirected)
1. [CollectGemsMultiAgentUndirected](#collectgemsmultiagentundirected)
1. [DynamicObstaclesUndirected](#dynamicobstaclesundirected)
1. [DynamicObstaclesDirected](#dynamicobstaclesdirected)
1. [SokobanUndirected](#sokobanundirected)
1. [SokobanDirected](#sokobandirected)
1. [Snake](#snake)
1. [Catcher](#catcher)
1. [TransportUndirected](#transportundirected)
1. [TransportDirected](#transportdirected)

## Getting Started

```julia
import GridWorlds as GW

env = GW.SingleRoomUndirectedModule.SingleRoomUndirected()

GW.reset!(env)
GW.act!(env, 1) # move up
GW.act!(env, 2) # move down
GW.act!(env, 3) # move left
GW.act!(env, 4) # move right

# play an environment interactively inside the terminal

GW.Play.play!(env, file_name = "recording.txt")

# replay the recording inside the terminal at given frame rate

GW.Play.replay("recording.txt", frame_rate = 2)

# manually step through the recording

GW.Play.replay("recording.txt", frame_rate = nothing)

# using the RLBase API

import ReinforcementLearningBase as RLBase

rlbase_env = GW.RLBaseEnvModule.RLBaseEnv(env)

RLBase.reset!(rlbase_env)
RLBase.state(rlbase_env)
RLBase.action_space(rlbase_env)
RLBase.reward(rlbase_env)
RLBase.is_terminated(rlbase_env)

rlbase_env(1) # move up
rlbase_env(2) # move down
rlbase_env(3) # move left
rlbase_env(4) # move right
```

## Playing and Recording

All the environments can be played directly inside the REPL. These interactive sessions can be recorded in plain text files and replayed as well. There are two ways to replay a recording:
1. Replay the recording at a given frame rate. This would loop through all the frames once and then (and only then) exit back to the REPL.
1. Manually step through the recording. This allows you to move through the frames one by one with keyboard inputs at your own pace. The key bindings for replaying are as follows: `n` to go to next frame, `p` to go to previous frame, `f` to go to first frame, `q` to quit.

Here is an example:

<img src="https://user-images.githubusercontent.com/32610387/124133299-52476d00-da9f-11eb-9127-b5e24fd7cc52.gif">

## List of Environments

1. ### SingleRoomUndirected

    <img src="https://user-images.githubusercontent.com/32610387/124130483-748bbb80-da9c-11eb-8ff7-a0fa3c2a7b88.gif">

1. ### SingleRoomDirected

    <img src="https://user-images.githubusercontent.com/32610387/124130952-efed6d00-da9c-11eb-84fa-0caf856a2580.gif">

1. ### GridRoomsUndirected

    <img src="https://user-images.githubusercontent.com/32610387/124348535-1d0a5e80-dc08-11eb-9cfb-7c5f40e9c5c9.gif">

1. ### GridRoomsDirected

    <img src="https://user-images.githubusercontent.com/32610387/124348551-298eb700-dc08-11eb-835a-ee4b80a5b1b4.gif">

1. ### SequentialRoomsUndirected

    <img src="https://user-images.githubusercontent.com/32610387/124383241-0f78d580-dce9-11eb-929f-b485ee72f496.gif">

1. ### SequentialRoomsDirected

    <img src="https://user-images.githubusercontent.com/32610387/124383247-199ad400-dce9-11eb-9e6d-565857c4b7ff.gif">

1. ### MazeUndirected

    <img src="https://user-images.githubusercontent.com/32610387/124395058-abbdcf00-dd1f-11eb-9a89-3abe575c3d37.gif">

1. ### MazeDirected

    <img src="https://user-images.githubusercontent.com/32610387/124395056-a791b180-dd1f-11eb-968a-96e478861bda.gif">

1. ### GoToTargetUndirected

    <img src="https://user-images.githubusercontent.com/32610387/124428857-ced19880-dd8a-11eb-847c-d1be4991bcd8.gif">

1. ### GoToTargetDirected

    <img src="https://user-images.githubusercontent.com/32610387/124428875-d2fdb600-dd8a-11eb-826a-6802f999d237.gif">

1. ### DoorKeyUndirected

    <img src="https://user-images.githubusercontent.com/32610387/124733469-daab8f00-df31-11eb-945c-ceffa4aa5384.gif">

1. ### DoorKeyDirected

    <img src="https://user-images.githubusercontent.com/32610387/124733482-de3f1600-df31-11eb-81d3-688b8f289b4d.gif">

1. ### CollectGemsUndirected

    <img src="https://user-images.githubusercontent.com/32610387/124762000-06d60880-df50-11eb-9ce4-7ebbe7e0ce27.gif">

1. ### CollectGemsDirected

    <img src="https://user-images.githubusercontent.com/32610387/124762009-09d0f900-df50-11eb-96d3-9dd50f6cfaf5.gif">

1. ### CollectGemsMultiAgentUndirected

    <img src="https://user-images.githubusercontent.com/32610387/126144961-1dbafc54-c510-4b9a-9cdb-2b056f07eb27.gif">

1. ### DynamicObstaclesUndirected

    <img src="https://user-images.githubusercontent.com/32610387/124779409-6091ff00-df5f-11eb-8546-0b719f6ba260.gif">

1. ### DynamicObstaclesDirected

    <img src="https://user-images.githubusercontent.com/32610387/124779434-6687e000-df5f-11eb-9cff-3e3098675c15.gif">

1. ### SokobanUndirected

    <img src="https://user-images.githubusercontent.com/32610387/126067718-ad16a8e2-0164-4366-bbd3-371254c8b58f.gif">

1. ### SokobanDirected

    <img src="https://user-images.githubusercontent.com/32610387/126067805-448b19a6-b9f7-43cd-a347-67af5b929b65.gif">

1. ### Snake

    <img src="https://user-images.githubusercontent.com/32610387/126077504-44a613a6-d941-45ca-98af-5fbb7aec678b.gif">

1. ### Catcher

    <img src="https://user-images.githubusercontent.com/32610387/126079450-8a4df282-f17c-485e-96d3-17ab7fcfb0fc.gif">

1. ### TransportUndirected

    <img src="https://user-images.githubusercontent.com/32610387/126120108-86f6664e-4521-411e-b207-a40c221b9017.gif">

1. ### TransportDirected

    <img src="https://user-images.githubusercontent.com/32610387/126120388-556cd987-8e92-405f-8b36-341a643da372.gif">
