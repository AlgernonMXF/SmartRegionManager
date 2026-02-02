--[[
  Render Engine Module
  
  Handles the actual rendering of regions with appropriate channel settings.
  Supports batch rendering with per-region channel mode configuration.
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

-- Build output filename for a region
function RenderEngine.build_filename(region, output_dir)
    local base_name = region.name
    
    -- Clean filename (remove invalid characters)
    base_name = base_name:gsub('[<>:"/\\|?*]', "_")
    
    -- Add channel suffix if enabled
    local suffix = Config.get_channel_suffix(region.channel_mode)
    
    -- Build full path
    local extension = "." .. string.lower(Config.get("output_format") or "wav")
    local filename = base_name .. suffix .. extension
    
    if output_dir and output_dir ~= "" then
        -- Ensure trailing separator
        if not output_dir:match("[/\\]$") then
            output_dir = output_dir .. "/"
        end
        return output_dir .. filename
    end
    
    return filename
end

-- Get channel count for mode
function RenderEngine._get_channel_count(mode)
    if mode == "Mono" then
        return 1
    else
        return 2  -- Stereo
    end
end

-- Save current render settings
function RenderEngine._save_render_settings()
    local settings = {}
    
    -- Save relevant render settings
    settings.bounds = reaper.GetSetProjectInfo(0, "RENDER_BOUNDSFLAG", 0, false)
    settings.channels = reaper.GetSetProjectInfo(0, "RENDER_CHANNELS", 0, false)
    settings.startpos = reaper.GetSetProjectInfo(0, "RENDER_STARTPOS", 0, false)
    settings.endpos = reaper.GetSetProjectInfo(0, "RENDER_ENDPOS", 0, false)
    
    local retval, render_file = reaper.GetSetProjectInfo_String(0, "RENDER_FILE", "", false)
    settings.render_file = render_file
    
    local retval2, render_pattern = reaper.GetSetProjectInfo_String(0, "RENDER_PATTERN", "", false)
    settings.render_pattern = render_pattern
    
    return settings
end

-- Restore render settings
function RenderEngine._restore_render_settings(settings)
    reaper.GetSetProjectInfo(0, "RENDER_BOUNDSFLAG", settings.bounds, true)
    reaper.GetSetProjectInfo(0, "RENDER_CHANNELS", settings.channels, true)
    reaper.GetSetProjectInfo(0, "RENDER_STARTPOS", settings.startpos, true)
    reaper.GetSetProjectInfo(0, "RENDER_ENDPOS", settings.endpos, true)
    reaper.GetSetProjectInfo_String(0, "RENDER_FILE", settings.render_file, true)
    reaper.GetSetProjectInfo_String(0, "RENDER_PATTERN", settings.render_pattern, true)
end

-- Render a single region
function RenderEngine.render_region(region, output_dir)
    -- Save current settings
    local saved_settings = RenderEngine._save_render_settings()
    
    local success = true
    local error_msg = ""
    
    -- Begin undo block
    reaper.Undo_BeginBlock()
    
    -- Set render bounds to time selection (we'll set the time selection to region bounds)
    -- RENDER_BOUNDSFLAG: 0=custom, 1=project, 2=time sel, 3=all regions, 4=selected regions
    reaper.GetSetProjectInfo(0, "RENDER_BOUNDSFLAG", 0, true)  -- Custom time bounds
    
    -- Set render time bounds to region
    reaper.GetSetProjectInfo(0, "RENDER_STARTPOS", region.start_pos, true)
    reaper.GetSetProjectInfo(0, "RENDER_ENDPOS", region.end_pos, true)
    
    -- Set channel count based on region's channel mode
    local channel_count = RenderEngine._get_channel_count(region.channel_mode)
    reaper.GetSetProjectInfo(0, "RENDER_CHANNELS", channel_count, true)
    
    -- Set output path
    local filename = RenderEngine.build_filename(region, output_dir)
    
    -- Split into directory and pattern
    local dir, pattern = filename:match("(.+[/\\])(.+)")
    if not dir then
        dir = ""
        pattern = filename
    end
    
    reaper.GetSetProjectInfo_String(0, "RENDER_FILE", dir, true)
    reaper.GetSetProjectInfo_String(0, "RENDER_PATTERN", pattern, true)
    
    -- Execute render
    -- Action 42230 = File: Render project, using the most recent render settings, auto-close render dialog
    local render_result = reaper.Main_OnCommand(42230, 0)
    
    -- End undo block
    reaper.Undo_EndBlock("Render Region: " .. region.name, -1)
    
    -- Restore settings
    RenderEngine._restore_render_settings(saved_settings)
    
    return success, error_msg
end

-- Start batch render of selected regions
function RenderEngine.start_batch_render(output_dir)
    local selected_regions = RegionManager.get_selected_regions()
    
    if #selected_regions == 0 then
        last_error = "No regions selected for rendering"
        return false
    end
    
    -- Validate output directory
    if not output_dir or output_dir == "" then
        -- Use project directory
        local proj_path = reaper.GetProjectPath("")
        output_dir = proj_path
    end
    
    -- Initialize queue
    render_queue = {}
    for _, region in ipairs(selected_regions) do
        table.insert(render_queue, {
            region = region,
            output_dir = output_dir,
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
