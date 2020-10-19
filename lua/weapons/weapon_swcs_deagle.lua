SWEP.Base = "weapon_swcs_base"
SWEP.Category = "Counter-Strike: Global Offensive"

DEFINE_BASECLASS(SWEP.Base)

SWEP.PrintName = "Desert Eagle"
SWEP.Spawnable = true
SWEP.HoldType = "revolver"
SWEP.WorldModel = Model"models/weapons/csgo/w_pist_deagle_dropped.mdl"
SWEP.WorldModelPlayer = Model"models/weapons/csgo/w_pist_deagle.mdl"
SWEP.ViewModel = Model"models/weapons/csgo/v_pist_deagle.mdl"

sound.Add({
	name = "Weapon_DEagle_CSGO.Single",
	channel = CHAN_STATIC,
	level = 79,
	volume = 1,
	pitch = 100,
	sound = {Sound")weapons/csgo/deagle/deagle_01.wav", Sound")weapons/csgo/deagle/deagle_02.wav"}
})
sound.Add({
	name = "Weapon_DEagle_CSGO.Draw",
	channel = CHAN_STATIC,
	level = 65,
	volume = 0.3,
	sound = Sound"weapons/csgo/deagle/de_draw.wav"
})
sound.Add({
	name = "Weapon_DEagle_CSGO.Clipout",
	channel = CHAN_ITEM,
	level = 65,
	volume = 1,
	sound = Sound"weapons/csgo/deagle/de_clipout.wav"
})
sound.Add({
	name = "Weapon_DEagle_CSGO.Clipin",
	channel = CHAN_ITEM,
	level = 65,
	volume = 1,
	sound = Sound"weapons/csgo/deagle/de_clipin.wav"
})
sound.Add({
	name = "Weapon_DEagle_CSGO.Slideback",
	channel = CHAN_ITEM,
	level = 65,
	volume = 1,
	sound = Sound"weapons/csgo/deagle/de_slideback.wav"
})
sound.Add({
	name = "Weapon_DEagle_CSGO.Slideforward",
	channel = CHAN_ITEM,
	level = 65,
	volume = 1,
	sound = Sound"weapons/csgo/deagle/de_slideforward.wav"
})
sound.Add({
	name = "Weapon_DEagle_CSGO.WeaponMove1",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement1.wav"
})
sound.Add({
	name = "Weapon_DEagle_CSGO.WeaponMove2",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement2.wav"
})
sound.Add({
	name = "Weapon_DEagle_CSGO.WeaponMove3",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/movement3.wav"
})
sound.Add({
	name = "Weapon_DEagle_CSGO.WeaponMove4",
	channel = CHAN_ITEM,
	level = 65,
	volume = {0.05, .1},
	pitch = {98, 101},
	sound = Sound"weapons/csgo/deagle/de_draw.wav"
})
sound.Add({
	name = "Weapon_DEagle_CSGO.LookAt009",
	channel = CHAN_STATIC,
	level = 65,
	sound = Sound"weapons/csgo/deagle/deagle_special_lookat_f009.wav"
})
sound.Add({
	name = "Weapon_DEagle_CSGO.LookAt036",
	channel = CHAN_STATIC,
	level = 65,
	sound = Sound"weapons/csgo/deagle/deagle_special_lookat_f036.wav"
})
sound.Add({
	name = "Weapon_DEagle_CSGO.LookAt057",
	channel = CHAN_STATIC,
	level = 65,
	sound = Sound"weapons/csgo/deagle/deagle_special_lookat_f057.wav"
})
sound.Add({
	name = "Weapon_DEagle_CSGO.LookAt081",
	channel = CHAN_STATIC,
	level = 65,
	sound = Sound"weapons/csgo/deagle/deagle_special_lookat_f081.wav"
})
sound.Add({
	name = "Weapon_DEagle_CSGO.LookAt111",
	channel = CHAN_STATIC,
	level = 65,
	sound = Sound"weapons/csgo/deagle/deagle_special_lookat_f111.wav"
})
sound.Add({
	name = "Weapon_DEagle_CSGO.LookAt133",
	channel = CHAN_STATIC,
	level = 65,
	sound = Sound"weapons/csgo/deagle/deagle_special_lookat_f133.wav"
})
sound.Add({
	name = "Weapon_DEagle_CSGO.LookAt166",
	channel = CHAN_STATIC,
	level = 65,
	sound = Sound"weapons/csgo/deagle/deagle_special_lookat_f166.wav"
})
sound.Add({
	name = "Weapon_DEagle_CSGO.LookAt193",
	channel = CHAN_STATIC,
	level = 65,
	sound = Sound"weapons/csgo/deagle/deagle_special_lookat_f193.wav"
})
sound.Add({
	name = "Weapon_DEagle_CSGO.LookAt228",
	channel = CHAN_STATIC,
	level = 65,
	sound = Sound"weapons/csgo/deagle/deagle_special_lookat_f228.wav"
})

