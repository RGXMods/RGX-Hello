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
--   - startup and repeating timer logic routed through RGX paths -- never a
--     manual event frame or C_Timer (onInit, declarative every)
--=====================================================================================

local RGX = _G.RGXFramework

RGXAddon "RGX-Hello" {
    dbName  = "RGXHelloDB",
    slash   = "rgxhello",
    minimap = "Interface\\AddOns\\RGX-Framework\\media\\logo.tga",

    db = {
        enabled = true,
        volume = 50,
    },

    every = {
        heartbeat = { 1, function(self, timer)
            self.heartbeatTicks = (self.heartbeatTicks or 0) + 1
            if self.heartbeatTicks >= 3 then
                self:CancelTimer(timer)
            end
        end },
    },

    options = {
        General = {
            { toggle = "enabled", label = "Enable Addon" },
            { slider = "volume", label = "Volume", min = 0, max = 100, suffix = "%" },
        },
    },

    onInit = function()
        local version = RGX.API.GetAddOnMetadata("RGX-Hello", "Version") or "unknown"
        RGX:LoginMessage(string.format(
            "RGX-Hello v%s loaded with RGX-Framework v%s.",
            tostring(version),
            tostring(RGX.version or "unknown")
        ))
    end,
}
