SWEP.Base = "weapon_swcs_base"
SWEP.Category = "Counter-Strike: Global Offensive"

SWEP.PrintName = "M4A1-S"
SWEP.Spawnable = true
SWEP.HoldType = "ar2"
SWEP.WorldModel = Model"models/weapons/csgo/w_rif_m4a1_s_dropped.mdl"
SWEP.WorldModelPlayer = Model"models/weapons/csgo/w_rif_m4a1_s.mdl"
SWEP.ViewModel = Model"models/weapons/csgo/v_rif_m4a1_s.mdl"

-- silenced sound
sound.Add({
	name = "Weapon_M4A1_CSGO.Silenced",
	channel = CHAN_STATIC,
	level = 73,
	volume = 0.9,
	pitch = 100,
	sound = Sound")weapons/csgo/m4a1/m4a1_silencer_01.wav"
})
-- unsilenced sound
sound.Add({
	name = "Weapon_M4A1_CSGO.SilencedSingle",
	channel = CHAN_STATIC,
	level = 60,
	volume = 1.0,
	pitch = 100,
	sound = {Sound")weapons/csgo/m4a1/m4a1_us_01.wav",Sound")weapons/csgo/m4a1/m4a1_us_02.wav",Sound")weapons/csgo/m4a1/m4a1_us_03.wav",Sound")weapons/csgo/m4a1/m4a1_us_04.wav"}
})
sound.Add({
	name = "Weapon_M4A1S_CSGO.BoltBack",
	channel = CHAN_ITEM,
	level = 65,
	volume = 0.7,
	pitch = { 100, 101 },
	sound = Sound"weapons/csgo/m4a1/m4a1_silencer_boltback.wav"
})
sound.Add({
	name = "Weapon_M4A1S_CSGO.BoltForward",
	channel = CHAN_ITEM,
	level = 65,
	volume = 0.7,
	pitch = { 100, 101 },
	sound = Sound"weapons/csgo/m4a1/m4a1_silencer_boltforward.wav"
})

-- silencer sounds
sound.Add({
	name = "Weapon_M4A1_CSGO.SilencerScrewOnStart",
	channel = CHAN_ITEM,
	level = 65,
	volume = 1.0,
	pitch = 100,
	sound = Sound"weapons/csgo/m4a1/m4a1_silencer_screw_on_start.wav"
})
sound.Add({
	name = "Weapon_M4A1_CSGO.SilencerScrewOffEnd",
	channel = CHAN_ITEM,
	level = 65,
	volume = 1.0,
	pitch = 100,
	sound = Sound"weapons/csgo/m4a1/m4a1_silencer_screw_off_end.wav"
})
sound.Add({
	name = "Weapon_M4A1_CSGO.SilencerScrew1",
	channel = CHAN_ITEM,
	level = 65,
	volume = 1.0,
	pitch = 100,
	sound = Sound"weapons/csgo/m4a1/m4a1_silencer_screw_1.wav"
})
sound.Add({
	name = "Weapon_M4A1_CSGO.SilencerScrew2",
	channel = CHAN_ITEM,
	level = 65,
	volume = 1.0,
	pitch = 100,
	sound = Sound"weapons/csgo/m4a1/m4a1_silencer_screw_2.wav"
})
sound.Add({
	name = "Weapon_M4A1_CSGO.SilencerScrew3",
	channel = CHAN_ITEM,
	level = 65,
	volume = 1.0,
	pitch = 100,
	sound = Sound"weapons/csgo/m4a1/m4a1_silencer_screw_3.wav"
})
sound.Add({
	name = "Weapon_M4A1_CSGO.SilencerScrew4",
	channel = CHAN_ITEM,
	level = 65,
	volume = 1.0,
	pitch = 100,
	sound = Sound"weapons/csgo/m4a1/m4a1_silencer_screw_4.wav"
})
sound.Add({
	name = "Weapon_M4A1_CSGO.SilencerScrew5",
	channel = CHAN_ITEM,
	level = 65,
	volume = 1.0,
	pitch = 100,
	sound = Sound"weapons/csgo/m4a1/m4a1_silencer_screw_5.wav"
})
sound.Add({
	name = "Weapon_M4A1_CSGO.SilencerWeaponMove1",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, 0.1},
	sound = Sound"weapons/csgo/movement1.wav"
})
sound.Add({
	name = "Weapon_M4A1_CSGO.SilencerWeaponMove2",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, 0.1},
	sound = Sound"weapons/csgo/movement2.wav"
})
sound.Add({
	name = "Weapon_M4A1_CSGO.SilencerWeaponMove3",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, 0.1},
	sound = Sound"weapons/csgo/movement3.wav"
})

