local player_meta = FindMetaTable("Player")

function player_meta:set_role(role)
    assert(table.HasValue(table.GetKeys(Howl.roles), role))

    role = role or "user"
    self:SetNW2String("role", role)
    self:save_player()
end
player_meta.SetUserGroup = player_meta.set_role

function player_meta:can(perm)
    local role = Howl.roles[self:get_role()]

    if not role then
        error("Player has no role. Check database connectivity.")
    end

    if not perm or role.root or table.HasValue(role.perms, perm) then
        return true
    else
        return false
    end
end

function player_meta:save_player()
    local query = string.format(
        [[
            UPDATE player SET name = '%s', role = '%s'
                WHERE id = %s;
        ]],
        GAMEMODE.Database:Escape(self:Name()),
        GAMEMODE.Database:Escape(self:get_role()),
        GAMEMODE.Database:Escape(self:SteamID64())
    )

    GAMEMODE.Database:Queue(query, function(_, res)
        hook.Run("PlayerSaved", self)
    end)
end

function player_meta:restore_player()
    local query = string.format(
        "SELECT name, role FROM player WHERE id = %s;",
        GAMEMODE.Database:Escape(self:SteamID64())
    )

    GAMEMODE.Database:Queue(query, function(res, size)
        if not IsValid(self) then
            return
        end

        if size > 0 then
            hook.Run("PlayerRestored", self, res[1])
        else
            local obj = {}
            obj.name = self:Name()
            obj.role = "user"

            local query = string.format(
                [[
                    INSERT INTO player
                        VALUES (%s, '%s', '%s');
                ]],
                self:SteamID64(),
                obj.name,
                obj.role
            )

            GAMEMODE.Database:Queue(query, function(_, res)
                hook.Run("PlayerRestored", self, obj)
            end)
        end
    end)
end

util.AddNetworkString("howl_notify")
util.AddNetworkString("howl_notify_console")

function player_meta:notify(...)
    local message = {...}

    if not table.IsEmpty(message) then
        net.Start("howl_notify")
        net.WriteTable(message)
        net.Send(self)
    end
end

function player_meta:notify_console(...)
    local message = {...}

    if not table.IsEmpty(message) then
        net.Start("howl_notify_console")
        net.WriteTable(message)
        net.Send(self)
    end
end
