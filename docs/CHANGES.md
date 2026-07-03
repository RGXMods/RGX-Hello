# Changelog

## [v1.1.0](changelogs/1.1.0.md) - 2026-07-03

- Merged RGX-Framework's `tools/rgx-visual-test` dev tool into this repo as `data/visualtest.lua` — RGX-Hello is now both the reference addon and the visual QA harness (`/rgxvisual`, `/rgxcolor`), one install instead of two.
- Fixed four "What to test" hint labels that ran past their panel edge (upstream `UI:CreateLabel` word-wrap fix in RGX-Framework v2.4.0).

## [v1.0.0](changelogs/1.0.0.md) - 2026-07-03

- Initial release: RGX-Hello rewritten as a single-file addon built entirely on RGX-Framework's `RGXAddon` declarative front door.
- Demonstrates saved settings, a tabbed options panel, a slash command, a minimap button, and event handling in one call.
- Release automation wired up (CurseForge/Wago/WoWInterface via `BigWigsMods/packager`, Discord notifications).
