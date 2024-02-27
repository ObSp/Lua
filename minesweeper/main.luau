type State = "Active" | "Won" | "Lost"

local classesfolder = "minesweeper/classes/"

local game = require(classesfolder.."game")

while true do
    local curgame = game.new()
    curgame:Start()
    curgame.completed:Wait()
    local state: State = curgame.state
    

    if state == "Won" then
        print("Won!")
    end
end