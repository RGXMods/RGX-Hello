# Changelog

## Current Release

### [v1.3.1](changelogs/1.3.1.md) - 2026-08-23

- Replaced three hard-coded startup lines with one metadata-derived
  `RGX:LoginMessage` line that obeys the framework's global login preference.
- Routed RGXVisual logging through the standard framework chat formatter and
  removed its independent startup message.
- Raised all six flavor TOCs to RGX-Hello 1.3.1 and RGX-Framework 2.7.4.

## Recent Releases

### [v1.3.0](changelogs/1.3.0.md) - 2026-08-15

- Moved the reference heartbeat from imperative `addon:Every` setup into
  `every.heartbeat`, exercising Framework v2.7.0's shipped named timer contract.
- Added explicit in-game verification that the timer reaches 3 ticks,
  self-cancels, and remains at 3.
- Raised the minimum Framework version to 2.7.0 across all six flavor TOCs.
- Expanded the Auras tab to verify accessible-only player/target scans,
  applied/updated/removed callbacks, and restricted-target suppression without
  `pcall`-wrapped field access, with exact before/after/recovery counter snapshots.

### [v1.2.1](changelogs/1.2.1.md) - 2026-08-13

- Replaced premature declarative `on`/`every` usage with shipped imperative
  APIs until the named timer vertical slice could be rebuilt cleanly.
- Preserved the three-tick heartbeat and corrected Framework/MCP distribution
  wording and Retail metadata.

## [v1.2.0](changelogs/1.2.0.md) - 2026-07-04

- **Five new test tabs** — the suite now covers every user-facing framework module: Tooltip (`Tip:Attach`/`Show`/`Hide`/`HookNative`), Auras (`IterateAuras` scan + live `OnApplied`/`OnRemoved` chat log with unsubscribe), Minimap (`MM:Create` with drag/tooltip/persistent angle, `Toggle`), Design (`RGX:Font` one-call styling + `RGXDesign` primitives), and System (`RGX:After`/`Every`/`CancelTimer`). Every API call verified against framework source before writing.
- Sound intentionally stays untested here: the sound module is a per-addon registry that BLU exercises in production.
- `media/README.md` no longer leaks into the packaged zip.

## [v1.1.1](changelogs/1.1.1.md) - 2026-07-03

- Added `.pkgmeta` — the packaged zip's `CHANGELOG.md` was being auto-generated from raw git commit messages; it now uses this curated changelog, and `docs/`/`README.md` no longer leak into the player zip.
- README rewritten around what RGX-Hello actually is now: the hello-world reference **and** RGX-Framework's in-game testing suite, wired into the framework's `rgx-mcp` MCP server in both directions (the generator can reproduce `core.lua`; the framework's end-to-end test validates and audits this repo).
- Requires RGX-Framework v2.4.1+ — the Volume slider's `%` suffix only renders from that version on (the framework's declarative mapper silently dropped `suffix` before then; found by the MCP test running against this repo).

## [v1.1.0](changelogs/1.1.0.md) - 2026-07-03

- Merged RGX-Framework's `tools/rgx-visual-test` dev tool into this repo as `data/visualtest.lua` — RGX-Hello is now both the reference addon and the visual QA harness (`/rgxvisual`, `/rgxcolor`), one install instead of two.
- Fixed four "What to test" hint labels that ran past their panel edge (upstream `UI:CreateLabel` word-wrap fix in RGX-Framework v2.4.0).

## [v1.0.0](changelogs/1.0.0.md) - 2026-07-03

- Initial release: RGX-Hello rewritten as a single-file addon built entirely on RGX-Framework's `RGXAddon` declarative front door.
- Demonstrates saved settings, a tabbed options panel, a slash command, a minimap button, and event handling in one call.
- Release automation wired up (CurseForge/Wago/WoWInterface via `BigWigsMods/packager`, Discord notifications).
