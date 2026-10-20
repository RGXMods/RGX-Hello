# RGX-Hello

The [RGX-Framework](https://github.com/RGXMods/RGX-Framework) reference addon **and** its in-game testing suite, in one install. It exists for two audiences at once:

> The TOCs own RGX-Hello's version and minimum Framework version. The source reference tracks the Framework stable release for strict release conformance; source metadata is not a new release announcement.

- **Addon developers** — `data/core.lua` is the canonical "hello world": the smallest complete RGX addon, written in the declarative `RGXAddon` style you should copy when starting your own.
- **Framework development** — `data/visualtest.lua` is the visual QA harness used to test RGX-Framework's features in-game before releases. As the framework grows, this suite grows with it; the goal is coverage of **every** framework feature.

## Source Contract Conformance

RGX-Framework owns the runtime Lua API and the reusable declarative contract, generation, validation, audit, MCP, and editor/authoring infrastructure. Its `tools/rgx-mcp/` transport is a private source-tree contract-conformance fixture, not a separately published product or part of the player addon. Developer tooling is optional: RGX-Hello and the framework runtime do not depend on MCP, Node.js, or an editor. A future RGX Studio application is a downstream consumer of that foundation, not the owner of runtime semantics or a shipped prerequisite. RGX-Hello remains wired into the fixture in both directions:

- `rgx_generate_addon` can reproduce `data/core.lua`'s structure from a short spec — the hand-written file and the generator's output are kept convergent.
- The framework's end-to-end test (`tools/rgx-mcp/test/test-rgx-hello.mjs`) runs the real MCP server against **this repo**: it validates `core.lua`'s opts table against the schema and audits every Lua file here for unsafe patterns. If this repo drifts from the contract, the framework's own test fails.

That loop has already paid off: its first run caught a framework bug (the declarative slider's `suffix` was silently dropped — this addon's own Volume slider shipped without its "%" until RGX-Framework v2.4.1 fixed it).

## The Hello World (`data/core.lua`)

```lua
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
```

That single call gives you saved settings with automatic persistence, a tabbed options panel with declarative pages/card grids and db-bound controls, a named repeating timer, a slash command, a minimap button, branded chat output, and framework-scoped startup logic. No event frames, no `C_Timer`, no `SLASH_X` globals, no SavedVariables boilerplate.

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
| Auras | `RGXAuras` — accessible-only player/target scans, `WatchUnit` + `OnApplied`/`OnUpdated`/`OnRemoved` live log, phase counter snapshots, restricted-target suppression, unsubscribe |
| Minimap | `RGXMinimap` — `MM:Create` (icon, tooltip, drag, persistent angle), `Toggle`/`IsShown` |
| Design | `RGX:Font` one-call styling, `RGXDesign` `CreateButton`/`CreateSectionHeader`/`CreateDivider`, theme tokens |
| System | declarative `every.heartbeat` self-cancellation, `RGX:After`, `RGX:Every`, `RGX:CancelTimer` |

Sound is intentionally untested here — the sound module is a per-addon registry that [BLU](https://github.com/RGXMods/BLU) exercises in production, which is a more honest test than a synthetic registration. Standing pattern: when a framework module ships or changes, its test tab lands here in the same cycle.

## Installation

1. Install [RGX-Framework](https://github.com/RGXMods/RGX-Framework) for the same client flavor, at or above the `X-RGX-Framework-MinVersion` declared in the TOC.
2. Copy the `RGX-Hello` addon folder to that client's `Interface\AddOns\` directory (for example, `World of Warcraft\_retail_\Interface\AddOns\` for Retail). The TOC and `data/` folder must be directly inside `AddOns\RGX-Hello\`, not nested inside an extra download folder.
3. `/reload` or restart, and enable both addons. No developer tooling is required to run them.

Current source TOC coverage (metadata targets, not a claim that every client was tested in-game):

| Client target | TOC | Interface |
|---------------|-----|-----------|
| Retail / Forever beta / Classic Era | `RGX-Hello.toc` | `120100`, `16001`, `11509` |
| Classic Era | `RGX-Hello_Vanilla.toc` | `11509` |
| Burning Crusade Classic | `RGX-Hello_TBC.toc` | `20506` |
| Wrath / Titan target | `RGX-Hello_Wrath.toc` | `38002` |
| Cataclysm (historical) | `RGX-Hello_Cata.toc` | `40402` |
| Mists Classic | `RGX-Hello_Mists.toc` | `50504` |

Keep the supplied TOCs together; the game chooses the applicable TOC. All six directly load `data/core.lua`, then `data/visualtest.lua`, and declare `RGXHelloDB` and `RGXVisualTestDB` as SavedVariables. The XML file is not in their load lists.

## Using This As a Template

1. Copy the repo; rename the folder and each TOC you keep to your addon's name, preserving flavor suffixes. Keep only the client targets your addon actually supports.
2. Edit the TOC header (`Title`, `Notes`, `Author`, `SavedVariables`), keeping `RequiredDeps: RGX-Framework` and an accurate `X-RGX-Framework-MinVersion`. Match `SavedVariables` to the declaration's `dbName`.
3. Edit the `RGXAddon "..." { }` call in `data/core.lua` — `db` for settings, `options` for the panel, `every` for repeating work, and `onInit` for event/setup code while declarative `on` remains Tier 4.
4. Delete `data/visualtest.lua`, its entry from every retained TOC, and `RGXVisualTestDB` from those TOCs — the harness tests the framework, not your addon. `RGX-Hello.xml` is an unused alternate loader; remove it, or rename/update it only if you deliberately switch your TOCs to XML loading. Do not load the Lua files twice.
5. Set `minimap` to your own texture path, or drop the key. The reference declaration currently uses the framework's `media/logo.tga`; the local `media/icon.tga` is not its configured icon.

For the full declarative surface see the framework's [DECLARATIVE-API.md](https://github.com/RGXMods/RGX-Framework/blob/main/docs/DECLARATIVE-API.md), [SUPER-SIMPLE.md](https://github.com/RGXMods/RGX-Framework/blob/main/docs/SUPER-SIMPLE.md), and [API.md](https://github.com/RGXMods/RGX-Framework/blob/main/docs/API.md).

## Project Structure

```
RGX-Hello/
├── RGX-Hello.toc      # Base metadata; directly loads core.lua then visualtest.lua
├── RGX-Hello_*.toc    # Five flavor TOCs; same direct Lua load order
├── RGX-Hello.xml      # Alternate loader, not referenced by the current TOCs
├── data/
│   ├── core.lua       # The hello-world reference addon
│   └── visualtest.lua # The framework testing suite (/rgxvisual)
├── media/
│   └── icon.tga        # Local icon asset; the declaration uses the framework logo
└── docs/
    └── CHANGES.md      # Curated changelog (packaged as CHANGELOG.md)
```

## License

MIT License — see [LICENSE](LICENSE) for details.

## Contributing

Template forks welcome. If you find issues with the RGX-Framework integration patterns, please open an issue.
