SWEP.Base = "weapon_swcs_base"
SWEP.Category = "Counter-Strike: Global Offensive"

SWEP.PrintName = "FAMAS"
SWEP.Spawnable = true
SWEP.HoldType = "ar2"
SWEP.WorldModel = Model"models/weapons/csgo/w_rif_famas_dropped.mdl"
SWEP.WorldModelPlayer = Model"models/weapons/csgo/w_rif_famas.mdl"
SWEP.ViewModel = Model"models/weapons/csgo/v_rif_famas.mdl"

sound.Add({
	name = "Weapon_FAMAS_CSGO.Single",
	channel = CHAN_STATIC,
	level = 79,
	volume = 0.85,
	pitch = 100,
	sound = {Sound")weapons/csgo/famas/famas_01.wav",Sound")weapons/csgo/famas/famas_02.wav",Sound")weapons/csgo/famas/famas_03.wav",Sound")weapons/csgo/famas/famas_04.wav"}
})
sound.Add({
	name = "Weapon_FAMAS_CSGO.Clipout",
	channel = CHAN_ITEM,
	level = 65,
	sound = Sound"weapons/csgo/famas/famas_clipout.wav"
})
sound.Add({
	name = "Weapon_FAMAS_CSGO.Clipin",
	channel = CHAN_ITEM,
	level = 65,
	sound = Sound"weapons/csgo/famas/famas_clipin.wav"
})
sound.Add({
	name = "Weapon_FAMAS_CSGO.Draw",
	channel = CHAN_ITEM,
	level = 75,
	volume = 0.5,
	sound = Sound"weapons/csgo/famas/famas_draw.wav"
})
sound.Add({
	name = "Weapon_FAMAS_CSGO.BoltBack",
	channel = CHAN_ITEM,
	level = 65,
	sound = Sound"weapons/csgo/famas/famas_boltback.wav"
})
sound.Add({
	name = "Weapon_FAMAS_CSGO.BoltForward",
	channel = CHAN_ITEM,
	level = 65,
	sound = Sound"weapons/csgo/famas/famas_boltforward.wav"
})
sound.Add({
	name = "Weapon_FAMAS_CSGO.ClipHit",
	channel = CHAN_ITEM,
	level = 65,
	sound = Sound"weapons/csgo/famas/famas_cliphit.wav"
})
sound.Add({
	name = "Weapon_FAMAS_CSGO.WeaponMove1",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement3.wav"
})
sound.Add({
	name = "Weapon_FAMAS_CSGO.WeaponMove2",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement2.wav"
})
sound.Add({
	name = "Weapon_FAMAS_CSGO.WeaponMove3",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement3.wav"
})

SWEP.ItemDefAttributes = [=["attributes 06/30/2020"
{
    "magazine model"		"models/weapons/w_rif_famas_mag.mdl"
    "primary reserve ammo max"		"90"
    "recovery time crouch"		"0.120000"
    "recovery time crouch final"		"0.480000"
    "recovery time stand"		"0.250000"
    "recovery time stand final"		"0.500000"
    "tracer frequency alt"		"3"
    "inaccuracy jump initial"		"94.769997"
    "inaccuracy jump"		"110.389999"
    "inaccuracy jump alt"		"110.389999"
    "heat per shot"		"0.350000"
    "addon scale"		"0.900000"
    "tracer frequency"		"3"
    "max player speed"		"220"
    "is full auto"		"1"
    "in game price"		"2050"
    "armor ratio"		"1.400000"
    "penetration"		"2"
    "damage"		"30"
    "range"		"8192"
    "range modifier"		"0.960000"
    "cycletime"		"0.090000"
    "time to idle"		"1.100000"
    "flinch velocity modifier large"		"0.400000"
    "flinch velocity modifier small"		"0.550000"
    "spread"		"0.600000"
    "inaccuracy crouch"		"7.390000"
    "inaccuracy stand"		"9.850000"
    "inaccuracy land"		"0.205000"
    "inaccuracy ladder"		"118.716003"
    "inaccuracy fire"		"6.050000"
    "inaccuracy move"		"99.339996"
    "spread alt"		"0.600000"
    "inaccuracy crouch alt"		"3.250000"
    "inaccuracy stand alt"		"3.690000"
    "inaccuracy land alt"		"0.205000"
    "inaccuracy ladder alt"		"118.716003"
    "inaccuracy fire alt"		"3.350000"
    "inaccuracy move alt"		"99.339996"
    "recoil angle"		"0"
    "recoil angle variance"		"60"
    "recoil magnitude"		"20"
    "recoil magnitude variance"		"1"
    "recoil seed"		"39623"
    "recoil angle alt"		"0"
    "recoil angle variance alt"		"50"
    "recoil magnitude alt"		"20"
    "recoil magnitude variance alt"		"1"
    "primary clip size"		"25"
    "weapon weight"		"75"
    "rumble effect"		"3"
    "max player speed alt"		"220"
    "has burst mode"		"1"
    "cycletime when in burst mode"		"0.550000"
    "time between burst shots"		"0.075000"
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
    "player_animation_extension"		"famas"
    "primary_ammo"		"BULLET_PLAYER_556MM"
    "sound_single_shot"		"Weapon_FAMAS_CSGO.Single"
    "sound_nearlyempty"		"Default.nearlyempty"
}]=]
