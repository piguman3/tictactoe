local algos = {
    PiguAlgo = require "algos/piguepicalgo",
    CountBot = require "algos/countbot"
}

local results = {
    STALEMATE = 0,
    WIN = 1,
    LOSE = 2,
    NOTHING = 3
}

local spots = {
    EMPTY = 0,
    MINE = 1,
    ENEMY = 2
}

local matchCount = 100000

local function reverseBoard(board)
    local out = {{}, {}, {}}

    for x=1,3 do
        for y=1,3 do
            if board[x][y]==1 then
                out[x][y] = 2
            elseif board[x][y]==2 then
                out[x][y] = 1
            else
                out[x][y] = 0
            end
        end
    end

    return out
end

local function isLegalMove(board, x, y)
    return (x>=1) and (x<=3) and (y>=1) and (y<=3) and (board[x][y]==spots.EMPTY)
end

local function check(board, spot)
    -- Vertical check
    for x=1,3 do
        local count = 0
        for y=1,3 do
            if board[x][y]==spot then count = count + 1 end
        end
        if count==3 then return true end
    end

    -- Horizontal check
    for y=1,3 do
        local count = 0
        for x=1,3 do
            if board[x][y]==spot then count = count + 1 end
        end
        if count==3 then return true end
    end

    -- Diagonal 1,1 to 3,3
    local count = 0
    for x=1,3 do
        if board[x][x]==spot then count = count + 1 end
    end
    if count==3 then return true end

    -- Diagonal 1,1 to 3,3
    count = 0
    for x=1,3 do
        if board[4-x][x]==spot then count = count + 1 end
    end
    if count==3 then return true end

    return false
end

local function checkBoth(board)
    if check(board, spots.MINE) then
        return results.WIN
    elseif check(board, spots.ENEMY) then
        return results.LOSE
    else
        local count = 0
        for x=1,3 do
            for y=1,3 do
                if board[x][y]~=spots.EMPTY then count = count + 1 end
            end
        end
        if count==9 then 
            return results.STALEMATE 
        end
    end

    return results.NOTHING
end

local function printBoard(board)
    for x=1,3 do
        print(table.concat(board[x]))
    end
end

local function match(algo, opponent)
    local outresult = results.NOTHING
    local board = {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}}

    local turn = false
    while 1 do
        local x, y = 0, 0

        if turn then -- Algos turn
            x, y = algo.makeMove(board)
            if isLegalMove(board, x, y) then 
                board[x][y] = spots.MINE
            else
                outresult = results.LOSE
                break
            end
        else -- Opponents turn
            x, y = opponent.makeMove(reverseBoard(board))
            if isLegalMove(board, x, y) then 
                board[x][y] = spots.ENEMY
            else
                outresult = results.WIN
                break
            end
        end

        local result = checkBoth(board)
        if result~=results.NOTHING then
            outresult = result
            break
        end

        turn = not turn
    end

    return outresult
end

local function matchAll(algo)
    local wins = 0
    local loses = 0
    local draws = 0
    
    for x=1,matchCount do
        for name, opponent in pairs(algos) do
            local result = match(algo, opponent)
            if result==results.WIN then
                wins = wins + 1
            elseif result==results.LOSE then
                loses = loses + 1
            elseif result==results.STALEMATE then
                draws = draws + 1
            end
        end
    end

    return wins, loses, draws
end

print("ALGORITHM BATTLES!!")
for name, algo in pairs(algos) do
    local wins, loses, draws = matchAll(algo)
    print(name, " Wins:", wins, " Loses:", loses, " Draws:", draws)
end