local class = require("jsLua/jsclass")

local being = class{
    MealType = 1,

    constructor = function(self)

    end,

    eat = function()

    end
}

local animal = class{
    extends = being,

    constructor = function(self, Type)
        self.x = 1
        self.Type = Type
    end,

    makeNoise = function(self)
        print(self.Type)
    end
}

local zebra = animal("Zebra")
print(zebra.MealType)