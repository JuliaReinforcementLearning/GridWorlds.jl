# GridWorlds

This project aims to provide some simple grid world environments similar to [gym-minigrid](https://github.com/maximecb/gym-minigrid) for reinforcement learning research in Julia.

## Design

### API

`GridWorlds.jl` uses the API provided in [`ReinforcementLearningBase.jl`](https://github.com/JuliaReinforcementLearning/ReinforcementLearningBase.jl) so that it can seamlessly work with the rest of the [JuliaReinforcementLearning](https://github.com/JuliaReinforcementLearning) ecosystem.

### Implementation

A `GridWorldBase` is used to represent the whole grid world. Inside of it, a 3-D `BitArray` of size `(n_objects, height, width)` is used to encode objects in each tile.

### Rendering

`GridWorlds.jl` offers two modes of rendering:

1. Terminal Rendering

    While rendering a gridworld in the terminal, we display only one character per grid cell. If multiple objects are present in the same cell location, we go by a priority implied by the indices of the corresponding objects in the `objects` attribute (which is a tuple, and hence it is ordered) of the `GridWorldBase` instance.

    For example, if the value of the `objects` attribute is `(AGENT, DOOR)` and if a cell contains both the agent and a door, then the character corresponding to the `AGENT` will be displayed.

1. Makie Rendering

    If available, one can optionally use [`Makie.jl`](https://github.com/JuliaPlots/Makie.jl) to render and save animations. See examples given below in the List of Environments.

## Usage

```julia
using GridWorlds

w = EmptyGridWorld()

w(MOVE_FORWARD)
w(TURN_LEFT)
w(TURN_RIGHT)

# play interactively with Makie.
# you need to manually install Makie with the following command first
# ] add Makie
# first time plot may be slow
using Makie
play(w;file_name="example.gif",frame_rate=5)
```

## List of Environments

1. ### EmptyGridWorld

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/EmptyGridWorld.gif" width="300px">

1. ### FourRooms

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/FourRooms.gif" width="300px">

1. ### GoToDoor

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/GoToDoor.gif" width="300px">

1. ### DoorKey

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/DoorKey.gif" width="300px">

1. ### CollectGems

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/CollectGems.gif" width="300px">

1. ### DynamicObstacles

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/DynamicObstacles.gif" width="300px">

1. ### MultiRoom

    <img src="https://github.com/JuliaReinforcementLearning/GridWorlds.jl/raw/master/docs/src/assets/img/MultiRoom.gif" width="300px">
