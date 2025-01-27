-- @author JLP
-- @version 25.01.27
-- @description Track filter

-- @about
--   # Track Filter

--   ## Description
--   The Track Filter script is a simple GUI based tool to show/hide tracks in MCP and TCP based on their name.
--   It requires my script **Visible tracks fit TCP height** to work !

--   ## TODO
--   - [ ] Add options to affect TCP visiblity only
--   - [ ] Add options to affect MCP visiblity only
--   - [ ] Add options to show parent tracks of match tracks (currently on)
--   - [ ] Add options to show children tracks of match tracks (currently on)
  
--   # Known issue

-- @changelog
--     Initial release
-- @provides
--     jlp_Track filter - focus search bar.lua
--     jlp_Track filter - set selected track's name as track filters.lua
--     ./src/main_window.lua
--     ./src/main.lua
--     ./src/track_filter.lua

local main_path = reaper.GetResourcePath()
local script_path = main_path .. "/Scripts/JLP Scripts"
dofile(script_path.."/Track Filter/src/main.lua")