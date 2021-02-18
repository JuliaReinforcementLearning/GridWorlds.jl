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
BenchmarkTools.Trial: 
  memory estimate:  2.36 KiB
  allocs estimate:  29
  --------------
  minimum time:     1.969 μs (0.00% GC)
  median time:      2.367 μs (0.00% GC)
  mean time:        2.993 μs (4.86% GC)
  maximum time:     445.402 μs (98.26% GC)
  --------------
  samples:          10000
  evals/sample:     9
#### RLBase.reset!(env)
BenchmarkTools.Trial: 
  memory estimate:  32 bytes
  allocs estimate:  1
  --------------
  minimum time:     264.636 ns (0.00% GC)
  median time:      295.987 ns (0.00% GC)
  mean time:        344.724 ns (0.32% GC)
  maximum time:     5.851 μs (93.02% GC)
  --------------
  samples:          10000
  evals/sample:     313
#### RLBase.state(env)
BenchmarkTools.Trial: 
  memory estimate:  2.22 KiB
  allocs estimate:  37
  --------------
  minimum time:     1.619 μs (0.00% GC)
  median time:      1.801 μs (0.00% GC)
  mean time:        2.105 μs (5.88% GC)
  maximum time:     324.798 μs (99.22% GC)
  --------------
  samples:          10000
  evals/sample:     10
#### RLBase.action_space(env)
BenchmarkTools.Trial: 
  memory estimate:  0 bytes
  allocs estimate:  0
  --------------
  minimum time:     0.026 ns (0.00% GC)
  median time:      0.030 ns (0.00% GC)
  mean time:        0.030 ns (0.00% GC)
  maximum time:     0.052 ns (0.00% GC)
  --------------
  samples:          10000
  evals/sample:     1000
#### RLBase.is_terminated(env)
BenchmarkTools.Trial: 
  memory estimate:  32 bytes
  allocs estimate:  1
  --------------
  minimum time:     31.225 ns (0.00% GC)
  median time:      33.982 ns (0.00% GC)
  mean time:        39.050 ns (2.90% GC)
  maximum time:     2.105 μs (97.96% GC)
  --------------
  samples:          10000
  evals/sample:     992
#### RLBase.reward(env)
BenchmarkTools.Trial: 
  memory estimate:  0 bytes
  allocs estimate:  0
  --------------
  minimum time:     1.812 ns (0.00% GC)
  median time:      1.887 ns (0.00% GC)
  mean time:        1.995 ns (0.00% GC)
  maximum time:     20.483 ns (0.00% GC)
  --------------
  samples:          10000
  evals/sample:     1000
#### env(GridWorlds.TurnRight())
BenchmarkTools.Trial: 
  memory estimate:  0 bytes
  allocs estimate:  0
  --------------
  minimum time:     67.834 ns (0.00% GC)
  median time:      79.054 ns (0.00% GC)
  mean time:        90.770 ns (0.00% GC)
  maximum time:     1.229 μs (0.00% GC)
  --------------
  samples:          10000
  evals/sample:     970
#### env(GridWorlds.MoveForward())
BenchmarkTools.Trial: 
  memory estimate:  96 bytes
  allocs estimate:  3
  --------------
  minimum time:     94.347 ns (0.00% GC)
  median time:      99.204 ns (0.00% GC)
  mean time:        110.633 ns (3.46% GC)
  maximum time:     2.443 μs (94.79% GC)
  --------------
  samples:          10000
  evals/sample:     935
#### env(GridWorlds.TurnLeft())
BenchmarkTools.Trial: 
  memory estimate:  0 bytes
  allocs estimate:  0
  --------------
  minimum time:     67.179 ns (0.00% GC)
  median time:      70.956 ns (0.00% GC)
  mean time:        76.583 ns (0.00% GC)
  maximum time:     243.759 ns (0.00% GC)
  --------------
  samples:          10000
  evals/sample:     971
