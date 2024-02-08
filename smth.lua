local class = require("luaClass/luaClasses")


local test = class({
    x = 5,
})

local thing = test()
print(thing.x)