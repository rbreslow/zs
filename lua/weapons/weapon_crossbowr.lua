SWEP.PrintName = "#HL2_Crossbow"
SWEP.Base = "weapon_hl2base"
SWEP.Category = "Half-Life 2 Remake"

DEFINE_BASECLASS("weapon_hl2base")

SWEP.WorldModel = "models/weapons/w_crossbow.mdl"
SWEP.ViewModel = "models/weapons/c_crossbow.mdl"

SWEP.Slot = 3
SWEP.SlotPos = 2

SWEP.Spawnable = false
SWEP.CharLogo = "g"
SWEP.HoldType = "crossbow"
SWEP.SINGLE = "Weapon_Crossbow.Single"
SWEP.RELOAD = "Weapon_Crossbow.Reload"

SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Ammo = "XBowBolt"

SWEP.Secondary.Automatic = false

SWEP.IconOverride = "entities/weapon_crossbow.png"

local BOLT_AIR_VELOCITY = 3500
local BOLT_WATER_VELOCITY = 1500

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)
	self:NetworkVar("Bool", 2, "InZoom")
	self:NetworkVar("Bool", 3, "ForceReload")
end

function SWEP:CreateBolt(vecOrigin, angAngles, Damage)
	local bolt = ents.Create("crossbow_boltr")
	bolt.Damage = 100
	bolt:SetPos(vecOrigin)
	bolt:SetAngles(angAngles)
	bolt:Spawn()
	bolt:SetOwner(self:GetOwner())

	return bolt
end

function SWEP:InReloadThink()
	self:SetNextSecondaryFire(CurTime())
end

function SWEP:PrimaryAttack()
	if self:Clip1() <= 0 then return end

	if SERVER then
		local vecAiming = self:GetOwner():GetAimVector()
		local vecSrc = self:GetOwner():GetShootPos()

		local angAiming = vecAiming:Angle()
		local bolt = self:CreateBolt(vecSrc, angAiming, 0)

		if self:GetOwner():WaterLevel() == 3 then
			bolt:SetVelocity(vecAiming * BOLT_WATER_VELOCITY)
		else
			bolt:SetVelocity(vecAiming * BOLT_AIR_VELOCITY)
		end
	end

	self:SetClip1(self:Clip1() - 1)

	self:GetOwner():ViewPunch(Angle(-2,0,0))

	self:EmitSound("Weapon_Crossbow.Single")
	self:EmitSound("Weapon_Crossbow.BoltFly")

	self:SetWeaponAnim(ACT_VM_PRIMARYATTACK)

	self:SetNextPrimaryFire(CurTime() + (self:GetRapidFire() and .1 or .75))
	self:SetForceReload(true)
end

function SWEP:SecondaryAttack()
	self:ToggleZoom()
end

function SWEP:AdjustMouseSensitivity()
	return self:GetOwner():GetFOV() / GetConVar"fov_desired":GetInt()
end

function SWEP:ToggleZoom()
	if SERVER then
		if self:GetInZoom() then
			self:GetOwner():SetFOV(0,.2)
			self:SetInZoom(false)
		else
			self:GetOwner():SetFOV(20,.1)
			self:SetInZoom(true)
		end
	end
end

function SWEP:Think()
	BaseClass.Think(self)

	if self:GetForceReload() then
		self:Reload()
	end
end

function SWEP:OnFinishReload()
	self:SetForceReload(false)
end

function SWEP:Holster()
	if self:GetInZoom() then
		self:ToggleZoom()
	end

	return BaseClass.Holster(self)
end
