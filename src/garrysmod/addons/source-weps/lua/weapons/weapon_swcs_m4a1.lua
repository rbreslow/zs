SWEP.Base = "weapon_swcs_base"
SWEP.Category = "Counter-Strike: Global Offensive"

SWEP.PrintName = "M4A4"
SWEP.Spawnable = true
SWEP.HoldType = "ar2"
SWEP.WorldModel = Model"models/weapons/csgo/w_rif_m4a1_dropped.mdl"
SWEP.WorldModelPlayer = Model"models/weapons/csgo/w_rif_m4a1.mdl"
SWEP.ViewModel = Model"models/weapons/csgo/v_rif_m4a1.mdl"

sound.Add({
	name = "Weapon_M4A1_CSGO.Single",
	channel = CHAN_STATIC,
	level = 79,
	pitch = 120,
	sound = {Sound")weapons/csgo/m4a1/m4a1_01.wav",Sound")weapons/csgo/m4a1/m4a1_02.wav",Sound")weapons/csgo/m4a1/m4a1_03.wav",Sound")weapons/csgo/m4a1/m4a1_04.wav"}
})
sound.Add({
	name = "Weapon_M4A1_CSGO.Draw",
	channel = CHAN_ITEM,
	level = 65,
	volume = 0.7,
	pitch = { 100, 101 },
	sound = Sound"weapons/csgo/m4a1/m4a1_draw.wav"
})
sound.Add({
	name = "Weapon_M4A1_CSGO.Clipout",
	channel = CHAN_ITEM,
	level = 65,
	volume = 0.7,
	pitch = { 100, 101 },
	sound = Sound"weapons/csgo/m4a1/m4a1_clipout.wav"
})
sound.Add({
	name = "Weapon_M4A1_CSGO.Clipin",
	channel = CHAN_ITEM,
	level = 65,
	volume = 0.9,
	pitch = { 100, 105 },
	sound = Sound"weapons/csgo/m4a1/m4a1_clipin.wav"
})
sound.Add({
	name = "Weapon_M4A1_CSGO.BoltBack",
	channel = CHAN_ITEM,
	level = 65,
	volume = 0.8,
	sound = Sound"weapons/csgo/m4a1/m4a1_boltback.wav"
})
sound.Add({
	name = "Weapon_M4A1_CSGO.BoltForward",
	channel = CHAN_ITEM,
	level = 65,
	volume = 0.5,
	sound = Sound"weapons/csgo/m4a1/m4a1_boltforward.wav"
})
sound.Add({
	name = "Weapon_M4A1_CSGO.ClipHit",
	channel = CHAN_ITEM,
	level = 65,
	volume = 0.9,
	sound = Sound"weapons/csgo/m4a1/m4a1_cliphit.wav"
})

sound.Add({
	name = "Weapon_M4A1_CSGO.WeaponMove1",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement1.wav"
})
sound.Add({
	name = "Weapon_M4A1_CSGO.WeaponMove2",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement2.wav"
})
sound.Add({
	name = "Weapon_M4A1_CSGO.WeaponMove3",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement3.wav"
})

SWEP.ItemDefAttributes = [=["attributes 04/22/2020"
{
    "magazine model"		"models/weapons/w_rif_m4a1_mag.mdl"
    "primary reserve ammo max"		"90"
    "recovery time crouch"		"0.242100"
    "recovery time crouch final"		"0.332888"
    "recovery time stand"		"0.338941"
    "recovery time stand final"		"0.466044"
    "inaccuracy crouch"		"4.100000"
    "inaccuracy jump initial"		"94.410004"
    "inaccuracy jump"		"97.269997"
    "inaccuracy jump alt"		"97.269997"
    "heat per shot"		"0.350000"
    "addon scale"		"1.000000"
    "tracer frequency"		"3"
    "max player speed"		"225"
    "is full auto"		"1"
    "in game price"		"3100"
    "armor ratio"		"1.400000"
    "penetration"		"2"
    "damage"		"33"
    "range"		"8192"
    "range modifier"		"0.970000"
    "cycletime"		"0.090000"
    "time to idle"		"1.500000"
    "idle interval"		"60"
    "flinch velocity modifier large"		"0.400000"
    "flinch velocity modifier small"		"0.550000"
    "spread"		"0.600000"
    "inaccuracy stand"		"4.900000"
    "inaccuracy land"		"0.192000"
    "inaccuracy ladder"		"110.994003"
    "inaccuracy fire"		"7.000000"
    "inaccuracy move"		"137.880005"
    "spread alt"		"0.450000"
    "inaccuracy crouch alt"		"3.680000"
    "inaccuracy stand alt"		"4.900000"
    "inaccuracy land alt"		"0.197000"
    "inaccuracy ladder alt"		"113.671997"
    "inaccuracy fire alt"		"6.340000"
    "inaccuracy move alt"		"122.000000"
    "recoil seed"		"38965"
    "recoil angle"		"0"
    "recoil angle variance"		"70"
    "recoil magnitude"		"23"
    "recoil magnitude variance"		"0"
    "primary clip size"		"30"
    "weapon weight"		"25"
    "rumble effect"		"4"
    "max player speed alt"		"225"
    "recoil angle alt"		"0"
    "recoil angle variance alt"		"70"
    "recoil magnitude alt"		"23"
    "recoil magnitude variance alt"		"0"
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
	"player_animation_extension"		"m4"
	"primary_ammo"		"BULLET_PLAYER_556MM"
	"sound_single_shot"		"Weapon_M4A1_CSGO.Single"
	"sound_special1"		"Weapon_M4A1_CSGO.Silenced"
	"sound_nearlyempty"		"Default.nearlyempty"
}]=]
