local Command = Howl.Command("banid", "moderate")

Command:register_argument("steamID", "steamID", true)
Command:register_argument("length", "duration", false)
Command:register_argument("reason", "string", false)

function Command:execute(caller, steamid, duration, reason)
    GAMEMODE.Database:Queue(
        string.format("SELECT EXISTS(SELECT 1 FROM player WHERE id = %s);", steamid),
        function(res, size)
            if res[1].exists then
                Howl:ban(steamid, caller, duration, reason)
            else
                GAMEMODE.Database:Queue(
                    string.format("INSERT INTO player (id) VALUES (%s);", steamid),
                    function(res, size)
                        Howl:ban(steamid, caller, duration, reason)
                    end
                )
            end
        end
    )
end

Howl:register_command(Command)
