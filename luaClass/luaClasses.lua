local reserved_names = {"__init__", "__str__"}

local classes = {}
classes.__index = classes
classes.__call = function(self, args) -- instantiate new "class" object
    local obj = {}
    for i,v in self._methods do
        obj[i] = v
    end
    if self.__init__ then self.__init__(obj, args) end
    return obj
end

return function(args) -- Create a new class with functions and properties
    local newclass = setmetatable({}, classes)
    newclass._methods = {}
    for i,v in args do
        if type(v) == "function" and not table.find(reserved_names, i) then
            newclass._methods[i] = v
            continue
        end
        newclass[i] = v
    end
    return newclass
end