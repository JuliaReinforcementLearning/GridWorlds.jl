Date: 2021_04_01_23_28_19
# List of Environments
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
  1. [TransportDirected](#transportdirected)
  1. [TransportUndirected](#transportundirected)

# Benchmarks

# EmptyRoomDirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  2.64 MiB

allocs estimate:  76390

minimum time:     13.941 ms (0.00% GC)

median time:      14.315 ms (0.00% GC)

mean time:        14.784 ms (2.35% GC)

maximum time:     22.721 ms (30.99% GC)

samples:          339

evals/sample:     1

#### GridWorlds.EmptyRoomDirected()

memory estimate:  320 bytes

allocs estimate:  6

minimum time:     753.068 ns (0.00% GC)

median time:      802.417 ns (0.00% GC)

mean time:        850.155 ns (3.59% GC)

maximum time:     46.008 μs (97.81% GC)

samples:          10000

evals/sample:     103

#### RLBase.reset!(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     250.111 ns (0.00% GC)

median time:      274.815 ns (0.00% GC)

mean time:        307.756 ns (0.00% GC)

maximum time:     965.910 ns (0.00% GC)

samples:          10000

evals/sample:     343

#### RLBase.state(env)

memory estimate:  224 bytes

allocs estimate:  5

minimum time:     1.247 μs (0.00% GC)

median time:      1.304 μs (0.00% GC)

mean time:        1.356 μs (0.00% GC)

maximum time:     5.319 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.529 ns (0.00% GC)

median time:      2.631 ns (0.00% GC)

mean time:        2.648 ns (0.00% GC)

maximum time:     34.551 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.814 ns (0.00% GC)

median time:      1.891 ns (0.00% GC)

mean time:        1.925 ns (0.00% GC)

maximum time:     33.608 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.880 ns (0.00% GC)

median time:      1.891 ns (0.00% GC)

mean time:        1.987 ns (0.00% GC)

maximum time:     42.654 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     49.823 ns (0.00% GC)

median time:      94.260 ns (0.00% GC)

mean time:        86.933 ns (0.00% GC)

maximum time:     4.053 μs (0.00% GC)

samples:          10000

evals/sample:     987

#### env(GridWorlds.MoveForward())

memory estimate:  64 bytes

allocs estimate:  2

minimum time:     44.088 ns (0.00% GC)

median time:      48.293 ns (0.00% GC)

mean time:        54.034 ns (7.04% GC)

maximum time:     3.247 μs (98.33% GC)

samples:          10000

evals/sample:     984

#### env(GridWorlds.TurnLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     47.121 ns (0.00% GC)

median time:      92.748 ns (0.00% GC)

mean time:        87.254 ns (0.00% GC)

maximum time:     4.193 μs (0.00% GC)

samples:          10000

evals/sample:     987

# EmptyRoomUndirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  1.68 MiB

allocs estimate:  40006

minimum time:     16.111 ms (0.00% GC)

median time:      16.878 ms (0.00% GC)

mean time:        19.615 ms (0.97% GC)

maximum time:     50.337 ms (0.00% GC)

samples:          256

evals/sample:     1

#### GridWorlds.EmptyRoomUndirected()

memory estimate:  304 bytes

allocs estimate:  6

minimum time:     804.286 ns (0.00% GC)

median time:      1.324 μs (0.00% GC)

mean time:        1.512 μs (3.35% GC)

maximum time:     155.842 μs (98.78% GC)

samples:          10000

evals/sample:     70

#### RLBase.reset!(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     218.552 ns (0.00% GC)

median time:      267.069 ns (0.00% GC)

mean time:        299.351 ns (0.00% GC)

maximum time:     877.237 ns (0.00% GC)

samples:          10000

evals/sample:     451

#### RLBase.state(env)

memory estimate:  144 bytes

allocs estimate:  2

minimum time:     1.734 μs (0.00% GC)

median time:      2.037 μs (0.00% GC)

mean time:        2.469 μs (0.00% GC)

maximum time:     26.670 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.883 ns (0.00% GC)

median time:      2.431 ns (0.00% GC)

mean time:        2.862 ns (0.00% GC)

maximum time:     110.182 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.882 ns (0.00% GC)

median time:      3.605 ns (0.00% GC)

mean time:        3.615 ns (0.00% GC)

maximum time:     94.407 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.897 ns (0.00% GC)

median time:      2.251 ns (0.00% GC)

mean time:        2.902 ns (0.00% GC)

maximum time:     66.840 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.MoveDown())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.915 ns (0.00% GC)

median time:      14.253 ns (0.00% GC)

mean time:        18.481 ns (0.00% GC)

maximum time:     107.582 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveUp())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     13.616 ns (0.00% GC)

median time:      14.773 ns (0.00% GC)

mean time:        18.453 ns (0.00% GC)

maximum time:     134.668 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     13.014 ns (0.00% GC)

median time:      14.855 ns (0.00% GC)

mean time:        19.597 ns (0.00% GC)

maximum time:     359.150 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     13.266 ns (0.00% GC)

median time:      15.819 ns (0.00% GC)

mean time:        20.027 ns (0.00% GC)

maximum time:     222.487 ns (0.00% GC)

samples:          10000

evals/sample:     998

# GridRoomsDirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  2.64 MiB

allocs estimate:  76439

minimum time:     21.186 ms (0.00% GC)

median time:      26.617 ms (0.00% GC)

mean time:        27.830 ms (2.50% GC)

maximum time:     49.223 ms (29.93% GC)

samples:          180

evals/sample:     1

#### GridWorlds.GridRoomsDirected()

memory estimate:  752 bytes

allocs estimate:  11

minimum time:     1.762 μs (0.00% GC)

median time:      2.737 μs (0.00% GC)

mean time:        3.474 μs (3.01% GC)

maximum time:     1.053 ms (99.17% GC)

samples:          10000

evals/sample:     10

#### RLBase.reset!(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     310.702 ns (0.00% GC)

median time:      453.467 ns (0.00% GC)

mean time:        489.874 ns (0.00% GC)

maximum time:     2.830 μs (0.00% GC)

samples:          10000

evals/sample:     228

#### RLBase.state(env)

memory estimate:  224 bytes

allocs estimate:  5

minimum time:     1.735 μs (0.00% GC)

median time:      3.276 μs (0.00% GC)

mean time:        3.210 μs (0.00% GC)

maximum time:     105.686 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.623 ns (0.00% GC)

median time:      3.232 ns (0.00% GC)

mean time:        3.819 ns (0.00% GC)

maximum time:     69.598 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.882 ns (0.00% GC)

median time:      2.888 ns (0.00% GC)

mean time:        3.051 ns (0.00% GC)

maximum time:     87.226 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.032 ns (0.00% GC)

median time:      2.502 ns (0.00% GC)

mean time:        2.738 ns (0.00% GC)

maximum time:     59.860 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     49.860 ns (0.00% GC)

median time:      56.023 ns (0.00% GC)

mean time:        70.317 ns (0.00% GC)

maximum time:     296.118 ns (0.00% GC)

samples:          10000

evals/sample:     986

#### env(GridWorlds.MoveForward())

memory estimate:  64 bytes

allocs estimate:  2

minimum time:     45.092 ns (0.00% GC)

median time:      56.285 ns (0.00% GC)