# GridWorlds.GridRooms
#### GridWorlds.GridRooms()
BenchmarkTools.Trial: 
  memory estimate:  13.16 KiB
  allocs estimate:  348
  --------------
  minimum time:     11.433 μs (0.00% GC)
  median time:      12.854 μs (0.00% GC)
  mean time:        15.022 μs (4.78% GC)
  maximum time:     3.777 ms (99.40% GC)
  --------------
  samples:          10000
  evals/sample:     1
#### RLBase.reset!(env)
BenchmarkTools.Trial: 
  memory estimate:  32 bytes
  allocs estimate:  1
  --------------
  minimum time:     282.087 ns (0.00% GC)
  median time:      313.055 ns (0.00% GC)
  mean time:        330.130 ns (0.23% GC)
  maximum time:     7.849 μs (95.61% GC)
  --------------
  samples:          10000
  evals/sample:     264
#### RLBase.state(env)
BenchmarkTools.Trial: 
  memory estimate:  1.47 KiB
  allocs estimate:  25
  --------------
  minimum time:     1.038 μs (0.00% GC)
  median time:      1.184 μs (0.00% GC)
  mean time:        1.403 μs (8.14% GC)
  maximum time:     449.418 μs (99.54% GC)
  --------------
  samples:          10000
  evals/sample:     10
#### RLBase.action_space(env)
BenchmarkTools.Trial: 
  memory estimate:  0 bytes
  allocs estimate:  0
  --------------
  minimum time:     0.024 ns (0.00% GC)
  median time:      0.028 ns (0.00% GC)
  mean time:        0.028 ns (0.00% GC)
  maximum time:     0.055 ns (0.00% GC)
  --------------
  samples:          10000
  evals/sample:     1000
#### RLBase.is_terminated(env)
BenchmarkTools.Trial: 
  memory estimate:  32 bytes
  allocs estimate:  1
  --------------
  minimum time:     30.756 ns (0.00% GC)
  median time:      33.538 ns (0.00% GC)
  mean time:        38.626 ns (3.22% GC)
  maximum time:     2.229 μs (98.23% GC)
  --------------
  samples:          10000
  evals/sample:     993
#### RLBase.reward(env)
BenchmarkTools.Trial: 
  memory estimate:  0 bytes
  allocs estimate:  0
  --------------
  minimum time:     1.813 ns (0.00% GC)
  median time:      1.887 ns (0.00% GC)
  mean time:        1.894 ns (0.00% GC)
  maximum time:     15.442 ns (0.00% GC)
  --------------
  samples:          10000
  evals/sample:     1000
#### env(GridWorlds.TurnRight())
BenchmarkTools.Trial: 
  memory estimate:  0 bytes
  allocs estimate:  0
  --------------
  minimum time:     67.406 ns (0.00% GC)
  median time:      69.890 ns (0.00% GC)
  mean time:        74.792 ns (0.00% GC)
  maximum time:     216.223 ns (0.00% GC)
  --------------
  samples:          10000
  evals/sample:     971
#### env(GridWorlds.MoveForward())
BenchmarkTools.Trial: 
  memory estimate:  96 bytes
  allocs estimate:  3
  --------------
  minimum time:     94.637 ns (0.00% GC)
  median time:      97.299 ns (0.00% GC)
  mean time:        109.680 ns (3.94% GC)
  maximum time:     2.779 μs (93.28% GC)
  --------------
  samples:          10000
  evals/sample:     940
#### env(GridWorlds.TurnLeft())
BenchmarkTools.Trial: 
  memory estimate:  0 bytes
  allocs estimate:  0
  --------------
  minimum time:     67.103 ns (0.00% GC)
  median time:      69.457 ns (0.00% GC)
  mean time:        74.432 ns (0.00% GC)
  maximum time:     210.537 ns (0.00% GC)
  --------------
  samples:          10000
  evals/sample:     972
