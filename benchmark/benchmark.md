Date: 2021_04_09_00_01_10
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

memory estimate:  2.72 MiB

allocs estimate:  81959

minimum time:     15.295 ms (0.00% GC)

median time:      15.609 ms (0.00% GC)

mean time:        16.119 ms (2.04% GC)

maximum time:     38.186 ms (14.14% GC)

samples:          311

evals/sample:     1

#### GridWorlds.EmptyRoomDirected()

memory estimate:  320 bytes

allocs estimate:  6

minimum time:     947.273 ns (0.00% GC)

median time:      1.099 μs (0.00% GC)

mean time:        1.103 μs (0.00% GC)

maximum time:     4.111 μs (0.00% GC)

samples:          10000

evals/sample:     11

#### RLBase.reset!(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     219.640 ns (0.00% GC)

median time:      236.322 ns (0.00% GC)

mean time:        237.893 ns (0.00% GC)

maximum time:     455.303 ns (0.00% GC)

samples:          10000

evals/sample:     469

#### RLBase.state(env)

memory estimate:  224 bytes

allocs estimate:  5

minimum time:     1.566 μs (0.00% GC)

median time:      1.588 μs (0.00% GC)

mean time:        1.640 μs (0.00% GC)

maximum time:     5.144 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.442 ns (0.00% GC)

median time:      2.541 ns (0.00% GC)

mean time:        2.600 ns (0.00% GC)

maximum time:     34.460 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.820 ns (0.00% GC)

median time:      1.857 ns (0.00% GC)

mean time:        1.885 ns (0.00% GC)

maximum time:     33.659 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.834 ns (0.00% GC)

median time:      1.871 ns (0.00% GC)

mean time:        1.905 ns (0.00% GC)

maximum time:     33.361 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     60.884 ns (0.00% GC)

median time:      63.001 ns (0.00% GC)

mean time:        63.823 ns (0.00% GC)

maximum time:     144.802 ns (0.00% GC)

samples:          10000

evals/sample:     976

#### env(GridWorlds.MoveForward())

memory estimate:  80 bytes

allocs estimate:  3

minimum time:     61.215 ns (0.00% GC)

median time:      62.841 ns (0.00% GC)

mean time:        71.293 ns (7.47% GC)

maximum time:     3.977 μs (97.23% GC)

samples:          10000

evals/sample:     976

#### env(GridWorlds.TurnLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     62.070 ns (0.00% GC)

median time:      64.147 ns (0.00% GC)

mean time:        64.806 ns (0.00% GC)

maximum time:     138.624 ns (0.00% GC)

samples:          10000

evals/sample:     976

# EmptyRoomUndirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  1.68 MiB

allocs estimate:  40006

minimum time:     15.436 ms (0.00% GC)

median time:      15.573 ms (0.00% GC)

mean time:        15.841 ms (1.15% GC)

maximum time:     21.680 ms (0.00% GC)

samples:          316

evals/sample:     1

#### GridWorlds.EmptyRoomUndirected()

memory estimate:  304 bytes

allocs estimate:  6

minimum time:     888.382 ns (0.00% GC)

median time:      965.206 ns (0.00% GC)

mean time:        1.013 μs (3.00% GC)

maximum time:     154.700 μs (99.15% GC)

samples:          10000

evals/sample:     34

#### RLBase.reset!(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     167.325 ns (0.00% GC)

median time:      179.556 ns (0.00% GC)

mean time:        180.525 ns (0.00% GC)

maximum time:     269.310 ns (0.00% GC)

samples:          10000

evals/sample:     741

#### RLBase.state(env)

memory estimate:  144 bytes

allocs estimate:  2

minimum time:     1.247 μs (0.00% GC)

median time:      1.287 μs (0.00% GC)

mean time:        1.340 μs (0.00% GC)

maximum time:     6.582 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.449 ns (0.00% GC)

median time:      2.549 ns (0.00% GC)

mean time:        2.598 ns (0.00% GC)

maximum time:     34.378 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.818 ns (0.00% GC)

median time:      1.850 ns (0.00% GC)

mean time:        1.880 ns (0.00% GC)

maximum time:     14.960 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.834 ns (0.00% GC)

median time:      1.889 ns (0.00% GC)

mean time:        1.909 ns (0.00% GC)

maximum time:     15.397 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.MoveDown())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.322 ns (0.00% GC)

median time:      13.327 ns (0.00% GC)

mean time:        13.424 ns (0.00% GC)

maximum time:     46.362 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveUp())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.332 ns (0.00% GC)

median time:      12.984 ns (0.00% GC)

mean time:        13.425 ns (0.00% GC)

maximum time:     46.562 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.969 ns (0.00% GC)

median time:      13.308 ns (0.00% GC)

mean time:        13.749 ns (0.00% GC)

maximum time:     47.316 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     13.093 ns (0.00% GC)

median time:      13.810 ns (0.00% GC)

mean time:        14.189 ns (0.00% GC)

maximum time:     47.524 ns (0.00% GC)

samples:          10000

evals/sample:     998

# GridRoomsDirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  2.71 MiB

allocs estimate:  81373

minimum time:     15.549 ms (0.00% GC)

median time:      15.950 ms (0.00% GC)

mean time:        16.332 ms (2.06% GC)

maximum time:     21.917 ms (25.67% GC)

samples:          307

evals/sample:     1

#### GridWorlds.GridRoomsDirected()

memory estimate:  752 bytes

allocs estimate:  11

minimum time:     1.722 μs (0.00% GC)

median time:      1.882 μs (0.00% GC)

mean time:        1.983 μs (3.00% GC)

maximum time:     598.328 μs (99.43% GC)

samples:          10000

evals/sample:     10

#### RLBase.reset!(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     243.919 ns (0.00% GC)

median time:      260.311 ns (0.00% GC)

mean time:        262.062 ns (0.00% GC)

maximum time:     437.563 ns (0.00% GC)

samples:          10000

evals/sample:     405

#### RLBase.state(env)

memory estimate:  224 bytes

allocs estimate:  5

minimum time:     1.280 μs (0.00% GC)

median time:      1.307 μs (0.00% GC)

mean time:        1.358 μs (0.00% GC)

maximum time:     4.690 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.442 ns (0.00% GC)

median time:      2.559 ns (0.00% GC)

mean time:        2.592 ns (0.00% GC)

maximum time:     34.717 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.819 ns (0.00% GC)

median time:      1.876 ns (0.00% GC)

mean time:        1.896 ns (0.00% GC)

maximum time:     33.898 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.819 ns (0.00% GC)

median time:      1.839 ns (0.00% GC)

mean time:        1.878 ns (0.00% GC)

maximum time:     33.691 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     62.738 ns (0.00% GC)

median time:      64.469 ns (0.00% GC)

mean time:        65.376 ns (0.00% GC)

maximum time:     140.105 ns (0.00% GC)

samples:          10000

evals/sample:     976

#### env(GridWorlds.MoveForward())

memory estimate:  80 bytes

allocs estimate:  3

minimum time:     62.204 ns (0.00% GC)

median time:      63.658 ns (0.00% GC)

mean time:        71.368 ns (7.47% GC)

maximum time:     3.651 μs (98.14% GC)

samples:          10000

evals/sample:     974

#### env(GridWorlds.TurnLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     61.724 ns (0.00% GC)

