
local function find_player(search, return_first)
    local hits = {}

    for _, v in ipairs(player.GetAll()) do
        -- Match by userid
        if tonumber(search) == v:UserID() then
            table.insert(hits, v)
        end

        -- Match by SteamID
        if search == v:SteamID() then
            table.insert(hits, v)
        end

        -- Match by 64-bit SteamID
        if search == v:SteamID64() then
            table.insert(hits, v)
        end

        -- Case-insensitive match by name
        if v:Name():lower():find(search:lower()) then
            table.insert(hits, v)
        end

        if return_first and #hits > 0 then
            return hits[1]
        end
    end

    if #hits > 1 then
        return hits
    else
        return hits[1]
    end
end

Howl.Command.argument_types.player = function(value)
    target = find_player(value, false)

    if IsValid(target) then
        return { target }
    elseif istable(target) and #target > 0 then
        return { target[1] }
    end
end
