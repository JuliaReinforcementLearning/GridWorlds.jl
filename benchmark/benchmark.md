# List of Environments
  1. GridWorlds.EmptyRoom
  1. GridWorlds.GridRooms
  1. GridWorlds.SequentialRooms
  1. GridWorlds.Maze
  1. GridWorlds.GoToDoor
  1. GridWorlds.DoorKey
  1. GridWorlds.CollectGems
  1. GridWorlds.DynamicObstacles
  1. GridWorlds.Sokoban
  1. GridWorlds.Snake
  1. GridWorlds.Catcher
  1. GridWorlds.Transport

# Benchmarks

# GridWorlds.EmptyRoom

#### GridWorlds.EmptyRoom()

memory estimate:  1.81 KiB

allocs estimate:  40

minimum time:     2.289 μs (0.00% GC)

median time:      2.413 μs (0.00% GC)

mean time:        2.698 μs (4.37% GC)

maximum time:     401.815 μs (99.03% GC)

samples:          10000

evals/sample:     9

#### RLBase.reset!(env)

memory estimate:  32 bytes

allocs estimate:  1

minimum time:     267.770 ns (0.00% GC)

median time:      289.093 ns (0.00% GC)

mean time:        295.485 ns (0.33% GC)

maximum time:     5.192 μs (94.05% GC)

samples:          10000

evals/sample:     296

#### RLBase.state(env)

memory estimate:  1.72 KiB

allocs estimate:  29

minimum time:     1.244 μs (0.00% GC)

median time:      1.377 μs (0.00% GC)

mean time:        1.602 μs (5.16% GC)