# GridWorlds.SequentialRooms
#### GridWorlds.SequentialRooms()
BenchmarkTools.Trial: 
  memory estimate:  1.33 MiB
  allocs estimate:  12432
  --------------
  minimum time:     1.185 ms (0.00% GC)
  median time:      1.876 ms (0.00% GC)
  mean time:        2.039 ms (7.33% GC)
  maximum time:     6.275 ms (57.13% GC)
  --------------
  samples:          2452
  evals/sample:     1
#### RLBase.reset!(env)
BenchmarkTools.Trial: 
  memory estimate:  1.33 MiB
  allocs estimate:  12427
  --------------
  minimum time:     1.183 ms (0.00% GC)
  median time:      1.931 ms (0.00% GC)
  mean time:        2.147 ms (7.31% GC)
  maximum time:     10.512 ms (53.80% GC)
  --------------
  samples:          2329
  evals/sample:     1
#### RLBase.state(env)
BenchmarkTools.Trial: 
  memory estimate:  9.23 KiB
  allocs estimate:  149
  --------------
  minimum time:     6.982 μs (0.00% GC)
  median time:      7.404 μs (0.00% GC)
  mean time:        9.778 μs (9.73% GC)
  maximum time:     1.230 ms (99.15% GC)
  --------------
  samples:          10000
  evals/sample:     5
#### RLBase.action_space(env)
BenchmarkTools.Trial: 
  memory estimate:  0 bytes
  allocs estimate:  0
  --------------
  minimum time:     0.028 ns (0.00% GC)
  median time:      0.032 ns (0.00% GC)
  mean time:        0.032 ns (0.00% GC)
  maximum time:     0.156 ns (0.00% GC)
  --------------
  samples:          10000
  evals/sample:     1000
#### RLBase.is_terminated(env)
BenchmarkTools.Trial: 
  memory estimate:  32 bytes
  allocs estimate:  1
  --------------
  minimum time:     34.386 ns (0.00% GC)
  median time:      38.966 ns (0.00% GC)
  mean time:        55.831 ns (3.90% GC)
  maximum time:     5.615 μs (98.60% GC)
  --------------
  samples:          10000
  evals/sample:     991
#### RLBase.reward(env)
BenchmarkTools.Trial: 
  memory estimate:  0 bytes
  allocs estimate:  0
  --------------
  minimum time:     1.880 ns (0.00% GC)
  median time:      1.889 ns (0.00% GC)
  mean time:        1.980 ns (0.00% GC)
  maximum time:     21.143 ns (0.00% GC)
  --------------
  samples:          10000
  evals/sample:     1000
#### env(GridWorlds.TurnRight())
BenchmarkTools.Trial: 
  memory estimate:  0 bytes
  allocs estimate:  0
  --------------
  minimum time:     68.348 ns (0.00% GC)
  median time:      75.375 ns (0.00% GC)
  mean time:        85.017 ns (0.00% GC)
  maximum time:     237.275 ns (0.00% GC)
  --------------
  samples:          10000
  evals/sample:     971
#### env(GridWorlds.MoveForward())
BenchmarkTools.Trial: 
  memory estimate:  96 bytes
  allocs estimate:  3
  --------------
  minimum time:     102.715 ns (0.00% GC)
  median time:      115.919 ns (0.00% GC)
  mean time:        139.142 ns (3.87% GC)
  maximum time:     4.279 μs (97.22% GC)
  --------------
  samples:          10000
  evals/sample:     923
#### env(GridWorlds.TurnLeft())
BenchmarkTools.Trial: 
  memory estimate:  0 bytes
  allocs estimate:  0
  --------------
  minimum time:     67.435 ns (0.00% GC)
  median time:      73.707 ns (0.00% GC)
  mean time:        84.782 ns (0.00% GC)
  maximum time:     247.097 ns (0.00% GC)
  --------------
  samples:          10000
  evals/sample:     972
# GridWorlds.GoToDoor
#### GridWorlds.GoToDoor()
BenchmarkTools.Trial: 
  memory estimate:  5.78 KiB
  allocs estimate:  84
  --------------
  minimum time:     18.451 μs (0.00% GC)
  median time:      29.588 μs (0.00% GC)
  mean time:        33.650 μs (1.36% GC)
  maximum time:     4.627 ms (98.58% GC)
  --------------
  samples:          10000
  evals/sample:     1
