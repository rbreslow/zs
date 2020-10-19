SWEP.Base = "weapon_swcs_base"
SWEP.Category = "Counter-Strike: Global Offensive"

SWEP.PrintName = "Galil AR"
SWEP.Spawnable = true
SWEP.HoldType = "ar2"
SWEP.WorldModel = Model"models/weapons/csgo/w_rif_galilar_dropped.mdl"
SWEP.WorldModelPlayer = Model"models/weapons/csgo/w_rif_galilar.mdl"
SWEP.ViewModel = Model"models/weapons/csgo/v_rif_galilar.mdl"

sound.Add({
	name = "Weapon_GalilAR_CSGO.Single",
	channel = CHAN_STATIC,
	level = 79,
	volume = 0.7,
	pitch = 100,
	sound = {Sound")weapons/csgo/galilar/galil_01.wav",Sound")weapons/csgo/galilar/galil_02.wav",Sound"weapons/csgo/galilar/galil_03.wav",Sound")weapons/csgo/galilar/galil_04.wav"}
})
sound.Add({
	name = "Weapon_GalilAR_CSGO.Clipout",
	channel = CHAN_ITEM,
	level = 65,
	sound = Sound"weapons/csgo/galilar/galil_clipout.wav"
})
sound.Add({
	name = "Weapon_GalilAR_CSGO.Clipin",
	channel = CHAN_ITEM,
	level = 65,
	sound = Sound"weapons/csgo/galilar/galil_clipin.wav"
})
sound.Add({
	name = "Weapon_GalilAR_CSGO.Draw",
	channel = CHAN_ITEM,
	level = 75,
	volume = 0.5,
	sound = Sound"weapons/csgo/galilar/galil_draw.wav"
})
sound.Add({
	name = "Weapon_GalilAR_CSGO.BoltBack",
	channel = CHAN_ITEM,
	level = 65,
	sound = Sound"weapons/csgo/galilar/galil_boltback.wav"
})
sound.Add({
	name = "Weapon_GalilAR_CSGO.BoltForward",
	channel = CHAN_ITEM,
	level = 65,
	sound = Sound"weapons/csgo/galilar/galil_boltforward.wav"
})
sound.Add({
	name = "Weapon_GalilAR_CSGO.WeaponMove1",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement3.wav"
})
sound.Add({
	name = "Weapon_GalilAR_CSGO.WeaponMove2",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement2.wav"
})
sound.Add({
	name = "Weapon_GalilAR_CSGO.WeaponMove3",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement3.wav"
})

SWEP.ItemDefAttributes = [=["attributes 04/24/2020"
{
    "magazine model"		"models/weapons/w_rif_galilar_mag.mdl"
    "primary reserve ammo max"		"90"
    "recovery time crouch"		"0.150000"
    "recovery time crouch final"		"0.470000"
    "recovery time stand"		"0.300000"
    "recovery time stand final"		"0.500000"
    "inaccuracy jump initial"		"105.389999"
    "inaccuracy jump"		"149.779999"
    "inaccuracy jump alt"		"149.779999"
    "heat per shot"		"0.350000"
    "addon scale"		"0.900000"
    "tracer frequency"		"3"
    "max player speed"		"215"
    "is full auto"		"1"
    "in game price"		"1800"
    "armor ratio"		"1.550000"
    "penetration"		"2"
    "damage"		"30"
    "range"		"8192"
    "cycletime"		"0.090000"
    "time to idle"		"1.280000"
    "flinch velocity modifier large"		"0.400000"
    "flinch velocity modifier small"		"0.550000"
    "spread"		"0.600000"
    "inaccuracy crouch"		"6.580000"
    "inaccuracy stand"		"8.770000"
    "inaccuracy land"		"0.256000"
    "inaccuracy ladder"		"113.580002"
    "inaccuracy fire"		"7.000000"
    "inaccuracy move"		"123.559998"
    "spread alt"		"0.600000"
    "inaccuracy crouch alt"		"4.840000"
    "inaccuracy stand alt"		"7.780000"
    "inaccuracy land alt"		"0.256000"
    "inaccuracy ladder alt"		"113.580002"
    "inaccuracy fire alt"		"5.850000"
    "inaccuracy move alt"		"106.519997"
    "recoil seed"		"51191"
    "recoil angle"		"0"
    "recoil angle variance"		"70"
    "recoil magnitude"		"21"
    "recoil magnitude variance"		"1"
    "primary clip size"		"35"
    "weapon weight"		"25"
    "rumble effect"		"4"
    "max player speed alt"		"215"
    "recoil angle alt"		"0"
    "recoil angle variance alt"		"70"
    "recoil magnitude alt"		"21"
    "recoil magnitude variance alt"		"1"
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
    "player_animation_extension"		"galilar"
    "primary_ammo"		"BULLET_PLAYER_556MM"
    "sound_single_shot"		"Weapon_GalilAR_CSGO.Single"
    "sound_nearlyempty"		"Default.nearlyempty"
}]=]
