if SERVER then AddCSLuaFile() end

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.PrintName = "C4"
ENT.Author = "homonovus"

function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "PlantTime")
    self:NetworkVar("Float", 1, "NextBeep")
end

function ENT:Use(activator, caller, type, int)
    --print(activator, caller, type, int)
end

function ENT:Precache()
    util.PrecacheModel("models/weapons/tfa_csgo/w_c4_planted.mdl")
end

function ENT:Initialize()
    self:SetModel("models/weapons/tfa_csgo/w_c4_planted.mdl")
    if SERVER then
        self:SetUseType(SIMPLE_USE)
    end

    self:SetPlantTime(CurTime())

    self:SetSolid(SOLID_VPHYSICS)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    self:SetMoveType(MOVETYPE_NONE)

    self:SetNextBeep(CurTime() + 1)
end

function ENT:Think()
    if self:GetPlantTime() + 40 <= CurTime() then
        if SERVER then
            self:Explode()
            self:Remove()
        end

        return
    else
        if self:GetNextBeep() <= CurTime() then
            if SERVER then
                if self:GetPlantTime() + 38 > CurTime() then
                    self:EmitSound("TFA_CSGO_c4.PlantSound")
                else
                    self:EmitSound("TFA_CSGO_c4.ExplodeWarning")
                    self:SetNextBeep(math.huge)
                    return
                end
            end

            local delay = (40 / (CurTime() - self:GetPlantTime() + 40)) / 2
            --print(self:GetPlantTime() + 40, CurTime() + delay)

            self:SetNextBeep(CurTime() + delay)
        end
    end
end

function ENT:Explode()
    local ply = IsValid(self:GetOwner()) and self:GetOwner() or self
    if SERVER then
        local explode = ents.Create( "info_particle_system" )
        explode:SetKeyValue( "effect_name", "explosion_c4_500" )
        explode:SetOwner( self.Owner )
        explode:SetPos( self:GetPos() )
        explode:Spawn()
        explode:Activate()
        explode:Fire( "start", "", 0 )
        explode:Fire( "kill", "", 30 )
        self:EmitSound( "TFA_CSGO_c4.explode" )
    end
    util.BlastDamage( self, ply, self:GetPos(), 1750, 500 )
    local spos = self:GetPos()
    local trs = util.TraceLine({
        start = spos + Vector(0,0,64),
        endpos = spos + Vector(0,0,-32),
        filter = self
    })
    util.Decal("Scorch", trs.HitPos + trs.HitNormal, trs.HitPos - trs.HitNormal)
end
