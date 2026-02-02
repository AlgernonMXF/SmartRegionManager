--[[
  GUI Module
  
  Implements the main user interface using ReaImGui.
  Provides region list, channel settings, and render controls.
--]]

GUI = {}

-- UI State
local show_settings = false
local output_directory = ""
local search_filter = ""

-- Combo box state (for ImGui)
local channel_combo_items = "Mono\0Stereo\0"

-- Theme state
local theme_colors_pushed = 0
local current_theme = nil  -- "dark" or "light"

-- Theme color definitions
local THEMES = {
    dark = {
        -- Window
        WindowBg = 0x1E1E1EFF,
        PopupBg = 0x252526FF,
        Border = 0x3C3C3CFF,
        -- Text
        Text = 0xD4D4D4FF,
        TextDisabled = 0x6E6E6EFF,
        -- Headers
        Header = 0x3C3C3CFF,
        HeaderHovered = 0x4E4E4EFF,
        HeaderActive = 0x5A5A5AFF,
        -- Buttons
        Button = 0x3C3C3CFF,
        ButtonHovered = 0x4E4E4EFF,
        ButtonActive = 0x5A5A5AFF,
        -- Frame (inputs, combo boxes)
        FrameBg = 0x333333FF,
        FrameBgHovered = 0x3E3E3EFF,
        FrameBgActive = 0x4A4A4AFF,
        -- Tables
        TableHeaderBg = 0x2D2D2DFF,
        TableRowBg = 0x1E1E1EFF,
        TableRowBgAlt = 0x262626FF,
        TableBorderStrong = 0x3C3C3CFF,
        TableBorderLight = 0x333333FF,
        -- Checkboxes
        CheckMark = 0x569CD6FF,
        -- Scrollbar
        ScrollbarBg = 0x1E1E1EFF,
        ScrollbarGrab = 0x4E4E4EFF,
        ScrollbarGrabHovered = 0x5E5E5EFF,
        ScrollbarGrabActive = 0x6E6E6EFF,
        -- Separators
        Separator = 0x3C3C3CFF,
        -- Title
        TitleBg = 0x1E1E1EFF,
        TitleBgActive = 0x2D2D2DFF,
        TitleBgCollapsed = 0x1E1E1EFF,
        -- Child windows
        ChildBg = 0x1E1E1EFF,
        -- Menu bar
        MenuBarBg = 0x252526FF,
        -- Resize grips
        ResizeGrip = 0x3C3C3CFF,
        ResizeGripHovered = 0x4E4E4EFF,
        ResizeGripActive = 0x5A5A5AFF,
        -- Slider
        SliderGrab = 0x4E4E4EFF,
        SliderGrabActive = 0x5A5A5AFF,
        -- Tab
        Tab = 0x2D2D2DFF,
        TabHovered = 0x3C3C3CFF,
        TabActive = 0x3C3C3CFF,
        TabUnfocused = 0x252526FF,
        TabUnfocusedActive = 0x2D2D2DFF,
    },
    light = {
        -- Window
        WindowBg = 0xFFFFFFFF,
        PopupBg = 0xFFFFFFFF,
        Border = 0xCCCCCCFF,
        -- Text
        Text = 0x1E1E1EFF,
        TextDisabled = 0x808080FF,
        -- Headers
        Header = 0xF0F0F0FF,
        HeaderHovered = 0xE0E0E0FF,
        HeaderActive = 0xD0D0D0FF,
        -- Buttons
        Button = 0xF0F0F0FF,
        ButtonHovered = 0xE0E0E0FF,
        ButtonActive = 0xD0D0D0FF,
        -- Frame (inputs, combo boxes)
        FrameBg = 0xFFFFFFFF,
        FrameBgHovered = 0xF5F5F5FF,
        FrameBgActive = 0xEEEEEEFF,
        -- Tables
        TableHeaderBg = 0xF5F5F5FF,
        TableRowBg = 0xFFFFFFFF,
        TableRowBgAlt = 0xFAFAFAFF,
        TableBorderStrong = 0xCCCCCCFF,
        TableBorderLight = 0xE0E0E0FF,
        -- Checkboxes
        CheckMark = 0x0066CCFF,
        -- Scrollbar
        ScrollbarBg = 0xFAFAFAFF,
        ScrollbarGrab = 0xC0C0C0FF,
        ScrollbarGrabHovered = 0xA0A0A0FF,
        ScrollbarGrabActive = 0x808080FF,
        -- Separators
        Separator = 0xE0E0E0FF,
        -- Title (窗口标题栏 - 使用非常浅的颜色，接近白色)
        TitleBg = 0xFAFAFAFF,
        TitleBgActive = 0xF5F5F5FF,
        TitleBgCollapsed = 0xFAFAFAFF,
        -- Child windows
        ChildBg = 0xFFFFFFFF,
        -- Menu bar
        MenuBarBg = 0xF5F5F5FF,
        -- Resize grips
        ResizeGrip = 0xCCCCCCFF,
        ResizeGripHovered = 0xB0B0B0FF,
        ResizeGripActive = 0x808080FF,
        -- Slider
        SliderGrab = 0xC0C0C0FF,
        SliderGrabActive = 0x808080FF,
        -- Tab
        Tab = 0xD8D8D8FF,
        TabHovered = 0xC0C0C0FF,
        TabActive = 0xC0C0C0FF,
        TabUnfocused = 0xE8E8E8FF,
        TabUnfocusedActive = 0xD8D8D8FF,
    }
}

