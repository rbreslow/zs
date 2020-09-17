local Command = Howl.Command("unban", "moderate")

Command:register_argument("steamID", "steamID", true)

function Command:execute(caller, steamid)
    local query = string.format(
        [[
            UPDATE ban SET unbanned = TRUE
            FROM player p
            WHERE ban.player_id = p.id
                    AND player_id = %s
                    AND expires_at > now()
                    AND NOT unbanned RETURNING p.name;
        ]],
        GAMEMODE.Database:Escape(steamid)
    )

    GAMEMODE.Database:Queue(query, function(res, size)
        if size > 0 then
            Howl:notify(caller, string.format("%s (%s) has been unbanned.", res[1].name, steamid))
        else
            Howl:notify(caller, string.format("No bans found for %s.", steamid))
        end
    end)

    return string.format("Unbanning %s...", steamid)
end

Howl:register_command(Command)
