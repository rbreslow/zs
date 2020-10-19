SWEP.PrintName = "#HL2_357Handgun"
SWEP.Base = "weapon_hl2base"
SWEP.Category = "Half-Life 2 Remake"

DEFINE_BASECLASS("weapon_hl2base")

SWEP.Spawnable = true

SWEP.HoldType = "revolver"

SWEP.ViewModel = "models/weapons/c_357.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"

SWEP.EMPTY = "Weapon_Pistol.Empty"
SWEP.SINGLE = "Weapon_357.Single"
SWEP.CharLogo = "e"

SWEP.Primary.Ammo = "357"
SWEP.Primary.DefaultClip = 6
SWEP.Primary.ClipSize = 6
SWEP.Primary.Automatic = true
SWEP.Primary.Delay = .75
SWEP.Primary.Damage = 40

SWEP.Cone = Vector(0,0,0)

SWEP.IconOverride = "entities/weapon_357.png"

local sk_plr_dmg_357 = GetConVar("sk_plr_dmg_357")

function SWEP:Initialize()
    BaseClass.Initialize(self)
    self.Primary.Damage = sk_plr_dmg_357:GetInt()
end

function SWEP:AddViewKick()
    local angles = self:GetOwner():EyeAngles()
    angles.x = angles.x + util.SharedRandom("KickBackX", -1, 1)
    angles.y = angles.y + util.SharedRandom("KickBackY", -1, 1)
    angles.z = 0

    if (game.SinglePlayer() and SERVER) or (not game.SinglePlayer() and CLIENT and IsFirstTimePredicted()) then
        self:GetOwner():SetEyeAngles(angles)
    end

    self.Owner:ViewPunch( Angle( -8, -util.SharedRandom("KickBackX", -2, 2), 0 ) )
end
