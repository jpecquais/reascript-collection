-- @noindex

local navigation = {}

function navigation.track_is_visible_in_mcp(tr)
  local is_visible = reaper.GetMediaTrackInfo_Value(tr, "B_SHOWINMIXER") == 1
  local is_collapsed = reaper.GetMediaTrackInfo_Value(tr, "I_MCPW") == 0
  return is_visible and not is_collapsed
end

function navigation.track_is_visible_in_tcp(tr)
  local is_visible = reaper.GetMediaTrackInfo_Value(tr, "B_SHOWINTCP") == 1
  local is_collapsed = reaper.GetMediaTrackInfo_Value(tr, "I_WNDH") == 0
  return is_visible and not is_collapsed
end

function navigation.get_adjacent_visible_track(tr,in_mcp,is_next)
  
  local increment
  if is_next then increment = 1 else increment = -1 end
  
  local tr_id = reaper.GetMediaTrackInfo_Value(tr, "IP_TRACKNUMBER")-1+increment
  local new_tr = reaper.GetTrack(0, tr_id)

  if (new_tr ~= nil and ((not navigation.track_is_visible_in_tcp(new_tr) and not in_mcp) or (not navigation.track_is_visible_in_mcp(new_tr) and in_mcp))) then
    new_tr = navigation.get_adjacent_visible_track(new_tr,in_mcp,is_next)
  end

  return new_tr
end

function navigation.select_adjacent_visible_track(in_mcp,is_next,add_to_selection)
  add_to_selection = add_to_selection or false
  local tr = reaper.GetLastTouchedTrack()
  tr = navigation.get_adjacent_visible_track(tr,in_mcp,is_next) or tr
  if not add_to_selection then reaper.Main_OnCommandEx(40297, 0, 0) end-- Track: Unselect all tracks
  reaper.SetMediaTrackInfo_Value(tr, "I_SELECTED" , 1)
end

function navigation.move_selected_tracks_relative_to_last_touched_track(increment, make_folder)
  -- Ensure make_folder is a boolean
  make_folder = make_folder or false

  -- Get the first selected track and its folder depth
  local first_selected_track = {}
  first_selected_track.track = reaper.GetSelectedTrack(0, 0)
  first_selected_track.folder_depth = reaper.GetMediaTrackInfo_Value(first_selected_track.track, 'I_FOLDERDEPTH')

  -- Get the last selected track and its folder depth
  local num_selected_tracks = reaper.CountSelectedTracks(0)
  local last_selected_track = {}
  if num_selected_tracks > 0 then
    last_selected_track.track = reaper.GetSelectedTrack(0, num_selected_tracks - 1)
    last_selected_track.folder_depth = reaper.GetMediaTrackInfo_Value(last_selected_track.track, 'I_FOLDERDEPTH')
  else
    last_selected_track = first_selected_track
  end

  -- Get the previous track and its folder depth
  local previous_track = {}
  previous_track.track = reaper.GetTrack(0, reaper.GetMediaTrackInfo_Value(first_selected_track.track, 'IP_TRACKNUMBER') - 2)
  if previous_track.track then
    previous_track.folder_depth = reaper.GetMediaTrackInfo_Value(previous_track.track, 'I_FOLDERDEPTH')
  end

  -- Get the next track and its folder depth
  local next_track = {}
  next_track.track = reaper.GetTrack(0, reaper.GetMediaTrackInfo_Value(first_selected_track.track, 'IP_TRACKNUMBER'))
  if next_track.track then
    next_track.folder_depth = reaper.GetMediaTrackInfo_Value(next_track.track, 'I_FOLDERDEPTH')
  end

  -- Handle folder depth adjustments for positive increment
  if first_selected_track.folder_depth < 0 and increment > 0 then
    if previous_track.folder_depth <= 0 then
      reaper.SetMediaTrackInfo_Value(previous_track.track, 'I_FOLDERDEPTH', first_selected_track.folder_depth)
    else
      reaper.SetMediaTrackInfo_Value(previous_track.track, 'I_FOLDERDEPTH', 0)
    end
    reaper.SetMediaTrackInfo_Value(first_selected_track.track, 'I_FOLDERDEPTH', 0)
    return
  end

  -- Handle folder depth adjustments for negative increment
  if previous_track.track ~= nil and (previous_track.folder_depth < 0 and increment < 0) then
    reaper.SetMediaTrackInfo_Value(previous_track.track, "I_FOLDERDEPTH", 0)
    reaper.SetMediaTrackInfo_Value(last_selected_track.track, "I_FOLDERDEPTH", previous_track.folder_depth)
    return
  end

  -- Reorder selected tracks
  local first_selected_track_index = reaper.GetMediaTrackInfo_Value(first_selected_track.track, "IP_TRACKNUMBER") - 1
  reaper.ReorderSelectedTracks(first_selected_track_index + increment, make_folder and 1 or 0)

  -- Handle folder depth adjustments for the next track
  if next_track.track ~= nil and (increment > 0 and next_track.folder_depth < 0) then
    reaper.SetMediaTrackInfo_Value(last_selected_track.track, "I_FOLDERDEPTH", next_track.folder_depth)
    reaper.SetMediaTrackInfo_Value(next_track.track, "I_FOLDERDEPTH", 0)
  end
end


return navigation