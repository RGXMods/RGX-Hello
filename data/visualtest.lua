--=====================================================================================
-- RGX Visual Test -- dev/debug visual QA harness for RGX-Framework, bundled into
-- RGX-Hello. RGX-Hello now serves two purposes in one install: data/core.lua is
-- the minimal declarative RGXAddon example, and this file is the manual/advanced
-- pattern -- hand-building tab content with every control type via RGX:GetUI(),
-- RGX:GetColorPicker(), RGX:GetDropdowns(), RGX:GetFonts(), RGX:GetTextures().
-- Rather than open a second window, these test tabs are registered onto
-- RGX-Hello's own options panel via RGX:AddOptionsTab, so /rgxhello and
-- /rgxvisual open one shared panel. Every API called below was verified against real
-- RGX-Framework source (modules/ui/controls.lua, modules/ui/options.lua,
-- modules/colors/colorpicker.lua, modules/fonts/dropdowns.lua,
-- modules/textures/textures.lua) before this file was written.
--
-- In-game:
--   /rgxvisual  -- opens the full tabbed test panel
--   /rgxcolor   -- opens just the color picker directly
--=====================================================================================

local R = _G.RGXFramework
if not R then return end

_G.RGXVisualTestDB = _G.RGXVisualTestDB or {}
local DB = _G.RGXVisualTestDB

DB.primary = DB.primary or { r = 0.35, g = 0.75, b = 0.51 }
DB.accent = DB.accent or { r = 0.74, g = 0.44, b = 0.66 }
DB.enabled = DB.enabled ~= false
DB.scale = DB.scale or 100
DB.volume = DB.volume or "medium"
DB.dropdownChoice = DB.dropdownChoice or "one"

local function Log(...)
    print("|cFF00A2FF[RGXVisual]|r", ...)
end

local function Place(parent)
    local y = -18
    return function(widget, gap)
        if not widget then return nil end
        widget:SetPoint("TOPLEFT", parent, "TOPLEFT", 18, y)
        y = y - (widget:GetHeight() or 28) - (gap or 12)
        return widget
    end
end

local function MakePreview(parent, title)
    local D = R:GetDesign()
    local f = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    f:SetSize(300, 130)
    f:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
    })
    f:SetBackdropColor(0.08, 0.09, 0.11, 0.96)
    f:SetBackdropBorderColor(D:Unpack("border"))

    f.title = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    f.title:SetPoint("TOP", 0, -10)
    f.title:SetText(title or "Preview")

    f.swatch = f:CreateTexture(nil, "ARTWORK")
    f.swatch:SetSize(90, 50)
    f.swatch:SetPoint("CENTER", 0, -12)
    f.swatch:SetColorTexture(DB.primary.r, DB.primary.g, DB.primary.b, 1)

    f.value = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    f.value:SetPoint("BOTTOM", 0, 10)

    function f:SetColor(r, g, b)
        self.swatch:SetColorTexture(r, g, b, 1)
        self.value:SetText(string.format("RGB %.2f / %.2f / %.2f", r, g, b))
    end

    f:SetColor(DB.primary.r, DB.primary.g, DB.primary.b)
    return f
end

