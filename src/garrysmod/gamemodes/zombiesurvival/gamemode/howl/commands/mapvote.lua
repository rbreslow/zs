local Command = Howl.Command("mapvote", "administrate")

Command:register_argument("duration", "number", false)

function Command:execute(caller, duration)
    GAMEMODE.MapVote:Start(duration)
end

Howl:register_command(Command)
