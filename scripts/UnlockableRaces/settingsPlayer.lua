---@diagnostic disable: param-type-mismatch
---@omw-context player
local I = require('openmw.interfaces')
local auxUtil = require("openmw_aux.util")

local races = require("scripts.UnlockableRaces.races.shared")

local locked, unlocked = races.getRaces()

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
                dialogue = true,
                greeting = false,
                corpse   = false,
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
            key = "unlocked",
            name = "unlocked_name",
            description = "unlocked_desc",
            renderer = "textSet",
            default = auxUtil.shallowCopy(unlocked), -- userdata is le bad
            argument = {
                lower = true,
                label = "Race Id",
            },
        },
        {
            key = "locked",
            name = "locked_name",
            description = "locked_desc",
            renderer = "textSet",
            default = auxUtil.shallowCopy(locked),
            argument = {
                lower = true,
                label = "Race Id",
            },
        },
    },
}
