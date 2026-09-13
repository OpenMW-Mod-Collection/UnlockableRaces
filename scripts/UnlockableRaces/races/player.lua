---@diagnostic disable: undefined-field, undefined-global, need-check-nil
---@omw-context player
local storage = require("openmw.storage")
local core = require("openmw.core")
local types = require("openmw.types")
local auxUtil = require("openmw_aux.util")

local racesShared = require("scripts.UnlockableRaces.races.shared")

local M = {}

M.storageSection = racesShared.storageSection
M.vanillaRaces = racesShared.vanillaRaces
M.tdRaces = racesShared.tdRaces
M.getRaces = racesShared.getRaces

local settingsSection = storage.playerSection("SettingsUnlockableRaces_races")

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

local prevLocked, prevUnlocked = M.getRaces()

M.initRaces = function()
    if not M.storageSection:get("locked") then
        M.storageSection:set("locked", M.tdRaces)
    end
    if not M.storageSection:get("unlocked") then
        M.storageSection:set("unlocked", M.vanillaRaces)
    end
end

local function updateStorage(locked, unlocked)
    M.storageSection:set("locked", locked)
    M.storageSection:set("unlocked", unlocked)
    settingsSection:set("locked", locked)
    settingsSection:set("unlocked", unlocked)
end

M.unlockRace = function(raceId)
    if not prevLocked[raceId] then
        return false
    end

    prevLocked[raceId] = nil
    prevUnlocked[raceId] = true
    updateStorage(prevLocked, prevUnlocked)
    return true
end

M.resyncRaceLists = function()
    local unlocked = auxUtil.shallowCopy(settingsSection:get("unlocked"))
    local locked = auxUtil.shallowCopy(settingsSection:get("locked"))
    local changed = false

    for raceId in pairs(prevUnlocked) do
        if not unlocked[raceId] and not locked[raceId] then
            locked[raceId] = true
            changed = true
        end
    end
    for raceId in pairs(prevLocked) do
        if not locked[raceId] and not unlocked[raceId] then
            unlocked[raceId] = true
            changed = true
        end
    end

    if not changed then
        return
    end

    prevUnlocked = unlocked
    prevLocked = locked
    updateStorage(prevLocked, prevUnlocked)
end

return M
