-- @author JLP
-- @version 25.01.27
-- @description Select next visible track in TCP
-- @changelog
--     Initial release

local main_path = reaper.GetResourcePath()
local script_path = main_path.."/Scripts/JLP Scripts"
local navigation = dofile(script_path.."/Navigation/lib/navigation.lua")

navigation.select_adjacent_visible_track(false,false)