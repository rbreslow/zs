SWEP.Base = "weapon_swcs_base"
SWEP.Category = "Counter-Strike: Global Offensive"

SWEP.PrintName = "grenade"
SWEP.Spawnable = false
SWEP.HoldType = "grenade"

SWEP.IsBaseWep = true

DEFINE_BASECLASS(SWEP.Base)

SWEP.ItemDefAttributes = [=["attributes 04/22/2020" {}]=]
SWEP.ItemDefVisuals = [=["visuals 07/07/2020" {}]=]
SWEP.ItemDefPrefab = [=["prefab 08/11/2020" {}]=]

local GRENADE_SECONDARY_DAMPENING = 0.3
local GRENADE_SECONDARY_LOWER = 12.0
local GRENADE_SECONDARY_TRANSITION = 1.3
local GRENADE_SECONDARY_INTERP = 2.0
local GRENADE_UNDERHAND_THRESHOLD = 0.33

function SWEP:SetupDataTables()
    BaseClass.SetupDataTables(self)

    self:NetworkVar("Bool", 7, "Redraw")
    self:NetworkVar("Bool", 8, "IsHeldByPlayer")
    self:NetworkVar("Bool", 8, "PinPulled")
    self:NetworkVar("Float", 11, "ThrowTime")
    self:NetworkVar("Bool", 9, "LoopingSoundPlaying")
    self:NetworkVar("Float", 12, "ThrowStrength")

    self:SetRedraw(false)
    self:SetIsHeldByPlayer(false)
    self:SetPinPulled(false)
    self:SetThrowTime(0)
    self:SetLoopingSoundPlaying(false)
    self:SetThrowStrength(0)
end

function SWEP:Deploy()
    self:SetRedraw(false)
    self:SetIsHeldByPlayer(true)
    self:SetPinPulled(false)

    self:SetThrowStrength(1.0)
    self.m_flThrowStrengthClientSmooth = 1
    self:SetThrowTime(0)

    --[[
	// if we're officially out of grenades, ditch this weapon
	CCSPlayer *pPlayer = GetPlayerOwner();
	if ( !pPlayer )
		return false;

	if ( pPlayer->GetAmmoCount(m_iPrimaryAmmoType) <= 0 )
	{
		pPlayer->Weapon_Drop( this, NULL, NULL );
		UTIL_Remove(this);
		return false;
	}
    ]]

    return BaseClass.Deploy(self)
end

local function MACRO__SetupItemDefGetter(tab, name, attribute, force_type, scale, default)
    local fnName = "Get" .. name
    scale = scale or 1
    default = default or 0

    if force_type == FORCE_BOOL then
        tab[fnName] = function(self)
            return tobool(self.ItemAttributes[attribute] or default)
        end
    elseif force_type == FORCE_STRING then
        tab[fnName] = function(self)
            return tostring(self.ItemAttributes[attribute])
        end
    else -- assume number
        tab[fnName] = function(self)
            return (self.ItemAttributes[attribute] or default) * scale
        end
    end
end

function SWEP:Initialize()
    MACRO__SetupItemDefGetter(self, "ThrowVelocity", "throw velocity")

    self:SetPinPulled(false)
    BaseClass.Initialize(self)

    self.GetHasSilencer = function() return false end
    self.GetZoomLevels = function() return 0 end
end

function SWEP:Holster(wep)

    self:SetRedraw(true)
    self:SetPinPulled(false)
    self:SetThrowStrength(1.0)
    self.m_flThrowStrengthClientSmooth = 1
    self:SetThrowTime(0)

    --[[
    CCSPlayer *pPlayer = GetPlayerOwner();
	if ( !pPlayer )
		return false;

	if( pPlayer->GetAmmoCount(m_iPrimaryAmmoType) <= 0 )
	{
		CBaseCombatCharacter *pOwner = (CBaseCombatCharacter *)pPlayer;
		pOwner->Weapon_Drop( this );
		UTIL_Remove(this);
	}
    ]]

    return true
end

function SWEP:CalcViewModelView(vm, oldPos, oldAng, pos, ang)
    vm:SetPoseParameter("throwcharge", math.Clamp(self:ApproachThrownStrength(), 0, 1))

    return BaseClass.CalcViewModelView(self, vm, oldPos, oldAng, pos, ang)
end

