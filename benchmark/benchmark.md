# List of Environments
  1. [GridWorlds.EmptyRoom](#GridWorlds.EmptyRoom)
  1. [GridWorlds.GridRooms](#GridWorlds.GridRooms)
  1. [GridWorlds.SequentialRooms](#GridWorlds.SequentialRooms)
  1. [GridWorlds.GoToDoor](#GridWorlds.GoToDoor)
  1. [GridWorlds.DoorKey](#GridWorlds.DoorKey)
  1. [GridWorlds.CollectGems](#GridWorlds.CollectGems)
  1. [GridWorlds.DynamicObstacles](#GridWorlds.DynamicObstacles)
  1. [GridWorlds.Sokoban](#GridWorlds.Sokoban)

# Benchmarks

# GridWorlds.EmptyRoom

#### GridWorlds.EmptyRoom()

memory estimate:  2.36 KiB

allocs estimate:  29

minimum time:     2.049 μs (0.00% GC)

median time:      2.309 μs (0.00% GC)

mean time:        2.768 μs (4.74% GC)

maximum time:     346.105 μs (98.59% GC)

samples:          10000

evals/sample:     9

#### RLBase.reset!(env)

memory estimate:  32 bytes

allocs estimate:  1

minimum time:     264.632 ns (0.00% GC)

median time:      294.210 ns (0.00% GC)

mean time:        314.038 ns (0.23% GC)

maximum time:     7.683 μs (92.50% GC)

samples:          10000

evals/sample:     269

#### RLBase.state(env)

memory estimate:  2.72 KiB

allocs estimate:  45

minimum time:     2.003 μs (0.00% GC)

median time:      2.220 μs (0.00% GC)

mean time:        3.132 μs (6.86% GC)

maximum time:     496.003 μs (99.30% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     0.026 ns (0.00% GC)

median time:      0.029 ns (0.00% GC)

mean time:        0.030 ns (0.00% GC)

maximum time:     12.513 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  32 bytes

allocs estimate:  1

minimum time:     31.045 ns (0.00% GC)

median time:      33.965 ns (0.00% GC)

mean time:        37.581 ns (2.85% GC)

maximum time:     2.016 μs (97.73% GC)

samples:          10000

evals/sample:     993

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.813 ns (0.00% GC)

median time:      1.886 ns (0.00% GC)

mean time:        1.903 ns (0.00% GC)

maximum time:     34.104 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     69.396 ns (0.00% GC)

median time:      70.953 ns (0.00% GC)

mean time:        74.941 ns (0.00% GC)

maximum time:     214.224 ns (0.00% GC)

samples:          10000

evals/sample:     970

#### env(GridWorlds.MoveForward())

memory estimate:  96 bytes

allocs estimate:  3

minimum time:     97.064 ns (0.00% GC)

median time:      99.139 ns (0.00% GC)

mean time:        109.022 ns (3.25% GC)

maximum time:     2.284 μs (94.11% GC)

samples:          10000

evals/sample:     940

#### env(GridWorlds.TurnLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     69.014 ns (0.00% GC)

median time:      72.121 ns (0.00% GC)

mean time:        75.012 ns (0.00% GC)

maximum time:     218.572 ns (0.00% GC)

samples:          10000

evals/sample:     973

# GridWorlds.GridRooms

#### GridWorlds.GridRooms()

memory estimate:  13.16 KiB

allocs estimate:  348

minimum time:     11.497 μs (0.00% GC)

median time:      13.130 μs (0.00% GC)

mean time:        15.194 μs (4.45% GC)

maximum time:     3.440 ms (99.01% GC)

samples:          10000

evals/sample:     1

#### RLBase.reset!(env)

memory estimate:  32 bytes

allocs estimate:  1

minimum time:     276.655 ns (0.00% GC)

median time:      306.675 ns (0.00% GC)

mean time:        319.382 ns (0.33% GC)

maximum time:     11.267 μs (94.06% GC)

samples:          10000

evals/sample:     229

#### RLBase.state(env)

memory estimate:  2.09 KiB

allocs estimate:  35

minimum time:     1.481 μs (0.00% GC)

median time:      1.675 μs (0.00% GC)

mean time:        1.911 μs (6.79% GC)

maximum time:     333.096 μs (99.06% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     0.026 ns (0.00% GC)

median time:      0.028 ns (0.00% GC)

mean time:        0.028 ns (0.00% GC)

maximum time:     0.048 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  32 bytes

allocs estimate:  1

minimum time:     32.302 ns (0.00% GC)

median time:      33.256 ns (0.00% GC)

mean time:        37.833 ns (2.96% GC)

maximum time:     2.049 μs (97.95% GC)

samples:          10000

evals/sample:     992

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.813 ns (0.00% GC)

median time:      1.888 ns (0.00% GC)

mean time:        1.938 ns (0.00% GC)

maximum time:     33.704 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     67.694 ns (0.00% GC)

median time:      69.843 ns (0.00% GC)

mean time:        74.192 ns (0.00% GC)

maximum time:     1.353 μs (0.00% GC)

samples:          10000

evals/sample:     971

#### env(GridWorlds.MoveForward())

memory estimate:  96 bytes

allocs estimate:  3

minimum time:     96.429 ns (0.00% GC)

median time:      98.169 ns (0.00% GC)

mean time:        109.319 ns (3.49% GC)

maximum time:     2.615 μs (96.08% GC)

samples:          10000

evals/sample:     939

#### env(GridWorlds.TurnLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     67.939 ns (0.00% GC)

median time:      71.274 ns (0.00% GC)

mean time:        74.673 ns (0.00% GC)

maximum time:     226.624 ns (0.00% GC)

samples:          10000

evals/sample:     971

# GridWorlds.SequentialRooms

#### GridWorlds.SequentialRooms()

memory estimate:  1.33 MiB

allocs estimate:  12432

minimum time:     1.196 ms (0.00% GC)

median time:      1.953 ms (0.00% GC)

mean time:        2.104 ms (7.31% GC)

maximum time:     6.231 ms (60.08% GC)

samples:          2376

evals/sample:     1

#### RLBase.reset!(env)

memory estimate:  1.33 MiB

allocs estimate:  12427

minimum time:     1.191 ms (0.00% GC)

median time:      1.893 ms (0.00% GC)

mean time:        2.026 ms (7.35% GC)

maximum time:     6.342 ms (58.45% GC)

samples:          2468

evals/sample:     1

#### RLBase.state(env)

memory estimate:  10.36 KiB

allocs estimate:  167

minimum time:     6.821 μs (0.00% GC)

median time:      7.645 μs (0.00% GC)

mean time:        8.699 μs (8.97% GC)

maximum time:     769.997 μs (98.72% GC)

samples:          10000

evals/sample:     5

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     0.026 ns (0.00% GC)

median time:      0.028 ns (0.00% GC)

mean time:        0.029 ns (0.00% GC)

maximum time:     0.198 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  32 bytes

allocs estimate:  1

minimum time:     31.576 ns (0.00% GC)

median time:      33.701 ns (0.00% GC)

mean time:        38.017 ns (3.15% GC)

maximum time:     2.220 μs (97.47% GC)

samples:          10000

evals/sample:     992

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.812 ns (0.00% GC)

median time:      1.887 ns (0.00% GC)

mean time:        1.915 ns (0.00% GC)

maximum time:     33.722 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     67.596 ns (0.00% GC)

median time:      70.102 ns (0.00% GC)

mean time:        73.150 ns (0.00% GC)

maximum time:     236.009 ns (0.00% GC)

samples:          10000

evals/sample:     970

#### env(GridWorlds.MoveForward())

memory estimate:  96 bytes

allocs estimate:  3

minimum time:     100.777 ns (0.00% GC)

median time:      102.833 ns (0.00% GC)

mean time:        113.411 ns (3.93% GC)

maximum time:     3.078 μs (96.27% GC)

samples:          10000

evals/sample:     923

#### env(GridWorlds.TurnLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     67.502 ns (0.00% GC)

median time:      69.860 ns (0.00% GC)

mean time:        72.437 ns (0.00% GC)

maximum time:     201.711 ns (0.00% GC)

samples:          10000

evals/sample:     971

# GridWorlds.GoToDoor

#### GridWorlds.GoToDoor()

memory estimate:  5.78 KiB

allocs estimate:  84

minimum time:     18.065 μs (0.00% GC)

median time:      20.709 μs (0.00% GC)

mean time:        21.801 μs (1.82% GC)

maximum time:     4.003 ms (99.10% GC)

samples:          10000

evals/sample:     1

#### RLBase.reset!(env)

memory estimate:  1.53 KiB

allocs estimate:  27

minimum time:     1.047 μs (0.00% GC)

median time:      1.306 μs (0.00% GC)

mean time:        1.527 μs (6.20% GC)

maximum time:     341.454 μs (99.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.state(env)

memory estimate:  3.38 KiB

allocs estimate:  56

minimum time:     2.488 μs (0.00% GC)

median time:      2.794 μs (0.00% GC)

mean time:        3.210 μs (8.22% GC)

maximum time:     456.497 μs (98.87% GC)

samples:          10000

evals/sample:     9

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     0.026 ns (0.00% GC)

median time:      0.029 ns (0.00% GC)

mean time:        0.029 ns (0.00% GC)

maximum time:     0.058 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  32 bytes

allocs estimate:  1

minimum time:     41.643 ns (0.00% GC)

median time:      44.371 ns (0.00% GC)

mean time:        49.150 ns (2.76% GC)

maximum time:     2.471 μs (97.74% GC)

samples:          10000

evals/sample:     988

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.881 ns (0.00% GC)

median time:      1.888 ns (0.00% GC)

mean time:        1.919 ns (0.00% GC)

maximum time:     33.419 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     69.774 ns (0.00% GC)

median time:      71.476 ns (0.00% GC)

mean time:        80.155 ns (0.00% GC)

maximum time:     231.178 ns (0.00% GC)

samples:          10000

evals/sample:     973

#### env(GridWorlds.MoveForward())

memory estimate:  96 bytes

allocs estimate:  3

minimum time:     104.183 ns (0.00% GC)

median time:      108.873 ns (0.00% GC)

mean time:        119.384 ns (3.93% GC)

maximum time:     3.168 μs (96.09% GC)

samples:          10000

evals/sample:     921

#### env(GridWorlds.TurnLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     68.198 ns (0.00% GC)

median time:      71.325 ns (0.00% GC)

mean time:        74.505 ns (0.00% GC)

maximum time:     220.495 ns (0.00% GC)

samples:          10000

evals/sample:     970

# GridWorlds.DoorKey

#### GridWorlds.DoorKey()

memory estimate:  2.39 KiB

allocs estimate:  29

minimum time:     2.243 μs (0.00% GC)

median time:      2.382 μs (0.00% GC)

mean time:        2.800 μs (5.08% GC)

maximum time:     366.787 μs (98.64% GC)

samples:          10000

evals/sample:     9

#### RLBase.reset!(env)

memory estimate:  64 bytes

allocs estimate:  2

minimum time:     536.755 ns (0.00% GC)

median time:      553.207 ns (0.00% GC)

mean time:        580.798 ns (0.43% GC)

maximum time:     13.483 μs (94.19% GC)

samples:          10000

evals/sample:     188

#### RLBase.state(env)

memory estimate:  1.22 KiB

allocs estimate:  21

minimum time:     868.500 ns (0.00% GC)

median time:      964.019 ns (0.00% GC)

mean time:        1.105 μs (10.10% GC)

maximum time:     94.436 μs (97.81% GC)

samples:          10000

evals/sample:     52

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     0.026 ns (0.00% GC)

median time:      0.029 ns (0.00% GC)

mean time:        0.029 ns (0.00% GC)

maximum time:     0.051 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  32 bytes

allocs estimate:  1

minimum time:     31.491 ns (0.00% GC)

median time:      33.738 ns (0.00% GC)

mean time:        38.229 ns (3.77% GC)

maximum time:     2.516 μs (98.33% GC)

samples:          10000

evals/sample:     992

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.814 ns (0.00% GC)

median time:      1.888 ns (0.00% GC)

mean time:        1.926 ns (0.00% GC)

maximum time:     34.356 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     67.911 ns (0.00% GC)

median time:      70.253 ns (0.00% GC)

mean time:        73.485 ns (0.00% GC)

maximum time:     237.533 ns (0.00% GC)

samples:          10000

evals/sample:     971

#### env(GridWorlds.PickUp())

memory estimate:  32 bytes

allocs estimate:  1

minimum time:     33.821 ns (0.00% GC)

median time:      36.474 ns (0.00% GC)

mean time:        40.486 ns (3.55% GC)

maximum time:     2.868 μs (98.31% GC)

samples:          10000

evals/sample:     992

#### env(GridWorlds.MoveForward())

memory estimate:  96 bytes

allocs estimate:  3

minimum time:     95.023 ns (0.00% GC)

median time:      97.023 ns (0.00% GC)

mean time:        107.661 ns (4.33% GC)

maximum time:     3.078 μs (96.59% GC)

samples:          10000

evals/sample:     939

#### env(GridWorlds.TurnLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     67.077 ns (0.00% GC)

median time:      69.252 ns (0.00% GC)

mean time:        72.663 ns (0.00% GC)

maximum time:     230.249 ns (0.00% GC)

samples:          10000

evals/sample:     971

# GridWorlds.CollectGems

#### GridWorlds.CollectGems()

memory estimate:  2.75 KiB

allocs estimate:  33

minimum time:     2.610 μs (0.00% GC)

median time:      2.998 μs (0.00% GC)

mean time:        3.373 μs (5.65% GC)

maximum time:     413.794 μs (98.80% GC)

samples:          10000

evals/sample:     9

#### RLBase.reset!(env)

memory estimate:  336 bytes

allocs estimate:  4

minimum time:     905.400 ns (0.00% GC)

median time:      1.207 μs (0.00% GC)

mean time:        1.249 μs (0.00% GC)

maximum time:     5.046 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.state(env)

memory estimate:  3.34 KiB

allocs estimate:  55

minimum time:     2.237 μs (0.00% GC)

median time:      2.518 μs (0.00% GC)

mean time:        2.941 μs (9.46% GC)

maximum time:     509.938 μs (99.22% GC)

samples:          10000

evals/sample:     9

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     0.027 ns (0.00% GC)

median time:      0.029 ns (0.00% GC)

mean time:        0.030 ns (0.00% GC)

maximum time:     2.008 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.880 ns (0.00% GC)

median time:      1.889 ns (0.00% GC)

mean time:        1.929 ns (0.00% GC)

maximum time:     33.808 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.879 ns (0.00% GC)

median time:      1.890 ns (0.00% GC)

mean time:        1.927 ns (0.00% GC)

maximum time:     34.082 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     69.442 ns (0.00% GC)

median time:      71.717 ns (0.00% GC)

mean time:        73.938 ns (0.00% GC)

maximum time:     220.674 ns (0.00% GC)

samples:          10000

evals/sample:     969

#### env(GridWorlds.MoveForward())

memory estimate:  96 bytes

allocs estimate:  3

minimum time:     95.252 ns (0.00% GC)

median time:      96.721 ns (0.00% GC)

mean time:        108.436 ns (4.80% GC)

maximum time:     3.156 μs (96.60% GC)

samples:          10000

evals/sample:     935

#### env(GridWorlds.TurnLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     68.993 ns (0.00% GC)

median time:      72.266 ns (0.00% GC)

mean time:        75.189 ns (0.00% GC)

maximum time:     228.067 ns (0.00% GC)

samples:          10000

evals/sample:     969

# GridWorlds.DynamicObstacles

#### GridWorlds.DynamicObstacles()

memory estimate:  2.63 KiB

allocs estimate:  32

minimum time:     2.377 μs (0.00% GC)

median time:      2.718 μs (0.00% GC)

mean time:        3.073 μs (6.64% GC)

maximum time:     424.044 μs (98.72% GC)

samples:          10000

evals/sample:     9

#### RLBase.reset!(env)

memory estimate:  192 bytes

allocs estimate:  3

minimum time:     703.784 ns (0.00% GC)

median time:      756.360 ns (0.00% GC)

mean time:        796.105 ns (1.61% GC)

maximum time:     28.808 μs (96.77% GC)

samples:          10000

evals/sample:     139

#### RLBase.state(env)

memory estimate:  1.22 KiB

allocs estimate:  21

minimum time:     891.537 ns (0.00% GC)

median time:      1.002 μs (0.00% GC)

mean time:        1.152 μs (10.46% GC)

maximum time:     118.824 μs (99.00% GC)

samples:          10000

evals/sample:     41

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     0.027 ns (0.00% GC)

median time:      0.029 ns (0.00% GC)

mean time:        0.030 ns (0.00% GC)

maximum time:     0.051 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  64 bytes

allocs estimate:  2

minimum time:     60.516 ns (0.00% GC)

median time:      65.733 ns (0.00% GC)

mean time:        72.396 ns (4.62% GC)

maximum time:     3.034 μs (97.59% GC)

samples:          10000

evals/sample:     975

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.880 ns (0.00% GC)

median time:      1.888 ns (0.00% GC)

mean time:        1.933 ns (0.00% GC)

maximum time:     42.420 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  5.25 KiB

allocs estimate:  42

minimum time:     2.038 μs (0.00% GC)

median time:      2.145 μs (0.00% GC)

mean time:        2.605 μs (9.70% GC)

maximum time:     364.511 μs (98.65% GC)

samples:          10000

evals/sample:     9

#### env(GridWorlds.MoveForward())

memory estimate:  5.31 KiB

allocs estimate:  44

minimum time:     1.994 μs (0.00% GC)

median time:      2.108 μs (0.00% GC)

mean time:        2.596 μs (9.96% GC)

maximum time:     318.669 μs (98.19% GC)

samples:          10000

evals/sample:     9

#### env(GridWorlds.TurnLeft())

memory estimate:  5.25 KiB

allocs estimate:  42

minimum time:     2.029 μs (0.00% GC)

median time:      2.143 μs (0.00% GC)

mean time:        2.589 μs (9.32% GC)

maximum time:     250.672 μs (98.29% GC)

samples:          10000

evals/sample:     9

# GridWorlds.Sokoban

#### GridWorlds.Sokoban()

memory estimate:  848.75 KiB

allocs estimate:  23971

minimum time:     1.360 ms (0.00% GC)

median time:      1.448 ms (0.00% GC)

mean time:        1.557 ms (4.68% GC)

maximum time:     6.166 ms (74.30% GC)

samples:          3211

evals/sample:     1

#### RLBase.reset!(env)

memory estimate:  512 bytes

allocs estimate:  6

minimum time:     3.059 μs (0.00% GC)

median time:      3.542 μs (0.00% GC)

mean time:        4.013 μs (0.82% GC)

maximum time:     332.136 μs (98.63% GC)

samples:          10000

evals/sample:     9

#### RLBase.state(env)

memory estimate:  1.33 KiB

allocs estimate:  27

minimum time:     2.947 μs (0.00% GC)

median time:      3.341 μs (0.00% GC)

mean time:        3.981 μs (3.79% GC)

maximum time:     841.566 μs (98.89% GC)

samples:          10000

evals/sample:     8

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     0.027 ns (0.00% GC)

median time:      0.030 ns (0.00% GC)

mean time:        0.030 ns (0.00% GC)

maximum time:     0.112 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     8.425 ns (0.00% GC)

median time:      9.659 ns (0.00% GC)

mean time:        10.489 ns (0.00% GC)

maximum time:     172.493 ns (0.00% GC)

samples:          10000

evals/sample:     999

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.813 ns (0.00% GC)

median time:      1.889 ns (0.00% GC)

mean time:        1.972 ns (0.00% GC)

maximum time:     43.046 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.MoveDown())

memory estimate:  32 bytes

allocs estimate:  1

minimum time:     68.885 ns (0.00% GC)

median time:      73.117 ns (0.00% GC)

mean time:        81.389 ns (2.26% GC)

maximum time:     3.563 μs (94.10% GC)

samples:          10000

evals/sample:     971

#### env(GridWorlds.MoveUp())

memory estimate:  32 bytes

allocs estimate:  1

minimum time:     63.466 ns (0.00% GC)

median time:      67.815 ns (0.00% GC)

mean time:        74.956 ns (2.22% GC)

maximum time:     2.973 μs (97.45% GC)

samples:          10000

evals/sample:     974

#### env(GridWorlds.MoveLeft())

memory estimate:  32 bytes

allocs estimate:  1

minimum time:     68.520 ns (0.00% GC)

median time:      71.837 ns (0.00% GC)

mean time:        77.898 ns (2.30% GC)

maximum time:     3.587 μs (96.17% GC)

samples:          10000

evals/sample:     970

#### env(GridWorlds.MoveRight())

memory estimate:  32 bytes

allocs estimate:  1

minimum time:     63.659 ns (0.00% GC)

median time:      66.116 ns (0.00% GC)

mean time:        71.629 ns (2.38% GC)

maximum time:     3.118 μs (97.37% GC)

samples:          10000

evals/sample:     974