median time:      63.525 ns (0.00% GC)

mean time:        64.533 ns (0.00% GC)

maximum time:     153.427 ns (0.00% GC)

samples:          10000

evals/sample:     976

# GridRoomsUndirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  1.68 MiB

allocs estimate:  40011

minimum time:     15.646 ms (0.00% GC)

median time:      15.830 ms (0.00% GC)

mean time:        16.073 ms (1.07% GC)

maximum time:     20.868 ms (23.15% GC)

samples:          311

evals/sample:     1

#### GridWorlds.GridRoomsUndirected()

memory estimate:  736 bytes

allocs estimate:  11

minimum time:     1.622 μs (0.00% GC)

median time:      1.805 μs (0.00% GC)

mean time:        1.888 μs (3.15% GC)

maximum time:     600.066 μs (99.18% GC)

samples:          10000

evals/sample:     10

#### RLBase.reset!(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     187.105 ns (0.00% GC)

median time:      199.904 ns (0.00% GC)

mean time:        201.246 ns (0.00% GC)

maximum time:     322.741 ns (0.00% GC)

samples:          10000

evals/sample:     646

#### RLBase.state(env)

memory estimate:  144 bytes

allocs estimate:  2

minimum time:     1.517 μs (0.00% GC)

median time:      1.533 μs (0.00% GC)

mean time:        1.586 μs (0.00% GC)

maximum time:     5.138 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.822 ns (0.00% GC)

median time:      1.893 ns (0.00% GC)

mean time:        1.910 ns (0.00% GC)

maximum time:     35.667 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.821 ns (0.00% GC)

median time:      1.848 ns (0.00% GC)

mean time:        1.878 ns (0.00% GC)

maximum time:     10.387 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.833 ns (0.00% GC)

median time:      1.871 ns (0.00% GC)

mean time:        1.899 ns (0.00% GC)

maximum time:     35.464 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.MoveDown())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.625 ns (0.00% GC)

median time:      13.279 ns (0.00% GC)

mean time:        13.615 ns (0.00% GC)

maximum time:     45.782 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveUp())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     13.039 ns (0.00% GC)

median time:      14.080 ns (0.00% GC)

mean time:        14.444 ns (0.00% GC)

maximum time:     49.506 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.655 ns (0.00% GC)

median time:      13.353 ns (0.00% GC)

mean time:        13.741 ns (0.00% GC)

maximum time:     50.949 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.334 ns (0.00% GC)

median time:      13.703 ns (0.00% GC)

mean time:        14.149 ns (0.00% GC)

maximum time:     49.254 ns (0.00% GC)

samples:          10000

evals/sample:     998

# SequentialRoomsDirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  11.68 MiB

allocs estimate:  141305

minimum time:     52.988 ms (0.00% GC)

median time:      54.071 ms (0.00% GC)

mean time:        55.013 ms (1.72% GC)

maximum time:     60.288 ms (0.00% GC)

samples:          91

evals/sample:     1

#### GridWorlds.SequentialRoomsDirected()

memory estimate:  74.55 KiB

allocs estimate:  510

minimum time:     55.209 μs (0.00% GC)

median time:      67.579 μs (0.00% GC)

mean time:        74.523 μs (6.66% GC)

maximum time:     3.002 ms (95.48% GC)

samples:          10000

evals/sample:     1

#### RLBase.reset!(env)

memory estimate:  73.56 KiB

allocs estimate:  505

minimum time:     54.495 μs (0.00% GC)

median time:      65.529 μs (0.00% GC)

mean time:        72.305 μs (7.09% GC)

maximum time:     2.841 ms (95.62% GC)

samples:          10000

evals/sample:     1

#### RLBase.state(env)

memory estimate:  240 bytes

allocs estimate:  5

minimum time:     3.278 μs (0.00% GC)

median time:      3.302 μs (0.00% GC)

mean time:        3.399 μs (0.00% GC)

maximum time:     7.768 μs (0.00% GC)

samples:          10000

evals/sample:     8

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.441 ns (0.00% GC)

median time:      2.546 ns (0.00% GC)

mean time:        2.593 ns (0.00% GC)

maximum time:     34.094 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.821 ns (0.00% GC)

median time:      1.882 ns (0.00% GC)

mean time:        1.904 ns (0.00% GC)

maximum time:     15.326 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.818 ns (0.00% GC)

median time:      1.831 ns (0.00% GC)

mean time:        1.971 ns (0.00% GC)

maximum time:     33.748 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     61.425 ns (0.00% GC)

median time:      63.805 ns (0.00% GC)

mean time:        64.510 ns (0.00% GC)

maximum time:     122.051 ns (0.00% GC)

samples:          10000

evals/sample:     976

#### env(GridWorlds.MoveForward())

memory estimate:  80 bytes

allocs estimate:  3

minimum time:     71.960 ns (0.00% GC)

median time:      74.345 ns (0.00% GC)

mean time:        81.126 ns (5.78% GC)

maximum time:     3.641 μs (97.48% GC)

samples:          10000

evals/sample:     963

#### env(GridWorlds.TurnLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     61.453 ns (0.00% GC)

median time:      62.867 ns (0.00% GC)

mean time:        63.616 ns (0.00% GC)

maximum time:     142.632 ns (0.00% GC)

samples:          10000

evals/sample:     976

# SequentialRoomsUndirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  10.60 MiB

allocs estimate:  99452

minimum time:     55.316 ms (0.00% GC)

median time:      55.674 ms (0.00% GC)

mean time:        56.610 ms (1.32% GC)

maximum time:     62.793 ms (0.00% GC)

samples:          89

evals/sample:     1

#### GridWorlds.SequentialRoomsUndirected()

memory estimate:  74.36 KiB

allocs estimate:  510

minimum time:     54.868 μs (0.00% GC)

median time:      65.840 μs (0.00% GC)

mean time:        72.606 μs (7.09% GC)

maximum time:     2.797 ms (94.43% GC)

samples:          10000

evals/sample:     1

#### RLBase.reset!(env)

memory estimate:  73.73 KiB

allocs estimate:  505

minimum time:     54.083 μs (0.00% GC)

median time:      65.336 μs (0.00% GC)

mean time:        72.187 μs (7.09% GC)

maximum time:     2.852 ms (95.14% GC)

samples:          10000

evals/sample:     1

#### RLBase.state(env)

memory estimate:  160 bytes

allocs estimate:  2

minimum time:     4.715 μs (0.00% GC)

median time:      4.733 μs (0.00% GC)

mean time:        4.851 μs (0.00% GC)

maximum time:     13.416 μs (0.00% GC)

samples:          10000

evals/sample:     7

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.822 ns (0.00% GC)

median time:      1.885 ns (0.00% GC)

mean time:        1.889 ns (0.00% GC)

maximum time:     15.023 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.817 ns (0.00% GC)

median time:      1.845 ns (0.00% GC)

mean time:        1.875 ns (0.00% GC)

maximum time:     16.190 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.835 ns (0.00% GC)

median time:      1.901 ns (0.00% GC)

mean time:        1.912 ns (0.00% GC)

maximum time:     8.792 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.MoveDown())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.597 ns (0.00% GC)

median time:      12.990 ns (0.00% GC)

mean time:        13.443 ns (0.00% GC)

