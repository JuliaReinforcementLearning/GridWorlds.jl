Date: 2021_07_26_14_39_10 (yyyy_mm_dd_HH_MM_SS)

**Note:** The time in benchmarks is the median time. While benchmarking the random policy, each environment was run for 100 episodes of 100 steps each, that is, a total of 10000 steps.

## List of Environments
  1. [SingleRoomUndirected](#singleroomundirected)
  1. [SingleRoomDirected](#singleroomdirected)
  1. [GridRoomsUndirected](#gridroomsundirected)
  1. [GridRoomsDirected](#gridroomsdirected)
  1. [SequentialRoomsUndirected](#sequentialroomsundirected)
  1. [SequentialRoomsDirected](#sequentialroomsdirected)
  1. [MazeUndirected](#mazeundirected)
  1. [MazeDirected](#mazedirected)
  1. [GoToTargetUndirected](#gototargetundirected)
  1. [GoToTargetDirected](#gototargetdirected)
  1. [DoorKeyUndirected](#doorkeyundirected)
  1. [DoorKeyDirected](#doorkeydirected)
  1. [CollectGemsUndirected](#collectgemsundirected)
  1. [CollectGemsDirected](#collectgemsdirected)
  1. [CollectGemsMultiAgentUndirected](#collectgemsmultiagentundirected)
  1. [DynamicObstaclesUndirected](#dynamicobstaclesundirected)
  1. [DynamicObstaclesDirected](#dynamicobstaclesdirected)
  1. [SokobanUndirected](#sokobanundirected)
  1. [SokobanDirected](#sokobandirected)
  1. [Snake](#snake)
  1. [Catcher](#catcher)
  1. [TransportUndirected](#transportundirected)
  1. [TransportDirected](#transportdirected)

### SingleRoomUndirected
|random_policy|reset|state|MOVE_UP|MOVE_DOWN|MOVE_LEFT|MOVE_RIGHT|is_terminated|reward|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|0 bytes<br>338.576 μs|0 bytes<br>77.548 ns|0 bytes<br>2.216 ns|0 bytes<br>13.480 ns|0 bytes<br>13.353 ns|0 bytes<br>13.672 ns|0 bytes<br>13.321 ns|0 bytes<br>1.847 ns|0 bytes<br>1.849 ns|

### SingleRoomDirected
|random_policy|reset|state|MOVE_FORWARD|MOVE_BACKWARD|TURN_LEFT|TURN_RIGHT|is_terminated|reward|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|0 bytes<br>345.671 μs|0 bytes<br>86.328 ns|0 bytes<br>1.851 ns|0 bytes<br>14.628 ns|0 bytes<br>15.547 ns|0 bytes<br>12.485 ns|0 bytes<br>12.511 ns|0 bytes<br>2.194 ns|0 bytes<br>1.871 ns|

### GridRoomsUndirected
|random_policy|reset|state|MOVE_UP|MOVE_DOWN|MOVE_LEFT|MOVE_RIGHT|is_terminated|reward|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|0 bytes<br>366.796 μs|0 bytes<br>219.287 ns|0 bytes<br>1.881 ns|0 bytes<br>13.470 ns|0 bytes<br>14.565 ns|0 bytes<br>15.510 ns|0 bytes<br>13.630 ns|0 bytes<br>1.856 ns|0 bytes<br>1.834 ns|

### GridRoomsDirected
|random_policy|reset|state|MOVE_FORWARD|MOVE_BACKWARD|TURN_LEFT|TURN_RIGHT|is_terminated|reward|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|0 bytes<br>364.481 μs|0 bytes<br>229.418 ns|0 bytes<br>2.198 ns|0 bytes<br>15.245 ns|0 bytes<br>14.760 ns|0 bytes<br>12.486 ns|0 bytes<br>12.466 ns|0 bytes<br>1.852 ns|0 bytes<br>1.851 ns|

### SequentialRoomsUndirected
|random_policy|reset|state|MOVE_UP|MOVE_DOWN|MOVE_LEFT|MOVE_RIGHT|is_terminated|reward|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|4.45 MiB<br>33.176 ms|32.72 KiB<br>35.608 μs|0 bytes<br>2.927 μs|0 bytes<br>20.412 ns|0 bytes<br>20.091 ns|0 bytes<br>20.417 ns|0 bytes<br>20.094 ns|0 bytes<br>1.857 ns|0 bytes<br>1.828 ns|

### SequentialRoomsDirected
|random_policy|reset|state|MOVE_FORWARD|MOVE_BACKWARD|TURN_LEFT|TURN_RIGHT|is_terminated|reward|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|4.49 MiB<br>33.176 ms|32.72 KiB<br>35.705 μs|0 bytes<br>2.865 μs|0 bytes<br>14.638 ns|0 bytes<br>14.652 ns|0 bytes<br>12.653 ns|0 bytes<br>12.534 ns|0 bytes<br>1.855 ns|0 bytes<br>1.844 ns|

### MazeUndirected
|random_policy|reset|state|MOVE_UP|MOVE_DOWN|MOVE_LEFT|MOVE_RIGHT|is_terminated|reward|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|85.94 KiB<br>808.307 μs|880 bytes<br>4.690 μs|0 bytes<br>2.221 ns|0 bytes<br>15.145 ns|0 bytes<br>14.289 ns|0 bytes<br>14.162 ns|0 bytes<br>14.433 ns|0 bytes<br>1.853 ns|0 bytes<br>1.865 ns|

### MazeDirected
|random_policy|reset|state|MOVE_FORWARD|MOVE_BACKWARD|TURN_LEFT|TURN_RIGHT|is_terminated|reward|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|85.94 KiB<br>806.197 μs|880 bytes<br>4.710 μs|0 bytes<br>2.189 ns|0 bytes<br>15.098 ns|0 bytes<br>15.740 ns|0 bytes<br>12.656 ns|0 bytes<br>12.669 ns|0 bytes<br>1.854 ns|0 bytes<br>1.844 ns|

### GoToTargetUndirected
|random_policy|reset|state|MOVE_UP|MOVE_DOWN|MOVE_LEFT|MOVE_RIGHT|is_terminated|reward|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|0 bytes<br>394.753 μs|0 bytes<br>306.571 ns|0 bytes<br>1.868 ns|0 bytes<br>13.972 ns|0 bytes<br>14.950 ns|0 bytes<br>17.539 ns|0 bytes<br>15.141 ns|0 bytes<br>1.860 ns|0 bytes<br>1.826 ns|

### GoToTargetDirected
|random_policy|reset|state|MOVE_FORWARD|MOVE_BACKWARD|TURN_LEFT|TURN_RIGHT|is_terminated|reward|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|0 bytes<br>395.697 μs|0 bytes<br>291.905 ns|0 bytes<br>2.213 ns|0 bytes<br>15.945 ns|0 bytes<br>16.927 ns|0 bytes<br>14.681 ns|0 bytes<br>14.703 ns|0 bytes<br>1.853 ns|0 bytes<br>1.868 ns|

### DoorKeyUndirected
|random_policy|reset|state|MOVE_UP|MOVE_DOWN|MOVE_LEFT|MOVE_RIGHT|PICK_UP|is_terminated|reward|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|0 bytes<br>376.832 μs|0 bytes<br>199.785 ns|0 bytes<br>1.885 ns|0 bytes<br>14.057 ns|0 bytes<br>14.611 ns|0 bytes<br>14.584 ns|0 bytes<br>14.131 ns|0 bytes<br>13.020 ns|0 bytes<br>1.845 ns|0 bytes<br>1.865 ns|

### DoorKeyDirected
|random_policy|reset|state|MOVE_FORWARD|MOVE_BACKWARD|TURN_LEFT|TURN_RIGHT|PICK_UP|is_terminated|reward|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|0 bytes<br>363.589 μs|0 bytes<br>209.137 ns|0 bytes<br>2.188 ns|0 bytes<br>22.728 ns|0 bytes<br>18.863 ns|0 bytes<br>13.616 ns|0 bytes<br>13.316 ns|0 bytes<br>18.297 ns|0 bytes<br>1.853 ns|0 bytes<br>1.855 ns|

### CollectGemsUndirected
|random_policy|reset|state|MOVE_UP|MOVE_DOWN|MOVE_LEFT|MOVE_RIGHT|is_terminated|reward|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|0 bytes<br>441.002 μs|0 bytes<br>908.355 ns|0 bytes<br>2.198 ns|0 bytes<br>13.930 ns|0 bytes<br>13.511 ns|0 bytes<br>13.448 ns|0 bytes<br>13.578 ns|0 bytes<br>1.853 ns|0 bytes<br>1.859 ns|

### CollectGemsDirected
|random_policy|reset|state|MOVE_FORWARD|MOVE_BACKWARD|TURN_LEFT|TURN_RIGHT|is_terminated|reward|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|0 bytes<br>415.312 μs|0 bytes<br>982.661 ns|0 bytes<br>2.188 ns|0 bytes<br>14.312 ns|0 bytes<br>14.464 ns|0 bytes<br>13.031 ns|0 bytes<br>12.864 ns|0 bytes<br>1.850 ns|0 bytes<br>1.852 ns|

### CollectGemsMultiAgentUndirected
|random_policy|reset|state|MOVE_UP|MOVE_DOWN|MOVE_LEFT|MOVE_RIGHT|is_terminated|reward|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|0 bytes<br>630.289 μs|0 bytes<br>1.338 μs|0 bytes<br>1.887 ns|0 bytes<br>25.334 ns|0 bytes<br>25.798 ns|0 bytes<br>24.040 ns|0 bytes<br>24.342 ns|0 bytes<br>1.855 ns|0 bytes<br>1.825 ns|

### DynamicObstaclesUndirected
|random_policy|reset|state|MOVE_UP|MOVE_DOWN|MOVE_LEFT|MOVE_RIGHT|is_terminated|reward|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|0 bytes<br>1.751 ms|0 bytes<br>563.709 ns|0 bytes<br>1.887 ns|0 bytes<br>150.750 ns|0 bytes<br>150.626 ns|0 bytes<br>150.340 ns|0 bytes<br>148.430 ns|0 bytes<br>1.869 ns|0 bytes<br>1.832 ns|

### DynamicObstaclesDirected
|random_policy|reset|state|MOVE_FORWARD|MOVE_BACKWARD|TURN_LEFT|TURN_RIGHT|is_terminated|reward|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|0 bytes<br>1.800 ms|0 bytes<br>572.072 ns|0 bytes<br>2.190 ns|0 bytes<br>153.142 ns|0 bytes<br>156.083 ns|0 bytes<br>154.026 ns|0 bytes<br>154.611 ns|0 bytes<br>1.850 ns|0 bytes<br>2.193 ns|

### SokobanUndirected
|random_policy|reset|state|MOVE_UP|MOVE_DOWN|MOVE_LEFT|MOVE_RIGHT|is_terminated|reward|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|0 bytes<br>812.181 μs|0 bytes<br>811.588 ns|0 bytes<br>2.197 ns|0 bytes<br>48.230 ns|0 bytes<br>53.669 ns|0 bytes<br>52.852 ns|0 bytes<br>48.247 ns|0 bytes<br>1.856 ns|0 bytes<br>1.833 ns|

### SokobanDirected
|random_policy|reset|state|MOVE_FORWARD|MOVE_BACKWARD|TURN_LEFT|TURN_RIGHT|is_terminated|reward|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|0 bytes<br>782.403 μs|0 bytes<br>816.440 ns|0 bytes<br>1.851 ns|0 bytes<br>48.445 ns|0 bytes<br>54.114 ns|0 bytes<br>46.958 ns|0 bytes<br>46.978 ns|0 bytes<br>2.193 ns|0 bytes<br>1.864 ns|

### Snake
|random_policy|reset|state|MOVE_UP|MOVE_DOWN|MOVE_LEFT|MOVE_RIGHT|is_terminated|reward|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|0 bytes<br>429.255 μs|0 bytes<br>202.144 ns|0 bytes<br>1.877 ns|0 bytes<br>12.634 ns|0 bytes<br>12.609 ns|0 bytes<br>12.618 ns|0 bytes<br>12.614 ns|0 bytes<br>1.853 ns|0 bytes<br>1.834 ns|

### Catcher
|random_policy|reset|state|MOVE_LEFT|MOVE_RIGHT|NO_MOVE|is_terminated|reward|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|0 bytes<br>327.558 μs|0 bytes<br>41.618 ns|0 bytes<br>1.882 ns|0 bytes<br>21.297 ns|0 bytes<br>20.260 ns|0 bytes<br>20.170 ns|0 bytes<br>1.849 ns|0 bytes<br>1.864 ns|

### TransportUndirected
|random_policy|reset|state|MOVE_UP|MOVE_DOWN|MOVE_LEFT|MOVE_RIGHT|PICK_UP|DROP|is_terminated|reward|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|0 bytes<br>382.490 μs|0 bytes<br>302.589 ns|0 bytes<br>2.196 ns|0 bytes<br>14.938 ns|0 bytes<br>15.182 ns|0 bytes<br>14.793 ns|0 bytes<br>14.705 ns|0 bytes<br>15.153 ns|0 bytes<br>11.392 ns|0 bytes<br>1.841 ns|0 bytes<br>1.869 ns|

### TransportDirected
|random_policy|reset|state|MOVE_FORWARD|MOVE_BACKWARD|TURN_LEFT|TURN_RIGHT|PICK_UP|DROP|is_terminated|reward|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|0 bytes<br>350.543 μs|0 bytes<br>281.448 ns|0 bytes<br>1.849 ns|0 bytes<br>17.298 ns|0 bytes<br>17.214 ns|0 bytes<br>12.375 ns|0 bytes<br>12.785 ns|0 bytes<br>14.785 ns|0 bytes<br>11.833 ns|0 bytes<br>1.839 ns|0 bytes<br>1.853 ns|

