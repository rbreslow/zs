SWEP.Base = "weapon_swcs_base"
SWEP.Category = "Counter-Strike: Global Offensive"

SWEP.is_sg556 = true

SWEP.PrintName = "SG 553"
SWEP.Spawnable = true
SWEP.HoldType = "ar2"
SWEP.WorldModel = Model"models/weapons/csgo/w_rif_sg556_dropped.mdl"
SWEP.WorldModelPlayer = Model"models/weapons/csgo/w_rif_sg556.mdl"
SWEP.ViewModel = Model"models/weapons/csgo/v_rif_sg556.mdl"

sound.Add({
	name = "Weapon_sg556_CSGO.Single",
	channel = CHAN_STATIC,
	level = 79,
	volume = 0.9,
	pitch = 100,
	sound = {Sound")weapons/csgo/sg556/sg556_01.wav", Sound")weapons/csgo/sg556/sg556_02.wav", Sound")weapons/csgo/sg556/sg556_03.wav", Sound")weapons/csgo/sg556/sg556_04.wav"}
})
sound.Add({
	name = "Weapon_sg556_CSGO.Draw",
	channel = CHAN_STATIC,
	level = 65,
	volume = 0.3,
	sound = Sound"weapons/csgo/sg556/sg556_draw.wav"
})
sound.Add({
	name = "Weapon_sg556_CSGO.BoltBack",
	channel = CHAN_ITEM,
	level = 65,
	volume = 1,
	pitch = 100,
	sound = Sound"weapons/csgo/sg556/sg556_boltback.wav"
})
sound.Add({
	name = "Weapon_sg556_CSGO.BoltForward",
	channel = CHAN_ITEM,
	level = 65,
	volume = 1,
	pitch = 100,
	sound = Sound"weapons/csgo/sg556/sg556_boltforward.wav"
})
sound.Add({
	name = "Weapon_sg556_CSGO.Clipin",
	channel = CHAN_ITEM,
	level = 65,
	volume = 1,
	pitch = 100,
	sound = Sound"weapons/csgo/sg556/sg556_clipin.wav"
})
sound.Add({
	name = "Weapon_sg556_CSGO.Clipout",
	channel = CHAN_ITEM,
	level = 65,
	volume = 1,
	pitch = 100,
	sound = Sound"weapons/csgo/sg556/sg556_clipout.wav"
})
sound.Add({
	name = "Weapon_sg556_CSGO.WeaponMove1",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement1.wav"
})
sound.Add({
	name = "Weapon_sg556_CSGO.WeaponMove2",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement2.wav"
})
sound.Add({
	name = "Weapon_sg556_CSGO.WeaponMove3",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement3.wav"
})
sound.Add({
	name = "Weapon_sg556_CSGO.ZoomIn",
	channel = CHAN_STATIC,
	level = 65,
	volume = 0.4,
	sound = Sound"weapons/csgo/sg556/sg556_zoom_in.wav"
})
sound.Add({
	name = "Weapon_sg556_CSGO.ZoomOut",
	channel = CHAN_STATIC,
	level = 65,
	volume = 0.6,
	sound = Sound"weapons/csgo/sg556/sg556_zoom_out.wav"
})

SWEP.ItemDefAttributes = [=["attributes 07/03/2020"
{
	"magazine model"		"models/weapons/w_rif_sg556_mag.mdl"
	"aimsight capable"		"1"
	"aimsight speed up"		"10.000000"
	"aimsight speed down"		"8.000000"
	"aimsight looseness"		"0.030000"
	"aimsight eye pos"		"0.72 -5.12 -1.33"
	"aimsight pivot angle"		"0.52 0.04 0.72"
	"aimsight fov"		"45"
	"aimsight pivot forward"		"8"
	"aimsight lens mask"		"models/weapons/v_rif_sg556_scopelensmask.mdl"
	"primary reserve ammo max"		"90"
	"tracer frequency alt"		"3"
	"inaccuracy jump initial"		"78.790001"
	"inaccuracy jump"		"109.000000"
	"inaccuracy jump alt"		"109.000000"
	"heat per shot"		"0.350000"
	"addon scale"		"0.900000"
	"tracer frequency"		"3"
	"max player speed"		"210"
	"max player speed alt"		"150"
	"is full auto"		"1"
	"in game price"		"3000"
	"armor ratio"		"2.000000"
	"crosshair min distance"		"5"
	"zoom levels"		"1"
	"zoom time 0"		"0.060000"
	"zoom fov 1"		"45"
	"zoom time 1"		"0.100000"
	"penetration"		"2"
	"damage"		"30"
	"range"		"8192"
	"cycletime"		"0.110000"
	"time to idle"		"2"
	"flinch velocity modifier large"		"0.400000"
	"flinch velocity modifier small"		"0.550000"
	"spread"		"0.600000"
	"inaccuracy crouch"		"3.810000"
	"inaccuracy stand"		"5.810000"
	"inaccuracy land"		"0.188000"
	"inaccuracy ladder"		"83.660004"
	"inaccuracy fire"		"7.950000"
	"inaccuracy move"		"136.009995"
	"spread alt"		"0.300000"
	"inaccuracy crouch alt"		"3.050000"
	"inaccuracy stand alt"		"3.810000"
	"inaccuracy land alt"		"0.188000"
	"inaccuracy ladder alt"		"138.757996"
	"inaccuracy fire alt"		"9.200000"
	"inaccuracy move alt"		"136.009995"
	"recovery time crouch"		"0.379204"
	"recovery time stand"		"0.452886"
	"recoil seed"		"43500"
	"recoil angle"		"0"
	"recoil angle variance"		"60"
	"recoil magnitude"		"28"
	"recoil magnitude variance"		"2"
	"recoil magnitude alt"		"19"
	"primary clip size"		"30"
	"weapon weight"		"25"
	"rumble effect"		"4"
	"recoil angle alt"		"0"
	"recoil angle variance alt"		"60"
	"recoil magnitude variance alt"		"2"
	"recovery time crouch final"		"0.379204"
	"recovery time stand final"		"0.452886"
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
	"player_animation_extension"		"sg556"
	"primary_ammo"		"BULLET_PLAYER_556MM"
	"sound_single_shot"		"Weapon_SG556_CSGO.Single"
	"sound_nearlyempty"		"Default.nearlyempty"
}]=]
SWEP.ItemDefPrefab = [=["prefab 08/11/2020" {
    "zoom_in_sound"		"Weapon_sg556_CSGO.ZoomIn"
	"zoom_out_sound"		"Weapon_sg556_CSGO.ZoomOut"
}]=]