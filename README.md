# GridWorlds

A package for creating grid world environments for reinforcement learning in Julia. This package is designed to be lightweight and fast.

This package is inspired by [gym-minigrid](https://github.com/maximecb/gym-minigrid). In order to cite this package, please refer to the file `CITATION.bib`. Starring the repository on GitHub is also appreciated. For benchmarks, refer to `benchmark/benchmarks.md`.

## Table of contents:

* [Getting Started](#getting-started)
* [Notes on Design](#notes-on-design)

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

# Each environment `Env` lives in its own module `EnvModule`
# For example, the `SingleRoomUndirected` environment lives inside the `SingleRoomUndirectedModule` module

env = GW.SingleRoomUndirectedModule.SingleRoomUndirected()

# reset the environment

GW.reset!(env)

# get names of actions that can be performed in this environment

GW.get_action_names(env)

# perform actions in the environment

GW.act!(env, 1) # move up
GW.act!(env, 2) # move down
GW.act!(env, 3) # move left
GW.act!(env, 4) # move right

# play an environment interactively inside the terminal

GW.play!(env)

# play and record the interaction in a file called recording.txt

GW.play!(env, file_name = "recording.txt", frame_start_delimiter = "FRAME_START_DELIMITER")

# manually step through the frames in the recording

GW.replay(file_name = "recording.txt", frame_start_delimiter = "FRAME_START_DELIMITER")

# replay the recording inside the terminal at a given frame rate

GW.replay(file_name = "recording.txt", frame_start_delimiter = "FRAME_START_DELIMITER", frame_rate = 2)

# use the RLBase API

import ReinforcementLearningBase as RLBase

# wrap a game instance from this package to create an RLBase compatible environment

rlbase_env = GW.RLBaseEnv(env)

# perform RLBase operations on the wrapped environment

RLBase.reset!(rlbase_env)
state = RLBase.state(rlbase_env)
action_space = RLBase.action_space(rlbase_env)
reward = RLBase.reward(rlbase_env)
done = RLBase.is_terminated(rlbase_env)

rlbase_env(1) # move up
rlbase_env(2) # move down
rlbase_env(3) # move left
rlbase_env(4) # move right
```

## Notes on Design

### Reinforcement Learning

This package does not intend to reinvent a fully usable reinforcement learning API. Instead, all the games in this package provide the bare minimum of what is needed to for the game logic, which is the ability to reset an environment using `GW.reset!(env)` and to perform actions in the environment using `GW.act!(env, action)`. In order to utilize such a game for reinforcement learning, you would probably be using a higher level reinforcement learning API like the one offered by the `ReinforcementLearning.jl` package (`RLBase` API), for example. As of this writing, all the environments provide a default implementation for the `RLBase` API, which means that you can easily wrap a game from `GridWorlds.jl` and use it directly with the rest of the `ReinforcementLearning.jl` ecosystem.

1. ### States

    There are a few possible options for representing the state/observation for an environment. You can use the entire tile map. You can also augment that with other environment specific information like the agent's direction, target (in `GoToTargetUndirected`) etc. In several games, you can also use the `GW.get_sub_tile_map!` function to get a partial view of the tile map to be used as the observation.

    All environemnts provide a default implementation of the `RLBase.state` function. It is recommended that before performing reinforcement learning experiments using an environment, you carefully understand the information contained in the state representation for that environment.

1. ### Actions

    As of this writing, all actions in all environments are discrete. And so, to keep things simple and consistent, they are represented by elements of `Base.OneTo(NUM_ACTIONS)` (basically integers going from 1 to NUM_ACTIONS). In order to know which action does what, you can call `GW.get_action_names(env)` to get a list of names which gives a better description. For example:

    ```
    julia> env = GW.SingleRoomUndirectedModule.SingleRoomUndirected();

    julia> GW.get_action_names(env)
    (:MOVE_UP, :MOVE_DOWN, :MOVE_LEFT, :MOVE_RIGHT)
    ```

    The order of elements in this list corresponds to that of the actions.

1. ### Rewards and Termination

    As mentioned before, in order to use these for reinforcement learning experiments, you would mostly be using a higher level API like `RLBase`, which should already provide a way to get these values. For example, in RLBase, rewards can be accessed using `RLBase.reward(env)` and checking whether an environment has terminated or not can by done by calling `RLBase.is_terminated(env)`. In case you are using some other API and need more direct control, it is better to take a look at the implementation for that environment to access things like reward and check for termination.

### Tile Map

Each environment contains a tile map, which is a `BitArray{3}` that encodes information about the presence or absence of objects in the grid world. It is of size `(num_objects, height, width)`. The second and third dimensions correspond to positions along the height and width of the tile map. The first dimension corresponds to the presence or absence of objects at a particular position using a multi-hot encoding along the first dimension. You can get the name and ordering of objects along the first dimension of the tile map by using the following method:

```
julia> env = GW.SingleRoomUndirectedModule.SingleRoomUndirected();

julia> GW.get_object_names(env)
(:AGENT, :WALL, :GOAL)
```

### Navigation

Several environments contain the word `Undirected` or `Directed` within their name. This refers to the navigation style of the agent. `Undirected` means that the agent has no direction associated with it, and navigates around by directly moving up, down, left, or right on the tile map. `Directed` means that the agent has a direction associated with it, and it navigates around by moving forward or backward along its current direction, or it could also turn left or right with respect to its current direction. There are 4 directions - `UP`, `DOWN`, `LEFT`, and `RIGHT`.

### Playing and Recording

All the environments can be played directly inside the REPL. These interactive sessions can also be recorded in plain text files and replayed in the terminal. There are two ways to replay a recording:
1. The default way is to manually step through each recorded frame. This allows you to move through the frames one by one at your own pace using keyboard inputs.
1. The second way is to replay the frames at a given frame rate. This would loop through all the frames once and then (and only then) exit the replay.

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