mean time:        75.202 ns (10.38% GC)

maximum time:     7.661 μs (98.60% GC)

samples:          10000

evals/sample:     989

#### env(GridWorlds.TurnLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     50.102 ns (0.00% GC)

median time:      59.903 ns (0.00% GC)

mean time:        74.151 ns (0.00% GC)

maximum time:     235.176 ns (0.00% GC)

samples:          10000

evals/sample:     987

# GridRoomsUndirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  1.68 MiB

allocs estimate:  40011

minimum time:     15.673 ms (0.00% GC)

median time:      22.272 ms (0.00% GC)

mean time:        22.222 ms (1.14% GC)

maximum time:     42.614 ms (0.00% GC)

samples:          226

evals/sample:     1

#### GridWorlds.GridRoomsUndirected()

memory estimate:  736 bytes

allocs estimate:  11

minimum time:     1.672 μs (0.00% GC)

median time:      3.042 μs (0.00% GC)

mean time:        3.331 μs (2.30% GC)

maximum time:     771.933 μs (99.39% GC)

samples:          10000

evals/sample:     10

#### RLBase.reset!(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     246.338 ns (0.00% GC)

median time:      339.652 ns (0.00% GC)

mean time:        354.142 ns (0.00% GC)

maximum time:     918.152 ns (0.00% GC)

samples:          10000

evals/sample:     349

#### RLBase.state(env)

memory estimate:  144 bytes

allocs estimate:  2

minimum time:     1.384 μs (0.00% GC)

median time:      2.065 μs (0.00% GC)

mean time:        2.195 μs (0.00% GC)

maximum time:     23.217 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.250 ns (0.00% GC)

median time:      2.819 ns (0.00% GC)

mean time:        3.106 ns (0.00% GC)

maximum time:     88.800 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.883 ns (0.00% GC)

median time:      2.425 ns (0.00% GC)

mean time:        3.046 ns (0.00% GC)

maximum time:     669.258 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.896 ns (0.00% GC)

median time:      2.445 ns (0.00% GC)

mean time:        2.930 ns (0.00% GC)

maximum time:     74.129 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.MoveDown())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.912 ns (0.00% GC)

median time:      15.164 ns (0.00% GC)

mean time:        19.424 ns (0.00% GC)

maximum time:     115.689 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveUp())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     13.156 ns (0.00% GC)

median time:      14.596 ns (0.00% GC)

mean time:        19.707 ns (0.00% GC)

maximum time:     137.897 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.602 ns (0.00% GC)

median time:      13.978 ns (0.00% GC)

mean time:        18.676 ns (0.00% GC)

maximum time:     1.224 μs (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     13.080 ns (0.00% GC)

median time:      15.346 ns (0.00% GC)

mean time:        19.351 ns (0.00% GC)

maximum time:     645.208 ns (0.00% GC)

samples:          10000

evals/sample:     998

# SequentialRoomsDirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  218.09 MiB

allocs estimate:  1376292

minimum time:     367.021 ms (8.10% GC)

median time:      393.814 ms (7.86% GC)

mean time:        391.281 ms (8.11% GC)

maximum time:     432.951 ms (7.79% GC)

samples:          13

evals/sample:     1

#### GridWorlds.SequentialRoomsDirected()

memory estimate:  1.23 MiB

allocs estimate:  9441

minimum time:     1.046 ms (0.00% GC)

median time:      2.453 ms (0.00% GC)

mean time:        2.947 ms (9.27% GC)

maximum time:     14.625 ms (57.08% GC)

samples:          1694

evals/sample:     1

#### RLBase.reset!(env)

memory estimate:  1.23 MiB

allocs estimate:  9436

minimum time:     1.101 ms (0.00% GC)

median time:      2.610 ms (0.00% GC)

mean time:        2.956 ms (9.17% GC)

maximum time:     18.374 ms (0.00% GC)

samples:          1691

evals/sample:     1

#### RLBase.state(env)

memory estimate:  240 bytes

allocs estimate:  5

minimum time:     4.732 μs (0.00% GC)

median time:      5.690 μs (0.00% GC)

mean time:        6.670 μs (0.00% GC)

maximum time:     19.707 μs (0.00% GC)

samples:          10000

evals/sample:     7

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.621 ns (0.00% GC)

median time:      3.236 ns (0.00% GC)

mean time:        3.901 ns (0.00% GC)

maximum time:     22.069 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.882 ns (0.00% GC)

median time:      2.555 ns (0.00% GC)

mean time:        2.806 ns (0.00% GC)

maximum time:     264.884 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.881 ns (0.00% GC)

median time:      2.561 ns (0.00% GC)

mean time:        2.745 ns (0.00% GC)

maximum time:     74.297 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     50.617 ns (0.00% GC)

median time:      65.397 ns (0.00% GC)

mean time:        77.930 ns (0.00% GC)

maximum time:     2.906 μs (0.00% GC)

samples:          10000

evals/sample:     987

#### env(GridWorlds.MoveForward())

memory estimate:  64 bytes

allocs estimate:  2

minimum time:     45.934 ns (0.00% GC)

median time:      65.715 ns (0.00% GC)

mean time:        81.767 ns (7.65% GC)

maximum time:     7.345 μs (99.24% GC)

samples:          10000

evals/sample:     988

#### env(GridWorlds.TurnLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     50.378 ns (0.00% GC)

median time:      61.756 ns (0.00% GC)

mean time:        76.810 ns (0.00% GC)

maximum time:     1.297 μs (0.00% GC)

samples:          10000

evals/sample:     987

# SequentialRoomsUndirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  210.98 MiB

allocs estimate:  1322806

minimum time:     325.347 ms (5.55% GC)

median time:      366.535 ms (7.19% GC)

mean time:        373.387 ms (7.19% GC)

maximum time:     417.766 ms (7.34% GC)

samples:          14

evals/sample:     1

#### GridWorlds.SequentialRoomsUndirected()

memory estimate:  1.23 MiB

allocs estimate:  9437

minimum time:     1.094 ms (0.00% GC)

median time:      2.427 ms (0.00% GC)

mean time:        2.808 ms (9.18% GC)

maximum time:     11.631 ms (60.70% GC)

samples:          1777

evals/sample:     1

#### RLBase.reset!(env)

memory estimate:  1.23 MiB

allocs estimate:  9432

minimum time:     1.068 ms (0.00% GC)

median time:      2.400 ms (0.00% GC)

mean time:        2.745 ms (9.33% GC)

maximum time:     12.374 ms (55.17% GC)

samples:          1820

evals/sample:     1

#### RLBase.state(env)

memory estimate:  160 bytes

allocs estimate:  2

minimum time:     5.198 μs (0.00% GC)

median time:      5.786 μs (0.00% GC)

mean time:        6.939 μs (0.00% GC)

maximum time:     36.529 μs (0.00% GC)

samples:          10000

evals/sample:     6

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.883 ns (0.00% GC)

median time:      2.359 ns (0.00% GC)

mean time:        2.932 ns (0.00% GC)

maximum time:     41.688 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.883 ns (0.00% GC)

median time:      4.100 ns (0.00% GC)

mean time:        4.317 ns (0.00% GC)

maximum time:     1.199 μs (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.897 ns (0.00% GC)

median time:      2.240 ns (0.00% GC)

mean time:        2.990 ns (0.00% GC)

maximum time:     33.418 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.MoveDown())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.833 ns (0.00% GC)

median time:      14.603 ns (0.00% GC)

mean time:        18.307 ns (0.00% GC)

maximum time:     417.803 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveUp())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.921 ns (0.00% GC)

