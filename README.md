# Gridworld

This project aims to provide some simple grid world environments similar to [gym-minigrid]https://github.com/maximecb/gym-minigrid) for reinforcement learning research in Julia.

## Design

A `GridWorldBase` is used to represent the whole grid world. Inside of it, a 3-D `BitArray` of size `(n_objects, height, width)` is used to encode objects in each tile.

## Usage

```julia
julia> using Gridworld

julia> w = EmptyGridWorld()
World:
████████
█→⋅⋅⋅⋅⋅█
█⋅⋅⋅⋅⋅⋅█
█⋅⋅⋅⋅⋅⋅█
█⋅⋅⋅⋅⋅⋅█
█⋅⋅⋅⋅⋅⋅█
█⋅⋅⋅⋅⋅♥█
████████

Agent's view:
⋅⋅⋅↓█__
⋅⋅⋅⋅█__
⋅⋅⋅⋅█__
⋅⋅⋅⋅█__
⋅⋅⋅⋅█__
⋅⋅⋅⋅█__
█████__

julia> w(MOVE_FORWARD)
World:
████████
█⋅→⋅⋅⋅⋅█
█⋅⋅⋅⋅⋅⋅█
█⋅⋅⋅⋅⋅⋅█
█⋅⋅⋅⋅⋅⋅█
█⋅⋅⋅⋅⋅⋅█
█⋅⋅⋅⋅⋅♥█
████████

Agent's view:
⋅⋅⋅↓█__
⋅⋅⋅⋅█__
⋅⋅⋅⋅█__
⋅⋅⋅⋅█__
⋅⋅⋅⋅█__
█████__
_______

julia> play(w)  # you can also play interactively with the help of Makie
```

## TODO

### Environment list

- [x] EmptyGridWorld
- [x] FourRooms
- [x] GoToDoor
- 

### Needs improvement

- [ ] Add test cases
- [ ] Benchmark (ensure our implementations do not have significant performance issues)
- [ ] A wrapper for ReinforcementLearningBase.jl
- [ ] Gif/Video writer
