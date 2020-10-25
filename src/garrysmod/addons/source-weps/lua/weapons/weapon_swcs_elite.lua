SWEP.Base = "weapon_swcs_base"
SWEP.Category = "Counter-Strike: Global Offensive"

SWEP.IsElites = true

SWEP.PrintName = "Dual Berettas"
SWEP.Spawnable = true
SWEP.HoldType = "duel"
SWEP.WorldModel = Model"models/weapons/csgo/w_pist_elite_dropped.mdl"
SWEP.WorldModelPlayer = Model"models/weapons/csgo/w_pist_elite.mdl"
SWEP.ViewModel = Model"models/weapons/csgo/v_pist_elite.mdl"
sound.Add({
	name = "Weapon_ELITE_CSGO.Single",
	channel = CHAN_STATIC,
	level = 79,
	volume = 1.0,
	pitch = 110,
	sound = {Sound")weapons/csgo/elite/elites_01.wav", Sound")weapons/csgo/elite/elites_02.wav", Sound")weapons/csgo/elite/elites_03.wav",Sound")weapons/csgo/elite/elites_01.wav"}
})
sound.Add({
	name = "Weapon_ELITE_CSGO.Clipout",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.5, 1.0},
	pitch = {97, 105},
	sound = Sound")weapons/csgo/elite/elite_clipout.wav",
})
sound.Add({
	name = "Weapon_ELITE_CSGO.Rclipin",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.5, 1.0},
	pitch = 100,
	sound = Sound")weapons/csgo/elite/elite_rightclipin.wav",
})
sound.Add({
	name = "Weapon_ELITE_CSGO.Lclipin",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.5, 1.0},
	pitch = 100,
	sound = Sound")weapons/csgo/elite/elite_leftclipin.wav",
})
sound.Add({
	name = "Weapon_ELITE_CSGO.Sliderelease",
	channel = CHAN_ITEM,
	level = 60,
	volume = 0.5,
	pitch = 100,
	sound = Sound")weapons/csgo/elite/elite_sliderelease.wav",
})
sound.Add({
	name = "Weapon_ELITE_CSGO.Slideback",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.5, 0.7},
	pitch = {97, 105},
	sound = Sound")weapons/csgo/hkp2000/hkp2000_slideback.wav",
})
sound.Add({
	name = "Weapon_ELITE_CSGO.Draw",
	channel = CHAN_STATIC,
	volume = 0.3,
	pitch = 100,
	level = 65,
	sound = Sound")weapons/csgo/elite/elite_draw.wav",
})
sound.Add({
	name = "Weapon_ELITE_CSGO.TauntLook1",
	channel = CHAN_ITEM,
	level = 65,
	volume = .1,
	pitch = 90,
	sound = Sound"weapons/csgo/elite/elite_draw.wav"
})
sound.Add({
	name = "Weapon_ELITE_CSGO.TauntLook2",
	channel = CHAN_STATIC,
	level = 65,
	volume = .05,
	pitch = 90,
	sound = Sound"weapons/csgo/elite/elite_draw.wav"
})
sound.Add({
	name = "Weapon_ELITE_CSGO.TauntStartTap",
	channel = CHAN_STATIC,
	level = 65,
	volume = .1,
	pitch = 90,
	sound = Sound"weapons/csgo/elite/elite_draw.wav"
})
sound.Add({
	name = "Weapon_ELITE_CSGO.TauntTap1",
	channel = CHAN_STATIC,
	level = 65,
	volume = .25,
	pitch = 90,
	sound = Sound"weapons/csgo/elite/elite_taunt_tap.wav"
})
sound.Add({
	name = "Weapon_ELITE_CSGO.TauntTap2",
	channel = CHAN_STATIC,
	level = 65,
	volume = .25,
	pitch = 90,
	sound = Sound"weapons/csgo/elite/elite_taunt_tap.wav"
})
sound.Add({
	name = "Weapon_ELITE_CSGO.TauntTwirl",
	channel = CHAN_STATIC,
	level = 65,
	volume = .15,
	pitch = 95,
	sound = Sound"weapons/csgo/elite/elite_draw.wav"
})

