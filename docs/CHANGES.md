# Changelog

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
