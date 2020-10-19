SWEP.Base = "weapon_swcs_base"
SWEP.Category = "Counter-Strike: Global Offensive"

SWEP.PrintName = "Tec-9"
SWEP.Spawnable = true
SWEP.HoldType = "smg"
SWEP.WorldModel = Model"models/weapons/csgo/w_pist_tec9_dropped.mdl"
SWEP.WorldModelPlayer = Model"models/weapons/csgo/w_pist_tec9.mdl"
SWEP.ViewModel = Model"models/weapons/csgo/v_pist_tec9.mdl"
sound.Add({
	name = "Weapon_tec9_CSGO.Single",
	channel = CHAN_STATIC,
	level = 79,
	volume = 0.8,
	pitch = {99, 101},
	sound = Sound")weapons/csgo/tec9/tec9_02.wav"
})
sound.Add({
	name = "Weapon_tec9_CSGO.Clipout",
	channel = CHAN_ITEM,
	level = 60,
	volume = {0.5, 1.0},
	pitch = {97, 105},
	sound = Sound")weapons/csgo/tec9/tec9_clipout.wav",
})
sound.Add({
	name = "Weapon_tec9_CSGO.Clipin",
	channel = CHAN_ITEM,
	level = 60,
	volume = {0.5, 1.0},
	pitch = {97, 105},
	sound = Sound")weapons/csgo/tec9/tec9_clipin.wav",
})
sound.Add({
	name = "Weapon_tec9_CSGO.Boltrelease",
	channel = CHAN_ITEM,
	level = 60,
	volume = {0.5, 1.0},
	pitch = {97, 105},
	sound = Sound")weapons/csgo/tec9/tec9_boltrelease.wav",
})
sound.Add({
	name = "Weapon_tec9_CSGO.Boltpull",
	channel = CHAN_ITEM,
	level = 60,
	volume = {0.5, 1.0},
	pitch = {97, 105},
	sound = Sound")weapons/csgo/tec9/tec9_boltpull.wav",
})
sound.Add({
	name = "Weapon_tec9_CSGO.Draw",
	channel = CHAN_STATIC,
	level = 65,
	volume = 0.3,
	sound = Sound")weapons/csgo/tec9/tec9_draw.wav",
})

SWEP.ItemDefAttributes = [=["attributes 07/19/2020"
{
    "magazine model"		"models/weapons/w_pist_tec9_mag.mdl"
    "primary reserve ammo max"		"90"
    "inaccuracy jump initial"		"71.169998"
    "inaccuracy jump"		"79.779999"
    "heat per shot"		"0.300000"
    "tracer frequency"		"1"
    "max player speed"		"240"
    "in game price"		"500"
    "armor ratio"		"1.812000"
    "crosshair min distance"		"8"
    "penetration"		"1"
    "damage"		"33"
    "range"		"4096"
    "range modifier"		"0.790000"
    "cycletime"		"0.120000"
    "flinch velocity modifier large"		"0.500000"
    "flinch velocity modifier small"		"0.650000"
    "spread"		"2.000000"
    "inaccuracy crouch"		"3.680000"
    "inaccuracy stand"		"4.900000"
    "inaccuracy land"		"0.211000"
    "inaccuracy ladder"		"120.599998"
    "inaccuracy fire"		"45"
    "inaccuracy move"		"3.810000"
    "recovery time crouch"		"0.315000"
    "recovery time stand"		"0.391000"
    "recoil angle"		"0"
    "recoil angle variance"		"60"
    "recoil magnitude"		"23"
    "recoil magnitude variance"		"3"
    "recoil seed"		"789"
    "primary clip size"		"18"
    "weapon weight"		"6"
    "rumble effect"		"1"
    "inaccuracy crouch alt"		"7.270000"
    "inaccuracy fire alt"		"36.880001"
    "inaccuracy jump alt"		"79.779999"
    "inaccuracy ladder alt"		"120.599998"
    "inaccuracy land alt"		"0.211000"
    "inaccuracy move alt"		"3.810000"
    "inaccuracy stand alt"		"9.030000"
    "max player speed alt"		"240"
    "recoil angle alt"		"0"
    "recoil angle variance alt"		"60"
    "recoil magnitude alt"		"23"
    "recoil magnitude variance alt"		"3"
    "recovery time crouch final"		"0.315000"
    "recovery time stand final"		"0.391000"
    "spread alt"		"1.800000"
}]=]
SWEP.ItemDefVisuals = [=["visuals 07/19/2020"
{
    "muzzle_flash_effect_1st_person"		"weapon_muzzle_flash_pistol"
    "muzzle_flash_effect_3rd_person"		"weapon_muzzle_flash_pistol"
    "heat_effect"		"weapon_muzzle_smoke"
    "eject_brass_effect"		"weapon_shell_casing_9mm"
    "tracer_effect"		"weapon_tracers_pistol"
    "weapon_type"		"Pistol"
    "player_animation_extension"		"tec9"
    "primary_ammo"		"BULLET_PLAYER_9MM"
    "sound_single_shot"		"Weapon_tec9_CSGO.Single"
    "sound_nearlyempty"		"Default.nearlyempty"
}]=]
