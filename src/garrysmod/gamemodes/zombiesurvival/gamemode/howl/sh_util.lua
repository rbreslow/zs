function util.get_player_name(pl)
    if IsValid(pl) then
        return pl:Name()
    else
        return "Console"
    end
end

function util.list_to_string(callback, separator, ...)
    if !isfunction(callback) then
        callback = function(obj) return tostring(obj) end
    end

    if !isstring(separator) then
        separator = ", "
    end

    local list = { ... }
    local result = ""

    for k,v in ipairs(list) do
        local text = callback(v)

        if isstring(text) then
            result = result .. text
        end

        if k < #list then
            result = result .. separator
        end
    end

    return result
end

function util.player_list_to_string(player_list)
    local len = #player_list

    if len > 1 and len == #player.GetAll() then
        return "everyone"
    end

    return util.list_to_string(function(obj)
        return (IsValid(obj) and obj:Name()) or "Unknown Player"
    end, nil, unpack(player_list))
end
