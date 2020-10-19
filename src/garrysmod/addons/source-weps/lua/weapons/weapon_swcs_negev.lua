SWEP.Base = "weapon_swcs_base"
SWEP.Category = "Counter-Strike: Global Offensive"

SWEP.IsNegev = true

SWEP.PrintName = "Negev"
SWEP.Spawnable = true
SWEP.HoldType = "crossbow"
SWEP.WorldModel = Model"models/weapons/csgo/w_mach_negev_dropped.mdl"
SWEP.WorldModelPlayer = Model"models/weapons/csgo/w_mach_negev.mdl"
SWEP.ViewModel = Model"models/weapons/csgo/v_mach_negev.mdl"

sound.Add({
	name = "Weapon_Negev_CSGO.Single",
	channel = CHAN_STATIC,
	level = 93,
	volume = 1,
	sound = {Sound")weapons/csgo/negev/negev_01.wav",Sound")weapons/csgo/negev/negev_02.wav"}
})
sound.Add({
	name = "Weapon_Negev_CSGO.SingleFocused",
	channel = CHAN_STATIC,
	level = 79,
	volume = 1,
	sound = {Sound")weapons/csgo/negev/negev_clean_01.wav", Sound")weapons/csgo/negev/negev_clean_02.wav"}
})
sound.Add({
	name = "Weapon_Negev_CSGO.Draw",
	channel = CHAN_ITEM,
	level = 75,
	volume = 0.5,
	sound = Sound"weapons/csgo/negev/negev_draw.wav"
})
sound.Add({
	name = "Weapon_Negev_CSGO.Pump",
	channel = CHAN_ITEM,
	level = 65,
	sound = Sound"weapons/csgo/negev/negev_pump.wav"
})
sound.Add({
	name = "Weapon_Negev_CSGO.Coverup",
	channel = CHAN_ITEM,
	level = 65,
	sound = Sound"weapons/csgo/negev/negev_coverup.wav"
})
sound.Add({
	name = "Weapon_Negev_CSGO.Coverdown",
	channel = CHAN_ITEM,
	level = 65,
	sound = Sound"weapons/csgo/negev/negev_coverdown.wav"
})
sound.Add({
	name = "Weapon_Negev_CSGO.Boxout",
	channel = CHAN_ITEM,
	level = 65,
	sound = Sound"weapons/csgo/negev/negev_boxout.wav"
})
sound.Add({
	name = "Weapon_Negev_CSGO.Boxin",
	channel = CHAN_ITEM,
	level = 65,
	sound = Sound"weapons/csgo/negev/negev_boxin.wav"
})
sound.Add({
	name = "Weapon_Negev_CSGO.Chain",
	channel = CHAN_ITEM,
	level = 65,
	sound = Sound"weapons/csgo/negev/negev_chain.wav"
})
sound.Add({
	name = "Weapon_Negev_CSGO.WeaponMove1",
	channel = CHAN_ITEM,
	level = 65,
	volume = 0.25,
	sound = Sound"weapons/csgo/movement1.wav"
})
sound.Add({
	name = "Weapon_Negev_CSGO.WeaponMove2",
	channel = CHAN_ITEM,
	level = 65,
	volume = 0.25,
	sound = Sound"weapons/csgo/movement2.wav"
})
sound.Add({
	name = "Weapon_Negev_CSGO.WeaponMove3",
	channel = CHAN_ITEM,
	level = 65,
	volume = 0.25,
	sound = Sound"weapons/csgo/movement3.wav"
})

SWEP.ItemDefAttributes = [=["attributes 07/02/2020"
{
    "primary reserve ammo max"		"300"
    "attack movespeed factor"		"0.500000"
    "inaccuracy jump initial"		"116.290001"
    "inaccuracy jump"		"292.230011"
    "heat per shot"		"0.350000"
    "addon scale"		"0.900000"
    "tracer frequency"		"1"
    "max player speed"		"150"
    "is full auto"		"1"
    "in game price"		"1700"
    "armor ratio"		"1.420000"
    "crosshair min distance"		"6"
    "penetration"		"2"
    "damage"		"35"
    "range"		"8192"
    "range modifier"		"0.970000"
    "cycletime"		"0.075000"
    "time to idle"		"1.600000"
    "flinch velocity modifier large"		"0.400000"
    "flinch velocity modifier small"		"0.550000"
    "spread"		"2"
    "inaccuracy crouch"		"7.630000"
    "inaccuracy stand"		"10.170000"
    "inaccuracy land"		"0.409000"
    "inaccuracy ladder"		"136.429993"
    "inaccuracy fire"		"30.000000"
    "inaccuracy move"		"159.139999"
    "recovery time crouch"		"0.250000"
    "recovery time stand"		"0.300000"
    "recovery time crouch final"		"0.080000"
    "recovery time stand final"		"0.100000"
    "recoil angle"		"0"
    "recoil angle variance"		"0"
    "recoil magnitude"		"20"
    "recoil magnitude variance"		"2"
    "recoil seed"		"57966"
    "primary clip size"		"150"
    "weapon weight"		"25"
    "rumble effect"		"2"
    "inaccuracy crouch alt"		"7.630000"
    "inaccuracy fire alt"		"3.370000"
    "inaccuracy jump alt"		"292.230011"
    "inaccuracy ladder alt"		"136.429993"
    "inaccuracy land alt"		"0.409000"
    "inaccuracy move alt"		"159.139999"
    "inaccuracy stand alt"		"10.170000"
    "inaccuracy pitch shift"		"-50.000000"
    "inaccuracy alt sound threshold"		"0.020000"
    "max player speed alt"		"150"
    "recoil angle alt"		"0"
    "recoil angle variance alt"		"0"
    "recoil magnitude alt"		"20"
    "recoil magnitude variance alt"		"2"
    "spread alt"		"2"
    "recovery transition start bullet"		"9"
    "recovery transition end bullet"		"12"
}]=]
SWEP.ItemDefVisuals = [=["visuals 07/07/2020"
{
    "muzzle_flash_effect_1st_person"		"weapon_muzzle_flash_para_FP"
    "muzzle_flash_effect_3rd_person"		"weapon_muzzle_flash_para"
    "heat_effect"		"weapon_muzzle_smoke"
    "addon_location"		"primary_mg"
    "eject_brass_effect"		"weapon_shell_casing_rifle"
    "tracer_effect"		"weapon_tracers_mach"
    "weapon_type"		"Machinegun"
    "player_animation_extension"		"negev"
    "primary_ammo"		"BULLET_PLAYER_556MM_BOX"
    "sound_single_shot"		"Weapon_Negev_CSGO.Single"
    "sound_single_shot_accurate"		"Weapon_Negev_CSGO.SingleFocused"
    "sound_nearlyempty"		"Default.nearlyempty"
}]=]
