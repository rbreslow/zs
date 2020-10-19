AddCSLuaFile()

ENT.Base = "baseswcsgrenade_projectile"

DEFINE_BASECLASS(ENT.Base)

local GRENADE_MODEL = "models/weapons/csgo/w_eq_flashbang_dropped.mdl"

function ENT:Create(pos, angs, vel, angvel, owner)
    self:SetPos(pos)
    self:SetAngles(angs)

    self:SetVelocity(vel)
    self:SetInitialVelocity(vel)
    self:SetOwner(owner)

    self:SetLocalAngularVelocity(angvel)
    self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)

    return self
end

local GRENADE_DEFAULT_SIZE = 2.0
function ENT:Initialize()
    self:SetModel(GRENADE_MODEL)

    self:SetSolidFlags(FSOLID_NOT_STANDABLE)
    self:SetMoveType(MOVETYPE_FLYGRAVITY)
    self:SetMoveCollide(MOVECOLLIDE_FLY_CUSTOM)
    self:SetSolidFlags(SOLID_BBOX) -- So it will collide with physics props!
    self:AddFlags(FL_GRENADE)
    self:PhysicsInitBox(-Vector(1,1,1), Vector(1,1,1))

    if SERVER then
        self.m_LastHitPlayer = NULL
    end

    -- smaller, cube bounding box so we rest on the ground
    local min = Vector( -GRENADE_DEFAULT_SIZE, -GRENADE_DEFAULT_SIZE, -GRENADE_DEFAULT_SIZE );
    local max = Vector( GRENADE_DEFAULT_SIZE, GRENADE_DEFAULT_SIZE, GRENADE_DEFAULT_SIZE );

    self:SetCollisionBounds(min, max)
    self:SetBounces(0)

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
end
