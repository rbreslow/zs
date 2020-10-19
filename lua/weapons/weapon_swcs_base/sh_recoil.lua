AddCSLuaFile()

local weapon_air_spread_scale = GetConVar"weapon_air_spread_scale"
local weapon_recoil_decay_coefficient = GetConVar"weapon_recoil_decay_coefficient"
local weapon_accuracy_nospread = GetConVar"weapon_accuracy_nospread"
local weapon_recoil_suppression_shots = CreateConVar("weapon_recoil_suppression_shots", "4")
local weapon_recoil_suppression_factor = CreateConVar("weapon_recoil_suppression_factor", "0.75")
local weapon_recoil_variance = CreateConVar("weapon_recoil_variance", "0.55")

function SWEP:GenerateRecoilTable(data)
    local iSuppressionShots = weapon_recoil_suppression_shots:GetInt()
    local fBaseSuppressionFactor = weapon_recoil_suppression_factor:GetFloat()
    local fRecoilVariance = weapon_recoil_variance:GetFloat()
    local recoilRandom = UniformRandomStream()

    if not data then return end

    local iSeed = 0
    local bHasAttrSeed = false
    local bFullAuto = false
    local bHasAttrFullAuto = false
    local flRecoilAngle = {}
    local bHasAttrRecoilAngle = {}
    local flRecoilAngleVariance = {}
    local bHasAttrRecoilAngleVariance = {}
    local flRecoilMagnitude = {}
    local bHasAttrRecoilMagnitude = {}
    local flRecoilMagnitudeVariance = {}
    local bHasAttrRecoilMagnitudeVariance = {}

    if self.ItemAttributes then
        iSeed = tonumber(self.ItemAttributes["recoil seed"])
        bFullAuto = tobool(self.ItemAttributes["is full auto"])
        for iMode = 0, 1 do
            local isAlt = iMode == 1 and " alt" or ""

            flRecoilAngle[iMode] = self.ItemAttributes["recoil angle" .. isAlt]
            bHasAttrRecoilAngle[iMode] = self.ItemAttributes["recoil angle" .. isAlt] ~= nil
            flRecoilAngleVariance[iMode] = self.ItemAttributes["recoil angle variance" .. isAlt]
            bHasAttrRecoilAngleVariance[iMode] = self.ItemAttributes["recoil angle variance" .. isAlt] ~= nil
            flRecoilMagnitude[iMode] = self.ItemAttributes["recoil magnitude" .. isAlt]
            bHasAttrRecoilMagnitude[iMode] = self.ItemAttributes["recoil magnitude" .. isAlt] ~= nil
            flRecoilMagnitudeVariance[iMode] = self.ItemAttributes["recoil magnitude variance" .. isAlt]
            bHasAttrRecoilMagnitudeVariance[iMode] = self.ItemAttributes["recoil magnitude variance" .. isAlt] ~= nil
        end

        bHasAttrSeed = iSeed ~= nil
        bHasAttrFullAuto = bFullAuto ~= nil
    end

    for iMode = 0, 1 do
        data[iMode] = data[iMode] or {}
        assert(bHasAttrSeed, "no recoil seed attribute")
        assert(bHasAttrFullAuto, "no full auto attribute")

        flRecoilAngle[iMode] = flRecoilAngle[iMode] or 0
        assert(bHasAttrRecoilAngleVariance[iMode], Format("no recoil angle variance attribute on iMode: %d", iMode))
        assert(bHasAttrRecoilMagnitude[iMode], Format("no recoil magnitude attribute on iMode: %d", iMode))
        assert(bHasAttrRecoilMagnitudeVariance[iMode], Format("no recoil magnitude variance attribute on iMode: %d", iMode))

        recoilRandom:SetSeed(iSeed)
        local fAngle = 0
        local fMagnitude = 0

        -- data->recoilTable[64] has 64 elements; [0-63]
        -- start it at 0 just for solidarity
        for j = 0, 63 do
            data[iMode][j] = data[iMode][j] or {}

            local fAngleNew = flRecoilAngle[iMode] + recoilRandom:RandomFloat(- flRecoilAngleVariance[iMode], flRecoilAngleVariance[iMode] );
            local fMagnitudeNew = flRecoilMagnitude[iMode] + recoilRandom:RandomFloat(- flRecoilMagnitudeVariance[iMode], flRecoilMagnitudeVariance[iMode] );

            if ( bFullAuto and ( j > 0 ) ) then
                fAngle = Lerp( fRecoilVariance, fAngle, fAngleNew )
                fMagnitude = Lerp( fRecoilVariance, fMagnitude, fMagnitudeNew )
            else
                fAngle = fAngleNew
                fMagnitude = fMagnitudeNew
            end

            if ( bFullAuto and ( j < iSuppressionShots ) ) then
                local fSuppressionFactor = Lerp( j / iSuppressionShots, fBaseSuppressionFactor, 1.0 );
                fMagnitude = fMagnitude * fSuppressionFactor;
            end

            data[iMode][j].fAngle = fAngle;
            data[iMode][j].fMagnitude = fMagnitude;
        end
    end
