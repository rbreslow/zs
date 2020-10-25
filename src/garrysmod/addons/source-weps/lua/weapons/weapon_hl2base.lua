SWEP.PrintName = "YOU FORGOT TO NAME A SWEP."
SWEP.Category = "Half-Life 2 Remake"

local bIsTTT = util.NetworkStringToID("TTT_RoundState") ~= 0
SWEP.bIsTTT = bIsTTT
SWEP.Base = "weapon_base"

if bIsTTT then
    SWEP.Base = "weapon_tttbase"
    SWEP.Kind = WEAPON_HEAVY
    SWEP.AmmoEnt = "item_ammo_smg1_ttt"
    SWEP.AllowDrop = true
    SWEP.IsSilent = false
    SWEP.NoSights = true
    --SWEP.AutoSpawnable = true

    SWEP.ViewModelFlip = false
    SWEP.DrawCrosshair = true
end

DEFINE_BASECLASS(SWEP.Base)

SWEP.BounceWeaponIcon = false
SWEP.DrawWeaponInfoBox = false
SWEP.CharLogo = "a"

SWEP.Tracer = "Tracer"
SWEP.TracerFreq = 2
SWEP.EMPTY = "Weapon_Pistol.Empty"
SWEP.SINGLE = "Weapon_Pistol.Single"
SWEP.HoldType = "pistol"
SWEP.Cone = Vector(.15,.15,0)
SWEP.BulletsPerShot = 1
SWEP.FiresUnderWater = false

SWEP.UseHands = true
SWEP.ViewModelFOV = 54

SWEP.Slot = 1
SWEP.SlotPos = 2

SWEP.Primary.Ammo = "pistol"
SWEP.Primary.DefaultClip = 12
SWEP.Primary.ClipSize = 12
SWEP.Primary.Automatic = true
SWEP.Primary.Damage = 6
SWEP.Primary.Delay = .1

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Damage = 1

SWEP.Models = {}

function SWEP:Precache()
    util.PrecacheModel(self.WorldModel)
    util.PrecacheModel(self.ViewModel)

    for k,v in next, self.Models do
        if util.IsValidModel(v) and not IsUselessModel(v) then
            util.PrecacheModel(v)
        end
    end
end

function SWEP:SetupDataTables()
    self:NetworkVar("Int", 0, "ShotsFired")
    self:NetworkVar("Bool", 0, "RapidFire")
    self:NetworkVar("Float", 0, "FireDuration")
    self:NetworkVar("Bool", 1, "InReload")
    self:NetworkVar("Float", 1, "FinishReloadTime")
    self:NetworkVar("Float", 2, "WeaponIdleTime")
end

function SWEP:Initialize()
    self:SetHoldType(self.HoldType)
    self:SetDeploySpeed(bIsTTT and self.DeploySpeed or 1)
end

function SWEP:GetAimCone()
    return self.Cone
end

local function DrawFontIcon(wep, x, y, w, h, char, font1, font2, offset)
    y = y + (offset or 0)
    x = x + 10
    w = w - 20

    draw.DrawText(char,font2,x + w / 2,y,Color(255,220,0),TEXT_ALIGN_CENTER)
    draw.DrawText(char,font1,x + w / 2,y,Color(255,220,0),TEXT_ALIGN_CENTER)
end

function SWEP:DrawWeaponSelection(x,y,w,h,a)
    DrawFontIcon(self, x,y, w,h, self.CharLogo, "_sw_wepfont_0","_sw_wepfont_1", 24)

    return
end

function SWEP:AdjustMouseSensitivity()
    local owner = self:GetOwner()
    return owner:GetFOV() / owner:GetInfoNum("fov_desired", 90)
end

function SWEP:UsesClipsForAmmo1()
    return self:GetMaxClip1() ~= -1
end

function SWEP:UsesClipsForAmmo2()
    return self:GetMaxClip2() ~= -1
end

function SWEP:GetPrimaryAttackActivity()
    return ACT_VM_PRIMARYATTACK
end

function SWEP:GetSecondaryAttackActivity()
    return ACT_VM_SECONDARYATTACK
end

function SWEP:AddViewKick()
    -- NOTE: By default, weapon will not kick up (defined per weapon)
end

function SWEP:Holster()
    self:SetInReload(false)
    self:SetFinishReloadTime(0)
    self:SetShotsFired(0)

    return true
end

function SWEP:TertiaryAttack() end -- <3

function SWEP:GetIdleAct()
    return ACT_VM_IDLE
end

function SWEP:HasWeaponIdleTimeElapsed()
    return CurTime() > self:GetWeaponIdleTime()
end

function SWEP:SetWeaponSequence(idealSequence, flPlaybackRate)
    if idealSequence == -1 then return false end
    flPlaybackRate = flPlaybackRate or 1

    self:SendViewModelMatchingSequence(idealSequence)
    local owner = self:GetOwner()
    if owner:IsValid() then
        local vm = owner:GetViewModel()
        if vm:IsValid() then
            vm:SendViewModelMatchingSequence(idealSequence)
            vm:SetPlaybackRate(flPlaybackRate)
        end
    end

    -- Set the next time the weapon will idle
    self:SetWeaponIdleTime(CurTime() + (self:SequenceDuration(idealSequence) * flPlaybackRate))
    return true
