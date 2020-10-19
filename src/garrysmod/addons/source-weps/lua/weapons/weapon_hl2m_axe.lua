SWEP.Base = "weapon_hl2basebludgeon"
SWEP.PrintName = "Axe"
SWEP.Category = "Half-Life 2 Remake - Melee Pack"

SWEP.Spawnable = true

SWEP.Slot = 0
SWEP.SlotPos = 1

SWEP.HoldType = "melee2"

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/props/cs_militia/axe.mdl"

SWEP.Range = 55
SWEP.MELEE_HIT = "npc/ministrider/flechette_flesh_impact1.wav"
SWEP.SINGLE = "WeaponFrag.Roll"

SWEP.Primary.Damage = 30
SWEP.Primary.Delay = 1

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
            ent:Remove()
        end
    end

    function SWEP:DrawWorldModel()
        local owner = self:GetOwner()
        if not IsValid(owner) then
            self:DrawModel()
            return
        else
            self:DrawShadow(false)
            self:AddWM(owner,"models/props/cs_militia/axe.mdl",Vector(1.4,-2,4.2),Angle(5,0,90),false,Vector(1,1,1),"")
        end
    end

    function SWEP:PostDrawViewModel(vm,ply,wep)
        if not IsValid(vm) then return end
        vm:SetMaterial("engine/occlusionproxy")
        self:AddVM(vm,"models/props/cs_militia/axe.mdl",Vector(1.5,-2,2.5),Angle(0,0,90),"ValveBiped.Bip01_R_Hand",Vector(1,1,1),"")
    end
end

function SWEP:DoHide()
    if CLIENT then
        local owner = self:GetOwner() or LocalPlayer()

        if IsValid(owner) then
            local vm = owner:GetViewModel() or NULL
            if IsValid(vm) then vm:SetMaterial() end
        end
    end
end

function SWEP:Holster(wep)
    self:DoHide()
    return true
end

function SWEP:OnDrop()
    self:DoHide()
    return true
end