local function BuildColorsTab(frame)
    local UI = R:GetUI()
    local CP = R:GetColorPicker()
    local add = Place(frame)

    local title = UI:CreateLabel(frame, {
        text = "Color Picker Visual Test",
        size = "large",
        color = "accent",
    })
    add(title)

    local preview = MakePreview(frame, "Selected Color Preview")
    add(preview, 18)

    local picker = UI:CreateColorPicker(frame, {
        key = "primary",
        label = "Primary Color Swatch",
        storage = DB,
        default = { r = 0.35, g = 0.75, b = 0.51 },
        previewOnClick = function()
            Log("Color swatch clicked -- test SV square, hue bar, RGB, HEX, presets, OK/Cancel")
        end,
        onChange = function(r, g, b)
            DB.primary = { r = r, g = g, b = b }
            preview:SetColor(r, g, b)
            Log("Color changed", string.format("%.2f %.2f %.2f", r, g, b))
        end,
    })
    add(picker)

    local accent = UI:CreateColorPicker(frame, {
        key = "accent",
        label = "Accent Color Swatch",
        storage = DB,
        default = { r = 0.74, g = 0.44, b = 0.66 },
        onChange = function(r, g, b)
            DB.accent = { r = r, g = g, b = b }
            Log("Accent changed", string.format("%.2f %.2f %.2f", r, g, b))
        end,
    })
    add(accent)

    add(UI:CreateLabel(frame, { text = "Embedded color-picker card (UI:CreateColorPickerCard):", size = "small", color = "muted" }), 4)
    local card = UI:CreateColorPickerCard(frame, {
        key = "cardColor",
        storage = DB,
        default = { r = 0.35, g = 0.75, b = 0.51 },
        width = 220,
        onChange = function(r, g, b)
            preview:SetColor(r, g, b)
            Log("Embedded card changed", string.format("%.2f %.2f %.2f", r, g, b))
        end,
    })
    add(card, 18)

    local direct = UI:CreateButton(frame, "Open ColorPicker Directly", 210, 24)
    direct:SetScript("OnClick", function()
        CP:Show(DB.primary, function(r, g, b)
            DB.primary = { r = r, g = g, b = b }
            preview:SetColor(r, g, b)
            Log("Direct picker OK", string.format("%.2f %.2f %.2f", r, g, b))
        end)
    end)
    add(direct)

    add(UI:CreateLabel(frame, {
        text = "What to test: click swatches, drag SV square, drag hue bar, type HEX, type RGB, click presets, test OK, test Cancel, test X close, drag picker window, test Reset button.",
        size = "small",
        color = "muted",
        width = 340,
    }))
end

local function BuildControlsTab(frame)
    local UI = R:GetUI()
    local add = Place(frame)

    add(UI:CreateLabel(frame, {
        text = "Basic Control Visual Test",
        size = "large",
        color = "accent",
    }))

    add(UI:CreateToggle(frame, {
        key = "enabled",
        label = "Enable Test Toggle",
        storage = DB,
        default = true,
        onChange = function(v) Log("Toggle changed", tostring(v)) end,
    }))

    add(UI:CreateSlider(frame, {
        key = "scale",
        label = "Scale Slider",
        storage = DB,
        min = 50,
        max = 150,
        step = 5,
        default = 100,
        suffix = "%",
        width = 260,
        onChange = function(v) Log("Slider changed", v) end,
    }))

    add(UI:CreateVolumeSlider(frame, {
        key = "volume",
        storage = DB,
        default = "medium",
        width = 160,
        onChange = function(v) Log("Volume slider changed", v) end,
    }))

    add(UI:CreateLabel(frame, {
        text = "What to test: checkbox click, reset button, slider drag, slider click, mousewheel on slider, volume low/medium/high.",
        size = "small",
        color = "muted",
        width = 340,
    }))
end

local function BuildDropdownsTab(frame)
    local UI = R:GetUI()
    local Drops = R:GetDropdowns()
    local add = Place(frame)

    add(UI:CreateLabel(frame, {
        text = "Dropdown Visual Test",
        size = "large",
        color = "accent",
    }))

    local dd = Drops:CreateNestedDropdown(frame, {
        label = "Nested Dropdown",
        width = 320,
        buttonWidth = 240,
        value = DB.dropdownChoice,
        placeholder = "Choose one",
        items = {
            { text = "Group A", children = {
                { text = "Option One", value = "one" },
                { text = "Option Two", value = "two" },
            }},
            { text = "Group B", children = {
                { text = "Purple Choice", value = "purple" },
                { text = "Green Choice", value = "green" },
            }},
            { isSeparator = true },
            { text = "No Value Button", notCheckable = true },
        },
        onChange = function(value)
            DB.dropdownChoice = value
            Log("Dropdown selected", tostring(value))
        end,
    })
    add(dd, 20)

    add(UI:CreateLabel(frame, {
        text = "What to test: open menu, open nested groups, select radio item, reopen and confirm checked state, verify no taint/error.",
        size = "small",
        color = "muted",
        width = 340,
    }))
