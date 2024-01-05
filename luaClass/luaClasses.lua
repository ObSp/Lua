local reserved_names = {"__init__", "__str__"}

local function DeepCopy(t, tabletocopy)
    for i,v in tabletocopy do
        t[i] = v
    end
    return t
end


local classes = {}
classes.__index = classes
classes.__call = function(self, args) -- instantiate new "class" object
    local obj = setmetatable({}, self)
    obj = DeepCopy(obj, self._methods)
    if self.__init__ then self.__init__(obj, args) end
    return obj
end

return function(args) -- Create a new class with functions and properties
    local newclass = setmetatable({}, classes)
    newclass.__index = newclass
    newclass._methods = {}
    for i,v in args do
        if type(v) == "function" and not table.find(reserved_names, i) then
            newclass._methods[i] = v
            continue
        end
        newclass[i] = v
    end
    newclass.__tostring = function(self)
        return self.__str__(self)
    end
    return newclass
end