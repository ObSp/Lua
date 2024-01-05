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
    if self.__new__ then self.__new__(obj, args) end
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
        if self.__str__ then
            return self.__str__(self)
        end
        return tostring({self})
    end


    newclass.__add = function(self, other)
        if self.__add__  then return self.__add__(self,other) end
        return `Attempted to perform a mathematical opperation(add) on types {type(self)} and {type(other)}` 
    end

    newclass.__sub = function(self, other)
        if self.__sub__  then return self.__sub__(self,other) end
        return `Attempted to perform a mathematical opperation(sub) on types {type(self)} and {type(other)}`
    end

    newclass.__mul = function(self, other)
        if self.__mul__  then return self.__mul__(self,other) end
        return `Attempted to perform a mathematical opperation(mult) on types {type(self)} and {type(other)}`
    end

    newclass.__div = function(self, other)
        if self.__div__  then return self.__div__(self,other) end
        return `Attempted to perform a mathematical opperation(div) on types {type(self)} and {type(other)}`
    end

    newclass.__pow = function(self, other)
        if self.__pow__  then return self.__pow__(self,other) end
        return `Attempted to perform a mathematical opperation(pow) on type {type(self)} and {type(other)}`
    end



    return newclass
end