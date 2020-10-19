SWEP.PrintName = "#HL2_Crowbar"
SWEP.Base = "weapon_hl2basebludgeon"
SWEP.Category = "Half-Life 2 Remake"

DEFINE_BASECLASS("weapon_hl2basebludgeon")

SWEP.Spawnable = true

SWEP.CharLogo = "c"
SWEP.Slot = 0
SWEP.SlotPos = 1

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

SWEP.Range = 75
SWEP.MELEE_HIT = "Weapon_Crowbar.Melee_Hit"
SWEP.SINGLE = "Weapon_Crowbar.Single"

SWEP.Primary.Damage = 25
SWEP.Primary.Delay = .4

SWEP.IconOverride = "entities/weapon_crowbar.png"

local sk_plr_dmg_crowbar = GetConVar("sk_plr_dmg_crowbar")

function SWEP:Initialize()
    BaseClass.Initialize(self)
    self.Primary.Damage = sk_plr_dmg_crowbar:GetInt()
end

function SWEP:AddViewKick()
    self:GetOwner():ViewPunch(Angle(util.SharedRandom("crowbarpax", 1, 2), util.SharedRandom("crowbarpay", -2, -1), 0))
end
