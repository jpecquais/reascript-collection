-- @author JLP
-- @version 25.01.27
-- @description Toggle to stereo source
-- @noindex

local script = "monitoring.lua"
local script_folder = debug.getinfo(1,'S').source:match[[^@?(.*[\\/])[^\\/]-$]]
local script_path = script_folder .. script -- This can be erased if you prefer enter absolute path value above.

local monitoring = dofile(script_path)

monitoring.stereo_input_button:toggle()
