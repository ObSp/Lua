type Board = {
    fillRandom: ({})->nil,
    board: {{number}},
    revealBoard: (any),
}

type GameEnums = {
    States: {
        Active: number,
        Won: number,
        Lost: number,
    }
}

local game = {}
game.__index = game


local classesfolder = "minesweeper/classes/"

local map = require(classesfolder.."map")
local signal = require(classesfolder.."signal")

local function wait(seconds: number)
    local t = os.clock()
    repeat until os.clock()-t>=seconds
end


function game:newTurn()
    
end

function game:Start()
    local board: Board = map.new(10,10)
    board:fillRandom()
    print(board)
end


function game.new()
    local self = setmetatable({}, game)
    self.state = "Active"
    self.completed = signal.new()
    return self
end


return game