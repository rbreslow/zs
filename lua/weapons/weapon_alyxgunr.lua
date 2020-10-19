SWEP.PrintName = "#HL2_ALYXGUN"
SWEP.Base = "weapon_hl2basemg"
SWEP.Category = "Half-Life 2 Remake"

DEFINE_BASECLASS("weapon_hl2basemg")

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_alyx_gun.mdl"

SWEP.EMPTY = "Weapon_Alyx_Gun.Empty"
SWEP.SINGLE = "Weapon_Alyx_Gun.Single"
SWEP.BURST = "Weapon_Alyx_Gun.Burst"
SWEP.RELOAD = "Weapon_Alyx_Gun.NPC_Reload"
SWEP.SPECIAL1 = "Weapon_Alyx_Gun.Special1"
SWEP.SPECIAL2 = "Weapon_Alyx_Gun.Special2"

SWEP.CharLogo = "%"
SWEP.Cone = Vector(.02,.02,0)

SWEP.HoldType = "pistol"
SWEP.Slot = 1
SWEP.SlotPos = 3

SWEP.Primary.Ammo = "AlyxGun"
SWEP.Primary.DefaultClip = 30 * 5
SWEP.Primary.ClipSize = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Delay = .1
SWEP.Primary.BurstDelay = .05

SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = true

SWEP.IconOverride = "entities/weapon_alyxgun.png"

function SWEP:SetupDataTables()
    BaseClass.SetupDataTables(self)
    self:NetworkVar("Int", 1, "FireType")
    self:NetworkVar("Int", 2, "BurstNum")
    self:NetworkVar("Float", 3, "NextBurstFire")
end

function SWEP:Initialize()
    BaseClass.Initialize(self)
    self:SetFireType(2)
end

function SWEP:SwitchFireType()
    if CLIENT and not IsFirstTimePredicted() then return end

    local current = self:GetFireType()
    self:SetFireType(current + 1)

    if current == 1 then
        self:EmitSound(self.SPECIAL1)
    elseif current == 2 then
        self:EmitSound(self.SPECIAL2)
    end

    if self:GetFireType() > 2 then
        self:SetFireType(1)
    end
end

function SWEP:SecondaryAttack()
    self:SwitchFireType()
    self:SetNextSecondaryFire(CurTime() + .3)
end

local sk_plr_dmg_alyxgun = GetConVar("sk_plr_dmg_alyxgun")
function SWEP:PrimaryAttack()
    if not self:CanPrimaryAttack() then return end

    --[[if self:GetFireType() == 0 then -- Single
        --print"pew pew"
    else--]]
    if self:GetFireType() == 1 then -- Burst
        self:EmitSound(self.BURST)

        self:SetBurstNum(3)

        self:SetNextPrimaryFire(CurTime() + .5)
    elseif self:GetFireType() == 2 then -- Auto
        BaseClass.PrimaryAttack(self)
    end
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
        self:AddVM(vm,"models/weapons/w_alyx_gun.mdl",Vector(2.5,-4.8,6),Angle(-10,-175,-170),"ValveBiped.Bip01_R_Hand",Vector(1,1,1),"")
    end
end

function SWEP:Think()
    BaseClass.Think(self)

    if self:GetBurstNum() > 0 and
        self:GetNextBurstFire() <= CurTime() and
        self:Clip1() > 0
    then
        local owner = self:GetOwner()
        if not owner:IsValid() then return end

        self:FireBullets({
            Damage = sk_plr_dmg_alyxgun:GetInt(),
            Force = 1,
            Num = 1,
            Spread = self.Cone,
            AmmoType = self.Primary.Ammo,
            Tracer = self.TracerFreq,
            TracerName = self.Tracer,
            Dir = (owner:GetAimVector():Angle() + owner:GetViewPunchAngles()):Forward(),
            Src = owner:GetShootPos(),
            Attacker = owner
        })

        self:AddViewKick()

        self:SetWeaponAnim(self:GetPrimaryAttackActivity())
        owner:SetAnimation(PLAYER_ATTACK1)

        self:TakePrimaryAmmo(1)
        if self:Clip1() >= 1 then
            self:SetBurstNum(self:GetBurstNum() - 1)
            self:SetShotsFired(self:GetShotsFired() + 1)
        else
            self:SetBurstNum(0)
        end
        self:SetNextBurstFire(CurTime() + self.Primary.BurstDelay)
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
