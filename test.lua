local class = require("RoClasses")

local food = class({
    __init__ = function(self, args: {})
         self.FoodType = args[1]
         self.HealAmmount = args[2]
         return self
    end,

    __tostring__ = function(self)
        return self.FoodType
    end,

    printName = function(self)
        print(self.FoodType)
    end
})

local carrot = food({"Carrot", 15})
local beef = food({"Beef", 30})
print(carrot, beef)