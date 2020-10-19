SWEP.Base = "weapon_swcs_base"
SWEP.Category = "Counter-Strike: Global Offensive"

SWEP.PrintName = "Glock-18"
SWEP.Spawnable = true
SWEP.HoldType = "pistol"
SWEP.WorldModel = Model"models/weapons/csgo/w_pist_glock18_dropped.mdl"
SWEP.WorldModelPlayer = Model"models/weapons/csgo/w_pist_glock18.mdl"
SWEP.ViewModel = Model"models/weapons/csgo/v_pist_glock18.mdl"
sound.Add({
	name = "Weapon_Glock_CSGO.Single",
	channel = CHAN_STATIC,
	level = 79,
	volume = 0.8,
	pitch = {98, 101},
	sound = {Sound")weapons/csgo/glock18/glock_01.wav", Sound")weapons/csgo/glock18/glock_02.wav"}
})
sound.Add({
	name = "Weapon_Glock_CSGO.Clipout",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.5, 0.7},
	pitch = {98, 101},
	sound = Sound")weapons/csgo/glock18/glock_clipout.wav",
})
sound.Add({
	name = "Weapon_Glock_CSGO.Clipin",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.5, 0.7},
	pitch = {98, 101},
	sound = Sound")weapons/csgo/glock18/glock_clipin.wav",
})
sound.Add({
	name = "Weapon_Glock_CSGO.Sliderelease",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.5, 0.7},
	pitch = {98, 101},
	sound = Sound")weapons/csgo/glock18/glock_sliderelease.wav",
})
sound.Add({
	name = "Weapon_Glock_CSGO.Slideback",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.5, 0.7},
	pitch = {98, 101},
	sound = Sound")weapons/csgo/glock18/glock_slideback.wav",
})
sound.Add({
	name = "Weapon_Glock_CSGO.Draw",
	channel = CHAN_STATIC,
	level = 65,
	volume = {0.5, 0.7},
	pitch = {98, 101},
	sound = Sound")weapons/csgo/glock18/glock_draw.wav",
})

SWEP.ItemDefAttributes = [=["attributes 07/17/2020"
{
    "uid model"		"models/weapons/uid_small.mdl"
    "has burst mode"		"1"
    "cycletime when in burst mode"		"0.500000"
    "time between burst shots"		"0.050000"
    "magazine model"		"models/weapons/w_pist_glock18_mag.mdl"
    "primary reserve ammo max"		"120"
    "tracer frequency alt"		"1"
    "inaccuracy jump initial"		"96.620003"
    "inaccuracy jump"		"87.870003"
    "inaccuracy jump alt"		"87.870003"
    "heat per shot"		"0.300000"
    "tracer frequency"		"1"
    "max player speed"		"240"
    "in game price"		"200"
    "armor ratio"		"0.940000"
    "crosshair min distance"		"8"
    "penetration"		"1"
    "damage"		"30"
    "range"		"4096"
    "range modifier"		"0.850000"
    "flinch velocity modifier large"		"0.500000"
    "flinch velocity modifier small"		"0.650000"
    "spread"		"2.000000"
    "inaccuracy crouch"		"4.200000"
    "inaccuracy stand"		"5.600000"
    "inaccuracy land"		"0.185000"
    "inaccuracy ladder"		"137.000000"
    "inaccuracy fire"		"56.000000"
    "inaccuracy move"		"10.000000"
    "spread alt"		"15.000000"
    "inaccuracy crouch alt"		"3.000000"
    "inaccuracy stand alt"		"5.600000"
    "inaccuracy land alt"		"0.185000"
    "inaccuracy ladder alt"		"119.250000"
    "inaccuracy fire alt"		"45.000000"
    "inaccuracy move alt"		"12.950000"
    "recovery time crouch"		"0.200000"
    "recovery time stand"		"0.200000"
    "recoil angle"		"0"
    "recoil angle variance"		"20"
    "recoil magnitude"		"18"
    "recoil magnitude variance"		"0"
    "recoil seed"		"4484"
    "recoil angle alt"		"0"
    "recoil angle variance alt"		"20"
    "recoil magnitude alt"		"30"
    "recoil magnitude variance alt"		"5"
    "primary clip size"		"20"
    "weapon weight"		"5"
    "rumble effect"		"1"
    "max player speed alt"		"240"
    "recovery time crouch final"		"0.330000"
    "recovery time stand final"		"0.330000"
    "recovery transition start bullet"		"0"
    "recovery transition end bullet"		"5"
}]=]
SWEP.ItemDefVisuals = [=["visuals 07/17/2020"
{
    "muzzle_flash_effect_1st_person"		"weapon_muzzle_flash_pistol"
    "muzzle_flash_effect_3rd_person"		"weapon_muzzle_flash_pistol"
    "heat_effect"		"weapon_muzzle_smoke"
    "eject_brass_effect"		"weapon_shell_casing_9mm"
    "tracer_effect"		"weapon_tracers_pistol"
    "weapon_type"		"Pistol"
    "player_animation_extension"		"pistol"
    "primary_ammo"		"BULLET_PLAYER_9MM"
    "sound_single_shot"		"Weapon_Glock_CSGO.Single"
    "sound_nearlyempty"		"Default.nearlyempty"
}]=]
