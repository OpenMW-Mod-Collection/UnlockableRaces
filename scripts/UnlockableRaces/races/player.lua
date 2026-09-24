---@diagnostic disable: undefined-field, undefined-global, need-check-nil
---@omw-context player
local core = require("openmw.core")
local types = require("openmw.types")
local utilAux = require("openmw_aux.util")

local racesShared = require("scripts.UnlockableRaces.races.shared")

local M = {}

M.storageSection = racesShared.storageSection
M.vanillaRaces = racesShared.vanillaRaces
M.tdRaces = racesShared.tdRaces
M.getRaces = racesShared.getRaces
M.isUnlocked = racesShared.isUnlocked

M.raceTopics = {}
for _, races in ipairs { M.vanillaRaces, M.tdRaces } do
    for raceId, _ in pairs(races) do
        local raceRecord = types.NPC.races.records[raceId]
        local raceName = raceRecord.name:lower()
        if core.dialogue.topic.records[raceName] then
            M.raceTopics[raceId] = raceName
        end
    end
end

M.unlockRace = function(raceId)
    if M.isUnlocked(raceId) then
        return false
    end

    local overrides = utilAux.shallowCopy(M.storageSection:get("raceUnlocked") or {})
    overrides[raceId] = true
    M.storageSection:set("raceUnlocked", overrides)
    return true
end

return M
