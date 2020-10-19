SWEP.PrintName = ".357 Magnum (singly)"
SWEP.Base = "weapon_hl2base"
SWEP.Category = "Half-Life 2 Remake"

DEFINE_BASECLASS("weapon_hl2base")

SWEP.Spawnable = true

SWEP.HoldType = "revolver"

SWEP.ViewModel = "models/weapons/c_357.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"

SWEP.EMPTY = "Weapon_Pistol.Empty"
SWEP.SINGLE = "Weapon_357.Single"
SWEP.CharLogo = "e"

SWEP.Primary.Ammo = "357"
SWEP.Primary.DefaultClip = 6
SWEP.Primary.ClipSize = 6
SWEP.Primary.Automatic = true
SWEP.Primary.Delay = .75
SWEP.Primary.Damage = 40

SWEP.Cone = Vector(0,0,0)

SWEP.IconOverride = "entities/weapon_357.png"

local sk_plr_dmg_357 = GetConVar("sk_plr_dmg_357")

function SWEP:Initialize()
    BaseClass.Initialize(self)
    self.Primary.Damage = sk_plr_dmg_357:GetInt()
end

function SWEP:AddViewKick()
    local angles = self:GetOwner():EyeAngles()
    angles.x = angles.x + util.SharedRandom("KickBackX", -1, 1)
    angles.y = angles.y + util.SharedRandom("KickBackY", -1, 1)
    angles.z = 0

    if (game.SinglePlayer() and SERVER) or (not game.SinglePlayer() and CLIENT and IsFirstTimePredicted()) then
        self:GetOwner():SetEyeAngles(angles)
    end

    self.Owner:ViewPunch( Angle( -8, -util.SharedRandom("KickBackX", -2, 2), 0 ) )
end

function SWEP:Deploy()
    self:SetInReload(false)
    return true
end

function SWEP:StartReload()
    local owner = self:GetOwner()

    if owner:GetAmmoCount(self.Primary.Ammo) <= 0 then return false end

    if self:Clip1() >= self:GetMaxClip1() then return false end

    local j = math.min(1, owner:GetAmmoCount(self.Primary.Ammo))
    if j <= 0 then return false end

    local seqID, dur = self:LookupSequence("reload_start")
    self:SetWeaponSequence(seqID)
    owner:SetAnimation(PLAYER_RELOAD)

    self:SetNextPrimaryFire(CurTime() + dur)

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
    local seqID, dur = self:LookupSequence("reload_loop")
    owner:GetViewModel():SendViewModelMatchingSequence(seqID)

    self:SetNextPrimaryFire(CurTime() + dur)
    self:SetNextSecondaryFire(CurTime() + dur)
end

function SWEP:FinishReload()
    self:SetInReload(false)
    self:FillClip()

    local seqID, dur = self:LookupSequence("reload_end")
    self:GetOwner():GetViewModel():SendViewModelMatchingSequence(seqID)

    self:SetNextPrimaryFire(CurTime() + dur)
    self:SetNextSecondaryFire(CurTime() + dur)
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

function SWEP:Think()
    local owner = self:GetOwner()
    if not owner then return end
    if self:GetInReload() then
        -- If I'm primary firing and have one round, stop reloading and fire
        if owner:KeyDown(IN_ATTACK) and self:Clip1() >= 1 then
            self:SetNextPrimaryFire(CurTime())
            self:FinishReload()
        elseif self:GetNextPrimaryFire() <= CurTime() then
            -- If I'm out of ammo and reloading
            if owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
                self:FinishReload()
                return
            end

            -- If clip not full, insert a shell
            if self:Clip1() < self:GetMaxClip1() - 1 then
                self:InsertShell()
                return
            -- Clip full, stop reloading
            else
                self:FinishReload()
                return
            end
        end
    end
end
