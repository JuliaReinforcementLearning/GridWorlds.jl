module GridWorlds

import REPL
import Requires
import Crayons
import MacroTools:@forward
import Random
import DataStructures
const DS = DataStructures
import ReinforcementLearningBase
import ReinforcementLearningBase:RLBase
import StaticArrays
const SA = StaticArrays

const GW = GridWorlds

include("directions.jl")
include("actions.jl")
include("objects.jl")
include("grid_world_base.jl")
include("abstract_grid_world.jl")
include("play.jl")
include("envs/envs.jl")
include("textual_rendering.jl")

function __init__()
    # Requires.@require Makie = "ee78f7c6-11fb-53f2-987a-cfe4a2b5a57a" include("graphical_rendering.jl")
    Requires.@require Makie = "ee78f7c6-11fb-53f2-987a-cfe4a2b5a57a" begin
        Requires.@require GLMakie = "e9467ef8-e4e7-5192-8a1a-b1aee30e663a" include("graphical_rendering.jl")
    end
end

end
