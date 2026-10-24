--=====================================================================================
-- RGX-Hello — the smallest complete RGX-Framework addon.
--
-- This is the entire addon. One call is the addon: RGXAddon is a global the
-- framework provides -- ## RequiredDeps: RGX-Framework guarantees it exists
-- before this file runs. No event frames, no C_Timer, no SLASH_X globals,
-- no SavedVariables boilerplate.
--
-- The two guard lines above the call are the RGX contract compatibility
-- handshake (docs/DECLARATIVE-API.md): an RGX-Framework too old to honor
-- contract format 1 fails loudly with one clear message instead of
-- silently ignoring this addon.
--
-- What this one call gives you for free:
--   - saved settings with automatic persistence (db)
--   - a tabbed options panel with declarative pages/card grids
--     (one two-column page here) and db-bound controls that save AND restore
--     their visual state correctly (options)
--   - a slash command whose default handler opens that panel (slash)
--   - a minimap button (minimap)
--   - branded chat output (welcome, self:Print)
--   - startup and repeating timer logic routed through RGX paths -- never a
--     manual event frame or C_Timer (onInit, declarative every)
--=====================================================================================

local RGX = _G.RGXFramework
if type(RGX) ~= "table" or type(RGX.RequireContract) ~= "function" then
    error("RGX-Hello requires RGX-Framework 2.11.0 or newer with the RGX contract compatibility handshake. Update RGX-Framework.", 0)
end
RGX:RequireContract("RGX-Hello", 1, "2.11.0")

RGXAddon "RGX-Hello" {
    dbName  = "RGXHelloDB",
    slash   = "rgxhello",
    minimap = "Interface\\AddOns\\RGX-Framework\\media\\logo.tga",

    db = {
        enabled = true,
        volume = 50,
    },

    compat = {
        GetAddOnMetadata = { "C_AddOns.GetAddOnMetadata", "GetAddOnMetadata" },
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
            {
                page  = "Basics",
                grid  = 2,
                cards = {
                    {
                        card     = "Core",
                        controls = {
                            { toggle = "enabled", label = "Enable Addon" },
                        },
                    },
                    {
                        card     = "Audio",
                        columns  = 1,
                        controls = {
                            { slider = "volume", label = "Volume", min = 0, max = 100, suffix = "%" },
                        },
                    },
                },
            },
        },
    },

    onInit = function(self)
        local version = self.compat.GetAddOnMetadata("RGX-Hello", "Version") or "unknown"
        RGX:LoginMessage(string.format(
            "RGX-Hello v%s loaded with RGX-Framework v%s.",
            tostring(version),
            tostring(RGX.version or "unknown")
        ))
    end,
}