function SWEP:PrimaryAttackAct()
	if self:Clip1() == 1 then
		return ACT_VM_DRYFIRE
	end

	return BaseClass.PrimaryAttackAct(self)
end

SWEP.ItemDefAttributes = [=["attributes 07/07/2020"
{
    "magazine model"		"models/weapons/w_pist_deagle_mag.mdl"
    "heat per shot"		"0.300000"
    "addon scale"		"1.000000"
    "tracer frequency"		"1"
    "primary clip size"		"7"
    "primary default clip size"		"-1"
    "secondary default clip size"		"-1"
    "is full auto"		"0"
    "max player speed"		"230"
    "in game price"		"700"
    "armor ratio"		"1.864000"
    "crosshair min distance"		"8"
    "crosshair delta distance"		"3"
    "cycletime"		"0.225000"
    "model right handed"		"1"
    "penetration"		"2"
    "damage"		"63"
    "range"		"4096"
    "range modifier"		"0.810000"
    "bullets"		"1"
    "cycletime"		"0.225000"
    "flinch velocity modifier large"		"0.400000"
    "flinch velocity modifier small"		"0.550000"
    "spread"		"2.000000"
    "inaccuracy crouch"		"2.180000"
    "inaccuracy stand"		"4.200000"
    "inaccuracy jump initial"		"548.820007"
    "inaccuracy jump apex"		"331.549988"
    "inaccuracy jump"		"40.549999"
    "inaccuracy land"		"0.043000"
    "inaccuracy ladder"		"152.000000"
    "inaccuracy fire"		"72.230003"
    "inaccuracy move"		"48.099998"
    "recovery time crouch"		"0.449927"
    "recovery time stand"		"0.811200"
    "recoil angle"		"0.000000"
    "recoil angle variance"		"60"
    "recoil magnitude"		"48.200001"
    "recoil magnitude variance"		"18"
    "recoil seed"		"1454"
    "primary reserve ammo max"		"35"
    "weapon weight"		"7"
    "rumble effect"		"2"
    "inaccuracy crouch alt"		"2.180000"
    "inaccuracy fire alt"		"72.230003"
    "inaccuracy jump alt"		"371.549988"
    "inaccuracy ladder alt"		"152.000000"
    "inaccuracy land alt"		"0.730000"
    "inaccuracy move alt"		"48.099998"
    "inaccuracy stand alt"		"4.200000"
    "max player speed alt"		"230"
    "recoil angle variance alt"		"60"
    "recoil magnitude alt"		"48.200001"
    "recoil magnitude variance alt"		"18"
    "recovery time crouch final"		"0.449927"
    "recovery time stand final"		"0.811200"
    "spread alt"		"2.000000"
}]=]
SWEP.ItemDefVisuals = [=["visuals 07/07/2020"
{
    "muzzle_flash_effect_1st_person"		"weapon_muzzle_flash_pistol"
    "muzzle_flash_effect_3rd_person"		"weapon_muzzle_flash_pistol"
    "heat_effect"		"weapon_muzzle_smoke"
    "eject_brass_effect"		"weapon_shell_casing_9mm"
    "tracer_effect"		"weapon_tracers_pistol"
    "weapon_type"		"Pistol"
    "player_animation_extension"		"pistol"
    "primary_ammo"		"BULLET_PLAYER_50AE"
    "sound_single_shot"		"Weapon_DEagle_CSGO.Single"
    "sound_nearlyempty"		"Default.nearlyempty"
}]=]
