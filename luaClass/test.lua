local class = require("luaClasses")

local food = class({
    __init__ = function(self, args)
        self.FoodType = args.FoodType
        return self
    end,

    PrintType = function(self)
        print(self.FoodType)
    end,

    FoodType = "",
})

local Carrot = food({FoodType = "Carrot"})
Carrot:PrintType()