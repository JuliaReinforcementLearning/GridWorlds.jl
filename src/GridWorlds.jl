module GridWorlds

using Requires
using ReinforcementLearningBase

const GW = GridWorlds
export GW

include("directions.jl")
include("actions.jl")
include("objects.jl")
include("grid_world_base.jl")
include("abstract_grid_world.jl")
include("envs/envs.jl")
include("render_in_terminal.jl")

function __init__()
    @require Makie="ee78f7c6-11fb-53f2-987a-cfe4a2b5a57a" include("render_with_Makie.jl")
end

end
