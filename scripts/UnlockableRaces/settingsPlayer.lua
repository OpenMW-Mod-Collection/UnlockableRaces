---@diagnostic disable: param-type-mismatch
---@omw-context player
local I = require('openmw.interfaces')

local races = require("scripts.UnlockableRaces.races.shared")

I.Settings.registerPage {
    key = "UnlockableRaces",
    l10n = "UnlockableRaces",
    name = "page_name",
    description = "page_desc",
}

I.Settings.registerGroup {
    key = 'SettingsUnlockableRaces_races',
    page = 'UnlockableRaces',
    l10n = "UnlockableRaces",
    name = "races_groupName",
    order = 0,
    permanentStorage = true,
    settings = {
        {
            key = 'unlockBy',
            name = 'unlockBy_name',
            description = 'unlockBy_desc',
            renderer = 'multiCheckbox',
            default = {
                topic    = true,
                dialogue = false,
                greeting = false,
                corpse   = true,
            },
            argument = {
                l10n = 'UnlockableRaces',
                keys = {
                    'topic',
                    'dialogue',
                    'greeting',
                    'corpse',
                },
                colorful = true,
            },
        },
        {
            key = 'raceUnlocked',
            name = 'raceUnlocked_name',
            description = 'raceUnlocked_desc',
            renderer = 'twoColumnSet',
            default = races.defaultUnlocked,
            argument = {
                width      = 200,
                leftLabel  = 'Unlocked',
                rightLabel = 'Locked',
                lower      = true,
                colorful   = true,
            },
        },
    },
}