#### RLBase.reset!(env)
BenchmarkTools.Trial: 
  memory estimate:  1.53 KiB
  allocs estimate:  27
  --------------
  minimum time:     1.072 μs (0.00% GC)
  median time:      1.343 μs (0.00% GC)
  mean time:        1.627 μs (6.86% GC)
  maximum time:     478.375 μs (98.72% GC)
  --------------
  samples:          10000
  evals/sample:     10
#### RLBase.state(env)
BenchmarkTools.Trial: 
  memory estimate:  2.75 KiB
  allocs estimate:  46
  --------------
  minimum time:     2.240 μs (0.00% GC)
  median time:      2.495 μs (0.00% GC)
  mean time:        3.007 μs (7.91% GC)
  maximum time:     524.972 μs (99.10% GC)
  --------------
  samples:          10000
  evals/sample:     9
#### RLBase.action_space(env)
BenchmarkTools.Trial: 
  memory estimate:  0 bytes
  allocs estimate:  0
  --------------
  minimum time:     0.027 ns (0.00% GC)
  median time:      0.030 ns (0.00% GC)
  mean time:        0.030 ns (0.00% GC)
  maximum time:     0.057 ns (0.00% GC)
  --------------
  samples:          10000
  evals/sample:     1000
#### RLBase.is_terminated(env)
BenchmarkTools.Trial: 
  memory estimate:  32 bytes
  allocs estimate:  1
  --------------
  minimum time:     41.531 ns (0.00% GC)
  median time:      45.408 ns (0.00% GC)
  mean time:        52.627 ns (3.20% GC)
  maximum time:     3.812 μs (97.25% GC)
  --------------
  samples:          10000
  evals/sample:     988
#### RLBase.reward(env)
BenchmarkTools.Trial: 
  memory estimate:  0 bytes
  allocs estimate:  0
  --------------
  minimum time:     1.814 ns (0.00% GC)
  median time:      1.889 ns (0.00% GC)
  mean time:        1.932 ns (0.00% GC)
  maximum time:     33.278 ns (0.00% GC)
  --------------
  samples:          10000
  evals/sample:     1000
#### env(GridWorlds.TurnRight())
BenchmarkTools.Trial: 
  memory estimate:  0 bytes
  allocs estimate:  0
  --------------
  minimum time:     66.648 ns (0.00% GC)
  median time:      74.431 ns (0.00% GC)
  mean time:        80.057 ns (0.00% GC)
  maximum time:     241.110 ns (0.00% GC)
  --------------
  samples:          10000
  evals/sample:     972
#### env(GridWorlds.MoveForward())
BenchmarkTools.Trial: 
  memory estimate:  96 bytes
  allocs estimate:  3
  --------------
  minimum time:     105.547 ns (0.00% GC)
  median time:      114.165 ns (0.00% GC)
  mean time:        127.540 ns (4.16% GC)
  maximum time:     3.550 μs (96.27% GC)
  --------------
  samples:          10000
  evals/sample:     914
#### env(GridWorlds.TurnLeft())
BenchmarkTools.Trial: 
  memory estimate:  0 bytes
  allocs estimate:  0
  --------------
  minimum time:     66.296 ns (0.00% GC)
  median time:      70.012 ns (0.00% GC)
  mean time:        75.902 ns (0.00% GC)
  maximum time:     260.006 ns (0.00% GC)
  --------------
  samples:          10000
  evals/sample:     972
# GridWorlds.DoorKey
#### GridWorlds.DoorKey()
BenchmarkTools.Trial: 
  memory estimate:  2.39 KiB
  allocs estimate:  29
  --------------
  minimum time:     2.381 μs (0.00% GC)
  median time:      2.852 μs (0.00% GC)
  mean time:        3.817 μs (4.20% GC)
  maximum time:     496.988 μs (98.46% GC)
  --------------
  samples:          10000
  evals/sample:     9
