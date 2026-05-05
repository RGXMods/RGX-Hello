local RGX = assert(_G.RGXFramework, "RGX-Hello: RGX-Framework not loaded")

RGX:OnLogin(function()
    local db = RGX:DB("RGXHelloDB", { enabled = true, volume = 50 })

    local panel = RGX:Options({
        title = "RGX-Hello",
        tabs = {
            { text = "General", content = function(add)
                add:Toggle("Enable", db, "enabled")
                add:Slider("Volume", db, "volume", 0, 100)
            end },
        },
    })

    RGX:Minimap({
        name    = "RGXHello_Minimap",
        icon    = "Interface\\AddOns\\RGX-Hello\\media\\icon.tga",
        storage = db,
        tooltip = {
            title       = "RGX-Hello",
            description = "An RGX-Framework example.",
        },
        onLeftClick = function() panel:Open() end,
    })
end)

RGX:Slash("rgxhello", function(input)
    RGX:Print(input ~= "" and ("You said: " .. input) or "Hello from RGX-Hello!")
end)
