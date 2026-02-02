--[[
  Render Engine Module
  
  Handles the actual rendering of regions with appropriate channel settings.
  Supports batch rendering with per-region channel mode configuration.
  
  Path Handling Notes:
  - REAPER's RENDER_FILE API can behave unexpectedly with path concatenation
  - This module implements robust path sanitization to prevent issues like "D:\C:\Users\..."
  - All paths are normalized to absolute form before being passed to REAPER
--]]

RenderEngine = {}

-- Render status
RenderEngine.STATUS = {
    IDLE = "idle",
    RENDERING = "rendering",
    COMPLETED = "completed",
    ERROR = "error"
}

-- Runtime state
local current_status = RenderEngine.STATUS.IDLE
local render_queue = {}
local current_render_index = 0
local last_error = ""
local render_progress = 0

-- Detect if running on Windows
local function is_windows()
    local os_name = reaper.GetOS() or ""
    return os_name:find("Win") ~= nil
end

-- Initialize
function RenderEngine.init()
    current_status = RenderEngine.STATUS.IDLE
    render_queue = {}
    current_render_index = 0
    last_error = ""
    render_progress = 0
end

-- Get current status
function RenderEngine.get_status()
    return current_status
end

-- Get last error message
function RenderEngine.get_last_error()
    return last_error
end

-- Get render progress (0-100)
function RenderEngine.get_progress()
    return render_progress
end

--------------------------------------------------------------------------------
-- Path Utility Functions (Robust path handling for cross-platform compatibility)
--------------------------------------------------------------------------------

-- Normalize path separators for the current OS
-- @param path string: Input path
-- @return string: Normalized path with correct separators
function RenderEngine._normalize_separators(path)
    if not path or path == "" then return "" end
    
    if is_windows() then
        -- Windows: use backslashes
        return path:gsub("/", "\\")
    else
        -- Unix/macOS: use forward slashes
        return path:gsub("\\", "/")
    end
end

-- Check if a path is absolute
-- @param path string: Input path
-- @return boolean: True if path is absolute
function RenderEngine._is_absolute_path(path)
    if not path or path == "" then return false end
    
    if is_windows() then
        -- Windows absolute path: starts with drive letter (C:\) or UNC (\\)
        return path:match("^[A-Za-z]:\\") ~= nil or path:match("^\\\\") ~= nil
    else
        -- Unix absolute path: starts with /
        return path:sub(1, 1) == "/"
    end
end

