-- track_filter.lua

-- Load utility functions
local main_path = reaper.GetResourcePath()
local script_path = main_path .. "/Scripts/JLP Scripts"
local utils = dofile(script_path .. "/Common/utils.lua")
local function tracks_fit_tcp()
    dofile(script_path.."/View/jlp_Visible tracks fit TCP width.lua")
end

-- table thas host specific patterns
local MAGIC_PATTERNS = {
    "$SOLO",
    "$MUTE",
    "$REC",
    "$ITEMS"
}
-- Create a namespace for track filtering functions
local Track_Filter = {}
Track_Filter.__index = Track_Filter

function Track_Filter:new()
    local new_instance = setmetatable({},Track_Filter)

    -- Attributes
        -- Options
    new_instance.show_parent_tracks = true
    new_instance.show_child_tracks  = true
    new_instance.is_case_sensitive  = false
    new_instance.is_tcp_filtered    = true
    new_instance.is_mcp_filtered    = true

        -- Modifier
    new_instance.modifiers = {}

    return new_instance
end

function Track_Filter:bind_modifers(t)
    self.modifiers = t
end

function Track_Filter:set_show_parent_tracks(new_value)
    self.show_parent_tracks = new_value
end

function Track_Filter:set_show_child_tracks(new_value)
    self.show_child_tracks = new_value
end

function Track_Filter:set_is_case_sensitive(new_value)
    self.is_case_sensitive = new_value
end

function Track_Filter:set_show_tracks_with_items(new_value)
    self.show_tracks_with_items = new_value
end

function Track_Filter:set_show_tracks_in_solo(new_value)
    self.show_tracks_in_solo = new_value
end

function Track_Filter:set_show_tracks_in_mute(new_value)
    self.show_tracks_in_mute = new_value
end

function Track_Filter:set_show_tracks_in_recarm(new_value)
    self.show_tracks_in_recarm = new_value
end

-- Extract Magic Patterns
local function get_magic_patterns_from_patterns(patterns)
    local founded_magic_patterns = {}
    local residue_patterns = patterns
    for index, pattern in ipairs(residue_patterns) do
        for _, magic_pattern in ipairs(MAGIC_PATTERNS) do
            if pattern == magic_pattern then
                table.insert(founded_magic_patterns,magic_pattern)
                table.remove(residue_patterns,index)
                break
            end
        end
    end
    return founded_magic_patterns, residue_patterns
end

-- Check if any pattern matches the track name
function Track_Filter:does_pattern_match_track_name(tr, patterns, is_case_sensitive)
    if next(patterns) == nil then return true end

    local _, tr_name = reaper.GetSetMediaTrackInfo_String(tr, "P_NAME", "", false)

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

function Track_Filter:does_track_state_match_track(tr, track_state)
    local state = reaper.GetMediaTrackInfo_Value(tr,track_state)
    return state > 0
end

function Track_Filter:does_track_has_items(tr)
    return reaper.CountTrackMediaItems(tr) > 0
end

function Track_Filter:match_by_name(patterns, is_case_sensitive)
    return function(tr)
        return self:does_pattern_match_track_name(tr, patterns, is_case_sensitive)
    end
end

function Track_Filter:match_by_track_state(track_state)
    return function(tr)
        return self:does_track_state_match_track(tr,track_state)
    end
end

function Track_Filter:match_by_track_has_items()
    return function(tr)
        return self:does_track_has_items(tr)
    end
end

function Track_Filter:always_match()
    return function(tr)
        return true
    end
end

-- Recursively match tracks by folders based on patterns
function Track_Filter:recursively_match_tracks_by_patterns(matching_function, start_index, folder_depth)
    start_index = start_index or 0
    folder_depth = folder_depth or 0

    local matching_tracks = {}
    local non_matching_tracks = {}

    local num_tr = reaper.CountTracks(0)
    local last_tr_idx = 0
    local new_folder_depth = 0

    local i = start_index
    while i < num_tr do
        -- utils.debug(i .. ": ")
        local tr = reaper.GetTrack(0, i)
        local tr_folder_depth = reaper.GetMediaTrackInfo_Value(tr, "I_FOLDERDEPTH")
        new_folder_depth = folder_depth + tr_folder_depth
        last_tr_idx = i

        -- utils.debug_get_tr_name(tr)
        -- utils.debug(" ")
        -- utils.debug(new_folder_depth .. " ")
        local match_found = matching_function(tr)

        local child_matching_tracks, child_non_matching_tracks = {}, {}

        if tr_folder_depth == 1 then

            -- utils.debug("Enter folder\n")
            local return_idx, return_folder_depth
            local matching_function_for_children = matching_function
            
            if match_found and self.show_child_tracks then
                -- utils.debug("\n showing children")
                matching_function_for_children = function() return self:always_match() end
            end
            child_matching_tracks, child_non_matching_tracks, return_idx, return_folder_depth = self:recursively_match_tracks_by_patterns(
                matching_function_for_children, i + 1, new_folder_depth
            )
            utils.join_tables(matching_tracks, child_matching_tracks)
            utils.join_tables(non_matching_tracks, child_non_matching_tracks)
            i = return_idx
            last_tr_idx = i

            -- utils.debug(return_folder_depth .. " ")
            new_folder_depth = return_folder_depth

        end

        -- utils.debug(tostring(match_found) .. " ")

        if match_found or ((next(child_matching_tracks) ~= nil) and self.show_parent_tracks) then
            table.insert(matching_tracks, tr)
        else
            table.insert(non_matching_tracks, tr)
        end

        if new_folder_depth < folder_depth then break end
        i = i + 1

    end

    return matching_tracks, non_matching_tracks, last_tr_idx, new_folder_depth

