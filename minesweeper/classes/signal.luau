local signal = {}
signal.__index = signal


function signal:Connect(f: ()->())
    table.insert(self._connections, f)
end

function signal:Fire()
    for _,f in self._connections do
        f()
    end

    for _,f in self._onces do
        f()
    end
    self._onces = {}
end


function signal:Once(f: ()->())
    table.insert(self._onces, f)
end

function signal:Wait()
    local done = false
    self:Once(function()
        done = true
    end)
    repeat until done
end

function signal:Disconnect()
    self._connections = {}
    self._onces = {}
end


function signal.new()
    local self = setmetatable({}, signal)
    self._connections = {}
    self._onces = {}
    return self
end

return signal