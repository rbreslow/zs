SWEP.Base = "weapon_swcs_base"
SWEP.Category = "Counter-Strike: Global Offensive"

SWEP.PrintName = "P250"
SWEP.Spawnable = true
SWEP.HoldType = "pistol"
SWEP.WorldModel = Model"models/weapons/csgo/w_pist_p250_dropped.mdl"
SWEP.WorldModelPlayer = Model"models/weapons/csgo/w_pist_p250.mdl"
SWEP.ViewModel = Model"models/weapons/csgo/v_pist_p250.mdl"
sound.Add({
	name = "Weapon_P250_CSGO.Single",
	channel = CHAN_STATIC,
	level = 79,
	volume = 0.9,
	pitch = {98, 101},
	sound = Sound")weapons/csgo/p250/p250_01.wav"
})
sound.Add({
	name = "Weapon_P250_CSGO.Clipout",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.5, 1.0},
	pitch = {97, 105},
	sound = Sound")weapons/csgo/p250/p250_clipout.wav",
})
sound.Add({
	name = "Weapon_P250_CSGO.Clipin",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.5, 1.0},
	pitch = {97, 105},
	sound = Sound")weapons/csgo/p250/p250_clipin.wav",
})
sound.Add({
	name = "Weapon_P250_CSGO.Sliderelease",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.5, 1.0},
	pitch = {97, 105},
	sound = Sound")weapons/csgo/p250/p250_sliderelease.wav",
})
sound.Add({
	name = "Weapon_P250_CSGO.Slideback",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.5, 1.0},
	pitch = {97, 105},
	sound = Sound")weapons/csgo/p250/p250_slideback.wav",
})
sound.Add({
	name = "Weapon_P250_CSGO.Draw",
	channel = CHAN_STATIC,
	level = 65,
	volume = 0.3,
	sound = Sound")weapons/csgo/p250/p250_draw.wav",
})

SWEP.ItemDefAttributes = [=["attributes 07/19/2020"
{
    "magazine model"		"models/weapons/w_pist_p250_mag.mdl"
    "primary reserve ammo max"		"26"
    "inaccuracy jump initial"		"96.620003"
    "inaccuracy jump"		"92.959999"
    "heat per shot"		"0.300000"
    "tracer frequency"		"1"
    "max player speed"		"240"
    "in game price"		"300"
    "armor ratio"		"1.280000"
    "crosshair min distance"		"8"
    "penetration"		"1"
    "damage"		"38"
    "range"		"4096"
    "range modifier"		"0.900000"
    "flinch velocity modifier large"		"0.500000"
    "flinch velocity modifier small"		"0.650000"
    "spread"		"2.000000"
    "inaccuracy crouch"		"6.830000"
    "inaccuracy stand"		"9.100000"
    "inaccuracy land"		"0.190000"
    "inaccuracy ladder"		"138.000000"
    "inaccuracy fire"		"52.450001"
    "inaccuracy move"		"20"
    "recovery time crouch"		"0.287823"
    "recovery time stand"		"0.345388"
    "recoil angle"		"0"
    "recoil angle variance"		"10"
    "recoil magnitude"		"26"
    "recoil magnitude variance"		"3"
    "recoil seed"		"9788"
    "primary clip size"		"13"
    "weapon weight"		"5"
    "rumble effect"		"1"
    "inaccuracy crouch alt"		"6.830000"
    "inaccuracy fire alt"		"52.450001"
    "inaccuracy jump alt"		"92.959999"
    "inaccuracy ladder alt"		"138.000000"
    "inaccuracy land alt"		"0.190000"
    "inaccuracy move alt"		"13.410000"
    "inaccuracy stand alt"		"9.100000"
    "max player speed alt"		"240"
    "recoil angle alt"		"0"
    "recoil angle variance alt"		"10"
    "recoil magnitude alt"		"26"
    "recoil magnitude variance alt"		"3"
    "recovery time crouch final"		"0.287823"
    "recovery time stand final"		"0.345388"
    "spread alt"		"2.000000"
}]=]
SWEP.ItemDefVisuals = [=["visuals 07/19/2020"
{
    "muzzle_flash_effect_1st_person"		"weapon_muzzle_flash_pistol"
    "muzzle_flash_effect_3rd_person"		"weapon_muzzle_flash_pistol"
    "heat_effect"		"weapon_muzzle_smoke"
    "eject_brass_effect"		"weapon_shell_casing_9mm"
    "tracer_effect"		"weapon_tracers_pistol"
    "weapon_type"		"Pistol"
    "player_animation_extension"		"pistol"
    "primary_ammo"		"BULLET_PLAYER_357SIG_P250"
    "sound_single_shot"		"Weapon_P250_CSGO.Single"
    "sound_nearlyempty"		"Default.nearlyempty"
}]=]
