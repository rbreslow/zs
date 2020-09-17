local Command = {}
Command.prototype = {}
Command.__index = Command.prototype

Command.argument_types = {}

setmetatable(Command, {
    __call = function(self, name, perm)
        local obj = {}
        obj.name = name or ""
        obj.perm = perm or nil
        obj.argument_types = {}
        obj.required_args = #obj.argument_types
        
        return setmetatable(obj, self)
    end
})

function Command.prototype:register_argument(argument_name, argument, is_required)
    assert(Command.argument_types[argument] ~= nil)
    
    table.insert(self.argument_types, { name = argument_name, type = argument, is_required = is_required })
    if is_required then
        self.required_args = self.required_args + 1
    end
end

function Command.prototype:usage()
    local msg = string.format("usage: %s", self.name)
    
    for _, arg in ipairs(self.argument_types) do
        if arg.is_required then
            msg = string.format("%s <%s>", msg, arg.name)
        else
            msg = string.format("%s [%s]", msg, arg.name)
        end
    end
    
    return msg
end

function Command.prototype:parse(raw_args)
    if #raw_args < self.required_args then
        return string.format(
            "%s\nNot enough arguments. %d expected. %d provided.",
            self:usage(),
            self.required_args,
            #raw_args
        )
    end

    local parsed_args = {}

    for i = 1, #self.argument_types do
        local arg
        
        if #raw_args > #self.argument_types and i == #self.argument_types then
            for j = i, #raw_args do
                if arg then
                    arg = arg .. " " .. raw_args[j]
                else
                    arg = raw_args[j]
                end
            end
        else
            arg = raw_args[i]
        end
        
        if arg then
            local parsed_arg = Command.argument_types[self.argument_types[i].type](arg)
            if parsed_arg then
                parsed_args[i] = parsed_arg
            else
                return string.format(
                    "\"%s\" is not a valid %s.",
                    arg,
                    self.argument_types[i].type
                )
            end
        end
    end

    return parsed_args
end

function Command.prototype:execute()
    error("Attempted to call unimplemented method Command#execute.")
end

Howl.Command = Command

local search = string.format("%s/gamemode/howl/argument_types/*", GM.FolderName)
for _, v in ipairs(file.Find(search, "LUA")) do
    include(string.format("argument_types/%s", v))
end
