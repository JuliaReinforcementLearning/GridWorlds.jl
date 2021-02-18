# GridWorlds

A package for creating grid world environments for reinforcement learning in Julia. The focus of this package is on being **lightweight** and **efficient**.

This package is inspired by [gym-minigrid](https://github.com/maximecb/gym-minigrid). In order to cite this package, please refer to the file `CITATION.bib`. Starring the repository on GitHub is also appreciated. For benchmarks, refer to `benchmark/benchmark.md`.

## Table of contents:

* [Getting Started](#getting-started)
* [Design](#design)
  - [Reinforcement Learing API for the environments](#reinforcement-learing-api-for-the-environments)
  - [Representation of a grid-world](#representation-of-a-grid-world)
  - [Customizing an existing environment](#customizing-an-existing-environment)
  - [Rendering](#rendering)
    1. [Terminal Rendering](#terminal-rendering)
    1.  [Makie Rendering](#makie-rendering)
* [List of Environments](#list-of-environments)
  1. [EmptyRoom](#emptyroom)
  1. [GridRooms](#gridrooms)
  1. [SequentialRooms](#sequentialrooms)
  1. [Maze](#maze)
  1. [GoToDoor](#gotodoor)
  1. [DoorKey](#doorkey)
  1. [CollectGems](#collectgems)
  1. [DynamicObstacles](#dynamicobstacles)
  1. [Sokoban](#sokoban)
  1. [Catcher](#catcher)
  1. [Snake](#snake)

## Getting Started

```julia
using GridWorlds

env = EmptyRoom()

env(MOVE_FORWARD)
env(TURN_LEFT)
env(TURN_RIGHT)

using ReinforcementLearningBase

state(env)
action_space(env)
reward(env)
is_terminated(env)
reset!(env)

# play interactively using Makie.jl
# you need to first manually install Makie.jl with the following command
# ] add Makie
# first time plot may be slow
using Makie
play(env, file_name = "example.gif", frame_rate = 5)
```

## Design

### Reinforcement Learing API for the environments

This package uses the API provided in [`ReinforcementLearningBase.jl`](https://github.com/JuliaReinforcementLearning/ReinforcementLearningBase.jl) so that it can seamlessly work with the rest of the [JuliaReinforcementLearning](https://github.com/JuliaReinforcementLearning) ecosystem.

### Representation of a grid-world

A grid-world environment instance (often named `env`) contains within it an instance of `GridWorldBase` (often named `world`), which represents the grid-world. A `world` contains a 3-D boolean array (`BitArray{3}`) (often named `grid`) of size `(num_objects, height, width)`. Each tile of the `grid` can have multiple objects in it, indicated by a multi-hot encoding along the first dimension of the `grid`. The objects in the `world` do not contain any fields. Any related information for such objects that is needed is cached separately as fields of `env`.

`env` contains fields called `world` and `agent` (along with some other fields). The point here is to note that an `agent` is stored separately as a field in `env` instead of an object contained in `world`. You *can* create a custom field-less agent object and store it in the `world` if you want, but we usually store it as a field in the `env`, since an `agent` often has other information that need caching.

### Customizing an existing environment

The behaviour of environments is easily customizable. Here are some of the things that one may typically want to customize:

1. Keyword arguments allow for enough flexibility in most environments. For example, most environments allow creation of rectangular worlds.
1. You can set the navigation style trait (for environments where it makes sense) by `GridWorlds.get_navigation_style(::Type{<:SomeEnv}) = GridWorlds.DIRECTED_NAVIGATION` or `GridWorlds.get_navigation_style(::Type{<:SomeEnv}) = GridWorlds.UNDIRECTED_NAVIGATION`.
1. You can override specific `ReinforcementLearningBase` methods for customization. For example, the default implementation of the `ReinforcementLearingBase.reset!` method for an environment is appropriately randomized (like the goal position and agent start position in `EmptyRoom`). In case you need some custom behaviour, you can do so by simply overriding the `ReinforcementLearningBase.reset!` method, and reusing the rest of the behaviour (like what happens upon taking some action) as it is. You may also want to customize the `ReinforcementLearningBase.state` method to return the entire grid, or only the agent's view, or anything else you wish. See [RLBase API defaults](https://github.com/JuliaReinforcementLearning/GridWorlds.jl/blob/2e8975c85ce3534c2151121a0791be1ec53a8d31/src/abstract_grid_world.jl#L64) in `abstract_grid_world.jl` for examples.

### Rendering

`GridWorlds.jl` offers two modes of rendering:

1. #### Terminal Rendering

    While rendering a gridworld environment in the terminal, we display only one character per tile. If multiple objects are present in the same tile, we go by a priority implied by the order of the corresponding objects (lower the index, higher the priority) in the `objects` attribute (which is a tuple, and hence it is ordered) of the `GridWorldBase` instance.

    For example, if the value of the `objects` attribute is `(DIRECTION_LESS_AGENT, EMPTY, WALL, DOOR)`, and if a tile contains both `DIRECTION_LESS_AGENT` and `DOOR` (say when the agent is crossing the door), then the character corresponding to the `DIRECTION_LESS_AGENT` will be displayed on the terminal for that tile.

    A rendered environment looks something like this on the terminal:
    
    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/EmptyRoom.png" width="300px">
    
1. #### Makie Rendering

    If available, one can optionally use [`Makie.jl`](https://github.com/JuliaPlots/Makie.jl) in order to render an environment, play with it interactively, and save animations. See the examples given below in List of Environments.

## List of Environments

1. ### EmptyRoom

    DirectedNavigation | UndirectedNavigation
    ------------ | -------------
    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/empty_room_directed.gif" width="300px"> | <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/empty_room_undirected.gif" width="300px">

1. ### GridRooms

    DirectedNavigation | UndirectedNavigation
    ------------ | -------------
    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/grid_rooms_directed.gif" width="300px"> | <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/grid_rooms_undirected.gif" width="300px">

1. ### SequentialRooms

    DirectedNavigation | UndirectedNavigation
    ------------ | -------------
    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/sequential_rooms_directed.gif" width="300px"> | <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/sequential_rooms_undirected.gif" width="300px">

1. ### Maze

    DirectedNavigation | UndirectedNavigation
    ------------ | -------------
    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/maze_directed.gif" width="300px"> | <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/maze_undirected.gif" width="300px">

1. ### GoToDoor

    DirectedNavigation | UndirectedNavigation
    ------------ | -------------
    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/go_to_door_directed.gif" width="300px"> | <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/go_to_door_undirected.gif" width="300px">

1. ### DoorKey

    DirectedNavigation | UndirectedNavigation
    ------------ | -------------
    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/door_key_directed.gif" width="300px"> | <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/door_key_undirected.gif" width="300px">

1. ### CollectGems

    DirectedNavigation | UndirectedNavigation
    ------------ | -------------
    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/collect_gems_directed.gif" width="300px"> | <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/collect_gems_undirected.gif" width="300px">

1. ### DynamicObstacles

    DirectedNavigation | UndirectedNavigation
    ------------ | -------------
    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/dynamic_obstacles_directed.gif" width="300px"> | <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/dynamic_obstacles_undirected.gif" width="300px">
 
1. ### Sokoban

    DirectedNavigation | UndirectedNavigation
    ------------ | -------------
    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/sokoban_directed.gif" width="300px"> | <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/sokoban_undirected.gif" width="300px">

1. ### Snake

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/snake.gif" width="300px">

1. ### Catcher

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/catcher.gif" width="300px">
