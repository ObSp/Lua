type Board = {
    fillRandom: ({})->nil,
    board: {{number}},
    sizex: number,
    sizey: number,
}

type Coordinate = {
    x: number,
    y: number
}


type CoordinateModule = {
    new: (number,number) -> Coordinate
}

local Coordinate: CoordinateModule = require("minesweeper/classes/coordinate")



local map = {}
map.__index = map
map.__tostring = function(self: Board)
    for y=0, self.sizey do
        local prnt_str = ""
        for x=0, self.sizex do
            prnt_str ..= ` [{x}, {y}] `
        end
        print(prnt_str)
    end
    return ""
end


function map:checkCoord(coordinate: Coordinate) : boolean
    return (self.board[coordinate.x][coordinate.y]~=1 and true) or false
end


function map:revealBoard()
    self = self :: Board

    for y=0, self.sizey do
        local prnt_str = ""
        for x=0, self.sizex do
            prnt_str ..= ` {self.board[x][y]} `
        end
        print(prnt_str)
    end
end


function map:fillRandom()
    self = self :: Board
    local board: {{number}} = self.board

    for x=0, self.sizex do
        for y=0, self.sizey do
            if math.random(0,1)==1 then self.board[x][y] = 1 end
        end
    end
end


function map.new(sizex, sizey) : Board
    local self = setmetatable({}, map)
    self.board = {}
    self.sizex = sizex-1
    self.sizey = sizey-1

    for x=0,sizex do
        self.board[x] = {}

        for y=0,sizey do
            self.board[x][y] = 0
        end
    end



    return self
end

return {
    new = map.new
}