local Command = Howl.Command("getrole", "moderate")

Command:register_argument("targets", "player", false)

function Command:execute(caller, targets)
    local player_list
    if targets then
        player_list = targets
    else
        player_list = player.GetAll()
    end

    return util.list_to_string(function(obj)
        return IsValid(obj) and string.format("%s: %s", obj:Name(), obj:get_role()) or nil
    end, nil, unpack(player_list)) .. "."
end

Howl:register_command(Command)
