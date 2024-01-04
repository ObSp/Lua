local itemList = {
    Common = {
        Cost = 2,
        Rarity = "Common"
    },
    Rare = {
        Cost = 15,
        Rarity = "Rare"
    },
    Legendary = {
        Cost = 50,
        Rarity = "Legendary"
    },
} 

local function GenerateItems()
    local returntable = {}
    for item, _ in itemList do
        table.insert(returntable, item)
    end
    return returntable
end

local rxscript = require("rxscript")
local dailyshopstore = rxscript.GetDataStore("DailyShop",{ShopItems={}}, "Other",  rxscript.InstanceTypes.DataStoreSettings(true,true,nil, 5))

local date = os.date("*t")
local today = date.day*date.year
local yesterday = dailyshopstore:GetData(today*date.year)

if yesterday == today then return end

local items = GenerateItems()

dailyshopstore:SaveData(today*date.year,items)
