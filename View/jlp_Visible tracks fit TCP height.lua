-- @author JLP
-- @version 25.01.27
-- @description Visible tracks fit TCP height
-- @changelog
--     Initial release

local function get_visible_tr_in_mcp()
    local num_tr = reaper.CountTracks(0)
    local visible_tr = {}
    for i=0, num_tr-1 do
        local tr = reaper.GetTrack(0,i)
        local is_visible_in_mcp = reaper.GetMediaTrackInfo_Value(tr,"B_SHOWINTCP") == 1
        local tr_folder_depth = reaper.GetMediaTrackInfo_Value(tr,"I_FOLDERDEPTH")
        local is_collpased = false
        local parent_track = reaper.GetParentTrack(tr)
        while parent_track ~= nil do
            is_collpased = reaper.GetMediaTrackInfo_Value(parent_track,"I_FOLDERCOMPACT") == 2
            if is_collpased then break end
            parent_track = reaper.GetParentTrack(parent_track)
        end
        if is_visible_in_mcp and not is_collpased then table.insert(visible_tr,tr) end
    end
    return visible_tr
end

local function compute_track_height_in_TCP(num_shown_tr)
    local arrange = reaper.JS_Window_FindChildByID(reaper.GetMainHwnd(), 0x3E8)
    local _, left, top, right, bottom = reaper.JS_Window_GetClientRect(arrange)
    return math.abs((bottom-top)/num_shown_tr)
end

local function set_track_height(tr, new_height)
    local current_height_wth_envelop = reaper.GetMediaTrackInfo_Value(tr,"I_WNDH")
    local current_height = reaper.GetMediaTrackInfo_Value(tr,"I_TCPH")
    local track_height = new_height - (current_height_wth_envelop-current_height)
    reaper.SetMediaTrackInfo_Value(tr, "I_HEIGHTOVERRIDE", track_height)
end

local function main()
    local visible_tr = get_visible_tr_in_mcp()
    local track_height = compute_track_height_in_TCP(#visible_tr)
    for _, tr in ipairs(visible_tr) do
        set_track_height(tr,track_height)
    end
end

main()