-- Detect theme from REAPER colors (auto mode)
local function detect_theme_auto()
    -- Try to get REAPER's main background color
    -- Note: GetThemeColor may return 0 or -1 if color doesn't exist
    local bg_color = reaper.GetThemeColor("col_main_bg2", 0)
    if bg_color == 0 or bg_color == -1 then
        bg_color = reaper.GetThemeColor("col_main_bg", 0)
    end
    
    -- If still invalid, default to dark theme (most common for DAWs)
    if bg_color == 0 or bg_color == -1 then
        return "dark"
    end
    
    -- Extract RGB components (REAPER returns BGR format on Windows)
    local r = (bg_color & 0xFF)
    local g = (bg_color >> 8) & 0xFF
    local b = (bg_color >> 16) & 0xFF
    
    -- Calculate luminance (perceived brightness)
    local luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255
    
    -- Determine theme based on luminance
    if luminance < 0.5 then
        return "dark"
    else
        return "light"
    end
end

-- Get current theme (respects manual setting or auto-detects)
local function detect_theme()
    local theme_mode = Config.get("theme_mode") or "auto"
    
    if theme_mode == "dark" then
        return "dark"
    elseif theme_mode == "light" then
        return "light"
    else
        -- Auto mode: detect from REAPER theme
        return detect_theme_auto()
    end
end

-- Cycle theme mode: auto -> dark -> light -> auto
local function cycle_theme_mode()
    local current_mode = Config.get("theme_mode") or "auto"
    local next_mode = "auto"
    
    if current_mode == "auto" then
        next_mode = "dark"
    elseif current_mode == "dark" then
        next_mode = "light"
    else
        next_mode = "auto"
    end
    
    Config.set("theme_mode", next_mode)
    return next_mode
end

-- Get theme button label
local function get_theme_button_label()
    local theme_mode = Config.get("theme_mode") or "auto"
    if theme_mode == "auto" then
        return "Theme: Auto"
    elseif theme_mode == "dark" then
        return "Theme: Dark"
    else
        return "Theme: Light"
    end
end