maximum time:     47.577 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveUp())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.600 ns (0.00% GC)

median time:      13.008 ns (0.00% GC)

mean time:        13.564 ns (0.00% GC)

maximum time:     49.858 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.365 ns (0.00% GC)

median time:      12.510 ns (0.00% GC)

mean time:        13.040 ns (0.00% GC)

maximum time:     82.335 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.926 ns (0.00% GC)

median time:      13.572 ns (0.00% GC)

mean time:        14.002 ns (0.00% GC)

maximum time:     47.046 ns (0.00% GC)

samples:          10000

evals/sample:     998

# MazeDirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  6.11 MiB

allocs estimate:  133607

minimum time:     19.242 ms (0.00% GC)

median time:      19.778 ms (0.00% GC)

mean time:        20.493 ms (3.39% GC)

maximum time:     26.581 ms (20.68% GC)

samples:          244

evals/sample:     1

#### GridWorlds.MazeDirected()

memory estimate:  33.84 KiB

allocs estimate:  500

minimum time:     36.592 μs (0.00% GC)

median time:      38.811 μs (0.00% GC)

mean time:        42.711 μs (6.07% GC)

maximum time:     3.929 ms (98.18% GC)

samples:          10000

evals/sample:     1

#### RLBase.reset!(env)

memory estimate:  33.53 KiB

allocs estimate:  494

minimum time:     35.444 μs (0.00% GC)

median time:      37.561 μs (0.00% GC)

mean time:        41.149 μs (6.17% GC)

maximum time:     3.998 ms (98.43% GC)

samples:          10000

evals/sample:     1

#### RLBase.state(env)

memory estimate:  224 bytes

allocs estimate:  5

minimum time:     1.561 μs (0.00% GC)

median time:      1.582 μs (0.00% GC)

mean time:        1.636 μs (0.00% GC)

maximum time:     5.059 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.443 ns (0.00% GC)

median time:      2.559 ns (0.00% GC)

mean time:        2.604 ns (0.00% GC)

maximum time:     35.266 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.822 ns (0.00% GC)

median time:      1.845 ns (0.00% GC)

mean time:        1.882 ns (0.00% GC)

maximum time:     34.857 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.818 ns (0.00% GC)

median time:      1.838 ns (0.00% GC)

mean time:        1.873 ns (0.00% GC)

maximum time:     14.986 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     61.349 ns (0.00% GC)

median time:      63.154 ns (0.00% GC)

mean time:        63.867 ns (0.00% GC)

maximum time:     136.617 ns (0.00% GC)

samples:          10000

evals/sample:     976

#### env(GridWorlds.MoveForward())

memory estimate:  80 bytes

allocs estimate:  3

minimum time:     62.102 ns (0.00% GC)

median time:      64.525 ns (0.00% GC)

mean time:        72.070 ns (7.42% GC)

maximum time:     3.575 μs (97.50% GC)

samples:          10000

evals/sample:     974

#### env(GridWorlds.TurnLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     61.007 ns (0.00% GC)

median time:      63.956 ns (0.00% GC)

mean time:        64.502 ns (0.00% GC)

maximum time:     115.831 ns (0.00% GC)

samples:          10000

evals/sample:     977

# MazeUndirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  5.08 MiB

allocs estimate:  92468

minimum time:     18.657 ms (0.00% GC)

median time:      18.986 ms (0.00% GC)

mean time:        19.698 ms (3.07% GC)

maximum time:     36.125 ms (19.93% GC)

samples:          254

evals/sample:     1

#### GridWorlds.MazeUndirected()

memory estimate:  33.83 KiB

allocs estimate:  500

minimum time:     36.210 μs (0.00% GC)

median time:      38.376 μs (0.00% GC)

mean time:        42.078 μs (6.14% GC)

maximum time:     3.975 ms (98.38% GC)

samples:          10000

evals/sample:     1

#### RLBase.reset!(env)

memory estimate:  33.53 KiB

allocs estimate:  494

minimum time:     35.285 μs (0.00% GC)

median time:      37.194 μs (0.00% GC)

mean time:        40.834 μs (6.25% GC)

maximum time:     3.928 ms (98.31% GC)

samples:          10000

evals/sample:     1

#### RLBase.state(env)

memory estimate:  144 bytes

allocs estimate:  2

minimum time:     1.515 μs (0.00% GC)

median time:      1.532 μs (0.00% GC)

mean time:        1.589 μs (0.00% GC)

maximum time:     5.011 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.823 ns (0.00% GC)

median time:      1.879 ns (0.00% GC)

mean time:        1.892 ns (0.00% GC)

maximum time:     33.734 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.818 ns (0.00% GC)

median time:      1.849 ns (0.00% GC)

mean time:        1.880 ns (0.00% GC)

maximum time:     34.530 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.834 ns (0.00% GC)

median time:      1.898 ns (0.00% GC)

mean time:        1.920 ns (0.00% GC)

maximum time:     34.617 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.MoveDown())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.322 ns (0.00% GC)

median time:      13.041 ns (0.00% GC)

mean time:        13.502 ns (0.00% GC)

maximum time:     506.378 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveUp())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.594 ns (0.00% GC)

median time:      13.056 ns (0.00% GC)

mean time:        13.679 ns (0.00% GC)

maximum time:     54.416 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.376 ns (0.00% GC)

median time:      12.512 ns (0.00% GC)

mean time:        12.994 ns (0.00% GC)

maximum time:     48.261 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.960 ns (0.00% GC)

median time:      13.586 ns (0.00% GC)

mean time:        14.128 ns (0.00% GC)

maximum time:     47.866 ns (0.00% GC)

samples:          10000

evals/sample:     998

# GoToTargetDirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  2.72 MiB

allocs estimate:  81926

minimum time:     15.795 ms (0.00% GC)

median time:      16.132 ms (0.00% GC)

mean time:        16.513 ms (1.98% GC)

maximum time:     22.112 ms (25.21% GC)

samples:          303

evals/sample:     1

#### GridWorlds.GoToTargetDirected()

memory estimate:  384 bytes

allocs estimate:  8

minimum time:     1.290 μs (0.00% GC)

median time:      1.526 μs (0.00% GC)

mean time:        1.534 μs (0.00% GC)

