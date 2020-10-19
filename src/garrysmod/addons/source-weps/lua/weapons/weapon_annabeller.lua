SWEP.PrintName = "#HL2_ANNABELLE"
SWEP.Base = "weapon_hl2base"
SWEP.Category = "Half-Life 2 Remake"
DEFINE_BASECLASS("weapon_hl2base")

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/c_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_annabelle.mdl"

SWEP.EMPTY = "Weapon_Alyx_Gun.Empty"
SWEP.SINGLE = "weapons/shotgun/shotgun_fire6.wav"
SWEP.RELOAD = "weapons/shotgun/shotgun_reload2.wav"

SWEP.CharLogo = "("
SWEP.Cone = Vector(.02,.02,0)

SWEP.HoldType = "ar2"
SWEP.Slot = 2
SWEP.SlotPos = 3

SWEP.Primary.Ammo = "357"
SWEP.Primary.DefaultClip = 2
SWEP.Primary.ClipSize = 2
SWEP.Primary.Automatic = true
SWEP.Primary.Delay = 1.5
SWEP.Primary.Damage = 40

SWEP.IconOverride = "entities/weapon_annabelle.png"

local sk_plr_dmg_357 = GetConVar("sk_plr_dmg_357")

function SWEP:Initialize()
    BaseClass.Initialize(self)
    self.Primary.Damage = sk_plr_dmg_357:GetInt()
end

if CLIENT then
    function SWEP:AddWM(owner,mdl,pos,ang,left,scale,mat,col)
        local b = "ValveBiped.Bip01_" .. (left and "L" or "R") .. "_Hand"
        if (owner:LookupBone(b) ~= nil) then
            local bnep,bnea = owner:GetBonePosition(owner:LookupBone(b))
            bnep:Add(bnea:Right() * pos.x)
            bnep:Add(bnea:Up() * pos.y)
            bnep:Add(bnea:Forward() * pos.z)
            bnea:RotateAroundAxis(bnea:Right(),ang.x)
            bnea:RotateAroundAxis(bnea:Up(),ang.y)
            bnea:RotateAroundAxis(bnea:Forward(),ang.z)
            local m = Matrix()
            m:Scale(scale)
            local ent = ClientsideModel(mdl,RENDERGROUP_OTHER)
            if not IsValid(ent) then return end

            ent:SetModel(mdl)
            ent:SetNoDraw(true)
            ent:SetPos(bnep)
            ent:SetAngles(bnea)
            ent:EnableMatrix("RenderMultiply",m)
            if mat then
                ent:SetMaterial(mat)
            end
            col = col or Color(255,255,255)
            render.SetColorModulation(col.r / 255,col.g / 255,col.b / 255)
            ent:DrawModel()
            ent:Remove()
        end
    end

    function SWEP:AddVM(vm,mdl,pos,ang,bone,scale,mat,col)
        local b = tostring(bone)
        if (vm:LookupBone(b) ~= nil) then
            local bnep,bnea = vm:GetBonePosition(vm:LookupBone(b))
            bnep:Add(bnea:Right() * pos.x)
            bnep:Add(bnea:Up() * pos.y)
            bnep:Add(bnea:Forward() * pos.z)
            bnea:RotateAroundAxis(bnea:Right(),ang.x)
            bnea:RotateAroundAxis(bnea:Up(),ang.y)
            bnea:RotateAroundAxis(bnea:Forward(),ang.z)
            local m = Matrix()
            m:Scale(scale)
            local ent = ClientsideModel(mdl,RENDERGROUP_OTHER)
            if not IsValid(ent) then return end

            ent:SetModel(mdl)
            ent:SetNoDraw(true)
            ent:SetPos(bnep)
            ent:SetAngles(bnea)
            ent:EnableMatrix("RenderMultiply",m)
            if mat then
                ent:SetMaterial(mat)
            end
            col = col or Color(255,255,255)
            render.SetColorModulation(col.r / 255,col.g / 255,col.b / 255)
            ent:DrawModel()
            if self:GetOwner():FlashlightIsOn() then
                render.PushFlashlightMode(true)
                ent:DrawModel()
                render.PopFlashlightMode()
            end
            ent:Remove()
        end
    end

    function SWEP:PreDrawViewModel(vm, wep, ply)
        vm:SetMaterial("engine/occlusionproxy")
    end

    function SWEP:PostDrawViewModel(vm, wep, ply)
        if not IsValid(vm) then return end
        vm:SetMaterial("")
        self:AddVM(vm,"models/weapons/w_annabelle.mdl",Vector(2.5,0,-1),Angle(-90,-5,-90),"ValveBiped.Gun",Vector(1,1,1),"")
    end
end

function SWEP:OnRemove()
    if CLIENT then
        local owner = self:GetOwner() or LocalPlayer()

        if IsValid(owner) then
            local vm = owner:GetViewModel() or NULL
            if IsValid(vm) then vm:SetMaterial() end
        end
    end
end

function SWEP:Holster(wep)
    self:OnRemove()
    return true
end

function SWEP:OnDrop()
    self:OnRemove()
    return true
end