SWEP.m_flThrowStrengthClientSmooth = 0
function SWEP:ApproachThrownStrength()
    self.m_flThrowStrengthClientSmooth = math.Approach(
        self.m_flThrowStrengthClientSmooth,
        self:GetThrowStrength(),
        FrameTime() * GRENADE_SECONDARY_INTERP
    )

    return self.m_flThrowStrengthClientSmooth
end

function SWEP:PrimaryAttack()
    if --[[not self:GetIsHeldByPlayer() or]] self:GetPinPulled() or self:GetThrowTime() > 0 then
        return end

    local owner = self:GetPlayerOwner()
    if not owner then return end

    -- Ensure that the player can use this grenade
    --if ( !pPlayer->CanUseGrenade( GetCSWeaponID() ) )
    --{
    --    return;
    --}

    self:SetWeaponAnim(ACT_VM_PULLPIN)
    self:SetPinPulled(true)

    self:SetWeaponIdleTime(CurTime() + self:SequenceDuration())

    self:SetNextPrimaryFire(self:GetWeaponIdleTime())
end

function SWEP:SecondaryAttack()
    if not self:GetPinPulled() then
        self:SetThrowStrength(0)
        self.m_flThrowStrengthClientSmooth = 0
    end

    self:PrimaryAttack()
end

function SWEP:Think()
    local owner = self:GetPlayerOwner()
    if not owner then return end

    local vm = owner:GetViewModel(self:ViewModelIndex())
    if not vm:IsValid() then return end

    local bPrimaryHeld = (owner:KeyDown(IN_ATTACK))
    local bSecondaryHeld = (owner:KeyDown(IN_ATTACK2))

    if self:GetPinPulled() and ( bPrimaryHeld or bSecondaryHeld ) then
        local flIdealThrowStrength = 0.5

        if bPrimaryHeld then
            flIdealThrowStrength = flIdealThrowStrength + 0.5
        end

        if bSecondaryHeld then
            flIdealThrowStrength = flIdealThrowStrength - 0.5
        end

        self:SetThrowStrength( math.Approach( self:GetThrowStrength(), flIdealThrowStrength, FrameTime() * GRENADE_SECONDARY_TRANSITION ) )
    end

    -- If they let go of the fire buttons, they want to throw the grenade.
    if self:GetPinPulled() and not (bPrimaryHeld or bSecondaryHeld) then
        self:StartGrenadeThrow()

        self:SetPinPulled(false)

        if self:IsThrownUnderhand() then
            self:SetWeaponAnim( ACT_VM_RELEASE )
        else
            self:SetWeaponAnim( ACT_VM_THROW )
        end

        self:SetWeaponIdleTime(CurTime() + self:SequenceDuration())
        self:SetNextPrimaryFire(self:GetWeaponIdleTime())
    elseif self:GetThrowTime() > 0 and self:GetThrowTime() < CurTime() then
        -- self:DecrementAmmo(owner)
        self:ThrowGrenade()
    elseif not self:GetIsHeldByPlayer() then
        --[[
            // Has the throw animation finished playing
            if( m_flTimeWeaponIdle < gpGlobals->curtime )
            {
                // if we're officially out of grenades, ditch this weapon
                int nAmmoCount = pPlayer->GetAmmoCount(m_iPrimaryAmmoType);
                if( nAmmoCount <= 0 )
                {
                    pPlayer->Weapon_Drop( this, NULL, NULL );
                    //pPlayer->RemoveWeaponOnPlayer( this );
                    -- if SERVER then
                    UTIL_Remove(this);
                    -- end SERVER
                }

                else
                {
                    pPlayer->SwitchToNextBestWeapon( this );
                }

                -- if CLIENT then
                // when a grenade is removed, force the local player to update thier inventory screen
                C_CSPlayer *pLocalPlayer = C_CSPlayer::GetLocalCSPlayer();
                if ( pLocalPlayer && pLocalPlayer == pPlayer )
                {
                    SFWeaponSelection *pHudWS = GET_HUDELEMENT( SFWeaponSelection );
                    if ( pHudWS )
                    {
                        int nAmmoCount = pPlayer->GetAmmoCount(m_iPrimaryAmmoType);
                        if ( nAmmoCount <= 0 )
                        {
                            pHudWS->ShowAndUpdateSelection( WEPSELECT_DROP, this );
                        }
                        else
                        {
                            // we need to tell the hud that this weapon still exists and then update the selected weapon
                            pHudWS->ShowAndUpdateSelection( WEPSELECT_PICKUP, this );
                        }
                    }
                }
                -- end CLIENT
                return;	//don't animate this grenade any more!
            }	
        ]]
    elseif not self:GetRedraw() then
        BaseClass.Think(self)
    end
