local Command = Howl.Command("setrole", "administrate")

Howl.Command.argument_types.role = function(value)
    local valid_roles = table.GetKeys(Howl.roles)

    if table.HasValue(valid_roles, value) then
        return value
    end
end

Command:register_argument("targets", "player", true)
Command:register_argument("role", "role", true)

function Command:execute(caller, targets, role)
    for _, target in ipairs(targets) do
        target:set_role(role)
    end

    return string.format("Set %s's role to %s.", util.player_list_to_string(targets), role)
end

Howl:register_command(Command)