end

-- csgo originally has this at 1.1
-- i have it at 1.25 because some servers have low tickrate, which causes erroneous decay
local WEAPON_RECOIL_DECAY_THRESHOLD = 1.25
function SWEP:UpdateAccuracyPenalty()
    local owner = self:GetPlayerOwner()
    if not owner then return end

    local fNewPenalty = 0

    if owner:GetMoveType() == MOVETYPE_LADDER then
        fNewPenalty = fNewPenalty + self:GetInaccuracyLadder()
    elseif not owner:IsFlagSet(FL_ONGROUND) then
        fNewPenalty = fNewPenalty + self:GetInaccuracyStand()
        fNewPenalty = fNewPenalty + self:GetInaccuracyJump() * weapon_air_spread_scale:GetFloat()
    elseif owner:Crouching() then
        fNewPenalty = fNewPenalty + self:GetInaccuracyCrouch()
    else
        fNewPenalty = fNewPenalty + self:GetInaccuracyStand()
    end

    if self:GetInReload() then
        fNewPenalty = fNewPenalty + self:GetInaccuracyReload()
    end

    if fNewPenalty > self:GetAccuracyPenalty() then
        self:SetAccuracyPenalty(fNewPenalty)
    else
        local fDecayFactor = math.log(10) / self:GetRecoveryTime()
        self:SetAccuracyPenalty(Lerp(math.exp(engine.TickInterval() * -fDecayFactor), fNewPenalty, self:GetAccuracyPenalty()))
    end

    -- Decay the recoil index if a little more than cycle time has elapsed since the last shot. In other words,
    -- don't decay if we're firing full-auto.
    if SWCS_DEBUG_RECOIL_DECAY:GetBool() then
        print("should decay?", self, CurTime(), self:LastShootTime() + (self:GetCycleTime() * WEAPON_RECOIL_DECAY_THRESHOLD), CurTime() > self:LastShootTime() + (self:GetCycleTime() * WEAPON_RECOIL_DECAY_THRESHOLD))
    end
    if CurTime() > self:LastShootTime() + (self:GetCycleTime() * WEAPON_RECOIL_DECAY_THRESHOLD) then
        local fDecayFactor = math.log(10) * weapon_recoil_decay_coefficient:GetFloat()
        self:SetRecoilIndex(Lerp(math.exp(engine.TickInterval() * -fDecayFactor), 0, self:GetRecoilIndex()))
    end
end

