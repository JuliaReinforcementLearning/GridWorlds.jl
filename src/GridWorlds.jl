module GridWorlds

export GW

import Requires
using Random
using ReinforcementLearningBase

const GW = GridWorlds

include("directions.jl")
include("actions.jl")
include("objects.jl")
include("grid_world_base.jl")
include("abstract_grid_world.jl")
include("envs/envs.jl")
include("terminal_rendering.jl")

function __init__()
    Requires.@require Makie = "ee78f7c6-11fb-53f2-987a-cfe4a2b5a57a" include("makie_rendering.jl")
end

end
