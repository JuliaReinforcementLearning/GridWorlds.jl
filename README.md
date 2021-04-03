# GridWorlds

A package for creating grid world environments for reinforcement learning in Julia. The focus of this package is on being **lightweight** and **efficient**.

This package is inspired by [gym-minigrid](https://github.com/maximecb/gym-minigrid). In order to cite this package, please refer to the file `CITATION.bib`. Starring the repository on GitHub is also appreciated. For benchmarks, refer to `benchmark/benchmark.md`.

## Table of contents:

* [Getting Started](#getting-started)
* [Design](#design)
  - [Reinforcement Learing API for the environments](#reinforcement-learing-api-for-the-environments)
  - [Representation of an environment](#representation-of-an-environment)
  - [Customizing an existing environment](#customizing-an-existing-environment)
  - [Rendering](#rendering)
    1. [Terminal Rendering](#terminal-rendering)
    1. [Makie Rendering](#makie-rendering)
* [List of Environments](#list-of-environments)
  1. [EmptyRoomDirected](#emptyroomdirected)
  1. [EmptyRoomUndirected](#emptyroomundirected)
  1. [GridRoomsDirected](#gridroomsdirected)
  1. [GridRoomsUndirected](#gridroomsundirected)
  1. [SequentialRoomsDirected](#sequentialroomsdirected)
  1. [SequentialRoomsUndirected](#sequentialroomsundirected)
  1. [MazeDirected](#mazedirected)
  1. [MazeUndirected](#mazeundirected)
  1. [GoToTargetDirected](#gototargetdirected)
  1. [GoToTargetUndirected](#gototargetundirected)
  1. [DoorKeyDirected](#doorkeydirected)
  1. [DoorKeyUndirected](#doorkeyundirected)
  1. [CollectGemsDirected](#collectgemsdirected)
  1. [CollectGemsUndirected](#collectgemsundirected)
  1. [DynamicObstaclesDirected](#dynamicobstaclesdirected)
  1. [DynamicObstaclesUndirected](#dynamicobstaclesundirected)
  1. [SokobanDirected](#sokobandirected)
  1. [SokobanUndirected](#sokobanundirected)
  1. [Snake](#snake)
  1. [Catcher](#catcher)
  1. [TransportDirected](#transport)
  1. [TransportUndirected](#transportundirected)

## Getting Started

```julia
import GridWorlds

env = GridWorlds.EmptyRoomDirected()

env(GridWorlds.MOVE_FORWARD)
env(GridWorlds.TURN_LEFT)
env(GridWorlds.TURN_RIGHT)

import ReinforcementLearningBase

ReinforcementLearningBase.state(env)
ReinforcementLearningBase.action_space(env)
ReinforcementLearningBase.reward(env)
ReinforcementLearningBase.is_terminated(env)
ReinforcementLearningBase.reset!(env)

# play interactively using Makie.jl
# you need to first manually install Makie.jl with the following command
# ] add Makie
# first time plot may be slow
import Makie

GridWorlds.play(env, file_name = "example.gif", frame_rate = 24)
```

## Design

### Reinforcement Learing API for the environments

This package uses the API provided in [`ReinforcementLearningBase.jl`](https://github.com/JuliaReinforcementLearning/ReinforcementLearningBase.jl) so that it can seamlessly work with the rest of the [JuliaReinforcementLearning](https://github.com/JuliaReinforcementLearning) ecosystem.

### Representation of an environment

An environment instance (often named `env`) contains within it an instance of `GridWorldBase` (often named `world`). A `world` contains a 3-D boolean array (which is a `BitArray{3}` and is often named `grid`) of size `(num_objects, height, width)`. Each tile of the `grid` can have multiple objects in it, as represented by a multi-hot encoding along the first dimension of the `grid`. The objects contained in the `world` do not contain any fields. Any information related to such objects that needs to be stored is cached separately as fields of `env`.

### Customizing an existing environment

The behaviour of environments is easily customizable. Here are some of the things that one may typically want to customize:

1. Keyword arguments allow for enough flexibility in most environments. For example, most environments allow creation of rectangular worlds.
1. Of course, one can also override the `ReinforcementLearningBase` (`RLBase`) API methods directly for a greater degree of customization. For example, the default implementation of the `RLBase.reset!` method for an environment is appropriately randomized (like the goal position and agent start position in the EmptyRoom environment). In case one needs some other behaviour, one can do so by simply overriding this particular method, and reuse the rest of the behaviour as it is (like the effects of actions in this environment).
1. Most environments offer multiple state representations. One can modify the `RLBase.StateStyle(env)` method to choose to partially observe (`RLBase.StateStyle(env)` returns `RLBase.Observation{Any}()`) or fully observe (`RLBase.StateStyle(env)` returns `RLBase.InternalState{Any}()`) the current state of an environment. During rendering, some environments display a gray shaded area surrounding the agent's character. The shaded area corresponds to the region of the `grid` that is observed via `RLBase.state(env)` in partially observable settings (when `RLBase.StateStyle(env)` is set to return `RLBase.Observation{Any}()`). In the case of fully observable environments (`RLBase.StateStyle(env)` returns `RLBase.InternalState{Any}()`), the entire `grid` is returned as part of `RLBase.state(env)`. For `Directed` environments, the direction of the agent is not encoded inside the `grid`. So when fully observing the environment using `RLBase.InternalState{Any}()`, `RLBase.state(env)` would return the direction of the agent separately.

Here is the `EmptyRoomUndirected` environment with `RLBase.Observation{Any}()`:
    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/observation.png" width="300px">

Here is the `EmptyRoomUndirected` environment with `RLBase.InternalState{Any}()`:
    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/internal_state.png" width="300px">

For more details, it is highly recommended that you take a look at the source code of the particular environment that you are working with.

### Rendering

`GridWorlds.jl` offers two modes of rendering:

1. #### Textual Rendering

    This mode can be used directly in the terminal to render an environment. In this mode, we can display only one character per tile. If multiple objects are present in the same tile, then the object with the least index in the `objects` field of `world` is chosen. For example, if `world.objects` is `(GridWorlds.Agent(), GridWorlds.Wall(), GridWorlds.Goal())` and if both `Agent` and `Goal` are present on a tile, then the character for `Agent` will be rendered for that particular tile.

    Here is an example of a textual rendering of the `SequentialRoomsDirected` environment:

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/textual_rendering.png" width="300px">

1. #### Graphical Rendering

    If available, one can optionally use [`Makie.jl`](https://github.com/JuliaPlots/Makie.jl) in order to render an environment graphically. It is also possible to play with an environment interactively, and save animations of the same. See the examples given below in [List of Environments](#list-of-environments).

## List of Environments

1. ### EmptyRoomDirected

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/empty_room_directed.gif" width="300px">

1. ### EmptyRoomUndirected

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/empty_room_undirected.gif" width="300px">

1. ### GridRoomsDirected

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/grid_rooms_directed.gif" width="300px">

1. ### GridRoomsUndirected

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/grid_rooms_undirected.gif" width="300px">

1. ### SequentialRoomsDirected

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/sequential_rooms_directed.gif" width="300px">

1. ### SequentialRoomsUndirected

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/sequential_rooms_undirected.gif" width="300px">

1. ### MazeDirected

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/maze_directed.gif" width="300px">

1. ### MazeUndirected

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/maze_undirected.gif" width="300px">

1. ### GoToTargetDirected

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/go_to_target_directed.gif" width="300px">

1. ### GoToTargetUndirected

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/go_to_target_undirected.gif" width="300px">

1. ### DoorKeyDirected

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/door_key_directed.gif" width="300px">

1. ### DoorKeyUndirected

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/door_key_undirected.gif" width="300px">

1. ### CollectGemsDirected

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/collect_gems_directed.gif" width="300px">

1. ### CollectGemsUndirected

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/collect_gems_undirected.gif" width="300px">

1. ### DynamicObstaclesDirected

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/dynamic_obstacles_directed.gif" width="300px">

1. ### DynamicObstaclesUndirected

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/dynamic_obstacles_undirected.gif" width="300px">
 
1. ### SokobanDirected

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/sokoban_directed.gif" width="300px">

1. ### SokobanUndirected

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/sokoban_undirected.gif" width="300px">

1. ### Snake

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/snake.gif" width="300px">

1. ### Catcher

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/catcher.gif" width="300px">
 
1. ### TransportDirected

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/transport_directed.gif" width="300px">

1. ### TransportUndirected

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/transport_undirected.gif" width="300px">