median time:      14.745 ns (0.00% GC)

mean time:        18.590 ns (0.00% GC)

maximum time:     58.443 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.576 ns (0.00% GC)

median time:      13.505 ns (0.00% GC)

mean time:        17.166 ns (0.00% GC)

maximum time:     62.597 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.793 ns (0.00% GC)

median time:      14.482 ns (0.00% GC)

mean time:        18.682 ns (0.00% GC)

maximum time:     209.889 ns (0.00% GC)

samples:          10000

evals/sample:     998

# MazeDirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  5.18 MiB

allocs estimate:  102991

minimum time:     25.191 ms (0.00% GC)

median time:      30.756 ms (0.00% GC)

mean time:        32.272 ms (2.89% GC)

maximum time:     51.554 ms (21.02% GC)

samples:          155

evals/sample:     1

#### GridWorlds.MazeDirected()

memory estimate:  26.05 KiB

allocs estimate:  269

minimum time:     30.221 μs (0.00% GC)

median time:      54.619 μs (0.00% GC)

mean time:        65.769 μs (5.43% GC)

maximum time:     8.087 ms (97.89% GC)

samples:          10000

evals/sample:     1

#### RLBase.reset!(env)

memory estimate:  25.73 KiB

allocs estimate:  263

minimum time:     28.717 μs (0.00% GC)

median time:      37.119 μs (0.00% GC)

mean time:        53.571 μs (4.28% GC)

maximum time:     5.203 ms (97.97% GC)

samples:          10000

evals/sample:     1

#### RLBase.state(env)

memory estimate:  224 bytes

allocs estimate:  5

minimum time:     1.721 μs (0.00% GC)

median time:      2.043 μs (0.00% GC)

mean time:        2.436 μs (0.00% GC)

maximum time:     10.055 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.623 ns (0.00% GC)

median time:      2.839 ns (0.00% GC)

mean time:        3.751 ns (0.00% GC)

maximum time:     273.716 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.881 ns (0.00% GC)

median time:      2.313 ns (0.00% GC)

mean time:        2.665 ns (0.00% GC)

maximum time:     173.399 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.881 ns (0.00% GC)

median time:      2.625 ns (0.00% GC)

mean time:        2.742 ns (0.00% GC)

maximum time:     29.498 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     49.940 ns (0.00% GC)

median time:      59.949 ns (0.00% GC)

mean time:        73.329 ns (0.00% GC)

maximum time:     226.462 ns (0.00% GC)

samples:          10000

evals/sample:     985

#### env(GridWorlds.MoveForward())

memory estimate:  64 bytes

allocs estimate:  2

minimum time:     44.694 ns (0.00% GC)

median time:      62.222 ns (0.00% GC)

mean time:        77.584 ns (9.30% GC)

maximum time:     9.614 μs (98.88% GC)

samples:          10000

evals/sample:     989

#### env(GridWorlds.TurnLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     48.817 ns (0.00% GC)

median time:      56.404 ns (0.00% GC)

mean time:        72.468 ns (0.00% GC)

maximum time:     2.861 μs (0.00% GC)

samples:          10000

evals/sample:     988

# MazeUndirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  4.22 MiB

allocs estimate:  66569

minimum time:     17.325 ms (0.00% GC)

median time:      18.445 ms (0.00% GC)

mean time:        20.125 ms (2.45% GC)

maximum time:     40.895 ms (0.00% GC)

samples:          249

evals/sample:     1

#### GridWorlds.MazeUndirected()

memory estimate:  26.03 KiB

allocs estimate:  269

minimum time:     30.180 μs (0.00% GC)

median time:      47.256 μs (0.00% GC)

mean time:        60.488 μs (4.50% GC)

maximum time:     7.903 ms (97.77% GC)

samples:          10000

evals/sample:     1

#### RLBase.reset!(env)

memory estimate:  25.73 KiB

allocs estimate:  263

minimum time:     28.724 μs (0.00% GC)

median time:      39.580 μs (0.00% GC)

mean time:        55.564 μs (4.73% GC)

maximum time:     7.011 ms (96.27% GC)

samples:          10000

evals/sample:     1

#### RLBase.state(env)

memory estimate:  144 bytes

allocs estimate:  2

minimum time:     1.370 μs (0.00% GC)

median time:      1.562 μs (0.00% GC)

mean time:        1.954 μs (0.00% GC)

maximum time:     66.516 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.250 ns (0.00% GC)

median time:      3.442 ns (0.00% GC)

mean time:        3.403 ns (0.00% GC)

maximum time:     36.033 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.882 ns (0.00% GC)

median time:      3.221 ns (0.00% GC)

mean time:        3.273 ns (0.00% GC)

maximum time:     199.165 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.896 ns (0.00% GC)

median time:      2.335 ns (0.00% GC)

mean time:        3.066 ns (0.00% GC)

maximum time:     169.301 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.MoveDown())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.546 ns (0.00% GC)

median time:      15.249 ns (0.00% GC)

mean time:        19.139 ns (0.00% GC)

maximum time:     181.686 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveUp())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.836 ns (0.00% GC)

median time:      14.460 ns (0.00% GC)

mean time:        18.367 ns (0.00% GC)

maximum time:     75.498 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.771 ns (0.00% GC)

median time:      15.762 ns (0.00% GC)

mean time:        19.794 ns (0.00% GC)

maximum time:     364.068 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     13.067 ns (0.00% GC)

median time:      14.601 ns (0.00% GC)

mean time:        18.343 ns (0.00% GC)

maximum time:     98.403 ns (0.00% GC)

samples:          10000

evals/sample:     998

# GoToTargetDirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  2.64 MiB

allocs estimate:  76394

minimum time:     21.292 ms (0.00% GC)

median time:      25.783 ms (0.00% GC)

mean time:        26.881 ms (2.42% GC)

maximum time:     44.801 ms (30.36% GC)

samples:          186

evals/sample:     1

#### GridWorlds.GoToTargetDirected()

memory estimate:  384 bytes

allocs estimate:  8

minimum time:     1.378 μs (0.00% GC)

median time:      2.220 μs (0.00% GC)

mean time:        2.661 μs (0.00% GC)

