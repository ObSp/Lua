type Coordinate = {
    x: number,
    y: number
}

local coord = {}
coord.__index = coord
coord.__add = function(self: Coordinate,other: Coordinate)
    return coord.new(self.x+other.x, self.y+other.y)
end



function coord.new(x: number, y: number)
   local self: Coordinate = setmetatable({}, coord)
   self.x = x
   self.y = y
   return self
end

return coord