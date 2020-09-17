Howl.Command.argument_types.steamID = function(value)
    if value:StartWith("STEAM_") then
        value = util.SteamIDTo64(value)
    end

    if tonumber(value) then
        return value
    end
end
