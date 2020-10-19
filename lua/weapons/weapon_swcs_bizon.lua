SWEP.Base = "weapon_swcs_base"
SWEP.Category = "Counter-Strike: Global Offensive"

SWEP.PrintName = "PP-Bizon"
SWEP.Spawnable = true
SWEP.HoldType = "ar2"
SWEP.WorldModel = Model"models/weapons/csgo/w_smg_bizon_dropped.mdl"
SWEP.WorldModelPlayer = Model"models/weapons/csgo/w_smg_bizon.mdl"
SWEP.ViewModel = Model"models/weapons/csgo/v_smg_bizon.mdl"

sound.Add({
	name = "Weapon_bizon_CSGO.Single",
	channel = CHAN_STATIC,
	level = 79,
	volume = 0.8,
	sound = {Sound")weapons/csgo/bizon/bizon_01.wav", Sound")weapons/csgo/bizon/bizon_02.wav"}
})
sound.Add({
	name = "Weapon_bizon_CSGO.Clipout",
	channel = CHAN_ITEM,
	level = 65,
	sound = Sound"weapons/csgo/bizon/bizon_clipout.wav"
})
sound.Add({
	name = "Weapon_bizon_CSGO.Clipin",
	channel = CHAN_ITEM,
	level = 65,
	sound = Sound"weapons/csgo/bizon/bizon_clipin.wav"
})
sound.Add({
	name = "Weapon_bizon_CSGO.Draw",
	channel = CHAN_STATIC,
	level = 65,
	volume = 0.3,
	sound = Sound"weapons/csgo/bizon/bizon_draw.wav"
})
sound.Add({
	name = "Weapon_bizon_CSGO.boltBack",
	channel = CHAN_STATIC,
	volume = 0.9,
	pitch = {98, 102},
	level = 60,
	sound = Sound"weapons/csgo/bizon/bizon_boltback.wav"
})
sound.Add({
	name = "Weapon_bizon_CSGO.boltForward",
	channel = CHAN_STATIC,
	volume = 0.9,
	pitch = {98, 102},
	level = 60,
	sound = Sound"weapons/csgo/bizon/bizon_boltforward.wav"
})
sound.Add({
	name = "Weapon_bizon_CSGO.WeaponMove1",
	channel = CHAN_ITEM,
	level = 65,
	volume = 0.25,
	sound = Sound"weapons/csgo/movement1.wav"
})
sound.Add({
	name = "Weapon_bizon_CSGO.WeaponMove2",
	channel = CHAN_ITEM,
	level = 65,
	volume = 0.25,
	sound = Sound"weapons/csgo/movement2.wav"
})
sound.Add({
	name = "Weapon_bizon_CSGO.WeaponMove3",
	channel = CHAN_ITEM,
	level = 65,
	volume = 0.25,
	sound = Sound"weapons/csgo/movement3.wav"
})
sound.Add({
	name = "Weapon_bizon_CSGO.WeaponMove1",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement1.wav"
})
sound.Add({
	name = "Weapon_bizon_CSGO.WeaponMove2",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement2.wav"
})
sound.Add({
	name = "Weapon_bizon_CSGO.WeaponMove3",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement3.wav"
})

SWEP.ItemDefAttributes = [=["attributes 07/17/2020"
{
    "magazine model"		"models/weapons/w_smg_bizon_mag.mdl"
    "primary reserve ammo max"		"120"
    "inaccuracy jump initial"		"45.900002"
    "inaccuracy jump"		"33.470001"
    "heat per shot"		"0.300000"
    "tracer frequency"		"3"
    "max player speed"		"240"
    "is full auto"		"1"
    "in game price"		"1400"
    "kill award"		"600"
    "armor ratio"		"1.260000"
    "crosshair min distance"		"7"
    "penetration"		"1"
    "damage"		"27"
    "range"		"3600"
    "range modifier"		"0.800000"
    "cycletime"		"0.080000"
    "time to idle"		"2"
    "flinch velocity modifier large"		"0.000000"
    "flinch velocity modifier small"		"0.000000"
    "spread"		"1"
    "inaccuracy crouch"		"10.500000"
    "inaccuracy stand"		"14.000000"
    "inaccuracy land"		"0.080000"
    "inaccuracy ladder"		"169.649994"
    "inaccuracy fire"		"2.880000"
    "inaccuracy move"		"27.570000"
    "recovery time crouch"		"0.236837"
    "recovery time stand"		"0.331572"
    "recoil angle"		"0"
    "recoil angle variance"		"70"
    "recoil magnitude"		"18"
    "recoil magnitude variance"		"1"
    "recoil seed"		"36387"
    "primary clip size"		"64"
    "rumble effect"		"3"
    "weapon weight"		"26"
    "inaccuracy crouch alt"		"10.500000"
    "inaccuracy fire alt"		"2.880000"
    "inaccuracy jump alt"		"33.470001"
    "inaccuracy ladder alt"		"169.649994"
    "inaccuracy land alt"		"0.080000"
    "inaccuracy move alt"		"27.570000"
    "inaccuracy stand alt"		"14.000000"
    "max player speed alt"		"240"
    "recoil angle alt"		"0"
    "recoil angle variance alt"		"70"
    "recoil magnitude alt"		"18"
    "recoil magnitude variance alt"		"1"
    "recovery time crouch final"		"0.236837"
    "recovery time stand final"		"0.331572"
    "spread alt"		"1"
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
    "player_animation_extension"		"bizon"
    "primary_ammo"		"BULLET_PLAYER_9MM"
    "sound_single_shot"		"Weapon_bizon_CSGO.Single"
    "sound_nearlyempty"		"Default.nearlyempty"
}]=]