maximum time:     52.404 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.reset!(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     428.379 ns (0.00% GC)

median time:      558.040 ns (0.00% GC)

mean time:        634.759 ns (0.00% GC)

maximum time:     3.750 μs (0.00% GC)

samples:          10000

evals/sample:     198

#### RLBase.state(env)

memory estimate:  224 bytes

allocs estimate:  5

minimum time:     945.696 ns (0.00% GC)

median time:      1.183 μs (0.00% GC)

mean time:        1.480 μs (2.69% GC)

maximum time:     399.850 μs (99.49% GC)

samples:          10000

evals/sample:     23

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.623 ns (0.00% GC)

median time:      3.979 ns (0.00% GC)

mean time:        4.175 ns (0.00% GC)

maximum time:     64.911 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.881 ns (0.00% GC)

median time:      2.485 ns (0.00% GC)

mean time:        2.635 ns (0.00% GC)

maximum time:     96.914 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.880 ns (0.00% GC)

median time:      2.319 ns (0.00% GC)

mean time:        2.474 ns (0.00% GC)

maximum time:     56.908 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     49.870 ns (0.00% GC)

median time:      57.611 ns (0.00% GC)

mean time:        77.079 ns (0.00% GC)

maximum time:     887.279 ns (0.00% GC)

samples:          10000

evals/sample:     986

#### env(GridWorlds.MoveForward())

memory estimate:  64 bytes

allocs estimate:  2

minimum time:     47.315 ns (0.00% GC)

median time:      74.793 ns (0.00% GC)

mean time:        89.261 ns (8.69% GC)

maximum time:     8.275 μs (99.15% GC)

samples:          10000

evals/sample:     984

#### env(GridWorlds.TurnLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     49.593 ns (0.00% GC)

median time:      59.050 ns (0.00% GC)

mean time:        74.939 ns (0.00% GC)

maximum time:     264.292 ns (0.00% GC)

samples:          10000

evals/sample:     986

# GoToTargetUndirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  1.68 MiB

allocs estimate:  40008

minimum time:     22.119 ms (0.00% GC)

median time:      26.193 ms (0.00% GC)

mean time:        27.039 ms (1.25% GC)

maximum time:     47.600 ms (21.99% GC)

samples:          185

evals/sample:     1

#### GridWorlds.GoToTargetUndirected()

memory estimate:  368 bytes

allocs estimate:  8

minimum time:     1.331 μs (0.00% GC)

median time:      1.815 μs (0.00% GC)

mean time:        2.351 μs (0.00% GC)

maximum time:     19.977 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.reset!(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     356.698 ns (0.00% GC)

median time:      445.922 ns (0.00% GC)

mean time:        510.907 ns (0.00% GC)

maximum time:     1.902 μs (0.00% GC)

samples:          10000

evals/sample:     205

#### RLBase.state(env)

memory estimate:  144 bytes

allocs estimate:  2

minimum time:     1.488 μs (0.00% GC)

median time:      1.774 μs (0.00% GC)

mean time:        2.151 μs (0.00% GC)

maximum time:     8.600 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.624 ns (0.00% GC)

median time:      3.559 ns (0.00% GC)

mean time:        4.137 ns (0.00% GC)

maximum time:     61.547 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.954 ns (0.00% GC)

median time:      2.555 ns (0.00% GC)

mean time:        2.690 ns (0.00% GC)

maximum time:     28.219 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.953 ns (0.00% GC)

median time:      2.431 ns (0.00% GC)

mean time:        2.586 ns (0.00% GC)

maximum time:     20.454 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.MoveDown())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     14.350 ns (0.00% GC)

median time:      15.274 ns (0.00% GC)

mean time:        20.134 ns (0.00% GC)

maximum time:     990.022 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveUp())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     15.649 ns (0.00% GC)

median time:      23.638 ns (0.00% GC)

mean time:        23.311 ns (0.00% GC)

maximum time:     99.913 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     14.714 ns (0.00% GC)

median time:      15.794 ns (0.00% GC)

mean time:        20.358 ns (0.00% GC)

maximum time:     82.704 ns (0.00% GC)

samples:          10000

evals/sample:     997

#### env(GridWorlds.MoveRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     15.049 ns (0.00% GC)

median time:      19.764 ns (0.00% GC)

mean time:        22.688 ns (0.00% GC)

maximum time:     384.934 ns (0.00% GC)

samples:          10000

evals/sample:     998

# DoorKeyDirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  2.60 MiB

allocs estimate:  74894

minimum time:     20.190 ms (0.00% GC)

median time:      22.978 ms (0.00% GC)

mean time:        23.960 ms (2.22% GC)

maximum time:     40.362 ms (20.76% GC)

samples:          209

evals/sample:     1

#### GridWorlds.DoorKeyDirected()

memory estimate:  528 bytes

allocs estimate:  8

minimum time:     1.436 μs (0.00% GC)

median time:      1.939 μs (0.00% GC)

mean time:        2.722 μs (3.15% GC)

maximum time:     860.355 μs (99.65% GC)

samples:          10000

evals/sample:     10

#### RLBase.reset!(env)

memory estimate:  80 bytes

allocs estimate:  1

minimum time:     439.066 ns (0.00% GC)

median time:      652.240 ns (0.00% GC)

mean time:        713.787 ns (1.13% GC)

maximum time:     33.206 μs (97.56% GC)

samples:          10000

evals/sample:     198

#### RLBase.state(env)

memory estimate:  224 bytes

allocs estimate:  5

minimum time:     1.393 μs (0.00% GC)

median time:      1.765 μs (0.00% GC)

mean time:        2.055 μs (0.00% GC)

maximum time:     10.158 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.882 ns (0.00% GC)

median time:      2.293 ns (0.00% GC)

mean time:        2.648 ns (0.00% GC)

maximum time:     20.918 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.248 ns (0.00% GC)

median time:      2.816 ns (0.00% GC)

mean time:        2.928 ns (0.00% GC)

maximum time:     29.378 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.897 ns (0.00% GC)

median time:      4.412 ns (0.00% GC)

mean time:        4.939 ns (0.00% GC)

maximum time:     627.964 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     50.872 ns (0.00% GC)

median time:      83.221 ns (0.00% GC)

mean time:        81.881 ns (0.00% GC)

maximum time:     2.737 μs (0.00% GC)

samples:          10000

evals/sample:     987

#### env(GridWorlds.PickUp())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.903 ns (0.00% GC)

median time:      15.048 ns (0.00% GC)

mean time:        19.407 ns (0.00% GC)

maximum time:     85.790 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveForward())

memory estimate:  64 bytes

allocs estimate:  2

minimum time:     50.302 ns (0.00% GC)

median time:      78.794 ns (0.00% GC)

mean time:        91.472 ns (9.21% GC)

maximum time:     8.166 μs (98.85% GC)

samples:          10000

evals/sample:     984

#### env(GridWorlds.TurnLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     50.766 ns (0.00% GC)

median time:      62.908 ns (0.00% GC)

mean time:        75.318 ns (0.00% GC)

maximum time:     191.966 ns (0.00% GC)

samples:          10000

evals/sample:     987

# DoorKeyUndirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  1.69 MiB

allocs estimate:  40108

minimum time:     24.312 ms (0.00% GC)

median time:      28.160 ms (0.00% GC)

mean time:        28.764 ms (1.15% GC)

maximum time:     47.078 ms (25.87% GC)

samples:          174

evals/sample:     1

#### GridWorlds.DoorKeyUndirected()

memory estimate:  512 bytes

allocs estimate:  8

minimum time:     1.360 μs (0.00% GC)

median time:      1.771 μs (0.00% GC)

mean time:        2.341 μs (3.96% GC)

maximum time:     933.003 μs (99.44% GC)

samples:          10000

evals/sample:     10

#### RLBase.reset!(env)

memory estimate:  80 bytes

allocs estimate:  1

minimum time:     353.176 ns (0.00% GC)

median time:      674.407 ns (0.00% GC)

mean time:        667.685 ns (1.25% GC)

maximum time:     40.074 μs (97.99% GC)

samples:          10000

