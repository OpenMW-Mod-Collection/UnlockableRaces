---@diagnostic disable: undefined-field, undefined-global
---@omw-context load|menu|player
local storage = require("openmw.storage")
local core = require("openmw.core")

local raceRecords = core.quit
    and require("openmw.types").NPC.races.records
    or require("openmw.content").races.records

local M = {}

M.storageSection = storage.playerSection("SettingsUnlockableRaces_races")

M.vanillaRaces = {
    ["redguard"] = true,
    ["dark elf"] = true,
    ["imperial"] = true,
    ["breton"]   = true,
    ["nord"]     = true,
    ["wood elf"] = true,
    ["high elf"] = true,
    ["khajiit"]  = true,
    ["argonian"] = true,
    ["orc"]      = true,
}

M.tdRaces = {}
for _, raceRecord in ipairs(raceRecords) do
    if raceRecord.id:find("^t_") then
        M.tdRaces[raceRecord.id] = true
    end
end

-- Default unlocked-state for every known race: vanilla = true, td = false.
-- The "raceUnlocked" setting only needs to store *overrides* of this.
M.defaultUnlocked = {}
for raceId in pairs(M.vanillaRaces) do M.defaultUnlocked[raceId] = true end
for raceId in pairs(M.tdRaces) do M.defaultUnlocked[raceId] = false end

---@param raceId string
---@return boolean
M.isUnlocked = function(raceId)
    local overrides = M.storageSection:get("raceUnlocked") or {}
    local v = overrides[raceId]
    if v == nil then
        return M.defaultUnlocked[raceId] == true
    end
    return v == true
end

---@return table locked
---@return table unlocked
M.getRaces = function()
    local overrides = M.storageSection:get("raceUnlocked") or {}
    local locked, unlocked = {}, {}

    for raceId in pairs(M.defaultUnlocked) do
        if M.isUnlocked(raceId) then
            unlocked[raceId] = true
        else
            locked[raceId] = true
        end
    end
    -- catch any override for a race outside the known default set
    for raceId in pairs(overrides) do
        if M.defaultUnlocked[raceId] == nil then
            if overrides[raceId] then unlocked[raceId] = true else locked[raceId] = true end
        end
    end

    return locked, unlocked
end

return M
