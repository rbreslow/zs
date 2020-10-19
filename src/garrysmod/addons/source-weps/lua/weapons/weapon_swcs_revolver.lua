SWEP.Base = "weapon_swcs_base"
SWEP.Category = "Counter-Strike: Global Offensive"

SWEP.IsR8Revolver = true

SWEP.PrintName = "R8 Revolver"
SWEP.Spawnable = true
SWEP.HoldType = "revolver"
SWEP.WorldModel = Model"models/weapons/csgo/w_pist_revolver_dropped.mdl"
SWEP.WorldModelPlayer = Model"models/weapons/csgo/w_pist_revolver.mdl"
SWEP.ViewModel = Model"models/weapons/csgo/v_pist_revolver.mdl"

sound.Add({
	name = "Weapon_Revolver_CSGO.Single",
	channel = CHAN_STATIC,
	level = 79,
	sound = Sound")weapons/csgo/revolver/revolver-1_01.wav"
})
sound.Add({
	name = "Weapon_Revolver_CSGO.Prepare",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.9, 1.0},
	sound = Sound"weapons/csgo/revolver/revolver_prepare.wav"
})
sound.Add({
	name = "Weapon_Revolver_CSGO.Draw",
	channel = CHAN_STATIC,
	level = 65,
	volume = 0.3,
	pitch = {97, 105},
	sound = Sound"weapons/csgo/revolver/revolver_draw.wav"
})
sound.Add({
	name = "Weapon_Revolver_CSGO.Clipout",
	channel = CHAN_ITEM,
	level = 65,
	pitch = {97, 105},
	volume = {0.5, 1.0},
	sound = Sound"weapons/csgo/revolver/revolver_clipout.wav"
})
sound.Add({
	name = "Weapon_Revolver_CSGO.Clipin",
	channel = CHAN_ITEM,
	level = 65,
	pitch = {97, 105},
	volume = {0.5, 1.0},
	sound = Sound"weapons/csgo/revolver/revolver_clipin.wav"
})
sound.Add({
	name = "Weapon_Revolver_CSGO.Sideback",
	channel = CHAN_ITEM,
	level = 65,
	pitch = {97, 105},
	volume = {0.5, 1.0},
	sound = Sound"weapons/csgo/revolver/revolver_sideback.wav"
})
sound.Add({
	name = "Weapon_Revolver_CSGO.Siderelease",
	channel = CHAN_ITEM,
	level = 65,
	pitch = {97, 105},
	volume = {0.5, 1.0},
	sound = Sound"weapons/csgo/revolver/revolver_siderelease.wav"
})
sound.Add({
	name = "Weapon_Revolver_CSGO.BarrelRoll",
	channel = CHAN_ITEM,
	level = 65,
	pitch = 120,
	volume = 0.2,
	sound = Sound"weapons/csgo/revolver/revolver_prepare.wav"
})

SWEP.ItemDefAttributes = [=["attributes 07/07/2020"
{
    "icon display model"		"models/weapons/w_pist_revolver_icon.mdl"
    "is revolver"		"1"
    "is full auto"		"1"
    "in game price"		"600"
    "primary clip size"		"8"
    "primary reserve ammo max"		"8"
    "crosshair min distance"		"4"
    "crosshair delta distance"		"3"
    "penetration"		"2"
    "damage"		"86"
    "range modifier"		"0.940000"
    "bullets"		"1"
    "time to idle"		"1.500000"
    "idle interval"		"60"
    "flinch velocity modifier large"		"0.400000"
    "flinch velocity modifier small"		"0.400000"
    "spread"		"0.520000"
    "inaccuracy crouch"		"1.000000"
    "inaccuracy stand"		"2.000000"
    "inaccuracy jump initial"		"18.650000"
    "inaccuracy jump"		"53.230000"
    "inaccuracy land"		"0.130000"
    "inaccuracy ladder"		"12.000000"
    "inaccuracy fire"		"50.000000"
    "inaccuracy move"		"6.500000"
    "max player speed"		"180"
    "cycletime"		"0.500000"
    "spread alt"		"68.000000"
    "inaccuracy crouch alt"		"5.000000"
    "inaccuracy stand alt"		"12.000000"
    "inaccuracy jump alt"		"53.230000"
    "inaccuracy land alt"		"0.150000"
    "inaccuracy ladder alt"		"35.000000"
    "inaccuracy fire alt"		"55.000000"
    "inaccuracy move alt"		"36.000000"
    "max player speed alt"		"220"
    "cycletime alt"		"0.400000"
    "recovery time crouch"		"0.700000"
    "recovery time stand"		"0.900000"
    "recoil seed"		"12345"
    "recoil angle"		"0"
    "recoil angle variance"		"40"
    "recoil magnitude"		"20"
    "recoil magnitude variance"		"0"
    "recoil angle alt"		"3"
    "recoil angle variance alt"		"50"
    "recoil magnitude alt"		"45"
    "recoil magnitude variance alt"		"6"
    "tracer frequency alt"		"1"
    "tracer frequency"		"1"
    "armor ratio"		"1.864000"
    "range"		"4096"
    "weapon weight"		"7"
    "rumble effect"		"2"
    "recovery time crouch final"		"0.449927"
    "recovery time stand final"		"0.811200"
}]=]
SWEP.ItemDefVisuals = [=["visuals 07/07/2020"
{
    "sound_single_shot"		"Weapon_Revolver_CSGO.Single"
    "muzzle_flash_effect_1st_person"		"weapon_muzzle_flash_assaultrifle"
    "muzzle_flash_effect_3rd_person"		"weapon_muzzle_flash_assaultrifle"
    "heat_effect"		"weapon_muzzle_smoke"
    "eject_brass_effect"		"weapon_shell_casing_9mm"
    "tracer_effect"		"weapon_tracers_pistol"
    "weapon_type"		"Pistol"
    "player_animation_extension"		"pistol"
    "primary_ammo"		"BULLET_PLAYER_50AE"
    "sound_nearlyempty"		"Default.nearlyempty"
}]=]
