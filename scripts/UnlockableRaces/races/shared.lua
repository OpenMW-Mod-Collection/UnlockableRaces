---@diagnostic disable: undefined-field, undefined-global
---@omw-context load|menu|player
local storage = require("openmw.storage")
local core = require("openmw.core")
local auxUtil = require("openmw_aux.util")

-- https://media.tenor.com/LkpkY6TdgewAAAPo/tylercarey.mp4
local raceRecords = core.quit
    and require("openmw.types").NPC.races.records
    or require("openmw.content").races.records

local M = {}

M.storageSection = storage.playerSection("UnlockableRaces_races")
-- for k, v in pairs(M.storageSection:asTable()) do
--     print(k, v)
--     for i, j in pairs(v) do
--         print(i, j)
--     end
-- end

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

---@return table locked
---@return table unlocked
M.getRaces = function()
    return M.storageSection:get("locked") and auxUtil.shallowCopy(M.storageSection:get("locked")) or M.tdRaces,
        M.storageSection:get("unlocked") and auxUtil.shallowCopy(M.storageSection:get("unlocked")) or M.vanillaRaces
end

return M
