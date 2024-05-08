local namesToIgnore = {"_constructor"}

local c = {}
c.__index = c


export type Object = {
    prototype: {}
}

export type Class = {
    _extends: Class?,
    _constructor: (this: Object)->(),
    _methods: {()->()},
    _instanceVariables: {[any]: any}
}

local object: Class

local function getDefaultValueForType(t: any)
    t = typeof(t)

    if t == "string" then
        t = ""
    elseif t == "number" then
        t = 0
    end
end

local function getInstanceVars(args: {})
    local vars = {}
    for k,v in args do
        if typeof(k) == "string" and typeof(v) ~= "function" then
            vars[k] = v;
        end
    end
    return vars
end

local function isFunc(anObject)
    return typeof(anObject) == "function"
end

local function getMethods(args: {}) : {(any)->any}
    local methods = {}
    for k,v in args do
        if isFunc(v) and not table.find(namesToIgnore, k) then methods[k] = v end
    end
    return methods
end


local function getPrototype(self)
    local prototype = {}
    for k, v in self do
        if typeof(v) == "function" then
            prototype[k] = v;
        end
    end
    return self
end

local function createDefConstructor(s, instanceVars)
    return function(self)

    end
end

local function isClass(obj: Class)
    return obj._constructor and obj._instanceVariables and obj._methods
end

local function extendToObject(obj, to_extend: Class, ...)
    if not isClass(to_extend) then return end

    obj = setmetatable(obj, to_extend)
    for i,v in to_extend._instanceVariables do
        obj[i] = v
    end
    for i,v in to_extend._methods do
        obj[i] = v
    end
    to_extend._constructor(obj, ...)
    if to_extend._extends then
        extendToObject(obj, to_extend._extends, ...)
    end
end

c.__call = function(self: Class, ...)
    local obj: Object

    if self._extends and isClass(self._extends) then
        obj = {}
        obj.super = self._extends
        extendToObject(obj, self, ...)

        --[[
        obj = setmetatable({
            super = self._extends
        }, self._extends)

        obj = setmetatable(obj, self)

        for k,v in self._extends._instanceVariables do
            obj[k] = v
        end

        for fn, f in self._extends._methods do
            obj[fn] = f
        end

        self._extends._constructor(obj, ...)]]

    else
        obj = setmetatable({}, self)
    end

    obj.prototype = self

    --[[for varname, var in self._instanceVariables do
        obj[varname] = var
    end

    for fname, f in self._methods do
        obj[fname] = f
    end
    
    self._constructor(obj)]]

    return obj
end


local function new(args: {}) : Class
    local newClass: Class = setmetatable({}, c)

    local instanceVars = getInstanceVars(args)
    local methods = getMethods(args)

    for fname, f in methods do
        newClass[fname] = f
    end

    newClass._methods = methods
    newClass._instanceVariables = instanceVars


    if args.constructor then
        newClass._constructor = args.constructor
    else
        newClass._constructor = createDefConstructor(newClass, instanceVars)
    end

    --class extending
    newClass._extends = args.extends or (not args.NOEXTEND and object) or nil

    


    return newClass
end

object = new{
    NOEXTEND = true,

    constructor = function(self)
        
    end,

    Destroy = function(self)
        for i,v in self do
            self[i] = nil
        end
    end
}

return new