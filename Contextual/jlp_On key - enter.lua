local window, segment, details = reaper.BR_GetMouseCursorContext()
local context = {window,segment,details}

local function is_over_track(context)
    local over_track_in_tcp = context[1] == "tcp" and context[2] == "track"
    local over_track_in_mcp = context[1] == "mcp" and context[2] == "track"
    return over_track_in_tcp or over_track_in_mcp
end

local function is_over_envelop(context)
    return context[1] == "arrange" and context[2] == "envelope"
end

if is_over_track(context) then
    reaper.Main_OnCommand(40696, 0) --rename last touched track
elseif is_over_envelop(context) then
    reaper.Main_OnCommand(42091,0) --rename automation item
else
    reaper.Main_OnCommand(40042,0) --set cursor at start of project
end