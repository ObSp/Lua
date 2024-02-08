local reserved_names = {"__init__", "__new__"}

local function call(self,funcname,...)
    if self[funcname] and type(self[funcname]) == "function" then return self[funcname](self,...) end
    return nil
end

local function DeepCopy(t, tabletocopy)
    for i,v in tabletocopy do
        t[i] = v
    end
    return t
end


local classes = {}
classes.__index = classes

classes.__call = function(self, args) -- instantiate new object in a class
    local obj = setmetatable({}, self)
    obj = DeepCopy(obj, self._methods)

    for var,val in self._instancevars do
        obj[var] = val
    end

    if self.__new__ then self.__new__(obj, args) end
    if self.__init__ then self.__init__(obj, args) end
    return obj
end

classes.__tostring = function(self)
    return `class@{tostring({self}):split("table: ")[2]}`
end


return function(args) -- Create a new class with functions and properties
    local newclass = setmetatable({}, classes)
    newclass.__index = newclass
    newclass._methods = {}
    newclass._instancevars = {}
    for i,v in args do
        if type(v) == "function" and not table.find(reserved_names, i) then
            newclass._methods[i] = v
            continue
        elseif type(v) ~= "function" then
            newclass._instancevars[i] = v
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
        return call(self, "__add__",other) or `Attempted to perform a mathematical opperation(add) on types {type(self)} and {type(other)}`
    end

    newclass.__sub = function(self, other)
        return call(self, "__sub__", other) or `Attempted to perform a mathematical opperation(sub) on types {type(self)} and {type(other)}`
    end

    newclass.__mul = function(self, other)
        if self.__mul__  then return self.__mul__(self,other) end
        return call(self, "__mul__",other) or `Attempted to perform a mathematical opperation(mult) on types {type(self)} and {type(other)}`
    end

    newclass.__div = function(self, other)
        if self.__div__  then return self.__div__(self,other) end
        return call(self,"__div__",other) or `Attempted to perform a mathematical opperation(div) on types {type(self)} and {type(other)}`
    end

    newclass.__pow = function(self, other)
        if self.__pow__  then return self.__pow__(self,other) end
        return call(self, "__pow__", other) or `Attempted to perform a mathematical opperation(pow) on type {type(self)} and {type(other)}`
    end

    newclass.__concat = function(self, other)
        if self.__concat__ then return self.__concat__(self,other) end
        return call(self, "__concat__", other) or `Attempted to concat {type(self)} with {type(other)}`
    end

    newclass.__eq = function(self, other)
        if self.__eq__ then return self.__eq__(self,other) end
        return call(self, "__eq__", other) or `Attempted to determine equal of table and {type(other)}`
    end


    return newclass
end