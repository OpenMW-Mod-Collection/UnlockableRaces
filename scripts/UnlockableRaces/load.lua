---@diagnostic disable: undefined-global
---@omw-context load
local content = require("openmw.content")

local function changeRaces(raceList, isPlayable)
    for raceId, _ in pairs(raceList) do
        local race = content.races.records[raceId]
        if race then
            -- print(raceId, isPlayable)
            race.isPlayable = isPlayable
        end
    end
end

local function onContentFilesLoaded()
    local racesShared = require("scripts.UnlockableRaces.races.shared")
    local lockedRaces, unlockedRaces = racesShared.getRaces()
    changeRaces(lockedRaces, false)
    changeRaces(unlockedRaces, true)
end

return {
    engineHandlers = {
        onContentFilesLoaded = onContentFilesLoaded,
    }
}
