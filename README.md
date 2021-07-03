# GridWorlds

A package for creating grid world environments for reinforcement learning in Julia. This package is designed to be lightweight and fast.

This package is inspired by [gym-minigrid](https://github.com/maximecb/gym-minigrid). In order to cite this package, please refer to the file `CITATION.bib`. Starring the repository on GitHub is also appreciated.

**Important note:** This package is undergoing heavy internal redesign. This README reflects the new design. The README for the last released version (`0.4.0`) can be found [here](https://github.com/JuliaReinforcementLearning/GridWorlds.jl/tree/c0e86bb6c33819f0e4a4cefe0284d985d0474ed3).

## Table of contents:

* [Getting Started](#getting-started)
* [Playing and Recording](#playing-and-recording)

[List of Environments](#list-of-environments)
1. [SingleRoomUndirected](#singleroomundirected)
1. [SingleRoomDirected](#singleroomdirected)
1. [GridRoomsUndirected](#gridroomsundirected)
1. [GridRoomsDirected](#gridroomsdirected)

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