-- Apply theme colors
local function apply_theme(ctx)
    -- Pop previous colors if any
    if theme_colors_pushed > 0 then
        reaper.ImGui_PopStyleColor(ctx, theme_colors_pushed)
        theme_colors_pushed = 0
    end
    
    -- Detect and apply theme
    current_theme = detect_theme()
    local theme = THEMES[current_theme]
    
    -- Apply colors
    local function push_color(idx_func, color)
        if idx_func then
            local success, idx = pcall(idx_func)
            if success and idx and idx >= 0 then
                reaper.ImGui_PushStyleColor(ctx, idx, color)
                theme_colors_pushed = theme_colors_pushed + 1
            end
        end
    end
    
    -- Window
    push_color(function() return reaper.ImGui_Col_WindowBg() end, theme.WindowBg)
    push_color(function() return reaper.ImGui_Col_PopupBg() end, theme.PopupBg)
    push_color(function() return reaper.ImGui_Col_Border() end, theme.Border)
    
    -- Text
    push_color(function() return reaper.ImGui_Col_Text() end, theme.Text)
    push_color(function() return reaper.ImGui_Col_TextDisabled() end, theme.TextDisabled)
    
    -- Headers
    push_color(function() return reaper.ImGui_Col_Header() end, theme.Header)
    push_color(function() return reaper.ImGui_Col_HeaderHovered() end, theme.HeaderHovered)
    push_color(function() return reaper.ImGui_Col_HeaderActive() end, theme.HeaderActive)
    
    -- Buttons
    push_color(function() return reaper.ImGui_Col_Button() end, theme.Button)
    push_color(function() return reaper.ImGui_Col_ButtonHovered() end, theme.ButtonHovered)
    push_color(function() return reaper.ImGui_Col_ButtonActive() end, theme.ButtonActive)
    
    -- Frame
    push_color(function() return reaper.ImGui_Col_FrameBg() end, theme.FrameBg)
    push_color(function() return reaper.ImGui_Col_FrameBgHovered() end, theme.FrameBgHovered)
    push_color(function() return reaper.ImGui_Col_FrameBgActive() end, theme.FrameBgActive)
    
    -- Tables
    push_color(function() return reaper.ImGui_Col_TableHeaderBg() end, theme.TableHeaderBg)
    push_color(function() return reaper.ImGui_Col_TableRowBg() end, theme.TableRowBg)
    push_color(function() return reaper.ImGui_Col_TableRowBgAlt() end, theme.TableRowBgAlt)
    push_color(function() return reaper.ImGui_Col_TableBorderStrong() end, theme.TableBorderStrong)
    push_color(function() return reaper.ImGui_Col_TableBorderLight() end, theme.TableBorderLight)
    
    -- Checkboxes
    push_color(function() return reaper.ImGui_Col_CheckMark() end, theme.CheckMark)
    
    -- Scrollbar
    push_color(function() return reaper.ImGui_Col_ScrollbarBg() end, theme.ScrollbarBg)
    push_color(function() return reaper.ImGui_Col_ScrollbarGrab() end, theme.ScrollbarGrab)
    push_color(function() return reaper.ImGui_Col_ScrollbarGrabHovered() end, theme.ScrollbarGrabHovered)
    push_color(function() return reaper.ImGui_Col_ScrollbarGrabActive() end, theme.ScrollbarGrabActive)
    
    -- Separator
    push_color(function() return reaper.ImGui_Col_Separator() end, theme.Separator)
    
    -- Title bar
    push_color(function() return reaper.ImGui_Col_TitleBg() end, theme.TitleBg)
    push_color(function() return reaper.ImGui_Col_TitleBgActive() end, theme.TitleBgActive)
    if theme.TitleBgCollapsed then
        push_color(function() 
            if reaper.ImGui_Col_TitleBgCollapsed then
                return reaper.ImGui_Col_TitleBgCollapsed()
            end
            return nil
        end, theme.TitleBgCollapsed)
    end
    
    -- Child windows
    if theme.ChildBg then
        push_color(function() 
            if reaper.ImGui_Col_ChildBg then
                return reaper.ImGui_Col_ChildBg()
            end
            return nil
        end, theme.ChildBg)
    end
    
    -- Menu bar
    if theme.MenuBarBg then
        push_color(function() 
            if reaper.ImGui_Col_MenuBarBg then
                return reaper.ImGui_Col_MenuBarBg()
            end
            return nil
        end, theme.MenuBarBg)
    end
    
    -- Resize grips
    if theme.ResizeGrip then
        push_color(function() 
            if reaper.ImGui_Col_ResizeGrip then
                return reaper.ImGui_Col_ResizeGrip()
            end
            return nil
        end, theme.ResizeGrip)
        push_color(function() 
            if reaper.ImGui_Col_ResizeGripHovered then
                return reaper.ImGui_Col_ResizeGripHovered()
            end
            return nil
        end, theme.ResizeGripHovered)
        push_color(function() 
            if reaper.ImGui_Col_ResizeGripActive then
                return reaper.ImGui_Col_ResizeGripActive()
            end
            return nil
        end, theme.ResizeGripActive)
    end
    
    -- Slider
    if theme.SliderGrab then
        push_color(function() 
            if reaper.ImGui_Col_SliderGrab then
                return reaper.ImGui_Col_SliderGrab()
            end
            return nil
        end, theme.SliderGrab)
        push_color(function() 
            if reaper.ImGui_Col_SliderGrabActive then
                return reaper.ImGui_Col_SliderGrabActive()
            end
            return nil
        end, theme.SliderGrabActive)
    end
    
    -- Tab
    if theme.Tab then
        push_color(function() 
            if reaper.ImGui_Col_Tab then
                return reaper.ImGui_Col_Tab()
            end
            return nil
        end, theme.Tab)
        push_color(function() 
            if reaper.ImGui_Col_TabHovered then
                return reaper.ImGui_Col_TabHovered()
            end
            return nil
        end, theme.TabHovered)
        push_color(function() 
            if reaper.ImGui_Col_TabActive then
                return reaper.ImGui_Col_TabActive()
            end
            return nil
        end, theme.TabActive)
        push_color(function() 
            if reaper.ImGui_Col_TabUnfocused then
                return reaper.ImGui_Col_TabUnfocused()
            end
            return nil
        end, theme.TabUnfocused)
        push_color(function() 
            if reaper.ImGui_Col_TabUnfocusedActive then
                return reaper.ImGui_Col_TabUnfocusedActive()
            end
            return nil
        end, theme.TabUnfocusedActive)
    end
