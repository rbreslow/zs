local Command = Howl.Command("rcon", "administrate")

Command:register_argument("command", "string", true)

function Command:execute(caller, input)
    game.ConsoleCommand(input .. "\n")
    return string.format("%s", input)
end

Howl:register_command(Command)
