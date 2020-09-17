function Howl.CheckPassword(steamid, ip_address, _, _, name)
    local query = string.format(
        [[
            SELECT extract(epoch FROM now()) AS curtime,
                    extract(epoch FROM expires_at) AS expires_at,
                    reason
            FROM ban
            WHERE player_id = %s
                    AND expires_at > now()
                    AND NOT unbanned
            ORDER BY expires_at LIMIT 1;
        ]],
        GAMEMODE.Database:Escape(steamid)
    )

    return GAMEMODE.Database:RawQuery(query, function(res, size)
        if size > 0 then
            local row = res[1]

            local message = "You are permanently banned."

            -- If the ban is permanent, expires_at will be equal to math.huge (infinity)
            if row.expires_at ~= math.huge then
                message = string.format("You are banned for %s.", string.NiceTime(row.expires_at - row.curtime))
            end

            if row.reason then
                message = message .. "\n" .. string.format("Reason: %s.", row.reason)
            end

            Howl.logger.info(
                string.format(
                    "%s (%s) attempted to connect. Disconnect: %s",
                    name,
                    ip_address,
                    message:Replace("\n", " ")
                )
            )

            return false, message
        end
    end)
end
hook.Add("CheckPassword", "Howl#CheckPassword", Howl.CheckPassword)

function Howl.PlayerDisconnected(pl)
    pl:save_player()
end
hook.Add("PlayerDisconnected", "Howl#PlayerDisconnected", Howl.PlayerDisconnected)

function Howl.PlayerRestored(pl, record)
    if record.role then
        pl:set_role(record.role)
    end

    Howl.logger.info(string.format("%s has connected to the server.", pl:Name()))
end
hook.Add("PlayerRestored", "Howl#PlayerRestored", Howl.PlayerRestored)

function Howl.PlayerSay(pl, str)
    local prefixes = {"!", "/"}

    for _, prefix in ipairs(prefixes) do
        if str:StartWith(prefix) then
            return Howl:interpret(pl, str:sub(2))
        end
    end
end
hook.Add("PlayerSay", "Howl#PlayerSay", Howl.PlayerSay)

function Howl.concommand(player, cmd, args, args_text)
    Howl:interpret(player, args_text, true)
end
concommand.Add("howl", Howl.concommand)

-- This hook ends up overriding everyone's role to user and saving the record
-- back to the database.
-- See: https://github.com/Facepunch/garrysmod/blob/394ae745df8f8f353ea33c8780f012fc000f4f56/garrysmod/lua/includes/extensions/player_auth.lua#L81-L105
hook.Remove("PlayerInitialSpawn", "PlayerAuthSpawn")
