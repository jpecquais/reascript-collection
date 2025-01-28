-- @description Track filter: Push the selected track's name to text input of the track filter utility.
-- @version 25.01.27
-- @author JLP
-- @noindex
-- @changelog
--     Initial release


local sel_tr = reaper.CountSelectedTracks(0)
local filters = ""
for i=0, sel_tr-1 do
    local tr = reaper.GetSelectedTrack(0, i)
    local _, tr_name = reaper.GetSetMediaTrackInfo_String(tr,"P_NAME","",false)
    filters = filters..tr_name..";"
end

reaper.SetExtState("jlp_Track filter","text_box",filters,false)