maximum time:     52.241 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.reset!(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     335.493 ns (0.00% GC)

median time:      360.915 ns (0.00% GC)

mean time:        363.952 ns (0.00% GC)

maximum time:     789.585 ns (0.00% GC)

samples:          10000

evals/sample:     217

#### RLBase.state(env)

memory estimate:  224 bytes

allocs estimate:  5

minimum time:     1.060 μs (0.00% GC)

median time:      1.085 μs (0.00% GC)

mean time:        1.130 μs (0.00% GC)

maximum time:     4.844 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.441 ns (0.00% GC)

median time:      2.541 ns (0.00% GC)

mean time:        2.590 ns (0.00% GC)

maximum time:     35.545 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.819 ns (0.00% GC)

median time:      1.853 ns (0.00% GC)

mean time:        1.882 ns (0.00% GC)

maximum time:     34.600 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.817 ns (0.00% GC)

median time:      1.847 ns (0.00% GC)

mean time:        1.871 ns (0.00% GC)

maximum time:     5.303 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     61.740 ns (0.00% GC)

median time:      63.899 ns (0.00% GC)

mean time:        64.564 ns (0.00% GC)

maximum time:     159.579 ns (0.00% GC)

samples:          10000

evals/sample:     976

#### env(GridWorlds.MoveForward())

memory estimate:  80 bytes

allocs estimate:  3

minimum time:     68.726 ns (0.00% GC)

median time:      70.040 ns (0.00% GC)

mean time:        77.741 ns (6.65% GC)

maximum time:     3.642 μs (97.73% GC)

samples:          10000

evals/sample:     968

#### env(GridWorlds.TurnLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     62.037 ns (0.00% GC)

median time:      63.726 ns (0.00% GC)

mean time:        64.357 ns (0.00% GC)

maximum time:     119.404 ns (0.00% GC)

samples:          10000

evals/sample:     976

# GoToTargetUndirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  1.68 MiB

allocs estimate:  40008

minimum time:     16.344 ms (0.00% GC)

median time:      16.617 ms (0.00% GC)

mean time:        16.856 ms (1.09% GC)

maximum time:     21.871 ms (22.96% GC)

samples:          297

evals/sample:     1

#### GridWorlds.GoToTargetUndirected()

memory estimate:  368 bytes

allocs estimate:  8

minimum time:     1.252 μs (0.00% GC)

median time:      1.448 μs (0.00% GC)

mean time:        1.461 μs (0.00% GC)

maximum time:     6.176 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.reset!(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     266.697 ns (0.00% GC)

median time:      291.788 ns (0.00% GC)

mean time:        293.693 ns (0.00% GC)

maximum time:     484.817 ns (0.00% GC)

samples:          10000

evals/sample:     290

#### RLBase.state(env)

memory estimate:  144 bytes

allocs estimate:  2

minimum time:     1.310 μs (0.00% GC)

median time:      1.347 μs (0.00% GC)

mean time:        1.396 μs (0.00% GC)

maximum time:     4.706 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.442 ns (0.00% GC)

median time:      2.540 ns (0.00% GC)

mean time:        2.591 ns (0.00% GC)

maximum time:     15.712 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.820 ns (0.00% GC)

median time:      1.876 ns (0.00% GC)

mean time:        1.890 ns (0.00% GC)

maximum time:     14.996 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.817 ns (0.00% GC)

median time:      1.828 ns (0.00% GC)

mean time:        1.873 ns (0.00% GC)

maximum time:     20.184 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.MoveDown())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     13.375 ns (0.00% GC)

median time:      13.880 ns (0.00% GC)

mean time:        14.338 ns (0.00% GC)

maximum time:     47.707 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveUp())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     13.547 ns (0.00% GC)

median time:      14.068 ns (0.00% GC)

mean time:        14.514 ns (0.00% GC)

maximum time:     50.532 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     14.385 ns (0.00% GC)

median time:      14.680 ns (0.00% GC)

mean time:        15.215 ns (0.00% GC)

maximum time:     48.743 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     16.211 ns (0.00% GC)

median time:      16.498 ns (0.00% GC)

mean time:        17.090 ns (0.00% GC)

maximum time:     50.708 ns (0.00% GC)

samples:          10000

evals/sample:     997

# DoorKeyDirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  2.70 MiB

allocs estimate:  81721

minimum time:     16.007 ms (0.00% GC)

median time:      16.400 ms (0.00% GC)

mean time:        16.782 ms (2.01% GC)

maximum time:     22.581 ms (25.37% GC)

samples:          298

evals/sample:     1

#### GridWorlds.DoorKeyDirected()

memory estimate:  528 bytes

allocs estimate:  8

minimum time:     1.179 μs (0.00% GC)

median time:      1.369 μs (0.00% GC)

mean time:        1.388 μs (0.00% GC)

maximum time:     5.554 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.reset!(env)

memory estimate:  80 bytes

allocs estimate:  1

minimum time:     362.849 ns (0.00% GC)

median time:      380.078 ns (0.00% GC)

mean time:        392.181 ns (1.04% GC)

maximum time:     14.305 μs (96.78% GC)

samples:          10000

evals/sample:     205

#### RLBase.state(env)

memory estimate:  224 bytes

allocs estimate:  5

minimum time:     676.301 ns (0.00% GC)

median time:      685.069 ns (0.00% GC)

mean time:        720.692 ns (3.56% GC)

maximum time:     37.972 μs (97.97% GC)

samples:          10000

evals/sample:     153

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.823 ns (0.00% GC)

median time:      1.857 ns (0.00% GC)

mean time:        1.886 ns (0.00% GC)

maximum time:     33.921 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.819 ns (0.00% GC)

median time:      1.867 ns (0.00% GC)

mean time:        1.890 ns (0.00% GC)

maximum time:     14.950 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.815 ns (0.00% GC)

median time:      1.835 ns (0.00% GC)

mean time:        1.869 ns (0.00% GC)

maximum time:     33.392 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     60.894 ns (0.00% GC)

median time:      62.512 ns (0.00% GC)

mean time:        63.201 ns (0.00% GC)

maximum time:     130.980 ns (0.00% GC)

samples:          10000

evals/sample:     976

#### env(GridWorlds.PickUp())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.291 ns (0.00% GC)

median time:      13.050 ns (0.00% GC)

mean time:        13.487 ns (0.00% GC)

maximum time:     32.973 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveForward())

memory estimate:  112 bytes

allocs estimate:  5

minimum time:     108.999 ns (0.00% GC)

median time:      111.559 ns (0.00% GC)

mean time:        121.687 ns (6.15% GC)

maximum time:     3.938 μs (95.98% GC)

samples:          10000

evals/sample:     921

#### env(GridWorlds.TurnLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     60.153 ns (0.00% GC)

median time:      62.397 ns (0.00% GC)

mean time:        63.176 ns (0.00% GC)

maximum time:     136.778 ns (0.00% GC)

samples:          10000

evals/sample:     978

# DoorKeyUndirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  1.69 MiB

allocs estimate:  40108

minimum time:     17.397 ms (0.00% GC)

median time:      17.726 ms (0.00% GC)

mean time:        18.763 ms (1.02% GC)

maximum time:     39.427 ms (0.00% GC)

samples:          267

evals/sample:     1

#### GridWorlds.DoorKeyUndirected()

memory estimate:  512 bytes

allocs estimate:  8

minimum time:     1.234 μs (0.00% GC)

median time:      1.472 μs (0.00% GC)

mean time:        1.560 μs (2.91% GC)

maximum time:     456.738 μs (99.40% GC)

samples:          10000

evals/sample:     10

#### RLBase.reset!(env)

memory estimate:  80 bytes

allocs estimate:  1

minimum time:     305.963 ns (0.00% GC)

median time:      322.827 ns (0.00% GC)

mean time:        335.244 ns (1.13% GC)

maximum time:     13.418 μs (97.10% GC)

samples:          10000

evals/sample:     217

#### RLBase.state(env)

memory estimate:  144 bytes

allocs estimate:  2

minimum time:     1.170 μs (0.00% GC)

median time:      1.237 μs (0.00% GC)

mean time:        1.289 μs (0.00% GC)

maximum time:     9.201 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.528 ns (0.00% GC)

median time:      2.549 ns (0.00% GC)

mean time:        2.608 ns (0.00% GC)

maximum time:     34.217 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.820 ns (0.00% GC)

median time:      1.890 ns (0.00% GC)

