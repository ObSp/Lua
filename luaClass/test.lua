local class = require("luaClass/luaClasses")

local shoppinglist = class({
    __new__ = function(self)
        print("__new__ was called")
    end,

    __init__ = function(self, args)
        for listitem, amount in args do
            self[listitem] = amount
        end
    end,

    __add__ = function(self,other)
        for i,v in other do
            if type(v) ~= "number" then continue end
            if self[i] then
                self[i] += v
            else
                self[i] = v
            end
        end
        return self
    end,

    __str__ = function(self)
        local list = ""
        for listitem, amount in self do
            if type(amount) == "function" then continue end
            list ..= `{listitem}: {amount}, `
        end
        return list
    end,

    RemoveItem = function(self, args)
        self[args.Item] = nil
        return self
    end

})

local tuesdayshopping = shoppinglist({Eggs = 5, Milk = 4, OrangeJuice = 1, Yogurt = 5})
local fridayshopping = shoppinglist({Yogurt = 10, Eggs = 12, Milk = 6, OrangeJuice = 4, Baguette = 1000000})
local weekshopping = tuesdayshopping+fridayshopping
print(weekshopping)
weekshopping:RemoveItem({Item = "Yogurt"})
print(weekshopping)