SWEP.Base = "weapon_swcs_base"
SWEP.Category = "Counter-Strike: Global Offensive"

SWEP.PrintName = "Five-SeveN"
SWEP.Spawnable = true
SWEP.HoldType = "pistol"
SWEP.WorldModel = Model"models/weapons/csgo/w_pist_fiveseven_dropped.mdl"
SWEP.WorldModelPlayer = Model"models/weapons/csgo/w_pist_fiveseven.mdl"
SWEP.ViewModel = Model"models/weapons/csgo/v_pist_fiveseven.mdl"
sound.Add({
	name = "Weapon_FiveSeven_CSGO.Single",
	channel = CHAN_STATIC,
	level = 79,
	volume = 1.0,
	pitch = {99, 101},
	sound = Sound")weapons/csgo/fiveseven/fiveseven_01.wav"
})
sound.Add({
	name = "Weapon_FiveSeven_CSGO.Clipout",
	channel = CHAN_ITEM,
	level = 60,
	volume = 0.7,
	pitch = 100,
	sound = Sound")weapons/csgo/fiveseven/fiveseven_clipout.wav",
})
sound.Add({
	name = "Weapon_FiveSeven_CSGO.Clipin",
	channel = CHAN_ITEM,
	level = 60,
	volume = 0.7,
	pitch = 100,
	sound = Sound")weapons/csgo/fiveseven/fiveseven_clipin.wav",
})
sound.Add({
	name = "Weapon_FiveSeven_CSGO.Sliderelease",
	channel = CHAN_ITEM,
	level = 60,
	volume = 0.7,
	pitch = 100,
	sound = Sound")weapons/csgo/fiveseven/fiveseven_sliderelease.wav",
})
sound.Add({
	name = "Weapon_FiveSeven_CSGO.Slideback",
	channel = CHAN_ITEM,
	level = 60,
	volume = 0.7,
	pitch = 100,
	sound = Sound")weapons/csgo/fiveseven/fiveseven_slideback.wav",
})
sound.Add({
	name = "Weapon_FiveSeven_CSGO.Draw",
	channel = CHAN_STATIC,
	level = 65,
	volume = 0.3,
	sound = Sound")weapons/csgo/fiveseven/fiveseven_draw.wav",
})

SWEP.ItemDefAttributes = [=["attributes 07/19/2020"
{
    "magazine model"		"models/weapons/w_pist_fiveseven_mag.mdl"
    "primary reserve ammo max"		"100"
    "inaccuracy jump initial"		"99.879997"
    "inaccuracy jump"		"89.699997"
    "heat per shot"		"0.300000"
    "tracer frequency"		"1"
    "max player speed"		"240"
    "in game price"		"500"
    "armor ratio"		"1.823000"
    "crosshair min distance"		"8"
    "penetration"		"1"
    "damage"		"32"
    "range"		"4096"
    "range modifier"		"0.810000"
    "flinch velocity modifier large"		"0.500000"
    "flinch velocity modifier small"		"0.650000"
    "spread"		"2.000000"
    "inaccuracy crouch"		"6.830000"
    "inaccuracy stand"		"9.100000"
    "inaccuracy land"		"0.190000"
    "inaccuracy ladder"		"138.000000"
    "inaccuracy fire"		"25"
    "inaccuracy move"		"40"
    "recovery time crouch"		"0.200000"
    "recovery time stand"		"0.200000"
    "recoil angle"		"0"
    "recoil angle variance"		"5"
    "recoil magnitude"		"25"
    "recoil magnitude variance"		"4"
    "recoil seed"		"33244"
    "primary clip size"		"20"
    "weapon weight"		"5"
    "rumble effect"		"1"
    "inaccuracy crouch alt"		"6.830000"
    "inaccuracy fire alt"		"32.450001"
    "inaccuracy jump alt"		"89.699997"
    "inaccuracy ladder alt"		"138.000000"
    "inaccuracy land alt"		"0.190000"
    "inaccuracy move alt"		"13.410000"
    "inaccuracy stand alt"		"9.100000"
    "max player speed alt"		"240"
    "recoil angle alt"		"0"
    "recoil angle variance alt"		"5"
    "recoil magnitude alt"		"25"
    "recoil magnitude variance alt"		"4"
    "recovery time crouch final"		"0.500000"
    "recovery time stand final"		"0.500000"
    "spread alt"		"2.000000"
    "recovery transition start bullet"		"0"
    "recovery transition end bullet"		"5"
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
    "primary_ammo"		"BULLET_PLAYER_57MM"
    "sound_single_shot"		"Weapon_FiveSeven_CSGO.Single"
    "sound_nearlyempty"		"Default.nearlyempty"
}]=]
