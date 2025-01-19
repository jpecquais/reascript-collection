--Script Name : ArrowRight.lua
--Author : Jean Loup Pecquais
--Description : take care of right arrow action depending of context
--v1.0.0

local main_path = reaper.GetResourcePath()
local script_path = main_path.."/Scripts/JLP Scripts"
local function select_previous_visible_track_in_tcp()
    dofile(script_path.."/Navigation/jlp_Select previous visible track in TCP.lua")
end
local winUnderMouse, segUnderMouse, detUnderMouse = reaper.BR_GetMouseCursorContext()

if winUnderMouse == "arrange" then
    -- reaper.Main_OnCommandEx(reaper.NamedCommandLookup("_SWS_SELPREVITEM"), 0, 0) -- select prev item
    -- selectPrevVisibleTrack_JumpIfNoItems()
elseif winUnderMouse == "ruler" then
    --
elseif winUnderMouse == "mcp" then
    reaper.Main_OnCommandEx(41665, 0, 0) -- show/hide children
elseif winUnderMouse == "tcp" then
    select_previous_visible_track_in_tcp()
end
