SWEP.Base = "weapon_zs_basemelee"

SWEP.PrintName = "Carpenter's Hammer"
SWEP.Description = "A simple but extremely useful tool. Allows you to hammer in nails to make barricades.\nPress SECONDARY FIRE to hammer in nail. It will be attached to whatever is behind it.\nPress RELOAD to take a nail out.\nUse PRIMARY FIRE to bash zombie brains or to repair damaged nails.\nYou get a point bonus for repairing damaged nails but a point penalty for removing another player's nails."

SWEP.DamageType = DMG_CLUB

SWEP.ViewModel = "models/weapons/v_hammer/c_hammer.mdl"
SWEP.WorldModel = "models/weapons/w_hammer.mdl"
SWEP.UseHands = true

SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "GaussEnergy"
SWEP.Primary.Delay = 1
SWEP.Primary.DefaultClip = 16

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Ammo = "dummy"

--SWEP.MeleeDamage = 35 -- Reduced due to instant swing speed
SWEP.MeleeDamage = 15
SWEP.MeleeRange = 50
SWEP.MeleeSize = 0.875

SWEP.MaxStock = 5

SWEP.UseMelee1 = true

SWEP.NoPropThrowing = true

SWEP.HitGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.MissGesture = SWEP.HitGesture

SWEP.HealStrength = 1

SWEP.NoHolsterOnCarry = true

SWEP.NoGlassWeapons = true

SWEP.AllowQualityWeapons = true

SWEP.DoorDamageMultiplier = 10

GAMEMODE:SetPrimaryWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.04)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MELEE_RANGE, 3, 1)

function SWEP:SetNextAttack()
	local owner = self:GetOwner()
	local armdelay = owner:GetMeleeSpeedMul()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay * (owner.HammerSwingDelayMul or 1) * armdelay)
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/crowbar/crowbar_hit-"..math.random(4)..".ogg", 75, math.random(110, 115))
end

function SWEP:PlayRepairSound(hitent)
	hitent:EmitSound("npc/dog/dog_servo"..math.random(7, 8)..".wav", 70, math.random(100, 105))
end

-- Disable behavior that happens when ghosting on meleebase
function SWEP:IsOwnerBarricadeGhosting()
	return false
end

-- Reloading at a door will attack it for vast damage
function SWEP:ReloadAttack(target)
	if not self:CanPrimaryAttack() then return end
	self:SetNextAttack()
	
	local owner = self:GetOwner()

	self:DoMeleeAttackAnim()

	if not target.Hit then
		if self.MissAnim then
			self:SendWeaponAnim(self.MissAnim)
		end
		self.IdleAnimation = CurTime() + self:SequenceDuration()
		self:PlaySwingSound()

		if owner.MeleePowerAttackMul and owner.MeleePowerAttackMul > 1 then
			self:SetPowerCombo(0)
		end

		if self.PostOnMeleeMiss then self:PostOnMeleeMiss(target) end

		return
	end

	local hitent = target.Entity
	
	if self.HitAnim then
		self:SendWeaponAnim(self.HitAnim)
	end
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	owner:EmitSound("weapons/melee/crowbar/crowbar_hit-"..math.random(4)..".ogg")
	self:PlayHitSound()

	if self.OnMeleeHit and self:OnMeleeHit(hitent, false, target) then
		return
	end

	if SERVER then
		self:ServerMeleeHitEntity(target, hitent, self.DoorDamageMultiplier)
	end

	self:MeleeHitEntity(target, hitent, self.DoorDamageMultiplier)

	if self.PostOnMeleeHit then self:PostOnMeleeHit(hitent, hitflesh, target) end

	if SERVER then
		self:ServerMeleePostHitEntity(target, hitent, self.DoorDamageMultiplier)
	end
end