end

function SWEP:IsThrownUnderhand()
    return self:GetThrowStrength() <= GRENADE_UNDERHAND_THRESHOLD
end

function SWEP:StartGrenadeThrow()
    self:SetThrowTime(CurTime() + .1)

    self:EmitSound(self.SND_SINGLE or "weapons/hegrenade/he_draw.wav")
end

CONTENTS_GRENADECLIP = 0x80000
function SWEP:ThrowGrenade()
    local owner = self:GetPlayerOwner()
    if not owner then return end

    local angThrow = self:GetFinalAimAngle()
    if angThrow.p > 90 then
        angThrow.p = angThrow.p - 360
    elseif angThrow.p <= -90 then
        angThrow.p = angThrow.p + 360
    end

    assert( angThrow.p <= 90.0 and angThrow.p >= -90.0, "Grenade throw pitch angle must be between -90 and 90 for the adustments to work.")

    -- NB. a pitch of +90 is looking straight down, -90 is looking straight up

    -- add a 10 degrees upwards angle to the throw when looking horizontal, lerp the upwards boost to 0 at the pitch extremes
    angThrow.p = angThrow.p - ( 10.0 * (90.0 - math.abs(angThrow.p)) / 90.0 )

    local kBaseVelocity = self:GetThrowVelocity()
    --const float kThrowVelocityClampRatio = 750.0f / 540.0f;	-- from original CSS values

    --float flVel = clamp((90 - angThrow.x) / 90, 0.0f, kThrowVelocityClampRatio) * kBaseVelocity;
    local flVel = math.Clamp( (kBaseVelocity * 0.9), 15, 750 )

    --clamp the throw strength ranges just to be sure
    local flClampedThrowStrength = self:GetThrowStrength()
    flClampedThrowStrength = math.Clamp( flClampedThrowStrength, 0.0, 1.0 )

    flVel = flVel * Lerp( flClampedThrowStrength, GRENADE_SECONDARY_DAMPENING, 1.0 )
    local vForward = angThrow:Forward()

    local vecSrc = owner:GetShootPos()

    vecSrc:Add(Vector(0, 0, Lerp( flClampedThrowStrength, -GRENADE_SECONDARY_LOWER, 0.0 ) ))

    -- We want to throw the grenade from 16 units out.  But that can cause problems if we're facing
    -- a thin wall.  Do a hull trace to be safe.
    -- Wills: Moved the trace length out to 22 inches, then subtract 6. This way we default to 16, 
    -- but pull back 6 from wherever we hit, so we don't emit from EXACTLY inside the close surface, which can lead to 
    -- the grenade penetrating the wall anyway.
    local trace = {}
    local mins = -Vector(2,2,2)
    util.TraceHull({
        start = vecSrc,
        endpos = vecSrc + vForward * 22,
        mins = mins,
        maxs = -mins,
        mask = bit.bor(MASK_SOLID, CONTENTS_GRENADECLIP),
        filter = owner,
        collisiongroup = COLLISION_GROUP_NONE,
        output = trace
    })
    vecSrc = trace.HitPos - (vForward * 6)

    local vecThrow = vForward * flVel + (owner:GetVelocity() * 1.25)

    local iSeed = self:GetRandomSeed()
    iSeed = iSeed + 1
    self:SetRandomSeed(iSeed)

    local random = UniformRandomStream(iSeed)

    self:EmitGrenade(vecSrc, angle_zero, vecThrow, Angle(600, random:RandomInt(-1200,1200)), owner)

    self.m_bHasEmittedProjectile = true -- Flag the grenade weapon as having emitted a projectile. The 'grenade' is now flying away from the player, so we don't want to drop *this* grenade on death (that'll make a duplicate)
    self:SetRedraw(true)
    self:SetIsHeldByPlayer(false)
    self:SetThrowTime(0)
end

function SWEP:EmitGrenade(vecSrc, angles, vecVel, vecAngImpulse, owner)
    assert(false, "swcs_base_grenade:EmitGrenade() should not be called. Make sure to implement this in your subclass!\n")
end
