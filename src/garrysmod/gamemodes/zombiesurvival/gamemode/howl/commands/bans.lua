local Command = Howl.Command("bans", "moderate")

Command:register_argument("search", "string", false)

-- We have to convert to varchar because I am running into rounding issues with
-- Lua due to the size of the integer.
local query_all = [[
    SELECT player.name AS player_name,
            player.id::VARCHAR as player_id,
            moderator.name AS moderator_name,
            ban.banned_at,
            ban.expires_at,
            ban.reason,
            ban.unbanned
    FROM ban
    LEFT JOIN player
        ON ban.player_id = player.id
    LEFT JOIN player moderator
        ON ban.banned_by = moderator.id
    WHERE ban.player_id = player.id
    ORDER BY ban.banned_at DESC LIMIT 10;
]]

local query_search = [[
    SELECT player.name AS player_name,
            player.id::VARCHAR AS player_id,
            moderator.name AS moderator_name,
            ban.banned_at,
            ban.expires_at,
            ban.reason,
            ban.unbanned
    FROM ban
    LEFT JOIN player
        ON ban.player_id = player.id
    LEFT JOIN player moderator
        ON ban.banned_by = moderator.id
    WHERE ban.player_id = player.id
            AND player.name ILIKE '%%%s%%'
    ORDER BY ban.banned_at DESC LIMIT 10;
]]

function Command:execute(caller, search)
    local query = ""
    if search then
        query = string.format(query_search, GAMEMODE.Database:Escape(search))
    else
        query = query_all
    end

    GAMEMODE.Database:Queue(query, function(res, size)
        Howl:notify(caller, util.TableToJSON(res, true))
    end)

    if search then
        return string.format("Searching for recent bans containing \"%s...\"", search)
    else
        return "Searching for recent bans..."
    end
end

Howl:register_command(Command)