SWEP.ItemDefAttributes = [=["attributes 07/17/2020"
{
    "icon display model"		"models/weapons/w_pist_elite_icon.mdl"
    "buymenu display model"		"models/weapons/w_pist_elite_buymenu.mdl"
    "magazine model"		"models/weapons/w_pist_elite_mag.mdl"
    "primary reserve ammo max"		"120"
    "inaccuracy jump initial"		"95.860001"
    "inaccuracy jump"		"158.419998"
    "inaccuracy jump alt"		"158.419998"
    "heat per shot"		"0.500000"
    "max player speed"		"240"
    "in game price"		"400"
    "armor ratio"		"1.150000"
    "penetration"		"1"
    "damage"		"38"
    "range"		"4096"
    "range modifier"		"0.790000"
    "cycletime"		"0.120000"
    "flinch velocity modifier large"		"0.500000"
    "flinch velocity modifier small"		"0.650000"
    "spread"		"2.000000"
    "inaccuracy crouch"		"5.250000"
    "inaccuracy stand"		"7.000000"
    "inaccuracy land"		"0.255000"
    "inaccuracy ladder"		"102.000000"
    "inaccuracy fire"		"11.160000"
    "inaccuracy move"		"17.850000"
    "spread alt"		"2.000000"
    "inaccuracy crouch alt"		"7.500000"
    "inaccuracy stand alt"		"10.000000"
    "inaccuracy land alt"		"0.255000"
    "inaccuracy ladder alt"		"102.000000"
    "inaccuracy fire alt"		"11.960000"
    "inaccuracy move alt"		"17.850000"
    "recovery time crouch"		"0.437491"
    "recovery time stand"		"0.524989"
    "recoil angle variance"		"20"
    "recoil magnitude"		"27"
    "recoil magnitude variance"		"4"
    "recoil seed"		"24563"
    "primary clip size"		"30"
    "weapon weight"		"5"
    "rumble effect"		"1"
    "max player speed alt"		"240"
    "recoil angle variance alt"		"20"
    "recoil magnitude alt"		"27"
    "recoil magnitude variance alt"		"4"
    "recovery time crouch final"		"0.437491"
    "recovery time stand final"		"0.524989"
}]=]
SWEP.ItemDefVisuals = [=["visuals 07/17/2020"
{
    "muzzle_flash_effect_1st_person"		"weapon_muzzle_flash_pistol_elite_FP"
    "muzzle_flash_effect_3rd_person"		"weapon_muzzle_flash_pistol_elite"
    "heat_effect"		"weapon_muzzle_smoke"
    "eject_brass_effect"		"weapon_shell_casing_9mm"
    "tracer_effect"		"weapon_tracers_pistol"
    "weapon_type"		"Pistol"
    "player_animation_extension"		"elites"
    "primary_ammo"		"BULLET_PLAYER_9MM"
    "sound_single_shot"		"Weapon_Elite_CSGO.Single"
    "sound_nearlyempty"		"Default.nearlyempty"
}]=]

function SWEP:FiringLeft()
	return bit.band(self:Clip1(), 1) == 0
end

function SWEP:PrimaryAttack()
	self:CSBaseGunFire(self:GetCycleTime(), self:FiringLeft() and Primary_Mode or Secondary_Mode)
end

function SWEP:PrimaryAttackAct()
	if self:FiringLeft() then
		if self:Clip1() > 2 then
			return ACT_VM_PRIMARYATTACK
		else
			return ACT_VM_DRYFIRE_LEFT
		end
	else
		if self:Clip1() > 2 then
			return ACT_VM_SECONDARYATTACK
		else
			return ACT_VM_DRYFIRE
		end
	end
end
