local class = require("luaClass/luaClasses")

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

local animal = class({
    __init__ = function(self, args)
        self.AnimalType = args.AnimalType
        self.Damage = args.Damage
        self.Noise = args.Noise
        return self
    end,
    
    MakeNoise = function(self)
        print(self.Noise)
    end
})

local beef = food({FoodType = "Beef"})
local cow = animal({AnimalType = "Cow", Damage = 1, Noise = "MOOOOOOO"})
beef:PrintType()
cow:MakeNoise()