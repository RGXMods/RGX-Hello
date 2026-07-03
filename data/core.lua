--=====================================================================================
-- RGX-Hello — the smallest complete RGX-Framework addon.
--
-- This is the entire addon. Line 1 is the addon: RGXAddon is a global the
-- framework provides -- ## RequiredDeps: RGX-Framework guarantees it exists
-- before this file runs. No local, no assert, no event frames, no C_Timer,
-- no SLASH_X globals, no SavedVariables boilerplate.
--
-- What this one call gives you for free:
--   - saved settings with automatic persistence (db)
--   - a tabbed options panel with db-bound controls that save AND restore
--     their visual state correctly (options)
--   - a slash command whose default handler opens that panel (slash)
--   - a minimap button (minimap)
--   - branded chat output (welcome, self:Print)
--   - scoped event registration, routed through the framework's taint-safe
--     paths -- never a manual event frame (onInit)
--=====================================================================================

RGXAddon "RGX-Hello" {
    dbName  = "RGXHelloDB",
    slash   = "rgxhello",
    minimap = "Interface\\AddOns\\RGX-Hello\\media\\icon.tga",

    db = {
        enabled = true,
        volume = 50,
    },

    options = {
        General = {
            { toggle = "enabled", label = "Enable Addon" },
            { slider = "volume", label = "Volume", min = 0, max = 100, suffix = "%" },
        },
    },

    welcome = "loaded -- /rgxhello for options",

    onInit = function(self)
        self:RegisterEvent("PLAYER_LOGIN", function()
            self:Print("Hello from RGX-Hello!")
        end)
    end,
}
