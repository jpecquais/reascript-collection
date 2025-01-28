-- @author JLP
-- @version 25.01.27
-- @description On key - right arrow
-- @noindex

local main_path = reaper.GetResourcePath()
local script_path = main_path.."/Scripts/JLP Scripts"
local function select_next_visible_track_in_mcp()
    dofile(script_path.."/Navigation/jlp_Select next visible track in MCP.lua")
end
local winUnderMouse, segUnderMouse, detUnderMouse = reaper.BR_GetMouseCursorContext()
--print(winUnderMouse)

if winUnderMouse == "arrange" then
    -- getNextItemOnSelTr()
    reaper.Main_OnCommandEx(reaper.NamedCommandLookup("_SWS_SELNEXTITEM"), 0, 0) -- select next item
elseif winUnderMouse == "ruler" then
    -- setEditCursorToNextMarker()
elseif winUnderMouse == "mcp" then
    select_next_visible_track_in_mcp()
elseif winUnderMouse == "tcp" then
    reaper.Main_OnCommandEx(reaper.NamedCommandLookup("_SWS_UNCOLLAPSE"), 0, 0) -- cycle collapse folder
end
