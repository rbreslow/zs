GM.MapVote = GM.MapVote or {}

function GM.MapVote:Sync()
    local conn = GAMEMODE.Database.conn

    local maps = select(1, file.Find("maps/zs_*.bsp", "GAME"))
    maps = table.Add(maps, file.Find("maps/ze_*.bsp", "GAME"))
    maps = table.Add(maps, file.Find("maps/zm_*.bsp", "GAME"))

    -- Strip file extension
    for i=1,#maps do
        maps[i] = maps[i]:sub(0, -5)
    end

    -- Make sure every map is currently installed on the server is present in
    -- the database
    local base = [[
        INSERT INTO maps
            VALUES
                %s
            ON CONFLICT (id)
                DO UPDATE SET
                    installed = TRUE;
    ]]

    local values = {}
    for i=1,#maps do
        table.insert(values, string.format("(%s)", conn:quote(conn:escape(maps[i]))))
    end

    local query_obj = conn:query(string.format(base, table.concat(values, ", ")))
    query_obj:set_sync(true)
    local success, res, size = query_obj:run()
    if not success then
        ErrorNoHalt(res)
    end

    -- If there are any maps present in the database that are *not* present on
    -- the server, let's update their status
    base = [[
        UPDATE
            maps
        SET
            installed = FALSE
        WHERE
            id NOT IN (%s);
    ]]

    values = {}
    for i=1,#maps do
        table.insert(values, string.format("%s", conn:quote(conn:escape(maps[i]))))
    end
    query_obj = conn:query(string.format(base, table.concat(values, ", ")))
    query_obj:set_sync(true)
    local success, res, size = query_obj:run()
    if not success then
        ErrorNoHalt(res)
    end
end

function GM.MapVote:MakePool()
    local conn = GAMEMODE.Database.conn
    local base = [[
        SELECT
            *
        FROM
            maps
        WHERE
            installed = TRUE
            AND id != %s
            AND last_played < (now() - interval '4 hours')
        ORDER BY
            random()
        LIMIT 8;
    ]]
    local query_obj = conn:query(string.format(base, conn:quote(conn:escape(game.GetMap()))))
    query_obj:set_sync(true)
    local success, res, size = query_obj:run()
    if success then
        local pool = {}

        for i=1,#res do
            table.insert(pool, res[i].id)
        end

        return pool
    else
        ErrorNoHalt(res)
    end
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

    local tallyStr = self.Pool[tally]

    local conn = GAMEMODE.Database.conn
    local base = [[
        UPDATE
            maps
        SET
            last_played = now()
        WHERE
            id = %s;
    ]]
    local query_obj = conn:query(string.format(base, conn:quote(conn:escape(tallyStr))))
    query_obj:set_sync(true)
    local success, res, size = query_obj:run()
    if not success then
        ErrorNoHalt(res)
    end

    timer.Simple(5, function()
        RunConsoleCommand("changelevel", tallyStr)
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
