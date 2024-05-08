--[=[ FM FRAMEWORK SERVER
- The module for anything FM server-related. 
]=]

type n = number


export type Service = {
    init: ()->()
}

--TODO: change when in studio
local promise = require("__index/Promise.lua")

local fm = {}
local Services = {}

local function initServices()
    local success, err = pcall(function()
        for name: string, service: Service in Services do
            service.start()
        end
    end)

    return success, err
end

-- Adds the specified service to the module's service cache so that it will be initialized when FM.start() is called
--@param name : The name of the service to add. This is useful when retrieving the service from other processes
--@param service : The module to be added
function fm.AddService(name: string, service: Service)
    Services[name] = service
end

-- Attempts to retrieve the service with the specified name from the FM Service Cache and returns it if successful
--@param name : The name of the service to retrieve
--@return The service with the name {name} or nil if no such service exists
function fm.GetService(name: string) : Service
    return Services[name]
end

--Initializes the server framework
function fm.start()
    return promise.new(function(resolve, reject)
        local success, err = initServices()

        if not success then
            reject(err)
            return
        end

        resolve()
    end)
end

return fm