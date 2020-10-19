SWEP.Base = "weapon_swcs_base"
SWEP.Category = "Counter-Strike: Global Offensive"

SWEP.PrintName = "P90"
SWEP.Spawnable = true
SWEP.HoldType = "smg"
SWEP.WorldModel = Model"models/weapons/csgo/w_smg_p90_dropped.mdl"
SWEP.WorldModelPlayer = Model"models/weapons/csgo/w_smg_p90.mdl"
SWEP.ViewModel = Model"models/weapons/csgo/v_smg_p90.mdl"

sound.Add({
	name = "Weapon_P90_CSGO.Single",
	channel = CHAN_STATIC,
	level = 79,
	volume = 0.8,
	sound = {Sound")weapons/csgo/p90/p90_01.wav", Sound")weapons/csgo/p90/p90_02.wav"}
})
sound.Add({
	name = "Weapon_P90_CSGO.Cliprelease",
	channel = CHAN_ITEM,
	pitch = {98, 102},
	level = 65,
	sound = Sound"weapons/csgo/p90/p90_cliprelease.wav"
})
sound.Add({
	name = "Weapon_P90_CSGO.Clipout",
	channel = CHAN_ITEM,
	pitch = {98, 102},
	level = 65,
	sound = Sound"weapons/csgo/p90/p90_clipout.wav"
})
sound.Add({
	name = "Weapon_P90_CSGO.Clipin",
	channel = CHAN_ITEM,
	pitch = {98, 102},
	level = 65,
	sound = Sound"weapons/csgo/p90/p90_clipin.wav"
})
sound.Add({
	name = "Weapon_P90_CSGO.Draw",
	channel = CHAN_STATIC,
	level = 65,
	volume = 0.3,
	sound = Sound"weapons/csgo/p90/p90_draw.wav"
})
sound.Add({
	name = "Weapon_P90_CSGO.Cliphit",
	channel = CHAN_ITEM,
	pitch = {98, 102},
	level = 65,
	sound = Sound"weapons/csgo/p90/p90_cliphit.wav"
})
sound.Add({
	name = "Weapon_P90_CSGO.boltBack",
	channel = CHAN_ITEM,
	volume = 0.7,
	level = 65,
	sound = Sound"weapons/csgo/p90/p90_boltback.wav"
})
sound.Add({
	name = "Weapon_P90_CSGO.boltForward",
	channel = CHAN_ITEM,
	volume = 0.7,
	level = 65,
	sound = Sound"weapons/csgo/p90/p90_boltforward.wav"
})
sound.Add({
	name = "Weapon_P90_CSGO.WeaponMove1",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement1.wav"
})
sound.Add({
	name = "Weapon_P90_CSGO.WeaponMove2",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement2.wav"
})
sound.Add({
	name = "Weapon_P90_CSGO.WeaponMove3",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement3.wav"
})

SWEP.ItemDefAttributes = [=["attributes 07/17/2020"
{
    "magazine model"		"models/weapons/w_smg_p90_mag.mdl"
    "primary reserve ammo max"		"100"
    "inaccuracy jump initial"		"104.599998"
    "inaccuracy jump"		"90.080002"
    "heat per shot"		"0.350000"
    "tracer frequency"		"3"
    "max player speed"		"230"
    "is full auto"		"1"
    "in game price"		"2350"
    "armor ratio"		"1.380000"
    "crosshair min distance"		"7"
    "penetration"		"1"
    "damage"		"26"
    "range"		"3700"
    "range modifier"		"0.860000"
    "cycletime"		"0.070000"
    "time to idle"		"2"
    "flinch velocity modifier large"		"0.000000"
    "flinch velocity modifier small"		"0.000000"
    "spread"		"1.000000"
    "inaccuracy crouch"		"10.240000"
    "inaccuracy stand"		"13.650000"
    "inaccuracy land"		"0.082000"
    "inaccuracy ladder"		"132.169998"
    "inaccuracy fire"		"2.850000"
    "inaccuracy move"		"31"
    "recovery time crouch"		"0.265784"
    "recovery time stand"		"0.372098"
    "recoil angle"		"0"
    "recoil angle variance"		"70"
    "recoil magnitude"		"16"
    "recoil magnitude variance"		"1"
    "recoil seed"		"6213"
    "primary clip size"		"50"
    "weapon weight"		"26"
    "rumble effect"		"3"
    "inaccuracy crouch alt"		"10.240000"
    "inaccuracy fire alt"		"2.850000"
    "inaccuracy jump alt"		"90.080002"
    "inaccuracy ladder alt"		"132.169998"
    "inaccuracy land alt"		"0.082000"
    "inaccuracy move alt"		"31"
    "inaccuracy stand alt"		"13.650000"
    "max player speed alt"		"230"
    "recoil angle alt"		"0"
    "recoil angle variance alt"		"70"
    "recoil magnitude alt"		"16"
    "recoil magnitude variance alt"		"1"
    "recovery time crouch final"		"0.265784"
    "recovery time stand final"		"0.372098"
    "spread alt"		"1.000000"
}]=]
SWEP.ItemDefVisuals = [=["visuals 07/17/2020"
{
    "muzzle_flash_effect_1st_person"		"weapon_muzzle_flash_smg"
    "muzzle_flash_effect_3rd_person"		"weapon_muzzle_flash_smg"
    "heat_effect"		"weapon_muzzle_smoke"
    "addon_location"		"primary_smg"
    "eject_brass_effect"		"weapon_shell_casing_9mm"
    "tracer_effect"		"weapon_tracers_smg"
    "weapon_type"		"SubMachinegun"
    "player_animation_extension"		"p90"
    "primary_ammo"		"BULLET_PLAYER_57MM"
    "sound_single_shot"		"Weapon_P90_CSGO.Single"
    "sound_nearlyempty"		"Default.nearlyempty"
}]=]