mean time:        1.890 ns (0.00% GC)

maximum time:     33.507 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.838 ns (0.00% GC)

median time:      12.976 ns (0.00% GC)

mean time:        13.407 ns (0.00% GC)

maximum time:     143.646 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.MoveDown())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     14.018 ns (0.00% GC)

median time:      14.467 ns (0.00% GC)

mean time:        15.040 ns (0.00% GC)

maximum time:     49.553 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveUp())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     14.118 ns (0.00% GC)

median time:      14.763 ns (0.00% GC)

mean time:        15.232 ns (0.00% GC)

maximum time:     55.378 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     13.759 ns (0.00% GC)

median time:      14.201 ns (0.00% GC)

mean time:        14.669 ns (0.00% GC)

maximum time:     47.832 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     14.405 ns (0.00% GC)

median time:      15.192 ns (0.00% GC)

mean time:        15.635 ns (0.00% GC)

maximum time:     36.321 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.PickUp())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     11.756 ns (0.00% GC)

median time:      13.012 ns (0.00% GC)

mean time:        13.505 ns (0.00% GC)

maximum time:     46.782 ns (0.00% GC)

samples:          10000

evals/sample:     998

# CollectGemsDirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  2.73 MiB

allocs estimate:  81982

minimum time:     15.332 ms (0.00% GC)

median time:      15.629 ms (0.00% GC)

mean time:        16.043 ms (2.14% GC)

maximum time:     22.552 ms (25.33% GC)

samples:          312

evals/sample:     1

#### GridWorlds.CollectGemsDirected()

memory estimate:  688 bytes

allocs estimate:  9

minimum time:     1.744 μs (0.00% GC)

median time:      2.123 μs (0.00% GC)

mean time:        2.231 μs (2.67% GC)

maximum time:     599.704 μs (99.34% GC)

samples:          10000

evals/sample:     10

#### RLBase.reset!(env)

memory estimate:  96 bytes

allocs estimate:  1

minimum time:     815.000 ns (0.00% GC)

median time:      1.103 μs (0.00% GC)

mean time:        1.123 μs (0.00% GC)

maximum time:     4.680 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.state(env)

memory estimate:  224 bytes

allocs estimate:  5

minimum time:     1.285 μs (0.00% GC)

median time:      1.326 μs (0.00% GC)

mean time:        1.373 μs (0.00% GC)

maximum time:     4.702 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.442 ns (0.00% GC)

median time:      2.549 ns (0.00% GC)

mean time:        2.731 ns (0.00% GC)

maximum time:     622.419 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.818 ns (0.00% GC)

median time:      1.870 ns (0.00% GC)

mean time:        1.893 ns (0.00% GC)

maximum time:     33.391 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.816 ns (0.00% GC)

median time:      1.833 ns (0.00% GC)

mean time:        1.862 ns (0.00% GC)

maximum time:     15.446 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     58.073 ns (0.00% GC)

median time:      59.365 ns (0.00% GC)

mean time:        60.398 ns (0.00% GC)

maximum time:     728.450 ns (0.00% GC)

samples:          10000

evals/sample:     979

#### env(GridWorlds.MoveForward())

memory estimate:  80 bytes

allocs estimate:  3

minimum time:     70.263 ns (0.00% GC)

median time:      72.389 ns (0.00% GC)

mean time:        80.076 ns (6.51% GC)

maximum time:     3.723 μs (97.28% GC)

samples:          10000

evals/sample:     967

#### env(GridWorlds.TurnLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     58.109 ns (0.00% GC)

median time:      60.231 ns (0.00% GC)

mean time:        61.302 ns (0.00% GC)

maximum time:     182.148 ns (0.00% GC)

samples:          10000

evals/sample:     979

# CollectGemsUndirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  1.69 MiB

allocs estimate:  40109

minimum time:     15.567 ms (0.00% GC)

median time:      15.723 ms (0.00% GC)

mean time:        15.989 ms (1.20% GC)

maximum time:     21.531 ms (23.36% GC)

samples:          313

evals/sample:     1

#### GridWorlds.CollectGemsUndirected()

memory estimate:  688 bytes

allocs estimate:  9

minimum time:     1.692 μs (0.00% GC)

median time:      2.025 μs (0.00% GC)

mean time:        2.110 μs (2.84% GC)

maximum time:     601.859 μs (99.41% GC)

samples:          10000

evals/sample:     10

#### RLBase.reset!(env)

memory estimate:  96 bytes

allocs estimate:  1

minimum time:     827.393 ns (0.00% GC)

median time:      1.016 μs (0.00% GC)

mean time:        1.023 μs (0.00% GC)

maximum time:     2.602 μs (0.00% GC)

samples:          10000

evals/sample:     28

#### RLBase.state(env)

memory estimate:  144 bytes

allocs estimate:  2

minimum time:     1.027 μs (0.00% GC)

median time:      1.065 μs (0.00% GC)

mean time:        1.105 μs (0.00% GC)

maximum time:     3.552 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.823 ns (0.00% GC)

median time:      1.900 ns (0.00% GC)

mean time:        1.954 ns (0.00% GC)

maximum time:     33.570 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.818 ns (0.00% GC)

median time:      1.853 ns (0.00% GC)

mean time:        1.886 ns (0.00% GC)

maximum time:     33.925 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.832 ns (0.00% GC)

median time:      1.892 ns (0.00% GC)

mean time:        1.903 ns (0.00% GC)

maximum time:     33.689 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.MoveDown())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     13.081 ns (0.00% GC)

median time:      13.675 ns (0.00% GC)

mean time:        14.145 ns (0.00% GC)

maximum time:     47.493 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveUp())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     13.044 ns (0.00% GC)

median time:      13.558 ns (0.00% GC)

mean time:        14.031 ns (0.00% GC)

maximum time:     47.584 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     14.324 ns (0.00% GC)

median time:      15.045 ns (0.00% GC)

mean time:        15.485 ns (0.00% GC)

maximum time:     49.043 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     14.164 ns (0.00% GC)

median time:      15.063 ns (0.00% GC)

mean time:        15.420 ns (0.00% GC)

maximum time:     48.870 ns (0.00% GC)

samples:          10000

evals/sample:     998

# DynamicObstaclesDirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  13.41 MiB

allocs estimate:  159099

minimum time:     31.035 ms (0.00% GC)

median time:      31.867 ms (0.00% GC)

mean time:        33.336 ms (3.62% GC)

maximum time:     40.869 ms (0.00% GC)

samples:          150

evals/sample:     1

#### GridWorlds.DynamicObstaclesDirected()

memory estimate:  592 bytes

allocs estimate:  10

minimum time:     1.508 μs (0.00% GC)

median time:      1.829 μs (0.00% GC)

mean time:        1.928 μs (2.56% GC)

maximum time:     497.458 μs (99.30% GC)

samples:          10000

evals/sample:     10

#### RLBase.reset!(env)

memory estimate:  160 bytes

allocs estimate:  2

minimum time:     663.127 ns (0.00% GC)

median time:      727.430 ns (0.00% GC)

mean time:        768.607 ns (1.02% GC)

maximum time:     21.184 μs (96.22% GC)

samples:          10000

evals/sample:     142

#### RLBase.state(env)

memory estimate:  224 bytes

allocs estimate:  5

