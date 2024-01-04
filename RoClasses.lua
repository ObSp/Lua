local classes = {}
classes.__index = classes
classes.__call = function(self)
    if not self.__init__ then error("No init defined") end
    return self.__init__(self)
end
classes.__tostring = function(self)
    if not self.__tostring__ then error("No tostring defined") end
    return self.__tostring__(self)
end

return function (data)
    local newobj = setmetatable({}, classes)
    for i,v in data do
        newobj[i] = v
    end
    return newobj
end