end

local function BuildMediaTab(frame)
    local UI = R:GetUI()
    local Fonts = R:GetFonts()
    local Textures = R:GetTextures()
    local add = Place(frame)

    add(UI:CreateLabel(frame, {
        text = "Fonts + Textures Visual Test",
        size = "large",
        color = "accent",
    }))

    local sample = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    -- Constrain + wrap so long preview text stays inside the panel instead of
    -- bleeding past its right edge.
    sample:SetWidth(340)
    sample:SetWordWrap(true)
    sample:SetJustifyH("LEFT")
    sample:SetText("Font preview: The quick brown fox jumps over RGX.")
    add(sample, 18)

    local fontDD = Fonts:CreateFontDropdown(frame, {
        label = "Font Dropdown",
        width = 320,
        buttonWidth = 230,
        value = DB.fontName or Fonts:GetDefault(),
        onChange = function(name)
            DB.fontName = name
            R:Font(sample, name, 18, "OUTLINE")
            
            -- User specifically expects this to restyle the entire RGX-Hello panel
            local helloAddon = R:GetAddon("RGX-Hello")
            if helloAddon and helloAddon.panel then
                Fonts:ChangeFontFamily(helloAddon.panel, name)
            end
            
            -- Update the framework's default font so newly built tabs and future UI also use it
            Fonts:SetDefault(name)
            
            Log("Font selected", tostring(name))
        end,
    })
    add(fontDD, 20)

    local bar = CreateFrame("StatusBar", nil, frame)
    bar:SetSize(300, 24)
    bar:SetMinMaxValues(0, 100)
    bar:SetValue(67)
    bar:SetStatusBarColor(DB.primary.r, DB.primary.g, DB.primary.b, 1)
    bar:SetStatusBarTexture(Textures:GetBar(DB.barTexture or Textures:GetDefault()))
    add(bar, 18)

    local barBG = bar:CreateTexture(nil, "BACKGROUND")
    barBG:SetAllPoints()
    barBG:SetColorTexture(0.1, 0.1, 0.1, 1)

    local texDD = Textures:CreateBarSettingControl(frame, {
        label = "Statusbar Texture",
        storage = DB,
        key = "barTexture",
        width = 330,
        onChange = function(holder, name, path)
            if path then
                bar:SetStatusBarTexture(path)
            end
            Log("Texture selected", tostring(name))
        end,
    })
    add(texDD, 20)

    add(UI:CreateLabel(frame, {
        text = "What to test: font dropdown opens, font changes preview text, texture dropdown changes the statusbar texture.",
        size = "small",
        color = "muted",
        width = 340,
    }))
end

