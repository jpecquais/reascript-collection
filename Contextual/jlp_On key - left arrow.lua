-- @author JLP
-- @version 25.01.27
-- @description On key - left arrow
-- @noindex

local main_path = reaper.GetResourcePath()
local script_path = main_path.."/Scripts/JLP Scripts"
local function select_previous_visible_track_in_mcp()
    dofile(script_path.."/Navigation/jlp_Select previous visible track in MCP.lua")
end

local winUnderMouse, segUnderMouse, detUnderMouse = reaper.BR_GetMouseCursorContext()

if winUnderMouse == "arrange" then
    -- getPrevItemOnSelTr()
    reaper.Main_OnCommandEx(reaper.NamedCommandLookup("_SWS_SELPREVITEM"), 0, 0) -- select prev item
elseif winUnderMouse == "ruler" then
    -- setEditCursorToPrevMarker()
elseif winUnderMouse == "mcp" then
    select_previous_visible_track_in_mcp()
elseif winUnderMouse == "tcp" then
    reaper.Main_OnCommandEx(reaper.NamedCommandLookup("_SWS_COLLAPSE"), 0, 0) -- cycle collapse folder
end