#### RLBase.reset!(env)
BenchmarkTools.Trial: 
  memory estimate:  64 bytes
  allocs estimate:  2
  --------------
  minimum time:     541.262 ns (0.00% GC)
  median time:      627.476 ns (0.00% GC)
  mean time:        721.515 ns (0.36% GC)
  maximum time:     13.857 μs (94.73% GC)
  --------------
  samples:          10000
  evals/sample:     187
#### RLBase.state(env)
BenchmarkTools.Trial: 
  memory estimate:  2.72 KiB
  allocs estimate:  45
  --------------
  minimum time:     2.193 μs (0.00% GC)
  median time:      2.296 μs (0.00% GC)
  mean time:        2.916 μs (9.66% GC)
  maximum time:     803.717 μs (99.30% GC)
  --------------
  samples:          10000
  evals/sample:     9
#### RLBase.action_space(env)
BenchmarkTools.Trial: 
  memory estimate:  0 bytes
  allocs estimate:  0
  --------------
  minimum time:     0.030 ns (0.00% GC)
  median time:      0.043 ns (0.00% GC)
  mean time:        0.044 ns (0.00% GC)
  maximum time:     0.408 ns (0.00% GC)
  --------------
  samples:          10000
  evals/sample:     1000
#### RLBase.is_terminated(env)
BenchmarkTools.Trial: 
  memory estimate:  32 bytes
  allocs estimate:  1
  --------------
  minimum time:     31.458 ns (0.00% GC)
  median time:      37.204 ns (0.00% GC)
  mean time:        46.974 ns (4.53% GC)
  maximum time:     6.598 μs (98.40% GC)
  --------------
  samples:          10000
  evals/sample:     991
#### RLBase.reward(env)
BenchmarkTools.Trial: 
  memory estimate:  0 bytes
  allocs estimate:  0
  --------------
  minimum time:     1.880 ns (0.00% GC)
  median time:      2.303 ns (0.00% GC)
  mean time:        2.694 ns (0.00% GC)
  maximum time:     3.329 μs (0.00% GC)
  --------------
  samples:          10000
  evals/sample:     1000
#### env(GridWorlds.TurnRight())
BenchmarkTools.Trial: 
  memory estimate:  0 bytes
  allocs estimate:  0
  --------------
  minimum time:     67.325 ns (0.00% GC)
  median time:      73.246 ns (0.00% GC)
  mean time:        84.559 ns (0.00% GC)
  maximum time:     227.440 ns (0.00% GC)
  --------------
  samples:          10000
  evals/sample:     971
#### env(GridWorlds.PickUp())
BenchmarkTools.Trial: 
  memory estimate:  32 bytes
  allocs estimate:  1
  --------------
  minimum time:     37.791 ns (0.00% GC)
  median time:      68.620 ns (0.00% GC)
  mean time:        70.117 ns (3.43% GC)
  maximum time:     5.886 μs (98.43% GC)
  --------------
  samples:          10000
  evals/sample:     992
#### env(GridWorlds.MoveForward())
BenchmarkTools.Trial: 
  memory estimate:  96 bytes
  allocs estimate:  3
  --------------
  minimum time:     106.599 ns (0.00% GC)
  median time:      146.636 ns (0.00% GC)
  mean time:        189.353 ns (3.59% GC)
  maximum time:     18.449 μs (0.00% GC)
  --------------
  samples:          10000
  evals/sample:     932
#### env(GridWorlds.TurnLeft())
BenchmarkTools.Trial: 
  memory estimate:  0 bytes
  allocs estimate:  0
  --------------
  minimum time:     67.937 ns (0.00% GC)
  median time:      77.621 ns (0.00% GC)
  mean time:        95.012 ns (0.00% GC)
  maximum time:     978.866 ns (0.00% GC)
  --------------
  samples:          10000
  evals/sample:     971
