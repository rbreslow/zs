SWEP.PrintName = "#HL2_Pulse_Rifle"
SWEP.Base = "weapon_hl2basemg"
SWEP.Category = "Half-Life 2 Remake"

DEFINE_BASECLASS("weapon_hl2basemg")

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/c_irifle.mdl"
SWEP.WorldModel = "models/weapons/w_irifle.mdl"

SWEP.EMPTY = "Weapon_AR2.Empty"
SWEP.SINGLE = "Weapon_AR2.Single"
SWEP.CharLogo = "l"
SWEP.Cone = Vector(0.026180, 0.026180, 0)
SWEP.Tracer = "AR2Tracer"

SWEP.HoldType = "ar2"
SWEP.Slot = 2
SWEP.SlotPos = 2

SWEP.Primary.Ammo = "AR2"
SWEP.Primary.DefaultClip = 30
SWEP.Primary.ClipSize = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Delay = .1
SWEP.Primary.Damage = 8

SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Ammo = "AR2AltFire"
SWEP.Secondary.Automatic = true

SWEP.IconOverride = "entities/weapon_ar2.png"

local sk_plr_dmg_ar2 = GetConVar("sk_plr_dmg_ar2")
local sk_weapon_ar2_alt_fire_radius = GetConVar("sk_weapon_ar2_alt_fire_radius")
local sk_weapon_ar2_alt_fire_mass = GetConVar("sk_weapon_ar2_alt_fire_mass")
local sk_weapon_ar2_alt_fire_duration = GetConVar("sk_weapon_ar2_alt_fire_duration")

local function RemapValClamped(val, A,B,C,D)
    local cVal = (val - A) / (B - A)
    --cVal = sature(cVal)

    return C + (D - C) * cVal
end

function SWEP:SetupDataTables()
    BaseClass.SetupDataTables(self)
    self:NetworkVar("Bool", 2, "ShotDelayed")
    self:NetworkVar("Float", 2, "DelayedFire")
    self:NetworkVar("Entity", 0, "Projectile")
end

function SWEP:Initialize()
    BaseClass.Initialize(self)
    self.Primary.Damage = sk_plr_dmg_ar2:GetInt()
end

function SWEP:AddViewKick()
    local EASY_DAMPEN = .5
    local MAX_VERTICAL_KICK = 8
    local SLIDE_LIMIT = 5

    self:DoMachineGunKick(EASY_DAMPEN, MAX_VERTICAL_KICK, self:GetFireDuration(), SLIDE_LIMIT)
end

function SWEP:DoImpactEffect(trace, DamageType)
    local data = EffectData()

    data:SetOrigin(trace.HitPos + (trace.HitNormal * 1))
    data:SetNormal(trace.HitNormal)

    util.Effect("AR2Impact", data)
end

function SWEP:SecondaryAttack()
    if not self:CanSecondaryAttack() then return end
    if self:GetShotDelayed() then return end

    if self:GetOwner():KeyDown(IN_RELOAD) then
        if CLIENT and not IsFirstTimePredicted() then return end
        self:SetRapidFire(not self:GetRapidFire())
        return
    end

    if not self:CanSecondaryAttack() then return end

    if self:GetOwner():WaterLevel() == 3 then
        self:SetWeaponAnim(ACT_VM_DRYFIRE)
        self:EmitSound("Weapon_AR2.Empty")
        self:SetNextSecondaryFire(CurTime() + .5)

        return
    end

    self:SetShotDelayed(true)
    self:SetDelayedFire(CurTime() + (self:GetRapidFire() and .1 or .5))
    self:SetNextPrimaryFire(self:GetDelayedFire())

    self:SetWeaponAnim(ACT_VM_FIDGET)
    self:EmitSound("Weapon_CombineGuard.Special1")
end

function SWEP:Holster()
    if self:GetShotDelayed() then return false end

    return true
end

function SWEP:DelayedAttack()
    self:SetShotDelayed(false)

    self:SetWeaponAnim(ACT_VM_SECONDARYATTACK)
    self:SetNextPrimaryFire((self:GetRapidFire() and 0 or CurTime()) + self:SequenceDuration())

    self:GetOwner():MuzzleFlash()

    self:EmitSound("Weapon_AR2.Double")

    local vecSrc = self:GetOwner():GetShootPos()
    local vecAiming = self:GetOwner():GetAimVector()

    local vecVelocity = vecAiming * 1000

    if SERVER then
        local ball = util.CreateCombineBall(
            vecSrc,
            vecVelocity,
            sk_weapon_ar2_alt_fire_radius:GetFloat(),
            sk_weapon_ar2_alt_fire_mass:GetFloat(),
            sk_weapon_ar2_alt_fire_duration:GetFloat(),
            self:GetOwner()
        )
        self:SetProjectile(ball)
        ball:SetNWVector("_vel", vecAiming)

        if not self:GetRapidFire() then -- epilepsy warning
            self:GetOwner():ScreenFade(SCREENFADE.IN,nil,.1,0)
        end
    end

    self:GetOwner():ViewPunch(Angle(util.SharedRandom("ar2pax", -8, -12), util.SharedRandom("ar2pay", 1, 2), 0))

    self:TakeSecondaryAmmo(1)

    self:SetNextPrimaryFire((self:GetRapidFire() and 0 or CurTime()) + .5)

    self:SetNextSecondaryFire((self:GetRapidFire() and 0 or CurTime()) + 1)
end

function SWEP:Think()
    local owner = self:GetOwner()

    if self:GetShotDelayed() and CurTime() > self:GetDelayedFire() then
        self:DelayedAttack()
    end

    -- Really stupid hack, otherwise the ball sticks in your face for a second
    local ball = self:GetProjectile()
    if CLIENT and IsValid(ball) and not ball._cl_init then
        if IsValid(ball:GetPhysicsObject()) then
            ball:GetPhysicsObject():SetVelocityInstantaneous(ball:GetNWVector("_vel", owner:GetAimVector()) * 1000)
        end
        ball._cl_init = true
    end

    local vm = owner:GetViewModel()
    if IsValid(vm) then
        local VentPose = RemapValClamped(self:GetShotsFired(), 0, 5, 0, 1)
        vm:SetPoseParameter("VentPoses", VentPose)
    end

    BaseClass.Think(self)
end
