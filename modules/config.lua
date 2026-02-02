--[[
  Configuration Module
  
  Manages global settings and user preferences for Region Channel Exporter.
  Settings are persisted using Reaper's ExtState system.
--]]

Config = {}

-- Constants
local EXT_STATE_SECTION = "SmartRegionManager"
local SETTINGS_KEY = "Settings"

-- Default settings
local DEFAULT_SETTINGS = {
    -- Naming options
    add_channel_suffix = true,           -- Whether to add channel mode suffix to filename
    mono_suffix = "_Mono",               -- Suffix for mono files
    stereo_suffix = "_Stereo",           -- Suffix for stereo files
    
    -- Render options
    default_channel_mode = "Stereo",     -- Default channel mode for new regions
    output_format = "WAV",               -- Output format (WAV, FLAC, MP3, etc.)
    sample_rate = 48000,                 -- Sample rate
    bit_depth = 24,                      -- Bit depth
    
    -- UI options
    show_time_in_seconds = false,        -- Show time in seconds vs SMPTE
    auto_refresh = true,                 -- Auto-refresh region list
    theme_mode = "auto",                 -- Theme mode: "auto", "dark", or "light"
    
    -- Path options
    output_directory = "",               -- Last used output directory (empty = use project path)
}

-- Current settings (runtime)
local settings = {}

-- Initialize configuration
function Config.init()
    Config.load()
end

-- Load settings from ExtState
function Config.load()
    local retval, json_str = reaper.GetProjExtState(0, EXT_STATE_SECTION, SETTINGS_KEY)
    
    if retval > 0 and json_str ~= "" then
        -- Parse simple key=value format (Lua doesn't have native JSON)
        settings = Config._parse_settings(json_str)
    else
        -- Use defaults
        settings = Config._copy_table(DEFAULT_SETTINGS)
    end
    
    -- Ensure all default keys exist
    for key, value in pairs(DEFAULT_SETTINGS) do
        if settings[key] == nil then
            settings[key] = value
        end
    end
end

-- Save settings to ExtState
function Config.save()
    local str = Config._serialize_settings(settings)
    reaper.SetProjExtState(0, EXT_STATE_SECTION, SETTINGS_KEY, str)
end

-- Get a setting value
function Config.get(key)
    return settings[key]
end

-- Set a setting value
function Config.set(key, value)
    settings[key] = value
    Config.save()
end

-- Get all settings
function Config.get_all()
    return Config._copy_table(settings)
end

-- Reset to defaults
function Config.reset()
    settings = Config._copy_table(DEFAULT_SETTINGS)
    Config.save()
end

-- Get channel suffix based on mode
function Config.get_channel_suffix(channel_mode)
    if not Config.get("add_channel_suffix") then
        return ""
    end
    
    if channel_mode == "Mono" then
        return Config.get("mono_suffix") or "_Mono"
    else
        return Config.get("stereo_suffix") or "_Stereo"
    end
end

-- Internal: Parse settings string
function Config._parse_settings(str)
    local result = {}
    for line in str:gmatch("[^\n]+") do
        local key, value = line:match("([^=]+)=(.+)")
        if key and value then
            key = key:match("^%s*(.-)%s*$")  -- trim
            value = value:match("^%s*(.-)%s*$")  -- trim
            
            -- Convert types
            if value == "true" then
                result[key] = true
            elseif value == "false" then
                result[key] = false
            elseif tonumber(value) then
                result[key] = tonumber(value)
            else
                result[key] = value
            end
        end
    end
    return result
end

-- Internal: Serialize settings to string
function Config._serialize_settings(tbl)
    local lines = {}
    for key, value in pairs(tbl) do
        table.insert(lines, key .. "=" .. tostring(value))
    end
    return table.concat(lines, "\n")
end

-- Internal: Deep copy table
function Config._copy_table(tbl)
    local copy = {}
    for key, value in pairs(tbl) do
        if type(value) == "table" then
            copy[key] = Config._copy_table(value)
        else
            copy[key] = value
        end
    end
    return copy
end

return Config
