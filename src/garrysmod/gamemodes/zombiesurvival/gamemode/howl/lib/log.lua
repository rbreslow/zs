local log = {}

log.use_color = true
log.level = "trace"

local modes = {
    { name = "trace", color = "\27[34m", alt = Color(122, 166, 218) }, -- blue
    { name = "debug", color = "\27[36m", alt = Color(112, 192, 186) }, -- cyan
    { name = "info",  color = "\27[32m", alt = Color(185, 202, 74) }, -- green
    { name = "warn",  color = "\27[33m", alt = Color(230, 197, 71) }, -- yellow
    { name = "error", color = "\27[31m", alt = Color(213, 78, 83) }, -- red
    { name = "fatal", color = "\27[35m", alt = Color(195, 151, 216) }, -- magenta
}

local levels = {}
for i, v in ipairs(modes) do
    levels[v.name] = i
end

for i, x in ipairs(modes) do
    local name_upper = x.name:upper()
    log[x.name] = function(...)

        -- Return early if we're below the log level
        if i < levels[log.level] then
            return
        end

        local msg = tostring(...)
        local info = debug.getinfo(2, "Sl")
        local line_info = info.short_src .. ":" .. info.currentline

        if CLIENT or system.IsWindows() then
            MsgC(
                log.use_color and x.alt or Color(255, 255, 255),
                string.format(
                    "[%s] [%s]",
                    name_upper,
                    os.date("%H:%M:%S")
                ),
                Color(255, 255, 255),
                string.format(
                    " %s: %s\n",
                    line_info,
                    msg
                )
            )
        else
            print(
                string.format(
                    "%s[%s] [%s]%s %s: %s",
                    log.use_color and x.color or "",
                    os.date("%Y-%m-%d %H:%M:%S %z"),
                    name_upper,
                    log.use_color and "\27[0m" or "",
                    line_info,
                    msg
                )
            )
        end
    end
end

return log
