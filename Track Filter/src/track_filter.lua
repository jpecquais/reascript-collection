-- track_filter.lua

-- Load utility functions
local main_path = reaper.GetResourcePath()
local script_path = main_path .. "/Scripts/JLP Scripts"
local utils = dofile(script_path .. "/Common/utils.lua")
local function tracks_fit_tcp()
    dofile(script_path.."/View/jlp_Visible tracks fit TCP width.lua")
end

-- Create a namespace for track filtering functions
local track_filter = {}

-- Check if any pattern matches the track name
function track_filter.does_pattern_match_track_name(patterns, tr_name, is_case_sensitive, default_match_case)
    if next(patterns) == nil then return default_match_case end

    local match_is_found = false
    for _, pattern in ipairs(patterns) do
        if not is_case_sensitive then pattern = string.lower(pattern) end
        if not is_case_sensitive then tr_name = string.lower(tr_name) end
        if tr_name:find(pattern, 0, false) ~= nil then
            match_is_found = true
            break
        end
    end

    return match_is_found
end

-- Recursively match tracks by folders based on patterns
function track_filter.recursively_match_tracks_by_patterns(patterns, is_case_sensitive, show_parent_tracks, show_child_tracks, start_index, folder_depth)
    show_parent_tracks = show_parent_tracks or true
    show_child_tracks = show_child_tracks or true
    is_case_sensitive = is_case_sensitive or false
    start_index = start_index or 0
    folder_depth = folder_depth or 0

    local matching_tracks = {}
    local non_matching_tracks = {}

    local num_tr = reaper.CountTracks(0)
    local default_match_case = next(patterns) == nil
    local last_tr_idx = 0
    local new_folder_depth = 0

    local i = start_index
    while i < num_tr do
        utils.debug(i .. ": ")
        local tr = reaper.GetTrack(0, i)
        local tr_folder_depth = reaper.GetMediaTrackInfo_Value(tr, "I_FOLDERDEPTH")
        new_folder_depth = folder_depth + tr_folder_depth
        last_tr_idx = i

        utils.debug_get_tr_name(tr)
        utils.debug(" ")
        utils.debug(new_folder_depth .. " ")
        local _, tr_name = reaper.GetSetMediaTrackInfo_String(tr, "P_NAME", "", false)
        local match_found = track_filter.does_pattern_match_track_name(patterns, tr_name, is_case_sensitive, default_match_case)

        local child_matching_tracks, child_non_matching_tracks = {}, {}
        if tr_folder_depth == 1 then

            utils.debug("Enter folder\n")
            local return_idx, return_folder_depth
            local patterns_for_children = patterns
            if match_found and show_child_tracks then
                patterns_for_children = {}
            end
            child_matching_tracks, child_non_matching_tracks, return_idx, return_folder_depth = track_filter.recursively_match_tracks_by_patterns(
                patterns_for_children, is_case_sensitive, show_parent_tracks, show_child_tracks, i + 1, new_folder_depth
            )
            utils.join_tables(matching_tracks, child_matching_tracks)
            utils.join_tables(non_matching_tracks, child_non_matching_tracks)
            i = return_idx
            last_tr_idx = i

            utils.debug(return_folder_depth .. " ")
            new_folder_depth = return_folder_depth

        end

        utils.debug(tostring(match_found) .. " ")

        if match_found or ((next(child_matching_tracks) ~= nil) and show_parent_tracks) then
            table.insert(matching_tracks, tr)
        else
            table.insert(non_matching_tracks, tr)
        end

        if new_folder_depth < folder_depth then break end
        i = i + 1

    end

    return matching_tracks, non_matching_tracks, last_tr_idx, new_folder_depth

end

-- Filter tracks based on patterns and update visibility
function track_filter.filter_tracks(patterns, is_case_sensitive, show_parent_tracks, show_child_tracks, is_tcp_filtered, is_mcp_filtered)
    show_parent_tracks = show_parent_tracks or false
    show_child_tracks = show_child_tracks or false
    is_case_sensitive = is_case_sensitive or false
    is_tcp_filtered = is_tcp_filtered or true
    is_mcp_filtered = is_mcp_filtered or false

    local matching_tracks, non_matching_tracks = track_filter.recursively_match_tracks_by_patterns(utils.split_patterns(patterns),is_case_sensitive, show_parent_tracks, show_child_tracks)

    for _, tr in ipairs(matching_tracks) do
        local _, name = reaper.GetSetMediaTrackInfo_String(tr, "P_NAME", "", false)
        reaper.SetMediaTrackInfo_Value(tr, "B_SHOWINTCP", 1)
        reaper.SetMediaTrackInfo_Value(tr, "B_SHOWINMIXER", 1)
    end
    for _, tr in ipairs(non_matching_tracks) do
        reaper.SetMediaTrackInfo_Value(tr, "B_SHOWINTCP", 0)
        reaper.SetMediaTrackInfo_Value(tr, "B_SHOWINMIXER", 0)
    end

    tracks_fit_tcp()
end

return track_filter