# GridWorlds.CollectGems
#### GridWorlds.CollectGems()
BenchmarkTools.Trial: 
  memory estimate:  2.75 KiB
  allocs estimate:  33
  --------------
  minimum time:     2.903 μs (0.00% GC)
  median time:      3.860 μs (0.00% GC)
  mean time:        5.048 μs (5.55% GC)
  maximum time:     925.641 μs (98.51% GC)
  --------------
  samples:          10000
  evals/sample:     8
#### RLBase.reset!(env)
BenchmarkTools.Trial: 
  memory estimate:  336 bytes
  allocs estimate:  4
  --------------
  minimum time:     1.022 μs (0.00% GC)
  median time:      1.384 μs (0.00% GC)
  mean time:        1.584 μs (0.00% GC)
  maximum time:     5.650 μs (0.00% GC)
  --------------
  samples:          10000
  evals/sample:     10
#### RLBase.state(env)
BenchmarkTools.Trial: 
  memory estimate:  3.34 KiB
  allocs estimate:  55
  --------------
  minimum time:     2.521 μs (0.00% GC)
  median time:      2.780 μs (0.00% GC)
  mean time:        3.879 μs (10.66% GC)
  maximum time:     1.139 ms (99.52% GC)
  --------------
  samples:          10000
  evals/sample:     9
#### RLBase.action_space(env)
BenchmarkTools.Trial: 
  memory estimate:  0 bytes
  allocs estimate:  0
  --------------
  minimum time:     0.029 ns (0.00% GC)
  median time:      0.034 ns (0.00% GC)
  mean time:        0.037 ns (0.00% GC)
  maximum time:     1.878 ns (0.00% GC)
  --------------
  samples:          10000
  evals/sample:     1000
#### RLBase.is_terminated(env)
BenchmarkTools.Trial: 
  memory estimate:  0 bytes
  allocs estimate:  0
  --------------
  minimum time:     1.881 ns (0.00% GC)
  median time:      1.954 ns (0.00% GC)
  mean time:        2.022 ns (0.00% GC)
  maximum time:     15.944 ns (0.00% GC)
  --------------
  samples:          10000
  evals/sample:     1000
#### RLBase.reward(env)
BenchmarkTools.Trial: 
  memory estimate:  0 bytes
  allocs estimate:  0
  --------------
  minimum time:     1.880 ns (0.00% GC)
  median time:      1.888 ns (0.00% GC)
  mean time:        1.931 ns (0.00% GC)
  maximum time:     33.780 ns (0.00% GC)
  --------------
  samples:          10000
  evals/sample:     1000
#### env(GridWorlds.TurnRight())
BenchmarkTools.Trial: 
  memory estimate:  0 bytes
  allocs estimate:  0
  --------------
  minimum time:     69.109 ns (0.00% GC)
  median time:      73.709 ns (0.00% GC)
  mean time:        79.787 ns (0.00% GC)
  maximum time:     327.870 ns (0.00% GC)
  --------------
  samples:          10000
  evals/sample:     969
#### env(GridWorlds.MoveForward())
BenchmarkTools.Trial: 
  memory estimate:  96 bytes
  allocs estimate:  3
  --------------
  minimum time:     95.031 ns (0.00% GC)
  median time:      102.396 ns (0.00% GC)
  mean time:        115.605 ns (4.62% GC)
  maximum time:     3.354 μs (96.70% GC)
  --------------
  samples:          10000
  evals/sample:     934
#### env(GridWorlds.TurnLeft())
BenchmarkTools.Trial: 
  memory estimate:  0 bytes
  allocs estimate:  0
  --------------
  minimum time:     69.713 ns (0.00% GC)
  median time:      79.647 ns (0.00% GC)
  mean time:        88.382 ns (0.00% GC)
  maximum time:     612.579 ns (0.00% GC)
  --------------
  samples:          10000
  evals/sample:     969