local function BuildTooltipTab(frame)
    local UI = R:GetUI()
    local Tip = R:GetTooltip()
    local add = Place(frame)

    add(UI:CreateLabel(frame, {
        text = "RGXTooltip Visual Test",
        size = "large",
        color = "accent",
    }))

    -- Tip:Attach — one call wires OnEnter/OnLeave; builder runs at hover time
    local attached = UI:CreateButton(frame, "Hover Me (Tip:Attach)", 220, 26)
    Tip:Attach(attached, function()
        return {
            title = "Attached Tooltip",
            lines = {
                "Plain string line (wraps by default).",
                { "Double line left", "right value" },
                { text = "Colored line", r = 1, g = 0.4, b = 0.4 },
                { text = "This long wrapped line demonstrates that wrap = true keeps composed tooltip text inside the tooltip's own bounds instead of stretching it.", wrap = true },
            },
        }
    end)
    add(attached)

    -- Manual Show/Hide — the raw pair Attach wraps
    local manual = UI:CreateButton(frame, "Hover Me (manual Show/Hide)", 220, 26)
    manual:SetScript("OnEnter", function(self)
        Tip:Show(self, { anchor = "ANCHOR_TOP", title = "Manual Tooltip", lines = { "Shown via Tip:Show, hidden via Tip:Hide." } })
    end)
    manual:SetScript("OnLeave", function() Tip:Hide() end)
    add(manual)

    -- HookNative — one-shot by design: the framework keeps one Blizzard
    -- registration per type forever, and callbacks cannot be unregistered.
    local hookRegistered = false
    local hookBtn = UI:CreateButton(frame, "Register item HookNative", 220, 26)
    hookBtn:SetScript("OnClick", function()
        if hookRegistered then
            Log("HookNative already registered -- hover any item tooltip to see the injected line")
            return
        end
        hookRegistered = Tip:HookNative("item", function(tooltip)
            tooltip:AddLine("|cff58be81RGX HookNative:|r injected by /rgxvisual", 1, 1, 1)
        end)
        Log(hookRegistered and "HookNative(item) registered -- hover any item in your bags"
            or "HookNative(item) registration FAILED")
    end)
    add(hookBtn)

    add(UI:CreateLabel(frame, {
        text = "What to test: hover both buttons (title, double line, colored line, wrapped line, ANCHOR_TOP placement), then register the item hook and hover a bag item -- the green injected line should appear and persist for the session without breaking other tooltips.",
        size = "small",
        color = "muted",
        width = 340,
    }))
end