function SWEP:GetRecoveryTime()
    local owner = self:GetPlayerOwner()
    if not owner then return -1 end

    if owner:GetMoveType() == MOVETYPE_LADDER then
        return self:GetRecoveryTimeStand()
    elseif not owner:IsFlagSet(FL_ONGROUND) then -- in air
        return self:GetRecoveryTimeCrouch()
    elseif owner:IsFlagSet(FL_DUCKING) then
        local flRecoveryTime = self:GetRecoveryTimeCrouch()
        local flRecoveryTimeFinal = self:GetRecoveryTimeCrouchFinal()

        if flRecoveryTimeFinal ~= -1 then
            local nRecoilIndex = math.floor(self:GetRecoilIndex())

            flRecoveryTime = util.RemapValClamped( nRecoilIndex, self:GetRecoveryTransitionStartBullet() or 0, self:GetRecoveryTransitionEndBullet() or 0, flRecoveryTime, flRecoveryTimeFinal )
        end

        return flRecoveryTime
    else
        local flRecoveryTime = self:GetRecoveryTimeStand()
        local flRecoveryTimeFinal = self:GetRecoveryTimeStandFinal()

        if flRecoveryTimeFinal ~= -1 then
            local nRecoilIndex = math.floor(self:GetRecoilIndex())

            flRecoveryTime = util.RemapValClamped( nRecoilIndex, self:GetRecoveryTransitionStartBullet() or 0, self:GetRecoveryTransitionEndBullet() or 0, flRecoveryTime, flRecoveryTimeFinal )
        end

        return flRecoveryTime
    end
end

local CS_PLAYER_SPEED_DUCK_MODIFIER = .34
local MOVEMENT_CURVE01_EXPONENT = .25
local weapon_accuracy_forcespread = GetConVar"weapon_accuracy_forcespread"
function SWEP:GetInaccuracy()
    local owner = self:GetPlayerOwner()
    if not owner then return 0 end
    if weapon_accuracy_nospread:GetBool() then return 0 end
    if weapon_accuracy_forcespread:GetFloat() > 0 then return weapon_accuracy_forcespread:GetFloat() end

    local fMaxSpeed = self:GetMaxSpeed()
    local fAccuracy = self:GetAccuracyPenalty()
    local flVerticalSpeed = math.abs(owner:GetVelocity().z)

    local flMovementInaccuracyScale = util.RemapValClamped(owner:GetVelocity():Length2D(),
        fMaxSpeed * CS_PLAYER_SPEED_DUCK_MODIFIER,
        fMaxSpeed * .95,
        0, 1)

    if flMovementInaccuracyScale > 0 then
        if not owner:KeyDown(IN_WALK) then
            flMovementInaccuracyScale = math.pow(flMovementInaccuracyScale, MOVEMENT_CURVE01_EXPONENT)
        end

        fAccuracy = fAccuracy + (flMovementInaccuracyScale * self:GetInaccuracyMove())
    end

    if not owner:IsFlagSet(FL_ONGROUND) then
        local flInaccuracyJumpInitial = self:GetInaccuracyJumpInitial() * weapon_air_spread_scale:GetFloat()
        local kMaxFallingPenalty = 2.0

        local fSqrtMaxJumpSpeed = math.sqrt(owner:GetJumpPower())
        local fSqrtVerticalSpeed = math.sqrt(flVerticalSpeed)

        local flAirSpeedInaccuracy = util.RemapVal(fSqrtVerticalSpeed,
            fSqrtMaxJumpSpeed * .25,
            fSqrtMaxJumpSpeed,
            0,
            flInaccuracyJumpInitial)

        if flAirSpeedInaccuracy < 0 then
            flAirSpeedInaccuracy = 0
        elseif (flAirSpeedInaccuracy > (kMaxFallingPenalty * flInaccuracyJumpInitial)) then
            flAirSpeedInaccuracy = kMaxFallingPenalty * flInaccuracyJumpInitial
        end

        -- this is currently wrong,
        -- pls do not commit or ur a dumbass
        -- cl_weapon_debug_print_accuracy 1 's Inaccuracy shouldn't go below 0.5 when jumping

        --[[if fSqrtVerticalSpeed <= 9.8 then
            fAccuracy = fAccuracy + self:GetInaccuracyJumpApex()
        end]]

        fAccuracy = fAccuracy + flAirSpeedInaccuracy
    end

    if fAccuracy > 1 then
        fAccuracy = 1
    end

    return fAccuracy
end

function SWEP:GetRecoilOffset(iMode, iIndex)
    if not self.m_RecoilData or table.IsEmpty(self.m_RecoilData) then
        ErrorNoHalt("Generating recoil table too late")

        self.m_RecoilData = {}
        self:GenerateRecoilTable(self.m_RecoilData)
    end

    iIndex = iIndex % 63

    local elem = self.m_RecoilData[iMode][iIndex]
    if elem then
        return elem.fAngle, elem.fMagnitude
    else
        return 0, 0
    end