# GridWorlds.DynamicObstacles
#### GridWorlds.DynamicObstacles()
BenchmarkTools.Trial: 
  memory estimate:  2.63 KiB
  allocs estimate:  32
  --------------
  minimum time:     2.433 μs (0.00% GC)
  median time:      2.782 μs (0.00% GC)
  mean time:        3.333 μs (6.16% GC)
  maximum time:     447.114 μs (98.68% GC)
  --------------
  samples:          10000
  evals/sample:     9
#### RLBase.reset!(env)
BenchmarkTools.Trial: 
  memory estimate:  192 bytes
  allocs estimate:  3
  --------------
  minimum time:     689.427 ns (0.00% GC)
  median time:      817.874 ns (0.00% GC)
  mean time:        908.886 ns (1.65% GC)
  maximum time:     39.831 μs (96.88% GC)
  --------------
  samples:          10000
  evals/sample:     131
#### RLBase.state(env)
BenchmarkTools.Trial: 
  memory estimate:  2.72 KiB
  allocs estimate:  45
  --------------
  minimum time:     2.062 μs (0.00% GC)
  median time:      2.201 μs (0.00% GC)
  mean time:        2.614 μs (9.12% GC)
  maximum time:     521.700 μs (99.40% GC)
  --------------
  samples:          10000
  evals/sample:     9
#### RLBase.action_space(env)
BenchmarkTools.Trial: 
  memory estimate:  0 bytes
  allocs estimate:  0
  --------------
  minimum time:     0.029 ns (0.00% GC)
  median time:      0.034 ns (0.00% GC)
  mean time:        0.039 ns (0.00% GC)
  maximum time:     0.785 ns (0.00% GC)
  --------------
  samples:          10000
  evals/sample:     1000
#### RLBase.is_terminated(env)
BenchmarkTools.Trial: 
  memory estimate:  64 bytes
  allocs estimate:  2
  --------------
  minimum time:     62.936 ns (0.00% GC)
  median time:      74.913 ns (0.00% GC)
  mean time:        89.277 ns (4.51% GC)
  maximum time:     5.164 μs (98.32% GC)
  --------------
  samples:          10000
  evals/sample:     973
#### RLBase.reward(env)
BenchmarkTools.Trial: 
  memory estimate:  0 bytes
  allocs estimate:  0
  --------------
  minimum time:     1.880 ns (0.00% GC)
  median time:      1.891 ns (0.00% GC)
  mean time:        1.948 ns (0.00% GC)
  maximum time:     42.269 ns (0.00% GC)
  --------------
  samples:          10000
  evals/sample:     1000
#### env(GridWorlds.TurnRight())
BenchmarkTools.Trial: 
  memory estimate:  5.25 KiB
  allocs estimate:  42
  --------------
  minimum time:     2.026 μs (0.00% GC)
  median time:      2.171 μs (0.00% GC)
  mean time:        2.996 μs (10.52% GC)
  maximum time:     468.569 μs (98.64% GC)
  --------------
  samples:          10000
  evals/sample:     9
#### env(GridWorlds.MoveForward())
BenchmarkTools.Trial: 
  memory estimate:  5.31 KiB
  allocs estimate:  44
  --------------
  minimum time:     1.988 μs (0.00% GC)
  median time:      2.095 μs (0.00% GC)
  mean time:        2.575 μs (9.57% GC)
  maximum time:     279.796 μs (98.33% GC)
  --------------
  samples:          10000
  evals/sample:     9
#### env(GridWorlds.TurnLeft())
BenchmarkTools.Trial: 
  memory estimate:  5.25 KiB
  allocs estimate:  42
  --------------
  minimum time:     2.036 μs (0.00% GC)
  median time:      2.395 μs (0.00% GC)
  mean time:        3.587 μs (8.44% GC)
  maximum time:     387.202 μs (97.04% GC)
  --------------
  samples:          10000
  evals/sample:     9
# GridWorlds.Sokoban
#### GridWorlds.Sokoban()
BenchmarkTools.Trial: 
  memory estimate:  848.75 KiB
  allocs estimate:  23971
  --------------
  minimum time:     1.383 ms (0.00% GC)
  median time:      1.613 ms (0.00% GC)
  mean time:        1.841 ms (4.81% GC)
  maximum time:     14.049 ms (75.38% GC)
  --------------
  samples:          2714
  evals/sample:     1
