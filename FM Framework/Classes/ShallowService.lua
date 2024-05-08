local CONFIG = require("CONFIG")

local ss = {}
ss.__index = ss

if CONFIG.AUTO_INDEX_TO_SERVER then
    ss.__index = function(self, requested_index)
        if ss[requested_index] then return ss[requested_index] end

        --TODO: send request to server to get object
    end
end


function ss._new()
    local self = setmetatable({}, ss)

    return self
end

return ss