# RGX-Hello

The [RGX-Framework](https://github.com/DonnieDice/RGX-Framework) reference addon **and** its in-game testing suite, in one install. It exists for two audiences at once:

- **Addon developers** — `data/core.lua` is the canonical "hello world": the smallest complete RGX addon, written in the declarative `RGXAddon` style you should copy when starting your own.
- **Framework development** — `data/visualtest.lua` is the visual QA harness used to test RGX-Framework's features in-game before releases. As the framework grows, this suite grows with it; the goal is coverage of **every** framework feature.

## Built with rgx-mcp

RGX-Framework ships an MCP server (`tools/rgx-mcp/`, included in the framework's packaged zip) that validates, audits, and generates declarative RGX addons against the framework's frozen Simplicity Contract. RGX-Hello is wired into it in both directions:

- `rgx_generate_addon` can reproduce `data/core.lua`'s structure from a short spec — the hand-written file and the generator's output are kept convergent.
- The framework's end-to-end test (`tools/rgx-mcp/test/test-rgx-hello.mjs`) runs the real MCP server against **this repo**: it validates `core.lua`'s opts table against the schema and audits every Lua file here for unsafe patterns. If this repo drifts from the contract, the framework's own test fails.

That loop has already paid off: its first run caught a framework bug (the declarative slider's `suffix` was silently dropped — this addon's own Volume slider shipped without its "%" until RGX-Framework v2.4.1 fixed it).

## The Hello World (`data/core.lua`)

```lua
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
```

That single call gives you saved settings with automatic persistence, a tabbed options panel with db-bound controls, a slash command, a minimap button, branded chat output, and taint-safe event registration. No event frames, no `C_Timer`, no `SLASH_X` globals, no SavedVariables boilerplate.

## The Testing Suite (`data/visualtest.lua`)

A hand-built options panel exercising the framework's manual API (`RGX:GetUI()`, `RGX:GetColorPicker()`, `RGX:GetDropdowns()`, `RGX:GetFonts()`, `RGX:GetTextures()`) — this is also the reference for going *beyond* the declarative surface.

| Command | Opens |
|---------|-------|
| `/rgxhello` | RGX-Hello's own options panel (the hello-world addon) |
| `/rgxvisual` or `/rgxviz` | The full test suite (tabs below) |
| `/rgxcolor` or `/rgxcp` | The color picker directly |

Current coverage:

| Tab | Framework features exercised |
|-----|------------------------------|
| Colors | `RGXColorPicker` (SV box, hue bar, HEX/RGB inputs, presets, OK/Cancel), `UI:CreateColorPicker` swatches + Reset |
| Controls | `UI:CreateToggle`, `UI:CreateSlider`, `UI:CreateVolumeSlider`, reset buttons, label word-wrap |
| Dropdowns | `RGXDropdowns:CreateNestedDropdown` (groups, separators, checked state) |
| Media | `RGXFonts` font dropdown, `RGXTextures` statusbar textures |
| Tooltip | `RGXTooltip` — `Tip:Attach` builder, manual `Show`/`Hide`, `HookNative("item")` injection |
| Auras | `RGXAuras` — `IterateAuras` scan, `WatchUnit` + `OnApplied`/`OnRemoved` live log with unsubscribe |
| Minimap | `RGXMinimap` — `MM:Create` (icon, tooltip, drag, persistent angle), `Toggle`/`IsShown` |
| Design | `RGX:Font` one-call styling, `RGXDesign` `CreateButton`/`CreateSectionHeader`/`CreateDivider`, theme tokens |
| System | `RGX:After`, `RGX:Every`, `RGX:CancelTimer` |

Sound is intentionally untested here — the sound module is a per-addon registry that [BLU](https://github.com/DonnieDice/BLU) exercises in production, which is a more honest test than a synthetic registration. Standing pattern: when a framework module ships or changes, its test tab lands here in the same cycle.

## Installation

1. Install [RGX-Framework](https://github.com/DonnieDice/RGX-Framework) (required dependency, v2.4.1+).
2. Copy the `RGX-Hello` folder to `World of Warcraft\_retail_\Interface\AddOns\`.
3. `/reload` or restart, and enable both addons.

## Using This As a Template

1. Copy the repo; rename the folder, `RGX-Hello.toc`, and `RGX-Hello.xml` to your addon's name.
2. Edit the TOC header (`Title`, `Notes`, `Author`, `SavedVariables`).
3. Edit the `RGXAddon "..." { }` call in `data/core.lua` — `db` for settings, `options` for the panel, `onInit` for behavior.
4. Delete `data/visualtest.lua` (and its TOC/XML lines) — it tests the framework, not your addon.
5. Replace `media/icon.tga`, or drop the `minimap` key.

For the full declarative surface see the framework's [DECLARATIVE-API.md](https://github.com/DonnieDice/RGX-Framework/blob/main/docs/DECLARATIVE-API.md), [SUPER-SIMPLE.md](https://github.com/DonnieDice/RGX-Framework/blob/main/docs/SUPER-SIMPLE.md), and [API.md](https://github.com/DonnieDice/RGX-Framework/blob/main/docs/API.md).

## Project Structure

```
RGX-Hello/
├── RGX-Hello.toc      # Addon metadata
├── RGX-Hello.xml      # Loads both files below
├── data/
│   ├── core.lua       # The hello-world reference addon
│   └── visualtest.lua # The framework testing suite (/rgxvisual)
├── media/
│   └── icon.tga        # Minimap icon
└── docs/
    └── CHANGES.md      # Curated changelog (packaged as CHANGELOG.md)
```

## License

MIT License — see [LICENSE](LICENSE) for details.

## Contributing

Template forks welcome. If you find issues with the RGX-Framework integration patterns, please open an issue.
