local class: (args: {})->() = require("Signal/__index/class")
local Array: {new: ()->{}} = require("Signal/__index/Array")

export type Signal = {
    Connect: (self: Signal, callback: ()->())->Connection,
    Once: (self: Signal, callback: ()->())->OnceConnection,
    Wait: (self: Signal)->...any,
    Fire: (self: Signal, ...any)->(),
}

export type AbstractConnection = {
    Connected: boolean,
}

export type OnceConnection = {
    Disconnect: ()->(),
    Connected: boolean,
}

export type Connection = {
    Disconnect: ()->(),
    Connected: boolean,
}

local function wait(time)
    local s = os.clock()
    repeat until os.clock()-time>s
end

local abstract_connection = class{

    Connected = false,

    constructor = function(self: AbstractConnection, parent, callback: ()->())
        self._parent = parent
        self.Connected = true
        self._callback = callback
    end,

    _call = function(self: AbstractConnection , ...)
        return self._callback(...)
    end
}

local connection = class{
    extends = abstract_connection,

    Disconnect = function(self: Connection)
        if not self.Connected then
            error("Unable to disconnect an already disconnected signal")
        end

        local parent: Signal = self._parent

        local callbackIndex = table.find(parent._callbacks, self)

        if callbackIndex then
            table.remove(parent._callbacks, callbackIndex)
        end
    end,
}

local onceConnection = class{
    extends = abstract_connection,

    constructor = function(self: OnceConnection, parent, callback: ()->())
        self.super(self, parent, callback)
    end,

    Disconnect = function(self: OnceConnection)
        if not self.Connected then
            error("Unable to disconnect an already disconnected signal")
        end

        local parent: Signal = self._parent

        local onceIndex = table.find(parent._onces, self)

        if onceIndex then
            table.remove(parent._onces, onceIndex)
        end
    end,

    _call = function(self: OnceConnection, ...)
        self:Disconnect()
        return self.super._call(self, ...)
    end
}

local signal = class{

    _callbacks = Array.new(),
    _onces = Array.new(),

    Connect = function(self: Signal, callback: ()->())
        local con: Connection = connection(self, callback)
        self._callbacks:Insert(con)
    end,

    Once = function(self: Signal, callback: ()->())
        local con: OnceConnection = onceConnection(self, callback)
        self._onces:Insert(con)
    end,

    Fire = function(self: Signal, ...)
        local args = ...
        self._callargs = args
        self._callbacks:forEach(function(i, v:Connection)
            v:_call(args)
        end)
        self._onces:forEach(function(i, v:OnceConnection)
            v:_call(args)
        end)
    end,

    Wait = function(self: Signal)
        local fired = false
        self:Once(function()
            fired = true
        end)

        repeat until fired

        return self._callargs
    end
}

local sig: Signal = signal()


coroutine.wrap(function()
    wait(1)
    sig:Fire("hello", "bye")
end)()

sig:Connect(function(arg1, arg2)
    print(arg1, arg2)
end)