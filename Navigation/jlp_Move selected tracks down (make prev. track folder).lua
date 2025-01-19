local main_path = reaper.GetResourcePath()
local script_path = main_path.."/Scripts/JLP Scripts"
local navigation = dofile(script_path.."/Navigation/lib/navigation.lua")

reaper.Undo_BeginBlock2(0)
local num_sel_tr = reaper.CountSelectedTracks(0)
navigation.move_selected_tracks_relative_to_last_touched_track(num_sel_tr+1,true)
reaper.Undo_EndBlock2(0,"Move selected tracks down (make prev. track folder)",0)