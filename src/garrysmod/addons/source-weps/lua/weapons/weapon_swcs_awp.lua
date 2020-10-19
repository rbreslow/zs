SWEP.Base = "weapon_swcs_base"
SWEP.Category = "Counter-Strike: Global Offensive"

SWEP.PrintName = "AWP"
SWEP.Spawnable = true
SWEP.HoldType = "ar2"
SWEP.WorldModel = Model"models/weapons/csgo/w_snip_awp_dropped.mdl"
SWEP.WorldModelPlayer = Model"models/weapons/csgo/w_snip_awp.mdl"
SWEP.ViewModel = Model"models/weapons/csgo/v_snip_awp.mdl"

sound.Add({
	name = "Weapon_AWP_CSGO.Single",
	channel = CHAN_STATIC,
	level = 79,
	volume = 1,
	pitch = 100,
	sound = {Sound")weapons/csgo/awp/awp_01.wav", Sound")weapons/csgo/awp/awp_02.wav"}
})
sound.Add({
	name = "Weapon_AWP_CSGO.Draw",
	channel = CHAN_STATIC,
	level = 65,
	volume = 0.3,
	sound = Sound"weapons/csgo/awp/awp_draw.wav"
})
sound.Add({
	name = "Weapon_AWP_CSGO.Clipout",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.5, 1},
	pitch = {97, 105},
	sound = Sound"weapons/csgo/awp/awp_clipout.wav"
})
sound.Add({
	name = "Weapon_AWP_CSGO.Clipin",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.5, 1},
	pitch = {97, 105},
	sound = Sound"weapons/csgo/awp/awp_clipin.wav"
})
sound.Add({
	name = "Weapon_AWP_CSGO.Cliphit",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.5, 1},
	pitch = {97, 105},
	sound = Sound"weapons/csgo/awp/awp_cliphit.wav"
})
sound.Add({
	name = "Weapon_AWP_CSGO.Boltback",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.5, 1},
	pitch = {97, 105},
	sound = Sound"weapons/csgo/awp/awp_boltback.wav"
})
sound.Add({
	name = "Weapon_AWP_CSGO.Boltforward",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.5, 1},
	pitch = {97, 105},
	sound = Sound"weapons/csgo/awp/awp_boltforward.wav"
})
sound.Add({
	name = "Weapon_AWP_CSGO.WeaponMove1",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement3.wav"
})
sound.Add({
	name = "Weapon_AWP_CSGO.WeaponMove2",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement2.wav"
})
sound.Add({
	name = "Weapon_AWP_CSGO.WeaponMove3",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement3.wav"
})
sound.Add({
	name = "Weapon_AWP_CSGO.Zoom",
	channel = CHAN_ITEM,
	sound = Sound"weapons/csgo/scar20/zoom.wav"
})

SWEP.ItemDefAttributes = [=["attributes 07/17/2020"
{
    "magazine model"		"models/weapons/w_snip_awp_mag.mdl"
    "unzoom after shot"		"1"
    "primary reserve ammo max"		"30"
    "inaccuracy jump initial"		"172.860001"
    "inaccuracy jump"		"133.830002"
    "inaccuracy jump alt"		"133.830002"
    "heat per shot"		"1.500000"
    "addon scale"		"0.900000"
    "max player speed"		"200"
    "max player speed alt"		"100"
    "in game price"		"4750"
    "kill award"		"100"
    "armor ratio"		"1.950000"
    "crosshair min distance"		"8"
    "zoom levels"		"2"
    "zoom time 0"		"0.050000"
    "zoom fov 1"		"40"
    "zoom time 1"		"0.050000"
    "zoom fov 2"		"10"
    "zoom time 2"		"0.050000"
    "hide view model zoomed"		"1"
    "penetration"		"2.500000"
    "damage"		"115"
    "range"		"8192"
    "range modifier"		"0.990000"
    "cycletime"		"1.455000"
    "time to idle"		"2"
    "idle interval"		"60"
    "flinch velocity modifier large"		"0.350000"
    "flinch velocity modifier small"		"0.400000"
    "inaccuracy reload"		"0"
    "spread"		"0.200000"
    "inaccuracy crouch"		"60.599998"
    "inaccuracy stand"		"80.800003"
    "inaccuracy land"		"0.307000"
    "inaccuracy ladder"		"136.500000"
    "inaccuracy fire"		"53.849998"
    "inaccuracy move"		"176.479996"
    "spread alt"		"0.200000"
    "inaccuracy crouch alt"		"1.500000"
    "inaccuracy stand alt"		"2.000000"
    "inaccuracy land alt"		"0.100000"
    "inaccuracy ladder alt"		"136.500000"
    "inaccuracy fire alt"		"53.849998"
    "inaccuracy move alt"		"176.479996"
    "recovery time crouch"		"0.246710"
    "recovery time stand"		"0.345390"
    "recoil angle"		"0"
    "recoil angle variance"		"20"
    "recoil magnitude"		"78"
    "recoil magnitude variance"		"15"
    "recoil seed"		"4100"
    "primary clip size"		"10"
    "weapon weight"		"30"
    "rumble effect"		"2"
    "recoil angle alt"		"0"
    "recoil angle variance alt"		"20"
    "recoil magnitude alt"		"25"
    "recoil magnitude variance alt"		"2"
    "recovery time crouch final"		"0.246710"
    "recovery time stand final"		"0.345390"
}]=]
SWEP.ItemDefVisuals = [=["visuals 07/17/2020"
{
    "muzzle_flash_effect_1st_person"		"weapon_muzzle_flash_awp"
    "muzzle_flash_effect_3rd_person"		"weapon_muzzle_flash_awp"
    "heat_effect"		"weapon_muzzle_smoke"
    "addon_location"		"primary_sniper"
    "eject_brass_effect"		"weapon_shell_casing_50cal"
    "tracer_effect"		"weapon_tracers_rifle"
    "weapon_type"		"SniperRifle"
    "player_animation_extension"		"awp"
    "primary_ammo"		"BULLET_PLAYER_338MAG"
    "sound_single_shot"		"Weapon_AWP_CSGO.Single"
    "sound_nearlyempty"		"Default.nearlyempty"
}]=]
SWEP.ItemDefPrefab = [=["prefab 08/11/2020"
{
    "zoom_in_sound"		"Weapon_AWP_CSGO.Zoom"
    "zoom_out_sound"		"Weapon_AWP_CSGO.Zoom"
}]=]
