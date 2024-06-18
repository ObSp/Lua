function calcXP(level: number)
    return math.round((level^1.5)*250)
end

print("local info = {}")
print()
print("info.LevelInfo = {")

local lastmin = -1

for i=1,999 do
    print(`[{i}] = `.."{"..`MinimumEXP = {lastmin+1}, MaximumEXP = {calcXP(i)}`.."},")
end

print("}\n\n return info")