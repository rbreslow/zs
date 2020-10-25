SWEP.Base = "weapon_swcs_base"
SWEP.Category = "Counter-Strike: Global Offensive"

SWEP.PrintName = "MAG-7"
SWEP.Spawnable = true
SWEP.HoldType = "shotgun"
SWEP.WorldModel = Model"models/weapons/csgo/w_shot_mag7_dropped.mdl"
SWEP.WorldModelPlayer = Model"models/weapons/csgo/w_shot_mag7.mdl"
SWEP.ViewModel = Model"models/weapons/csgo/v_shot_mag7.mdl"

sound.Add({
	name = "Weapon_Mag7_CSGO.Single",
	channel = CHAN_STATIC,
	volume = 0.9,
	level = 79,
	sound = {Sound")weapons/csgo/mag7/mag7_01.wav", Sound")weapons/csgo/mag7/mag7_02.wav"}
})
sound.Add({
	name = "Weapon_Mag7_CSGO.Clipin",
	channel = CHAN_STATIC,
	volume = 1,
	level = 65,
	pitch = {97, 105},
	sound = Sound"weapons/csgo/mag7/mag7_clipin.wav"
})
sound.Add({
	name = "Weapon_Mag7_CSGO.Clipout",
	channel = CHAN_STATIC,
	volume = 1,
	level = 65,
	pitch = {97, 105},
	sound = Sound"weapons/csgo/mag7/mag7_clipout.wav"
})
sound.Add({
	name = "Weapon_Mag7_CSGO.Draw",
	channel = CHAN_STATIC,
	volume = 0.3,
	level = 65,
	pitch = {97, 105},
	sound = Sound"weapons/csgo/mag7/mag7_draw.wav"
})
sound.Add({
	name = "Weapon_Mag7_CSGO.PumpForward",
	channel = CHAN_STATIC,
	volume = 0.4,
	level = 65,
	sound = Sound"weapons/csgo/mag7/mag7_pump_forward.wav"
})
sound.Add({
	name = "Weapon_Mag7_CSGO.PumpBack",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 65,
	pitch = 150,
	sound = Sound"weapons/csgo/mag7/mag7_pump_back.wav"
})

SWEP.ItemDefAttributes = [=["attributes 08/01/2020"
{
    "magazine model"		"models/weapons/w_shot_mag7_mag.mdl"
    "primary reserve ammo max"		"32"
    "is full auto"		"0"
    "inaccuracy jump initial"		"52.639999"
    "inaccuracy jump"		"50.090000"
    "heat per shot"		"1.500000"
    "addon scale"		"0.900000"
    "tracer frequency"		"1"
    "max player speed"		"225"
    "in game price"		"1300"
    "kill award"		"900"
    "armor ratio"		"1.500000"
    "crosshair min distance"		"9"
    "crosshair delta distance"		"4"
    "penetration"		"1"
    "damage"		"30"
    "range"		"1400"
    "range modifier"		"0.450000"
    "bullets"		"8"
    "cycletime"		"0.850000"
    "flinch velocity modifier large"		"0.400000"
    "flinch velocity modifier small"		"0.450000"
    "spread"		"40.000000"
    "inaccuracy crouch"		"5.250000"
    "inaccuracy stand"		"7.000000"
    "inaccuracy land"		"0.103000"
    "inaccuracy ladder"		"134.259995"
    "inaccuracy fire"		"11.190000"
    "inaccuracy move"		"15.990000"
    "recovery time crouch"		"0.285521"
    "recovery time stand"		"0.399729"
    "recoil angle variance"		"20"
    "recoil magnitude"		"165"
    "recoil magnitude variance"		"25"
    "recoil seed"		"12518"
    "spread seed"		"19899236"
    "primary clip size"		"5"
    "weapon weight"		"20"
    "rumble effect"		"5"
    "inaccuracy crouch alt"		"5.250000"
    "inaccuracy fire alt"		"11.190000"
    "inaccuracy jump alt"		"50.090000"
    "inaccuracy ladder alt"		"134.259995"
    "inaccuracy land alt"		"0.103000"
    "inaccuracy move alt"		"15.990000"
    "inaccuracy stand alt"		"7.000000"
    "max player speed alt"		"225"
    "recoil angle variance alt"		"20"
    "recoil magnitude alt"		"165"
    "recoil magnitude variance alt"		"25"
    "recovery time crouch final"		"0.285521"
    "recovery time stand final"		"0.399729"
    "spread alt"		"40.000000"
}]=]
SWEP.ItemDefVisuals = [=["visuals 08/01/2020"
{
    "muzzle_flash_effect_1st_person"		"weapon_muzzle_flash_autoshotgun"
    "muzzle_flash_effect_3rd_person"		"weapon_muzzle_flash_autoshotgun"
    "heat_effect"		"weapon_muzzle_smoke"
    "addon_location"		"primary_shotgun"
    "eject_brass_effect"		"weapon_shell_casing_shotgun"
    "tracer_effect"		"weapon_tracers_shot"
    "weapon_type"		"Shotgun"
    "player_animation_extension"		"mag7"
    "primary_ammo"		"BULLET_PLAYER_BUCKSHOT"
    "sound_single_shot"		"Weapon_Mag7_CSGO.Single"
    "sound_nearlyempty"		"Default.nearlyempty"
}]=]
