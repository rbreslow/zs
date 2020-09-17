local Command = Howl.Command("map", "administrate")

Command:register_argument("map", "string", true)

function Command:execute(caller, map)
    local maps = select(1, file.Find("maps/*.bsp", "GAME"))
    for k,v in ipairs(maps) do
        maps[k] = v:sub(1, -5)
    end

    if table.HasValue(maps, map) then
        RunConsoleCommand("changelevel", map)
    else
        return string.format("%s is not installed.", map)
    end
end

Howl:register_command(Command)