minimum time:     869.436 ns (0.00% GC)

median time:      881.509 ns (0.00% GC)

mean time:        931.948 ns (2.29% GC)

maximum time:     110.115 μs (99.02% GC)

samples:          10000

evals/sample:     55

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.443 ns (0.00% GC)

median time:      2.549 ns (0.00% GC)

mean time:        2.595 ns (0.00% GC)

maximum time:     34.360 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.819 ns (0.00% GC)

median time:      1.869 ns (0.00% GC)

mean time:        1.889 ns (0.00% GC)

maximum time:     15.101 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.832 ns (0.00% GC)

median time:      1.886 ns (0.00% GC)

mean time:        1.910 ns (0.00% GC)

maximum time:     33.665 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  1.00 KiB

allocs estimate:  8

minimum time:     1.483 μs (0.00% GC)

median time:      1.664 μs (0.00% GC)

mean time:        1.857 μs (3.68% GC)

maximum time:     349.913 μs (99.11% GC)

samples:          10000

evals/sample:     10

#### env(GridWorlds.NoMove())

memory estimate:  1008 bytes

allocs estimate:  8

minimum time:     1.408 μs (0.00% GC)

median time:      1.587 μs (0.00% GC)

mean time:        1.776 μs (3.99% GC)

maximum time:     370.339 μs (99.26% GC)

samples:          10000

evals/sample:     10

#### env(GridWorlds.MoveForward())

memory estimate:  1.07 KiB

allocs estimate:  11

minimum time:     1.474 μs (0.00% GC)

median time:      1.632 μs (0.00% GC)

mean time:        1.838 μs (4.20% GC)

maximum time:     398.552 μs (99.29% GC)

samples:          10000

evals/sample:     10

#### env(GridWorlds.TurnLeft())

memory estimate:  1017 bytes

allocs estimate:  8

minimum time:     1.487 μs (0.00% GC)

median time:      1.673 μs (0.00% GC)

mean time:        1.861 μs (3.80% GC)

maximum time:     358.381 μs (99.31% GC)

samples:          10000

evals/sample:     10

# DynamicObstaclesUndirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  12.43 MiB

allocs estimate:  120210

minimum time:     32.462 ms (0.00% GC)

median time:      32.842 ms (0.00% GC)

mean time:        34.010 ms (2.92% GC)

maximum time:     39.609 ms (9.17% GC)

samples:          147

evals/sample:     1

#### GridWorlds.DynamicObstaclesUndirected()

memory estimate:  576 bytes

allocs estimate:  10

minimum time:     1.472 μs (0.00% GC)

median time:      1.724 μs (0.00% GC)

mean time:        1.804 μs (2.97% GC)

maximum time:     538.995 μs (99.38% GC)

samples:          10000

evals/sample:     10

#### RLBase.reset!(env)

memory estimate:  160 bytes

allocs estimate:  2

minimum time:     592.877 ns (0.00% GC)

median time:      646.058 ns (0.00% GC)

mean time:        665.940 ns (1.42% GC)

maximum time:     17.285 μs (95.92% GC)

samples:          10000

evals/sample:     171

#### RLBase.state(env)

memory estimate:  144 bytes

allocs estimate:  2

minimum time:     1.593 μs (0.00% GC)

median time:      1.616 μs (0.00% GC)

mean time:        1.671 μs (0.00% GC)

maximum time:     5.038 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.441 ns (0.00% GC)

median time:      2.542 ns (0.00% GC)

mean time:        2.588 ns (0.00% GC)

maximum time:     15.640 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.818 ns (0.00% GC)

median time:      1.857 ns (0.00% GC)

mean time:        1.882 ns (0.00% GC)

maximum time:     15.039 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.832 ns (0.00% GC)

median time:      1.884 ns (0.00% GC)

mean time:        1.901 ns (0.00% GC)

maximum time:     15.105 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.MoveDown())

memory estimate:  1.00 KiB

allocs estimate:  8

minimum time:     1.401 μs (0.00% GC)

median time:      1.590 μs (0.00% GC)

mean time:        1.777 μs (3.99% GC)

maximum time:     368.366 μs (99.19% GC)

samples:          10000

evals/sample:     10

#### env(GridWorlds.NoMove())

memory estimate:  1020 bytes

allocs estimate:  8

minimum time:     1.391 μs (0.00% GC)

median time:      1.592 μs (0.00% GC)

mean time:        1.774 μs (4.00% GC)

maximum time:     360.800 μs (99.35% GC)

samples:          10000

evals/sample:     10

#### env(GridWorlds.MoveUp())

memory estimate:  1008 bytes

allocs estimate:  8

minimum time:     1.396 μs (0.00% GC)

median time:      1.591 μs (0.00% GC)

mean time:        1.770 μs (4.12% GC)

maximum time:     374.526 μs (99.31% GC)

samples:          10000

evals/sample:     10

#### env(GridWorlds.MoveLeft())

memory estimate:  1.00 KiB

allocs estimate:  8

minimum time:     1.385 μs (0.00% GC)

median time:      1.579 μs (0.00% GC)

mean time:        1.764 μs (4.00% GC)

maximum time:     357.526 μs (99.40% GC)

samples:          10000

evals/sample:     10

#### env(GridWorlds.MoveRight())

memory estimate:  1009 bytes

allocs estimate:  8

minimum time:     1.400 μs (0.00% GC)

median time:      1.601 μs (0.00% GC)

mean time:        1.784 μs (3.99% GC)

maximum time:     367.036 μs (99.39% GC)

samples:          10000

evals/sample:     10

# SokobanDirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  3.48 MiB

allocs estimate:  89657

minimum time:     6.740 ms (0.00% GC)

median time:      6.887 ms (0.00% GC)

mean time:        7.325 ms (4.79% GC)

maximum time:     17.972 ms (36.81% GC)

samples:          682

evals/sample:     1

#### GridWorlds.SokobanDirected()

memory estimate:  794.78 KiB

allocs estimate:  23092

minimum time:     1.737 ms (0.00% GC)

median time:      1.767 ms (0.00% GC)

mean time:        1.854 ms (3.48% GC)

maximum time:     6.063 ms (66.88% GC)

samples:          2691

evals/sample:     1

#### RLBase.reset!(env)

memory estimate:  480 bytes

allocs estimate:  5

minimum time:     2.334 μs (0.00% GC)

median time:      2.600 μs (0.00% GC)

mean time:        2.669 μs (1.35% GC)

maximum time:     363.905 μs (99.08% GC)

samples:          10000

evals/sample:     9

#### RLBase.state(env)

memory estimate:  208 bytes

allocs estimate:  3

minimum time:     109.943 ns (0.00% GC)

median time:      112.747 ns (0.00% GC)

mean time:        129.483 ns (10.43% GC)

maximum time:     3.897 μs (95.60% GC)

samples:          10000

evals/sample:     914

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.174 ns (0.00% GC)

median time:      2.200 ns (0.00% GC)

mean time:        2.247 ns (0.00% GC)

maximum time:     34.398 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.817 ns (0.00% GC)

median time:      1.863 ns (0.00% GC)

mean time:        1.885 ns (0.00% GC)

maximum time:     33.668 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.833 ns (0.00% GC)

median time:      1.888 ns (0.00% GC)

mean time:        1.914 ns (0.00% GC)

