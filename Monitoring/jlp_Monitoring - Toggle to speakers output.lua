--Script Name : Monitoring - Toggle stereo Source.lua
--Author : Jean Loup Pecquais
--Description : This is a toggle to set the monitoring source to stereo
--v1.0.0

local script = "monitoring.lua"
local script_folder = debug.getinfo(1,'S').source:match[[^@?(.*[\\/])[^\\/]-$]]
local script_path = script_folder .. script -- This can be erased if you prefer enter absolute path value above.

local monitoring = dofile(script_path)

monitoring.speakers_output_button:toggle()
