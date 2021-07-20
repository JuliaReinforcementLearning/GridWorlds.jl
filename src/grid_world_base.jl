function get_grid_inds((i, j), (m, n))
    temp1 = m ÷ 2
    temp2 = i - temp1
    temp3 = n ÷ 2
    temp4 = j - temp3
    return CartesianIndices((temp2 : temp2 + m - 1, temp4 : temp4 + n - 1))
end

function get_grid_inds((i, j), (m, n), ::Up)
    temp1 = n - 1
    temp2 = temp1 ÷ 2
    temp3 = j - temp2
    return CartesianIndices((i - m + 1 : i, temp3 : temp3 + temp1))
end

function get_grid_inds((i, j), (m, n), ::Down)
    temp1 = n - 1
    temp2 = temp1 ÷ 2
    temp3 = j - temp2
    return CartesianIndices((i : i + m - 1, temp3 : temp3 + temp1))
end

function get_grid_inds((i, j), (m, n), ::Left)
    temp1 = n - 1
    temp2 = temp1 ÷ 2
    temp3 = i - temp2
    return CartesianIndices((temp3 : temp3 + temp1, j - m + 1 : j))
end

function get_grid_inds((i, j), (m, n), ::Right)
    temp1 = n - 1
    temp2 = temp1 ÷ 2
    temp3 = i - temp2
    return CartesianIndices((temp3 : temp3 + temp1, j : j + m - 1))
end

map_ind((i,j), (m, n), ::Up) = (m-i+1, n-j+1)
map_ind((i,j), (m, n), ::Down) = (i,j)
map_ind((i,j), (m, n), ::Left) = (m-j+1, i)
map_ind((i,j), (m, n), ::Right) = (j, n-i+1)

function get_grid(src_grid::AbstractArray{Bool, 3}, pos::CartesianIndex{2}, dir::AbstractDirection, window_size, layers)
    dest_grid = falses(length(layers), window_size...)
    get_grid!(dest_grid, src_grid, pos, dir, window_size, layers)
    return dest_grid
end

function get_grid!(dest_grid::AbstractArray{Bool, 3}, src_grid::AbstractArray{Bool, 3}, pos::CartesianIndex{2}, dir::AbstractDirection, window_size, layers)
    window_inds = get_grid_inds(pos.I, window_size, dir)

    valid_inds = CartesianIndices((get_height(src_grid), get_width(src_grid)))

    @views for ind in CartesianIndices(window_inds)
        pos = window_inds[ind]
        if pos ∈ valid_inds
            dest_grid[:, map_ind(ind.I, window_size, dir)...] .= src_grid[layers, pos]
        end
    end

    return nothing
end

function get_grid(src_grid::AbstractArray{Bool, 3}, pos::CartesianIndex{2}, window_size, layers)
    dest_grid = falses(length(layers), window_size...)
    get_grid!(dest_grid, src_grid, pos, window_size, layers)
    return dest_grid
end

function get_grid!(dest_grid::AbstractArray{Bool, 3}, src_grid::AbstractArray{Bool, 3}, pos::CartesianIndex{2}, window_size, layers)
    window_inds = get_grid_inds(pos.I, window_size)

    valid_inds = CartesianIndices((get_height(src_grid), get_width(src_grid)))

    @views for ind in CartesianIndices(window_inds)
        pos = window_inds[ind]
        if pos ∈ valid_inds
            dest_grid[:, ind.I...] .= src_grid[layers, pos]
        end
    end

    return nothing
end
