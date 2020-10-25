SWEP.Base = "weapon_swcs_base"
SWEP.Category = "Counter-Strike: Global Offensive"

SWEP.PrintName = "SSG 08"
SWEP.Spawnable = true
SWEP.HoldType = "ar2"
SWEP.WorldModel = Model"models/weapons/csgo/w_snip_ssg08_dropped.mdl"
SWEP.WorldModelPlayer = Model"models/weapons/csgo/w_snip_ssg08.mdl"
SWEP.ViewModel = Model"models/weapons/csgo/v_snip_ssg08.mdl"

sound.Add({
	name = "Weapon_SSG08_CSGO.Single",
	channel = CHAN_STATIC,
	level = 79,
	volume = 0.8,
	pitch = 100,
	sound = Sound")weapons/csgo/ssg08/ssg08_01.wav"
})
sound.Add({
	name = "Weapon_SSG08_CSGO.Draw",
	channel = CHAN_STATIC,
	level = 65,
	volume = 0.3,
	sound = Sound"weapons/csgo/ssg08/ssg08_draw.wav"
})
sound.Add({
	name = "Weapon_SSG08_CSGO.Clipout",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.5, 1},
	pitch = {97, 105},
	sound = Sound"weapons/csgo/ssg08/ssg08_clipout.wav"
})
sound.Add({
	name = "Weapon_SSG08_CSGO.Clipin",
	channel = CHAN_ITEM,
	level = 60,
	volume = {0.5, 1},
	pitch = {97, 105},
	sound = Sound"weapons/csgo/ssg08/ssg08_clipin.wav"
})
sound.Add({
	name = "Weapon_SSG08_CSGO.Cliphit",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.5, 1},
	pitch = {97, 105},
	sound = Sound"weapons/csgo/ssg08/ssg08_cliphit.wav"
})
sound.Add({
	name = "Weapon_SSG08_CSGO.Boltback",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.5, 1},
	pitch = {97, 105},
	sound = Sound"weapons/csgo/ssg08/ssg08_boltback.wav"
})
sound.Add({
	name = "Weapon_SSG08_CSGO.Boltforward",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.5, 1},
	pitch = {97, 105},
	sound = Sound"weapons/csgo/ssg08/ssg08_boltforward.wav"
})
sound.Add({
	name = "Weapon_SSG08_CSGO.WeaponMove1",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement3.wav"
})
sound.Add({
	name = "Weapon_SSG08_CSGO.WeaponMove2",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement2.wav"
})
sound.Add({
	name = "Weapon_SSG08_CSGO.WeaponMove3",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement3.wav"
})
sound.Add({
	name = "Weapon_SSG08_CSGO.Zoom",
	channel = CHAN_ITEM,
	sound = Sound"weapons/csgo/scar20/zoom.wav"
})

SWEP.ItemDefAttributes = [=["attributes 07/17/2020"
{
    "magazine model"		"models/weapons/w_snip_ssg08_mag.mdl"
    "unzoom after shot"		"1"
    "primary reserve ammo max"		"90"
    "inaccuracy jump initial"		"208.720001"
    "inaccuracy jump"		"5.720000"
    "inaccuracy jump alt"		"5.720000"
    "heat per shot"		"0.500000"
    "addon scale"		"0.900000"
    "max player speed"		"230"
    "max player speed alt"		"230"
    "in game price"		"1700"
    "armor ratio"		"1.700000"
    "crosshair min distance"		"5"
    "zoom levels"		"2"
    "zoom time 0"		"0.050000"
    "zoom fov 1"		"40"
    "zoom time 1"		"0.050000"
    "zoom fov 2"		"15"
    "zoom time 2"		"0.050000"
    "hide view model zoomed"		"1"
    "penetration"		"2.500000"
    "damage"		"88"
    "range"		"8192"
    "cycletime"		"1.250000"
    "time to idle"		"1.800000"
    "idle interval"		"60"
    "flinch velocity modifier large"		"0.350000"
    "flinch velocity modifier small"		"0.400000"
    "spread"		"0.280000"
    "inaccuracy crouch"		"23.780001"
    "inaccuracy stand"		"31.700001"
    "inaccuracy land"		"0.215000"
    "inaccuracy ladder"		"95.489998"
    "inaccuracy fire"		"22.920000"
    "inaccuracy move"		"123.449997"
    "spread alt"		"0.230000"
    "inaccuracy crouch alt"		"2.800000"
    "inaccuracy stand alt"		"3.000000"
    "inaccuracy land alt"		"0.215000"
    "inaccuracy ladder alt"		"95.489998"
    "inaccuracy fire alt"		"22.920000"
    "inaccuracy move alt"		"123.449997"
    "recovery time crouch"		"0.055783"
    "recovery time stand"		"0.142096"
    "recoil angle"		"0"
    "recoil angle variance"		"20"
    "recoil magnitude"		"33"
    "recoil magnitude variance"		"15"
    "recoil seed"		"1278"
    "primary clip size"		"10"
    "weapon weight"		"30"
    "rumble effect"		"4"
    "recoil angle alt"		"0"
    "recoil angle variance alt"		"20"
    "recoil magnitude alt"		"25"
    "recoil magnitude variance alt"		"2"
    "recovery time crouch final"		"0.055783"
    "recovery time stand final"		"0.142096"
}]=]
SWEP.ItemDefVisuals = [=["visuals 07/17/2020"
{
    "muzzle_flash_effect_1st_person"		"weapon_muzzle_flash_huntingrifle_FP"
    "muzzle_flash_effect_3rd_person"		"weapon_muzzle_flash_huntingrifle"
    "heat_effect"		"weapon_muzzle_smoke"
    "addon_location"		"primary_sniper"
    "eject_brass_effect"		"weapon_shell_casing_rifle"
    "tracer_effect"		"weapon_tracers_assrifle"
    "weapon_type"		"SniperRifle"
    "player_animation_extension"		"ssg08"
    "primary_ammo"		"BULLET_PLAYER_762MM"
    "sound_single_shot"		"Weapon_SSG08_CSGO.Single"
    "sound_nearlyempty"		"Default.nearlyempty"
}]=]
SWEP.ItemDefPrefab = [=["prefab 08/11/2020"
{
    "zoom_in_sound"		"Weapon_SSG08_CSGO.Zoom"
    "zoom_out_sound"		"Weapon_SSG08_CSGO.Zoom"
}]=]
