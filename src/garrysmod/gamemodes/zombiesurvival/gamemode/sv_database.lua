require "pg"

local database = CreateConVar("postgres_db", "zombiesurvival", bit.bor(FCVAR_PROTECTED), "")
local password = CreateConVar("postgres_password", "zombiesurvival", bit.bor(FCVAR_PROTECTED), "")
local user     = CreateConVar("postgres_user", "zombiesurvival", bit.bor(FCVAR_PROTECTED), "")
local host     = CreateConVar("postgres_host", "database", bit.bor(FCVAR_PROTECTED), "")

GM.Database = GM.Database or {}

function GM.Database:EstablishConnection(onConnected)
    local host, user, password, port, database = host:GetString(), user:GetString(), password:GetString(), database:GetString()

    if pg then
        self.conn = pg.new_connection()

        local success, err = self.conn:connect(host, user, password, database, 5432)

        if success then
            success, err = self.conn:set_encoding("UTF8")

            if not success then
                ErrorNoHalt("Failed to set connection encoding:\n", err)
            end

            if isfunction(onConnected) then onConnected(self) end
        else
            ErrorNoHalt("Unable to connect to the database!\n", err)
        end
    else
        ErrorNoHalt("gmsv_pg has not been found.")
    end
end
