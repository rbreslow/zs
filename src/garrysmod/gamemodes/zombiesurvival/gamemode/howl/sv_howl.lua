Howl = {}
Howl.logger = include("lib/log.lua")
Howl.commands = {}
Howl.roles = {
    ["admin"] = {
        root = true,
        -- These are skipped due to root and are for illustrative purposes only.
        perms = { "administrate", "moderate" }
    },
    ["moderator"] = {
        perms = { "moderate" }
    },
    ["user"] = {
        perms = {}
    }
}

-- Metatable overrides
AddCSLuaFile("meta/cl_player.lua")
AddCSLuaFile("meta/sh_player.lua")
include("meta/sh_player.lua")
include("meta/sv_player.lua")

-- Howl
AddCSLuaFile("sh_util.lua")
include("sh_util.lua")
include("sv_hooks.lua")
include("sv_command.lua")

function Howl:register_command(command)
    for k, v in pairs(self.commands) do
        if v.name == command.name then
            table.remove(self.commands, k)
        end
    end

    table.insert(self.commands, command)
end

function Howl:find_command(name)
    for _, command in ipairs(self.commands) do
        if name == command.name then
            return command
        end
    end
end

function Howl:available_commands_message(pl)
    local available_commands = {}

    for _, command in ipairs(self.commands) do
        if command ~= self and (not pl:IsValid() or pl:can(command.perm)) then
            table.insert(available_commands, "• " .. string.Split(command:usage(), "usage: ")[2])
        end
    end

    return string.format(
        "AVAILABLE COMMANDS\n%s",
        table.concat(available_commands, "\n")
    )
end

function Howl:extract_arguments(text)
    local raw_args
    local arguments = {}
    local word = ""
    local skip = 0
    local tlen = string.len(text)

    for i = 1, tlen do
        if raw_args == nil and #arguments > 0 then
            raw_args = string.sub(i, tlen)
        end

        if skip > 0 then
            skip = skip - 1

            continue
        end

        local char = utf8.sub(text, i, i)

        if (char == '"' or char == "'") and word == "" then
            local end_pos = text:find('"', i + 1)

            if !end_pos then
                end_pos = text:find("'", i + 1)
            end

            if end_pos then
                table.insert(arguments, utf8.sub(text, i + 1, end_pos - 1))
                skip = end_pos - i
            else
                word = word .. char
            end
        elseif char == " " then
            if word != "" then
                table.insert(arguments, word)
                word = ""
            end
        else
            word = word .. char
        end
    end

    if word != "" then
        table.insert(arguments, word)
    end

    return arguments, (raw_args or "")
end

function Howl:interpret(caller, text, from_console)
    local args = self:extract_arguments(text)
    if table.IsEmpty(args) then
        self:notify_console(
            caller,
            "usage: howl <command> [parameters]",
            "\n\n",
            self:available_commands_message(caller)
        )
    else
        local raw_command = args[1]:lower()
        local command = self:find_command(raw_command)
        table.remove(args, 1)

        -- Check if player can execute the command, skip if Console
        local has_permission = true
        if command and caller:IsValid() then
            has_permission = caller:can(command.perm)
        end

        if command and has_permission then
            args = command:parse(args)
            if istable(args) then
                self.logger.info(string.format("%s (%s) executed %s.", util.get_player_name(caller), IsValid(caller) and caller:SteamID64() or -1, text))

                local result = command:execute(caller, unpack(args))
                if result then
                    self:notify(caller, result)
                end
            else
                self:notify(caller, args)
            end
            return ""
        end

        if from_console then
            self:notify_console(
                caller,
                "usage: howl <command> [parameters]",
                "\n\n",
                string.format("%s: command not found.", raw_command),
                "\n\n",
                self:available_commands_message(caller)
            )
        end
    end
end

function Howl:ban(target, caller, duration, reason)
    local player_id = isentity(target) and target:SteamID64() or target
    local player_name = isentity(target) and target:Name() or target
    local banned_by = IsValid(caller) and caller:SteamID64() or -1
    duration = duration or 0
    reason = GAMEMODE.Database:Quote(GAMEMODE.Database:Escape(reason)) or "NULL"

    -- We have a separate query, because permanent bans do not pass a duration
    -- to string.format
    local query = string.format(
        [[
            INSERT INTO ban (player_id, banned_by, expires_at, reason)
            VALUES (%s, %s, 'infinity', %s);
        ]],
        player_id,
        banned_by,
        reason
    )

    if duration > 0 then
        query = string.format(
            [[
                INSERT INTO ban (player_id, banned_by, expires_at, reason)
                VALUES (%s, %s, now() + interval '%d second', %s);
            ]],
            player_id,
            banned_by,
            duration,
            reason
        )
    end

    -- The Database class will requeue queries that fail due to connection
    -- issues, but besides from that, we have no way to recover from a failure.
    -- There is a possibility they won't be banned.
    GAMEMODE.Database:Queue(query, function(size, res)
        local message = string.format(
            "%s permanently banned %s",
            util.get_player_name(caller),
            player_name
        )

        if duration > 0 then
            message = string.format(
                "%s banned %s for %s",
                util.get_player_name(caller),
                player_name,
                string.NiceTime(duration)
            )
        end

        if reason ~= "NULL" then
            message = message .. " " .. string.format("(%s)", reason)
        end

        Howl:notify_staff(message)
    end)
end

function Howl:notify(caller, ...)
    if IsValid(caller) then
        caller:notify(...)
    else
        MsgN(...)
    end
end

function Howl:notify_console(caller, ...)
    if IsValid(caller) then
        caller:notify_console(...)
    else
        MsgN(...)
    end
end

function Howl:notify_all(...)
    local message = {...}

    if not table.IsEmpty(message) then
        net.Start("howl_notify")
        net.WriteTable(message)
        net.Broadcast()
    end

    MsgN(...)
end

function Howl:notify_staff(...)
    for _, v in ipairs(player.GetAll()) do
        if v:IsAdmin() then
            v:notify(...)
        end
    end

    MsgN(...)
end

local search = string.format("%s/gamemode/howl/commands/*", GM.FolderName)
for _, v in ipairs(file.Find(search, "LUA")) do
    include(string.format("commands/%s", v))
end
