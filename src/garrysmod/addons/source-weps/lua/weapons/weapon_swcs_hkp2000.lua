SWEP.Base = "weapon_swcs_base"
SWEP.Category = "Counter-Strike: Global Offensive"

SWEP.PrintName = "P2000"
SWEP.Spawnable = true
SWEP.HoldType = "pistol"
SWEP.WorldModel = Model"models/weapons/csgo/w_pist_hkp2000_dropped.mdl"
SWEP.WorldModelPlayer = Model"models/weapons/csgo/w_pist_hkp2000.mdl"
SWEP.ViewModel = Model"models/weapons/csgo/v_pist_hkp2000.mdl"
sound.Add({
	name = "Weapon_hkp2000_CSGO.Single",
	channel = CHAN_STATIC,
	level = 79,
	volume = 1.0,
	pitch = {99, 101},
	sound = {Sound")weapons/csgo/hkp2000/hkp2000_01.wav", Sound")weapons/csgo/hkp2000/hkp2000_02.wav", Sound")weapons/csgo/hkp2000/hkp2000_03.wav",}
})
sound.Add({
	name = "Weapon_hkp2000_CSGO.Clipout",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.5, 0.7},
	pitch = {97, 105},
	sound = Sound")weapons/csgo/hkp2000/hkp2000_clipout.wav",
})
sound.Add({
	name = "Weapon_hkp2000_CSGO.Clipin",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.5, 0.7},
	pitch = {97, 105},
	sound = Sound")weapons/csgo/hkp2000/hkp2000_clipin.wav",
})
sound.Add({
	name = "Weapon_hkp2000_CSGO.Sliderelease",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.5, 0.7},
	pitch = {97, 105},
	sound = Sound")weapons/csgo/hkp2000/hkp2000_sliderelease.wav",
})
sound.Add({
	name = "Weapon_hkp2000_CSGO.Slideback",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.5, 0.7},
	pitch = {97, 105},
	sound = Sound")weapons/csgo/hkp2000/hkp2000_slideback.wav",
})
sound.Add({
	name = "Weapon_hkp2000_CSGO.Draw",
	channel = CHAN_STATIC,
	level = 65,
	volume = 0.3,
	pitch = {97, 105},
	sound = Sound")weapons/csgo/hkp2000/hkp2000_draw.wav",
})

SWEP.ItemDefAttributes = [=["attributes 07/05/2020"
{
    "magazine model"		"models/weapons/w_pist_hkp2000_mag.mdl"
    "uid model"		"models/weapons/uid_small.mdl"
    "primary reserve ammo max"		"52"
    "inaccuracy jump initial"		"96.599998"
    "inaccuracy jump"		"94.480003"
    "inaccuracy jump alt"		"94.480003"
    "heat per shot"		"0.300000"
    "tracer frequency"		"1"
    "max player speed"		"240"
    "in game price"		"200"
    "armor ratio"		"1.010000"
    "crosshair min distance"		"8"
    "penetration"		"1"
    "damage"		"35"
    "range"		"4096"
    "range modifier"		"0.910000"
    "cycletime"		"0.170000"
    "flinch velocity modifier large"		"0.500000"
    "flinch velocity modifier small"		"0.650000"
    "spread"		"2.000000"
    "inaccuracy crouch"		"3.680000"
    "inaccuracy stand"		"4.900000"
    "inaccuracy land"		"0.191000"
    "inaccuracy ladder"		"138.320007"
    "inaccuracy fire"		"50.000000"
    "inaccuracy move"		"13.000000"
    "spread alt"		"1.500000"
    "inaccuracy crouch alt"		"3.680000"
    "inaccuracy stand alt"		"4.900000"
    "inaccuracy land alt"		"0.198000"
    "inaccuracy ladder alt"		"119.900002"
    "inaccuracy fire alt"		"13.150000"
    "inaccuracy move alt"		"13.870000"
    "recovery time crouch"		"0.291277"
    "recovery time stand"		"0.349532"
    "recoil angle"		"0"
    "recoil angle variance"		"0"
    "recoil magnitude"		"26"
    "recoil magnitude variance"		"0"
    "recoil seed"		"5426"
    "primary clip size"		"13"
    "weapon weight"		"5"
    "rumble effect"		"1"
    "max player speed alt"		"240"
    "recoil angle alt"		"0"
    "recoil angle variance alt"		"0"
    "recoil magnitude alt"		"26"
    "recoil magnitude variance alt"		"0"
    "recovery time crouch final"		"0.291277"
    "recovery time stand final"		"0.349532"
}]=]
SWEP.ItemDefVisuals = [=["visuals 07/07/2020"
{
    "muzzle_flash_effect_1st_person"		"weapon_muzzle_flash_pistol"
    "muzzle_flash_effect_3rd_person"		"weapon_muzzle_flash_pistol"
    "heat_effect"		"weapon_muzzle_smoke"
    "eject_brass_effect"		"weapon_shell_casing_9mm"
    "tracer_effect"		"weapon_tracers_pistol"
    "weapon_type"		"Pistol"
    "player_animation_extension"		"pistol"
    "primary_ammo"		"BULLET_PLAYER_357SIG"
    "sound_single_shot"		"Weapon_hkp2000_CSGO.Single"
    "sound_nearlyempty"		"Default.nearlyempty"
}]=]
