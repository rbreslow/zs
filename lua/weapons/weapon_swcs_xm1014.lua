SWEP.Base = "weapon_swcs_base"
SWEP.Category = "Counter-Strike: Global Offensive"

DEFINE_BASECLASS(SWEP.Base)

SWEP.PrintName = "XM1014"
SWEP.Spawnable = true
SWEP.HoldType = "shotgun"
SWEP.WorldModel = Model"models/weapons/csgo/w_shot_xm1014_dropped.mdl"
SWEP.WorldModelPlayer = Model"models/weapons/csgo/w_shot_xm1014.mdl"
SWEP.ViewModel = Model"models/weapons/csgo/v_shot_xm1014.mdl"

sound.Add({
	name = "Weapon_XM1014_CSGO.Single",
	channel = CHAN_STATIC,
	volume = 0.9,
	level = 79,
	sound = Sound")weapons/csgo/xm1014/xm1014-1.wav"
})
sound.Add({
	name = "Weapon_XM1014_CSGO.InsertShell",
	channel = CHAN_ITEM,
	volume = {0.5, 1.0},
	level = 65,
	sound = {Sound"weapons/csgo/xm1014/xm1014_insertshell_01.wav", Sound"weapons/csgo/xm1014/xm1014_insertshell_02.wav", Sound"weapons/csgo/xm1014/xm1014_insertshell_03.wav"}
})
sound.Add({
	name = "Weapon_XM1014_CSGO.Draw",
	channel = CHAN_STATIC,
	volume = 0.3,
	level = 65,
	sound = Sound"weapons/csgo/xm1014/xm1014_draw.wav"
})
sound.Add({
	name = "Weapon_XM1014_CSGO.WeaponMove1",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement3.wav"
})
sound.Add({
	name = "Weapon_XM1014_CSGO.WeaponMove2",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement2.wav"
})
sound.Add({
	name = "Weapon_XM1014_CSGO.WeaponMove3",
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
			self:SetNextPrimaryFire(CurTime() + .25)
		end

		return
	end

	self:SetWeaponAnim(self:PrimaryAttackAct())
	owner:MuzzleFlash()
	owner:SetAnimation(PLAYER_ATTACK1)

	self:FX_FireBullets()

	-- are we firing the last round in the clip?
	if self:Clip1() == 1 then
		self:SetWeaponIdleTime(CurTime() + .25)
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
	"is full auto"		"1"
	"inaccuracy jump initial"		"100.379997"
	"inaccuracy jump"		"130.830002"
	"heat per shot"		"1.500000"
	"addon scale"		"0.900000"
	"tracer frequency"		"1"
	"max player speed"		"215"
	"in game price"		"2000"
	"kill award"		"900"
	"armor ratio"		"1.600000"
	"crosshair min distance"		"9"
	"crosshair delta distance"		"4"
	"penetration"		"1"
	"damage"		"20"
	"range"		"3000"
	"range modifier"		"0.700000"
	"bullets"		"6"
	"cycletime"		"0.350000"
	"flinch velocity modifier large"		"0.400000"
	"flinch velocity modifier small"		"0.450000"
	"spread"		"38.000000"
	"inaccuracy crouch"		"5.250000"
	"inaccuracy stand"		"7.000000"
	"inaccuracy land"		"0.232000"
	"inaccuracy ladder"		"77.209999"
	"inaccuracy fire"		"8.830000"
	"inaccuracy move"		"36.029999"
	"recovery time crouch"		"0.361835"
	"recovery time stand"		"0.506569"
	"recoil angle"		"0"
	"recoil angle variance"		"20"
	"recoil magnitude"		"80"
	"recoil magnitude variance"		"20"
	"recoil seed"		"24862"
	"spread seed"		"817955"
	"primary clip size"		"7"
	"weapon weight"		"20"
	"rumble effect"		"5"
	"inaccuracy crouch alt"		"5.250000"
	"inaccuracy fire alt"		"8.830000"
	"inaccuracy jump alt"		"130.830002"
	"inaccuracy ladder alt"		"77.209999"
	"inaccuracy land alt"		"0.232000"
	"inaccuracy move alt"		"36.029999"
	"inaccuracy stand alt"		"7.000000"
	"max player speed alt"		"215"
	"recoil angle alt"		"0"
	"recoil angle variance alt"		"20"
	"recoil magnitude alt"		"80"
	"recoil magnitude variance alt"		"20"
	"recovery time crouch final"		"0.361835"
	"recovery time stand final"		"0.506569"
	"spread alt"		"38.000000"
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
	"player_animation_extension"		"xm1014"
	"primary_ammo"		"BULLET_PLAYER_BUCKSHOT"
	"sound_single_shot"		"Weapon_XM1014_CSGO.Single"
	"sound_nearlyempty"		"Default.nearlyempty"
}]=]