end

-- Pop theme colors (call at end of frame)
local function pop_theme_colors(ctx)
    if theme_colors_pushed > 0 then
        reaper.ImGui_PopStyleColor(ctx, theme_colors_pushed)
        theme_colors_pushed = 0
    end
end

-- Initialize output directory from project path
local function init_output_directory()
    if output_directory == "" then
        output_directory = reaper.GetProjectPath("")
    end
end

-- Open folder in file explorer (cross-platform)
local function open_folder_in_explorer(folder_path)
    if folder_path == "" or folder_path == nil then
        return false
    end

    -- Trim surrounding whitespace
    folder_path = folder_path:match("^%s*(.-)%s*$")

    -- Prefer SWS ShellExecute if available (more reliable on Windows)
    if reaper.CF_ShellExecute then
        reaper.CF_ShellExecute(folder_path)
        return true
    end
    
    -- Detect OS
    local os_name = reaper.GetOS() or ""
    local command = ""
    
    if os_name:find("Win") then
        -- Windows: use cmd start to open folder reliably
        -- Normalize path separators for Windows
        folder_path = folder_path:gsub("/", "\\")
        -- "start" needs a window title, so pass empty title ""
        command = string.format('cmd.exe /C start "" "%s"', folder_path)
    elseif os_name:find("OSX") then
        -- macOS: use open command
        command = string.format('open "%s"', folder_path)
    else
        -- Linux: use xdg-open
        command = string.format('xdg-open "%s"', folder_path)
    end
    
    -- Execute command
    if reaper.ExecProcess then
        reaper.ExecProcess(command, 0)
        return true
    else
        -- Fallback: try using os.execute (less reliable)
        if _G.os and _G.os.execute then
            _G.os.execute(command)
        end
        return true
    end
end

