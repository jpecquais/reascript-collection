-- main.lua

reaper.set_action_options(1) -- if script is terminated, it is automatically relaunched.

debug_mode = false

local main_path = reaper.GetResourcePath()
local script_path = main_path .. "/Scripts/JLP Scripts"

-- Load track filtering functions
local make_track_filter = dofile(script_path .. "/Track Filter/src/track_filter.lua")
local track_filter = make_track_filter()

-- Load main window
local make_main_window = dofile(script_path .. "/Track Filter/src/main_window.lua")
local main_window = make_main_window()
track_filter:bind_modifers(main_window:get_modifier_buttons())

main_window:set_callback(function(text) track_filter:filter_tracks(text) end)

local function loop()

    main_window:set_text(reaper.GetExtState("jlp_Track filter", "text_box"))

    if reaper.GetExtState("jlp_Track filter", "request_focus") == "true" then main_window:request_focus() end
    main_window:process_shortcuts()
    main_window:draw()

    reaper.TrackList_AdjustWindows(false)

    -- Ensure that once the window has taken the focus, the shared variable is turned to false
    reaper.SetExtState("jlp_Track filter", "text_box", main_window:get_text(), false)
    reaper.SetExtState("jlp_Track filter", "request_focus", "false", false)

    if main_window.is_open then
        reaper.defer(loop)
    end
end

reaper.defer(loop)
