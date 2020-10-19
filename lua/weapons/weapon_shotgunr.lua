SWEP.PrintName = "#HL2_Shotgun"
SWEP.Base = "weapon_hl2base"
SWEP.Category = "Half-Life 2 Remake"

DEFINE_BASECLASS("weapon_hl2base")

SWEP.Spawnable = true
SWEP.ViewModel = "models/weapons/c_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"
SWEP.CharLogo = "b"
SWEP.Slot = 3
SWEP.SlotPos = 1
SWEP.HoldType = "shotgun"

SWEP.Primary.DefaultClip = 6
SWEP.Primary.ClipSize = 6
SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.Automatic = true

SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = true

SWEP.SINGLE = "Weapon_Shotgun.Single"
SWEP.EMPTY = "Weapon_Shotgun.Empty"
SWEP.RELOAD = "Weapon_Shotgun.Reload"
SWEP.BulletsPerShot = 7
SWEP.Cone = Vector(.1,.1,0)

SWEP.IconOverride = "entities/weapon_shotgun.png"

function SWEP:SetupDataTables()
    BaseClass.SetupDataTables(self)
    self:NetworkVar("Bool", 2, "NeedPump")
end

function SWEP:Pump()
    self:SetNeedPump(false)

    if self.DelayedReload then
        self.DelayedReload = false
        self:StartReload()
    end

    self:EmitSound("Weapon_Shotgun.Special1")

    self:SetWeaponAnim(ACT_SHOTGUN_PUMP)

    self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
    self:SetNextSecondaryFire(CurTime() + self:SequenceDuration())
end

function SWEP:StartReload()
    if self:GetNeedPump() then return false end

    local owner = self:GetOwner()

    if owner:GetAmmoCount(self.Primary.Ammo) <= 0 then return false end

    if self:Clip1() >= self:GetMaxClip1() then return false end

    local j = math.min(1, owner:GetAmmoCount(self.Primary.Ammo))
    if j <= 0 then return false end

    self:SetWeaponAnim(ACT_SHOTGUN_RELOAD_START)
    --owner:GetViewModel():SetBodygroup(1, 0)
    owner:SetAnimation(PLAYER_RELOAD)

    self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())

    self:SetInReload(true)
    return true
end

function SWEP:InsertShell()
    if not self:GetInReload() then
        ErrorNoHalt("ERROR: Shotgun InsertShell() called incorrectly!")
        return
    end

    local owner = self:GetOwner()

    if not owner then return false end
    if owner:GetAmmoCount(self.Primary.Ammo) <= 0 then return false end
    if self:Clip1() >= self:GetMaxClip1() then return false end

    local j = math.min(1, owner:GetAmmoCount(self.Primary.Ammo))
    if j <= 0 then return false end

    self:FillClip()
    self:EmitSound(self.RELOAD)
    self:SetWeaponAnim(ACT_VM_RELOAD)

    self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
    self:SetNextSecondaryFire(CurTime() + self:SequenceDuration())
end

function SWEP:FinishReload()
    self:SetInReload(false)

    self:SetWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)

    self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
    self:SetNextSecondaryFire(CurTime() + self:SequenceDuration())
end

function SWEP:Reload()
    if self:GetInReload() then return end

    self:StartReload()
end

function SWEP:FillClip()
    if self:GetOwner():GetAmmoCount(self.Primary.Ammo) > 0 and
    self:Clip1() < self:GetMaxClip1() then
        self:SetClip1(self:Clip1() + 1)
        self:GetOwner():RemoveAmmo(1, self.Primary.Ammo)
    end
end

local sk_plr_num_shotgun_pellets = GetConVar("sk_plr_num_shotgun_pellets")
local sk_plr_dmg_buckshot = GetConVar("sk_plr_dmg_buckshot")
function SWEP:SecondaryAttack()
    if not self:CanSecondaryAttack() then return end

    if self:Clip1() < 2 then
        self:PrimaryAttack()
        return
    end

    self:EmitSound("Weapon_Shotgun.Double")
    self:GetOwner():MuzzleFlash()

    self:SetWeaponAnim(ACT_VM_SECONDARYATTACK)

    self:SetNextPrimaryFire((self:GetRapidFire() and 0 or CurTime()) + self:SequenceDuration())
    self:SetNextSecondaryFire((self:GetRapidFire() and 0 or CurTime()) + self:SequenceDuration())
    self:SetClip1(self:Clip1() - 2)

    self:GetOwner():SetAnimation(PLAYER_ATTACK1)

    self:FireBullets({
        Attacker = self:GetOwner(),
        Damage = sk_plr_dmg_buckshot:GetInt(),
        Force = 1,
        Num = sk_plr_num_shotgun_pellets:GetInt(),
        Spread = Vector(.1,.1,0),
        AmmoType = self.Primary.Ammo,
        Tracer = 2,
        Dir = self:GetOwner():GetAimVector(),
        Src = self:GetOwner():GetShootPos(),
    })

    local punch = Angle(util.SharedRandom("shotgunpax", -5, 5), 0, 0)
    self:GetOwner():ViewPunch(punch)

    self:SetNeedPump(not self:GetRapidFire())
end

function SWEP:PrimaryAttack()
    if not self:CanPrimaryAttack() then return end

    BaseClass.PrimaryAttack(self)
    self:SetNextPrimaryFire((self:GetRapidFire() and 0 or CurTime()) + self:SequenceDuration())
    self:SetNextSecondaryFire((self:GetRapidFire() and 0 or CurTime()) + self:SequenceDuration())

    self:SetNeedPump(not self:GetRapidFire())
end

function SWEP:AddViewKick()
    self:GetOwner():ViewPunch(Angle(util.SharedRandom("shotgunpax", -2, -1), util.SharedRandom("shotgunpay", -2, 2), 0))
end

function SWEP:CanSecondaryAttack()
    if not self:CanPrimaryAttack() then
        self:SetNextSecondaryFire(self:GetNextPrimaryFire())
        return false
    end
    return true
end

function SWEP:Deploy()
    self.DelayedReload = false
    self:SetInReload(false)
    return BaseClass.Deploy(self)
end

function SWEP:Think()
    local owner = self:GetOwner()
    if not owner then return end

    if self:GetInReload() then
        -- If I'm primary firing and have one round, stop reloading and fire
        if owner:KeyDown(IN_ATTACK) and self:Clip1() >= 1 and not self:GetNeedPump() then
            self:SetNextPrimaryFire(CurTime())
            self:SetInReload(false)
            self:SetNeedPump(false)
        -- If I'm secondary firing and have two rounds, stop reloading and fire
        elseif owner:KeyDown(IN_ATTACK2) and self:Clip1() >= 2 and not self:GetNeedPump() then
            self:SetNextSecondaryFire(CurTime())
            self:SetInReload(false)
            self:SetNeedPump(false)
        elseif self:GetNextPrimaryFire() <= CurTime() then
            -- If I'm out of ammo and reloading
            if owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
                self:FinishReload()
                return
            end

            -- If clip not full, insert a shell
            if self:Clip1() < self:GetMaxClip1() then
                self:InsertShell()
                return
            -- Clip full, stop reloading
            else
                self:FinishReload()
                return
            end
        end
    end

    if self:GetNeedPump() and self:GetNextPrimaryFire() <= CurTime() then
        self:Pump()
        return
    end

    -- No buttons down
    if not owner:KeyDown(bit.bor(IN_ATTACK, IN_ATTACK2, IN_ATTACK3)) and not self:GetInReload() then
        self:WeaponIdle()
    end
end