#### RLBase.reset!(env)
BenchmarkTools.Trial: 
  memory estimate:  512 bytes
  allocs estimate:  6
  --------------
  minimum time:     2.821 μs (0.00% GC)
  median time:      4.860 μs (0.00% GC)
  mean time:        5.030 μs (0.96% GC)
  maximum time:     491.374 μs (98.37% GC)
  --------------
  samples:          10000
  evals/sample:     9
#### RLBase.state(env)
BenchmarkTools.Trial: 
  memory estimate:  1.33 KiB
  allocs estimate:  27
  --------------
  minimum time:     3.037 μs (0.00% GC)
  median time:      3.352 μs (0.00% GC)
  mean time:        4.020 μs (4.58% GC)
  maximum time:     1.037 ms (99.09% GC)
  --------------
  samples:          10000
  evals/sample:     8
#### RLBase.action_space(env)
BenchmarkTools.Trial: 
  memory estimate:  0 bytes
  allocs estimate:  0
  --------------
  minimum time:     0.026 ns (0.00% GC)
  median time:      0.029 ns (0.00% GC)
  mean time:        0.030 ns (0.00% GC)
  maximum time:     6.757 ns (0.00% GC)
  --------------
  samples:          10000
  evals/sample:     1000
#### RLBase.is_terminated(env)
BenchmarkTools.Trial: 
  memory estimate:  0 bytes
  allocs estimate:  0
  --------------
  minimum time:     8.422 ns (0.00% GC)
  median time:      9.635 ns (0.00% GC)
  mean time:        10.408 ns (0.00% GC)
  maximum time:     629.083 ns (0.00% GC)
  --------------
  samples:          10000
  evals/sample:     999
#### RLBase.reward(env)
BenchmarkTools.Trial: 
  memory estimate:  0 bytes
  allocs estimate:  0
  --------------
  minimum time:     1.879 ns (0.00% GC)
  median time:      1.889 ns (0.00% GC)
  mean time:        2.019 ns (0.00% GC)
  maximum time:     65.712 ns (0.00% GC)
  --------------
  samples:          10000
  evals/sample:     1000
#### env(GridWorlds.MoveDown())
BenchmarkTools.Trial: 
  memory estimate:  32 bytes
  allocs estimate:  1
  --------------
  minimum time:     64.859 ns (0.00% GC)
  median time:      75.094 ns (0.00% GC)
  mean time:        87.035 ns (2.08% GC)
  maximum time:     4.295 μs (97.16% GC)
  --------------
  samples:          10000
  evals/sample:     973
#### env(GridWorlds.MoveUp())
BenchmarkTools.Trial: 
  memory estimate:  32 bytes
  allocs estimate:  1
  --------------
  minimum time:     63.738 ns (0.00% GC)
  median time:      72.275 ns (0.00% GC)
  mean time:        82.478 ns (2.04% GC)
  maximum time:     3.184 μs (97.33% GC)
  --------------
  samples:          10000
  evals/sample:     974
#### env(GridWorlds.MoveLeft())
BenchmarkTools.Trial: 
  memory estimate:  32 bytes
  allocs estimate:  1
  --------------
  minimum time:     64.260 ns (0.00% GC)
  median time:      74.373 ns (0.00% GC)
  mean time:        86.842 ns (2.10% GC)
  maximum time:     4.056 μs (96.68% GC)
  --------------
  samples:          10000
  evals/sample:     974
#### env(GridWorlds.MoveRight())
BenchmarkTools.Trial: 
  memory estimate:  32 bytes
  allocs estimate:  1
  --------------
  minimum time:     63.581 ns (0.00% GC)
  median time:      73.862 ns (0.00% GC)
  mean time:        87.706 ns (2.32% GC)
  maximum time:     4.616 μs (97.09% GC)
  --------------
  samples:          10000
  evals/sample:     975