SWEP.ItemDefAttributes = [=["attributes 07/03/2020"
{
    "icon display model"		"models/weapons/w_rif_m4a1_s_icon.mdl"
    "magazine model"		"models/weapons/w_rif_m4a1_s_mag.mdl"
    "primary reserve ammo max"		"75"
    "is full auto"		"1"
    "time between burst shots"		"0.090000"
    "has silencer"		"1"
    "in game price"		"2900"
    "primary clip size"		"25"
    "heat per shot"		"0.350000"
    "addon scale"		"0.900000"
    "tracer frequency"		"3"
    "tracer frequency alt"		"0"
    "max player speed"		"225"
    "max player speed alt"		"225"
    "crosshair min distance"		"4"
    "crosshair delta distance"		"3"
    "penetration"		"2"
    "damage"		"33"
    "range"		"8192"
    "range modifier"		"0.990000"
    "bullets"		"1"
    "cycletime"		"0.100000"
    "time to idle"		"1.500000"
    "idle interval"		"60"
    "flinch velocity modifier large"		"0.400000"
    "flinch velocity modifier small"		"0.400000"
    "spread"		"0.600000"
    "inaccuracy stand"		"4.900000"
    "inaccuracy jump initial"		"96.769997"
    "inaccuracy jump"		"99.699997"
    "inaccuracy land"		"0.197000"
    "inaccuracy ladder"		"110.994003"
    "inaccuracy fire"		"12.000000"
    "inaccuracy move"		"92.879997"
    "spread alt"		"0.500000"
    "inaccuracy stand alt"		"4.900000"
    "inaccuracy jump alt"		"99.699997"
    "inaccuracy land alt"		"0.197000"
    "inaccuracy ladder alt"		"113.671997"
    "inaccuracy fire alt"		"7.000000"
    "inaccuracy move alt"		"122.000000"
    "recoil seed"		"38965"
    "recoil angle"		"0"
    "recoil angle alt"		"0"
    "recoil angle variance"		"65"
    "recoil angle variance alt"		"65"
    "recoil magnitude"		"25"
    "recoil magnitude variance"		"3"
    "recoil magnitude alt"		"21"
    "recoil magnitude variance alt"		"0"
    "recovery time crouch"		"0.242100"
    "recovery time crouch final"		"0.332888"
    "recovery time stand"		"0.338941"
    "recovery time stand final"		"0.466044"
    "inaccuracy crouch"		"4.100000"
    "inaccuracy crouch alt"		"4.100000"
    "addon scale"		"1.000000"
    "armor ratio"		"1.400000"
    "weapon weight"		"25"
    "rumble effect"		"4"
}]=]
SWEP.ItemDefVisuals = [=["visuals 07/07/2020"
{
	"primary_ammo"		"BULLET_PLAYER_556MM_SMALL"
	"weapon_type"		"Rifle"
	"addon_location"		"primary_rifle"
	"eject_brass_effect"		"weapon_shell_casing_rifle"
	"tracer_effect"		"weapon_tracers_assrifle"
	"muzzle_flash_effect_1st_person"		"weapon_muzzle_flash_assaultrifle"
	"muzzle_flash_effect_1st_person_alt"		"weapon_muzzle_flash_assaultrifle_silenced"
	"muzzle_flash_effect_3rd_person"		"weapon_muzzle_flash_assaultrifle"
	"muzzle_flash_effect_3rd_person_alt"		"weapon_muzzle_flash_assaultrifle_silenced"
	"heat_effect"		"weapon_muzzle_smoke"
	"player_animation_extension"		"m4_s"
	"sound_single_shot"		"Weapon_M4A1_CSGO.SilencedSingle"
	"sound_special1"		"Weapon_M4A1_CSGO.Silenced"
	"sound_nearlyempty"		"Default.nearlyempty"
}]=]