evals/sample:     205

#### RLBase.state(env)

memory estimate:  144 bytes

allocs estimate:  2

minimum time:     1.198 μs (0.00% GC)

median time:      1.339 μs (0.00% GC)

mean time:        1.364 μs (0.00% GC)

maximum time:     6.369 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.530 ns (0.00% GC)

median time:      2.633 ns (0.00% GC)

mean time:        2.801 ns (0.00% GC)

maximum time:     54.819 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.954 ns (0.00% GC)

median time:      2.809 ns (0.00% GC)

mean time:        2.851 ns (0.00% GC)

maximum time:     34.719 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.880 ns (0.00% GC)

median time:      2.503 ns (0.00% GC)

mean time:        2.536 ns (0.00% GC)

maximum time:     26.564 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.MoveDown())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     13.652 ns (0.00% GC)

median time:      14.981 ns (0.00% GC)

mean time:        18.018 ns (0.00% GC)

maximum time:     76.921 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveUp())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     14.228 ns (0.00% GC)

median time:      15.315 ns (0.00% GC)

mean time:        18.669 ns (0.00% GC)

maximum time:     70.291 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     14.649 ns (0.00% GC)

median time:      15.668 ns (0.00% GC)

mean time:        19.389 ns (0.00% GC)

maximum time:     67.772 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     13.792 ns (0.00% GC)

median time:      15.489 ns (0.00% GC)

mean time:        19.302 ns (0.00% GC)

maximum time:     67.336 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.PickUp())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     13.578 ns (0.00% GC)

median time:      14.897 ns (0.00% GC)

mean time:        19.347 ns (0.00% GC)

maximum time:     58.612 ns (0.00% GC)

samples:          10000

evals/sample:     998

# CollectGemsDirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  2.65 MiB

allocs estimate:  76505

minimum time:     19.100 ms (0.00% GC)

median time:      21.787 ms (0.00% GC)

mean time:        22.847 ms (2.72% GC)

maximum time:     39.644 ms (32.28% GC)

samples:          219

evals/sample:     1

#### GridWorlds.CollectGemsDirected()

memory estimate:  688 bytes

allocs estimate:  9

minimum time:     2.219 μs (0.00% GC)

median time:      4.060 μs (0.00% GC)

mean time:        4.476 μs (2.66% GC)

maximum time:     1.202 ms (99.28% GC)

samples:          10000

evals/sample:     9

#### RLBase.reset!(env)

memory estimate:  96 bytes

allocs estimate:  1

minimum time:     1.131 μs (0.00% GC)

median time:      1.956 μs (0.00% GC)

mean time:        2.002 μs (0.00% GC)

maximum time:     13.877 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.state(env)

memory estimate:  224 bytes

allocs estimate:  5

minimum time:     1.129 μs (0.00% GC)

median time:      1.715 μs (0.00% GC)

mean time:        1.808 μs (0.00% GC)

maximum time:     7.706 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.630 ns (0.00% GC)

median time:      3.592 ns (0.00% GC)

mean time:        3.724 ns (0.00% GC)

maximum time:     291.876 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.883 ns (0.00% GC)

median time:      2.123 ns (0.00% GC)

mean time:        2.875 ns (0.00% GC)

maximum time:     27.392 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.896 ns (0.00% GC)

median time:      2.137 ns (0.00% GC)

mean time:        2.634 ns (0.00% GC)

maximum time:     25.880 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     44.297 ns (0.00% GC)

median time:      49.029 ns (0.00% GC)

mean time:        58.975 ns (0.00% GC)

maximum time:     184.127 ns (0.00% GC)

samples:          10000

evals/sample:     988

#### env(GridWorlds.MoveForward())

memory estimate:  64 bytes

allocs estimate:  2

minimum time:     45.264 ns (0.00% GC)

median time:      48.317 ns (0.00% GC)

mean time:        67.853 ns (9.07% GC)

maximum time:     7.047 μs (99.02% GC)

samples:          10000

evals/sample:     987

#### env(GridWorlds.TurnLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     44.174 ns (0.00% GC)

median time:      49.296 ns (0.00% GC)

mean time:        61.281 ns (0.00% GC)

maximum time:     198.916 ns (0.00% GC)

samples:          10000

evals/sample:     988

# CollectGemsUndirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  1.69 MiB

allocs estimate:  40109

minimum time:     19.916 ms (0.00% GC)

median time:      23.042 ms (0.00% GC)

mean time:        23.578 ms (1.42% GC)

maximum time:     33.668 ms (33.88% GC)

samples:          213

evals/sample:     1

#### GridWorlds.CollectGemsUndirected()

memory estimate:  688 bytes

allocs estimate:  9

minimum time:     2.121 μs (0.00% GC)

median time:      2.824 μs (0.00% GC)

mean time:        3.547 μs (1.90% GC)

maximum time:     679.643 μs (99.16% GC)

samples:          10000

evals/sample:     9

#### RLBase.reset!(env)

memory estimate:  96 bytes

allocs estimate:  1

minimum time:     943.900 ns (0.00% GC)

median time:      1.394 μs (0.00% GC)

mean time:        1.564 μs (0.00% GC)

maximum time:     6.605 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.state(env)

memory estimate:  144 bytes

allocs estimate:  2

minimum time:     1.367 μs (0.00% GC)

median time:      1.733 μs (0.00% GC)

mean time:        2.062 μs (0.00% GC)

maximum time:     5.984 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.621 ns (0.00% GC)

median time:      2.964 ns (0.00% GC)

mean time:        3.772 ns (0.00% GC)

maximum time:     35.471 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.881 ns (0.00% GC)

median time:      2.663 ns (0.00% GC)

mean time:        2.674 ns (0.00% GC)

maximum time:     32.410 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.885 ns (0.00% GC)

median time:      2.458 ns (0.00% GC)

mean time:        4.363 ns (0.00% GC)

maximum time:     6.719 μs (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.MoveDown())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     14.332 ns (0.00% GC)

median time:      15.237 ns (0.00% GC)

mean time:        18.025 ns (0.00% GC)

maximum time:     92.872 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveUp())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     13.620 ns (0.00% GC)

median time:      14.580 ns (0.00% GC)

mean time:        18.303 ns (0.00% GC)

maximum time:     78.764 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     14.001 ns (0.00% GC)

median time:      15.675 ns (0.00% GC)

mean time:        19.826 ns (0.00% GC)

maximum time:     344.320 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     15.435 ns (0.00% GC)

median time:      16.710 ns (0.00% GC)

mean time:        20.612 ns (0.00% GC)

maximum time:     115.984 ns (0.00% GC)

samples:          10000

evals/sample:     997

# DynamicObstaclesDirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  13.34 MiB

allocs estimate:  154914

minimum time:     43.464 ms (0.00% GC)

median time:      49.704 ms (0.00% GC)

mean time:        50.867 ms (4.45% GC)

maximum time:     69.528 ms (12.23% GC)

samples:          99

evals/sample:     1

#### GridWorlds.DynamicObstaclesDirected()

memory estimate:  592 bytes

allocs estimate:  10

minimum time:     1.933 μs (0.00% GC)

median time:      2.703 μs (0.00% GC)

mean time:        3.458 μs (1.56% GC)

maximum time:     543.803 μs (99.08% GC)

