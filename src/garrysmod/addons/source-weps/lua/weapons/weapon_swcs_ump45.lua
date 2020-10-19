SWEP.Base = "weapon_swcs_base"
SWEP.Category = "Counter-Strike: Global Offensive"

SWEP.PrintName = "UMP-45"
SWEP.Spawnable = true
SWEP.HoldType = "smg"
SWEP.WorldModel = Model"models/weapons/csgo/w_smg_ump45_dropped.mdl"
SWEP.WorldModelPlayer = Model"models/weapons/csgo/w_smg_ump45.mdl"
SWEP.ViewModel = Model"models/weapons/csgo/v_smg_ump45.mdl"

sound.Add({
	name = "Weapon_UMP45_CSGO.Single",
	channel = CHAN_STATIC,
	level = 79,
	volume = 0.75,
	sound = Sound")weapons/csgo/ump45/ump45_02.wav"
})
sound.Add({
	name = "Weapon_UMP45_CSGO.Clipout",
	channel = CHAN_ITEM,
	level = 65,
	sound = Sound"weapons/csgo/ump45/ump45_clipout.wav"
})
sound.Add({
	name = "Weapon_UMP45_CSGO.Clipin",
	channel = CHAN_ITEM,
	level = 65,
	sound = Sound"weapons/csgo/ump45/ump45_clipin.wav"
})
sound.Add({
	name = "Weapon_UMP45_CSGO.Draw",
	channel = CHAN_STATIC,
	level = 65,
	volume = 0.3,
	sound = Sound"weapons/csgo/ump45/ump45_draw.wav"
})
sound.Add({
	name = "Weapon_UMP45_CSGO.boltBack",
	channel = CHAN_ITEM,
	level = 65,
	sound = Sound"weapons/csgo/ump45/ump45_boltback.wav"
})
sound.Add({
	name = "Weapon_UMP45_CSGO.boltForward",
	channel = CHAN_ITEM,
	level = 65,
	sound = Sound"weapons/csgo/ump45/ump45_boltforward.wav"
})
sound.Add({
	name = "Weapon_UMP45_CSGO.WeaponMove1",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement1.wav"
})
sound.Add({
	name = "Weapon_UMP45_CSGO.WeaponMove2",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement2.wav"
})
sound.Add({
	name = "Weapon_UMP45_CSGO.WeaponMove3",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement3.wav"
})

SWEP.ItemDefAttributes = [=["attributes 07/17/2020"
{
    "magazine model"		"models/weapons/w_smg_ump45_mag.mdl"
    "primary reserve ammo max"		"100"
    "inaccuracy jump initial"		"47.209999"
    "inaccuracy jump"		"37.250000"
    "heat per shot"		"0.300000"
    "tracer frequency"		"3"
    "max player speed"		"230"
    "is full auto"		"1"
    "in game price"		"1200"
    "kill award"		"600"
    "armor ratio"		"1.300000"
    "crosshair min distance"		"6"
    "penetration"		"1"
    "damage"		"35"
    "range"		"3700"
    "range modifier"		"0.750000"
    "cycletime"		"0.090000"
    "time to idle"		"2"
    "flinch velocity modifier large"		"0.000000"
    "flinch velocity modifier small"		"0.000000"
    "spread"		"1.000000"
    "inaccuracy crouch"		"10.070000"
    "inaccuracy stand"		"13.430000"
    "inaccuracy land"		"0.085000"
    "inaccuracy ladder"		"42.349998"
    "inaccuracy fire"		"3.420000"
    "inaccuracy move"		"28.760000"
    "recovery time crouch"		"0.249995"
    "recovery time stand"		"0.349993"
    "recoil angle variance"		"40"
    "recoil magnitude"		"23"
    "recoil magnitude variance"		"1"
    "recoil seed"		"59299"
    "primary clip size"		"25"
    "weapon weight"		"25"
    "rumble effect"		"4"
    "inaccuracy crouch alt"		"10.070000"
    "inaccuracy fire alt"		"3.420000"
    "inaccuracy jump alt"		"37.250000"
    "inaccuracy ladder alt"		"42.349998"
    "inaccuracy land alt"		"0.085000"
    "inaccuracy move alt"		"28.760000"
    "inaccuracy stand alt"		"13.430000"
    "max player speed alt"		"230"
    "recoil angle variance alt"		"40"
    "recoil magnitude alt"		"23"
    "recoil magnitude variance alt"		"1"
    "recovery time crouch final"		"0.249995"
    "recovery time stand final"		"0.349993"
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
    "player_animation_extension"		"ump45"
    "primary_ammo"		"BULLET_PLAYER_45ACP"
    "sound_single_shot"		"Weapon_UMP45_CSGO.Single"
    "sound_nearlyempty"		"Default.nearlyempty"
}]=]
