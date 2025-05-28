local bot = {}

function bot.makeMove(board)
    local pos = 0

    while board[math.floor(pos/3)+1][pos%3+1]~=0 do
        pos = pos + 1
    end

    return math.floor(pos/3)+1, pos%3+1
end

return bot