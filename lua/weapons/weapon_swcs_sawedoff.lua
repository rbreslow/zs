SWEP.Base = "weapon_swcs_base"
SWEP.Category = "Counter-Strike: Global Offensive"

DEFINE_BASECLASS(SWEP.Base)

SWEP.PrintName = "Sawed-Off"
SWEP.Spawnable = true
SWEP.HoldType = "shotgun"
SWEP.WorldModel = Model"models/weapons/csgo/w_shot_sawedoff_dropped.mdl"
SWEP.WorldModelPlayer = Model"models/weapons/csgo/w_shot_sawedoff.mdl"
SWEP.ViewModel = Model"models/weapons/csgo/v_shot_sawedoff.mdl"

sound.Add({
	name = "Weapon_Sawedoff_CSGO.Single",
	channel = CHAN_STATIC,
	volume = 0.9,
	level = 79,
	sound = Sound")weapons/csgo/sawedoff/sawedoff-1.wav"
})
sound.Add({
	name = "Weapon_Sawedoff_CSGO.InsertShell",
	channel = CHAN_ITEM,
	volume = {0.5, 0.9},
	pitch = {98, 102},
	level = 65,
	sound = {Sound"weapons/csgo/sawedoff/sawedoff_insertshell_01.wav", Sound"weapons/csgo/sawedoff/sawedoff_insertshell_02.wav", Sound"weapons/csgo/sawedoff/sawedoff_insertshell_03.wav"}
})
sound.Add({
	name = "Weapon_Sawedoff_CSGO.Pump",
	channel = CHAN_ITEM,
	volume = {0.5, 1.0},
	pitch = {97, 105},
	level = 65,
	sound = Sound"weapons/csgo/sawedoff/sawedoff_pump.wav"
})
sound.Add({
	name = "Weapon_Sawedoff_CSGO.Draw",
	channel = CHAN_STATIC,
	volume = 0.3,
	level = 65,
	sound = Sound"weapons/csgo/sawedoff/sawedoff_draw.wav"
})
sound.Add({
	name = "Weapon_Sawedoff_CSGO.PumpDuringShot",
	channel = CHAN_ITEM,
	volume = 0.3,
	level = 65,
	sound = Sound"weapons/csgo/sawedoff/sawedoff_pump.wav"
})
sound.Add({
	name = "Weapon_Sawedoff_CSGO.WeaponMove1",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement1.wav"
})
sound.Add({
	name = "Weapon_Sawedoff_CSGO.WeaponMove2",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement2.wav"
})
sound.Add({
	name = "Weapon_Sawedoff_CSGO.WeaponMove3",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement3.wav"
})

function SWEP:GetShotgunReloadState() return self:GetReloadState() end

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)

	self:NetworkVar("Int", 7, "ReloadState")
end

function SWEP:PrimaryAttack()
	local owner = self:GetOwner()
	if not owner:IsValid() then return end

	local flCycleTime = self:GetCycleTime()

	if owner:WaterLevel() == 3 then
		self:PlayEmptySound()
		self:SetNextPrimaryFire(CurTime() + .15)
		return
	end

	if self:Clip1() <= 0 then
		self:Reload()

		if self:Clip1() == 0 then
			self:PlayEmptySound()
			self:SetNextPrimaryFire(CurTime() + .2)
		end

		return
	end

	self:SetWeaponAnim(self:PrimaryAttackAct())
	owner:MuzzleFlash()
	owner:SetAnimation(PLAYER_ATTACK1)

	self:FX_FireBullets()

	-- are we firing the last round in the clip?
	if self:Clip1() == 1 then
		self:SetWeaponIdleTime(CurTime() + .875)
	else
		-- pumptime = CurTime() + .5
		self:SetWeaponIdleTime(CurTime() + 2.5)
	end

	self:SetReloadState(0)

	self:SetAccuracyPenalty(self:GetAccuracyPenalty() + self:GetInaccuracyFire(Primary_Mode))

	self:Recoil(Primary_Mode)

	self:SetNextPrimaryFire(CurTime() + flCycleTime)

	self:SetRecoilIndex(self:GetRecoilIndex() + 1)
	self:TakePrimaryAmmo(1)
end

