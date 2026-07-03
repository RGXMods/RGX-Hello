# RGX-Hello

Two things in one install:

1. **A reference/template addon** ([RGX-Framework](https://github.com/DonnieDice/RGX-Framework)'s smallest complete addon) — `data/core.lua`, built entirely from the `RGXAddon` declarative front door. No event frames, no `C_Timer`, no `SLASH_X` globals, no SavedVariables boilerplate — RGX-Framework handles all of it.
2. **RGX-Framework's visual QA harness** — `data/visualtest.lua`, a hand-built options panel exercising every control type (color picker, toggles, sliders, nested dropdowns, font/texture dropdowns) via the framework's manual API (`RGX:GetUI()`, `RGX:GetColorPicker()`, etc). Useful both as a dev tool for testing RGX-Framework itself, and as a second reference showing the "go beyond the declarative surface" pattern.

## What You Get

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

That single call gives you:

- saved settings with automatic persistence (`db`)
- a tabbed options panel with db-bound controls that save and restore their visual state correctly (`options`)
- a slash command whose default handler opens that panel (`slash`)
- a minimap button (`minimap`)
- branded chat output (`welcome`, `self:Print`)
- scoped event registration, routed through the framework's taint-safe paths (`onInit`)

## Installation

### Requirements

- World of Warcraft (Retail) — version matching `## Interface:` in `RGX-Hello.toc`
- [RGX-Framework](https://github.com/DonnieDice/RGX-Framework) must be installed

### Installing This Addon

1. Download or clone this repository
2. Copy the `RGX-Hello` folder to your WoW AddOns directory:
   ```
   World of Warcraft\_retail_\Interface\AddOns\
   ```
3. Restart WoW or run `/reload`
4. Enable both "RGX-Framework" and "RGX-Hello" in the AddOns list

## Usage

| Command | Opens |
|---------|-------|
| `/rgxhello` | RGX-Hello's own options panel (from `data/core.lua`) |
| `/rgxvisual` or `/rgxviz` | The full visual QA harness (Colors, Controls, Dropdowns, Media tabs) |
| `/rgxcolor` or `/rgxcp` | The color picker directly |

On login, the addon prints a greeting to chat.

## Using This As a Template

1. Rename the folder, `RGX-Hello.toc`, and `RGX-Hello.xml` to your addon's name.
2. Edit the TOC header (`Title`, `Notes`, `Author`, `SavedVariables`).
3. Edit the `RGXAddon "..." { }` call in `data/core.lua`:
   - `db` — your saved settings and their defaults
   - `options` — your options panel tabs and controls
   - `onInit` — your addon's actual behavior (events, timers, UI)
4. Replace `media/icon.tga` with your own minimap icon, or drop the `minimap` key entirely if you don't want one.

See [SUPER-SIMPLE.md](https://github.com/DonnieDice/RGX-Framework/blob/main/docs/SUPER-SIMPLE.md) and [API.md](https://github.com/DonnieDice/RGX-Framework/blob/main/docs/API.md) in RGX-Framework for the full declarative surface (more control types, `RGX:Font`, dropdowns, tooltips, etc).

## Project Structure

```
RGX-Hello/
├── RGX-Hello.toc      # Addon metadata
├── RGX-Hello.xml      # Loads data/core.lua and data/visualtest.lua
├── data/
│   ├── core.lua       # The reference addon (template starting point)
│   └── visualtest.lua # The visual QA harness (/rgxvisual, /rgxcolor)
└── media/
    └── icon.tga        # Minimap icon
```

## License

MIT License — see [LICENSE](LICENSE) for details.

## Contributing

This is a template repository. Feel free to fork and customize for your own addons! If you find issues with the RGX-Framework integration patterns, please open an issue.
