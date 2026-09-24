---@diagnostic disable: need-check-nil
---@omw-context player
local self = require("openmw.self")
local storage = require("openmw.storage")
local async = require("openmw.async")
local types = require("openmw.types")
local ambient = require("openmw.ambient")
local core = require("openmw.core")

local settingsCache = require("scripts.UnlockableRaces.utils.settingsCache")
local races = require("scripts.UnlockableRaces.races.player")

local l10n = core.l10n("UnlockableRaces")
local settings = settingsCache.new(
    storage.playerSection("SettingsUnlockableRaces_races"),
    async
)

local function tryUnlockingRace(unlocked, raceId)
    if unlocked and races.unlockRace(raceId) then
        local raceName = types.NPC.races.records[raceId].name
        local msg = l10n("msg_newRaceUnlocked", { race = raceName })
        self:sendEvent("ShowMessage", { message = msg })
        ambient.playSound("skillraise")
    end
end

local function getLockedRaceId(object)
    if not object or not types.NPC.objectIsInstance(object) then
        return
    end

    local raceId = types.NPC.records[object.recordId].race
    if races.isUnlocked(raceId) then
        return
    end

    return raceId
end

local function onUiModeChanged(data)
    local raceId = getLockedRaceId(data.arg)
    if not raceId then
        return
    end

    local unlocked = (
        settings.unlockBy.dialogue
        and data.newMode == "Dialogue"
    ) or (
    -- in case there is no race topic in the game
        settings.unlockBy.topic
        and data.newMode == "Dialogue"
        and not races.raceTopics[raceId]
    ) or (
        settings.unlockBy.corpse
        and data.newMode == "Container"
        and types.NPC.isDead(data.arg)
    )

    tryUnlockingRace(unlocked, raceId)
end

local function onDialogueResponse(e)
    local raceId = getLockedRaceId(e.actor)
    if not raceId then
        return
    end

    local unlocked = (
        settings.unlockBy.corpse
        and e.type == "greeting"
        and e.recordId == "hello"
    ) or (
        settings.unlockBy.topic
        and e.type == "topic"
        and e.recordId == races.raceTopics[raceId]
    )

    tryUnlockingRace(unlocked, raceId)
end

return {
    eventHandlers = {
        UiModeChanged = onUiModeChanged,
        DialogueResponse = onDialogueResponse,
    },
}
