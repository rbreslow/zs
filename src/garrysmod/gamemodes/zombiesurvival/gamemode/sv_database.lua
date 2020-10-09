require "pg"

local database = CreateConVar("postgres_db", "zombiesurvival", bit.bor(FCVAR_PROTECTED), "")
local password = CreateConVar("postgres_password", "zombiesurvival", bit.bor(FCVAR_PROTECTED), "")
local user = CreateConVar("postgres_user", "zombiesurvival", bit.bor(FCVAR_PROTECTED), "")
local host = CreateConVar("postgres_host", "database", bit.bor(FCVAR_PROTECTED), "")

GM.Database = GAMEMODE and GAMEMODE.Database or {
    _Connection = nil,
    _Connected = false,
    _Queue = {}
}

function GM.Database:Connect()
    local host, user, password, port, database = host:GetString(), user:GetString(), password:GetString(), database:GetString()

    if pg then
        self._Connection = pg.new_connection()

        local success, err = self._Connection:connect(host, user, password, database, 5432)

        if success then
            success, err = self._Connection:set_encoding("UTF8")

            if not success then
                ErrorNoHalt("Failed to set connection encoding:\n", err)
            end

            MsgN("Connected to the database!")

            self._Connected = true
            hook.Run("DatabaseConnected")
        else
            ErrorNoHalt("Unable to connect to the database!\n", err)
            hook.Run("DatabaseConnectionFailed", error_text)
        end
    else
        ErrorNoHalt("gmsv_pg has not been found.")
    end
end

function GM.Database:Connected()
    return self._Connected
end

function GM.Database:Escape(str)
    return self._Connection:escape(str)
end

function GM.Database:Quote(str)
    return self._Connection:quote(str)
end

function GM.Database:QuoteName(str)
    return self._Connection:quote_name(str)
end

function GM.Database:Queue(query, callback)
    assert(type(query) == "string")
    table.insert(self._Queue, { query, callback })
end

function GM.Database:RawQuery(query, callback)
    if not self:Connected() then
        return self:Queue(query, callback)
    end

    local query_obj = self._Connection:query(query)
    query_obj:set_sync(true)

    local success, res, size = query_obj:run()
    if success then
        if isfunction(callback) then
            return select(2, xpcall(callback, ErrorNoHalt, res, size))
        end
    else
        ErrorNoHalt("PostgreSQL Query Error!\n")
        ErrorNoHalt(string.format("Query: %s\n", query))
        local err = tostring(res)
        ErrorNoHalt(string.format("%s\n", err))

        if err == "Connection to database failed" then
            return self:Queue(query, callback)
        end
    end
end

function GM.Database:_Think()
    if #self._Queue > 0 then
        if istable(self._Queue[1]) then
            local queue_obj = self._Queue[1]
            local query_string = queue_obj[1]

            if isstring(query_string) then
                self:RawQuery(query_string, queue_obj[2])
            end

            table.remove(self._Queue, 1)
        end
    end
end

timer.Create("GAMEMODE::Database#_Think", .25, 0, function()
    GAMEMODE.Database:_Think()
end)

concommand.Add("dump_postgresql_queue", function()
    for i=1,#GAMEMODE.Database._Queue do
        MsgN(string.format("%d: %s", i, GAMEMODE.Database._Queue[i][1]))
    end
end)
