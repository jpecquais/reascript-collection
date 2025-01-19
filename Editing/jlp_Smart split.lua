local item_under_mouse, _ = reaper.BR_ItemAtMouseCursor()
if item_under_mouse == nil then
    --split at edit cursor
    reaper.Main_OnCommand(40759,0)
else
    --split at mouse cursor
    reaper.Main_OnCommand(42577,0)
end