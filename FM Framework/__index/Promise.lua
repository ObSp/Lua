type Promise = {
    andThen: (onfullfilled: ()->()?)->Promise,
    finally: (onfinnaly: ()->()?)->Promise,
    catch: (onreject: (rejectMessage: string?)->()?)->Promise
}


local promise = {}

local stateTypes = {
    UnResolved = 0,
    Resolved = 1,
    Rejected = 2
}


function promise.await(promise: Promise)
    local x = false
    promise.finally(function()
        x = true
    end)
    repeat until x
end

function promise.resolve(resolveable: Promise?)
    if not resolveable then 
        return promise.new(function(resolve, accept)
            resolve()
        end)
    end

    resolveable.state = stateTypes.Resolved
    for _,onfullfilled in resolveable._andThens do onfullfilled() end
    for _,onfinnaly in resolveable._finallies do onfinnaly("resolved") end
end

--Returns a new promise with the attached `executor`, which is called after the promise is created
function promise.new(executor: (resolve: (resolveMessage: any?)->(), reject: (rejectMessage: any?)->())->()) : Promise
    local self: Promise = {}
    self.state = stateTypes.UnResolved
    self._andThens = {}
    self._catches = {}
    self._finallies = {}

    function self.andThen(onfullfilled: ()->()?)
        if self.state == stateTypes.Resolved then onfullfilled() return promise.new() end

        table.insert(self._andThens, onfullfilled)
        return self
    end

    function self.finally(onfinnaly: (state: string)->()?)
        if self.state then onfinnaly(self.state==stateTypes.Resolved and "resolved" or "rejected") return promise.new() end
        table.insert(self._finallies, onfinnaly)
        return promise.new()
    end

    function self.catch(onreject: (rejectMessage: string?)->())
        if self.state == stateTypes.Rejected then onreject() return promise.new() end
        table.insert(self._catches, onreject)
        return self
    end

    local function resolve(resolveMessage: any?)
        self.state = stateTypes.Resolved
        for _,onfullfilled in self._andThens do onfullfilled(resolveMessage) end
        for _,onfinnaly in self._finallies do onfinnaly("resolved") end
    end

    local function reject(rejectMessage: any?)
        self.state = stateTypes.Rejected
        for _,onreject in self._catches do onreject(rejectMessage) end
        for _,onfinnaly in self._finallies do onfinnaly("rejected") end
        return self
    end



    if executor then executor(resolve, reject) end

    return self
end

--return promise