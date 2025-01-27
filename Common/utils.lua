-- @author JLP
-- @version 25.01.27
-- @description Utilities library
-- @noindex
-- NoIndex: true

local utils = {}

function utils.print(msg)
    if type(msg) == "nil" then msg = "nil"
    elseif type(msg) == "boolean" then
        if msg then msg = "true" else msg = "false" end
    elseif type(msg) == "userdata" then
        msg = tostring(msg)
    end
    reaper.ShowConsoleMsg(msg)
end

function utils.print_table(t)
    for k, v in pairs(t) do
        -- reaper.ShowConsoleMsg(type(k))
        utils.print(k)
        utils.print(":\t")
        utils.print(v)
        utils.print("\n")
    end
end

-- Debug function to print messages to the console
function utils.debug(msg)
    if not debug_mode then return end
    
    if type(msg) == "table" then utils.print_table(msg)
    else utils.print(msg) end

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