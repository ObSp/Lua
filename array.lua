local array = {}

export type Array = {
    Sort: (self: Array, callback: (a: any, b: any)->boolean)->(),
    Insert: (self: Array, value: any)->(),
    Find: (self: Array, value: any)->(),
    Clear: (self:Array)->(),
    RemoveIndex: (self:Array, index: number)->any,
    RemoveValue: (self: Array, value: any)->any,
    forEach: (self: Array, callback: (index: number, value: any)-> boolean | nil)->(),
    prototype: typeof(array)
}

local function shiftArrItemsDownFromIndex(arr: Array, index: number)
    for i=index, #arr do
        arr[i-1], arr[i] = arr[i], nil
    end
end

local function shiftArrItemsUp(arr: Array, fromIndex: number)
    local newTbl = {}
    for i=1,fromIndex-1 do
        newTbl[i] = arr[i]
    end

    for i = #arr, fromIndex, -1 do
        newTbl[i+1] = arr[i]
    end

    arr.__tbl = newTbl
end


array.__index = function(self, key)
    if array[key] then return array[key] end

    return self.__tbl[key]
end


array.__len = function(self)
    return #self.__tbl
end

array.__tostring = function(self)
    local str = "{\n"
    for i,v in self.__tbl do
        str ..= `[{i}] = {v}`
        if i~= #self then
            str ..= ", \n"
        end
    end
    str ..="\n}"
    return str
end

array.__newindex = function(self, key, value)
    return
end

array.__eq = function(self, other)
    if (not array.isArray(other)) then return false end

    return self.__tbl == other.__tbl
end

function array.isArray(arr) : boolean
    if (not arr.__tbl) then return false end

    if (arr.prototype ~= array) then return false end

    for k,v in array do
        if (arr[k] ~= v) then return false end
    end

    return true
end

function array:Sort(callback: (a: any, b: any)->boolean)
    self:forEach(function(i, _)
        
        local mindex: number = i
        for j=i, #self.__tbl do
            if (callback(self.__tbl[i], self.__tbl[j])==true) then
                mindex = j
            end
        end

        local itemAtIndex = self.__tbl[i]
        self.__tbl[i] = self.__tbl[mindex]
        self.__tbl[mindex] = itemAtIndex
    end)
end

function array:RemoveIndex(i: number) : typeof(self[i])
    local _ = self.__tbl[i]
    self.__tbl[i] = nil
    shiftArrItemsDownFromIndex(self, i)
    return _
end

function array:RemoveValue(v: any) : typeof(v)
    return self:RemoveIndex(self:Find(v))
end

function array:Find(value) : number
    print("'a")
    for i,v in self.__tbl do
        print(i)
        
        if v == value then return i end
    end

    return -1
end

function array:Insert(value: any, index: number?)
    if not index then
        self.__tbl[#self.__tbl+1] = value
        return
    end

    shiftArrItemsUp(self, index)
    self.__tbl[index] = value
end

function array:Clear()
    self.__tbl = {}
end

function array:forEach(callback: (index: number, value: any)->boolean | nil)
    for i,v in self.__tbl do
        local stop = callback(i,v)
        if (stop==false) then
            break
        end
    end
end

function array.new(fromTable: {}?) : Array
    return setmetatable({
        prototype = array,
        __tbl = fromTable or {}
    }, array)
end


return {
    new = array.new
}