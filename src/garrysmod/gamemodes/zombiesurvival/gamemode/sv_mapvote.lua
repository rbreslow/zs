GM.MapVote = GM.MapVote or {}

GM.MapVote.Cooldown = CreateConVar("zs_map_cooldown", 7200, FCVAR_ARCHIVE, "How long to wait before voting on a map again (in seconds).", 0):GetInt()
cvars.AddChangeCallback("zs_map_cooldown", function(_, _, value)
	GAMEMODE.MapVote.Cooldown = tonumber(value) or 7200
end)

local function get_file_system_maps()
    local maps = select(1, file.Find("maps/zs_*.bsp", "GAME"))
    maps = table.Add(maps, file.Find("maps/ze_*.bsp", "GAME"))
    maps = table.Add(maps, file.Find("maps/zm_*.bsp", "GAME"))

    -- Strip file extension
    for i=1,#maps do
        maps[i] = maps[i]:sub(0, -5)
    end

    return maps
end

function GM.MapVote:Sync()
    local maps = get_file_system_maps()

    -- Make sure every map is currently installed on the server is present in
    -- the database
    local values = {}
    for i=1,#maps do
        local map = GAMEMODE.Database:Escape(maps[i])
        table.insert(values, string.format("('%s')", map))
    end

    local query = string.format(
        [[
            INSERT INTO maps
                VALUES
                    %s
                ON CONFLICT (id)
                    DO UPDATE SET
                        installed = TRUE;
        ]],
        table.concat(values, ", ")
    )
    GAMEMODE.Database:Queue(query)

    -- If there are any maps present in the database that are *not* present on
    -- the server, let's update their status
    values = {}
    for i=1,#maps do
        local map = GAMEMODE.Database:Escape(maps[i])
        table.insert(values, string.format("'%s'", map))
    end

    local query = string.format(
        [[
            UPDATE
                maps
            SET
                installed = FALSE
            WHERE
                id NOT IN (%s);
        ]],
        table.concat(values, ", ")
    )
    GAMEMODE.Database:Queue(query)
end

function GM.MapVote:MakePool()
    local pool = {}

    if GAMEMODE.Database:Connected() then
        local query = string.format(
            [[
                SELECT
                    *
                FROM
                    maps
                WHERE
                    installed = TRUE
                    AND id != '%s'
                    AND last_played < (now() - interval '%d seconds')
                ORDER BY
                    random()
                LIMIT 8;
            ]], 
            GAMEMODE.Database:Escape(game.GetMap()), 
            GAMEMODE.MapVote.Cooldown
        )
        GAMEMODE.Database:RawQuery(query, function(res, size)
            for i=1,#res do
                table.insert(pool, res[i].id)
            end
        end)
    end

    -- Fallback to generating a pool from the file system.
    if table.IsEmpty(pool) then
        local maps = get_file_system_maps()

        local i = 1
        while i <= 8 do
            local map = table.Random(maps)

            if map ~= game.GetMap() and not table.HasValue(pool, map) then
                i = i + 1
                table.insert(pool, map)
            end
        end
    end

    return pool
end

function GM.MapVote:NetworkToPlayer(player)
    if self.Active then
        net.Start("zs_mapvote_start")
        net.WriteUInt(self.EndsAt, 16)
        net.WriteTable(self.Pool)
        net.Send(player)
    end
end

function GM.MapVote:Start(duration) 
    if self.Active then
        error("MapVote is already active.")
    end

    local duration = duration or 30

    self.Active = true
    self.EndsAt = CurTime() + duration
    self.Pool = self:MakePool()
    self.Votes = {}

    net.Start("zs_mapvote_start")
    net.WriteUInt(self.EndsAt, 16)
    net.WriteTable(self.Pool)
    net.Broadcast()
  
    timer.Simple(duration, function()
        self:End()
    end)
end

function GM.MapVote:Tally()
    if table.IsEmpty(self.Pool) then
        return nil
    elseif table.IsEmpty(self.Votes) then
        MsgN("No one voted. MapVote tally is random.")
        return math.random(1, #self.Pool)
    end

    local count = {}

    for _,vote in pairs(self.Votes) do
        count[vote] = count[vote] or 0 + 1
    end

    local winner = table.GetWinningKey(count)

    return winner
end

function GM.MapVote:End()
    if not self.Active then
        error("MapVote is already over.")
    end

    self.Active = false

    local tally = self:Tally()

    if not tally then
        error("MapVote tally cannot be nil. Aborting.")
    end

    net.Start("zs_mapvote_winner")
    net.WriteUInt(tally - 1, 3)
    net.Broadcast()

    local tally_str = self.Pool[tally]

    if GAMEMODE.Database:Connected() then
        local query = string.format(
            [[
                UPDATE
                    maps
                SET
                    last_played = now()
                WHERE
                    id = '%s';
            ]],
            GAMEMODE.Database:Escape(tally_str)
        )
        GAMEMODE.Database:RawQuery(query)
    end

    timer.Simple(5, function()
        RunConsoleCommand("changelevel", tally_str)
    end)
end

function GM.MapVote:RemoveVote(player)
    if self.Active then
        self.Votes[player:AccountID()] = nil
    end
end

net.Receive("zs_mapvote_vote", function(length, player)
    if GAMEMODE.MapVote.Active then
        -- 3 bit unsigned integer, maximum value is 7, but Lua array indexing
        -- starts at 1
        local vote = net.ReadUInt(3) + 1

        GAMEMODE.MapVote.Votes[player:AccountID()] = vote
        MsgN(string.format("%s voted for %s", player:Nick(), GAMEMODE.MapVote.Pool[vote]))
    end
end)