maximum time:     33.561 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     64.633 ns (0.00% GC)

median time:      66.145 ns (0.00% GC)

mean time:        66.907 ns (0.00% GC)

maximum time:     137.734 ns (0.00% GC)

samples:          10000

evals/sample:     973

#### env(GridWorlds.MoveForward())

memory estimate:  80 bytes

allocs estimate:  3

minimum time:     91.508 ns (0.00% GC)

median time:      94.270 ns (0.00% GC)

mean time:        102.092 ns (5.16% GC)

maximum time:     4.483 μs (97.69% GC)

samples:          10000

evals/sample:     932

#### env(GridWorlds.TurnLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     63.792 ns (0.00% GC)

median time:      64.967 ns (0.00% GC)

mean time:        65.778 ns (0.00% GC)

maximum time:     119.610 ns (0.00% GC)

samples:          10000

evals/sample:     974

# SokobanUndirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  2.96 MiB

allocs estimate:  63592

minimum time:     4.748 ms (0.00% GC)

median time:      4.852 ms (0.00% GC)

mean time:        5.156 ms (5.20% GC)

maximum time:     9.721 ms (41.69% GC)

samples:          969

evals/sample:     1

#### GridWorlds.SokobanUndirected()

memory estimate:  794.77 KiB

allocs estimate:  23092

minimum time:     1.712 ms (0.00% GC)

median time:      1.745 ms (0.00% GC)

mean time:        1.828 ms (3.58% GC)

maximum time:     5.886 ms (68.51% GC)

samples:          2729

evals/sample:     1

#### RLBase.reset!(env)

memory estimate:  480 bytes

allocs estimate:  5

minimum time:     2.333 μs (0.00% GC)

median time:      2.597 μs (0.00% GC)

mean time:        2.660 μs (1.35% GC)

maximum time:     361.525 μs (99.12% GC)

samples:          10000

evals/sample:     9

#### RLBase.state(env)

memory estimate:  192 bytes

allocs estimate:  2

minimum time:     56.602 ns (0.00% GC)

median time:      61.822 ns (0.00% GC)

mean time:        73.459 ns (14.28% GC)

maximum time:     3.012 μs (97.18% GC)

samples:          10000

evals/sample:     980

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.172 ns (0.00% GC)

median time:      2.203 ns (0.00% GC)

mean time:        2.248 ns (0.00% GC)

maximum time:     34.184 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.818 ns (0.00% GC)

median time:      1.852 ns (0.00% GC)

mean time:        1.879 ns (0.00% GC)

maximum time:     15.026 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.833 ns (0.00% GC)

median time:      1.871 ns (0.00% GC)

mean time:        1.906 ns (0.00% GC)

maximum time:     33.419 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.MoveDown())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     45.737 ns (0.00% GC)

median time:      47.226 ns (0.00% GC)

mean time:        47.780 ns (0.00% GC)

maximum time:     93.679 ns (0.00% GC)

samples:          10000

evals/sample:     987

#### env(GridWorlds.MoveUp())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     45.399 ns (0.00% GC)

median time:      47.248 ns (0.00% GC)

mean time:        47.770 ns (0.00% GC)

maximum time:     110.778 ns (0.00% GC)

samples:          10000

evals/sample:     986

#### env(GridWorlds.MoveLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     46.350 ns (0.00% GC)

median time:      48.226 ns (0.00% GC)

mean time:        48.932 ns (0.00% GC)

maximum time:     87.208 ns (0.00% GC)

samples:          10000

evals/sample:     986

#### env(GridWorlds.MoveRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     50.191 ns (0.00% GC)

median time:      51.724 ns (0.00% GC)

mean time:        52.493 ns (0.00% GC)

maximum time:     120.401 ns (0.00% GC)

samples:          10000

evals/sample:     984

# Snake

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  1.69 MiB

allocs estimate:  40012

minimum time:     16.189 ms (0.00% GC)

median time:      16.452 ms (0.00% GC)

mean time:        16.777 ms (1.11% GC)

maximum time:     32.484 ms (0.00% GC)

samples:          298

evals/sample:     1

#### GridWorlds.Snake()

memory estimate:  16.59 KiB

allocs estimate:  12

minimum time:     1.607 μs (0.00% GC)

median time:      1.742 μs (0.00% GC)

mean time:        2.192 μs (17.28% GC)

maximum time:     146.341 μs (95.70% GC)

samples:          10000

evals/sample:     10

#### RLBase.reset!(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     178.461 ns (0.00% GC)

median time:      191.985 ns (0.00% GC)

mean time:        193.268 ns (0.00% GC)

maximum time:     349.543 ns (0.00% GC)

samples:          10000

evals/sample:     681

#### RLBase.state(env)

memory estimate:  144 bytes

allocs estimate:  2

minimum time:     1.305 μs (0.00% GC)

median time:      1.326 μs (0.00% GC)

mean time:        1.376 μs (0.00% GC)

maximum time:     3.191 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.442 ns (0.00% GC)

median time:      2.540 ns (0.00% GC)

mean time:        2.598 ns (0.00% GC)

maximum time:     16.109 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.819 ns (0.00% GC)

median time:      1.848 ns (0.00% GC)

mean time:        1.879 ns (0.00% GC)

maximum time:     15.479 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.817 ns (0.00% GC)

median time:      1.838 ns (0.00% GC)

mean time:        1.876 ns (0.00% GC)

maximum time:     33.647 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.MoveDown())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.388 ns (0.00% GC)

median time:      12.818 ns (0.00% GC)

mean time:        13.406 ns (0.00% GC)

maximum time:     51.005 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveUp())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.165 ns (0.00% GC)

median time:      12.774 ns (0.00% GC)

mean time:        13.258 ns (0.00% GC)

maximum time:     46.593 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.810 ns (0.00% GC)

median time:      13.143 ns (0.00% GC)

mean time:        13.766 ns (0.00% GC)

maximum time:     48.313 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.391 ns (0.00% GC)

median time:      12.781 ns (0.00% GC)

mean time:        13.278 ns (0.00% GC)

maximum time:     46.584 ns (0.00% GC)

samples:          10000

evals/sample:     998

# Catcher

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  1.68 MiB

allocs estimate:  40007

minimum time:     2.373 ms (0.00% GC)

median time:      2.437 ms (0.00% GC)

mean time:        2.648 ms (7.20% GC)

maximum time:     7.822 ms (66.67% GC)

samples:          1886

evals/sample:     1

#### GridWorlds.Catcher()

memory estimate:  304 bytes

allocs estimate:  7

minimum time:     766.557 ns (0.00% GC)

median time:      779.929 ns (0.00% GC)

mean time:        837.045 ns (5.08% GC)

maximum time:     63.773 μs (98.44% GC)

samples:          10000

evals/sample:     106

#### RLBase.reset!(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     28.488 ns (0.00% GC)

median time:      30.373 ns (0.00% GC)

mean time:        30.946 ns (0.00% GC)

maximum time:     66.970 ns (0.00% GC)

samples:          10000

evals/sample:     994

#### RLBase.state(env)

memory estimate:  144 bytes

allocs estimate:  2

minimum time:     54.285 ns (0.00% GC)

median time:      58.411 ns (0.00% GC)

mean time:        72.218 ns (17.31% GC)

maximum time:     4.563 μs (98.35% GC)

