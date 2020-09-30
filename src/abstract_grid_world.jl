abstract type AbstractGridWorld end

function get_agent_view end
function get_agent_pos end
function get_agent_dir end

Base.convert(::Type{GridWorldBase}, w::AbstractGridWorld) = w.world
get_agent_pos(w::AbstractGridWorld) = w.agent_pos
get_agent_dir(w::AbstractGridWorld) = w.agent_dir
get_agent_view(w::AbstractGridWorld) = w.agent_view

