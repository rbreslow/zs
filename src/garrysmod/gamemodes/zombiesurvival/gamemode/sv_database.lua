require "pg"

local database = CreateConVar("postgres_db", "zombiesurvival", bit.bor(FCVAR_PROTECTED), "")
local password = CreateConVar("postgres_password", "zombiesurvival", bit.bor(FCVAR_PROTECTED), "")
local user = CreateConVar("postgres_user", "zombiesurvival", bit.bor(FCVAR_PROTECTED), "")
local host = CreateConVar("postgres_host", "database", bit.bor(FCVAR_PROTECTED), "")

GM.Database = GM.Database or {}
GM.Database._Connected = false
GM.Database._Queue = {}

function GM.Database:Connect()
    local host, user, password, port, database = host:GetString(), user:GetString(), password:GetString(), database:GetString()

    if pg then
        self.Connection = pg.new_connection()

        local success, err = self.Connection:connect(host, user, password, database, 5432)

        if success then
            success, err = self.Connection:set_encoding("UTF8")

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
    if self._Connected then
        return pcall(function() self.Connection:is_open() end)
    else
        return false
    end
end

function GM.Database:Escape(str)
    return self.Connection:escape(str)
end
  
function GM.Database:Quote(str)
    return self.Connection:quote(str)
end

function GM.Database:QuoteName(str)
    return self.Connection:quote_name(str)
end

function GM.Database:Queue(query, callback)
    assert(type(query) == "string")
    table.insert(self._Queue, { query, callback })
end

function GM.Database:RawQuery(query, callback)
    if not self:Connected() then
        return self:Queue(query, callback)
    end

    MsgN(string.format("Query: %s", query))

    local query_obj = self.Connection:query(query)
    query_obj:set_sync(true)

    local success, res, size = query_obj:run()
    if success then
        if isfunction(callback) then return callback(res, size) end
    else
        ErrorNoHalt("PostgreSQL Query Error!\n")
        ErrorNoHalt(string.format("Query: %s\n", query))
        ErrorNoHalt(string.format("%s\n", tostring(res)))
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

timer.Create("GAMEMODE::Database#_Think", 1, 0, function()
    GAMEMODE.Database:_Think()
end)

function GM.Database:_CheckConnection()
    local connected = self:Connected()

    if not connected then self:Connect() end
    return connected
end

timer.Create("GAMEMODE::Database#_CheckConnection", 30, 0, function()
    GAMEMODE.Database:_CheckConnection()
end)

concommand.Add("dump_postgresql_queue", function()
    for i=1,#GAMEMODE.Database._Queue do
        MsgN(string.format("%d: %s", i, GAMEMODE.Database._Queue[i][1]))
    end
end)
