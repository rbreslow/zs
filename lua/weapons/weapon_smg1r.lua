SWEP.PrintName = "#HL2_SMG1"
SWEP.Base = "weapon_hl2basemg"
SWEP.Category = "Half-Life 2 Remake"

DEFINE_BASECLASS("weapon_hl2basemg")

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/c_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"

SWEP.EMPTY = "Weapon_SMG1.Empty"
SWEP.SINGLE = "Weapon_SMG1.Single"
SWEP.RELOAD = "Weapon_SMG1.Reload"
SWEP.CharLogo = "a"
SWEP.Cone = Vector(0.043620, 0.043620, 0)

SWEP.HoldType = "smg"
SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.Primary.Ammo = "SMG1"
SWEP.Primary.DefaultClip = 45
SWEP.Primary.ClipSize = 45
SWEP.Primary.Automatic = true
SWEP.Primary.Delay = .075
SWEP.Primary.Damage = 4

SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Ammo = "SMG1_Grenade"
SWEP.Secondary.Automatic = true

SWEP.IconOverride = "entities/weapon_smg1.png"

local sk_plr_dmg_smg1 = GetConVar("sk_plr_dmg_smg1")

function SWEP:Initialize()
    BaseClass.Initialize(self)
    self.Primary.Damage = sk_plr_dmg_smg1:GetInt()
end

function SWEP:SecondaryAttack()
	if not self:CanSecondaryAttack() then return end

	self:EmitSound("Weapon_SMG1.Double")

	local vecSrc = self:GetOwner():GetShootPos()
	local vecThrow

	vecThrow = self:GetOwner():GetAimVector()
	vecThrow = vecThrow * 1000

	if SERVER then
		local Grenade = ents.Create("grenade_ar2")
		Grenade:SetPos(vecSrc) Grenade:Spawn()
		Grenade:SetAngles(Angle(0,0,0))

		Grenade:SetVelocity(vecThrow)

		Grenade:SetLocalAngularVelocity(AngleRand())
		Grenade:SetMoveType(bit.bor(MOVETYPE_FLYGRAVITY,MOVECOLLIDE_FLY_BOUNCE))
		Grenade:SetOwner(self:GetOwner())
	end

	self:SetWeaponAnim(ACT_VM_SECONDARYATTACK)

	self:GetOwner():SetAnimation(PLAYER_ATTACK1)

	self:TakeSecondaryAmmo(1)

	self:SetNextPrimaryFire((self:GetRapidFire() and 0 or CurTime()) + .5)
	self:SetNextSecondaryFire((self:GetRapidFire() and 0 or CurTime()) + 1)
end