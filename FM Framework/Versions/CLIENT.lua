export type Controller = {
    start: ()->()
}

--TODO: change when in studio
local promise = require("__index/Promise.lua")

local fm = {}
local Controllers = {}
local ServiceCache = {}

local function initControllers()
    local success, err = pcall(function()
        for name: string, controller: Controller in Controllers do
            controller.start()
        end
    end)

    return success, err
end

-- Adds the specified controller to the module's controller cache so that it will be initialized when FM.start() is called
--@param name : The name of the controller to add. This is useful when retrieving the controller from other processes
--@param controller : The module to be added
function fm.AddController(name: string, controller: {})
    Controllers[name] = controller
end

-- Attempts to retrieve the controller with the specified name from the FM Controller Cache and returns it if successful
--@param name : The name of the controller to retrieve
--@return The controller with the name {name} or nil if no such controller exists
function fm.GetController(name: string) : Controller
    return Controllers[name]
end

--Returns a shallow service object, which can be used to interact with the server-side service
--@param name : The name of the service
--@return A shallow service object or nil if the service doesn't exist
function fm.GetService(name: string)
    --TODO: ADD
end

--Initializes the client framework
function fm.start()
    return promise.new(function(resolve, reject)
        local success, err = initControllers()

        if not success then
            reject(err)
            return
        end

        resolve()
    end)
end

return fm