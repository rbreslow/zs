local player_meta = FindMetaTable("Player")

function player_meta:get_role()
    return self:GetNW2String("role") or "user"
end
player_meta.GetUserGroup = player_meta.get_role

function player_meta:IsSuperAdmin()
    return self:get_role() == "admin"
end
player_meta.IsAdmin = player_meta.IsSuperAdmin
