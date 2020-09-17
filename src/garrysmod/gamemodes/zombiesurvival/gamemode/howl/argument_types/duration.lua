-- Translations of words into seconds.
local tokens = {
    second = 1,
    sec = 1,
    minute = 60,
    min = 60,
    hour = 60 * 60,
    day = 60 * 60 * 24,
    week = 60 * 60 * 24 * 7,
    month = 60 * 60 * 24 * 30,
    mon = 60 * 60 * 24 * 30,
    year = 60 * 60 * 24 * 365,
    yr = 60 * 60 * 24 * 365,
    permanently = 0,
    perma = 0,
    perm = 0,
    pb = 0,
    forever = 0,
    moment = 1
}

local num_tokens = {
    one = 1,
    two = 2,
    three = 3,
    four = 4,
    five = 5,
    six = 6,
    seven = 7,
    eight = 8,
    nine = 9,
    ten = 10,
    few = 5,
    couple = 2,
    bunch = 120,
    lot = 1000000,
    dozen = 12
}

Howl.Command.argument_types.duration = function(value)
    if isnumber(value) then return value * 60 end
    if !isstring(value) then return false end

    value = value:Replace("'", "")
    value = value:lower()

    -- A regular number was entered?
    if tonumber(value) then
        return tonumber(value) * 60
    end

    value = value:Replace("-", "")

    local pieces = value:Split(" ")
    local result = 0
    local token, num = "", 0

    for k, v in ipairs(pieces) do
        local n = tonumber(v)

        if isstring(v) then
            v = v:TrimRight("s")
        end

        if !n and !tokens[v] and !num_tokens[v] then continue end

        if n then
            num = n
        elseif isstring(v) then
            v = v:TrimRight("s")

            local ntok = num_tokens[v]

            if ntok then
                num = ntok

                continue
            end

            local tok = tokens[v]

            if tok then
                if tok == 0 then
                    return 0
                else
                    result = result + (tok * num)
                end
            end

            token, num = "", 0
        else
            token, num = "", 0
        end
    end

    return result
end
