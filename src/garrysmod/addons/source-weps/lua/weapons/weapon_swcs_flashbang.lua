SWEP.Base = "weapon_swcs_base_grenade"
SWEP.Category = "Counter-Strike: Global Offensive"

SWEP.PrintName = "flashbang"
SWEP.Spawnable = false
SWEP.WorldModel = Model"models/weapons/csgo/w_eq_flashbang_dropped.mdl"
SWEP.WorldModelPlayer = Model"models/weapons/csgo/w_eq_flashbang.mdl"
SWEP.ViewModel = Model"models/weapons/csgo/v_eq_flashbang.mdl"

sound.Add({
    name = "Flashbang.PullPin_Grenade_Start",
    channel = CHAN_WEAPON,
    level = 65,
    volume = 1,
    pitch = 100,
    sound = Sound"weapons/csgo/flashbang/pinpull.wav"
})
sound.Add({
    name = "Flashbang.PullPin_Grenade",
    channel = CHAN_ITEM,
    level = 65,
    volume = 1,
    pitch = 100,
    sound = Sound"weapons/csgo/flashbang/pinpull_start.wav"
})
sound.Add({
    name = "Flashbang.Throw",
    channel = CHAN_STATIC,
    level = 65,
    volume = 1,
    pitch = 100,
    sound = Sound")weapons/csgo/flashbang/grenade_throw.wav"
})
sound.Add({
    name = "Flashbang.Draw",
    channel = CHAN_STATIC,
    level = 65,
    volume = 0.3,
    pitch = 100,
    sound = Sound")weapons/csgo/flashbang/flashbang_draw.wav"
})

SWEP.ItemDefAttributes = [=["attributes 09/03/2020" {
    "max player speed"		"245"
    "in game price"		"200"
    "crosshair min distance"		"7"
    "penetration"		"1"
    "damage"		"50"
    "range"		"4096"
    "range modifier"		"0.990000"
    "throw velocity"		"750.000000"
    "primary default clip size"		"1"
    "secondary default clip size"		"1"
    "weapon weight"		"1"
    "itemflag exhaustible"		"1"
    "max player speed alt"		"245"
}]=]
SWEP.ItemDefVisuals = [=["visuals 09/03/2020" {
    "weapon_type"		"Grenade"
    "player_animation_extension"		"gren"
    "primary_ammo"		"AMMO_TYPE_FLASHBANG"
    "sound_single_shot"		"Flashbang.Throw"
    "sound_nearlyempty"		"Default.nearlyempty"
}]=]

function SWEP:EmitGrenade(vecSrc, angles, vecVel, vecAngImpulse, owner)
    if SERVER then
        local ent = ents.Create("flashbang_projectile")
        ent:Create(vecSrc, angles, vecVel, vecAngImpulse, owner)
        ent:Spawn()
    end
end
