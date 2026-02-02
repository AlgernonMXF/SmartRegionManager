--[[
  Region Manager Module
  
  Handles enumeration of project regions and management of their channel settings.
  Channel settings are stored per-region using Reaper's ExtState system.
--]]

RegionManager = {}

-- Constants
local EXT_STATE_SECTION = "RegionChannelExporter"
local CHANNEL_KEY_PREFIX = "RegionChannel_"

-- Runtime data
local regions_cache = {}
local last_refresh_time = 0
local REFRESH_INTERVAL = 0.5  -- seconds
local is_first_init = true  -- Track first initialization for default select all

-- Channel modes
RegionManager.CHANNEL_MODES = {
    "Mono",
    "Stereo"
}

-- Get currently selected region IDs (for preserving selection across refresh)
local function get_selected_ids()
    local selected_ids = {}
    for _, region in ipairs(regions_cache) do
        if region.selected then
            selected_ids[region.id] = true
        end
    end
    return selected_ids
end

-- Initialize
function RegionManager.init()
    RegionManager.refresh()
    -- Default to all selected on first init
    if is_first_init then
        RegionManager.select_all()
        is_first_init = false
    end
end

-- Get all regions from project
function RegionManager.refresh()
    -- Preserve current selection state before refreshing
    local selected_ids = get_selected_ids()
    local had_regions = #regions_cache > 0
    
    regions_cache = {}
    
    local marker_count = reaper.CountProjectMarkers(0)
    
    for i = 0, marker_count - 1 do
        local retval, isrgn, pos, rgnend, name, markrgnindexnumber = reaper.EnumProjectMarkers(i)
        
        if isrgn then
            -- Restore selection state if region was previously selected
            -- For new regions (not in previous cache), default to selected if we had regions before
            local was_selected = selected_ids[markrgnindexnumber]
            local region = {
                id = markrgnindexnumber,
                index = i,
                name = name,
                start_pos = pos,
                end_pos = rgnend,
                duration = rgnend - pos,
                channel_mode = RegionManager._get_channel_mode(markrgnindexnumber),
                selected = was_selected or false  -- Preserve selection state
            }
            table.insert(regions_cache, region)
        end
    end
    
    -- Sort by start position
    table.sort(regions_cache, function(a, b)
        return a.start_pos < b.start_pos
    end)
    
    last_refresh_time = reaper.time_precise()
    return regions_cache
end

-- Get cached regions (with auto-refresh option)
function RegionManager.get_regions(force_refresh)
    if force_refresh then
        return RegionManager.refresh()
    end
    
    -- Auto-refresh if enabled and interval passed
    if Config.get("auto_refresh") then
        local now = reaper.time_precise()
        if now - last_refresh_time > REFRESH_INTERVAL then
            return RegionManager.refresh()
        end
    end
    
    return regions_cache
end

-- Get channel mode for a region
function RegionManager._get_channel_mode(region_id)
    local key = CHANNEL_KEY_PREFIX .. tostring(region_id)
    local retval, value = reaper.GetProjExtState(0, EXT_STATE_SECTION, key)
    
    if retval > 0 and value ~= "" then
        return value
    end
    
    -- Return default
    return Config.get("default_channel_mode") or "Stereo"
end

-- Set channel mode for a region
function RegionManager.set_channel_mode(region_id, mode)
    local key = CHANNEL_KEY_PREFIX .. tostring(region_id)
    reaper.SetProjExtState(0, EXT_STATE_SECTION, key, mode)
    
    -- Update cache
    for _, region in ipairs(regions_cache) do
        if region.id == region_id then
            region.channel_mode = mode
            break
        end
    end
end

-- Get a region by ID
function RegionManager.get_region_by_id(region_id)
    for _, region in ipairs(regions_cache) do
        if region.id == region_id then
            return region
        end
    end
    return nil
end

-- Set selection state for a region
function RegionManager.set_selected(region_id, selected)
    for _, region in ipairs(regions_cache) do
        if region.id == region_id then
            region.selected = selected
            break
        end
    end
end

-- Select all regions
function RegionManager.select_all()
    for _, region in ipairs(regions_cache) do
        region.selected = true
    end
end

-- Deselect all regions
function RegionManager.deselect_all()
    for _, region in ipairs(regions_cache) do
        region.selected = false
    end
end

-- Get selected regions
function RegionManager.get_selected_regions()
    local selected = {}
    for _, region in ipairs(regions_cache) do
        if region.selected then
            table.insert(selected, region)
        end
    end
    return selected
end

-- Set channel mode for all selected regions
function RegionManager.set_selected_channel_mode(mode)
    for _, region in ipairs(regions_cache) do
        if region.selected then
            RegionManager.set_channel_mode(region.id, mode)
        end
    end
end

-- Format time for display
function RegionManager.format_time(seconds)
    if Config.get("show_time_in_seconds") then
        return string.format("%.3f", seconds)
    else
        -- Format as MM:SS.mmm
        local mins = math.floor(seconds / 60)
        local secs = seconds - (mins * 60)
        return string.format("%02d:%06.3f", mins, secs)
    end
end

-- Format duration for display
function RegionManager.format_duration(seconds)
    if seconds < 1 then
        return string.format("%.0f ms", seconds * 1000)
    elseif seconds < 60 then
        return string.format("%.2f s", seconds)
    else
        local mins = math.floor(seconds / 60)
        local secs = seconds - (mins * 60)
        return string.format("%d:%05.2f", mins, secs)
    end
end

-- Get region count
function RegionManager.get_count()
    return #regions_cache
end

-- Get selected count
function RegionManager.get_selected_count()
    local count = 0
    for _, region in ipairs(regions_cache) do
        if region.selected then
            count = count + 1
        end
    end
    return count
end

return RegionManager
