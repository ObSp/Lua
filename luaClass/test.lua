local class = require("luaClass/luaClasses")
local Bird = class({
    __init__ = function(self,args)
        self.Name = args[1]
        self.CanFly = args[2]
    end,
    __str__ = function(self)
        return `{self.Name}, can fly: {self.CanFly}`
    end,

    printstuff = function(self)
        print(self.Name)
    end})

local Hummingbird = Bird({"Hummingbird", true})
local Penguin = Bird({"Penguin", false})