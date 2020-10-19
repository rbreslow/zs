SWEP.PrintName = "#HL2_RPG"
SWEP.Base = "weapon_hl2base"
SWEP.Category = "Half-Life 2 Remake"

DEFINE_BASECLASS("weapon_hl2base")

SWEP.Spawnable = false

SWEP.HoldType = "rpg"

SWEP.ViewModel = "models/weapons/c_rpg.mdl"
SWEP.WorldModel = "models/weapons/w_rocket_launcher.mdl"

SWEP.Slot = 4
SWEP.SlotPos = 2

SWEP.EMPTY = "Weapon_Pistol.Empty"
SWEP.SINGLE = "Weapon_RPG.Single"
SWEP.RELOAD = "Weapon_Pistol.Reload"
SWEP.CharLogo = "d"

SWEP.Primary.Ammo = "RPG_Round"
SWEP.Primary.DefaultClip = 3
SWEP.Primary.ClipSize = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Delay = .5

SWEP.Cone = Vector(0,0,0)

SWEP.IconOverride = "entities/weapon_rpg.png"

function SWEP:SetupDataTables()
    BaseClass.SetupDataTables(self)
    self:NetworkVar("Entity", 0, "Projectile")
end

function SWEP:NotifyRocketDied()
    if self:Clip1() > 0 then
        self:SetWeaponAnim(ACT_VM_RELOAD)
    else
        self:SetWeaponAnim(ACT_VM_DOWN_EMPTY)
    end
    self:SetNextPrimaryFire(self:GetRapidFire() and 0 or CurTime() + self:SequenceDuration())
end

function SWEP:PrimaryAttack()
    if not self:CanPrimaryAttack() then return end
    if IsValid(self:GetProjectile()) then return end
    local owner = self:GetOwner()
    if not IsValid(owner) then return end

    self:SetNextPrimaryFire(CurTime() + (self:GetRapidFire() and .1 or .5))
    local forward = owner:GetAimVector()
    local right, up = forward:Angle():Right(), forward:Angle():Up()

    local muzzlePoint = owner:GetShootPos() + (forward * 12) + (right * 6) + (up * -3)

    if SERVER then
        local ang = forward:Angle()
        local missile = ents.Create("rpg_missiler")
        missile:SetPos(muzzlePoint) missile:SetAngles(ang)
        missile:SetOwner(self)
        missile:Spawn()
        missile:AddEffects(EF_NOSHADOW)

        self:SetProjectile(missile)
        missile:SetAbsVelocity(forward * 300 + Vector(0, 0, 128))

        local tr = util.TraceLine({
            startpos = owner:GetShootPos(),
            endpos = owner:GetShootPos() + (forward * 128),
            mask = MASK_SHOT,
            filter = self,
            collisiongroup = COLLISION_GROUP_NONE
        })

        if tr.Fraction == 1 then
            missile:SetGracePeriod(.3)
        end
    end

    self:TakePrimaryAmmo(1)
    self:SetWeaponAnim(ACT_VM_PRIMARYATTACK)
    self:EmitSound(self.SINGLE)

    owner:SetAnimation(PLAYER_ATTACK1)
end
