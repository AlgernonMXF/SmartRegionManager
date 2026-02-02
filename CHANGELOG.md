# Changelog

All notable changes to Smart Region Manager will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [1.0.4] - 2026-02-02

### Added
- Output directory now persists between sessions
- Automatically restores last used output path when reopening the script

## [1.0.0] - 2026-02-02

### Added
- Initial release
- Region list display and management
- Per-region Mono/Stereo channel settings
- Batch operations (select all, batch set channel mode)
- One-click render with automatic channel configuration
- Optional naming suffix (`_Mono`, `_Stereo`)
- Settings persistence in project file
- Dark/Light theme support (auto-detects REAPER theme)
- Browse button compatibility (no longer requires JS_ReaScriptAPI extension)
