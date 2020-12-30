# GridWorlds

This package aims to provide grid world environments (like [gym-minigrid](https://github.com/maximecb/gym-minigrid)) for reinforcement learning research in Julia. The focus of this package is on being **lightweight** and **efficient**.

### Table of contents:

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
  1. [GoToDoor](#gotodoor)
  1. [DoorKey](#doorkey)
  1. [CollectGems](#collectgems)
  1. [DynamicObstacles](#dynamicobstacles)
  1. [Sokoban](#sokoban)

### Getting Started

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

#### Reinforcement Learing API for the environments

This package uses the API provided in [`ReinforcementLearningBase.jl`](https://github.com/JuliaReinforcementLearning/ReinforcementLearningBase.jl) so that it can seamlessly work with the rest of the [JuliaReinforcementLearning](https://github.com/JuliaReinforcementLearning) ecosystem.

#### Representation of a grid-world

A grid-world environment struct contains within it an instance of `GridWorldBase`, which represents the grid-world.
An instance of `GridWorldBase` contains a 3-D boolean array (`BitArray{3}`) of size `(num_objects, height, width)`. Each tile of the grid can have multiple objects in it, as indicated by a multi-hot encoding along the first dimension of the `BitArray{3}`.

#### Customizing an existing environment

The behaviour of environments is easily customizable. For example, the default implementation of the `ReinforcementLearingBase.reset!` method for an environment is appropriately randomized (like the goal position and agent start position in `EmptyRoom`). In case you need some custom behaviour, you can do so by simply override the `ReinforcementLearningBase.reset!` method, and reusing the rest of the behaviour (like what happens upon taking some action) off the shelf.

#### Rendering

`GridWorlds.jl` offers two modes of rendering:

1. ##### Terminal Rendering

    While rendering a gridworld environment in the terminal, we display only one character per tile. If multiple objects are present in the same tile, we go by a priority implied by the order of the corresponding objects (lower the index, higher the priority) in the `objects` attribute (which is a tuple, and hence it is ordered) of the `GridWorldBase` instance.

    For example, if the value of the `objects` attribute is `(DIRECTION_LESS_AGENT, EMPTY, WALL, DOOR)`, and if a tile contains both `DIRECTION_LESS_AGENT` and `DOOR` (say when the agent is crossing the door), then the character corresponding to the `DIRECTION_LESS_AGENT` will be displayed on the terminal for that tile.

    A rendered environment looks something like this on the terminal:
    
    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/EmptyRoom.png" width="300px">
    
1. ##### Makie Rendering

    If available, one can optionally use [`Makie.jl`](https://github.com/JuliaPlots/Makie.jl) in order to render an environment, play with it interactively, and save animations. See the examples given below in List of Environments.

## List of Environments

1. #### EmptyRoom

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/EmptyRoom.gif" width="300px">

1. #### GridRooms

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/GridRooms.gif" width="300px">

1. #### SequentialRooms

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/SequentialRooms.gif" width="300px">

1. #### GoToDoor

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/GoToDoor.gif" width="300px">

1. #### DoorKey

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/DoorKey.gif" width="300px">

1. #### CollectGems

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/CollectGems.gif" width="300px">

1. #### DynamicObstacles

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/DynamicObstacles.gif" width="300px">
 
1. #### Sokoban

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/Sokoban.gif" width="300px">
