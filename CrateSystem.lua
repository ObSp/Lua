local rxscript = require(game.ReplicatedStorage.rxscript)
local swords = game.ServerStorage:WaitForChild("Swords"):GetChildren()

local crate = {}

function crate.GenerateSword() : Instance
    return swords[math.random(1,#swords)]
end

function crate.Bought(plr: Player)
    local sword = crate.GenerateSword():Clone()
    sword.Parent = plr.Backpack
end

-- return crate

local toolstore = rxscript.GetDataStore("ToolStore", {Tools = {}}, rxscript.Instantiate("DataStoreSettings"))

local PlayerMain = {}

local function GetTools(plr:Player)
    local tools = {}
    for _,v in plr.Backpack:GetChildren() do
        if v:IsA("Tool") then table.insert(tools, v) end
    end
    for _,v in plr.Character:GetChildren() do
        if v:IsA("Tool") then table.insert(tools, v) end
    end
    return tools
end

function PlayerMain.KeepToolsOnRespawn(plr: Player)
    local tools = {}
    plr.CharacterAdded:Connect(function(char)
        for _,tool in tools do
            swords[tool.Name]:Clone().Parent = plr.Backpack
        end
        char:WaitForChild("Humanoid").Died:Connect(function()
            tools = GetTools(plr)
        end)
    end)
end

function PlayerMain.SaveTools(plr: Player)
    local tools
end