maximum time:     295.341 μs (99.21% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.815 ns (0.00% GC)

median time:      1.887 ns (0.00% GC)

mean time:        1.893 ns (0.00% GC)

maximum time:     14.921 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  32 bytes

allocs estimate:  1

minimum time:     31.933 ns (0.00% GC)

median time:      34.325 ns (0.00% GC)

mean time:        37.310 ns (2.48% GC)

maximum time:     1.625 μs (97.49% GC)

samples:          10000

evals/sample:     992

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.815 ns (0.00% GC)

median time:      1.889 ns (0.00% GC)

mean time:        1.884 ns (0.00% GC)

maximum time:     14.498 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     68.985 ns (0.00% GC)

median time:      72.642 ns (0.00% GC)

mean time:        74.169 ns (0.00% GC)

maximum time:     220.267 ns (0.00% GC)

samples:          10000

evals/sample:     971

#### env(GridWorlds.MoveForward())

memory estimate:  112 bytes

allocs estimate:  4

minimum time:     121.125 ns (0.00% GC)

median time:      123.003 ns (0.00% GC)

mean time:        131.158 ns (3.14% GC)

maximum time:     2.215 μs (94.24% GC)

samples:          10000

evals/sample:     898

#### env(GridWorlds.TurnLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     69.556 ns (0.00% GC)

median time:      71.168 ns (0.00% GC)

mean time:        72.825 ns (0.00% GC)

maximum time:     213.223 ns (0.00% GC)

samples:          10000

evals/sample:     969

# GridWorlds.GridRooms

#### GridWorlds.GridRooms()

memory estimate:  14.42 KiB

allocs estimate:  389

minimum time:     13.467 μs (0.00% GC)

median time:      14.840 μs (0.00% GC)

mean time:        17.340 μs (6.27% GC)

maximum time:     3.891 ms (98.85% GC)

samples:          10000

evals/sample:     1

#### RLBase.reset!(env)

memory estimate:  32 bytes

allocs estimate:  1

minimum time:     284.829 ns (0.00% GC)

median time:      306.424 ns (0.00% GC)

mean time:        313.456 ns (0.21% GC)

maximum time:     6.945 μs (95.10% GC)

samples:          10000

evals/sample:     257

#### RLBase.state(env)

memory estimate:  1.47 KiB

allocs estimate:  25

minimum time:     1.082 μs (0.00% GC)

median time:      1.199 μs (0.00% GC)

mean time:        1.405 μs (6.32% GC)

maximum time:     305.921 μs (99.26% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.170 ns (0.00% GC)

median time:      2.261 ns (0.00% GC)

mean time:        2.259 ns (0.00% GC)

maximum time:     15.071 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  32 bytes

allocs estimate:  1

minimum time:     31.923 ns (0.00% GC)

median time:      34.235 ns (0.00% GC)

mean time:        37.209 ns (2.71% GC)

maximum time:     1.849 μs (97.92% GC)

samples:          10000

evals/sample:     992

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.814 ns (0.00% GC)

median time:      1.889 ns (0.00% GC)

mean time:        1.885 ns (0.00% GC)

maximum time:     14.636 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     68.834 ns (0.00% GC)

median time:      70.303 ns (0.00% GC)

mean time:        72.260 ns (0.00% GC)

maximum time:     213.076 ns (0.00% GC)

samples:          10000

evals/sample:     972

#### env(GridWorlds.MoveForward())

memory estimate:  112 bytes

allocs estimate:  4

minimum time:     118.565 ns (0.00% GC)

median time:      120.373 ns (0.00% GC)

mean time:        129.008 ns (3.56% GC)

maximum time:     2.543 μs (95.09% GC)

samples:          10000

evals/sample:     911

#### env(GridWorlds.TurnLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     68.397 ns (0.00% GC)

median time:      70.437 ns (0.00% GC)

mean time:        71.709 ns (0.00% GC)

maximum time:     189.876 ns (0.00% GC)

samples:          10000

evals/sample:     970

# GridWorlds.SequentialRooms

#### GridWorlds.SequentialRooms()

memory estimate:  1.43 MiB

allocs estimate:  15497

minimum time:     1.267 ms (0.00% GC)

median time:      2.016 ms (0.00% GC)

mean time:        2.177 ms (8.02% GC)

maximum time:     6.147 ms (52.34% GC)

samples:          2296

evals/sample:     1

#### RLBase.reset!(env)

memory estimate:  1.43 MiB

allocs estimate:  15491

minimum time:     1.260 ms (0.00% GC)

median time:      2.020 ms (0.00% GC)

mean time:        2.180 ms (8.03% GC)

maximum time:     6.555 ms (62.48% GC)

samples:          2293

evals/sample:     1

#### RLBase.state(env)

memory estimate:  10.36 KiB

allocs estimate:  167

minimum time:     7.157 μs (0.00% GC)

median time:      7.641 μs (0.00% GC)

mean time:        8.770 μs (7.74% GC)

maximum time:     837.749 μs (98.48% GC)

samples:          10000

evals/sample:     4

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.169 ns (0.00% GC)

median time:      2.254 ns (0.00% GC)

mean time:        2.237 ns (0.00% GC)

maximum time:     15.101 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  32 bytes

allocs estimate:  1

minimum time:     32.473 ns (0.00% GC)

median time:      34.105 ns (0.00% GC)

mean time:        37.488 ns (2.95% GC)

maximum time:     1.999 μs (97.81% GC)

samples:          10000

evals/sample:     992

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.813 ns (0.00% GC)

median time:      1.889 ns (0.00% GC)

mean time:        1.894 ns (0.00% GC)

maximum time:     14.761 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     69.548 ns (0.00% GC)

median time:      71.938 ns (0.00% GC)

mean time:        73.570 ns (0.00% GC)

maximum time:     462.938 ns (0.00% GC)

samples:          10000

evals/sample:     969

#### env(GridWorlds.MoveForward())

memory estimate:  112 bytes

allocs estimate:  4

minimum time:     123.516 ns (0.00% GC)

median time:      125.613 ns (0.00% GC)

mean time:        135.227 ns (3.70% GC)

maximum time:     2.522 μs (94.79% GC)

samples:          10000

evals/sample:     905

#### env(GridWorlds.TurnLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     69.338 ns (0.00% GC)

median time:      71.930 ns (0.00% GC)

mean time:        73.681 ns (0.00% GC)

maximum time:     208.833 ns (0.00% GC)

samples:          10000

evals/sample:     969

# GridWorlds.Maze

#### GridWorlds.Maze()

memory estimate:  26.28 KiB

allocs estimate:  284

minimum time:     26.137 μs (0.00% GC)

median time:      27.331 μs (0.00% GC)

mean time:        30.523 μs (4.99% GC)

maximum time:     3.305 ms (98.21% GC)

samples:          10000

evals/sample:     1

#### RLBase.reset!(env)

memory estimate:  26.00 KiB

allocs estimate:  279

minimum time:     25.671 μs (0.00% GC)

median time:      26.749 μs (0.00% GC)

mean time:        29.706 μs (5.39% GC)

maximum time:     3.997 ms (97.02% GC)

samples:          10000

evals/sample:     1

#### RLBase.state(env)

memory estimate:  3.34 KiB

allocs estimate:  55

minimum time:     2.368 μs (0.00% GC)

median time:      2.560 μs (0.00% GC)

mean time:        2.932 μs (7.28% GC)

maximum time:     387.830 μs (98.83% GC)

samples:          10000

evals/sample:     9

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.815 ns (0.00% GC)

median time:      1.888 ns (0.00% GC)

mean time:        1.912 ns (0.00% GC)

maximum time:     14.909 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  32 bytes

allocs estimate:  1

minimum time:     32.257 ns (0.00% GC)

median time:      34.250 ns (0.00% GC)

mean time:        37.364 ns (3.03% GC)

maximum time:     1.976 μs (97.81% GC)

samples:          10000

evals/sample:     992

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.814 ns (0.00% GC)

median time:      1.890 ns (0.00% GC)

mean time:        1.909 ns (0.00% GC)

maximum time:     15.953 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     68.885 ns (0.00% GC)

median time:      71.985 ns (0.00% GC)

mean time:        73.470 ns (0.00% GC)

maximum time:     225.196 ns (0.00% GC)

samples:          10000

evals/sample:     975

#### env(GridWorlds.MoveForward())

memory estimate:  112 bytes

allocs estimate:  4

minimum time:     119.198 ns (0.00% GC)

median time:      121.345 ns (0.00% GC)

mean time:        130.364 ns (3.94% GC)

maximum time:     2.730 μs (94.28% GC)

samples:          10000

evals/sample:     909

#### env(GridWorlds.TurnLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     68.850 ns (0.00% GC)

median time:      70.731 ns (0.00% GC)

mean time:        72.527 ns (0.00% GC)

maximum time:     189.751 ns (0.00% GC)

samples:          10000

evals/sample:     969

# GridWorlds.GoToDoor

#### GridWorlds.GoToDoor()

memory estimate:  5.20 KiB

allocs estimate:  94

minimum time:     18.796 μs (0.00% GC)

median time:      21.018 μs (0.00% GC)

mean time:        21.919 μs (2.00% GC)

maximum time:     4.423 ms (99.23% GC)

samples:          10000

evals/sample:     1

#### RLBase.reset!(env)

memory estimate:  1.53 KiB

allocs estimate:  27

minimum time:     1.073 μs (0.00% GC)

median time:      1.322 μs (0.00% GC)

mean time:        1.540 μs (5.91% GC)

maximum time:     322.468 μs (98.88% GC)

samples:          10000

evals/sample:     10

#### RLBase.state(env)

memory estimate:  2.13 KiB

allocs estimate:  36

minimum time:     1.702 μs (0.00% GC)

median time:      1.910 μs (0.00% GC)

mean time:        2.177 μs (6.94% GC)

maximum time:     385.752 μs (99.17% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.529 ns (0.00% GC)

median time:      2.551 ns (0.00% GC)

mean time:        2.616 ns (0.00% GC)

maximum time:     15.686 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  32 bytes

allocs estimate:  1

minimum time:     45.879 ns (0.00% GC)

median time:      47.413 ns (0.00% GC)

mean time:        51.149 ns (2.37% GC)

maximum time:     2.113 μs (97.47% GC)

samples:          10000

evals/sample:     986

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.814 ns (0.00% GC)

median time:      1.889 ns (0.00% GC)

mean time:        1.906 ns (0.00% GC)

maximum time:     24.549 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     69.449 ns (0.00% GC)

median time:      70.593 ns (0.00% GC)

mean time:        72.600 ns (0.00% GC)

maximum time:     289.689 ns (0.00% GC)

samples:          10000

evals/sample:     970

#### env(GridWorlds.MoveForward())

memory estimate:  112 bytes

allocs estimate:  4

minimum time:     137.481 ns (0.00% GC)

median time:      141.040 ns (0.00% GC)

mean time:        150.525 ns (3.59% GC)

maximum time:     2.980 μs (95.00% GC)

samples:          10000

evals/sample:     842

#### env(GridWorlds.TurnLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     68.398 ns (0.00% GC)

median time:      70.424 ns (0.00% GC)

mean time:        71.943 ns (0.00% GC)

maximum time:     592.441 ns (0.00% GC)

samples:          10000

evals/sample:     970

# GridWorlds.DoorKey

#### GridWorlds.DoorKey()

memory estimate:  1.84 KiB

allocs estimate:  40

minimum time:     2.781 μs (0.00% GC)

median time:      2.926 μs (0.00% GC)

mean time:        3.228 μs (4.65% GC)

maximum time:     513.764 μs (98.89% GC)

samples:          10000

evals/sample:     9

#### RLBase.reset!(env)

memory estimate:  64 bytes

allocs estimate:  2

minimum time:     544.786 ns (0.00% GC)

median time:      562.706 ns (0.00% GC)

mean time:        580.246 ns (0.39% GC)

maximum time:     12.524 μs (93.99% GC)

samples:          10000

evals/sample:     187

#### RLBase.state(env)

memory estimate:  2.22 KiB

allocs estimate:  37

minimum time:     1.670 μs (0.00% GC)

median time:      1.845 μs (0.00% GC)

mean time:        2.105 μs (7.07% GC)

maximum time:     404.500 μs (99.07% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.530 ns (0.00% GC)

median time:      2.631 ns (0.00% GC)

mean time:        2.631 ns (0.00% GC)

maximum time:     17.172 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  32 bytes

allocs estimate:  1

minimum time:     29.903 ns (0.00% GC)

median time:      31.983 ns (0.00% GC)

mean time:        35.635 ns (3.74% GC)

maximum time:     2.915 μs (97.61% GC)

samples:          10000

evals/sample:     993

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.831 ns (0.00% GC)

median time:      1.907 ns (0.00% GC)

mean time:        1.929 ns (0.00% GC)

maximum time:     17.282 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     69.687 ns (0.00% GC)

median time:      70.980 ns (0.00% GC)

mean time:        73.059 ns (0.00% GC)

maximum time:     243.497 ns (0.00% GC)

samples:          10000

evals/sample:     970

#### env(GridWorlds.PickUp())

memory estimate:  32 bytes

allocs estimate:  1

minimum time:     35.410 ns (0.00% GC)

median time:      37.369 ns (0.00% GC)

mean time:        40.790 ns (3.13% GC)

maximum time:     2.294 μs (97.56% GC)

samples:          10000

evals/sample:     991

#### env(GridWorlds.MoveForward())

memory estimate:  128 bytes

allocs estimate:  5

minimum time:     143.313 ns (0.00% GC)

median time:      146.609 ns (0.00% GC)

mean time:        157.930 ns (4.14% GC)

maximum time:     3.381 μs (95.22% GC)

samples:          10000

evals/sample:     846

#### env(GridWorlds.TurnLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     68.939 ns (0.00% GC)

median time:      70.462 ns (0.00% GC)

mean time:        72.716 ns (0.00% GC)

maximum time:     244.690 ns (0.00% GC)

samples:          10000

evals/sample:     970

# GridWorlds.CollectGems

#### GridWorlds.CollectGems()

memory estimate:  2.20 KiB

allocs estimate:  44

minimum time:     3.158 μs (0.00% GC)

median time:      3.480 μs (0.00% GC)

mean time:        3.820 μs (4.29% GC)

maximum time:     554.837 μs (98.83% GC)

samples:          10000

evals/sample:     8

#### RLBase.reset!(env)

memory estimate:  336 bytes

allocs estimate:  4

minimum time:     901.100 ns (0.00% GC)

median time:      1.204 μs (0.00% GC)

mean time:        1.232 μs (0.00% GC)

maximum time:     4.409 μs (0.00% GC)

samples:          10000

evals/sample:     10

#### RLBase.state(env)

memory estimate:  3.34 KiB

allocs estimate:  55

minimum time:     2.374 μs (0.00% GC)

median time:      2.629 μs (0.00% GC)

mean time:        3.003 μs (8.22% GC)

maximum time:     433.943 μs (98.97% GC)

samples:          10000

evals/sample:     9

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.529 ns (0.00% GC)

median time:      2.630 ns (0.00% GC)

mean time:        2.640 ns (0.00% GC)

maximum time:     17.371 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.819 ns (0.00% GC)

median time:      1.909 ns (0.00% GC)

mean time:        1.924 ns (0.00% GC)

maximum time:     20.928 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.814 ns (0.00% GC)

median time:      1.889 ns (0.00% GC)

mean time:        1.915 ns (0.00% GC)

maximum time:     20.084 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     68.739 ns (0.00% GC)

median time:      71.443 ns (0.00% GC)

mean time:        74.016 ns (0.00% GC)

maximum time:     215.794 ns (0.00% GC)

samples:          10000

evals/sample:     970

#### env(GridWorlds.MoveForward())

memory estimate:  112 bytes

allocs estimate:  4

minimum time:     119.495 ns (0.00% GC)

median time:      124.637 ns (0.00% GC)

mean time:        141.792 ns (4.54% GC)

maximum time:     4.240 μs (95.07% GC)

samples:          10000

evals/sample:     905

#### env(GridWorlds.TurnLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     69.902 ns (0.00% GC)

median time:      73.199 ns (0.00% GC)

mean time:        78.469 ns (0.00% GC)

maximum time:     294.498 ns (0.00% GC)

samples:          10000

evals/sample:     968

# GridWorlds.DynamicObstacles

#### GridWorlds.DynamicObstacles()

memory estimate:  2.08 KiB

allocs estimate:  43

minimum time:     2.989 μs (0.00% GC)

median time:      3.305 μs (0.00% GC)

mean time:        3.630 μs (4.89% GC)

maximum time:     604.203 μs (99.00% GC)

samples:          10000

evals/sample:     8

#### RLBase.reset!(env)

memory estimate:  192 bytes

allocs estimate:  3

minimum time:     694.104 ns (0.00% GC)

median time:      740.720 ns (0.00% GC)

mean time:        770.609 ns (1.46% GC)

maximum time:     23.813 μs (96.43% GC)

samples:          10000

evals/sample:     134

#### RLBase.state(env)

memory estimate:  1.72 KiB

allocs estimate:  29

minimum time:     1.336 μs (0.00% GC)

median time:      1.491 μs (0.00% GC)

mean time:        1.731 μs (6.93% GC)

maximum time:     406.495 μs (99.31% GC)

samples:          10000

evals/sample:     10

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.622 ns (0.00% GC)

median time:      2.760 ns (0.00% GC)

mean time:        3.343 ns (0.00% GC)

maximum time:     101.432 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  64 bytes

allocs estimate:  2

minimum time:     61.952 ns (0.00% GC)

median time:      68.733 ns (0.00% GC)

mean time:        82.064 ns (4.43% GC)

maximum time:     5.996 μs (98.14% GC)

samples:          10000

evals/sample:     971

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.881 ns (0.00% GC)

median time:      1.892 ns (0.00% GC)

mean time:        1.951 ns (0.00% GC)

maximum time:     15.098 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  5.25 KiB

allocs estimate:  42

minimum time:     2.028 μs (0.00% GC)

median time:      2.147 μs (0.00% GC)

mean time:        2.636 μs (9.73% GC)

maximum time:     274.669 μs (98.71% GC)

samples:          10000

evals/sample:     9

#### env(GridWorlds.MoveForward())

memory estimate:  5.33 KiB

allocs estimate:  45

minimum time:     2.070 μs (0.00% GC)

median time:      2.169 μs (0.00% GC)

mean time:        2.645 μs (10.02% GC)

maximum time:     287.762 μs (98.74% GC)

samples:          10000

evals/sample:     9

#### env(GridWorlds.TurnLeft())

memory estimate:  5.25 KiB

allocs estimate:  42

minimum time:     2.024 μs (0.00% GC)

median time:      2.155 μs (0.00% GC)

mean time:        2.663 μs (10.00% GC)

maximum time:     300.390 μs (98.68% GC)

samples:          10000

evals/sample:     9

# GridWorlds.Sokoban

#### GridWorlds.Sokoban()

memory estimate:  888.08 KiB

allocs estimate:  24662

minimum time:     1.438 ms (0.00% GC)

median time:      1.625 ms (0.00% GC)

mean time:        1.764 ms (4.63% GC)

maximum time:     8.664 ms (67.36% GC)

samples:          2831

evals/sample:     1

#### RLBase.reset!(env)

memory estimate:  512 bytes

allocs estimate:  6

minimum time:     2.866 μs (0.00% GC)

median time:      3.597 μs (0.00% GC)

mean time:        4.155 μs (1.23% GC)

maximum time:     517.702 μs (98.92% GC)

samples:          10000

evals/sample:     9

#### RLBase.state(env)

memory estimate:  1.33 KiB

allocs estimate:  27

minimum time:     2.963 μs (0.00% GC)

median time:      3.147 μs (0.00% GC)

mean time:        3.410 μs (3.57% GC)

maximum time:     617.009 μs (99.13% GC)

samples:          10000

evals/sample:     9

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.529 ns (0.00% GC)

median time:      2.627 ns (0.00% GC)

mean time:        2.639 ns (0.00% GC)

maximum time:     15.707 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     8.421 ns (0.00% GC)

median time:      9.007 ns (0.00% GC)

mean time:        10.011 ns (0.00% GC)

maximum time:     33.920 ns (0.00% GC)

samples:          10000

evals/sample:     999

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.816 ns (0.00% GC)

median time:      1.889 ns (0.00% GC)

mean time:        1.902 ns (0.00% GC)

maximum time:     14.939 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.MoveDown())

memory estimate:  32 bytes

allocs estimate:  1

minimum time:     67.654 ns (0.00% GC)

median time:      70.586 ns (0.00% GC)

mean time:        75.940 ns (1.98% GC)

maximum time:     2.908 μs (97.28% GC)

samples:          10000

evals/sample:     973

#### env(GridWorlds.MoveUp())

memory estimate:  32 bytes

allocs estimate:  1

minimum time:     68.740 ns (0.00% GC)

median time:      70.362 ns (0.00% GC)

mean time:        75.687 ns (1.99% GC)

maximum time:     2.869 μs (97.28% GC)

samples:          10000

evals/sample:     973

#### env(GridWorlds.MoveLeft())

memory estimate:  32 bytes

allocs estimate:  1

minimum time:     70.022 ns (0.00% GC)

median time:      73.146 ns (0.00% GC)

mean time:        78.725 ns (1.92% GC)

maximum time:     2.705 μs (95.77% GC)

samples:          10000

evals/sample:     966

#### env(GridWorlds.MoveRight())

memory estimate:  32 bytes

allocs estimate:  1

minimum time:     67.776 ns (0.00% GC)

median time:      71.605 ns (0.00% GC)

mean time:        76.444 ns (2.12% GC)

maximum time:     3.011 μs (97.42% GC)

samples:          10000

evals/sample:     974

# GridWorlds.Snake

#### GridWorlds.Snake()

memory estimate:  18.33 KiB

allocs estimate:  53

minimum time:     4.001 μs (0.00% GC)

median time:      4.163 μs (0.00% GC)

mean time:        5.132 μs (14.98% GC)

maximum time:     311.435 μs (96.79% GC)

samples:          10000

evals/sample:     7

#### RLBase.reset!(env)

memory estimate:  256 bytes

allocs estimate:  9

minimum time:     612.547 ns (0.00% GC)

median time:      654.382 ns (0.00% GC)

mean time:        695.479 ns (2.20% GC)

maximum time:     18.461 μs (95.83% GC)

samples:          10000

evals/sample:     170

#### RLBase.state(env)

memory estimate:  1.31 KiB

allocs estimate:  27

minimum time:     2.382 μs (0.00% GC)

median time:      2.498 μs (0.00% GC)

mean time:        2.901 μs (4.83% GC)

maximum time:     737.103 μs (99.29% GC)

samples:          10000

evals/sample:     9

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.529 ns (0.00% GC)

median time:      2.629 ns (0.00% GC)

mean time:        2.735 ns (0.00% GC)

maximum time:     15.592 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.816 ns (0.00% GC)

median time:      1.893 ns (0.00% GC)

mean time:        1.922 ns (0.00% GC)

maximum time:     14.988 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.814 ns (0.00% GC)

median time:      1.890 ns (0.00% GC)

mean time:        1.927 ns (0.00% GC)

maximum time:     19.940 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.MoveDown())

memory estimate:  32 bytes

allocs estimate:  1

minimum time:     50.173 ns (0.00% GC)

median time:      58.790 ns (0.00% GC)

mean time:        63.948 ns (2.65% GC)

maximum time:     3.363 μs (97.42% GC)

samples:          10000

evals/sample:     982

#### env(GridWorlds.MoveUp())

memory estimate:  32 bytes

allocs estimate:  1

minimum time:     52.110 ns (0.00% GC)

median time:      57.705 ns (0.00% GC)

mean time:        64.032 ns (2.95% GC)

maximum time:     4.278 μs (97.78% GC)

samples:          10000

evals/sample:     983

#### env(GridWorlds.MoveLeft())

memory estimate:  32 bytes

allocs estimate:  1

minimum time:     51.240 ns (0.00% GC)

median time:      53.921 ns (0.00% GC)

mean time:        59.559 ns (2.73% GC)

maximum time:     3.112 μs (97.22% GC)

samples:          10000

evals/sample:     983

#### env(GridWorlds.MoveRight())

memory estimate:  32 bytes

allocs estimate:  1

minimum time:     49.517 ns (0.00% GC)

median time:      56.054 ns (0.00% GC)

mean time:        73.694 ns (2.57% GC)

maximum time:     4.448 μs (97.89% GC)

samples:          10000

evals/sample:     983

# GridWorlds.Catcher

#### GridWorlds.Catcher()

memory estimate:  368 bytes

allocs estimate:  7

minimum time:     646.175 ns (0.00% GC)

median time:      680.084 ns (0.00% GC)

mean time:        789.179 ns (4.48% GC)

maximum time:     31.546 μs (97.23% GC)

samples:          10000

evals/sample:     160

#### RLBase.reset!(env)

memory estimate:  64 bytes

allocs estimate:  2

minimum time:     128.924 ns (0.00% GC)

median time:      137.483 ns (0.00% GC)

mean time:        149.713 ns (2.63% GC)

maximum time:     4.082 μs (95.76% GC)

samples:          10000

evals/sample:     864

#### RLBase.state(env)

memory estimate:  1.30 KiB

allocs estimate:  27

minimum time:     2.356 μs (0.00% GC)

median time:      2.506 μs (0.00% GC)

mean time:        2.841 μs (4.64% GC)

maximum time:     675.344 μs (98.99% GC)

samples:          10000

evals/sample:     9

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.882 ns (0.00% GC)

median time:      1.890 ns (0.00% GC)

mean time:        1.969 ns (0.00% GC)

maximum time:     15.093 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     3.604 ns (0.00% GC)

median time:      3.741 ns (0.00% GC)

mean time:        3.757 ns (0.00% GC)

maximum time:     19.681 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.899 ns (0.00% GC)

median time:      1.907 ns (0.00% GC)

mean time:        1.957 ns (0.00% GC)

maximum time:     30.758 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.MoveLeft())

memory estimate:  64 bytes

allocs estimate:  2

minimum time:     78.502 ns (0.00% GC)

median time:      82.907 ns (0.00% GC)

mean time:        104.783 ns (3.78% GC)

maximum time:     3.954 μs (95.69% GC)

samples:          10000

evals/sample:     957

#### env(GridWorlds.MoveRight())

memory estimate:  64 bytes

allocs estimate:  2

minimum time:     77.696 ns (0.00% GC)

median time:      84.240 ns (0.00% GC)

mean time:        111.719 ns (3.59% GC)

maximum time:     3.710 μs (94.39% GC)

samples:          10000

evals/sample:     961

#### env(GridWorlds.MoveCenter())

memory estimate:  64 bytes

allocs estimate:  2

minimum time:     77.866 ns (0.00% GC)

median time:      81.898 ns (0.00% GC)

mean time:        91.295 ns (4.24% GC)

maximum time:     3.311 μs (95.00% GC)

samples:          10000

evals/sample:     962

# GridWorlds.Transport

#### GridWorlds.Transport()

memory estimate:  1.95 KiB

allocs estimate:  44

minimum time:     3.126 μs (0.00% GC)

median time:      3.525 μs (0.00% GC)

mean time:        3.905 μs (5.22% GC)

maximum time:     696.673 μs (98.95% GC)

samples:          10000

evals/sample:     8

#### RLBase.reset!(env)

memory estimate:  160 bytes

allocs estimate:  5

minimum time:     699.178 ns (0.00% GC)

median time:      752.581 ns (0.00% GC)

mean time:        797.502 ns (1.14% GC)

maximum time:     24.476 μs (96.49% GC)

samples:          10000

evals/sample:     129

#### RLBase.state(env)

memory estimate:  3.34 KiB

allocs estimate:  55

minimum time:     2.699 μs (0.00% GC)

median time:      2.836 μs (0.00% GC)

mean time:        3.431 μs (9.02% GC)

maximum time:     563.917 μs (99.26% GC)

samples:          10000

evals/sample:     9

#### RLBase.action_space(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     2.249 ns (0.00% GC)

median time:      2.339 ns (0.00% GC)

mean time:        2.545 ns (0.00% GC)

maximum time:     55.163 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### RLBase.is_terminated(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     6.033 ns (0.00% GC)

median time:      6.533 ns (0.00% GC)

mean time:        7.063 ns (0.00% GC)

maximum time:     38.545 ns (0.00% GC)

samples:          10000

evals/sample:     999

#### RLBase.reward(env)

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     1.880 ns (0.00% GC)

median time:      1.963 ns (0.00% GC)

mean time:        2.155 ns (0.00% GC)

maximum time:     40.372 ns (0.00% GC)

samples:          10000

evals/sample:     1000

#### env(GridWorlds.TurnRight())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     76.139 ns (0.00% GC)

median time:      83.502 ns (0.00% GC)

mean time:        88.995 ns (0.00% GC)

maximum time:     249.073 ns (0.00% GC)

samples:          10000

evals/sample:     964

#### env(GridWorlds.Drop())

memory estimate:  32 bytes

allocs estimate:  1

minimum time:     44.313 ns (0.00% GC)

median time:      51.687 ns (0.00% GC)

mean time:        60.396 ns (3.25% GC)

maximum time:     3.952 μs (97.98% GC)

samples:          10000

evals/sample:     986

#### env(GridWorlds.PickUp())

memory estimate:  32 bytes

allocs estimate:  1

minimum time:     37.404 ns (0.00% GC)

median time:      42.383 ns (0.00% GC)

mean time:        52.007 ns (5.02% GC)

maximum time:     7.190 μs (99.01% GC)

samples:          10000

evals/sample:     991

#### env(GridWorlds.MoveForward())

memory estimate:  80 bytes

allocs estimate:  3

minimum time:     92.637 ns (0.00% GC)

median time:      100.619 ns (0.00% GC)

mean time:        114.322 ns (5.21% GC)

maximum time:     4.303 μs (97.43% GC)

samples:          10000

evals/sample:     944

#### env(GridWorlds.TurnLeft())

memory estimate:  0 bytes

allocs estimate:  0

minimum time:     69.715 ns (0.00% GC)

median time:      75.133 ns (0.00% GC)

mean time:        81.087 ns (0.00% GC)

maximum time:     215.354 ns (0.00% GC)

samples:          10000

evals/sample:     969

