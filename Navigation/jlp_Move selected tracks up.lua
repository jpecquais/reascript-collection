-- @author JLP
-- @version 25.01.27
-- @description Move selected tracks up
-- @changelog
--     Initial release

local main_path = reaper.GetResourcePath()
local script_path = main_path.."/Scripts/JLP Scripts"
local navigation = dofile(script_path.."/Navigation/lib/navigation.lua")

reaper.Undo_BeginBlock2(0)
navigation.move_selected_tracks_relative_to_last_touched_track(-1)
reaper.Undo_EndBlock2(0,"Move selected tracks up",0)