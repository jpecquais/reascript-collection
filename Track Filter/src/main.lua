-- main.lua

reaper.set_action_options(1) -- if script is terminated, it is automatically relaunched.
-- reaper.set_action_options(1|2) -- if script is terminated, it is automatically relaunched.

debug_mode = false

package.path = reaper.ImGui_GetBuiltinPath() .. '/?.lua'
local ImGui = require 'imgui' '0.9.3'
local font = ImGui.CreateFont('sans-serif', 13)
local ctx = ImGui.CreateContext('Track filter')
ImGui.Attach(ctx, font)

local main_path = reaper.GetResourcePath()
local script_path = main_path .. "/Scripts/JLP Scripts"

-- Load track filtering functions
local track_filter = dofile(script_path .. "/Track Filter/src/track_filter.lua")

-- Initialize ImGui
if not reaper.ImGui_GetBuiltinPath then
    return reaper.MB('ReaImGui is not installed or too old.', 'My script', 0)
end


local text = ''
local last_text = ''


-- GUI Section

local function mainWindow()
    local rv
    ImGui.Text(ctx, 'Track filter')
    if reaper.GetExtState("jlp_Track filter", "request_focus") == "true" then
        local window = reaper.JS_Window_Find('Track filter', true)
        reaper.JS_Window_SetFocus(window)
        ImGui.SetKeyboardFocusHere(ctx)
    end
    rv, text = ImGui.InputText(ctx, ' ', text)
    ImGui.SameLine(ctx)
    if ImGui.Button(ctx, "clear") then text = "" end
end


local function PushREAPERStyle(context)
    ImGui.PushStyleColor(ctx, ImGui.Col_Text, 0xFFFFFFFF)
    ImGui.PushStyleColor(ctx, ImGui.Col_TextDisabled, 0x808080FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_WindowBg, 0x333334FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_ChildBg, 0x00000000)
    ImGui.PushStyleColor(ctx, ImGui.Col_PopupBg, 0x141414F0)
    ImGui.PushStyleColor(ctx, ImGui.Col_Border, 0x6E6E8080)
    ImGui.PushStyleColor(ctx, ImGui.Col_BorderShadow, 0x00000000)
    ImGui.PushStyleColor(ctx, ImGui.Col_FrameBg, 0x0D0D0D8A)
    ImGui.PushStyleColor(ctx, ImGui.Col_FrameBgHovered, 0x2D4F46FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_FrameBgActive, 0x2D4F46FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_TitleBg, 0x0A0A0AFF)
    ImGui.PushStyleColor(ctx, ImGui.Col_TitleBgActive, 0x2D4F46FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_TitleBgCollapsed, 0x00000082)
    ImGui.PushStyleColor(ctx, ImGui.Col_MenuBarBg, 0x242424FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_ScrollbarBg, 0x05050587)
    ImGui.PushStyleColor(ctx, ImGui.Col_ScrollbarGrab, 0x4F4F4FFF)
    ImGui.PushStyleColor(ctx, ImGui.Col_ScrollbarGrabHovered, 0x696969FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_ScrollbarGrabActive, 0x828282FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_CheckMark, 0x18BD98FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_SliderGrab, 0x18BD98FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_SliderGrabActive, 0x18BD98FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_Button, 0x1B1B1BFF)
    ImGui.PushStyleColor(ctx, ImGui.Col_ButtonHovered, 0x2D4F46FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_ButtonActive, 0x18BD98FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_Header, 0x18BD98FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_HeaderHovered, 0x18BD98FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_HeaderActive, 0x18BD98FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_Separator, 0x6E6E8080)
    ImGui.PushStyleColor(ctx, ImGui.Col_SeparatorHovered, 0x2D4F46FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_SeparatorActive, 0x2D4F46FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_ResizeGrip, 0x18BD98FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_ResizeGripHovered, 0x18BD98FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_ResizeGripActive, 0x18BD98FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_TabHovered, 0x18BD98FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_Tab, 0x2D4F46FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_TabSelected, 0x2D4F46FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_TabSelectedOverline, 0x18BD98FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_TabDimmed, 0x111A26F8)
    ImGui.PushStyleColor(ctx, ImGui.Col_TabDimmedSelected, 0x23436CFF)
    ImGui.PushStyleColor(ctx, ImGui.Col_TabDimmedSelectedOverline, 0x808080FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_DockingPreview, 0x18BD98FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_DockingEmptyBg, 0x333333FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_PlotLines, 0x9C9C9CFF)
    ImGui.PushStyleColor(ctx, ImGui.Col_PlotLinesHovered, 0xFF6E59FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_PlotHistogram, 0xE6B300FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_PlotHistogramHovered, 0xFF9900FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_TableHeaderBg, 0x303033FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_TableBorderStrong, 0x4F4F59FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_TableBorderLight, 0x3B3B40FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_TableRowBg, 0x00000000)
    ImGui.PushStyleColor(ctx, ImGui.Col_TableRowBgAlt, 0xFFFFFF0F)
    ImGui.PushStyleColor(ctx, ImGui.Col_TextSelectedBg, 0x18BD98FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_DragDropTarget, 0xFFFF00E6)
    ImGui.PushStyleColor(ctx, ImGui.Col_NavHighlight, 0x18BD98FF)
    ImGui.PushStyleColor(ctx, ImGui.Col_NavWindowingHighlight, 0xFFFFFFB3)
    ImGui.PushStyleColor(ctx, ImGui.Col_NavWindowingDimBg, 0xCCCCCC33)
    ImGui.PushStyleColor(ctx, ImGui.Col_ModalWindowDimBg, 0xCCCCCC59)
end


-- Main loop function
local function loop()
    ImGui.PushFont(ctx, font)
    PushREAPERStyle(ctx)
    text = reaper.GetExtState("jlp_Track filter", "text_box")
    ImGui.SetNextWindowSize(ctx, 400, 80, ImGui.Cond_FirstUseEver)
    local visible, open = ImGui.Begin(ctx, 'Track filter', true)
    if visible then
        mainWindow()
        if text ~= last_text then
            track_filter.filter_tracks(text)
            reaper.SetExtState("jlp_Track filter", "text_box", text, false)
        end
        if ImGui.Shortcut(ctx, ImGui.Key_Escape) then text = "" end
        ImGui.End(ctx)
    end
    ImGui.PopFont(ctx)
    ImGui.PopStyleColor(ctx, 57)
    reaper.TrackList_AdjustWindows(false)
    reaper.SetExtState("jlp_Track filter", "request_focus", "false", false)
    last_text = text

    if open then
        reaper.defer(loop)
    end
end

reaper.defer(loop)