end

local weapon_recoil_view_punch_extra = GetConVar"weapon_recoil_view_punch_extra"
function SWEP:Recoil(iMode)
    local owner = self:GetPlayerOwner()
    if not owner then return end

    if SWCS_DEBUG_RECOIL:GetBool() then
        print(Format("recoiling on %s index: %f", self, self:GetRecoilIndex()))
    end

    local iIndex = math.floor(self:GetRecoilIndex())
    local fAngle, fMagnitude = self:GetRecoilOffset(iMode, iIndex)

    local angleVel = Angle()
    angleVel.y = -math.sin(math.rad(fAngle)) * fMagnitude
    angleVel.p = -math.cos(math.rad(fAngle)) * fMagnitude
    angleVel = angleVel + self:GetAimPunchAngleVel()
    self:SetAimPunchAngleVel(angleVel)

    -- this bit gives additional punch to the view (screen shake) to make the kick back a bit more visceral
    local viewPunch = self:GetViewPunchAngle()
    local fViewPunchMagnitude = fMagnitude * weapon_recoil_view_punch_extra:GetFloat()
    viewPunch.y = viewPunch.y - math.sin(math.rad(fAngle)) * fViewPunchMagnitude
    viewPunch.p = viewPunch.p - math.cos(math.rad(fAngle)) * fViewPunchMagnitude
    viewPunch:Normalize()

    self:SetViewPunchAngle(viewPunch)
end

-- decay angles in PlayerMove()
function SWEP:OnMove(move, cmd)
    self:DecayViewPunchAngle()
    self:DecayAimPunchAngle()
end

local function DecayAngles(v, fExp, fLin, dT)
    v = Vector(v.x, v.y, v.z)
    fExp = fExp * dT
    fLin = fLin * dT

    v:Mul(math.exp(-fExp))

    local fMag = v:Length()
    if fMag > fLin then
        v:Mul(1 - fLin / fMag)
    else
        v:Set(vector_origin)
    end

    return Angle(v.x, v.y, v.z)
end

local view_punch_decay = CreateConVar("view_punch_decay", "18", nil, "Decay factor exponent for view punch")
function SWEP:DecayViewPunchAngle()
    local punchAng = self:GetViewPunchAngle()
    punchAng:Normalize()
    local decayedAng = DecayAngles(punchAng, view_punch_decay:GetFloat(), 0, engine.TickInterval())
    decayedAng:Normalize()

    self:SetViewPunchAngle(decayedAng)
end

local weapon_recoil_decay2_exp = CreateConVar("weapon_recoil_decay2_exp", "8", nil, "Decay factor exponent for weapon recoil")
local weapon_recoil_decay2_lin = CreateConVar("weapon_recoil_decay2_lin", "18", nil, "Decay factor (linear term) for weapon recoil")
local weapon_recoil_vel_decay = CreateConVar("weapon_recoil_vel_decay", "4.5", nil, "Decay factor for weapon recoil velocity")
function SWEP:DecayAimPunchAngle()
    local punchAng = self:GetRawAimPunchAngle()
    local punchAngVel = self:GetAimPunchAngleVel()
    punchAng:Normalize()
    punchAngVel:Normalize()

    local new = DecayAngles(punchAng, weapon_recoil_decay2_exp:GetFloat(), weapon_recoil_decay2_lin:GetFloat(), engine.TickInterval())
    new:Normalize()
    punchAng = new + (punchAngVel * engine.TickInterval() * .5)

    punchAngVel = punchAngVel * math.exp(engine.TickInterval() * -weapon_recoil_vel_decay:GetFloat())

    punchAng = punchAng + (punchAngVel * engine.TickInterval() * .5)

    punchAng:Normalize()
    punchAngVel:Normalize()

    self:SetRawAimPunchAngle(punchAng)
    self:SetAimPunchAngleVel(punchAngVel)
end
