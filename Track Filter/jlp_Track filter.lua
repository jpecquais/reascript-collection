local main_path = reaper.GetResourcePath()
local script_path = main_path .. "/Scripts/JLP Scripts"
dofile(script_path.."/Track Filter/src/main.lua")


-- OLD STUFF____________________________________________________________________________
-- reaper.set_action_options(1) --if script is terminated, it is automatically relaunched.
-- -- reaper.set_action_options(1|2) --if script is terminated, it is automatically relaunched.

-- debug_mode = false

-- local main_path = reaper.GetResourcePath()
-- local script_path = main_path.."/Scripts/JLP Scripts"

-- local function tracks_fit_mpc()
--     dofile(script_path.."/View/jlp_Visible tracks fit TCP width.lua")
-- end


-- local function debug(msg)
--     if debug_mode then reaper.ShowConsoleMsg(msg) end
-- end

-- local function debug_get_tr_name(tr)
--     local _, name = reaper.GetSetMediaTrackInfo_String(tr,"P_NAME","",false)
--     debug(name)
-- end

-- debug("")

-- if not reaper.ImGui_GetBuiltinPath then
--     return reaper.MB('ReaImGui is not installed or too old.', 'My script', 0)
-- end

-- package.path = reaper.ImGui_GetBuiltinPath() .. '/?.lua'
-- local ImGui = require 'imgui' '0.9.3'
-- local font = ImGui.CreateFont('sans-serif', 13)
-- local ctx = ImGui.CreateContext('Track filter')
-- ImGui.Attach(ctx, font)

-- local text = ''
-- local last_text = ''

-- function PushREAPERStyle(context)
--     ImGui.PushStyleColor(ctx, ImGui.Col_Text,                      0xFFFFFFFF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_TextDisabled,              0x808080FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_WindowBg,                  0x333334FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_ChildBg,                   0x00000000)
--     ImGui.PushStyleColor(ctx, ImGui.Col_PopupBg,                   0x141414F0)
--     ImGui.PushStyleColor(ctx, ImGui.Col_Border,                    0x6E6E8080)
--     ImGui.PushStyleColor(ctx, ImGui.Col_BorderShadow,              0x00000000)
--     ImGui.PushStyleColor(ctx, ImGui.Col_FrameBg,                   0x0D0D0D8A)
--     ImGui.PushStyleColor(ctx, ImGui.Col_FrameBgHovered,            0x2D4F46FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_FrameBgActive,             0x2D4F46FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_TitleBg,                   0x0A0A0AFF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_TitleBgActive,             0x2D4F46FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_TitleBgCollapsed,          0x00000082)
--     ImGui.PushStyleColor(ctx, ImGui.Col_MenuBarBg,                 0x242424FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_ScrollbarBg,               0x05050587)
--     ImGui.PushStyleColor(ctx, ImGui.Col_ScrollbarGrab,             0x4F4F4FFF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_ScrollbarGrabHovered,      0x696969FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_ScrollbarGrabActive,       0x828282FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_CheckMark,                 0x18BD98FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_SliderGrab,                0x18BD98FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_SliderGrabActive,          0x18BD98FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_Button,                    0x1B1B1BFF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_ButtonHovered,             0x2D4F46FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_ButtonActive,              0x18BD98FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_Header,                    0x18BD98FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_HeaderHovered,             0x18BD98FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_HeaderActive,              0x18BD98FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_Separator,                 0x6E6E8080)
--     ImGui.PushStyleColor(ctx, ImGui.Col_SeparatorHovered,          0x2D4F46FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_SeparatorActive,           0x2D4F46FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_ResizeGrip,                0x18BD98FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_ResizeGripHovered,         0x18BD98FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_ResizeGripActive,          0x18BD98FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_TabHovered,                0x18BD98FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_Tab,                       0x2D4F46FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_TabSelected,               0x2D4F46FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_TabSelectedOverline,       0x18BD98FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_TabDimmed,                 0x111A26F8)
--     ImGui.PushStyleColor(ctx, ImGui.Col_TabDimmedSelected,         0x23436CFF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_TabDimmedSelectedOverline, 0x808080FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_DockingPreview,            0x18BD98FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_DockingEmptyBg,            0x333333FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_PlotLines,                 0x9C9C9CFF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_PlotLinesHovered,          0xFF6E59FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_PlotHistogram,             0xE6B300FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_PlotHistogramHovered,      0xFF9900FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_TableHeaderBg,             0x303033FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_TableBorderStrong,         0x4F4F59FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_TableBorderLight,          0x3B3B40FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_TableRowBg,                0x00000000)
--     ImGui.PushStyleColor(ctx, ImGui.Col_TableRowBgAlt,             0xFFFFFF0F)
--     ImGui.PushStyleColor(ctx, ImGui.Col_TextSelectedBg,            0x18BD98FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_DragDropTarget,            0xFFFF00E6)
--     ImGui.PushStyleColor(ctx, ImGui.Col_NavHighlight,              0x18BD98FF)
--     ImGui.PushStyleColor(ctx, ImGui.Col_NavWindowingHighlight,     0xFFFFFFB3)
--     ImGui.PushStyleColor(ctx, ImGui.Col_NavWindowingDimBg,         0xCCCCCC33)
--     ImGui.PushStyleColor(ctx, ImGui.Col_ModalWindowDimBg,          0xCCCCCC59)

    
-- end

