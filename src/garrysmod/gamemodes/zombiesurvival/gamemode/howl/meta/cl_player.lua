local player_meta = FindMetaTable("Player")

net.Receive("howl_notify", function(len)
    LocalPlayer():notify(
        unpack(net.ReadTable())
    )
end)

net.Receive("howl_notify_console", function(len)
    LocalPlayer():notify_console(
        unpack(net.ReadTable())
    )
end)

function player_meta:notify(...)
    chat.AddText(...)
end

function player_meta:notify_console(...)
    local message = {...}
    table.insert(message, 1, Color(255, 255, 255))
    table.insert(message, "\n")
    MsgC(unpack(message))
end