samples:          10000

evals/sample:     9

#### RLBase.reset!(env)

memory estimate:  160 bytes

allocs estimate:  2

minimum time:     798.960 ns (0.00% GC)

median time:      1.080 μs (0.00% GC)

mean time:        1.254 μs (0.53% GC)

maximum time:     67.581 μs (98.08% GC)

samples:          10000

evals/sample:     50

#### RLBase.state(env)

memory estimate:  224 bytes

allocs estimate:  5

minimum time:     1.511 μs (0.00% GC)

median time:      1.675 μs (0.00% GC)

mean time:        2.041 μs (0.00% GC)

maximum time:     8.944 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.883 ns (0.00% GC)

median time:      2.869 ns (0.00% GC)

mean time:        3.189 ns (0.00% GC)

maximum time:     86.427 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.883 ns (0.00% GC)

median time:      2.290 ns (0.00% GC)

mean time:        2.995 ns (0.00% GC)

maximum time:     86.363 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.897 ns (0.00% GC)

median time:      2.465 ns (0.00% GC)

mean time:        3.032 ns (0.00% GC)

maximum time:     53.962 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  998 bytes

allocs estimate:  8

minimum time:     1.647 μs (0.00% GC)

median time:      2.284 μs (0.00% GC)

mean time:        2.740 μs (5.49% GC)

maximum time:     832.287 μs (99.40% GC)

samples:          10000

evals/sample:     10

#### env(GridWorlds.NoMove())

memory estimate:  1.01 KiB

allocs estimate:  8

minimum time:     1.616 μs (0.00% GC)

median time:      2.257 μs (0.00% GC)

mean time:        2.637 μs (4.09% GC)

maximum time:     647.351 μs (99.41% GC)

samples:          10000

evals/sample:     10

#### env(GridWorlds.MoveForward())

memory estimate:  1.08 KiB

allocs estimate:  10

minimum time:     1.651 μs (0.00% GC)

median time:      2.169 μs (0.00% GC)

mean time:        2.602 μs (4.30% GC)

maximum time:     566.785 μs (98.94% GC)

samples:          10000

evals/sample:     10

#### env(GridWorlds.TurnLeft())

memory estimate:  1.02 KiB

allocs estimate:  8

minimum time:     1.664 μs (0.00% GC)

median time:      2.144 μs (0.00% GC)

mean time:        2.573 μs (5.75% GC)

maximum time:     749.633 μs (99.45% GC)

samples:          10000

evals/sample:     10

# DynamicObstaclesUndirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  12.43 MiB

allocs estimate:  120210

minimum time:     44.748 ms (0.00% GC)

median time:      52.461 ms (0.00% GC)

mean time:        53.528 ms (3.87% GC)

maximum time:     75.505 ms (13.13% GC)

samples:          94

evals/sample:     1

#### GridWorlds.DynamicObstaclesUndirected()

memory estimate:  576 bytes

allocs estimate:  10

minimum time:     1.876 μs (0.00% GC)

median time:      2.480 μs (0.00% GC)

mean time:        3.215 μs (3.69% GC)

maximum time:     1.197 ms (99.05% GC)

samples:          10000

evals/sample:     9

#### RLBase.reset!(env)

memory estimate:  160 bytes

allocs estimate:  2

minimum time:     743.886 ns (0.00% GC)

median time:      938.773 ns (0.00% GC)

mean time:        1.087 μs (1.51% GC)

maximum time:     64.532 μs (98.18% GC)

samples:          10000

evals/sample:     88

#### RLBase.state(env)

memory estimate:  144 bytes

allocs estimate:  2

minimum time:     1.803 μs (0.00% GC)

median time:      1.929 μs (0.00% GC)

mean time:        2.349 μs (0.00% GC)

maximum time:     10.842 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.883 ns (0.00% GC)

median time:      2.320 ns (0.00% GC)

mean time:        2.672 ns (0.00% GC)

maximum time:     43.675 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.881 ns (0.00% GC)

median time:      2.212 ns (0.00% GC)

mean time:        2.493 ns (0.00% GC)

maximum time:     27.164 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.897 ns (0.00% GC)

median time:      2.339 ns (0.00% GC)

mean time:        2.900 ns (0.00% GC)

maximum time:     1.349 μs (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.MoveDown())

memory estimate:  1.01 KiB

allocs estimate:  8

minimum time:     1.667 μs (0.00% GC)

median time:      2.428 μs (0.00% GC)

mean time:        2.951 μs (5.24% GC)

maximum time:     944.578 μs (99.66% GC)

samples:          10000

evals/sample:     10

#### env(GridWorlds.NoMove())

memory estimate:  1019 bytes

allocs estimate:  8

minimum time:     1.654 μs (0.00% GC)

median time:      2.416 μs (0.00% GC)

mean time:        2.793 μs (4.83% GC)

maximum time:     719.779 μs (99.39% GC)

samples:          10000

evals/sample:     10

#### env(GridWorlds.MoveUp())

memory estimate:  1.00 KiB

allocs estimate:  8

minimum time:     1.594 μs (0.00% GC)

median time:      2.013 μs (0.00% GC)

mean time:        2.528 μs (4.94% GC)

maximum time:     823.665 μs (99.48% GC)

samples:          10000

evals/sample:     10

#### env(GridWorlds.MoveLeft())

memory estimate:  1.00 KiB

allocs estimate:  8

minimum time:     1.650 μs (0.00% GC)

median time:      2.738 μs (0.00% GC)

mean time:        3.010 μs (5.41% GC)

maximum time:     823.646 μs (99.59% GC)

samples:          10000

evals/sample:     10

#### env(GridWorlds.MoveRight())

memory estimate:  1020 bytes

allocs estimate:  8

minimum time:     1.638 μs (0.00% GC)

median time:      2.140 μs (0.00% GC)

mean time:        2.572 μs (5.75% GC)

maximum time:     760.465 μs (99.57% GC)

samples:          10000

evals/sample:     10

# SokobanDirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  3.45 MiB

allocs estimate:  83327

minimum time:     6.698 ms (0.00% GC)

median time:      9.498 ms (0.00% GC)

mean time:        10.004 ms (5.55% GC)

maximum time:     21.005 ms (47.99% GC)

samples:          500

evals/sample:     1

#### GridWorlds.SokobanDirected()

memory estimate:  888.08 KiB

allocs estimate:  24662

minimum time:     1.454 ms (0.00% GC)

median time:      1.980 ms (0.00% GC)

mean time:        2.334 ms (6.25% GC)

maximum time:     13.849 ms (75.49% GC)

samples:          2138

evals/sample:     1

#### RLBase.reset!(env)

memory estimate:  480 bytes

allocs estimate:  5

minimum time:     1.888 μs (0.00% GC)

median time:      2.194 μs (0.00% GC)

mean time:        2.339 μs (1.58% GC)

maximum time:     372.559 μs (99.25% GC)

samples:          10000

evals/sample:     10

#### RLBase.state(env)

memory estimate:  208 bytes

allocs estimate:  3

minimum time:     120.722 ns (0.00% GC)

median time:      131.256 ns (0.00% GC)

mean time:        168.377 ns (10.57% GC)

maximum time:     8.015 μs (96.31% GC)

samples:          10000

evals/sample:     864

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.249 ns (0.00% GC)

