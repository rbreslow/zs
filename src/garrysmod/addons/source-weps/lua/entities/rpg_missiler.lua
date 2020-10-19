if SERVER then AddCSLuaFile() end

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "rpg_missiler"
ENT.Author = "homonovus"

ENT.GracePeriodEndsAt = 0
--ENT.RocketTrail = NULL

local RPG_SPEED = 1500
local RPG_HOMING_SPEED = .125

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "CurrentThink")
end

function ENT:Initialize()
    self:SetModel("models/weapons/w_missile_launch.mdl")
    self:PhysicsInitBox(-Vector(4,4,4), Vector(4,4,4))
    self:SetMoveType(MOVETYPE_FLYGRAVITY) self:SetMoveCollide(MOVECOLLIDE_FLY_CUSTOM)
    self:SetCurrentThink(0)

    self:NextThink(CurTime() + .3)

    self:AddFlags(FL_OBJECT)
end

function ENT:SetGracePeriod(flGracePeriod)
    self.GracePeriodEndsAt = CurTime() + flGracePeriod
    self:AddSolidFlags(FSOLID_NOT_SOLID)
end

function ENT:Touch(ent)
    if not IsValid(ent) then return end

    -- Don't touch triggers (but DO hit weapons)
    if bit.band(ent:GetSolidFlags(), FSOLID_TRIGGER, FSOLID_VOLUME_CONTENTS) ~= 0 and ent:GetCollisionGroup() ~= COLLISION_GROUP_WEAPON then
        return end

    self:Explode()
end

function ENT:Explode()
    local forward = self:GetAngles():Forward()
    local tr = util.TraceLine({
        startpos = self:GetPos(),
        endpos = self:GetPos() + (forward * 16),
        mask = MASK_SHOT,
        filter = self,
        collisiongroup = COLLISION_GROUP_NONE
    })

    self:SetSolid(SOLID_NONE)

    if tr.Fraction == 1 or not tr.HitSky then
        self:DoExplosion()
    end

    if self.RocketTrail and self.RocketTrail:IsValid() then
        self.RocketTrail:SetLifeTime(.1)
    end

    if IsValid(self:GetOwner()) then
        self:GetOwner():NotifyRocketDied()
    end

    self:StopSound("Missile.Ignite")
    self:Remove()
end

function ENT:DoExplosion()
    local data = EffectData()
    data:SetOrigin(self:GetPos())

    util.Effect("Explosion", data)
end

function ENT:ComputeActualDotPosition()
    if IsValid(self:GetOwner()) then
        local rpg = self:GetOwner()
        if IsValid(rpg:GetOwner()) then
            --
        end
    end
    return vector_origin, 1
end

function ENT:IgniteThink()
    self:SetMoveType(MOVETYPE_FLY)
    self:PhysicsInitBox(vector_origin, vector_origin)
    self:RemoveSolidFlags(FSOLID_NOT_SOLID)

    local vecForward = self:GetAngles():Forward()
    self:EmitSound("Missile.Ignite")

    self:SetVelocity(vecForward * RPG_SPEED)

    self:SetCurrentThink(1)
    self:NextThink(CurTime())
end

function ENT:AccelerateThink()
    local forward = self:GetAngles():Forward()

    self:EmitSound("Missile.Accelerate")
    self:SetVelocity(forward * RPG_SPEED)
end

function ENT:SeekThink()
    --print"seeking :D"
    --[[if self:GetOwner() and IsValid(self:GetOwner()) then
        local rpg = self:GetOwner()
        if rpg:GetOwner() and IsValid(rpg:GetOwner()) then
            --local ply = rpg:GetOwner()

            local targetPos

            local homingSpeed
            targetPos, homingSpeed = self:ComputeActualDotPosition(targetPos, homingSpeed)

            --if (SimulatingOnAlternateTicks()) flHomingSpeed *= 2;

            local targetDir = targetPos - self:GetPos()
            local dist = targetDir:Length()
            targetDir:Normalize()

            local dir = self:GetVelocity()
            local speed = dir:Length() dir:Normalize()
            local newVel = dir
            if FrameTime() > 0 then
                if speed ~= 0 then
                    newVel = (homingSpeed * targetDir) + ( (1- homingSpeed) * dir)

                    -- This computation may happen to cancel itself out exactly. If so, slam to target dir
                    if newVel:Length() < 1e-3 then
                        newVel = dist ~= 0 and targetDir or dir
                    end
                else
                    newVel = targetDir
                end
            end
        end
    end]]
end

function ENT:Think()
    local rpg, owner
    if IsValid(self:GetOwner()) then
        rpg = self:GetOwner()
        if IsValid(rpg:GetOwner()) then
            owner = rpg:GetOwner()
        end
    end

    local curThink = self:GetCurrentThink()

    if curThink == 0 then
        self:IgniteThink(rpg,owner)
    elseif curThink == 1 then
        self:SeekThink(rpg,owner)
    elseif curThink == 2 then
        self:AccelerateThink(rpg,owner)
    end
end