function SWEP:Reload()
	local owner = self:GetPlayerOwner()
	if not owner then
		return false end

	if self:GetAmmoCount(self:GetPrimaryAmmoType()) <= 0 or self:Clip1() >= self:GetMaxClip1() then
		return true end

	-- don't reload until recoil is done
	if self:GetNextPrimaryFire() > CurTime() then
		return true end

	-- check to see if we're ready to reload
	if self:GetReloadState() == 0 then
		owner:SetAnimation(PLAYER_RELOAD)

		self:SetWeaponAnim(ACT_SHOTGUN_RELOAD_START)
		self:SetReloadState(1)
		self:SetWeaponIdleTime(CurTime() + 0.5)
		self:SetNextPrimaryFire(CurTime() + 0.5)
		self:SetNextSecondaryFire(CurTime() + 0.5)
		return true
	elseif self:GetReloadState() == 1 then
		if self:GetWeaponIdleTime() > CurTime() then
			return true end
		-- was waiting for gun to move to side
		self:SetReloadState(2)

		self:SetWeaponAnim(ACT_VM_RELOAD)
		self:SetWeaponIdleTime(CurTime() + 0.5)
	else
		-- Add them to the clip
		self:SetClip1(self:Clip1() + 1)
		if SWCS_INDIVIDUAL_AMMO:GetBool() then
			self:SetReserveAmmo(self:GetReserveAmmo() - 1)
		else
			owner:RemoveAmmo(1, self:GetPrimaryAmmoType())
		end

		self:SetReloadState(1)
	end

	return true
end

function SWEP:WeaponIdle()
	local owner = self:GetPlayerOwner()
	if not owner then
		return end

	if self:GetWeaponIdleTime() < CurTime() then
		if self:Clip1() == 0 and self:GetReloadState() == 0 and self:GetAmmoCount(self:GetPrimaryAmmoType()) > 0 then
			self:Reload()
		elseif self:GetReloadState() ~= 0 then
			if self:Clip1() < self:GetMaxClip1() and self:GetAmmoCount(self:GetPrimaryAmmoType()) > 0 then
				self:Reload()
			else
				-- reload debounce has timed out
				self:SetWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
				self:SetReloadState(0)
				self:SetWeaponIdleTime(CurTime() + 1.5)
			end
		else
			self:SetWeaponAnim(ACT_VM_IDLE)
		end
	end
end

SWEP.ItemDefAttributes = [=["attributes 08/01/2020"
{
    "primary reserve ammo max"		"32"
    "is full auto"		"0"
    "inaccuracy jump initial"		"50.119999"
    "inaccuracy jump"		"57.700001"
    "heat per shot"		"1.500000"
    "addon scale"		"0.900000"
    "tracer frequency"		"1"
    "max player speed"		"210"
    "in game price"		"1100"
    "kill award"		"900"
    "armor ratio"		"1.500000"
    "crosshair min distance"		"9"
    "crosshair delta distance"		"4"
    "penetration"		"1"
    "damage"		"32"
    "range"		"1400"
    "range modifier"		"0.450000"
    "bullets"		"8"
    "cycletime"		"0.850000"
    "flinch velocity modifier large"		"0.400000"
    "flinch velocity modifier small"		"0.450000"
    "spread"		"62.000000"
    "inaccuracy crouch"		"5.250000"
    "inaccuracy stand"		"7.000000"
    "inaccuracy land"		"0.108000"
    "inaccuracy ladder"		"36.000000"
    "inaccuracy fire"		"9.720000"
    "inaccuracy move"		"16.799999"
    "recovery time crouch"		"0.328941"
    "recovery time stand"		"0.460517"
    "recoil angle variance"		"20"
    "recoil magnitude"		"143"
    "recoil magnitude variance"		"22"
    "recoil seed"		"1089"
    "spread seed"		"9571223"
    "primary clip size"		"7"
    "weapon weight"		"20"
    "rumble effect"		"5"
    "inaccuracy crouch alt"		"5.250000"
    "inaccuracy fire alt"		"9.720000"
    "inaccuracy jump alt"		"57.700001"
    "inaccuracy ladder alt"		"36.000000"
    "inaccuracy land alt"		"0.108000"
    "inaccuracy move alt"		"16.799999"
    "inaccuracy stand alt"		"7.000000"
    "max player speed alt"		"210"
    "recoil angle variance alt"		"20"
    "recoil magnitude alt"		"143"
    "recoil magnitude variance alt"		"22"
    "recovery time crouch final"		"0.328941"
    "recovery time stand final"		"0.460517"
    "spread alt"		"62.000000"
}]=]
SWEP.ItemDefVisuals = [=["visuals 08/01/2020"
{
    "muzzle_flash_effect_1st_person"		"weapon_muzzle_flash_autoshotgun"
    "muzzle_flash_effect_3rd_person"		"weapon_muzzle_flash_autoshotgun"
    "heat_effect"		"weapon_muzzle_smoke"
    "addon_location"		"primary_shotgun"
    "eject_brass_effect"		"weapon_shell_casing_shotgun"
    "tracer_effect"		"weapon_tracers_shot"
    "weapon_type"		"Shotgun"
    "player_animation_extension"		"Sawedoff"
    "primary_ammo"		"BULLET_PLAYER_BUCKSHOT"
    "sound_single_shot"		"Weapon_Sawedoff_CSGO.Single"
    "sound_nearlyempty"		"Default.nearlyempty"
}]=]
