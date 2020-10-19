SWEP.PrintName = "#HL2_Pistol"
SWEP.Base = "weapon_hl2base"
SWEP.Category = "Half-Life 2 Remake"

DEFINE_BASECLASS("weapon_hl2base")

SWEP.Spawnable = true
SWEP.FiresUnderWater = true

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Slot = 1
SWEP.SlotPos = 1

SWEP.EMPTY = "Weapon_Pistol.Empty"
SWEP.SINGLE = "Weapon_Pistol.Single"
SWEP.RELOAD = "Weapon_Pistol.Reload"
SWEP.CharLogo = "d"

SWEP.Primary.Ammo = "pistol"
SWEP.Primary.DefaultClip = 18
SWEP.Primary.ClipSize = 18
SWEP.Primary.Automatic = true
SWEP.Primary.Damage = 5
SWEP.Primary.Delay = .5

SWEP.Cone = Vector(0,0,0)

SWEP.IconOverride = "entities/weapon_pistol.png"

local PISTOL_ACCURACY_SHOT_PENALTY_TIME = 0.2 -- Applied amount of time each shot adds to the time we must recover from
local PISTOL_ACCURACY_MAXIMUM_PENALTY_TIME = 1.5 -- Maximum penalty to deal out

local sk_plr_dmg_pistol = GetConVar("sk_plr_dmg_pistol")

function SWEP:SetupDataTables()
    BaseClass.SetupDataTables(self)
    self:NetworkVar("Float", 3, "AccuracyPenalty")
    self:NetworkVar("Float", 4, "SoonestPrimaryAttack")
end

function SWEP:Initialize()
    BaseClass.Initialize(self)
    self.Primary.Damage = sk_plr_dmg_pistol:GetInt()
end

local function RemapValClamped(val, A,B,C,D)
    local cVal = (val - A) / (B - A)
    --cVal = sature(cVal)

    return C + (D - C) * cVal
end

function SWEP:GetAimCone()
    local ramp = RemapValClamped(self:GetAccuracyPenalty(),
                            0,
                            PISTOL_ACCURACY_MAXIMUM_PENALTY_TIME,
                            0,
                            1)

    local cone = LerpVector(ramp, Vector(.01, .01, 0), Vector(.06, .06, 0))
    return cone
end

function SWEP:GetPrimaryAttackActivity()
    if self:GetShotsFired() < 2 then
        return ACT_VM_PRIMARYATTACK
    elseif self:GetShotsFired() < 3 then
        return ACT_VM_RECOIL1
    elseif self:GetShotsFired() < 4 then
        return ACT_VM_RECOIL2
    end

    return ACT_VM_RECOIL3
end

function SWEP:PrimaryAttack()
    if not self:CanPrimaryAttack() then return end

    if CurTime() - self:LastShootTime() > .5 then
        self:SetShotsFired(0)
    else
        self:SetShotsFired(self:GetShotsFired() + 1)
    end

    if self:GetOwner() then
        self:GetOwner():ViewPunchReset()
    end

    BaseClass.PrimaryAttack(self)

    self:SetAccuracyPenalty(self:GetAccuracyPenalty() + PISTOL_ACCURACY_SHOT_PENALTY_TIME)
end

function SWEP:Reload()
    self:SetAccuracyPenalty(0)
    BaseClass.Reload(self)
end

function SWEP:AddViewKick()
    self:GetOwner():ViewPunch( Angle( util.SharedRandom("pistolpax", .25, .5), util.SharedRandom("pistolpay", -.6, .6), 0 ) )
end

function SWEP:Think()
    BaseClass.Think(self)
    local owner = self:GetOwner()
    if not owner then return end

    -- Shoot as fast as you can cick
    if not self:GetInReload() and not owner:KeyDown(IN_ATTACK) and self:GetNextPrimaryFire() > CurTime() then
        self:SetNextPrimaryFire(CurTime() - .1)
    end

    -- Update penalty time
    if not owner:KeyDown(IN_ATTACK) and self:GetSoonestPrimaryAttack() < CurTime() then
        self:SetAccuracyPenalty(self:GetAccuracyPenalty() - FrameTime())
        self:SetAccuracyPenalty(math.Clamp(self:GetAccuracyPenalty(), 0, PISTOL_ACCURACY_MAXIMUM_PENALTY_TIME))
    end
end
