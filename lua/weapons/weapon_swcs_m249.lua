SWEP.Base = "weapon_swcs_base"
SWEP.Category = "Counter-Strike: Global Offensive"

SWEP.PrintName = "M249"
SWEP.Spawnable = true
SWEP.HoldType = "crossbow"
SWEP.WorldModel = Model"models/weapons/csgo/w_mach_m249_dropped.mdl"
SWEP.WorldModelPlayer = Model"models/weapons/csgo/w_mach_m249.mdl"
SWEP.ViewModel = Model"models/weapons/csgo/v_mach_m249para.mdl"

sound.Add({
	name = "Weapon_M249_CSGO.Single",
	channel = CHAN_STATIC,
	level = 93,
	volume = 1,
	pitch = {99, 101},
	sound = Sound")weapons/csgo/m249/m249-1.wav"
})
sound.Add({
	name = "Weapon_M249_CSGO.Draw",
	channel = CHAN_ITEM,
	level = 65,
	volume = 0.3,
	sound = Sound"weapons/csgo/m249/m249_draw.wav"
})
sound.Add({
	name = "Weapon_M249_CSGO.Pump",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.5, 1.0},
	pitch = {97, 105},
	sound = Sound"weapons/csgo/m249/m249_pump.wav"
})
sound.Add({
	name = "Weapon_M249_CSGO.Coverup",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.5, 1.0},
	pitch = {97, 105},
	sound = Sound"weapons/csgo/m249/m249_coverup.wav"
})
sound.Add({
	name = "Weapon_M249_CSGO.Coverdown",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.5, 1.0},
	pitch = {97, 105},
	sound = Sound"weapons/csgo/m249/m249_coverdown.wav"
})
sound.Add({
	name = "Weapon_M249_CSGO.Boxout",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.5, 1.0},
	pitch = {97, 105},
	sound = Sound"weapons/csgo/m249/m249_boxout.wav"
})
sound.Add({
	name = "Weapon_M249_CSGO.Boxin",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.5, 1.0},
	pitch = {97, 105},
	sound = Sound"weapons/csgo/m249/m249_boxin.wav"
})
sound.Add({
	name = "Weapon_M249_CSGO.Chain",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.5, 1.0},
	pitch = {97, 105},
	sound = Sound"weapons/csgo/m249/m249_chain.wav"
})
sound.Add({
	name = "Weapon_M249_CSGO.WeaponMove1",
	channel = CHAN_ITEM,
	level = 65,
	volume = 0.25,
	sound = Sound"weapons/csgo/movement1.wav"
})
sound.Add({
	name = "Weapon_M249_CSGO.WeaponMove2",
	channel = CHAN_ITEM,
	level = 65,
	volume = 0.25,
	sound = Sound"weapons/csgo/movement2.wav"
})
sound.Add({
	name = "Weapon_M249_CSGO.WeaponMove3",
	channel = CHAN_ITEM,
	level = 65,
	volume = 0.25,
	sound = Sound"weapons/csgo/movement3.wav"
})

SWEP.ItemDefAttributes = [=["attributes 07/19/2020"
{
    "primary reserve ammo max"		"200"
    "inaccuracy jump initial"		"118.269997"
    "inaccuracy jump"		"279.470001"
    "heat per shot"		"0.350000"
    "addon scale"		"0.900000"
    "tracer frequency"		"1"
    "max player speed"		"195"
    "is full auto"		"1"
    "in game price"		"5200"
    "armor ratio"		"1.600000"
    "crosshair min distance"		"6"
    "penetration"		"2"
    "damage"		"32"
    "range"		"8192"
    "range modifier"		"0.970000"
    "cycletime"		"0.080000"
    "time to idle"		"1.600000"
    "flinch velocity modifier large"		"0.400000"
    "flinch velocity modifier small"		"0.550000"
    "spread"		"2.000000"
    "inaccuracy crouch"		"5.340000"
    "inaccuracy stand"		"7.700000"
    "inaccuracy land"		"0.398000"
    "inaccuracy ladder"		"132.809998"
    "inaccuracy fire"		"3.560000"
    "inaccuracy move"		"156.250000"
    "recovery time crouch"		"0.592093"
    "recovery time stand"		"0.828931"
    "recoil angle"		"0"
    "recoil angle variance"		"50"
    "recoil magnitude"		"25"
    "recoil magnitude variance"		"2"
    "recoil seed"		"50310"
    "primary clip size"		"100"
    "weapon weight"		"25"
    "rumble effect"		"2"
    "inaccuracy crouch alt"		"5.340000"
    "inaccuracy fire alt"		"3.560000"
    "inaccuracy jump alt"		"279.470001"
    "inaccuracy ladder alt"		"132.809998"
    "inaccuracy land alt"		"0.398000"
    "inaccuracy move alt"		"156.250000"
    "inaccuracy stand alt"		"7.700000"
    "max player speed alt"		"195"
    "recoil angle alt"		"0"
    "recoil angle variance alt"		"50"
    "recoil magnitude alt"		"25"
    "recoil magnitude variance alt"		"2"
    "recovery time crouch final"		"0.592093"
    "recovery time stand final"		"0.828931"
    "spread alt"		"2.000000"
}]=]
SWEP.ItemDefVisuals = [=["visuals 07/19/2020"
{
    "muzzle_flash_effect_1st_person"		"weapon_muzzle_flash_para_FP"
    "muzzle_flash_effect_3rd_person"		"weapon_muzzle_flash_para"
    "heat_effect"		"weapon_muzzle_smoke"
    "addon_location"		"primary_mg"
    "eject_brass_effect"		"weapon_shell_casing_rifle"
    "tracer_effect"		"weapon_tracers_mach"
    "weapon_type"		"Machinegun"
    "player_animation_extension"		"m249"
    "primary_ammo"		"BULLET_PLAYER_556MM_BOX"
    "sound_single_shot"		"Weapon_M249_CSGO.Single"
    "sound_nearlyempty"		"Default.nearlyempty"
}]=]
