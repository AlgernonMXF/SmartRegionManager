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

-- Script path for loading modules
local script_path = debug.getinfo(1, "S").source:match("@(.+[\\/])")

-- Load modules
dofile(script_path .. "modules/config.lua")
dofile(script_path .. "modules/region_manager.lua")
dofile(script_path .. "modules/render_engine.lua")
dofile(script_path .. "modules/gui.lua")

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
