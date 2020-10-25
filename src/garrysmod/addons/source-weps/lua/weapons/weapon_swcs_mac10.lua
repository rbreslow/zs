SWEP.Base = "weapon_swcs_base"
SWEP.Category = "Counter-Strike: Global Offensive"

SWEP.PrintName = "MAC-10"
SWEP.Spawnable = true
SWEP.HoldType = "smg"
SWEP.WorldModel = Model"models/weapons/csgo/w_smg_mac10_dropped.mdl"
SWEP.WorldModelPlayer = Model"models/weapons/csgo/w_smg_mac10.mdl"
SWEP.ViewModel = Model"models/weapons/csgo/v_smg_mac10.mdl"

sound.Add({
	name = "Weapon_MAC10_CSGO.Single",
	channel = CHAN_STATIC,
	level = 79,
	volume = 0.65,
	sound = {Sound")weapons/csgo/mac10/mac10_01.wav",Sound")weapons/csgo/mac10/mac10_02.wav",Sound")weapons/csgo/mac10/mac10_03.wav"}
})
sound.Add({
	name = "Weapon_MAC10_CSGO.Clipout",
	channel = CHAN_ITEM,
	level = 65,
	sound = Sound"weapons/csgo/mac10/mac10_clipout.wav"
})
sound.Add({
	name = "Weapon_MAC10_CSGO.Clipin",
	channel = CHAN_ITEM,
	level = 65,
	sound = Sound"weapons/csgo/mac10/mac10_clipin.wav"
})
sound.Add({
	name = "Weapon_MAC10_CSGO.Draw",
	channel = CHAN_ITEM,
	level = 75,
	volume = 0.5,
	sound = Sound"weapons/csgo/mac10/mac10_draw.wav"
})
sound.Add({
	name = "Weapon_MAC10_CSGO.BoltBack",
	channel = CHAN_ITEM,
	level = 65,
	sound = Sound"weapons/csgo/mac10/mac10_boltback.wav"
})
sound.Add({
	name = "Weapon_MAC10_CSGO.BoltForward",
	channel = CHAN_ITEM,
	level = 65,
	sound = Sound"weapons/csgo/mac10/mac10_boltforward.wav"
})
sound.Add({
	name = "Weapon_MAC10_CSGO.WeaponMove1",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement1.wav"
})
sound.Add({
	name = "Weapon_MAC10_CSGO.WeaponMove2",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement2.wav"
})
sound.Add({
	name = "Weapon_MAC10_CSGO.WeaponMove3",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement3.wav"
})

SWEP.ItemDefAttributes = [=["attributes 07/01/2020"
{
    "magazine model"		"models/weapons/w_smg_mac10_mag.mdl"
    "primary reserve ammo max"		"100"
    "inaccuracy jump initial"		"34.990002"
    "inaccuracy jump"		"33.299999"
    "heat per shot"		"0.300000"
    "tracer frequency"		"3"
    "max player speed"		"240"
    "is full auto"		"1"
    "in game price"		"1050"
    "kill award"		"600"
    "armor ratio"		"1.150000"
    "crosshair min distance"		"9"
    "penetration"		"1"
    "damage"		"29"
    "range"		"3600"
    "range modifier"		"0.800000"
    "cycletime"		"0.075000"
    "time to idle"		"2"
    "flinch velocity modifier large"		"0.000000"
    "flinch velocity modifier small"		"0.000000"
    "spread"		"0.600000"
    "inaccuracy crouch"		"9.980000"
    "inaccuracy stand"		"13.300000"
    "inaccuracy land"		"0.069000"
    "inaccuracy ladder"		"34.259998"
    "inaccuracy fire"		"4.760000"
    "inaccuracy move"		"13.990000"
    "recovery time crouch"		"0.285521"
    "recovery time stand"		"0.399729"
    "recoil angle"		"0"
    "recoil angle variance"		"70"
    "recoil magnitude"		"18"
    "recoil magnitude variance"		"1"
    "recoil seed"		"34079"
    "primary clip size"		"30"
    "rumble effect"		"3"
    "weapon weight"		"25"
    "inaccuracy crouch alt"		"9.980000"
    "inaccuracy fire alt"		"4.760000"
    "inaccuracy jump alt"		"33.299999"
    "inaccuracy ladder alt"		"34.259998"
    "inaccuracy land alt"		"0.069000"
    "inaccuracy move alt"		"13.990000"
    "inaccuracy stand alt"		"13.300000"
    "max player speed alt"		"240"
    "recoil angle alt"		"0"
    "recoil angle variance alt"		"70"
    "recoil magnitude alt"		"18"
    "recoil magnitude variance alt"		"1"
    "recovery time crouch final"		"0.285521"
    "recovery time stand final"		"0.399729"
    "spread alt"		"0.600000"
}]=]
SWEP.ItemDefVisuals = [=["visuals 07/07/2020"
{
    "muzzle_flash_effect_1st_person"		"weapon_muzzle_flash_smg"
    "muzzle_flash_effect_3rd_person"		"weapon_muzzle_flash_smg"
    "heat_effect"		"weapon_muzzle_smoke"
    "addon_location"		"primary_smg"
    "eject_brass_effect"		"weapon_shell_casing_9mm"
    "tracer_effect"		"weapon_tracers_smg"
    "weapon_type"		"SubMachinegun"
    "player_animation_extension"		"mac10"
    "primary_ammo"		"BULLET_PLAYER_45ACP"
    "sound_single_shot"		"Weapon_MAC10_CSGO.Single"
    "sound_nearlyempty"		"Default.nearlyempty"
}]=]
