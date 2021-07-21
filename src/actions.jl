move_up(i::Integer, j::Integer) = (i - 1, j)
move_down(i::Integer, j::Integer) = (i + 1, j)
move_left(i::Integer, j::Integer) = (i, j - 1)
move_right(i::Integer, j::Integer) = (i, j + 1)
no_move(i::Integer, j::Integer) = (i, j)

function move_forward(dir::Integer, i::Integer, j::Integer)
    if dir == UP
        return move_up(i, j)
    elseif dir == DOWN
        return move_down(i, j)
    elseif dir == LEFT
        return move_left(i, j)
    elseif dir == RIGHT
        return move_right(i, j)
    else
        return no_move(i, j)
    end
end

function move_backward(dir::Integer, i::Integer, j::Integer)
    if dir == UP
        return move_down(i, j)
    elseif dir == DOWN
        return move_up(i, j)
    elseif dir == LEFT
        return move_right(i, j)
    elseif dir == RIGHT
        return move_left(i, j)
    else
        return no_move(i, j)
    end
end