-- Browse for folder (prefer native dialogs)
local function browse_for_folder(start_path)
    -- JS_Dialog_BrowseForFolder requires JS_ReaScriptAPI extension
    if reaper.JS_Dialog_BrowseForFolder then
        local retval, folder = reaper.JS_Dialog_BrowseForFolder("Select Output Directory", start_path or "")
        if retval == 1 then
            return folder
        end
        return nil
    end

    local os_name = reaper.GetOS() or ""
    local attempted_dialog = false

    -- Windows: use PowerShell FolderBrowserDialog via ExecProcess
    if os_name:find("Win") and reaper.ExecProcess then
        attempted_dialog = true
        local ps_start = (start_path or ""):gsub('"', '""')
        local temp_path = (reaper.GetResourcePath() or "") .. "\\SmartRegionManager_browse_path.txt"
        local command = string.format(
            'powershell -NoProfile -Command "Add-Type -AssemblyName System.Windows.Forms; $f=New-Object System.Windows.Forms.FolderBrowserDialog; $f.SelectedPath=\'%s\'; if($f.ShowDialog() -eq \'OK\'){Set-Content -LiteralPath \'%s\' -Value $f.SelectedPath -Encoding UTF8}"',
            ps_start,
            temp_path:gsub("'", "''")
        )
        reaper.ExecProcess(command, 30000)

        local file = io.open(temp_path, "r")
        if file then
            local selected = file:read("*a") or ""  -- Read all content
            file:close()
            if _G.os and _G.os.remove then
                _G.os.remove(temp_path)
            end
            -- Clean the path: remove whitespace, newlines, and any invalid characters
            selected = selected:match("^%s*(.-)%s*$") or ""
            -- Remove any trailing newlines or carriage returns
            selected = selected:gsub("[\r\n]+", "")
            -- Normalize Windows path separators
            if os_name:find("Win") then
                selected = selected:gsub("/", "\\")
                -- Remove any duplicate drive letters (e.g., "D:\C:\Users\..." -> "C:\Users\...")
                -- Find all positions of drive letters (e.g., "C:\", "D:\")
                local drive_positions = {}
                for pos, drive in selected:gmatch("()([A-Z]:\\)") do
                    table.insert(drive_positions, {pos = pos, drive = drive})
                end
                -- If multiple drive letters found, keep only the last one
                if #drive_positions > 1 then
                    local last_pos = drive_positions[#drive_positions].pos
                    selected = selected:sub(last_pos)
                end
            end
            if selected ~= "" then
                return selected
            end
        end
        return nil
    end

    -- macOS: use AppleScript choose folder
    if os_name:find("OSX") and reaper.ExecProcess then
        attempted_dialog = true
        local command = 'osascript -e "POSIX path of (choose folder)"'
        local exit_code, output = reaper.ExecProcess(command, 30000)
        local selected = output and output:match("^%s*(.-)%s*$") or ""
        if selected ~= "" then
            return selected
        end
        return nil
    end

    -- Linux: try zenity
    if reaper.ExecProcess then
        attempted_dialog = true
        local command = 'zenity --file-selection --directory'
        local exit_code, output = reaper.ExecProcess(command, 30000)
        local selected = output and output:match("^%s*(.-)%s*$") or ""
        if selected ~= "" then
            return selected
        end
        return nil
    end

    -- Fallback: Use GetUserInputs for manual path entry
    if attempted_dialog then
        return nil
    end
    local retval, path = reaper.GetUserInputs("Output Directory", 1, "Path:,extrawidth=300", start_path or "")
    if retval then
        return path
    end
    return nil
end

-- Apply theme before window begins (for title bar)
function GUI.apply_theme_before_window(ctx)
    apply_theme(ctx)
end

-- Pop theme colors after window ends
function GUI.pop_theme_after_window(ctx)
    pop_theme_colors(ctx)
end

-- Draw the main GUI
function GUI.draw(ctx)
    init_output_directory()
    
    -- Theme is already applied before window begins
    
    -- Top toolbar
    GUI._draw_toolbar(ctx)
    
    reaper.ImGui_Separator(ctx)
    
    -- Main content area
    local avail_width, avail_height = reaper.ImGui_GetContentRegionAvail(ctx)
    
    if show_settings then
        -- Settings panel
        GUI._draw_settings_panel(ctx)
    else
        -- Region list
        GUI._draw_region_list(ctx, avail_width, avail_height - 80)
        
        reaper.ImGui_Separator(ctx)
        
        -- Bottom panel (render controls)
        GUI._draw_render_panel(ctx)
    end
    
    -- Note: Theme colors are popped after window ends in main loop
end

-- Draw top toolbar
function GUI._draw_toolbar(ctx)
    -- Refresh button
    if reaper.ImGui_Button(ctx, "Refresh##refresh") then
        RegionManager.refresh()
    end
    
    reaper.ImGui_SameLine(ctx)
    
    -- Select All
    if reaper.ImGui_Button(ctx, "Select All##selall") then
        RegionManager.select_all()
    end
    
    reaper.ImGui_SameLine(ctx)
    
    -- Deselect All
    if reaper.ImGui_Button(ctx, "Deselect All##deselall") then
        RegionManager.deselect_all()
    end
    
    reaper.ImGui_SameLine(ctx)
    
    -- Batch set channel mode
    reaper.ImGui_Text(ctx, "  |  Set Selected to:")
    reaper.ImGui_SameLine(ctx)
    
    if reaper.ImGui_Button(ctx, "Mono##batchmono") then
        RegionManager.set_selected_channel_mode("Mono")
    end
    
    reaper.ImGui_SameLine(ctx)
    
    if reaper.ImGui_Button(ctx, "Stereo##batchstereo") then
        RegionManager.set_selected_channel_mode("Stereo")
    end
    
    reaper.ImGui_SameLine(ctx)
    
    -- Spacer
    local avail_width = reaper.ImGui_GetContentRegionAvail(ctx)
    reaper.ImGui_Dummy(ctx, avail_width - 200, 0)
    reaper.ImGui_SameLine(ctx)
    
    -- Theme button (manual theme selection)
    local theme_label = get_theme_button_label()
    if reaper.ImGui_Button(ctx, theme_label .. "##theme") then
        cycle_theme_mode()
    end
    
    reaper.ImGui_SameLine(ctx)
    
    -- Settings button
    local settings_label = show_settings and "Close Settings" or "Settings"
    if reaper.ImGui_Button(ctx, settings_label .. "##settings") then
        show_settings = not show_settings
    end
end

-- Draw region list table
function GUI._draw_region_list(ctx, width, height)
    local regions = RegionManager.get_regions(false)
    
    -- Search/filter
    reaper.ImGui_Text(ctx, "Filter:")
    reaper.ImGui_SameLine(ctx)
    reaper.ImGui_SetNextItemWidth(ctx, 200)
    local changed, new_filter = reaper.ImGui_InputText(ctx, "##filter", search_filter)
    if changed then
        search_filter = new_filter
    end
    
    reaper.ImGui_SameLine(ctx)
    reaper.ImGui_Text(ctx, string.format("  Total: %d | Selected: %d", 
        RegionManager.get_count(), 
        RegionManager.get_selected_count()))
    
    -- Table
    local table_flags = reaper.ImGui_TableFlags_Borders() |
                        reaper.ImGui_TableFlags_RowBg() |
                        reaper.ImGui_TableFlags_Resizable() |
                        reaper.ImGui_TableFlags_ScrollY() |
                        reaper.ImGui_TableFlags_SizingStretchProp()
    
    if reaper.ImGui_BeginTable(ctx, "RegionsTable", 6, table_flags, width, height) then
        -- Headers
        reaper.ImGui_TableSetupColumn(ctx, "##select", reaper.ImGui_TableColumnFlags_WidthFixed(), 30)
        reaper.ImGui_TableSetupColumn(ctx, "ID", reaper.ImGui_TableColumnFlags_WidthFixed(), 40)
        reaper.ImGui_TableSetupColumn(ctx, "Name", reaper.ImGui_TableColumnFlags_WidthStretch(), 200)
        reaper.ImGui_TableSetupColumn(ctx, "Start", reaper.ImGui_TableColumnFlags_WidthFixed(), 100)
        reaper.ImGui_TableSetupColumn(ctx, "Duration", reaper.ImGui_TableColumnFlags_WidthFixed(), 80)
        reaper.ImGui_TableSetupColumn(ctx, "Channel", reaper.ImGui_TableColumnFlags_WidthFixed(), 100)
        reaper.ImGui_TableSetupScrollFreeze(ctx, 0, 1)
        reaper.ImGui_TableHeadersRow(ctx)
        
        -- Rows
        for _, region in ipairs(regions) do
            -- Filter check
            local show_row = true
            if search_filter ~= "" then
                show_row = region.name:lower():find(search_filter:lower(), 1, true) ~= nil
            end
            
            if show_row then
                reaper.ImGui_TableNextRow(ctx)
                
                -- Checkbox column
                reaper.ImGui_TableSetColumnIndex(ctx, 0)
                local changed, selected = reaper.ImGui_Checkbox(ctx, "##sel" .. region.id, region.selected)
                if changed then
                    RegionManager.set_selected(region.id, selected)
                end
                
                -- ID column
                reaper.ImGui_TableSetColumnIndex(ctx, 1)
                reaper.ImGui_Text(ctx, string.format("R%d", region.id))
                
                -- Name column
                reaper.ImGui_TableSetColumnIndex(ctx, 2)
                reaper.ImGui_Text(ctx, region.name)
                
                -- Start column
                reaper.ImGui_TableSetColumnIndex(ctx, 3)
                reaper.ImGui_Text(ctx, RegionManager.format_time(region.start_pos))
                
                -- Duration column
                reaper.ImGui_TableSetColumnIndex(ctx, 4)
                reaper.ImGui_Text(ctx, RegionManager.format_duration(region.duration))
                
                -- Channel column (combo box)
                reaper.ImGui_TableSetColumnIndex(ctx, 5)
                reaper.ImGui_SetNextItemWidth(ctx, -1)
                
                local current_mode = region.channel_mode == "Mono" and 0 or 1
                local changed, new_mode = reaper.ImGui_Combo(ctx, "##ch" .. region.id, current_mode, channel_combo_items)
                if changed then
                    local mode = new_mode == 0 and "Mono" or "Stereo"
                    RegionManager.set_channel_mode(region.id, mode)
                end
            end
        end
        
        reaper.ImGui_EndTable(ctx)
    end
end

-- Draw settings panel
function GUI._draw_settings_panel(ctx)
    reaper.ImGui_Text(ctx, "Settings")
    reaper.ImGui_Separator(ctx)
    
    -- Naming Options
    if reaper.ImGui_CollapsingHeader(ctx, "Naming Options", reaper.ImGui_TreeNodeFlags_DefaultOpen()) then
        reaper.ImGui_Indent(ctx)
        
        -- Add channel suffix checkbox
        local add_suffix = Config.get("add_channel_suffix")
        local changed, new_val = reaper.ImGui_Checkbox(ctx, "Add channel mode suffix to filename", add_suffix)
        if changed then
            Config.set("add_channel_suffix", new_val)
        end
        
        if Config.get("add_channel_suffix") then
            -- Mono suffix
            reaper.ImGui_Text(ctx, "Mono suffix:")
            reaper.ImGui_SameLine(ctx)
            reaper.ImGui_SetNextItemWidth(ctx, 100)
            local mono_suffix = Config.get("mono_suffix") or "_Mono"
            local changed_m, new_mono = reaper.ImGui_InputText(ctx, "##monosuffix", mono_suffix)
            if changed_m then
                Config.set("mono_suffix", new_mono)
            end
            
            -- Stereo suffix
            reaper.ImGui_SameLine(ctx)
            reaper.ImGui_Text(ctx, "  Stereo suffix:")
            reaper.ImGui_SameLine(ctx)
            reaper.ImGui_SetNextItemWidth(ctx, 100)
            local stereo_suffix = Config.get("stereo_suffix") or "_Stereo"
            local changed_s, new_stereo = reaper.ImGui_InputText(ctx, "##stereosuffix", stereo_suffix)
            if changed_s then
                Config.set("stereo_suffix", new_stereo)
            end
            
            -- Preview
            reaper.ImGui_Text(ctx, "Preview: MyRegion" .. Config.get_channel_suffix("Mono") .. ".wav")
        end
        
        reaper.ImGui_Unindent(ctx)
    end
    
    -- Render Options
    if reaper.ImGui_CollapsingHeader(ctx, "Default Settings", reaper.ImGui_TreeNodeFlags_DefaultOpen()) then
        reaper.ImGui_Indent(ctx)
        
        -- Default channel mode
        reaper.ImGui_Text(ctx, "Default channel mode for new regions:")
        reaper.ImGui_SameLine(ctx)
        reaper.ImGui_SetNextItemWidth(ctx, 100)
        local default_mode = Config.get("default_channel_mode") == "Mono" and 0 or 1
        local changed_d, new_default = reaper.ImGui_Combo(ctx, "##defaultchannel", default_mode, channel_combo_items)
        if changed_d then
            Config.set("default_channel_mode", new_default == 0 and "Mono" or "Stereo")
        end
        
        -- Auto refresh
        local auto_refresh = Config.get("auto_refresh")
        local changed_ar, new_ar = reaper.ImGui_Checkbox(ctx, "Auto-refresh region list", auto_refresh)
        if changed_ar then
            Config.set("auto_refresh", new_ar)
        end
        
        -- Time format
        local show_seconds = Config.get("show_time_in_seconds")
        local changed_tf, new_tf = reaper.ImGui_Checkbox(ctx, "Show time in seconds (instead of MM:SS.mmm)", show_seconds)
        if changed_tf then
            Config.set("show_time_in_seconds", new_tf)
        end
        
        reaper.ImGui_Unindent(ctx)
    end
    
    reaper.ImGui_Separator(ctx)
    
    -- Reset button
    if reaper.ImGui_Button(ctx, "Reset to Defaults") then
        Config.reset()
    end
end

-- Draw render panel
function GUI._draw_render_panel(ctx)
    local is_rendering = RenderEngine.is_rendering()
    
    -- Output directory
    reaper.ImGui_Text(ctx, "Output Directory:")
    reaper.ImGui_SameLine(ctx)
    reaper.ImGui_SetNextItemWidth(ctx, 400)
    local changed_dir, new_dir = reaper.ImGui_InputText(ctx, "##outputdir", output_directory)
    if changed_dir then
        output_directory = new_dir
    end
    
    reaper.ImGui_SameLine(ctx)
    if reaper.ImGui_Button(ctx, "Browse...##browse") then
        local selected = browse_for_folder(output_directory)
        if selected and selected ~= "" then
            -- Clean the path before setting it
            local os_name = reaper.GetOS() or ""
            if os_name:find("Win") then
                -- Remove any duplicate drive letters
                local drive_positions = {}
                for pos, drive in selected:gmatch("()([A-Z]:\\)") do
                    table.insert(drive_positions, {pos = pos, drive = drive})
                end
                if #drive_positions > 1 then
                    local last_pos = drive_positions[#drive_positions].pos
                    selected = selected:sub(last_pos)
                end
            end
            output_directory = selected
        end
    end
    
    reaper.ImGui_SameLine(ctx)
    if reaper.ImGui_Button(ctx, "Open Folder##openfolder") then
        if output_directory ~= "" then
            open_folder_in_explorer(output_directory)
        else
            reaper.ShowMessageBox("Please set an output directory first.", "No Directory", 0)
        end
    end
    
    -- Render button / Progress
    reaper.ImGui_Spacing(ctx)
    
    if is_rendering then
        -- Show progress
        local progress = RenderEngine.get_progress() / 100
        reaper.ImGui_ProgressBar(ctx, progress, 300, 0)
        
        local queue_status = RenderEngine.get_queue_status()
        reaper.ImGui_SameLine(ctx)
        reaper.ImGui_Text(ctx, string.format("Rendering %d/%d...", 
            queue_status.completed + 1, queue_status.total))
        
        reaper.ImGui_SameLine(ctx)
        if reaper.ImGui_Button(ctx, "Cancel##cancel") then
            RenderEngine.cancel()
        end
    else
        -- Render button
        local selected_count = RegionManager.get_selected_count()
        local can_render = selected_count > 0
        
        if not can_render then
            reaper.ImGui_BeginDisabled(ctx)
        end
        
        local render_label = string.format("Render Selected (%d)##render", selected_count)
        if reaper.ImGui_Button(ctx, render_label, 200, 30) then
            RenderEngine.start_batch_render(output_directory)
        end
        
        if not can_render then
            reaper.ImGui_EndDisabled(ctx)
        end
        
        -- Status message
        local status = RenderEngine.get_status()
        if status == RenderEngine.STATUS.COMPLETED then
            reaper.ImGui_SameLine(ctx)
            local queue_status = RenderEngine.get_queue_status()
            reaper.ImGui_TextColored(ctx, 0x00FF00FF, 
                string.format("Completed! %d files rendered.", queue_status.completed))
        elseif status == RenderEngine.STATUS.ERROR then
            reaper.ImGui_SameLine(ctx)
            reaper.ImGui_TextColored(ctx, 0xFF0000FF, 
                "Error: " .. RenderEngine.get_last_error())
        end
    end
end

return GUI