end

function Track_Filter:post_filter(tracks)
    if not self.modifiers.items_state and not self.modifiers.solo_state then return tracks, {} end

    local matching_tracks, non_matching_tracks = tracks, {}
    for i, tr in ipairs(matching_tracks) do
        local tr_has_item = reaper.CountTrackMediaItems(tr) > 0 
        local tr_is_solo = reaper.GetMediaTrackInfo_Value(tr,"I_SOLO") > 0
        -- local tr_is_mute
        -- local tr_is_recarm
        
        -- utils.debug(self.modifiers)
        
        if (not tr_has_item and self.modifiers.items_state) or (not tr_is_solo and self.modifiers.solo_state) then
            table.insert(non_matching_tracks,table.remove(matching_tracks,i))
        -- elseif not tr_is_solo then 
        --     table.insert(non_matching_tracks,table.remove(matching_tracks,i))
        -- elseif not tr_is_mute then 
        --     table.insert(non_matching_tracks,table.remove(matching_tracks,i))
        -- elseif not tr_is_recarm then
        --     table.insert(non_matching_tracks,table.remove(matching_tracks,i))
        end
    end
    return matching_tracks, non_matching_tracks
end

-- Filter tracks based on patterns and update visibility
function Track_Filter:filter_tracks(string_input)

    -- local magic_patterns, residue_patterns = get_magic_patterns_from_patterns(patterns)

    -- local matching_tracks, non_matching_tracks = {}, {}

    -- if #magic_patterns>0 then
    --     for _, magic_pattern in ipairs(magic_patterns) do
    --         local magic_matching_tracks, non_magic_matching_track = {}, {}
    --         if magic_pattern == "$SOLO"  then magic_matching_tracks, non_magic_matching_track = track_filter.recursively_match_tracks_by_patterns(track_filter.match_by_track_state("I_SOLO"),  false,false)
    --         elseif magic_pattern == "$MUTE"  then magic_matching_tracks, non_magic_matching_track = track_filter.recursively_match_tracks_by_patterns(track_filter.match_by_track_state("B_MUTE"),  false,false)
    --         elseif magic_pattern == "$REC"   then magic_matching_tracks, non_magic_matching_track = track_filter.recursively_match_tracks_by_patterns(track_filter.match_by_track_state("I_RECARM"),false,false)
    --         elseif magic_pattern == "$ITEMS"  then magic_matching_tracks, non_magic_matching_track = track_filter.recursively_match_tracks_by_patterns(track_filter.match_by_track_has_items(),      false,false) end
    --         matching_tracks = utils.join_tables(matching_tracks,magic_matching_tracks)
    --         non_matching_tracks = utils.join_tables(non_matching_tracks,non_magic_matching_track)
    --     end
    -- end
    
    local patterns = utils.split_patterns(string_input)
    
    local matching_tracks, non_matching_tracks = self:recursively_match_tracks_by_patterns(self:match_by_name(patterns, self.is_case_sensitive))    

    local post_matching_tracks, post_non_matching_tracks = self:post_filter(matching_tracks)
    matching_tracks = post_matching_tracks
    non_matching_tracks = utils.join_tables(non_matching_tracks,post_non_matching_tracks)

    for _, tr in ipairs(matching_tracks) do
        reaper.SetMediaTrackInfo_Value(tr, "B_SHOWINTCP", 1)
        reaper.SetMediaTrackInfo_Value(tr, "B_SHOWINMIXER", 1)
    end
    for _, tr in ipairs(non_matching_tracks) do
        reaper.SetMediaTrackInfo_Value(tr, "B_SHOWINTCP", 0)
        reaper.SetMediaTrackInfo_Value(tr, "B_SHOWINMIXER", 0)
    end

    tracks_fit_tcp()
end

local function make_track_filter()
    return Track_Filter:new()
end

return make_track_filter