AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

local GRENADE_DEFAULT_SIZE = 2.0
local GRENADE_FAILSAFE_MAX_BOUNCES = 20

local sv_gravity = GetConVar"sv_gravity"

ENT.IsSWCSGrenade = true

function ENT:SetupDataTables()
    self:NetworkVar("Vector", 0, "InitialVelocity")
    self:NetworkVar("Int", 0, "Bounces")
end

function ENT:OnReloaded()
    self:Initialize()
end

function ENT:Initialize()
    --self:SetSolidFlags(FSOLID_NOT_STANDABLE)
    self:PhysicsInitBox(-Vector(1,1,1), Vector(1,1,1))
    self:SetMoveType(MOVETYPE_FLYGRAVITY)
    self:SetMoveCollide(MOVECOLLIDE_FLY_CUSTOM)
    --self:SetSolidFlags(SOLID_BBOX) -- So it will collide with physics props!
    self:AddFlags(FL_GRENADE)

    if SERVER then
        self.m_LastHitPlayer = NULL
    end

    -- smaller, cube bounding box so we rest on the ground
    local min = Vector( -GRENADE_DEFAULT_SIZE, -GRENADE_DEFAULT_SIZE, -GRENADE_DEFAULT_SIZE )
    local max = Vector( GRENADE_DEFAULT_SIZE, GRENADE_DEFAULT_SIZE, GRENADE_DEFAULT_SIZE )

    self:SetCollisionBounds(min, max)
    self:SetBounces(0)
end

--[[
function ENT:UpdateTransmitState()
    -- always call ShouldTransmit() for grenades
    return self:ShouldTransmit()
end
]]

function ENT:ShouldTransmit()
    --[[CBaseEntity *pRecipientEntity = CBaseEntity::Instance( pInfo->m_pClientEnt );
    if ( pRecipientEntity->IsPlayer() )
    {
        CBasePlayer *pRecipientPlayer = static_cast<CBasePlayer*>( pRecipientEntity );

        // always transmit to the thrower of the grenade
        if ( pRecipientPlayer && ( (GetThrower() && pRecipientPlayer == GetThrower()) ||
            pRecipientPlayer->GetTeamNumber() == TEAM_SPECTATOR) )
        {
            return FL_EDICT_ALWAYS;
        }
    }

    return FL_EDICT_PVSCHECK;]]
end

local STOP_EPSILON = 0.1

local function PhysicsClipVelocity( vecIn, vecNormal, vecOut, flOverbounce )
    local backoff
    local change
    local angle
    local blocked

    blocked = 0

    angle = vecNormal[ 2 ]

    if ( angle > 0 ) then
        blocked = bit.bor(blocked, 1) -- floor
    end
    if ( not angle ) then
        blocked = bit.bor(blocked, 2) -- step
    end

    backoff = vecIn:Dot(vecNormal) * flOverbounce

    for i = 1, 3 do
        change = vecNormal[i] * backoff
        vecOut[i] = vecIn[i] - change
        if (vecOut[i] > -STOP_EPSILON and vecOut[i] < STOP_EPSILON) then
            vecOut[i] = 0
        end
    end

    return blocked
end