end
function SWEP:SetWeaponAnim(idealAct, flPlaybackRate)
    local idealSequence = self:SelectWeightedSequence(idealAct)
    if idealSequence == -1 then return false end
    flPlaybackRate = flPlaybackRate or 1

    self:SendWeaponAnim(idealAct)
    self:SendViewModelMatchingSequence(idealSequence)
    --self:SetPlaybackRate(flPlaybackRate)

    -- Set the next time the weapon will idle
    self:SetWeaponIdleTime(CurTime() + (self:SequenceDuration() * flPlaybackRate))
    return true
end
function SWEP:WeaponIdle()
    if self:HasWeaponIdleTimeElapsed() then
        self:SetWeaponAnim(self:GetIdleAct())
    end
end

function SWEP:Think()
    local owner = self:GetOwner()
    if not owner then return end

    if self:GetInReload() then
        if self:GetFinishReloadTime() > CurTime() then
            self:InReloadThink()
        else
            local dif = self:GetMaxClip1() - self:Clip1()
            local amt = math.min(self:Clip1() + self:GetOwner():GetAmmoCount(self.Primary.Ammo), self:GetMaxClip1())

            self:GetOwner():RemoveAmmo(dif, self.Primary.Ammo)
            self:SetClip1(amt)

            self:SetInReload(false)
            self:OnFinishReload()
        end
    end

    if owner:KeyDown(IN_ATTACK3) then
        self:TertiaryAttack()
    end

    -- No buttons down
    if not owner:KeyDown(bit.bor(IN_ATTACK, IN_ATTACK2, IN_ATTACK3)) and not self:GetInReload() then
        self:WeaponIdle()
    end
end

function SWEP:CanReload()
    if self:GetInReload() then return false end
    if self:Clip1() >= self:GetMaxClip1() then return false end
    if self:GetNextPrimaryFire() > CurTime() and not (self.GetForceReload and self:GetForceReload()) then return false end
    local owner = self:GetOwner()
    if not IsValid(owner) then return false end
    if owner:GetAmmoCount(self.Primary.Ammo) < 1 then return false end

    return true
end

function SWEP:OnStartReload() end

function SWEP:InReloadThink() end

function SWEP:OnFinishReload() end

function SWEP:OnReloadFail() end

function SWEP:GetReloadActivity()
    return ACT_VM_RELOAD
end

function SWEP:Reload()
    local ok = self:CanReload()

    if ok then
        self:SetInReload(true)
        self:SetWeaponAnim(self:GetReloadActivity())
        if self.RELOAD then
            self:EmitSound(self.RELOAD)
        end

        self:SetShotsFired(0)
        self:SetFinishReloadTime(CurTime() + self:SequenceDuration())
        self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
        self:SetNextSecondaryFire(CurTime() + self:SequenceDuration())

        self:GetOwner():DoReloadEvent()

        self:OnStartReload()
    else
        self:OnReloadFail()
    end
end

function SWEP:CanPrimaryAttack()
    local can = true
    if self:UsesClipsForAmmo1() and self:Clip1() <= 0 then
        can = false
    end
    if not self:UsesClipsForAmmo1() and self:GetOwner():GetAmmoCount(self.Primary.Ammo) <= 0 then
        can = false
    end
    if self:GetOwner():WaterLevel() == 3 and not self.FiresUnderWater then
        can = false
    end

    if not can then
        self:EmitSound(self.EMPTY)
        self:SetNextPrimaryFire(CurTime() + .5)
    end

    return can
end

function SWEP:CanSecondaryAttack()
    local can = true
    if self:UsesClipsForAmmo2() and self:Clip2() <= 0 then
        can = false
    end
    if not self:UsesClipsForAmmo2() and self:GetOwner():GetAmmoCount(self.Secondary.Ammo) <= 0 then
        can = false
    end
    if self:GetOwner():WaterLevel() == 3 and not self.FiresUnderWater then
        can = false
    end

    if not can then
        self:EmitSound(self.EMPTY)
        self:SetNextSecondaryFire(CurTime() + .5)
    end

    return can
end

function SWEP:OnPrimaryAttack() end

function SWEP:BulletCallback(atk, tr, dmg) end

function SWEP:PrimaryAttack()
    if not self:CanPrimaryAttack() then return end
    local owner = self:GetOwner()

    owner:MuzzleFlash()

    self:EmitSound(self.SINGLE)
    self:SetWeaponAnim(self:GetPrimaryAttackActivity())

    -- player "shoot" animation
    owner:SetAnimation(PLAYER_ATTACK1)

    self:GetOwner():FireBullets({
        Src = owner:GetShootPos(),
        Dir = owner:GetAimVector(),
        Num = self.BulletsPerShot,
        AmmoType = self.Primary.Ammo,
        Tracer = self.TracerFreq,
        TracerName = self.Tracer,
        Attacker = self:GetOwner(),
        Spread = self:GetAimCone(),
        Damage = self.Primary.Damage,
        Callback = function(atk, tr, dmg)
            self:BulletCallback(atk, tr, dmg)
        end
    })

    self:TakePrimaryAmmo(1)
    self:SetNextPrimaryFire(self:GetRapidFire() and 0 or CurTime() + self.Primary.Delay)
    self:SetNextSecondaryFire(self:GetRapidFire() and 0 or CurTime() + self.Primary.Delay)
    self:SetLastShootTime()

    self:SetShotsFired(self:GetShotsFired() + 1)

    self:OnPrimaryAttack()
    self:AddViewKick()
end

function SWEP:SecondaryAttack() end
