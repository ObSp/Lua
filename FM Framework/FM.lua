local game = {
    GetService = function(self, n)
        return {
            IsServer = function(self)
                return true
            end
        }
    end
}

local rs = game:GetService("RunService")
local client = require("Versions/CLIENT")
local server = require("Versions/SERVER")

if rs:IsServer() then
    return server
else
    return client
end