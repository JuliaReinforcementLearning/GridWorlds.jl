function Base.show(io::IO, gw::AbstractGridWorld)
    p, d = get_agent_pos(gw), get_agent_dir(gw)
    w = convert(GridWorldBase, gw)

    println(io, "World:")
    for i in 1:size(w, 2)
        for j in 1:size(w, 3)
            if i == p[1] && j == p[2]
                print(io, (AGENT, d))
            else
                print(io, w.objects[w.world[:, i, j]])
            end
        end
        println(io)
    end
    println(io)

    println(io, "Agent's view:")
    v = get_agent_view(gw)
    for i in 1:size(v, 2)
        for j in 1:size(v, 3)
            o = w.objects[v[:, i, j]]
            if o isa Tuple{}
                print(io, '_')
            else
                print(io, o)
            end
        end
        println(io)
    end
    println(io)
end