median time:      2.260 ns (0.00% GC)

mean time:        2.390 ns (0.00% GC)

maximum time:     34.074 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.883 ns (0.00% GC)

median time:      1.893 ns (0.00% GC)

mean time:        1.974 ns (0.00% GC)

maximum time:     33.689 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.896 ns (0.00% GC)

median time:      1.905 ns (0.00% GC)

mean time:        2.059 ns (0.00% GC)

maximum time:     33.695 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     46.397 ns (0.00% GC)

median time:      49.430 ns (0.00% GC)

mean time:        51.785 ns (0.00% GC)

maximum time:     562.803 ns (0.00% GC)

samples:          10000

evals/sample:     985

#### env(GridWorlds.MoveForward())

memory estimate:  64 bytes

allocs estimate:  2

minimum time:     70.086 ns (0.00% GC)

median time:      75.618 ns (0.00% GC)

mean time:        83.251 ns (5.98% GC)

maximum time:     4.322 μs (97.93% GC)

samples:          10000

evals/sample:     968

#### env(GridWorlds.TurnLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     46.343 ns (0.00% GC)

median time:      49.601 ns (0.00% GC)

mean time:        50.762 ns (0.00% GC)

maximum time:     157.432 ns (0.00% GC)

samples:          10000

evals/sample:     986

# SokobanUndirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  3.05 MiB

allocs estimate:  65162

minimum time:     4.557 ms (0.00% GC)

median time:      4.943 ms (0.00% GC)

mean time:        5.477 ms (5.76% GC)

maximum time:     14.020 ms (58.79% GC)

samples:          914

evals/sample:     1

#### GridWorlds.SokobanUndirected()

memory estimate:  888.06 KiB

allocs estimate:  24662

minimum time:     1.478 ms (0.00% GC)

median time:      1.666 ms (0.00% GC)

mean time:        1.968 ms (6.09% GC)

maximum time:     13.373 ms (71.17% GC)

samples:          2539

evals/sample:     1

#### RLBase.reset!(env)

memory estimate:  480 bytes

allocs estimate:  5

minimum time:     1.930 μs (0.00% GC)

median time:      2.225 μs (0.00% GC)

mean time:        2.338 μs (1.47% GC)

maximum time:     347.041 μs (98.83% GC)

samples:          10000

evals/sample:     10

#### RLBase.state(env)

memory estimate:  192 bytes

allocs estimate:  2

minimum time:     58.677 ns (0.00% GC)

median time:      60.097 ns (0.00% GC)

mean time:        78.186 ns (17.33% GC)

maximum time:     3.653 μs (98.01% GC)

samples:          10000

evals/sample:     982

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.169 ns (0.00% GC)

median time:      2.261 ns (0.00% GC)

mean time:        2.362 ns (0.00% GC)

maximum time:     34.692 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.816 ns (0.00% GC)

median time:      1.893 ns (0.00% GC)

mean time:        2.074 ns (0.00% GC)

maximum time:     33.968 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.896 ns (0.00% GC)

median time:      1.907 ns (0.00% GC)

mean time:        2.261 ns (0.00% GC)

maximum time:     36.945 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.MoveDown())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     44.459 ns (0.00% GC)

median time:      45.353 ns (0.00% GC)

mean time:        49.094 ns (0.00% GC)

maximum time:     141.459 ns (0.00% GC)

samples:          10000

evals/sample:     987

#### env(GridWorlds.MoveUp())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     45.042 ns (0.00% GC)

median time:      47.018 ns (0.00% GC)

mean time:        49.824 ns (0.00% GC)

maximum time:     160.096 ns (0.00% GC)

samples:          10000

evals/sample:     986

#### env(GridWorlds.MoveLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     44.409 ns (0.00% GC)

median time:      45.223 ns (0.00% GC)

mean time:        48.285 ns (0.00% GC)

maximum time:     141.620 ns (0.00% GC)

samples:          10000

evals/sample:     988

#### env(GridWorlds.MoveRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     48.574 ns (0.00% GC)

median time:      49.220 ns (0.00% GC)

mean time:        51.128 ns (0.00% GC)

maximum time:     124.618 ns (0.00% GC)

samples:          10000

evals/sample:     985

# Snake

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  1.69 MiB

allocs estimate:  40012

minimum time:     16.533 ms (0.00% GC)

median time:      16.891 ms (0.00% GC)

mean time:        17.305 ms (1.31% GC)

maximum time:     24.352 ms (25.42% GC)

samples:          289

evals/sample:     1

#### GridWorlds.Snake()

memory estimate:  16.59 KiB

allocs estimate:  12

minimum time:     1.954 μs (0.00% GC)

median time:      2.114 μs (0.00% GC)

mean time:        2.898 μs (24.31% GC)

maximum time:     262.119 μs (95.30% GC)

samples:          10000

evals/sample:     9

#### RLBase.reset!(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     209.496 ns (0.00% GC)

median time:      227.877 ns (0.00% GC)

mean time:        231.756 ns (0.00% GC)

maximum time:     510.431 ns (0.00% GC)

samples:          10000

evals/sample:     506

#### RLBase.state(env)

memory estimate:  144 bytes

allocs estimate:  2

minimum time:     1.602 μs (0.00% GC)

median time:      1.641 μs (0.00% GC)

mean time:        1.713 μs (0.00% GC)

maximum time:     5.529 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.530 ns (0.00% GC)

median time:      2.635 ns (0.00% GC)

mean time:        2.717 ns (0.00% GC)

maximum time:     39.108 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.881 ns (0.00% GC)

median time:      1.892 ns (0.00% GC)

mean time:        1.973 ns (0.00% GC)

maximum time:     37.036 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.880 ns (0.00% GC)

median time:      1.892 ns (0.00% GC)

mean time:        1.960 ns (0.00% GC)

maximum time:     38.571 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.MoveDown())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.310 ns (0.00% GC)

median time:      12.394 ns (0.00% GC)

mean time:        13.552 ns (0.00% GC)

maximum time:     48.078 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveUp())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.307 ns (0.00% GC)

median time:      12.732 ns (0.00% GC)

mean time:        13.580 ns (0.00% GC)

maximum time:     87.071 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.618 ns (0.00% GC)

median time:      12.702 ns (0.00% GC)

mean time:        13.442 ns (0.00% GC)

maximum time:     46.216 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.304 ns (0.00% GC)

median time:      12.609 ns (0.00% GC)

mean time:        13.299 ns (0.00% GC)

maximum time:     46.508 ns (0.00% GC)

samples:          10000

evals/sample:     998

# Catcher

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  1.68 MiB

allocs estimate:  40007

minimum time:     2.454 ms (0.00% GC)

median time:      2.595 ms (0.00% GC)

mean time:        2.864 ms (8.02% GC)

maximum time:     9.504 ms (66.39% GC)

samples:          1747

evals/sample:     1

#### GridWorlds.Catcher()

memory estimate:  304 bytes

allocs estimate:  7

minimum time:     987.100 ns (0.00% GC)

median time:      1.115 μs (0.00% GC)

mean time:        1.147 μs (0.00% GC)

