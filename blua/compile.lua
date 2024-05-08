local langDict: {[string]: string} = require("blua/lang")

local f = [[
    fr x be 2
    yap(x)
    fr y be x vibin_with 2
    yap(y)
    x = 3
    print(x)
]]

for bluaExpresion, luaEquivalent in langDict do
    f = f:gsub(bluaExpresion, luaEquivalent)
end

loadstring(f)()