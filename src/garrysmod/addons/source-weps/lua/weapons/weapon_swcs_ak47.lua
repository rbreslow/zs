SWEP.Base = "weapon_swcs_base"
SWEP.Category = "Counter-Strike: Global Offensive"

SWEP.PrintName = "AK-47"
SWEP.Spawnable = true
SWEP.HoldType = "ar2"
SWEP.WorldModel = Model"models/weapons/csgo/w_rif_ak47_dropped.mdl"
SWEP.WorldModelPlayer = Model"models/weapons/csgo/w_rif_ak47.mdl"
SWEP.ViewModel = Model"models/weapons/csgo/v_rif_ak47.mdl"

sound.Add({
	name = "Weapon_AK47_CSGO.Single",
	channel = CHAN_STATIC,
	level = 79,
	volume = 0.9,
	pitch = 100,
	sound = Sound")weapons/csgo/ak47/ak47_01.wav"
})
sound.Add({
	name = "Weapon_AK47_CSGO.Draw",
	channel = CHAN_ITEM,
	level = 65,
	volume = 0.5,
	sound = Sound"weapons/csgo/ak47/ak47_draw.wav"
})
sound.Add({
	name = "Weapon_AK47_CSGO.BoltPull",
	channel = CHAN_ITEM,
	level = 65,
	volume = { 0.5, 1 },
	pitch = { 100, 105 },
	sound = Sound"weapons/csgo/ak47/ak47_boltpull.wav"
})
sound.Add({
	name = "Weapon_AK47_CSGO.Clipin",
	channel = CHAN_ITEM,
	level = 65,
	volume = { 0.5, 1 },
	pitch = { 100, 105 },
	sound = Sound"weapons/csgo/ak47/ak47_clipin.wav"
})
sound.Add({
	name = "Weapon_AK47_CSGO.Clipout",
	channel = CHAN_ITEM,
	level = 65,
	volume = { 0.5, 1 },
	pitch = { 100, 105 },
	sound = Sound"weapons/csgo/ak47/ak47_clipout.wav"
})
sound.Add({
	name = "Weapon_AK47_CSGO.WeaponMove1",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement3.wav"
})
sound.Add({
	name = "Weapon_AK47_CSGO.WeaponMove2",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement2.wav"
})
sound.Add({
	name = "Weapon_AK47_CSGO.WeaponMove3",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement3.wav"
})

SWEP.ItemDefAttributes = [=["attributes 04/22/2020"
{
    "magazine model"		"models/weapons/w_rif_ak47_mag.mdl"
    "primary reserve ammo max"		"90"
    "recovery time crouch"		"0.305257"
    "recovery time crouch final"		"0.419728"
    "recovery time stand"		"0.368000"
    "recovery time stand final"		"0.506000"
    "inaccuracy jump initial"		"100.940002"
    "inaccuracy jump"		"140.759995"
    "heat per shot"		"0.300000"
    "addon scale"		"0.900000"
    "tracer frequency"		"3"
    "max player speed"		"215"
    "is full auto"		"1"
    "in game price"		"2700"
    "armor ratio"		"1.550000"
    "crosshair delta distance"		"4"
    "penetration"		"2"
    "damage"		"36"
    "range"		"8192"
    "cycletime"		"0.100000"
    "time to idle"		"1.900000"
    "flinch velocity modifier large"		"0.400000"
    "flinch velocity modifier small"		"0.550000"
    "spread"		"0.600000"
    "inaccuracy crouch"		"4.810000"
    "inaccuracy stand"		"6.410000"
    "inaccuracy land"		"0.242000"
    "inaccuracy ladder"		"140.000000"
    "inaccuracy fire"		"7.800000"
    "inaccuracy move"		"175.059998"
    "recoil angle"		"0"
    "recoil angle variance"		"70"
    "recoil magnitude"		"30"
    "recoil magnitude variance"		"0"
    "recoil seed"		"223"
    "primary clip size"		"30"
    "weapon weight"		"25"
    "rumble effect"		"4"
    "inaccuracy crouch alt"		"4.810000"
    "inaccuracy fire alt"		"7.800000"
    "inaccuracy jump alt"		"140.759995"
    "inaccuracy ladder alt"		"140.000000"
    "inaccuracy land alt"		"0.242000"
    "inaccuracy move alt"		"175.059998"
    "inaccuracy stand alt"		"6.410000"
    "max player speed alt"		"215"
    "recoil angle alt"		"0"
    "recoil angle variance alt"		"70"
    "recoil magnitude alt"		"30"
    "recoil magnitude variance alt"		"0"
    "spread alt"		"0.600000"
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
    "player_animation_extension"		"ak"
    "primary_ammo"		"BULLET_PLAYER_762MM"
    "sound_single_shot"		"Weapon_AK47_CSGO.Single"
    "sound_nearlyempty"		"Default.nearlyempty"
}]=]