-- Extract the last valid absolute path from a potentially corrupted path
-- Handles cases like "D:\C:\Users\..." by extracting "C:\Users\..."
-- @param path string: Input path (possibly corrupted)
-- @return string: Clean absolute path
function RenderEngine._extract_last_absolute_path(path)
    if not path or path == "" then return "" end
    
    if is_windows() then
        -- Find all drive letter positions (e.g., "C:\", "D:\")
        local last_drive_pos = nil
        local search_start = 1
        
        while true do
            -- Look for pattern like "X:\" where X is a letter
            local match_start, match_end = path:find("[A-Za-z]:\\", search_start)
            if match_start then
                last_drive_pos = match_start
                search_start = match_end + 1
            else
                break
            end
        end
        
        -- If we found multiple drive letters, extract from the last one
        if last_drive_pos and last_drive_pos > 1 then
            return path:sub(last_drive_pos)
        end
    end
    
    return path
end

-- Sanitize and normalize an output directory path
-- @param dir string: Input directory path
-- @return string: Clean, absolute directory path (without trailing separator)
function RenderEngine._sanitize_directory(dir)
    if not dir or dir == "" then return "" end
    
    -- Normalize separators first
    dir = RenderEngine._normalize_separators(dir)
    
    -- Extract last valid absolute path (fix "D:\C:\..." issues)
    dir = RenderEngine._extract_last_absolute_path(dir)
    
    -- Remove trailing separators (REAPER may add its own)
    if is_windows() then
        dir = dir:gsub("\\+$", "")
    else
        dir = dir:gsub("/+$", "")
    end
    
    -- Remove any trailing/leading whitespace
    dir = dir:match("^%s*(.-)%s*$") or ""
    
    return dir
end

-- Build a clean filename (without path) for a region
-- @param region table: Region data with name and channel_mode
-- @return string: Clean filename with extension
function RenderEngine._build_clean_filename(region)
    local base_name = region.name or "unnamed"
    
    -- Remove invalid filename characters (more comprehensive list)
    -- Windows forbidden: < > : " / \ | ? *
    -- Also remove control characters and leading/trailing spaces/dots
    base_name = base_name:gsub('[<>:"/\\|?*]', "_")
    base_name = base_name:gsub("[%c]", "")  -- Remove control characters
    base_name = base_name:match("^[%.%s]*(.-)[%.%s]*$") or base_name  -- Trim dots and spaces
    
    -- Ensure filename is not empty after cleaning
    if base_name == "" then
        base_name = "region_" .. (region.id or "0")
    end
    
    -- Add channel suffix if enabled
    local suffix = ""
    if Config and Config.get_channel_suffix then
        suffix = Config.get_channel_suffix(region.channel_mode) or ""
    end
    
    -- Get extension
    local format = "wav"
    if Config and Config.get then
        format = string.lower(Config.get("output_format") or "wav")
    end
    local extension = "." .. format
    
    return base_name .. suffix .. extension
end

-- Build output filename for a region (legacy function for compatibility)
function RenderEngine.build_filename(region, output_dir)
    local filename = RenderEngine._build_clean_filename(region)
    
    if output_dir and output_dir ~= "" then
        local clean_dir = RenderEngine._sanitize_directory(output_dir)
        if clean_dir ~= "" then
            local sep = is_windows() and "\\" or "/"
            return clean_dir .. sep .. filename
        end
    end
    
    return filename
end

--------------------------------------------------------------------------------
-- Render Settings Management
--------------------------------------------------------------------------------

-- Get channel count for mode
function RenderEngine._get_channel_count(mode)
    if mode == "Mono" then
        return 1
    else
        return 2  -- Stereo
    end
end

-- Save current render settings (comprehensive)
function RenderEngine._save_render_settings()
    local settings = {}
    
    -- Save all relevant render settings
    settings.bounds = reaper.GetSetProjectInfo(0, "RENDER_BOUNDSFLAG", 0, false)
    settings.channels = reaper.GetSetProjectInfo(0, "RENDER_CHANNELS", 0, false)
    settings.startpos = reaper.GetSetProjectInfo(0, "RENDER_STARTPOS", 0, false)
    settings.endpos = reaper.GetSetProjectInfo(0, "RENDER_ENDPOS", 0, false)
    settings.srate = reaper.GetSetProjectInfo(0, "RENDER_SRATE", 0, false)
    
    local retval, render_file = reaper.GetSetProjectInfo_String(0, "RENDER_FILE", "", false)
    settings.render_file = render_file or ""
    
    local retval2, render_pattern = reaper.GetSetProjectInfo_String(0, "RENDER_PATTERN", "", false)
    settings.render_pattern = render_pattern or ""
    
    return settings
end

-- Restore render settings
function RenderEngine._restore_render_settings(settings)
    if not settings then return end
    
    reaper.GetSetProjectInfo(0, "RENDER_BOUNDSFLAG", settings.bounds or 0, true)
    reaper.GetSetProjectInfo(0, "RENDER_CHANNELS", settings.channels or 2, true)
    reaper.GetSetProjectInfo(0, "RENDER_STARTPOS", settings.startpos or 0, true)
    reaper.GetSetProjectInfo(0, "RENDER_ENDPOS", settings.endpos or 0, true)
    
    if settings.srate and settings.srate > 0 then
        reaper.GetSetProjectInfo(0, "RENDER_SRATE", settings.srate, true)
    end
    
    reaper.GetSetProjectInfo_String(0, "RENDER_FILE", settings.render_file or "", true)
    reaper.GetSetProjectInfo_String(0, "RENDER_PATTERN", settings.render_pattern or "", true)
end

-- Clear render path settings to prevent REAPER from concatenating paths
-- This is the KEY fix for the "D:\C:\Users\..." issue
function RenderEngine._clear_render_paths()
    -- Clear both RENDER_FILE and RENDER_PATTERN to reset REAPER's internal state
    -- This prevents REAPER from prepending the old path to the new one
    reaper.GetSetProjectInfo_String(0, "RENDER_FILE", "", true)
    reaper.GetSetProjectInfo_String(0, "RENDER_PATTERN", "", true)
end

--------------------------------------------------------------------------------
-- Core Render Function
--------------------------------------------------------------------------------

-- Render a single region
-- @param region table: Region data (id, name, start_pos, end_pos, channel_mode)
-- @param output_dir string: Output directory path
-- @return boolean, string: Success status and error message
function RenderEngine.render_region(region, output_dir)
    -- Validate inputs
    if not region then
        return false, "Invalid region data"
    end
    
    if not region.start_pos or not region.end_pos then
        return false, "Region missing position data"
    end
    
    -- Save current settings before making changes
    local saved_settings = RenderEngine._save_render_settings()
    
    local success = true
    local error_msg = ""
    
    -- Begin undo block
    reaper.Undo_BeginBlock()
    
    -- Prepare output directory (sanitize and validate)
    local clean_dir = RenderEngine._sanitize_directory(output_dir)
    
    -- If no valid directory provided, use project path
    if clean_dir == "" or not RenderEngine._is_absolute_path(clean_dir) then
        local proj_path = reaper.GetProjectPath("") or ""
        clean_dir = RenderEngine._sanitize_directory(proj_path)
    end
    
    -- Final validation: ensure we have an absolute path
    if not RenderEngine._is_absolute_path(clean_dir) then
        reaper.Undo_EndBlock("Render Region Failed", -1)
        RenderEngine._restore_render_settings(saved_settings)
        return false, "Could not determine valid output directory"
    end
    
    -- Build clean filename (without path)
    local filename = RenderEngine._build_clean_filename(region)
    
    -- === CRITICAL: Clear existing render paths BEFORE setting new ones ===
    -- This prevents REAPER from concatenating the old RENDER_FILE with the new one
    RenderEngine._clear_render_paths()
    
    -- Set render bounds to custom time bounds
    -- RENDER_BOUNDSFLAG: 0=custom, 1=project, 2=time sel, 3=all regions, 4=selected regions
    reaper.GetSetProjectInfo(0, "RENDER_BOUNDSFLAG", 0, true)
    
    -- Set render time bounds to region boundaries
    reaper.GetSetProjectInfo(0, "RENDER_STARTPOS", region.start_pos, true)
    reaper.GetSetProjectInfo(0, "RENDER_ENDPOS", region.end_pos, true)
    
    -- Set channel count based on region's channel mode
    local channel_count = RenderEngine._get_channel_count(region.channel_mode)
    reaper.GetSetProjectInfo(0, "RENDER_CHANNELS", channel_count, true)
    
    -- === Set output path (RENDER_FILE = directory, RENDER_PATTERN = filename) ===
    -- IMPORTANT: RENDER_FILE should be the directory WITHOUT trailing separator
    -- REAPER will handle the separator internally
    reaper.GetSetProjectInfo_String(0, "RENDER_FILE", clean_dir, true)
    reaper.GetSetProjectInfo_String(0, "RENDER_PATTERN", filename, true)
    
    -- Debug: Verify settings were applied correctly (optional, for troubleshooting)
    -- local _, verify_file = reaper.GetSetProjectInfo_String(0, "RENDER_FILE", "", false)
    -- local _, verify_pattern = reaper.GetSetProjectInfo_String(0, "RENDER_PATTERN", "", false)
    -- reaper.ShowConsoleMsg("RENDER_FILE: " .. verify_file .. "\nRENDER_PATTERN: " .. verify_pattern .. "\n")
    
    -- Execute render
    -- Action 42230 = File: Render project, using the most recent render settings, auto-close render dialog
    reaper.Main_OnCommand(42230, 0)
    
    -- End undo block
    reaper.Undo_EndBlock("Render Region: " .. (region.name or "unnamed"), -1)
    
    -- Restore original settings
    RenderEngine._restore_render_settings(saved_settings)
    
    return success, error_msg
end

--------------------------------------------------------------------------------
-- Batch Render Functions
--------------------------------------------------------------------------------

-- Start batch render of selected regions
-- @param output_dir string: Output directory path
-- @return boolean: True if render started successfully
function RenderEngine.start_batch_render(output_dir)
    local selected_regions = RegionManager.get_selected_regions()
    
    if #selected_regions == 0 then
        last_error = "No regions selected for rendering"
        current_status = RenderEngine.STATUS.ERROR
        return false
    end
    
    -- Sanitize and validate output directory
    local clean_dir = RenderEngine._sanitize_directory(output_dir)
    
    -- If no valid directory provided, use project path
    if clean_dir == "" then
        local proj_path = reaper.GetProjectPath("") or ""
        clean_dir = RenderEngine._sanitize_directory(proj_path)
    end
    
    -- Validate that we have a valid absolute path
    if not RenderEngine._is_absolute_path(clean_dir) then
        last_error = "Invalid output directory: " .. (output_dir or "(empty)")
        current_status = RenderEngine.STATUS.ERROR
        return false
    end
    
    -- Check if directory exists (optional, REAPER may create it)
    -- Note: Lua doesn't have built-in directory check, so we skip this
    
    -- Initialize render queue with sanitized directory
    render_queue = {}
    for _, region in ipairs(selected_regions) do
        table.insert(render_queue, {
            region = region,
            output_dir = clean_dir,  -- Use sanitized directory
            status = "pending"
        })
    end
    
    current_render_index = 0
    current_status = RenderEngine.STATUS.RENDERING
    render_progress = 0
    last_error = ""
    
    -- Start rendering first item
    RenderEngine._process_next()
    
    return true
end

-- Process next item in render queue
function RenderEngine._process_next()
    current_render_index = current_render_index + 1
    
    if current_render_index > #render_queue then
        -- All done
        current_status = RenderEngine.STATUS.COMPLETED
        render_progress = 100
        return
    end
    
    local item = render_queue[current_render_index]
    item.status = "rendering"
    
    -- Update progress
    render_progress = math.floor((current_render_index - 1) / #render_queue * 100)
    
    -- Render this region
    local success, error_msg = RenderEngine.render_region(item.region, item.output_dir)
    
    if success then
        item.status = "completed"
    else
        item.status = "error"
        item.error = error_msg
        last_error = error_msg
    end
    
    -- Continue with next (use defer for non-blocking)
    if current_render_index < #render_queue then
        reaper.defer(function()
            RenderEngine._process_next()
        end)
    else
        current_status = RenderEngine.STATUS.COMPLETED
        render_progress = 100
    end
end

-- Get render queue status
function RenderEngine.get_queue_status()
    local result = {
        total = #render_queue,
        completed = 0,
        errors = 0,
        pending = 0
    }
    
    for _, item in ipairs(render_queue) do
        if item.status == "completed" then
            result.completed = result.completed + 1
        elseif item.status == "error" then
            result.errors = result.errors + 1
        else
            result.pending = result.pending + 1
        end
    end
    
    return result
end

-- Cancel ongoing render
function RenderEngine.cancel()
    if current_status == RenderEngine.STATUS.RENDERING then
        current_status = RenderEngine.STATUS.IDLE
        render_queue = {}
        current_render_index = 0
    end
end

-- Check if currently rendering
function RenderEngine.is_rendering()
    return current_status == RenderEngine.STATUS.RENDERING
end

return RenderEngine
