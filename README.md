# Hello RGX

A **WoW addon template** demonstrating best practices for building addons with [RGX-Framework](https://github.com/yourusername/RGX-Framework).

This is a minimal, well-documented example that you can use as a starting point for your own RGX-native addons.

## Features

- **Clean Architecture**: Separates core, events, commands, and config into modular files
- **RGX-Framework Patterns**: Demonstrates proper use of:
  - `RGX:RegisterEvent()` for event handling
  - `RGX:After()` and `RGX:Every()` for timers
  - `RGX:RegisterSlashCommand()` for commands
  - `RGX:CopyTable()` for settings management
- **Fail-Fast Dependency Checking**: Errors clearly if RGX-Framework is missing
- **Comprehensive Examples**: Timer demos, custom messages, slash commands
- **Template-Ready**: Clear comments showing where to add your own code

## Installation

### Requirements

- World of Warcraft (Retail) - version matching `## Interface:` in `.toc`
- [RGX-Framework](https://github.com/yourusername/RGX-Framework) must be installed

### Installing This Addon

1. Download or clone this repository
2. Copy the `HelloRGX` folder to your WoW AddOns directory:
   ```
   World of Warcraft\_retail_\Interface\AddOns\
   ```
3. Restart WoW or run `/reload`
4. Enable "Hello RGX" in the AddOns list

## Usage

### Slash Commands

Once in-game, type any of these commands:

| Command | Description |
|---------|-------------|
| `/hellorgx` or `/hrgx` | Show help |
| `/hrgx greet` | Show greeting message |
| `/hrgx toggle` | Enable/disable addon |
| `/hrgx timer [start\|stop]` | Control demo timer |
| `/hrgx msg <text>` | Set custom greeting |
| `/hrgx debug` | Toggle debug output |
| `/hrgx status` | Show current settings |
| `/hrgx reset` | Reset to defaults |
| `/hrgx demo` | Run feature demonstration |

### What You'll See

On first load, the addon will:
1. Print a greeting message to chat
2. Start a demo timer (if enabled)
3. Register slash commands

## Using This Template

### 1. Rename the Addon

Find and replace all occurrences of:
- `HelloRGX` → `YourAddonName`
- `HELLO_` → `YOURPREFIX_` (for event IDs)
- `hellorgx` → `yourcommand`

### 2. Update Metadata

Edit `HelloRGX.toc`:
```toc
## Title: Your Addon Name
## Notes: Description of what your addon does
## Author: Your Name
## SavedVariables: YourAddonDB
```

### 3. Modify Core Logic

Open `data/core.lua` and customize:
- `DEFAULTS` table for your settings
- Public API methods
- Utility functions

### 4. Add Event Handlers

In `data/events.lua`:
- Add your event handlers as methods on the addon table
- Register them at the bottom using `RGX:RegisterEvent()`

### 5. Create Slash Commands

In `data/commands.lua`:
- Add command handlers
- Register aliases with `RGX:RegisterSlashCommand()`

### 6. Build Your UI

In `data/config.lua`:
- Add settings panel code
- Uncomment minimap button example if needed

## Project Structure

```
HelloRGX/
├── HelloRGX.toc          # Addon metadata (rename me!)
├── HelloRGX.xml          # Module loader
├── data/
│   ├── core.lua          # Main addon table, settings
│   ├── events.lua        # Event handlers
│   ├── commands.lua      # Slash commands
│   └── config.lua        # UI configuration
├── media/
│   ├── icon.tga          # Addon icon (replace me!)
│   └── README.md         # Asset guidelines
└── docs/
    └── TEMPLATE.md       # Detailed template guide
```

## RGX-Framework Quick Reference

### Event Registration
```lua
RGX:RegisterEvent("EVENT_NAME", callback, "UNIQUE_ID")
RGX:UnregisterEvent("EVENT_NAME", "UNIQUE_ID")
```

### Timers
```lua
-- One-shot timer
RGX:After(seconds, callback)

-- Repeating timer
RGX:Every(seconds, callback)

-- Cancel timer
RGX:CancelTimer(timerHandle)
```

### Slash Commands
```lua
RGX:RegisterSlashCommand("command", callback, "ID")
-- Supports multiple aliases: {"cmd1", "cmd2"}
```

### Custom Messages
```lua
-- Send
RGX:SendMessage("MY_EVENT", arg1, arg2)

-- Receive
RGX:RegisterMessage("MY_EVENT", callback, "ID")
```

## API Documentation

See [RGX-Framework](https://github.com/yourusername/RGX-Framework) for full API documentation.

## License

MIT License - See [LICENSE](LICENSE) for details.

## Contributing

This is a template repository. Feel free to fork and customize for your own addons!

If you find issues with the RGX-Framework integration patterns, please open an issue.
