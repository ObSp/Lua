local class = require("RoClasses")

local food = class({
    __init__ = function(self)
         self.properties = {"FoodType", "Regen"}
         return self     
    end,

    __tostring__ = function(self)
        return self.FoodType
    end,
})

local carrot = food()
carrot.properties.FoodType = "Carrot"
