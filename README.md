# GridWorlds

A package for creating grid world environments for reinforcement learning in Julia. This package is designed to be lightweight and fast.

This package is inspired by [gym-minigrid](https://github.com/maximecb/gym-minigrid). In order to cite this package, please refer to the file `CITATION.bib`. Starring the repository on GitHub is also appreciated. For benchmarks, refer to `benchmarks/benchmarks.md`.

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

# reset the environment. All environments are randomized

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

<img src="https://user-images.githubusercontent.com/32610387/126912986-83c112e4-feb2-4953-a4dc-06f7d67bb023.gif">

## List of Environments

1. ### SingleRoomUndirected

    <img src="https://user-images.githubusercontent.com/32610387/126909935-d6a1d303-9925-4fc9-9a9f-025fc133c64c.png">
    <img src="https://user-images.githubusercontent.com/32610387/126909804-b53f43a7-98d0-4d53-874e-d8988494ae53.gif">

    The objective of the agent is to navigate its way to the goal. When the agent reaches the goal, it receives a reward of 1 and the environment terminates.

1. ### SingleRoomDirected

    <img src="https://user-images.githubusercontent.com/32610387/126909946-b0b00a56-c48a-4e17-9aaf-08c054e72f9a.png">
    <img src="https://user-images.githubusercontent.com/32610387/126909809-6b6b37ad-3ccb-41c5-b263-5709e6a322db.gif">

    The objective of the agent is to navigate its way to the goal. When the agent reaches the goal, it receives a reward of 1 and the environment terminates.

1. ### GridRoomsUndirected

    <img src="https://user-images.githubusercontent.com/32610387/126909952-765ed7d4-f91c-4d31-8bfa-6f42fea791b7.png">
    <img src="https://user-images.githubusercontent.com/32610387/126909820-037aa2fb-e332-46d2-8f6e-cea9a138db82.gif">

    The objective of the agent is to navigate its way to the goal. When the agent reaches the goal, it receives a reward of 1 and the environment terminates.

1. ### GridRoomsDirected

    <img src="https://user-images.githubusercontent.com/32610387/126909955-81c9f724-45bb-40cb-ba91-ab124f27fe20.png">
    <img src="https://user-images.githubusercontent.com/32610387/126909822-301db2eb-1bc3-42ce-9fa9-1c305cadb9c3.gif">

    The objective of the agent is to navigate its way to the goal. When the agent reaches the goal, it receives a reward of 1 and the environment terminates.

1. ### SequentialRoomsUndirected

    <img src="https://user-images.githubusercontent.com/32610387/126909957-eaf2340a-f985-4b93-b677-1ad28a9fc671.png">
    <img src="https://user-images.githubusercontent.com/32610387/126909834-c88338b7-06d4-4a78-a48a-84774f2450ff.gif">

    The objective of the agent is to navigate its way to the goal. When the agent reaches the goal, it receives a reward of 1 and the environment terminates.

1. ### SequentialRoomsDirected

    <img src="https://user-images.githubusercontent.com/32610387/126909964-6c011d1a-59a9-4083-952a-ba46a016496f.png">
    <img src="https://user-images.githubusercontent.com/32610387/126909842-f6007d93-59ba-4c2f-ab84-e77bff09ab71.gif">

    The objective of the agent is to navigate its way to the goal. When the agent reaches the goal, it receives a reward of 1 and the environment terminates.

1. ### MazeUndirected

    <img src="https://user-images.githubusercontent.com/32610387/126909969-9b42380a-b96f-4448-be2c-bfe4c8a4a6ae.png">
    <img src="https://user-images.githubusercontent.com/32610387/126909846-c6a86cd3-a80b-4519-a786-0e42beaa34ac.gif">

    The objective of the agent is to navigate its way to the goal. When the agent reaches the goal, it receives a reward of 1 and the environment terminates.

1. ### MazeDirected

    <img src="https://user-images.githubusercontent.com/32610387/126909973-b06a42eb-cf87-40fa-b627-09e08716847f.png">
    <img src="https://user-images.githubusercontent.com/32610387/126909852-4f096c83-11b2-406f-a6fe-64d87e6c1e8d.gif">

    The objective of the agent is to navigate its way to the goal. When the agent reaches the goal, it receives a reward of 1 and the environment terminates.

1. ### GoToTargetUndirected

    <img src="https://user-images.githubusercontent.com/32610387/126909978-63bed874-f994-4278-b6ca-06a5f42e85db.png">
    <img src="https://user-images.githubusercontent.com/32610387/126909857-1b1159c7-df54-4b29-9c59-2bde48e667de.gif">

    The objective of the agent is to navigate its way to the desired target. When the agent reaches the desired target, it receives a reward of 1. When the agent reaches the other target, it receives a reward of -1. In either case, the environment terminates upon reaching a target.

1. ### GoToTargetDirected

    <img src="https://user-images.githubusercontent.com/32610387/126910005-b226bd16-a5b3-46a4-8ed0-4e60e9b8142f.png">
    <img src="https://user-images.githubusercontent.com/32610387/126909863-5d49fb4a-690a-4394-a391-81a5f068210e.gif">

    The objective of the agent is to navigate its way to the desired target. When the agent reaches the desired target, it receives a reward of 1. When the agent reaches the other target, it receives a reward of -1. In either case, the environment terminates upon reaching a target.

1. ### DoorKeyUndirected

    <img src="https://user-images.githubusercontent.com/32610387/126910012-2c802689-0112-4c2b-8f08-cfa33792bece.png">
    <img src="https://user-images.githubusercontent.com/32610387/126909869-4fff6bf7-7f4b-41c2-9710-ab6b76c5d184.gif">

    The objective of the agent is to collect the key and navigate its way to the goal. When the agent reaches the goal, it receives a reward of 1 and the environment terminates. Without picking up the key, the agent will not be able to pass through the door that separtes the agent and goal.

1. ### DoorKeyDirected

    <img src="https://user-images.githubusercontent.com/32610387/126910014-75f94b0a-88c5-462e-b9a8-fe97d537d8e6.png">
    <img src="https://user-images.githubusercontent.com/32610387/126909871-c5951db4-6f2e-469e-a5bc-256038892200.gif">

    The objective of the agent is to collect the key and navigate its way to the goal. When the agent reaches the goal, it receives a reward of 1 and the environment terminates. Without picking up the key, the agent will not be able to pass through the door that separtes the agent and goal.

1. ### CollectGemsUndirected

    <img src="https://user-images.githubusercontent.com/32610387/126910020-3722de31-4fa4-4013-9e4e-b42e77061a84.png">
    <img src="https://user-images.githubusercontent.com/32610387/126909874-15138b3f-25ce-4437-8e7a-eb31844dd228.gif">

    The objective of the agent is to collect all the randomly scattered gems. When the agent collects a gem, it receives a reward of 1. The environment terminates when the agent has collected all the gems.

1. ### CollectGemsDirected

    <img src="https://user-images.githubusercontent.com/32610387/126910021-56c5cf39-4638-456d-ab67-cf442de3f341.png">
    <img src="https://user-images.githubusercontent.com/32610387/126909881-d3aeed2e-0487-43c4-be58-ab43001e45c9.gif">

    The objective of the agent is to collect all the randomly scattered gems. When the agent collects a gem, it receives a reward of 1. The environment terminates when the agent has collected all the gems.

1. ### CollectGemsMultiAgentUndirected

    <img src="https://user-images.githubusercontent.com/32610387/126910026-fcff97b1-f498-4b23-acfe-ffc393fe851e.png">
    <img src="https://user-images.githubusercontent.com/32610387/126909885-fbc10e9c-3247-45ee-a354-946ebc77b513.gif">

    The objective of the agents is to collect all the randomly scattered gems. The agents take turns for performing actions. When an agent collects a gem, the environment gives a reward of 1. The environment terminates when the agents have collected all the gems.

1. ### DynamicObstaclesUndirected

    <img src="https://user-images.githubusercontent.com/32610387/126910030-d93a714d-10b7-4117-887c-773afe78c625.png">
    <img src="https://user-images.githubusercontent.com/32610387/126909888-8fa8473f-deb6-4562-9004-419fa8080693.gif">

    The objective of the agent is to navigate its way to the goal while avoiding collision with obstacles. When the agent reaches the goal, it receives a reward of 1 and the environment terminates. If the agent collides with an obstacle, the agent receives a reward of -1 and the environment terminates.

1. ### DynamicObstaclesDirected

    <img src="https://user-images.githubusercontent.com/32610387/126910033-ee68bd19-06f3-42eb-8606-1042633bbe9b.png">
    <img src="https://user-images.githubusercontent.com/32610387/126909890-9bb101aa-7fc8-4854-a9ad-f87ff81e7f73.gif">

    The objective of the agent is to navigate its way to the goal while avoiding collision with obstacles. When the agent reaches the goal, it receives a reward of 1 and the environment terminates. If the agent collides with an obstacle, the agent receives a reward of -1 and the environment terminates.

1. ### SokobanUndirected

    <img src="https://user-images.githubusercontent.com/32610387/126910035-5746bba6-7692-4ad9-b081-5db34e66f0a5.png">
    <img src="https://user-images.githubusercontent.com/32610387/126909897-621ee9eb-69e8-4be2-a5a2-e15929bd9acd.gif">

    The agent needs to push the boxes onto the target positions. The levels are taken from https://github.com/deepmind/boxoban-levels. Upon each reset, a level is randomly selected from https://github.com/deepmind/boxoban-levels/blob/master/medium/train/000.txt. The level dataset can be dynamically swapped during runtime in case more levels are needed. One way to achieve this while using `ReinforcementLearning.jl` is with the help of [hooks](https://juliareinforcementlearning.org/docs/How_to_use_hooks/).

1. ### SokobanDirected

    <img src="https://user-images.githubusercontent.com/32610387/126910036-b8f5754d-abf6-40b7-b40a-495f528b89b2.png">
    <img src="https://user-images.githubusercontent.com/32610387/126909900-b932420f-176c-4b95-8fff-db5efdf8fc9f.gif">

    The agent needs to push the boxes onto the target positions. The levels are taken from https://github.com/deepmind/boxoban-levels. Upon each reset, a level is randomly selected from https://github.com/deepmind/boxoban-levels/blob/master/medium/train/000.txt. The level dataset can be dynamically swapped during runtime in case more levels are needed. One way to achieve this while using `ReinforcementLearning.jl` is with the help of [hooks](https://juliareinforcementlearning.org/docs/How_to_use_hooks/).

1. ### Snake

    <img src="https://user-images.githubusercontent.com/32610387/126910039-aa960aa8-a1f6-4329-851f-1ebec350a7eb.png">
    <img src="https://user-images.githubusercontent.com/32610387/126909904-63160435-d75b-4510-b439-58f3f419d961.gif">

    The objective of the agent is to eat as many food pellets as possible. As soon as the agent eats a food pellet, the length of its body incrases by one and it receives a reward of 1. When the agent tries to move into a wall or into its body, it receives a reward of `- tile_map_height * tile_map_width` and the environment terminates. When the agent collects all the food pellets possible, it receives a reward of `tile_map_height * tile_map_width` + 1 (for the last food pellet it ate).

1. ### Catcher

    <img src="https://user-images.githubusercontent.com/32610387/126910040-e8e55c02-cb74-4089-b2c1-e5666143687e.png">
    <img src="https://user-images.githubusercontent.com/32610387/126909911-236987ce-12f2-49c8-9b93-2147e7c9ea01.gif">

    The objective of the agent is to keep catching the falling gems for as long as possible. It receives a reward of 1 when it catches a gem and a new gem gets spawned in the next step. When the agent misses catching a gem, it receives a reward of -1 and the environment terminates.

1. ### TransportUndirected

    <img src="https://user-images.githubusercontent.com/32610387/126910044-1e4896f3-8fa9-421d-9a5b-ee90f1b68d81.png">
    <img src="https://user-images.githubusercontent.com/32610387/126909918-87c80ac8-8015-4d96-a2f7-f775692118ac.gif">

    The objective of the agent is to pick up the gem and drop it to the target location. When the agent drops the gem at the target location, it receives a reward of 1 and the environment terminates.

1. ### TransportDirected

    <img src="https://user-images.githubusercontent.com/32610387/126910050-723e100c-c5c7-4703-8eab-5ab86a15e41f.png">
    <img src="https://user-images.githubusercontent.com/32610387/126909921-fdb3c853-4cac-4e6a-b20c-604caf5632e0.gif">

    The objective of the agent is to pick up the gem and drop it to the target location. When the agent drops the gem at the target location, it receives a reward of 1 and the environment terminates.
