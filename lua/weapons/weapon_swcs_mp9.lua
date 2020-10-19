SWEP.Base = "weapon_swcs_base"
SWEP.Category = "Counter-Strike: Global Offensive"

SWEP.PrintName = "MP9"
SWEP.Spawnable = true
SWEP.HoldType = "smg"
SWEP.WorldModel = Model"models/weapons/csgo/w_smg_mp9_dropped.mdl"
SWEP.WorldModelPlayer = Model"models/weapons/csgo/w_smg_mp9.mdl"
SWEP.ViewModel = Model"models/weapons/csgo/v_smg_mp9.mdl"

sound.Add({
	name = "Weapon_MP9_CSGO.Single",
	channel = CHAN_STATIC,
	level = 79,
	volume = 0.75,
	sound = {Sound")weapons/csgo/mp9/mp9_01.wav", Sound")weapons/csgo/mp9/mp9_02.wav", Sound")weapons/csgo/mp9/mp9_03.wav", Sound")weapons/csgo/mp9/mp9_04.wav"}
})
sound.Add({
	name = "Weapon_MP9_CSGO.Clipout",
	channel = CHAN_ITEM,
	level = 65,
	sound = Sound"weapons/csgo/mp9/mp9_clipout.wav"
})
sound.Add({
	name = "Weapon_MP9_CSGO.Clipin",
	channel = CHAN_ITEM,
	level = 65,
	sound = Sound"weapons/csgo/mp9/mp9_clipin.wav"
})
sound.Add({
	name = "Weapon_MP9_CSGO.Draw",
	channel = CHAN_STATIC,
	level = 65,
	volume = 0.3,
	sound = Sound"weapons/csgo/mp9/mp9_draw.wav"
})
sound.Add({
	name = "Weapon_MP9_CSGO.boltBack",
	channel = CHAN_ITEM,
	level = 60,
	sound = Sound"weapons/csgo/mp9/mp9_boltback.wav"
})
sound.Add({
	name = "Weapon_MP9_CSGO.boltForward",
	channel = CHAN_ITEM,
	level = 60,
	sound = Sound"weapons/csgo/mp9/mp9_boltforward.wav"
})
sound.Add({
	name = "Weapon_MP9_CSGO.WeaponMove1",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement1.wav"
})
sound.Add({
	name = "Weapon_MP9_CSGO.WeaponMove2",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement2.wav"
})
sound.Add({
	name = "Weapon_MP9_CSGO.WeaponMove3",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement3.wav"
})

SWEP.ItemDefAttributes = [=["attributes 07/17/2020"
{
    "magazine model"		"models/weapons/w_smg_mp9_mag.mdl"
    "primary reserve ammo max"		"120"
    "inaccuracy jump initial"		"37.279999"
    "inaccuracy jump"		"18.430000"
    "heat per shot"		"0.300000"
    "tracer frequency"		"3"
    "max player speed"		"240"
    "is full auto"		"1"
    "in game price"		"1250"
    "kill award"		"600"
    "armor ratio"		"1.200000"
    "crosshair min distance"		"7"
    "penetration"		"1"
    "damage"		"26"
    "range"		"3600"
    "range modifier"		"0.870000"
    "cycletime"		"0.070000"
    "time to idle"		"2"
    "flinch velocity modifier large"		"0.000000"
    "flinch velocity modifier small"		"0.000000"
    "spread"		"0.600000"
    "inaccuracy crouch"		"5.500000"
    "inaccuracy stand"		"9.000000"
    "inaccuracy land"		"0.056000"
    "inaccuracy ladder"		"148.912506"
    "inaccuracy fire"		"3.700000"
    "inaccuracy move"		"29.040001"
    "recovery time crouch"		"0.184207"
    "recovery time stand"		"0.257890"
    "recoil angle"		"0"
    "recoil angle variance"		"70"
    "recoil magnitude"		"19"
    "recoil magnitude variance"		"1"
    "recoil seed"		"50729"
    "primary clip size"		"30"
    "rumble effect"		"3"
    "weapon weight"		"25"
    "inaccuracy crouch alt"		"5.500000"
    "inaccuracy fire alt"		"3.700000"
    "inaccuracy jump alt"		"18.430000"
    "inaccuracy ladder alt"		"148.912506"
    "inaccuracy land alt"		"0.056000"
    "inaccuracy move alt"		"29.040001"
    "inaccuracy stand alt"		"9.000000"
    "max player speed alt"		"240"
    "recoil angle alt"		"0"
    "recoil angle variance alt"		"70"
    "recoil magnitude alt"		"19"
    "recoil magnitude variance alt"		"1"
    "recovery time crouch final"		"0.184207"
    "recovery time stand final"		"0.257890"
    "spread alt"		"0.600000"
}]=]
SWEP.ItemDefVisuals = [=["visuals 07/17/2020"
{
    "muzzle_flash_effect_1st_person"		"weapon_muzzle_flash_smg"
    "muzzle_flash_effect_3rd_person"		"weapon_muzzle_flash_smg"
    "heat_effect"		"weapon_muzzle_smoke"
    "addon_location"		"primary_smg"
    "eject_brass_effect"		"weapon_shell_casing_9mm"
    "tracer_effect"		"weapon_tracers_smg"
    "weapon_type"		"SubMachinegun"
    "player_animation_extension"		"mp9"
    "primary_ammo"		"BULLET_PLAYER_9MM"
    "sound_single_shot"		"Weapon_MP9_CSGO.Single"
    "sound_nearlyempty"		"Default.nearlyempty"
}]=]
