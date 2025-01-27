-- @author JLP
-- @version 25.01.27
-- @description Insert paste items
-- @noindex
-- NoIndex: true

local start, finish = reaper.GetSet_LoopTimeRange(false, false, 0, 0, false)
local flag = 0

turn_on_global_ripple_edit = 40311
turn_off_ripple_edit = 40309
paste_items_tracks = 42398
remove_content_time_selection = 40201

reaper.Main_OnCommand(turn_on_global_ripple_edit, flag)

if start ~= finish then
    reaper.SetEditCurPos(start, true, false)
    reaper.Main_OnCommand(remove_content_time_selection, flag)
end

reaper.Main_OnCommand(paste_items_tracks, flag)
reaper.Main_OnCommand(turn_off_ripple_edit, flag)