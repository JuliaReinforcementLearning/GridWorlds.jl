abstract type AbstractGridWorld end

function get_agent_view end
function get_agent end

Base.convert(::Type{GridWorldBase}, w::AbstractGridWorld) = w.world
get_object(w::AbstractGridWorld) = get_object(convert(GridWorldBase, w))
get_object(w::AbstractGridWorld, x::Type{<:AbstractObject}) = filter(o -> o isa x, get_object(w))
get_object(w::AbstractGridWorld, x::Type{Agent}) = w.agent
get_pos(w::AbstractGridWorld, ::Type{Agent}) = w.agent_pos

get_agent(w::AbstractGridWorld) = get_object(w, Agent)
get_agent_pos(w::AbstractGridWorld) = get_pos(w, Agent)
get_agent_dir(w::AbstractGridWorld) = w |> get_agent |> get_dir

function get_agent_view(w::AbstractGridWorld, agent_view_size=(7,7))
    wb = convert(GridWorldBase, w)
    v = BitArray{3}(undef, size(wb, 1), agent_view_size...)
    fill!(v, false)
    get_agent_view!(v, w)
end

function (w::AbstractGridWorld)(dir::Union{TurnRight, TurnLeft})
    a = get_agent(w)
    set_dir!(a, dir(get_dir(a)))
    w
end

get_agent_view_inds(w::AbstractGridWorld, s=(7,7)) = get_agent_view_inds(get_agent_pos(w).I, s, get_agent_dir(w))

get_agent_view!(v::BitArray{3}, w::AbstractGridWorld) = get_agent_view!(v, convert(GridWorldBase, w), get_agent_pos(w), get_agent_dir(w))