maximum time:     6.309 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.reset!(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     32.114 ns (0.00% GC)

median time:      34.652 ns (0.00% GC)

mean time:        35.830 ns (0.00% GC)

maximum time:     116.173 ns (0.00% GC)

samples:          10000

evals/sample:     992

#### RLBase.state(env)

memory estimate:  144 bytes

allocs estimate:  2

minimum time:     55.167 ns (0.00% GC)

median time:      56.677 ns (0.00% GC)

mean time:        75.630 ns (21.89% GC)

maximum time:     5.925 μs (98.31% GC)

samples:          10000

evals/sample:     984

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.531 ns (0.00% GC)

median time:      2.633 ns (0.00% GC)

mean time:        2.687 ns (0.00% GC)

maximum time:     39.443 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.881 ns (0.00% GC)

median time:      1.894 ns (0.00% GC)

mean time:        1.966 ns (0.00% GC)

maximum time:     38.695 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.879 ns (0.00% GC)

median time:      1.891 ns (0.00% GC)

mean time:        1.951 ns (0.00% GC)

maximum time:     14.966 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.NoMove())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     18.957 ns (0.00% GC)

median time:      19.163 ns (0.00% GC)

mean time:        20.165 ns (0.00% GC)

maximum time:     97.250 ns (0.00% GC)

samples:          10000

evals/sample:     997

#### env(GridWorlds.MoveLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     19.201 ns (0.00% GC)

median time:      19.811 ns (0.00% GC)

mean time:        20.615 ns (0.00% GC)

maximum time:     67.627 ns (0.00% GC)

samples:          10000

evals/sample:     996

#### env(GridWorlds.MoveRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     19.419 ns (0.00% GC)

median time:      19.769 ns (0.00% GC)

mean time:        21.157 ns (0.00% GC)

maximum time:     91.532 ns (0.00% GC)

samples:          10000

evals/sample:     996

# TransportDirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  2.56 MiB

allocs estimate:  73784

minimum time:     14.803 ms (0.00% GC)

median time:      15.284 ms (0.00% GC)

mean time:        15.867 ms (2.56% GC)

maximum time:     24.919 ms (28.97% GC)

samples:          316

evals/sample:     1

#### GridWorlds.TransportDirected()

memory estimate:  336 bytes

allocs estimate:  6

minimum time:     1.428 μs (0.00% GC)

median time:      1.699 μs (0.00% GC)

mean time:        1.752 μs (0.00% GC)

maximum time:     7.059 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.reset!(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     351.285 ns (0.00% GC)

median time:      382.082 ns (0.00% GC)

mean time:        390.668 ns (0.00% GC)

maximum time:     1.022 μs (0.00% GC)

samples:          10000

evals/sample:     207

#### RLBase.state(env)

memory estimate:  224 bytes

allocs estimate:  5

minimum time:     922.133 ns (0.00% GC)

median time:      942.667 ns (0.00% GC)

mean time:        1.016 μs (2.36% GC)

maximum time:     240.934 μs (99.46% GC)

samples:          10000

evals/sample:     30

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.882 ns (0.00% GC)

median time:      1.895 ns (0.00% GC)

mean time:        1.965 ns (0.00% GC)

maximum time:     34.106 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.882 ns (0.00% GC)

median time:      1.895 ns (0.00% GC)

mean time:        1.964 ns (0.00% GC)

maximum time:     34.176 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.896 ns (0.00% GC)

median time:      1.907 ns (0.00% GC)

mean time:        1.980 ns (0.00% GC)

maximum time:     34.325 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     45.044 ns (0.00% GC)

median time:      46.390 ns (0.00% GC)

mean time:        48.243 ns (0.00% GC)

maximum time:     139.694 ns (0.00% GC)

samples:          10000

evals/sample:     988

#### env(GridWorlds.Drop())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     9.068 ns (0.00% GC)

median time:      9.769 ns (0.00% GC)

mean time:        9.907 ns (0.00% GC)

maximum time:     47.491 ns (0.00% GC)

samples:          10000

evals/sample:     999

#### env(GridWorlds.PickUp())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     11.361 ns (0.00% GC)

median time:      12.332 ns (0.00% GC)

mean time:        12.956 ns (0.00% GC)

maximum time:     46.299 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveForward())

memory estimate:  64 bytes

allocs estimate:  2

minimum time:     41.097 ns (0.00% GC)

median time:      45.768 ns (0.00% GC)

mean time:        52.079 ns (9.42% GC)

maximum time:     4.127 μs (98.62% GC)

samples:          10000

evals/sample:     987

#### env(GridWorlds.TurnLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     44.697 ns (0.00% GC)

median time:      46.151 ns (0.00% GC)

mean time:        47.629 ns (0.00% GC)

maximum time:     178.077 ns (0.00% GC)

samples:          10000

evals/sample:     988

# TransportUndirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  1.68 MiB

allocs estimate:  40006

minimum time:     16.735 ms (0.00% GC)

median time:      17.147 ms (0.00% GC)

mean time:        17.621 ms (1.24% GC)

maximum time:     25.408 ms (23.75% GC)

samples:          284

evals/sample:     1

#### GridWorlds.TransportUndirected()

memory estimate:  320 bytes

allocs estimate:  6

minimum time:     1.350 μs (0.00% GC)

median time:      1.589 μs (0.00% GC)

mean time:        1.604 μs (0.00% GC)

maximum time:     4.960 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.reset!(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     295.979 ns (0.00% GC)

median time:      329.977 ns (0.00% GC)

mean time:        336.358 ns (0.00% GC)

maximum time:     800.623 ns (0.00% GC)

samples:          10000

evals/sample:     236

#### RLBase.state(env)

memory estimate:  144 bytes

allocs estimate:  2

minimum time:     1.605 μs (0.00% GC)

median time:      1.647 μs (0.00% GC)

mean time:        1.725 μs (0.00% GC)

maximum time:     6.492 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.882 ns (0.00% GC)

median time:      1.892 ns (0.00% GC)

mean time:        1.980 ns (0.00% GC)

maximum time:     36.404 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.882 ns (0.00% GC)

median time:      1.894 ns (0.00% GC)

mean time:        1.962 ns (0.00% GC)

maximum time:     37.314 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.897 ns (0.00% GC)

median time:      1.935 ns (0.00% GC)

mean time:        2.019 ns (0.00% GC)

maximum time:     33.481 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.MoveDown())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.006 ns (0.00% GC)

median time:      12.618 ns (0.00% GC)

mean time:        13.370 ns (0.00% GC)

maximum time:     47.062 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveUp())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.519 ns (0.00% GC)

median time:      12.821 ns (0.00% GC)

mean time:        13.591 ns (0.00% GC)

maximum time:     52.441 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.308 ns (0.00% GC)

median time:      12.713 ns (0.00% GC)

mean time:        13.390 ns (0.00% GC)

maximum time:     48.915 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.301 ns (0.00% GC)

median time:      12.564 ns (0.00% GC)

mean time:        13.308 ns (0.00% GC)

maximum time:     52.666 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.PickUp())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.217 ns (0.00% GC)

median time:      13.157 ns (0.00% GC)

mean time:        13.554 ns (0.00% GC)

maximum time:     46.351 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.Drop())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     9.411 ns (0.00% GC)

median time:      9.808 ns (0.00% GC)

mean time:        10.173 ns (0.00% GC)

maximum time:     50.119 ns (0.00% GC)

samples:          10000

evals/sample:     999

