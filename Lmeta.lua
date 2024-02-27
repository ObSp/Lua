--Lmeta
do
    type Lmetatable = {
        __tbl: {},
        __meta:{}
    }
    local Lmeta = {}
    Lmeta.Lmetamethodnames = {"__Ltostring", "__Lpairs", "__Lequals", "__Llen", "__Lcall"}
    Lmeta.__index = function(self, _k)
        return self.__tbl[_k]
    end

    Lmeta.__newindex = function(self, _k, _v)
        if typeof(_v) == "function" then
            self[_k] = _v
            return
        end

        if table.find(Lmeta.Lmetamethodnames, _k) then
            if not self.__meta then self.__meta = {} end
            self.__meta[_k] = _v
            return
        end
        self.__tbl[_k] = _v
    end



    local function deepCopy(tbl: {})
        local newT = {}
        for i,v in tbl do
            newT[i] = v
        end
        return newT
    end

    local function LBUILT_IN_RETURN(t: Lmetatable, _k: any, ...: any)
        if not t.__meta or not t.__meta[_k] then return ... end

        return t.__meta[_k]()

        --return (t.__meta[_k] and t.__meta[_k]()) or ...
    end

    local function LBUILT_IN_HASMETA(t: {})
        return t.__meta
    end

    local function LBUILT_IN_METHAMETHOD_EXISTS(t:{}, metamethod: string)
        return ( t.__meta and t.__meta[metamethod] and true) or false
    end


    local function removeKeyFromDict(dict: {}, key: any)
        local newDict = {}
        for k,v in dict do
            if k==key then continue end
            newDict[k] = v
        end
        dict = newDict
        return dict
    end


    function Lprint(...)
        local printObjs = {...}

        for _,v in printObjs do
            if type(v) == "table" and v.__meta and v.__meta.__Ltostring then
                print(v.__meta.__Ltostring(v))
            end
        end
    end


    function Lpairs(o: Lmetatable)
        return (o.__meta.__Lpairs and o.__meta.__Lpairs()) or next, o.__tbl, nil
    end

    function Lequals(o1: Lmetatable, o2: Lmetatable)
        return LBUILT_IN_RETURN(o1, "__Lequals", rawequal(o1.__tbl, o2.__tbl))
        --return (o1.__meta.__Lequals and o1.__meta.__Lequals(o1, o2)) or rawequal(o1.__tbl, o2.__tbl)
    end

    function Llen(o1: Lmetatable)
        return LBUILT_IN_RETURN(o1, "__Llen", #o1.__tbl)
    end

    function Lsetkey(t: Lmetatable, _k, _v)
        if typeof(_v) == "function" then
            t[_k] = _v
            return
        end

        if table.find(Lmeta.Lmetamethodnames, _k) then
            if not t.__meta then t.__meta = {} end
            t.__meta[_k] = _v
            return
        end

        if t.__tbl then t.__tbl[_k] = _v return end
        t[_k] = _v
    end

    function Lget(t: Lmetatable, _k)
        return (t.__tbl and t.__tbl[_k]) or t[_k]
    end

    function Lcall(_: Lmetatable | ()->(), ...: any)
        if type(_) == "function" then return _(...) end

        if not _.__meta or not _.__meta.__Lcall then error("Attempted to call a nil value") end

        return _.__meta.__Lcall(_, ...)
    end

    function Ladd(o1, o2)
        if type(o1) == "number" and typeof(o2) == "number" then return o1+o2 end

        return (LBUILT_IN_METHAMETHOD_EXISTS(o1, "__Ladd") and o1.__meta.__Ladd(o1,o2)) or (LBUILT_IN_METHAMETHOD_EXISTS(o2, "__Ladd") and o2.__meta.__Ladd(o1,o2)) or error("Attempted to perform arithmetic(add) on "..typeof(o1).." and "..typeof(o2))
    end

    --@Deprecated
    --Should no longer be used, instead just set Lmetamethods directly in a table containing an Lmeta
    function Lsetmetamethod(o: {}, fName: string, f: ()->())
        if not o.__meta then o.__meta = {} end
        o.__meta[fName] = f
    end

    --Sets the Lmeta of t1 to the Lmeta of t2, creating a __meta field if one doesn't exist
    function Lsetmeta(t1: {}, t2: {})

        local tCopy = deepCopy(t1)

        t1 = {}

        t1.__tbl = tCopy

        for _k, _v in t2 do
            if typeof(_v) == "function" and not table.find(Lmeta.Lmetamethodnames, _k) then t1[_k] = _v end
        end

        if not t2 or not t2.__meta then
            t1.__meta = {}

            for _k, _v in t2 do
                if table.find(Lmeta.Lmetamethodnames, _k) then t1.__meta[_k] = _v end
            end

            --return t1
            return setmetatable(t1, Lmeta)
        end

        t1.__meta = deepCopy(t2.__meta)

        --return t1
        return setmetatable(t1, Lmeta)
    end
end