-- local function split_string(inputstr,separator)
--     local t = {}
--     for elem in (inputstr..separator):gmatch("([^"..separator.."]+)"..separator) do table.insert(t, elem) end
--     return t
-- end

-- local function split_patterns(inputstr)
--     return split_string(inputstr,";")
-- end

-- local function join_tables(t1, t2)
--     return table.move(t2,1,#t2,#t1+1,t1)
-- end

-- local function patterns_match(patterns, tr_name, is_case_sensitive, default_match_case)
--     if next(patterns) == nil then return default_match_case end

--     local match_is_found = false
--     for _, pattern in ipairs(patterns) do
--         if not is_case_sensitive then pattern = string.lower(pattern) end
--         if not is_case_sensitive then tr_name = string.lower(tr_name) end
--         if tr_name:find(pattern, 0, false) ~= nil then
--             match_is_found = true
--             break
--         end
--     end

--     return match_is_found
-- end

-- local function match_tracks_by_folders(patterns, is_case_sensitive, are_parent_tracks_shown, are_children_tracks_shown, start_index, folder_depth)
--     are_parent_tracks_shown = are_parent_tracks_shown or true
--     are_children_tracks_shown = are_children_tracks_shown or true
--     is_case_sensitive = is_case_sensitive or false
--     start_index = start_index or 0
--     folder_depth = folder_depth or 0

--     local tracks_to_show = {}
--     local tracks_to_hide = {}

--     local num_tr = reaper.CountTracks(0)
--     local default_match_case = next(patterns) == nil
--     local last_tr_idx = 0
--     local new_folder_depth = 0

--     local i = start_index
--     while i < num_tr do
--         debug(i..": ")
--         local tr = reaper.GetTrack(0, i)
--         local tr_folder_depth = reaper.GetMediaTrackInfo_Value(tr, "I_FOLDERDEPTH")
--         new_folder_depth = folder_depth + tr_folder_depth
--         last_tr_idx = i

--         debug_get_tr_name(tr)
--         debug(" ")
--         debug(new_folder_depth.." ")
--         local _, tr_name = reaper.GetSetMediaTrackInfo_String(tr, "P_NAME", "", false)
--         local match_found = patterns_match(patterns, tr_name, is_case_sensitive, default_match_case)

--         local child_tracks_to_show, child_tracks_to_hide = {}, {}
--         if tr_folder_depth == 1 then

--             debug("Enter folder\n")
--             local return_idx, return_folder_depth
--             local patterns_for_children = patterns
--             if match_found and are_children_tracks_shown then
--                 patterns_for_children = {}
--             end
--             child_tracks_to_show, child_tracks_to_hide, return_idx, return_folder_depth = match_tracks_by_folders(
--                 patterns_for_children, is_case_sensitive, are_parent_tracks_shown, are_children_tracks_shown, i + 1, new_folder_depth
--             )
--             join_tables(tracks_to_show, child_tracks_to_show)
--             join_tables(tracks_to_hide, child_tracks_to_hide)
--             i = return_idx
--             last_tr_idx = i

--             debug(return_folder_depth.." ")
--             new_folder_depth = return_folder_depth

--         end

--         debug(tostring(match_found).." ")
        
--         if match_found or ((next(child_tracks_to_show) ~= nil) and are_parent_tracks_shown) then
--             table.insert(tracks_to_show, tr)
--         else
--             table.insert(tracks_to_hide, tr)
--         end

--         if new_folder_depth < folder_depth then break end
--         i = i + 1

--     end

--     return tracks_to_show, tracks_to_hide, last_tr_idx, new_folder_depth

-- end

-- local function filter_tracks(patterns,is_case_sensitive,is_tcp_filtered,is_mcp_filtered,are_parent_tracks_shown,are_child_tracks_shown)
--     are_parent_tracks_shown = are_parent_tracks_shown or false
--     are_child_tracks_shown = are_child_tracks_shown or false
--     is_case_sensitive = is_case_sensitive or false
--     is_tcp_filtered = is_tcp_filtered or true
--     is_mcp_filtered = is_mcp_filtered or false

--     local tracks_to_show, tracks_to_hide = match_tracks_by_folders(split_patterns(patterns))

--     for _, tr in ipairs(tracks_to_show) do
--         local _, name = reaper.GetSetMediaTrackInfo_String(tr,"P_NAME","",false)
--         reaper.SetMediaTrackInfo_Value(tr,"B_SHOWINTCP",1)
--         reaper.SetMediaTrackInfo_Value(tr,"B_SHOWINMIXER",1)
--     end
--     for _, tr in ipairs(tracks_to_hide) do
--         reaper.SetMediaTrackInfo_Value(tr,"B_SHOWINTCP",0)
--         reaper.SetMediaTrackInfo_Value(tr,"B_SHOWINMIXER",0)
--     end

--     tracks_fit_mpc()

-- end



-- local function mainWindow()
--     local rv
--     ImGui.Text(ctx, 'Track filter')
--     if reaper.GetExtState("jlp_Track filter","request_focus") == "true" then
--         local window = reaper.JS_Window_Find('Track filter', true)
--         reaper.JS_Window_SetFocus(window)
--         ImGui.SetKeyboardFocusHere(ctx)
--     end
--     rv, text = ImGui.InputText(ctx, ' ', text)
--     ImGui.SameLine(ctx)
--     if ImGui.Button(ctx,"clear") then text = "" end
-- end

-- local function loop()
--     ImGui.PushFont(ctx, font)
--     PushREAPERStyle(ctx)
--     text = reaper.GetExtState("jlp_Track filter","text_box")
--     ImGui.SetNextWindowSize(ctx, 400, 80, ImGui.Cond_FirstUseEver)
--     local visible, open = ImGui.Begin(ctx, 'Track filter', true)
--     if visible then
--         mainWindow()
--         if text ~= last_text then
--             filter_tracks(text)
--             reaper.SetExtState("jlp_Track filter","text_box",text,false)
--         end
--         if ImGui.Shortcut(ctx, ImGui.Key_Escape) then text="" end
--         ImGui.End(ctx)
--     end
--     ImGui.PopFont(ctx)  
--     ImGui.PopStyleColor(ctx, 57)
--     reaper.TrackList_AdjustWindows(false)
--     reaper.SetExtState("jlp_Track filter","request_focus","false",false)
--     last_text = text

--     if open then
--         reaper.defer(loop)
--     end
-- end

-- reaper.defer(loop)
