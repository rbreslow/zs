local Command = Howl.Command("kick", "moderate")

Command:register_argument("targets", "player", true)
Command:register_argument("reason", "string", false)

function Command:execute(caller, targets, reason)
    local message = "You have been kicked."

    if reason then
        message = message .. "\n" .. string.format("Reason: %s", reason)
    end

    -- Source always appends a period
    if message:EndsWith(".") then
        message = message:sub(1, -2)
    end

    for _, v in pairs(targets) do
        v:Kick(message)
    end

    local message = string.format(
        "%s kicked %s",
        util.get_player_name(caller),
        util.player_list_to_string(targets)
    )

    if reason then
        message = message .. " " .. string.format("(%s)", reason)
    end

    Howl:notify_staff(message)
end

Howl:register_command(Command)
