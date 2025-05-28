local bot = {}

function bot.makeMove(board)
    local outx = math.floor(math.random(1, 3))
    local outy = math.floor(math.random(1, 3))
    repeat
        outx = math.floor(math.random(1, 3))
        outy = math.floor(math.random(1, 3))
    until board[outx][outy]==0
    return outx, outy
end

return bot