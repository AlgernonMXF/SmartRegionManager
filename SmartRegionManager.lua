--[[
  Smart Region Manager for Reaper
  
  A tool to manage region channel settings (Mono/Stereo) and export audio files
  with automatic channel configuration based on region settings.
  
  Author: Unicon
  Version: 1.0.0
  Requires: Reaper 6.0+, ReaImGui extension
  
  Changelog v1.0.0 - Initial Release:
  - Region list display and management
  - Per-region Mono/Stereo channel settings
  - Batch operations (select all, batch set channel mode)
  - One-click render with automatic channel configuration
  - Optional naming suffix (_Mono, _Stereo)
  - Settings persistence in project file
  - Dark/Light theme support (auto-detects REAPER theme)
  - Browse button compatibility (no longer requires JS_ReaScriptAPI extension)
--]]

-- Check for ReaImGui
local has_imgui = reaper.ImGui_GetVersion ~= nil
if not has_imgui then
    reaper.ShowMessageBox(
        "This script requires ReaImGui extension.\n\n" ..
        "Please install it via ReaPack:\n" ..
        "Extensions > ReaPack > Browse packages > Search 'ReaImGui'",
        "Missing Dependency",
        0
    )
    return
end

-- Get script path with multiple fallback methods
local function get_script_path()
    local info = debug.getinfo(1, "S")
    if not info or not info.source then return nil end
    
    local source = info.source
    -- Remove @ prefix if present
    if source:sub(1, 1) == "@" then
        source = source:sub(2)
    end
    
    -- Extract directory path
    -- Try Windows path first, then Unix
    local path = source:match("(.+[\\/])") or source:match("(.+/)")
    return path
end

local script_path = get_script_path()
if not script_path then
    reaper.ShowMessageBox(
        "Could not determine script location.\n\n" ..
        "Please reinstall the script via ReaPack.",
        "Script Error", 0)
    return
end

-- Normalize path separator for current OS
local sep = package.config:sub(1,1) -- Gets OS path separator
local function normalize_path(path)
    if sep == "\\" then
        return path:gsub("/", "\\")
    else
        return path:gsub("\\", "/")
    end
end

-- Load modules with error handling
local function load_module(name)
    local path = normalize_path(script_path .. "modules/" .. name .. ".lua")
    local chunk, err = loadfile(path)
    if not chunk then
        reaper.ShowMessageBox(
            "Failed to load module: " .. name .. "\n\n" ..
            "Path: " .. path .. "\n\n" ..
            "Error: " .. (err or "unknown"),
            "Module Load Error", 0)
        return false
    end
    chunk()
    return true
end

-- Load all required modules
if not load_module("config") then return end
if not load_module("region_manager") then return end
if not load_module("render_engine") then return end
if not load_module("gui") then return end

-- Initialize
local ctx = reaper.ImGui_CreateContext("Smart Region Manager")

-- Main variables
local is_open = true
local window_flags = reaper.ImGui_WindowFlags_None()

-- Initialize modules
Config.init()
RegionManager.init()
RenderEngine.init()

-- Main loop
local function main()
    if not is_open then
        -- Cleanup (check if function exists - newer ReaImGui versions use garbage collection)
        if ctx and reaper.ImGui_DestroyContext then
            reaper.ImGui_DestroyContext(ctx)
        end
        ctx = nil
        return
    end
    
    -- Set initial window size
    reaper.ImGui_SetNextWindowSize(ctx, 800, 500, reaper.ImGui_Cond_FirstUseEver())
    
    -- Apply theme BEFORE window begins (so title bar uses correct colors)
    GUI.apply_theme_before_window(ctx)
    
    -- Main window
    local visible, open = reaper.ImGui_Begin(ctx, "Smart Region Manager", true, window_flags)
    is_open = open
    
    if visible then
        GUI.draw(ctx)
        reaper.ImGui_End(ctx)
    end
    
    -- Pop theme colors after window ends
    GUI.pop_theme_after_window(ctx)
    
    -- Continue loop
    reaper.defer(main)
end

-- Start the script
main()
