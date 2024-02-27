local class = {}
class.__index = class

function class:die()
    print(self.Name.. " has died")
end


function class.new(n)
    return setmetatable({Name = n}, class)
end