samples:          10000

evals/sample:     983

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.442 ns (0.00% GC)

median time:      2.548 ns (0.00% GC)

mean time:        2.595 ns (0.00% GC)

maximum time:     34.386 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.818 ns (0.00% GC)

median time:      1.856 ns (0.00% GC)

mean time:        1.886 ns (0.00% GC)

maximum time:     33.750 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.833 ns (0.00% GC)

median time:      1.892 ns (0.00% GC)

mean time:        1.903 ns (0.00% GC)

maximum time:     15.539 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.NoMove())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     18.817 ns (0.00% GC)

median time:      19.103 ns (0.00% GC)

mean time:        20.000 ns (0.00% GC)

maximum time:     78.770 ns (0.00% GC)

samples:          10000

evals/sample:     997

#### env(GridWorlds.MoveLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     18.845 ns (0.00% GC)

median time:      19.381 ns (0.00% GC)

mean time:        20.212 ns (0.00% GC)

maximum time:     54.324 ns (0.00% GC)

samples:          10000

evals/sample:     997

#### env(GridWorlds.MoveRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     19.273 ns (0.00% GC)

median time:      19.564 ns (0.00% GC)

mean time:        20.286 ns (0.00% GC)

maximum time:     63.100 ns (0.00% GC)

samples:          10000

evals/sample:     996

# TransportDirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  2.61 MiB

allocs estimate:  77093

minimum time:     15.596 ms (0.00% GC)

median time:      16.054 ms (0.00% GC)

mean time:        16.843 ms (2.02% GC)

maximum time:     28.150 ms (0.00% GC)

samples:          297

evals/sample:     1

#### GridWorlds.TransportDirected()

memory estimate:  336 bytes

allocs estimate:  6

minimum time:     1.049 μs (0.00% GC)

median time:      1.291 μs (0.00% GC)

mean time:        1.298 μs (0.00% GC)

maximum time:     4.631 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.reset!(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     309.047 ns (0.00% GC)

median time:      341.957 ns (0.00% GC)

mean time:        371.535 ns (0.00% GC)

maximum time:     784.901 ns (0.00% GC)

samples:          10000

evals/sample:     233

#### RLBase.state(env)

memory estimate:  224 bytes

allocs estimate:  5

minimum time:     1.379 μs (0.00% GC)

median time:      1.428 μs (0.00% GC)

mean time:        1.482 μs (0.00% GC)

maximum time:     4.887 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.528 ns (0.00% GC)

median time:      2.552 ns (0.00% GC)

mean time:        2.605 ns (0.00% GC)

maximum time:     34.059 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.817 ns (0.00% GC)

median time:      1.888 ns (0.00% GC)

mean time:        1.894 ns (0.00% GC)

maximum time:     33.548 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.833 ns (0.00% GC)

median time:      1.892 ns (0.00% GC)

mean time:        1.904 ns (0.00% GC)

maximum time:     15.683 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     62.290 ns (0.00% GC)

median time:      63.983 ns (0.00% GC)

mean time:        64.676 ns (0.00% GC)

maximum time:     115.749 ns (0.00% GC)

samples:          10000

evals/sample:     976

#### env(GridWorlds.Drop())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     10.395 ns (0.00% GC)

median time:      10.716 ns (0.00% GC)

mean time:        11.212 ns (0.00% GC)

maximum time:     44.625 ns (0.00% GC)

samples:          10000

evals/sample:     999

#### env(GridWorlds.PickUp())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.834 ns (0.00% GC)

median time:      13.751 ns (0.00% GC)

mean time:        14.225 ns (0.00% GC)

maximum time:     51.161 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveForward())

memory estimate:  80 bytes

allocs estimate:  3

minimum time:     71.199 ns (0.00% GC)

median time:      72.970 ns (0.00% GC)

mean time:        83.554 ns (6.41% GC)

maximum time:     3.777 μs (97.36% GC)

samples:          10000

evals/sample:     966

#### env(GridWorlds.TurnLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     61.074 ns (0.00% GC)

median time:      62.992 ns (0.00% GC)

mean time:        67.443 ns (0.00% GC)

maximum time:     1.801 μs (0.00% GC)

samples:          10000

evals/sample:     976

# TransportUndirected

#### Run uniformly random policy, NUM_RESETS = 100, STEPS_PER_RESET = 100, TOTAL_STEPS = 10000

memory estimate:  1.68 MiB

allocs estimate:  40006

minimum time:     16.984 ms (0.00% GC)

median time:      17.716 ms (0.00% GC)

mean time:        19.407 ms (1.12% GC)

maximum time:     44.158 ms (0.00% GC)

samples:          258

evals/sample:     1

#### GridWorlds.TransportUndirected()

memory estimate:  320 bytes

allocs estimate:  6

minimum time:     1.015 μs (0.00% GC)

median time:      1.210 μs (0.00% GC)

mean time:        1.218 μs (0.00% GC)

maximum time:     4.544 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.reset!(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     250.478 ns (0.00% GC)

median time:      274.767 ns (0.00% GC)

mean time:        285.521 ns (0.00% GC)

maximum time:     654.415 ns (0.00% GC)

samples:          10000

evals/sample:     337

#### RLBase.state(env)

memory estimate:  144 bytes

allocs estimate:  2

minimum time:     1.303 μs (0.00% GC)

median time:      1.375 μs (0.00% GC)

mean time:        1.437 μs (0.00% GC)

maximum time:     6.795 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.527 ns (0.00% GC)

median time:      2.624 ns (0.00% GC)

mean time:        2.650 ns (0.00% GC)

maximum time:     36.558 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.819 ns (0.00% GC)

median time:      2.215 ns (0.00% GC)

mean time:        2.332 ns (0.00% GC)

maximum time:     136.714 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.833 ns (0.00% GC)

median time:      3.312 ns (0.00% GC)

mean time:        3.073 ns (0.00% GC)

maximum time:     35.290 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.MoveDown())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.868 ns (0.00% GC)

median time:      13.783 ns (0.00% GC)

mean time:        14.667 ns (0.00% GC)

maximum time:     57.126 ns (0.00% GC)

samples:          10000

evals/sample:     995

#### env(GridWorlds.MoveUp())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.304 ns (0.00% GC)

median time:      14.053 ns (0.00% GC)

mean time:        15.189 ns (0.00% GC)

maximum time:     64.762 ns (0.00% GC)

samples:          10000

evals/sample:     997

#### env(GridWorlds.MoveLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     12.573 ns (0.00% GC)

median time:      13.460 ns (0.00% GC)

mean time:        14.444 ns (0.00% GC)

maximum time:     70.662 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.MoveRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     14.006 ns (0.00% GC)

median time:      24.031 ns (0.00% GC)

mean time:        22.799 ns (0.00% GC)

maximum time:     98.804 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.PickUp())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     13.037 ns (0.00% GC)

median time:      14.015 ns (0.00% GC)

mean time:        15.263 ns (0.00% GC)

maximum time:     66.433 ns (0.00% GC)

samples:          10000

evals/sample:     998

#### env(GridWorlds.Drop())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     10.367 ns (0.00% GC)

median time:      11.096 ns (0.00% GC)

mean time:        11.750 ns (0.00% GC)

maximum time:     73.167 ns (0.00% GC)

samples:          10000

evals/sample:     999

