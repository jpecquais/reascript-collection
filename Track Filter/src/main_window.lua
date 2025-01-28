-- @version 25.01.27
-- @author JLP

--load ImGui
package.path = reaper.ImGui_GetBuiltinPath() .. '/?.lua'
local ImGui = require 'imgui' '0.9.3'

local main_path = reaper.GetResourcePath()
local script_path = main_path .. "/Scripts/JLP Scripts"
local utils = dofile(script_path .. "/Common/utils.lua")
---------------------------------------------
---CLASS MAIN_WINDOW
---------------------------------------------
local Main_Window = {}
Main_Window.__index = Main_Window

-- Constructor
function Main_Window:new()
    local new_instance = setmetatable({},Main_Window)
    
    -- Attributes
    new_instance.text_field = ""
    new_instance.ctx = ImGui.CreateContext('Track filter')
    new_instance.font = ImGui.CreateFont('sans-serif', 13)
    ImGui.Attach(new_instance.ctx, new_instance.font)
    
    new_instance.is_focus_requested = false
    new_instance.is_open = false
    new_instance.action_buffer = ""

    new_instance.modifiers = {
        items_state  = false,
        solo_state   = false,
        mute_state   = false,
        recarm_state = false
    }
    
    new_instance._callback = function(text) return nil end
    ImGui.SetNextWindowSize(new_instance.ctx, 400, 80, ImGui.Cond_FirstUseEver)
    
    return new_instance
end

-- Methods

function Main_Window:push_style()
    local ctx = self.ctx
    ImGui.PushFont(ctx, self.font)
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

function Main_Window:set_text(new_text)
    self.text_field = new_text
end

function Main_Window:get_text()
    return self.text_field
end

function Main_Window:perform_action(action)
    utils.debug(action)
    if action == "items" then
        self.modifiers.items_state = true
    end
end

function Main_Window:on_text_change(text_has_change,text)
    if text_has_change then
        self.text_field = text
        local is_action, action = self:check_string_is_command(text)
        if is_action then
            self.action_buffer = action
        else 
            self:callback()
        end
    end
end

function Main_Window:on_checkbox_has_changed(has_been_pressed, new_value, checkbox_id)
    if has_been_pressed then
        self.modifiers[checkbox_id] = new_value
        self:callback()
    end
end

function Main_Window:get_modifier_buttons()
    return self.modifiers
end

function Main_Window:callback()
    self._callback(self.text_field)
end

function Main_Window:check_string_is_command(s)
    local char = s:sub(1, 1)
    local is_action, action = false, nil
    if char == "/" then
        is_action = true
        action = s:sub(2,-1)
    end
    return is_action, action
end

function Main_Window:on_clear_button(is_button_pressed)
    if is_button_pressed then
        self:clear_filters()
        self:clear_modifiers()
        self:callback()
    end
end

function Main_Window:on_escape_key(is_key_down)
    if is_key_down then self:clear_filter() end
end

function Main_Window:on_enter_key(is_key_down)
    if is_key_down then
        utils.debug(self.action_buffer)
        self:perform_action(self.action_buffer)
        self:clear_filters()
    end
end

function Main_Window:clear_filters()
    self.text_field = ""
end

function Main_Window:clear_modifiers()
    self.modifiers.items_state = false
    self.modifiers.solo_state = false
    self.modifiers.mute_state = false
    self.modifiers.recarm_state = false
end

function Main_Window:request_focus()
    self.is_focus_requested = true
end

function Main_Window:on_request_focus()
    if self.is_focus_requested then self:set_focus() end
end

function Main_Window:set_callback(new_callback)
    self._callback = new_callback
end

function Main_Window:set_focus()
    local window = reaper.JS_Window_Find('Track filter', true)
    reaper.JS_Window_SetFocus(window)
    ImGui.SetKeyboardFocusHere(self.ctx)
    self.is_focus_requested = false
end

function Main_Window:draw()
    
    self:push_style()

    local visible, open = ImGui.Begin(self.ctx, 'Track filter', true)
    if visible then
        ImGui.Text(self.ctx, 'Track filter')
        -- ImGui.SameLine(self.ctx)

        local has_changed, new_value = ImGui.Checkbox(self.ctx, "items",self.modifiers.items_state)
        self:on_checkbox_has_changed(has_changed, new_value ,"items_state")
        ImGui.SameLine(self.ctx)

        has_changed, new_value = ImGui.Checkbox(self.ctx, "solo", self.modifiers.solo_state)
        self:on_checkbox_has_changed(has_changed, new_value ,"solo_state")
        ImGui.SameLine(self.ctx)
        
        has_changed, new_value =  ImGui.Checkbox(self.ctx, "mute", self.modifiers.mute_state)
        self:on_checkbox_has_changed(has_changed, new_value ,"mute_state")
        ImGui.SameLine(self.ctx)
        has_changed, new_value =  ImGui.Checkbox(self.ctx, "rec arm", self.modifiers.recarm_state)
        self:on_checkbox_has_changed(has_changed, new_value ,"recarm_state")

        self:on_request_focus()

        self:on_text_change(ImGui.InputText(self.ctx, ' ', self.text_field))
    
        ImGui.SameLine(self.ctx)
        self:on_clear_button(ImGui.Button(self.ctx, "clear"))

        ImGui.End(self.ctx)
    end

    ImGui.PopFont(self.ctx)
    ImGui.PopStyleColor(self.ctx, 57)

    self.is_open = open
end

function Main_Window:process_shortcuts()
    self:on_escape_key(ImGui.Shortcut(self.ctx, ImGui.Key_Escape))
    self:on_enter_key(ImGui.Shortcut(self.ctx, ImGui.Key_Enter))
end

local function make_main_window()
    return Main_Window:new()
end

return make_main_window
