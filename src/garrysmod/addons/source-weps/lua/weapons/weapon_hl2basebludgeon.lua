SWEP.Base = "weapon_hl2base"
SWEP.Category = "Half-Life 2 Remake"

SWEP.HoldType = "melee"

SWEP.Range = 50
SWEP.MELEE_HITWORLD = "Weapon_Crowbar.Melee_Hit"
SWEP.MELEE_HIT = "Weapon_Crowbar.Melee_Hit"
SWEP.SINGLE = "Weapon_Crowbar.Single"
SWEP.CharLogo = "c"

SWEP.Primary.DefaultClip = -1
SWEP.Primary.ClipSize = -1
SWEP.Primary.Ammo = "none"
SWEP.Primary.Automatic = true
SWEP.Primary.Damage = 20
SWEP.Primary.Delay = .3

local BLUDGEON_HULL_DIM = 16
local bludgeonMins = Vector(-BLUDGEON_HULL_DIM,-BLUDGEON_HULL_DIM,-BLUDGEON_HULL_DIM)
local bludgeonMaxs = Vector(BLUDGEON_HULL_DIM,BLUDGEON_HULL_DIM,BLUDGEON_HULL_DIM)

function SWEP:GetRange()
    return self.Range
end

function SWEP:Swing(bIsSecondary)
    local owner = self:GetOwner()

    local traceHit = {}

    local swingStart = owner:GetShootPos()
    local forward = owner:GetAimVector()
    local swingEnd = swingStart + (forward * self:GetRange())
    util.TraceLine({
        start = swingStart,
        endpos = swingEnd,
        mask = MASK_SHOT_HULL,
        filter = owner,
        collisiongroup = COLLISION_GROUP_NONE,
        output = traceHit
    })
    if not traceHit.Hit then
        local bludgeonHullRadius = 1.732 * BLUDGEON_HULL_DIM

        swingEnd = swingEnd - (forward * bludgeonHullRadius)

        util.TraceHull({
            start = swingStart,
            endpos = swingEnd,
            mins = bludgeonMins,
            maxs = bludgeonMaxs,
            mask = MASK_SHOT_HULL,
            filter = owner,
            collisiongroup = COLLISION_GROUP_NONE,
            output = traceHit
        })
    end

    local hitActivity = ACT_VM_HITCENTER

    if SERVER then
        -- Like bullets, bludgeon traces have to trace against triggers.
        --hit triggers
    end

    if traceHit.Fraction == 1 and traceHit.Fraction < 1 and traceHit.Entity then
        local vecToTarget = traceHit.Entity:GetPos() - swingStart
        vecToTarget:Normalize()

        local dot = vecToTarget:Dot(forward)

        if dot < .70721 then
            traceHit.Fraction = 1
        else
            hitActivity = ACT_VM_HITCENTER
        end
    end

    self:EmitSound(self.SINGLE)

    -- Miss
    if traceHit.Fraction == 1 then
        hitActivity = bIsSecondary and ACT_VM_MISSCENTER or ACT_VM_MISSCENTER

        -- We want to test the first swing again
        local testEnd = swingStart + (forward * self:GetRange())

        -- See if we happened to hit water
        -- impactwater(swingStart, testEnd)
    else
        self:Hit(traceHit, hitActivity, bIsSecondary)
    end

    self:SetWeaponAnim(hitActivity)

    owner:SetAnimation(PLAYER_ATTACK1)

    self:SetNextPrimaryFire(self:GetRapidFire() and 0 or CurTime() + (bIsSecondary and self.Secondary.Delay or self.Primary.Delay))
    self:SetNextSecondaryFire(self:GetRapidFire() and 0 or CurTime() + (bIsSecondary and self.Secondary.Delay or self.Primary.Delay))
end

function SWEP:Hit(traceHit, hitActivity, bIsSecondary)
    local owner = self:GetOwner()

    local hitEntity = traceHit.Entity

    -- Apply damage to a hit target
    if hitEntity then
        local hitDirection = owner:GetAimVector()

        if SERVER then
            local info = DamageInfo()
            info:SetInflictor(owner)
            info:SetAttacker(owner)
            info:SetDamage(self.Primary.Damage)
            info:SetDamageType(DMG_CLUB)
            info:SetDamagePosition(traceHit.HitPos)

            local forceScale = info:GetBaseDamage() * (75 * 4)
            local force = hitDirection:GetNormal()
            force = force * forceScale
            force = force * GetConVar("phys_pushscale"):GetFloat()
            info:SetDamageForce(force)

            hitEntity:TakeDamageInfo(info)

            -- TraceAttackToTriggers()
        end

        if hitEntity == game.GetWorld() then
            self:EmitSound(self.MELEE_HITWORLD)
        else
            self:EmitSound(self.MELEE_HIT)
        end
    end

    self:AddViewKick()

    -- Apply an impact effect
    self:OnHit(traceHit, hitActivity, bIsSecondary)

    if SERVER and IsValid(owner) and owner:IsPlayer() then
        SuppressHostEvents(owner)
    end

    util.ImpactTrace(traceHit, DMG_CLUB)
end

function SWEP:AddViewKick()
    self:GetOwner():ViewPunch(Angle(util.SharedRandom("meleepax", 1, 2), util.SharedRandom("meleepay", -2, -1), 0))
end

function SWEP:OnHit(traceHit, hitActivity, bIsSecondary) end

function SWEP:PrimaryAttack()
    self:GetOwner():LagCompensation(true)
    self:Swing(false)
    self:GetOwner():LagCompensation(false)
end
