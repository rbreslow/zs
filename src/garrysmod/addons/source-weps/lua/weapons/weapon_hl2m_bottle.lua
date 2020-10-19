SWEP.Base = "weapon_hl2basebludgeon"
SWEP.PrintName = "Bottle"
SWEP.Category = "Half-Life 2 Remake - Melee Pack"

DEFINE_BASECLASS("weapon_hl2basebludgeon")

SWEP.Spawnable = true

SWEP.Slot = 0
SWEP.SlotPos = 1

SWEP.HoldType = "melee"

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/props_junk/glassbottle01a.mdl"

SWEP.ViewModelFOV = 70

SWEP.Range = 60
SWEP.MELEE_HITWORLD = "GlassBottle.Break"
SWEP.MELEE_HIT = "GlassBottle.Break"
SWEP.SINGLE = "WeaponFrag.Roll"

SWEP.Primary.Damage = 10
SWEP.Primary.Delay = .5

function SWEP:SetupDataTables()
    BaseClass.SetupDataTables(self)
    self:NetworkVar("Bool", 2, "Broken")
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
            self:AddWM(owner,self:GetBroken() and "models/props_junk/glassbottle01a_chunk01a.mdl" or "models/props_junk/glassbottle01a.mdl",self:GetBroken() and Vector(1.5,-2,3.5) or Vector(1.5,-5,3.5),Angle(0,90,0),false,Vector(1,1,1),"")
        end
    end

    function SWEP:PostDrawViewModel(vm,ply,wep)
        if not IsValid(vm) then return end
        vm:SetMaterial("engine/occlusionproxy")
        self:AddVM(vm,self:GetBroken() and "models/props_junk/glassbottle01a_chunk01a.mdl" or "models/props_junk/glassbottle01a.mdl",self:GetBroken() and Vector(1.2,-2,2.5) or Vector(1.2,-5,2.5),Angle(0,90,0),"ValveBiped.Bip01_R_Hand",Vector(1,1,1),"")
    end
end

function SWEP:SecondaryAttack()
    if CLIENT then return end

    if not self:GetBroken() then
        local pl = self:GetOwner()

        local thrown = ents.Create("prop_physics")
        thrown:SetModel(self.WorldModel)
        thrown:SetOwner(pl)
        thrown:SetAngles(pl:EyeAngles())
        thrown:SetPhysicsAttacker(pl,math.huge)

        thrown:SetPos(pl:GetShootPos())
        thrown:Spawn()
        thrown:Activate()
        thrown.Thrown = true

        local phys = thrown:GetPhysicsObject()
        phys:SetVelocity(pl:GetAimVector() * 2000)
        phys:AddAngleVelocity(Vector(0, 500, 0))

        pl:StripWeapon(self:GetClass())
    end
end

function SWEP:OnHit()
    if not self:GetBroken() then
        self:SetBroken(true)
        self:SetHoldType("knife")

        
        self.Primary.Damage = 30
        self.Range = 40
        self.MELEE_HIT = "Flesh_Bloody.ImpactHard"
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
