-- utils.lua
local utils = {}

-- Debug function to print messages to the console
function utils.debug(msg)
    if debug_mode then reaper.ShowConsoleMsg(msg) end
end

-- Debug function to get and print track name
function utils.debug_get_tr_name(tr)
    local _, name = reaper.GetSetMediaTrackInfo_String(tr, "P_NAME", "", false)
    utils.debug(name)
end

-- Split a string by a separator
function utils.split_string(inputstr, separator)
    local t = {}
    for elem in (inputstr .. separator):gmatch("([^" .. separator .. "]+)" .. separator) do
        table.insert(t, elem)
    end
    return t
end

-- Split patterns by semicolon
function utils.split_patterns(inputstr)
    return utils.split_string(inputstr, ";")
end

-- Join two tables
function utils.join_tables(t1, t2)
    return table.move(t2, 1, #t2, #t1 + 1, t1)
end

return utils