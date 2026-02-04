--[[
  Smart Region Manager for Reaper
  
  A tool to manage region channel settings (Mono/Stereo) and export audio files
  with automatic channel configuration based on region settings.
  
  Author: Unicon
  Version: 1.1.1
  Requires: Reaper 6.0+, ReaImGui extension
--]]

-- Get script directory using multiple methods for maximum compatibility
local function get_script_dir()
    -- Method 1: debug.getinfo (standard Lua way)
    local info = debug.getinfo(1, "S")
    if info and info.source then
        local source = info.source
        if source:sub(1, 1) == "@" then
            source = source:sub(2)
        end
        local dir = source:match("(.+[\\/])") or source:match("(.+/)")
        if dir then return dir end
    end
    
    -- Method 2: Use reaper.get_action_context() if available
    if reaper.get_action_context then
        local _, _, section, cmdID, _, _, _ = reaper.get_action_context()
        if section and cmdID then
            local _, filename = reaper.get_action_context()
            if filename then
                local dir = filename:match("(.+[\\/])") or filename:match("(.+/)")
                if dir then return dir end
            end
        end
    end
    
    return nil
end

-- Script directory (get it at top level)
local SCRIPT_DIR = get_script_dir()

-- Check for ReaImGui FIRST (before any other operations)
if not reaper.ImGui_GetVersion then
    reaper.ShowMessageBox(
        "This script requires ReaImGui extension.\n\n" ..
        "Please install it via ReaPack:\n" ..
        "Extensions > ReaPack > Browse packages > Search 'ReaImGui'",
        "Missing Dependency",
        0
    )
    return
end

-- Validate script directory
if not SCRIPT_DIR then
    reaper.ShowMessageBox(
        "Could not determine script location.\n\n" ..
        "Please try:\n" ..
        "1. Uninstall the script in ReaPack\n" ..
        "2. Restart REAPER\n" ..
        "3. Reinstall the script",
        "Script Error", 0)
    return
end

-- Normalize path for current OS
local function normalize_path(path)
    local sep = package.config:sub(1,1)
    if sep == "\\" then
        return path:gsub("/", "\\")
    else
        return path:gsub("\\", "/")
    end
end

-- Load a module with comprehensive error handling
local function load_module(name)
    local module_path = normalize_path(SCRIPT_DIR .. "modules/" .. name .. ".lua")
    
    -- Try to load the file
    local chunk, load_err = loadfile(module_path)
    if not chunk then
        reaper.ShowMessageBox(
            "Failed to load module: " .. name .. "\n\n" ..
            "Expected path:\n" .. module_path .. "\n\n" ..
            "Error: " .. tostring(load_err) .. "\n\n" ..
            "Please reinstall the script via ReaPack.",
            "Module Load Error", 0)
        return false
    end
    
    -- Try to execute the chunk
    local ok, exec_err = pcall(chunk)
    if not ok then
        reaper.ShowMessageBox(
            "Failed to execute module: " .. name .. "\n\n" ..
            "Error: " .. tostring(exec_err),
            "Module Error", 0)
        return false
    end
    
    return true
end

-- Load all required modules
local modules_ok = true
modules_ok = modules_ok and load_module("config")
modules_ok = modules_ok and load_module("region_manager")
modules_ok = modules_ok and load_module("render_engine")
modules_ok = modules_ok and load_module("gui")

if not modules_ok then
    return
end

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
