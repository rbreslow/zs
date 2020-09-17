local Command = Howl.Command("ban", "moderate")

Command:register_argument("targets", "player", true)
Command:register_argument("length", "duration", false)
Command:register_argument("reason", "string", false)

function Command:execute(caller, targets, duration, reason)
    duration = duration or 0

    local message = "You have been permanently banned"

    if duration > 0 then
        message = string.format("You have been banned for %s", string.NiceTime(duration))
    end

    if reason then
        message = message .. ".\n" .. string.format("Reason: %s", reason)
    end

    -- Source always appends a period
    if message:EndsWith(".") then
        message = message:sub(1, -2)
    end

    for _, target in ipairs(targets) do
        Howl:ban(target, caller, duration, reason)
        target:Kick(message)
    end
end

Howl:register_command(Command)
