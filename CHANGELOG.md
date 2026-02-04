# Changelog

All notable changes to Smart Region Manager will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [1.1.2] - 2026-02-04

### Fixed
- Fixed rename input immediately cancelling on double-click

### Changed
- Rename editing now requires Enter to confirm or Escape to cancel

## [1.1.1] - 2026-02-04

### Added
- Double-click on region name to rename directly in the list
  - Press Enter to confirm, Escape to cancel
  - Click elsewhere to cancel
  - Supports undo/redo
- Version number display in toolbar for easy update verification

### Fixed
- Fixed double-click detection not working (changed from Text to Selectable widget)

## [1.0.5] - 2026-02-02

### Fixed
- Fixed "Open Folder" button not working on Windows
  - Root cause: UTF-8 BOM character in saved paths from PowerShell folder dialog
  - Added BOM stripping in path cleaning functions

### Changed
- Refactored theme color system for cleaner code structure
- Consolidated path handling utilities into reusable functions
- Simplified folder browser dialog handling

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