local kSleepVelocity = 20
local kSleepVelocitySquared = kSleepVelocity * kSleepVelocity
function ENT:PhysicsCollide(data, otherPhys)
    local other = otherPhys:GetEntity()
    -- Verify that we have an entity.
    if not other:IsValid() then return end

    local trace = self:GetTouchTrace()
    --print("bbb", other)

    -- chicken check!! very important
    --[[
        if ( pEntity )
        {
            CChicken *pChicken = dynamic_cast< CChicken* >( pEntity );
            if (pChicken)
            {
                // hurt the chicken
                CTakeDamageInfo info( this, this, 10, DMG_CLUB );
                pChicken->DispatchTraceAttack( info, GetAbsVelocity().Normalized(), &trace );
                ApplyMultiDamage();

                return;
            }
        }
    ]]

    -- if its breakable glass and we kill it, don't bounce.
    -- give some damage to the glass, and if it breaks, pass 
    -- through it.
    local breakthrough = false

    if other:GetClass() == "func_breakable" then
        breakthrough = true
    end

    if other:GetClass() == "func_breakable_surf" then
        breakthrough = true
    end

    local m_takedamage = other:GetInternalVariable("m_takedamage")
    if other:GetClass() == "prop_physics_multiplayer" and other:GetMaxHealth() > 0 and m_takedamage == 2 then
        breakthrough = true
    end

    -- this one is tricky because BounceTouch hits breakable propers before we hit this function and the damage is already applied there (CBaseGrenade::BounceTouch( CBaseEntity *pOther ))
    -- by the time we hit this, the prop hasn't been removed yet, but it broke, is set to not take anymore damage and is marked for deletion - we have to cover this case here
    if other:GetClass() == "prop_dynamic" and other:GetMaxHealth() > 0 and (m_takedamage == 2 or (m_takedamage == 0 and other:IsEFlagSet( EFL_KILLME ))) then
        breakthrough = true
    end

    if breakthrough then
        --CTakeDamageInfo info( this, this, 10, DMG_CLUB );
        --pEntity->DispatchTraceAttack( info, GetAbsVelocity().Normalized(), &trace );

        --ApplyMultiDamage();

        if other:Health() <= 0 then
            -- slow our flight a little bit
            local vel = self:GetVelocity()

            vel:Mul(0.4)

            self:SetVelocity( vel )
            return
        end
    end

    --Assume all surfaces have the same elasticity
    local flSurfaceElasticity = 1.0

    --Don't bounce off of players with perfect elasticity
    if other:IsPlayer() then
        flSurfaceElasticity = 0.3

        -- and do slight damage to players on the opposite team
        --[[if ( GetTeamNumber() != pEntity->GetTeamNumber() )
        {
            CTakeDamageInfo info( this, GetThrower(), 2, DMG_GENERIC );

            pEntity->TakeDamage( info );
        }]]
    end

    --Don't bounce twice on a selection of problematic entities
    local bIsProjectile = other.IsSWCSGrenade == true--dynamic_cast< CBaseCSGrenadeProjectile* >( pEntity ) != NULL;
    if not other:IsWorld() and self.m_lastHitPlayer == other then
        local bIsHostage = false--dynamic_cast< CHostage* >( pEntity ) != NULL;

        if other:IsPlayer() or bIsHostage or bIsProjectile then
            print("e")
            --DevMsg( "Setting %s to DEBRIS, it is in group %i, it hit %s in group %i\n", this->GetClassname(), this->GetCollisionGroup(), pEntity->GetClassname(), pEntity->GetCollisionGroup() );
            self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
            if ( bIsProjectile ) then
                --DevMsg( "Setting %s to DEBRIS, it is in group %i.\n", pEntity->GetClassname(), pEntity->GetCollisionGroup() );
                self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
            end

            return
        end
    end
    if other:IsValid() then
        self.m_lastHitPlayer = other
    end

    local flTotalElasticity = self:GetElasticity() * flSurfaceElasticity
    flTotalElasticity = math.Clamp( flTotalElasticity, 0.0, 0.9 )

    -- NOTE: A backoff of 2.0f is a reflection
    local vecAbsVelocity = Vector()
    PhysicsClipVelocity( self:GetVelocity(), trace.HitNormal, vecAbsVelocity, 2.0 )
    vecAbsVelocity:Mul(flTotalElasticity)

    -- Get the total velocity (player + conveyors, etc.)
    local vecMove = self:GetBaseVelocity()
    vecAbsVelocity:Add(self:GetBaseVelocity())
    vecMove:Add(vecAbsVelocity)
    local flSpeedSqr = vecMove:Dot(vecMove)

    local bIsWeapon = other:IsWeapon()

    -- Stop if on ground or if we bounce and our velocity is really low (keeps it from bouncing infinitely)
    if ( IsValid(other) and
        ( ( trace.HitNormal.z > 0.7 ) or (trace.HitNormal.z > 0.1 and flSpeedSqr < kSleepVelocitySquared) ) and
        ( --[[other->IsStandable() or]] bIsProjectile or bIsWeapon or other:IsWorld() )
        )
    then
        -- clip it again to emulate old behavior and keep it from bouncing up like crazy when you throw it at the ground on the first toss
        if ( flSpeedSqr > 96000 ) then
            local alongDist = vecAbsVelocity:GetNormalized():Dot(trace.HitNormal)
            if ( alongDist > 0.5 ) then
                local flBouncePadding = (1.0 - alongDist) + 0.5
                vecAbsVelocity:Mul(flBouncePadding)
            end
        end

        self:SetVelocity( vecAbsVelocity )

        if ( flSpeedSqr < kSleepVelocitySquared ) then
            self:SetGroundEntity( other )

            -- Reset velocities.
            self:SetVelocity( vector_origin )
            self:SetLocalAngularVelocity( angle_zero )

            --align to the ground so we're not standing on end
            local angle = trace.HitNormal:Angle()

            -- rotate randomly in yaw
            angle[1] = g_ursRandom:RandomFloat( 0, 360 )

            -- TODO: rotate around trace.plane.normal

            self:SetAngles(angle)
        else
            local vecBaseDir = self:GetBaseVelocity()
            if ( not vecBaseDir:IsZero() ) then
                vecBaseDir:Normalize()
                local vecDelta = self:GetBaseVelocity() - vecAbsVelocity
                local flScale = vecDelta:Dot(vecBaseDir)
                vecAbsVelocity:Add(self:GetBaseVelocity() * flScale)
            end

            vecMove = vecAbsVelocity * (1 - trace.Fraction) * FrameTime() --VectorScale( vecAbsVelocity, ( 1.0 - trace.Fraction ) * FrameTime(), vecMove )

            --PhysicsPushEntity( vecMove, trace )
        end
    else
        self:SetVelocity( vecAbsVelocity )
        vecMove = vecAbsVelocity * (1 - trace.Fraction) * FrameTime() --VectorScale( vecAbsVelocity, ( 1.0 - trace.Fraction ) * FrameTime(), vecMove )
        --PhysicsPushEntity( vecMove, trace )
    end

    self:BounceSound()

    self:OnBounced()

    if self:GetBounces() > GRENADE_FAILSAFE_MAX_BOUNCES then
        -- failsafe detonate after 20 bounces
        self:SetVelocity(vector_origin)
        self:DetonateOnNextThink()
        self:SetNextThink(CurTime())
        self:SetMoveType(MOVETYPE_NONE)
    else
        self:SetBounces(self:GetBounces() + 1)
    end
end

function ENT:BounceSound()
    --
end

function ENT:OnBounced()
    --
end
