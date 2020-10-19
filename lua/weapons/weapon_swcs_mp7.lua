SWEP.Base = "weapon_swcs_base"
SWEP.Category = "Counter-Strike: Global Offensive"

SWEP.PrintName = "MP7"
SWEP.Spawnable = true
SWEP.HoldType = "smg"
SWEP.WorldModel = Model"models/weapons/csgo/w_smg_mp7_dropped.mdl"
SWEP.WorldModelPlayer = Model"models/weapons/csgo/w_smg_mp7.mdl"
SWEP.ViewModel = Model"models/weapons/csgo/v_smg_mp7.mdl"

sound.Add({
	name = "Weapon_MP7_CSGO.Single",
	channel = CHAN_STATIC,
	level = 79,
	volume = 1.0,
	sound = {Sound")weapons/csgo/mp7/mp7_01.wav", Sound")weapons/csgo/mp7/mp7_02.wav", Sound")weapons/csgo/mp7/mp7_03.wav", Sound")weapons/csgo/mp7/mp7_04.wav"}
})
sound.Add({
	name = "Weapon_MP7_CSGO.Clipout",
	channel = CHAN_ITEM,
	level = 65,
	sound = Sound"weapons/csgo/mp7/mp7_clipout.wav"
})
sound.Add({
	name = "Weapon_MP7_CSGO.Clipin",
	channel = CHAN_ITEM,
	level = 65,
	sound = Sound"weapons/csgo/mp7/mp7_clipin.wav"
})
sound.Add({
	name = "Weapon_MP7_CSGO.Draw",
	channel = CHAN_STATIC,
	level = 65,
	volume = 0.3,
	sound = Sound"weapons/csgo/mp7/mp7_draw.wav"
})
sound.Add({
	name = "Weapon_MP7_CSGO.slideBack",
	channel = CHAN_ITEM,
	level = 60,
	sound = Sound"weapons/csgo/mp7/mp7_slideback.wav"
})
sound.Add({
	name = "Weapon_MP7_CSGO.slideForward",
	channel = CHAN_ITEM,
	level = 60,
	sound = Sound"weapons/csgo/mp7/mp7_slideforward.wav"
})
sound.Add({
	name = "Weapon_MP7_CSGO.WeaponMove1",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement1.wav"
})
sound.Add({
	name = "Weapon_MP7_CSGO.WeaponMove2",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement2.wav"
})
sound.Add({
	name = "Weapon_MP7_CSGO.WeaponMove3",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement3.wav"
})

SWEP.ItemDefAttributes = [=["attributes 07/17/2020"
{
    "magazine model"		"models/weapons/w_smg_mp7_mag.mdl"
    "primary reserve ammo max"		"120"
    "inaccuracy jump initial"		"55.410000"
    "inaccuracy jump"		"59.599998"
    "heat per shot"		"0.350000"
    "tracer frequency"		"3"
    "max player speed"		"220"
    "is full auto"		"1"
    "in game price"		"1500"
    "kill award"		"600"
    "armor ratio"		"1.250000"
    "crosshair min distance"		"6"
    "crosshair delta distance"		"2"
    "penetration"		"1"
    "damage"		"29"
    "range"		"3600"
    "range modifier"		"0.850000"
    "cycletime"		"0.080000"
    "time to idle"		"2"
    "flinch velocity modifier large"		"0.000000"
    "flinch velocity modifier small"		"0.000000"
    "spread"		"0.600000"
    "inaccuracy crouch"		"5.920000"
    "inaccuracy stand"		"10.000000"
    "inaccuracy land"		"0.115000"
    "inaccuracy ladder"		"57.560001"
    "inaccuracy fire"		"2.180000"
    "inaccuracy move"		"19.860001"
    "recovery time crouch"		"0.312494"
    "recovery time stand"		"0.437491"
    "recoil angle"		"0"
    "recoil angle variance"		"70"
    "recoil magnitude"		"16"
    "recoil magnitude variance"		"1"
    "recoil seed"		"61649"
    "primary clip size"		"30"
    "weapon weight"		"25"
    "rumble effect"		"3"
    "inaccuracy crouch alt"		"5.920000"
    "inaccuracy fire alt"		"2.180000"
    "inaccuracy jump alt"		"59.599998"
    "inaccuracy ladder alt"		"57.560001"
    "inaccuracy land alt"		"0.115000"
    "inaccuracy move alt"		"19.860001"
    "inaccuracy stand alt"		"10.000000"
    "max player speed alt"		"220"
    "recoil angle alt"		"0"
    "recoil angle variance alt"		"70"
    "recoil magnitude alt"		"16"
    "recoil magnitude variance alt"		"1"
    "recovery time crouch final"		"0.312494"
    "recovery time stand final"		"0.437491"
    "spread alt"		"0.600000"
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
    "player_animation_extension"		"mp7"
    "primary_ammo"		"BULLET_PLAYER_9MM"
    "secondary_ammo"		"BULLET_PLAYER_9MM"
    "sound_single_shot"		"Weapon_MP7_CSGO.Single"
    "sound_nearlyempty"		"Default.nearlyempty"
}]=]
