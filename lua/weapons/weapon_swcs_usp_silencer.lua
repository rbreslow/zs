SWEP.Base = "weapon_swcs_base"
SWEP.Category = "Counter-Strike: Global Offensive"

SWEP.PrintName = "USP-S"
SWEP.Spawnable = true
SWEP.HoldType = "pistol"
SWEP.WorldModel = Model"models/weapons/csgo/w_pist_223_dropped.mdl"
SWEP.WorldModelPlayer = Model"models/weapons/csgo/w_pist_223.mdl"
SWEP.ViewModel = Model"models/weapons/csgo/v_pist_223.mdl"

-- silenced sound
sound.Add({
	name = "Weapon_USP_CSGO.SilencedShot",
	channel = CHAN_STATIC,
	level = 73,
	volume = 0.7,
	pitch = 100,
	sound = {Sound")weapons/csgo/usp/usp_01.wav", Sound")weapons/csgo/usp/usp_02.wav", Sound")weapons/csgo/usp/usp_03.wav",}
})
-- unsilenced sound
sound.Add({
	name = "Weapon_USP_CSGO.Single",
	channel = CHAN_STATIC,
	level = 79,
	volume = 0.8,
	pitch = 100,
	sound = {Sound")weapons/csgo/usp/usp_unsilenced_01.wav", Sound")weapons/csgo/usp/usp_unsilenced_02.wav", Sound")weapons/csgo/usp/usp_unsilenced_03.wav",}
})
sound.Add({
	name = "Weapon_USP_CSGO.SilencerScrewOnStart",
	channel = CHAN_ITEM,
	level = 65,
	volume = 0.75,
	sound = Sound"weapons/csgo/usp/usp_silencer_screw_on_start.wav"
})
sound.Add({
	name = "Weapon_USP_CSGO.SilencerScrew1",
	channel = CHAN_ITEM,
	level = 65,
	volume = 0.75,
	sound = Sound"weapons/csgo/usp/usp_silencer_screw1.wav"
})
sound.Add({
	name = "Weapon_USP_CSGO.SilencerScrew2",
	channel = CHAN_ITEM,
	level = 65,
	volume = 0.75,
	sound = Sound"weapons/csgo/usp/usp_silencer_screw2.wav"
})
sound.Add({
	name = "Weapon_USP_CSGO.SilencerScrew3",
	channel = CHAN_ITEM,
	level = 65,
	volume = 0.75,
	sound = Sound"weapons/csgo/usp/usp_silencer_screw3.wav"
})
sound.Add({
	name = "Weapon_USP_CSGO.SilencerScrew4",
	channel = CHAN_ITEM,
	level = 65,
	volume = 0.75,
	sound = Sound"weapons/csgo/usp/usp_silencer_screw4.wav"
})
sound.Add({
	name = "Weapon_USP_CSGO.SilencerScrew5",
	channel = CHAN_ITEM,
	level = 65,
	volume = 0.75,
	sound = Sound"weapons/csgo/usp/usp_silencer_screw5.wav"
})

sound.Add({
	name = "Weapon_USP_CSGO.SilencerWeaponMove1",
	channel = CHAN_ITEM,
	level = 65,
	volume = 0.25,
	sound = Sound"weapons/csgo/movement1.wav"
})
sound.Add({
	name = "Weapon_USP_CSGO.SilencerWeaponMove2",
	channel = CHAN_ITEM,
	level = 65,
	volume = 0.25,
	sound = Sound"weapons/csgo/movement2.wav"
})
sound.Add({
	name = "Weapon_USP_CSGO.SilencerWeaponMove3",
	channel = CHAN_ITEM,
	level = 65,
	volume = 0.25,
	sound = Sound"weapons/csgo/movement3.wav"
})

SWEP.ItemDefAttributes = [=["attributes 07/05/2020"
{
    "magazine model"		"models/weapons/w_pist_223_mag.mdl"
    "has silencer"		"1"
    "spread"		"2.500000"
    "spread alt"		"1.500000"
    "inaccuracy fire"		"71.000000"
    "inaccuracy fire alt"		"52.000000"
    "inaccuracy move"		"13.870000"
    "inaccuracy jump initial"		"96.599998"
    "inaccuracy jump"		"94.480003"
    "inaccuracy jump alt"		"94.480003"
    "recoil magnitude"		"29"
    "recoil magnitude alt"		"23"
    "tracer frequency"		"1"
    "tracer frequency alt"		"0"
    "primary clip size"		"12"
    "primary reserve ammo max"		"24"
    "heat per shot"		"0.300000"
    "max player speed"		"240"
    "in game price"		"200"
    "armor ratio"		"1.010000"
    "crosshair min distance"		"8"
    "penetration"		"1"
    "damage"		"35"
    "range"		"4096"
    "range modifier"		"0.910000"
    "cycletime"		"0.170000"
    "flinch velocity modifier large"		"0.500000"
    "flinch velocity modifier small"		"0.650000"
    "inaccuracy crouch"		"3.680000"
    "inaccuracy stand"		"4.900000"
    "inaccuracy land"		"0.191000"
    "inaccuracy ladder"		"138.320007"
    "inaccuracy crouch alt"		"3.680000"
    "inaccuracy stand alt"		"4.900000"
    "inaccuracy land alt"		"0.198000"
    "inaccuracy ladder alt"		"119.900002"
    "inaccuracy move alt"		"13.870000"
    "recovery time crouch"		"0.291277"
    "recovery time stand"		"0.349532"
    "recoil angle"		"0"
    "recoil angle variance"		"0"
    "recoil magnitude variance"		"0"
    "recoil seed"		"5426"
    "weapon weight"		"5"
    "rumble effect"		"1"
    "max player speed alt"		"240"
    "recoil angle alt"		"0"
    "recoil angle variance alt"		"0"
    "recoil magnitude variance alt"		"0"
    "recovery time crouch final"		"0.291277"
    "recovery time stand final"		"0.349532"
}]=]
SWEP.ItemDefVisuals = [=["visuals 07/07/2020"
{
    "sound_single_shot"		"Weapon_USP_CSGO.Single"
    "sound_special1"		"Weapon_USP_CSGO.SilencedShot"
    "primary_ammo"		"BULLET_PLAYER_357SIG_SMALL"
    "muzzle_flash_effect_1st_person"		"weapon_muzzle_flash_pistol"
    "muzzle_flash_effect_3rd_person"		"weapon_muzzle_flash_pistol"
    "heat_effect"		"weapon_muzzle_smoke"
    "eject_brass_effect"		"weapon_shell_casing_9mm"
    "tracer_effect"		"weapon_tracers_pistol"
    "weapon_type"		"Pistol"
    "player_animation_extension"		"pistol"
    "sound_nearlyempty"		"Default.nearlyempty"
}]=]