local function BuildAurasTab(frame)
    local UI = R:GetUI()
    local Auras = R:GetAuras()
    local add = Place(frame)

    add(UI:CreateLabel(frame, {
        text = "RGXAuras Visual Test",
        size = "large",
        color = "accent",
    }))

    local result = UI:CreateLabel(frame, { text = "No scan yet.", size = "small", color = "normal", width = 340 })

    local scanBtn = UI:CreateButton(frame, "Scan Player Auras (IterateAuras)", 240, 26)
    scanBtn:SetScript("OnClick", function()
        local names, total = {}, 0
        Auras:IterateAuras("player", "HELPFUL", function(auraData)
            total = total + 1
            if #names < 5 then
                local ok, name = pcall(function() return auraData.name end)
                names[#names + 1] = (ok and name) or "?"
            end
        end)
        result:SetText(total == 0 and "No HELPFUL auras on player."
            or string.format("%d HELPFUL aura(s): %s%s", total, table.concat(names, ", "), total > 5 and ", ..." or ""))
        Log("Aura scan complete:", total, "helpful aura(s)")
    end)
    add(scanBtn)
    add(result, 16)

    -- Live watch: player is watched by Auras:Init, but WatchUnit is idempotent
    -- so calling it again is safe if module init ordering ever changes.
    local unsubApplied, unsubRemoved
    local watchBtn = UI:CreateButton(frame, "Start Live Aura Log", 240, 26)
    watchBtn:SetScript("OnClick", function()
        if unsubApplied then
            unsubApplied(); unsubRemoved()
            unsubApplied, unsubRemoved = nil, nil
            Log("Live aura log STOPPED")
            return
        end
        Auras:WatchUnit("player")
        unsubApplied = Auras:OnApplied(function(unit, auraData)
            if unit ~= "player" then return end
            local ok, name = pcall(function() return auraData.name end)
            Log("Aura APPLIED:", (ok and name) or "?")
        end)
        unsubRemoved = Auras:OnRemoved(function(unit, instanceID)
            if unit ~= "player" then return end
            Log("Aura REMOVED: instance", instanceID)
        end)
        Log("Live aura log STARTED -- buff/debuff yourself (eat food, mount up) and watch chat. Click again to stop.")
    end)
    add(watchBtn)

    add(UI:CreateLabel(frame, {
        text = "What to test: scan lists your current buffs; live log prints APPLIED/REMOVED lines in chat as auras change (eat food, mount, cancel a buff). Unsubscribe (second click) must stop the chat lines.",
        size = "small",
        color = "muted",
        width = 340,
    }))
end

local function BuildMinimapTab(frame)
    local UI = R:GetUI()
    local MM = R:GetMinimap()
    local add = Place(frame)

    add(UI:CreateLabel(frame, {
        text = "RGXMinimap Visual Test",
        size = "large",
        color = "accent",
    }))

    local testBtn
    local createBtn = UI:CreateButton(frame, "Create Minimap Button", 220, 26)
    createBtn:SetScript("OnClick", function()
        if testBtn then
            Log("Minimap test button already exists -- use Toggle")
            return
        end
        testBtn = MM:Create({
            name         = "RGXVisualTestMinimapButton",
            icon         = "Interface\\AddOns\\RGX-Hello\\media\\icon.tga",
            defaultAngle = 200,
            storage      = DB,
            tooltip = {
                title = "|cff58be81RGX Visual Test|r",
                lines = {
                    { left = "|cff58be81Left-Click|r", right = "Log a click" },
                    { left = "|cff4ecdc4Drag|r",       right = "Move around minimap" },
                },
            },
            onLeftClick = function() Log("Minimap test button left-clicked") end,
        })
        Log(testBtn and "Minimap button created at angle 200 -- drag it, hover it, click it"
            or "Minimap button creation FAILED")
    end)
    add(createBtn)

    local toggleBtn = UI:CreateButton(frame, "Toggle Visibility", 220, 26)
    toggleBtn:SetScript("OnClick", function()
        if not testBtn then
            Log("Create the minimap button first")
            return
        end
        testBtn:Toggle()
        Log("Minimap button now", testBtn:IsShown() and "SHOWN at angle " .. math.floor(testBtn:GetAngle() or 0) or "HIDDEN")
    end)
    add(toggleBtn)

    add(UI:CreateLabel(frame, {
        text = "What to test: create the button, hover for its tooltip, left-click (chat line), drag it around the minimap ring, toggle it off/on, then /reload -- the dragged angle must persist (saved to RGXVisualTestDB).",
        size = "small",
        color = "muted",
        width = 340,
    }))
end

local function BuildDesignTab(frame)
    local UI = R:GetUI()
    local D = R:GetDesign()
    local add = Place(frame)

    add(UI:CreateLabel(frame, {
        text = "RGXDesign + RGX:Font Visual Test",
        size = "large",
        color = "accent",
    }))

    -- RGX:Font -- the one-call font application shipped in v2.3.0
    local sample = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    sample:SetText("RGX:Font sample -- click a button below to restyle me.")
    add(sample, 14)

    local fontDefault = UI:CreateButton(frame, "RGX:Font(defaults)", 160, 24)
    fontDefault:SetScript("OnClick", function()
        R:Font(sample)
        Log("Applied framework default font/size/flags")
    end)
    add(fontDefault, 6)

    local fontNamed = UI:CreateButton(frame, 'RGX:Font("Inter-Regular", 16, OUTLINE)', 260, 24)
    fontNamed:SetScript("OnClick", function()
        R:Font(sample, "Inter-Regular", 16, "OUTLINE")
        Log("Applied Inter-Regular 16 OUTLINE")
    end)
    add(fontNamed, 14)

    -- Design primitives
    local header = D:CreateSectionHeader(frame, "Design:CreateSectionHeader")
    header:SetWidth(340)
    add(header, 8)

    local divider = D:CreateDivider(frame)
    divider:SetWidth(340)
    add(divider, 10)

    local dBtn = D:CreateButton(frame, "Design:CreateButton", 180, 24,
        "Design Button", "Hover styling comes from RGXDesign theme tokens (primary color border/text).")
    add(dBtn, 14)

    add(UI:CreateLabel(frame, {
        text = "What to test: both font buttons visibly restyle the sample text; the section header shows the theme's primary color; the design button's border and label turn primary-colored on hover and show its tooltip.",
        size = "small",
        color = "muted",
        width = 340,
    }))
end

local function BuildSystemTab(frame)
    local UI = R:GetUI()
    local add = Place(frame)

    add(UI:CreateLabel(frame, {
        text = "Timers Visual Test (RGX:After / RGX:Every)",
        size = "large",
        color = "accent",
    }))

    local afterBtn = UI:CreateButton(frame, "Fire RGX:After(2s)", 200, 26)
    afterBtn:SetScript("OnClick", function()
        Log("After(2) armed...")
        R:After(2, function() Log("After(2) FIRED") end, "RGXVT_AFTER")
    end)
    add(afterBtn)

    local tickCount = 0
    local ticker
    local tickLabel = UI:CreateLabel(frame, { text = "Ticker: not running", size = "small", color = "normal" })
    local everyBtn = UI:CreateButton(frame, "Start/Stop RGX:Every(1s)", 200, 26)
    everyBtn:SetScript("OnClick", function()
        if ticker then
            R:CancelTimer(ticker)
            ticker = nil
            tickLabel:SetText("Ticker: stopped at " .. tickCount)
            Log("Every(1) cancelled at tick", tickCount)
            return
        end
        tickCount = 0
        ticker = R:Every(1, function()
            tickCount = tickCount + 1
            tickLabel:SetText("Ticker: " .. tickCount)
        end, "RGXVT_EVERY")
        tickLabel:SetText("Ticker: running")
        Log("Every(1) started")
    end)
    add(everyBtn, 8)
    add(tickLabel, 16)

    add(UI:CreateLabel(frame, {
        text = "What to test: After fires exactly once ~2s after the click; Every increments the counter each second; Stop must freeze the counter immediately (CancelTimer). Sound is intentionally not tested here -- BLU exercises the sound registry in production.",
        size = "small",
        color = "muted",
        width = 340,
    }))
end

-- Register every test tab onto RGX-Hello's own options panel (the one built by
-- data/core.lua's RGXAddon declaration). This runs at file-parse time -- before
-- RGX-Hello's ADDON_LOADED builds the panel -- so /rgxhello and /rgxvisual open
-- ONE shared window instead of two separate panels. The geometry hints size the
-- merged panel for the full suite without core.lua having to know it exists.
local TEST_TABS = {
    { text = "Colors",    content = BuildColorsTab },
    { text = "Controls",  content = BuildControlsTab },
    { text = "Dropdowns", content = BuildDropdownsTab },
    { text = "Media",     content = BuildMediaTab },
    { text = "Tooltip",   content = BuildTooltipTab },
    { text = "Auras",     content = BuildAurasTab },
    { text = "Minimap",   content = BuildMinimapTab },
    { text = "Design",    content = BuildDesignTab },
    { text = "System",    content = BuildSystemTab },
}
for _, t in ipairs(TEST_TABS) do
    R:AddOptionsTab("RGX-Hello", t.text, t.content, { width = 820, height = 720, maxPerRow = 5 })
end

local function OpenPanel()
    local a = R:GetAddon("RGX-Hello")
    if a and a.panel then
        a.panel:Open()
        if a.panel.SelectTabByName then a.panel:SelectTabByName("Colors") end
    else
        Log("RGX-Hello panel not ready -- is RGX-Hello's core.lua loaded?")
    end
end

R:OnReady(function()
    R:RegisterSlashCommand({ "rgxvisual", "rgxviz" }, function()
        OpenPanel()
    end, "RGX_VISUAL_TEST")

    R:RegisterSlashCommand({ "rgxcolor", "rgxcp" }, function()
        local CP = R:GetColorPicker()
        CP:Show(DB.primary, function(r, g, b)
            DB.primary = { r = r, g = g, b = b }
            Log("Direct color picker OK", string.format("%.2f %.2f %.2f", r, g, b))
        end)
    end, "RGX_COLOR_DIRECT")

    Log("loaded -- use /rgxvisual or /rgxcolor")
end)
