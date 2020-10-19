SWEP.Base = "weapon_swcs_base"
SWEP.Category = "Counter-Strike: Global Offensive"

SWEP.is_aug = true

SWEP.PrintName = "AUG"
SWEP.Spawnable = true
SWEP.HoldType = "smg"
SWEP.WorldModel = Model"models/weapons/csgo/w_rif_aug_dropped.mdl"
SWEP.WorldModelPlayer = Model"models/weapons/csgo/w_rif_aug.mdl"
SWEP.ViewModel = Model"models/weapons/csgo/v_rif_aug.mdl"

sound.Add({
	name = "Weapon_AUG_CSGO.Single",
	channel = CHAN_STATIC,
	level = 79,
	volume = 0.9,
	pitch = 100,
	sound = {Sound")weapons/csgo/aug/aug_01.wav", Sound")weapons/csgo/aug/aug_02.wav", Sound")weapons/csgo/aug/aug_03.wav", Sound")weapons/csgo/aug/aug_04.wav"}
})
sound.Add({
	name = "Weapon_AUG_CSGO.Draw",
	channel = CHAN_ITEM,
	level = 65,
	volume = 0.5,
	sound = Sound"weapons/csgo/aug/aug_draw.wav"
})
sound.Add({
	name = "Weapon_AUG_CSGO.BoltPull",
	channel = CHAN_ITEM,
	level = 65,
	volume = { 0.5, 1 },
	pitch = { 100, 105 },
	sound = Sound"weapons/csgo/aug/aug_boltpull.wav"
})
sound.Add({
	name = "Weapon_AUG_CSGO.BoltRelease",
	channel = CHAN_ITEM,
	level = 65,
	volume = { 0.5, 1 },
	pitch = { 100, 105 },
	sound = Sound"weapons/csgo/aug/aug_boltrelease.wav"
})
sound.Add({
	name = "Weapon_AUG_CSGO.Clipin",
	channel = CHAN_ITEM,
	level = 65,
	volume = { 0.5, 1 },
	pitch = { 100, 105 },
	sound = Sound"weapons/csgo/aug/aug_clipin.wav"
})
sound.Add({
	name = "Weapon_AUG_CSGO.Clipout",
	channel = CHAN_ITEM,
	level = 65,
	volume = { 0.5, 1 },
	pitch = { 100, 105 },
	sound = Sound"weapons/csgo/aug/aug_clipout.wav"
})
sound.Add({
	name = "Weapon_AUG_CSGO.Cliphit",
	channel = CHAN_ITEM,
	level = 65,
	volume = { 0.5, 1 },
	pitch = { 100, 105 },
	sound = Sound"weapons/csgo/aug/aug_cliphit.wav"
})
sound.Add({
	name = "Weapon_AUG_CSGO.WeaponMove1",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement3.wav"
})
sound.Add({
	name = "Weapon_AUG_CSGO.WeaponMove2",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement2.wav"
})
sound.Add({
	name = "Weapon_AUG_CSGO.WeaponMove3",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.5, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement3.wav"
})
sound.Add({
	name = "Weapon_AUG_CSGO.ZoomIn",
	channel = CHAN_STATIC,
	level = 65,
	volume = 0.4,
	sound = Sound"weapons/csgo/aug/aug_zoom_in.wav"
})
sound.Add({
	name = "Weapon_AUG_CSGO.ZoomOut",
	channel = CHAN_STATIC,
	level = 65,
	volume = 0.6,
	sound = Sound"weapons/csgo/aug/aug_zoom_out.wav"
})

SWEP.ItemDefAttributes = [=["attributes 07/03/2020"
{
    "magazine model"		"models/weapons/w_rif_aug_mag.mdl"
    "aimsight capable"		"1"
    "aimsight speed up"		"10.000000"
    "aimsight speed down"		"8.000000"
    "aimsight looseness"		"0.030000"
    "aimsight eye pos"		"-1.56 -3.6 -0.07"
    "aimsight pivot angle"		"0.78 -0.1 -0.03"
    "aimsight fov"		"45"
    "aimsight pivot forward"		"10"
    "aimsight lens mask"		"models/weapons/v_rif_aug_scopelensmask.mdl"
    "primary reserve ammo max"		"90"
    "tracer frequency alt"		"3"
    "inaccuracy jump initial"		"101.559998"
    "inaccuracy jump"		"105.989998"
    "inaccuracy jump alt"		"105.989998"
    "heat per shot"		"0.350000"
    "addon scale"		"0.900000"
    "tracer frequency"		"3"
    "max player speed"		"220"
    "max player speed alt"		"150"
    "is full auto"		"1"
    "in game price"		"3300"
    "armor ratio"		"1.800000"
    "crosshair min distance"		"3"
    "zoom levels"		"1"
    "zoom time 0"		"0.060000"
    "zoom fov 1"		"45"
    "zoom time 1"		"0.100000"
    "penetration"		"2"
    "damage"		"28"
    "range"		"8192"
    "cycletime"		"0.100000"
    "time to idle"		"1.900000"
    "flinch velocity modifier large"		"0.400000"
    "flinch velocity modifier small"		"0.550000"
    "spread"		"0.500000"
    "inaccuracy crouch"		"3.680000"
    "inaccuracy stand"		"4.900000"
    "inaccuracy land"		"0.208000"
    "inaccuracy ladder"		"110.040001"
    "inaccuracy fire"		"7.290000"
    "inaccuracy move"		"135.449997"
    "spread alt"		"0.300000"
    "inaccuracy crouch alt"		"3.110000"
    "inaccuracy stand alt"		"3.680000"
    "inaccuracy land alt"		"0.208000"
    "inaccuracy ladder alt"		"100.040001"
    "inaccuracy fire alt"		"7.290000"
    "inaccuracy move alt"		"105.449997"
    "recovery time crouch"		"0.305520"
    "recovery time stand"		"0.429727"
    "recoil angle"		"0"
    "recoil angle variance"		"60"
    "recoil magnitude"		"24"
    "recoil magnitude variance"		"0"
    "recoil seed"		"24204"
    "recoil magnitude alt"		"16"
    "primary clip size"		"30"
    "weapon weight"		"25"
    "rumble effect"		"4"
    "recoil angle alt"		"0"
    "recoil angle variance alt"		"60"
    "recoil magnitude variance alt"		"0"
    "recovery time crouch final"		"0.305520"
    "recovery time stand final"		"0.429727"
}]=]
SWEP.ItemDefVisuals = [=["visuals 07/07/2020"
{
    "muzzle_flash_effect_1st_person"		"weapon_muzzle_flash_assaultrifle"
    "muzzle_flash_effect_3rd_person"		"weapon_muzzle_flash_assaultrifle"
    "heat_effect"		"weapon_muzzle_smoke"
    "addon_location"		"primary_rifle"
    "eject_brass_effect"		"weapon_shell_casing_rifle"
    "tracer_effect"		"weapon_tracers_assrifle"
    "weapon_type"		"Rifle"
    "player_animation_extension"		"aug"
    "primary_ammo"		"BULLET_PLAYER_762MM"
    "sound_single_shot"		"Weapon_AUG_CSGO.Single"
    "sound_nearlyempty"		"Default.nearlyempty"
}]=]
SWEP.ItemDefPrefab = [=["prefab 08/11/2020" {
    "zoom_in_sound"		"Weapon_AUG_CSGO.ZoomIn"
	"zoom_out_sound"		"Weapon_AUG_CSGO.ZoomOut"
}]=]
