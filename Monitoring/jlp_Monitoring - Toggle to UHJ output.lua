-- @author JLP
-- @version 25.01.27
-- @description Toggle to UHJ output
-- @noindex

local script = "monitoring.lua"
local script_folder = debug.getinfo(1,'S').source:match[[^@?(.*[\\/])[^\\/]-$]]
local script_path = script_folder .. script -- This can be erased if you prefer enter absolute path value above.

local monitoring = dofile(script_path)

monitoring.uhj_output_button:toggle()
