function util.ClipPunchAngleOffset(angIn, angPunch, angClip)
	if not (angIn or isangle(angIn)) or not (angPunch or isangle(angPunch)) or not (angClip or not isangle(angClip)) then return end
	local final = angIn + angPunch

	for i = 1,3 do
		if final[i] > angClip[i] then
			final[i] = angClip[i]
		elseif final[i] < -angClip[i] then
			final[i] = -angClip[i]
		end
		final[i] = final[i] - angPunch[i]
	end

	-- cpp version sets angIn's x,y,z
	return final
end

if not util.ImpactTrace then
	function util.ImpactTrace(tr, iDamageType, effect)
		if not tr.Entity or tr.HitSky then
			return end
		if tr.Fraction == 1 then
			return end
		if tr.HitNoDraw then
			return end

		local data = EffectData()
		data:SetOrigin(tr.HitPos)
		data:SetStart(tr.StartPos)
		data:SetSurfaceProp(tr.SurfaceProps)
		data:SetDamageType(iDamageType)
		data:SetHitBox(tr.HitBox)
		data:SetEntity(tr.Entity)

		if SERVER or (CLIENT and IsFirstTimePredicted()) then
			util.Effect(effect or "Impact", data, not game.SinglePlayer())
		end
	end
end

local FX_WATER_IN_SLIME = 0x1
function util.BulletImpact(tr, ply)
	-- see if the bullet ended up underwater and started out of the water
	if bit.band(util.PointContents(tr.HitPos), bit.bor(CONTENTS_WATER, CONTENTS_SLIME)) ~= 0 then
		local waterTrace = {}
		util.TraceLine({
			start = tr.StartPos,
			endpos = tr.HitPos,
			mask = bit.bor(MASK_SHOT,CONTENTS_WATER,CONTENTS_SLIME),
			filter = ply,
			collisiongroup = COLLISION_GROUP_NONE,
			output = waterTrace,
		})

		if not waterTrace.AllSolid then
			local data = EffectData()
			data:SetOrigin(waterTrace.HitPos)
			data:SetNormal(waterTrace.HitNormal)
			data:SetScale(UniformRandomStream():RandomFloat(8, 12))

			if bit.band(waterTrace.Contents, CONTENTS_SLIME) ~= 0 then
				data:SetFlags(bit.bor(data:GetFlags(), FX_WATER_IN_SLIME))
			end

			if SERVER and IsValid(ply) and ply:IsPlayer() then
				SuppressHostEvents(ply)
			end

			if SERVER or (CLIENT and IsFirstTimePredicted()) then
				util.Effect("gunshotsplash", data, not game.SinglePlayer())
			end

			return
		end
	end

	if SERVER and IsValid(ply) and ply:IsPlayer() then
		SuppressHostEvents(ply)
	end

	util.ImpactTrace(tr, DMG_BULLET)
end

function util.CalculateMeleeDamageForce(info, vecMeleeDir, vecForceOrigin, flScale)
	info:SetDamagePosition(vecForceOrigin)

	-- Calculate an impulse large enough to push a 75kg man 4 in/sec per point of damage
	local flForceScale = info:GetBaseDamage() * (75 * 4)
	local vecForce = vecMeleeDir
	vecForce:Normalize()
	vecForce = vecForce * flForceScale
	vecForce = vecForce * GetConVar("phys_pushscale"):GetFloat()
	vecForce = vecForce * flScale
	info:SetDamageForce(vecForce)
end

function util.CreateCombineBall(vecOrigin, vecVel, flRadius, flMass, flLifeTime, entOwner)
	local ball = ents.Create("prop_combine_ball")
	ball:SetSaveValue("m_flRadius", flRadius)

	ball:SetPos(vecOrigin)
	ball:SetOwner(entOwner)

	ball:SetVelocity(vecVel)
	ball:Spawn()

	ball:SetSaveValue("m_nState", 2)
	ball:SetSaveValue("m_flSpeed", vecVel:Length())

	ball:EmitSound("NPC_CombineBall.Launch")

	local phys = ball:GetPhysicsObject()
	if IsValid(phys) then
		phys:AddGameFlag(FVPHYSICS_WAS_THROWN)
		phys:SetMass(flMass)
		phys:SetVelocity(vecVel)
	end

	ball:SetSaveValue("m_bWeaponLaunched", true)
	ball:SetSaveValue("m_bLaunched", true)

	-- isnt the best but oh well
	timer.Simple(flLifeTime, function()
		if IsValid(ball) and ball:GetInternalVariable("m_bHeld") == false then
			ball:Fire("Explode")
		end
	end)

	return ball
end

local function fsel(c, x, y)
	return c >= 0 and x or y
end
function util.RemapVal(val,a,b,c,d)
	if a == b then
		return fsel(val - b, d, c)
	end
	return c + (d - c) * (val - a) / (b - a)
end
function util.RemapValClamped(val,a,b,c,d)
	if a == b then
		return fsel(val - b, d, c)
	end

	local cVal = (val - a) / (b - a)
	cVal = math.Clamp(cVal, 0, 1)
	return c + (d - c) * cVal
end

local lastAmt = -1
local lastExponent = -1
function util.Bias(x, biasAmt)
	if lastAmt ~= biasAmt then
		lastExponent = math.log(biasAmt) * -1.4427 -- (-1.4427 = 1 / log(0.5))
	end

	return math.pow(x, lastExponent)
end

function util.Gain(x, biasAmt)
	if x < 0.5 then
		return 0.5 * util.Bias(2 * x, 1-biasAmt)
	else
		return 1 - 0.5 * util.Bias(2 - 2 * x, 1-biasAmt)
	end
end

-- hammer to irl measurements
do
	local UNIT_TO_INCH = .75
	local INCH_TO_CM = 2.54
	function util.HUtoInch(units)
		return units * UNIT_TO_INCH
	end
	function util.HUtoCM(units)
		return util.HUtoInch(units) * INCH_TO_CM
	end
	function util.NiceMetric(cm)
		local m = cm / 100
		return string.format("%.1f%s", m >= 1 and m or cm, m >= 1 and "m" or "cm")
	end
end

-- IronSightController
do
	local Gain = util.Gain
	local Bias = util.Bias
	local IRONSIGHT_ANGLE_AVERAGE_SIZE = 8
	local IRONSIGHT_ANGLE_AVERAGE_DIVIDE = 1 / IRONSIGHT_ANGLE_AVERAGE_SIZE

	local IronSight_should_approach_unsighted = 0
	local IronSight_should_approach_sighted = 1
	local IronSight_viewmodel_is_deploying = 2
	local IronSight_weapon_is_dropped = 3

	local IRONSIGHT_HIDE_CROSSHAIR_THRESHOLD = 0.5

	local IRONSIGHT_VIEWMODEL_BOB_MULT_X = 0.05
	local IRONSIGHT_VIEWMODEL_BOB_PERIOD_X = 6
	local IRONSIGHT_VIEWMODEL_BOB_MULT_Y = 0.1
	local IRONSIGHT_VIEWMODEL_BOB_PERIOD_Y = 10

	local META = {
		m_bIronSightAvailable			= false,
		m_angPivotAngle					= Angle(),
		m_vecEyePos						= Vector(),

		m_flIronSightAmount				= 0.0,
		m_flIronSightPullUpSpeed		= 8.0,
		m_flIronSightPutDownSpeed		= 4.0,
		m_flIronSightFOV				= 80.0,
		m_flIronSightPivotForward		= 10.0,
		m_flIronSightLooseness			= 0.5,
		m_pAttachedWeapon				= NULL,

		-- client only
		m_angDeltaAverage				= {},
		m_angViewLast					= Angle(),
		m_vecDotCoords					= Vector(),
		m_flDotBlur						= 0.0,
		m_flSpeedRatio					= 0.0,
	}

	for i = 0, IRONSIGHT_ANGLE_AVERAGE_SIZE do
		META.m_angDeltaAverage[i] = Angle()
	end
	META.__index = META
	META.__tostring = function(self)
		return "IronSightController [" .. tostring(self.m_pAttachedWeapon) .. "]"
	end

	function META:IsApproachingSighted()
		return IsValid(self.m_pAttachedWeapon) and self.m_pAttachedWeapon:GetIronSightMode() == IronSight_should_approach_sighted
	end
	function META:IsApproachingUnSighted()
		return IsValid(self.m_pAttachedWeapon) and self.m_pAttachedWeapon:GetIronSightMode() == IronSight_should_approach_unsighted
	end
	function META:IsDeploying()
		return IsValid(self.m_pAttachedWeapon) and self.m_pAttachedWeapon:GetIronSightMode() == IronSight_viewmodel_is_deploying
	end
	function META:IsDropped()
		return IsValid(self.m_pAttachedWeapon) and self.m_pAttachedWeapon:GetIronSightMode() == IronSight_weapon_is_dropped
	end

	function META:UpdateIronSightAmount()
		if not IsValid(self.m_pAttachedWeapon) or self:IsDropped() or self:IsDeploying() then
			-- ignore and discard any lingering ironsight amount.
			self.m_flIronSightAmount = 0.0
			self.m_flIronSightAmountGained = 0.0
			return
		end

		-- first determine if we are going into or out of ironsights, and set m_flIronSightAmount accordingly
		local flIronSightAmountTarget = self:IsApproachingSighted() and 1.0 or 0.0
		local flIronSightUpdOrDownSpeed = self:IsApproachingSighted() and self.m_flIronSightPullUpSpeed or self.m_flIronSightPutDownSpeed

		self.m_flIronSightAmount = math.Approach(self.m_flIronSightAmount, flIronSightAmountTarget, FrameTime() * flIronSightUpdOrDownSpeed)

		self.m_flIronSightAmountGained = Gain( self.m_flIronSightAmount, 0.8 )
		self.m_flIronSightAmountBiased = Bias( self.m_flIronSightAmount, 0.2 )
	end

	function META:IsInIronSight()
		if IsValid(self.m_pAttachedWeapon) then
			if self:IsDeploying() or
				self:IsDropped() or
				self.m_pAttachedWeapon:GetInReload() or
				self.m_pAttachedWeapon:GetDoneSwitchingSilencer() >= CurTime() then
				return false
			end

			-- if looking at wep, return false

			if self.m_flIronSightAmount > 0 and (self:IsApproachingSighted() or self:IsApproachingUnSighted()) then
				return true
			end
		end

		return false
	end

	local function AngleDiff(destAngle, srcAngle)
		local delta = math.fmod(destAngle - srcAngle, 360)
		if destAngle > srcAngle then
			if delta >= 180 then
				delta = delta - 360
			end
		else
			if delta <= -180 then
				delta = delta + 360
			end
		end

		return delta
	end

	function META:QAngleDiff(angTarget, angSrc)
		return Angle(	AngleDiff(angTarget.x, angSrc.x),
						AngleDiff(angTarget.y, angSrc.y),
						AngleDiff(angTarget.z, angSrc.z) )
	end

	function META:AddToAngleAverage(newAngle)
		if self.m_flIronSightAmount < 1 then return end

		newAngle.x = math.Clamp(newAngle.x, -2, 2)
		newAngle.y = math.Clamp(newAngle.y, -2, 2)
		newAngle.z = math.Clamp(newAngle.z, -2, 2)

		-- essentially table.insert
		for i = IRONSIGHT_ANGLE_AVERAGE_SIZE, 0, -1 do
			self.m_angDeltaAverage[i] = self.m_angDeltaAverage[i - 1]
		end

		self.m_angDeltaAverage[0] = newAngle
	end

	function META:GetAngleAverage()
		local temp = Angle()

		if self.m_flIronSightAmount < 1 then return temp end

		for i = 0, IRONSIGHT_ANGLE_AVERAGE_SIZE do
			temp = temp + self.m_angDeltaAverage[i]
		end

		return temp * IRONSIGHT_ANGLE_AVERAGE_DIVIDE
	end

	local ironsight_catchupspeed = 60
	function META:ApplyIronSightPositioning(vecPosition, angAngle)
		self:UpdateIronSightAmount()

		if self.m_flIronSightAmount == 0 then return end

		if self.m_pAttachedWeapon:GetPlayerOwner() then
			local ply = self.m_pAttachedWeapon:GetPlayerOwner()
			self.m_flSpeedRatio = math.Approach(self.m_flSpeedRatio, ply:GetAbsVelocity():Length() / self.m_pAttachedWeapon:GetMaxSpeed(), FrameTime() * 10)
		end

		-- if we're more than 10% ironsighted, apply looseness.
		if self.m_flIronSightAmount > 0.1 then
			-- get the difference between current angles and last angles
			local angDelta = self:QAngleDiff(self.m_angViewLast, angAngle)

			-- dampen the delta to simulate 'looseness', but the faster we move, the more looseness approaches ironsight_running_looseness.GetFloat(), which is as waggly as possible
			self:AddToAngleAverage(angDelta * Lerp(self.m_flSpeedRatio, self.m_flIronSightLooseness, .3))
			self.m_angViewLast:Sub(angDelta * math.Clamp(FrameTime() * ironsight_catchupspeed, 0, 1))
		else
			self.m_angViewLast = angAngle
		end

		-- now the fun part - move the viewmodel to look down the sights

		-- create a working matrix at the current eye position and angles
		local matIronSightMatrix = Matrix()
		matIronSightMatrix:Translate(vecPosition)
		matIronSightMatrix:SetAngles(angAngle)

		-- offset the matrix by the ironsight eye position
		matIronSightMatrix:Translate((-self.m_vecEyePos) * self.m_flIronSightAmountGained)

		-- additionally offset by the ironsight origin of rotation, the weapon will pivot around this offset from the eye
		matIronSightMatrix:Translate(Vector(self.m_flIronSightPivotForward, 0, 0))

		local angDeltaAverage = self:GetAngleAverage()

		-- apply ironsight eye rotation
		-- use schema defined angles
		local wtf = Angle()
		wtf:RotateAroundAxis(Vector(1, 0, 0), (angDeltaAverage.z + self.m_angPivotAngle.z) * self.m_flIronSightAmountGained)
		wtf:RotateAroundAxis(Vector(0, 1, 0), (angDeltaAverage.x + self.m_angPivotAngle.x) * self.m_flIronSightAmountGained)
		wtf:RotateAroundAxis(Vector(0, 0, 1), (angDeltaAverage.y + self.m_angPivotAngle.y) * self.m_flIronSightAmountGained)
		matIronSightMatrix:Rotate(wtf)

		-- move the weapon back to the ironsight eye position
		matIronSightMatrix:Translate(Vector(-self.m_flIronSightPivotForward, 0, 0))

		-- if the player is moving, pull down and re-bob the weapon
		if self.m_pAttachedWeapon:GetPlayerOwner() then
			local vecIronSightBob = Vector(
				1,
				IRONSIGHT_VIEWMODEL_BOB_MULT_X * math.sin(CurTime() * IRONSIGHT_VIEWMODEL_BOB_PERIOD_X),
				IRONSIGHT_VIEWMODEL_BOB_MULT_Y * math.sin(CurTime() * IRONSIGHT_VIEWMODEL_BOB_PERIOD_Y) - IRONSIGHT_VIEWMODEL_BOB_MULT_Y
			)

			self.m_vecDotCoords.x = -vecIronSightBob.y
			self.m_vecDotCoords.y = -vecIronSightBob.z
			self.m_vecDotCoords:Mul(0.1)
			self.m_vecDotCoords.x = self.m_vecDotCoords.x - angDeltaAverage.y * 0.03
			self.m_vecDotCoords.y = self.m_vecDotCoords.y + angDeltaAverage.x * 0.03
			self.m_vecDotCoords:Mul(self.m_flSpeedRatio)

			--[[
				if ( !cl_righthand.GetBool() )
					vecIronSightBob.y = -vecIronSightBob.y;
			]]

			matIronSightMatrix:Translate(vecIronSightBob * self.m_flSpeedRatio)
		end

		-- extract the final position and angles and apply them as differences from the passed in values
		vecPosition:Sub(vecPosition - matIronSightMatrix:GetTranslation())

		local angIronSightAngles = matIronSightMatrix:GetAngles()
		angAngle:Sub(self:QAngleDiff(angAngle, angIronSightAngles))

		--dampen dot blur
		self.m_flDotBlur = math.Approach(self.m_flDotBlur, 0, FrameTime() * 2)
	end

	function META:SetState(newState)
		if newState == IronSight_viewmodel_is_deploying or newState == IronSight_weapon_is_dropped then
			self.m_flIronSightAmount = 0
		end
		if self.m_pAttachedWeapon:IsValid() and self.m_pAttachedWeapon.IsSWCSWeapon then
			self.m_pAttachedWeapon:SetIronSightMode(newState)
		end
	end

	function META:IsInitializedAndAvailable()
		return self.m_bIronSightAvailable
	end

	function META:Init(wep)
		if self:IsInitializedAndAvailable() then return true end

		if wep:IsValid() and wep:IsWeapon() then
			if wep.is_aug then
				self.m_pAttachedWeapon = wep

				self.m_bIronSightAvailable			= true
				self.m_flIronSightLooseness			= 0.03
				self.m_flIronSightPullUpSpeed		= 10.0
				self.m_flIronSightPutDownSpeed		= 8.0
				self.m_flIronSightFOV				= 45.0
				self.m_flIronSightPivotForward		= 10.0
				self.m_vecEyePos						= Vector( -1.56, -3.6, -0.07 )
				self.m_angPivotAngle					= Angle( 0.78, -0.1, -0.03 )

				return true
			elseif wep.is_sg556 then
				self.m_pAttachedWeapon = wep

				self.m_bIronSightAvailable			= true
				self.m_flIronSightLooseness			= 0.03
				self.m_flIronSightPullUpSpeed		= 10.0
				self.m_flIronSightPutDownSpeed		= 8.0
				self.m_flIronSightFOV				= 45.0
				self.m_flIronSightPivotForward		= 8.0
				self.m_vecEyePos						= Vector(0.72, -5.12, -1.33)
				self.m_angPivotAngle					= Angle(0.52, 0.04, 0.72)

				return true
			end

			if tobool(wep.ItemAttributes["aimsight capable"]) then
				self.m_bIronSightAvailable = true
				self.m_pAttachedWeapon = wep

				self.m_flIronSightLooseness = tonumber(wep.ItemAttributes["aimsight looseness"])
				self.m_flIronSightPullUpSpeed = tonumber(wep.ItemAttributes["aimsight speed up"])
				self.m_flIronSightPutDownSpeed = tonumber(wep.ItemAttributes["aimsight speed down"])
				self.m_flIronSightFOV = tonumber(wep.ItemAttributes["aimsight fov"])
				self.m_flIronSightPivotForward = tonumber(wep.ItemAttributes["aimsight pivot forward"])
				self.m_vecEyePos = Vector(wep.ItemAttributes["aimsight eye pos"])
				self.m_angPivotAngle = Angle(wep.ItemAttributes["aimsight pivot angle"])

				return true
			end
		end

		return false
	end

	function META:ShouldHideCrossHair()
		return (self:IsApproachingSighted() or self:IsApproachingUnSighted()) and self.m_flIronSightAmount > IRONSIGHT_HIDE_CROSSHAIR_THRESHOLD
	end

	function META:GetDotMaterial()
		if self.m_pAttachedWeapon:IsValid() and self.m_pAttachedWeapon.is_aug then
			return "models/weapons/shared/scope/scope_dot_green"
		else
			return "models/weapons/shared/scope/scope_dot_red"
		end
	end
	function META:IncreaseDotBlur(flAmount)
		self.m_flDotBlur = math.Clamp(self.m_flDotBlur + flAmount, 0, 1)
	end
	function META:GetDotBlur()
		return Bias(1 - math.max(self.m_flDotBlur, self.m_flSpeedRatio * 0.5), 0.2)
	end
	function META:GetDotWidth()
		return 32 + (256 * math.max(self.m_flDotBlur, self.m_flSpeedRatio * 0.3))
	end

	function META:GetIronSightFOV(flDefaultFOV, bUseBiasedValue)
		-- sets biased value between the current FOV and the ideal IronSight FOV based on how 'ironsighted' the weapon currently is
		if not self:IsInIronSight() then
			return flDefaultFOV end

		local flIronSightFOVAmount = bUseBiasedValue and self.m_flIronSightAmountBiased or self.m_flIronSightAmount

		--print(flIronSightFOVAmount, bUseBiasedValue, Lerp(flIronSightFOVAmount, flDefaultFOV, self.m_flIronSightFOV))

		return Lerp(flIronSightFOVAmount, flDefaultFOV, self.m_flIronSightFOV)
	end

	local s_RatioToAspectModes = {
		{ 0, 4.0 / 3.0 },
		{ 1, 16.0 / 9.0 },
		{ 2, 16.0 / 10.0 },
		{ 2, 1.0 },
	}
	local function GetScreenAspectRatio(width, height)
		local aspectRatio = width / height

		-- just find the closest ratio
		local closestAspectRatioDist = 99999.0
		local closestAnamorphic = 0
		for i = 1, #s_RatioToAspectModes do
			local dist = math.abs( s_RatioToAspectModes[i][2] - aspectRatio )
			if (dist < closestAspectRatioDist) then
				closestAspectRatioDist = dist
				closestAnamorphic = s_RatioToAspectModes[i][1]
			end
		end

		return closestAnamorphic
	end

	local function Flerp(f1, f2, i1, i2, x)
		return f1 + (f2 - f1) * (x - i1) / (i2 - i1)
	end

	local function DrawScreenSpaceQuad(pMaterial)
		-- This is required because the texture coordinates for NVidia reading
		-- out of non-power-of-two textures is borked
		local w, h = ScrW(), ScrH()

		if w == 0 or h == 0 then
			return end

		-- This is the size of the back-buffer we're reading from.
		local bw, bh
		bw = w
		bh = h

		--[[/* FIXME: Get this to work in hammer/engine integration
		if ( m_pRenderTargetTexture )
		{
		}
		else
		{
			MaterialVideoMode_t mode;
			GetDisplayMode( mode );
			if ( ( mode.m_Width == 0 ) || ( mode.m_Height == 0 ) )
				return;
			bw = mode.m_Width;
			bh = mode.m_Height;
		}
		*/]]

		local s0, t0;
		local s1, t1;

		local flOffsetS = (bw ~= 0.0) and 1.0 / bw or 0.0
		local flOffsetT = (bh ~= 0.0) and 1.0 / bh or 0.0
		s0 = 0.5 * flOffsetS
		t0 = 0.5 * flOffsetT
		s1 = (w-0.5) * flOffsetS
		t1 = (h-0.5) * flOffsetT

		--Bind( pMaterial );
		local pMesh = Mesh()

		-- push view matrix
		--local MATRIX_VIEW = Matrix()
		--MATRIX_VIEW:Translate(EyePos())
		--MATRIX_VIEW:Translate(EyeAngles():Forward() * 10)
		--MATRIX_VIEW:Rotate(EyeAngles())
		--cam.PushModelMatrix(MATRIX_VIEW, true)

		--MatrixMode( MATERIAL_PROJECTION );
		--PushMatrix();
		--LoadIdentity();

		mesh.Begin(pMesh, MATERIAL_QUADS, 1)

		mesh.Position( Vector(-1.0, -1.0, 0.0) )
		mesh.TangentS( Vector(0.0, 1.0, 0.0) )
		mesh.TangentT( Vector(1.0, 0.0, 0.0) )
		mesh.Normal( Vector(0.0, 0.0, 1.0) )
		mesh.TexCoord( 0, s0, t1 )
		mesh.AdvanceVertex()

		mesh.Position( Vector(-1.0, 1, 0.0) )
		mesh.TangentS( Vector(0.0, 1.0, 0.0) )
		mesh.TangentT( Vector(1.0, 0.0, 0.0) )
		mesh.Normal( Vector(0.0, 0.0, 1.0) )
		mesh.TexCoord( 0, s0, t0 )
		mesh.AdvanceVertex()

		mesh.Position( Vector(1, 1, 0.0) )
		mesh.TangentS( Vector(0.0, 1.0, 0.0) )
		mesh.TangentT( Vector(1.0, 0.0, 0.0) )
		mesh.Normal( Vector(0.0, 0.0, 1.0) )
		mesh.TexCoord( 0, s1, t0 )
		mesh.AdvanceVertex()

		mesh.Position( Vector(1, -1.0, 0.0) )
		mesh.TangentS( Vector(0.0, 1.0, 0.0) )
		mesh.TangentT( Vector(1.0, 0.0, 0.0) )
		mesh.Normal( Vector(0.0, 0.0, 1.0) )
		mesh.TexCoord( 0, s1, t1 )
		mesh.AdvanceVertex()

		mesh.End()

		--cam.IgnoreZ(true)
		pMesh:Draw()

		-- pop view matrix
		--cam.PopModelMatrix()

		--MatrixMode( MATERIAL_PROJECTION );
		--PopMatrix();
	end

	local function DrawScreenSpaceRectangle(pMaterial,
								  nDestX, nDestY, nWidth, nHeight,	-- Rect to draw into in screen space
								  flSrcTextureX0, flSrcTextureY0,		-- which texel you want to appear at destx/y
								  flSrcTextureX1, flSrcTextureY1,		-- which texel you want to appear at destx+width-1, desty+height-1
								  nSrcTextureWidth, nSrcTextureHeight,		-- needed for fixup
								  nXDice, nYDice,							-- Amount to tessellate the mesh
								  fDepth)

		if nWidth <= 0 or nHeight <= 0 or nSrcTextureWidth <= 0 or nSrcTextureHeight <= 0 then
			return end

		fDepth = fDepth or 0
		nXDice = nXDice or 0
		nYDice = nYDice or 0

		local xSegments = math.floor(math.max(nXDice, 1))
		local ySegments = math.floor(math.max(nYDice, 1))

		if xSegments * ySegments < 1 then return end

		local pMesh = Mesh()
		mesh.Begin(pMesh, MATERIAL_QUADS, xSegments * ySegments)
		local nScreenWidth, nScreenHeight = ScrW(), ScrH()

		local flOffset = 0.5

		local flLeftX = nDestX - flOffset
		local flRightX = nDestX + nWidth - flOffset

		local flTopY = nDestY - flOffset
		local flBottomY = nDestY + nHeight - flOffset

		local flSubrectWidth = flSrcTextureX1 - flSrcTextureX0
		local flSubrectHeight = flSrcTextureY1 - flSrcTextureY0

		local flTexelsPerPixelX = ( nWidth > 1 ) and flSubrectWidth / ( nWidth - 1 ) or 0.0
		local flTexelsPerPixelY = ( nHeight > 1 ) and flSubrectHeight / ( nHeight - 1 ) or 0.0

		local flLeftU = flSrcTextureX0 + 0.5 - ( 0.5 * flTexelsPerPixelX )
		local flRightU = flSrcTextureX1 + 0.5 + ( 0.5 * flTexelsPerPixelX )
		local flTopV = flSrcTextureY0 + 0.5 - ( 0.5 * flTexelsPerPixelY )
		local flBottomV = flSrcTextureY1 + 0.5 + ( 0.5 * flTexelsPerPixelY )

		local flOOTexWidth = 1.0 / nSrcTextureWidth
		local flOOTexHeight = 1.0 / nSrcTextureHeight
		flLeftU = flLeftU * flOOTexWidth
		flRightU = flRightU * flOOTexWidth
		flTopV = flTopV * flOOTexHeight
		flBottomV = flBottomV * flOOTexHeight

		local vx, vy, vw, vh = 0, 0, nScreenWidth, nScreenHeight

		flRightX = Flerp( -1, 1, 0, vw, flRightX )
		flLeftX = Flerp( -1, 1, 0, vw, flLeftX )
		flTopY = Flerp( 1, -1, 0, vh ,flTopY )
		flBottomY = Flerp( 1, -1, 0, vh, flBottomY )

		-- Dice the quad up...
		if xSegments > 1 or ySegments > 1 then
			-- Screen height and width of a subrect
			local flWidth  = (flRightX - flLeftX) / xSegments
			local flHeight = (flTopY - flBottomY) / ySegments

			-- UV height and width of a subrect
			local flUWidth  = (flRightU - flLeftU) / xSegments
			local flVHeight = (flBottomV - flTopV) / ySegments

			for x = 0, xSegments do
				for y = 0, ySegments do
					-- Top left
					mesh.Position(Vector(flLeftX + x * flWidth, flTopY - y * flHeight, fDepth))
					mesh.Normal(Vector(0,0,1))
					mesh.TexCoord(0, flLeftU   + x * flUWidth, flTopV + y * flVHeight)
					mesh.TangentS(Vector(0,1,0))
					mesh.TangentT(Vector(1,0,0))
					mesh.AdvanceVertex()

					-- Top right (x + 1)
					mesh.Position(Vector(flLeftX   + (x + 1) * flWidth, flTopY - y * flHeight, fDepth))
					mesh.Normal(Vector(0,0,1))
					mesh.TexCoord(0, flLeftU   + (x + 1) * flUWidth, flTopV + y * flVHeight)
					mesh.TangentS(Vector(0,1,0))
					mesh.TangentT(Vector(1,0,0))
					mesh.AdvanceVertex()

					-- Bottom right (x + 1), (y + 1)
					mesh.Position(Vector(flLeftX   + (x + 1) * flWidth, flTopY - (y + 1) * flHeight, fDepth))
					mesh.Normal(Vector(0,0,1))
					mesh.TexCoord(0, flLeftU   + (x + 1) * flUWidth, flTopV + (y + 1) * flVHeight)
					mesh.TangentS(Vector(0,1,0))
					mesh.TangentT(Vector(1,0,0))
					mesh.AdvanceVertex()

					-- Bottom left (y + 1)
					mesh.Position(Vector(flLeftX   + x * flWidth, flTopY - (y + 1) * flHeight, fDepth))
					mesh.Normal(Vector(0,0,1))
					mesh.TexCoord(0, flLeftU   + x * flUWidth, flTopV + (y + 1) * flVHeight)
					mesh.TangentS(Vector(0,1,0))
					mesh.TangentT(Vector(1,0,0))
					mesh.AdvanceVertex()
				end
			end
		else -- just one quad
			-- for corner=0;corner<4;corner++
			for corner = 0, 3 do
				local bLeft = corner == 0 or corner == 3

				local pos = Vector(bLeft and flLeftX or flRightX, bit.band(corner, 2) ~= 0 and flBottomY or flTopY, fDepth )

				local ang_eye = EyeAngles()
				local ang_to_rotate_pos = Angle()

				-- orientate it to be "upwards"
				ang_to_rotate_pos:RotateAroundAxis(ang_to_rotate_pos:Right(), 90)
				ang_to_rotate_pos:RotateAroundAxis(ang_to_rotate_pos:Up(), -90)

				-- rotate it around eyeangles pitch and yaw
				ang_to_rotate_pos:RotateAroundAxis(ang_to_rotate_pos:Right(), -ang_eye.y)
				ang_to_rotate_pos:RotateAroundAxis(ang_to_rotate_pos:Forward(), -ang_eye.p)

				pos:Rotate(ang_to_rotate_pos)

				-- screen to world, very funny
				pos:Add(EyePos())

				-- out of ur face
				pos:Add(EyeAngles():Forward() * 1.01)

				mesh.Position( pos )
				mesh.Normal( Vector(0.0, 0.0, 1.0) )
				mesh.TexCoord( 0, bLeft and flLeftU or flRightU, bit.band(corner, 2) ~= 0 and flBottomV or flTopV )
				mesh.TangentS( Vector(0.0, 1.0, 0.0) )
				mesh.TangentT( Vector(1.0, 0.0, 0.0) )
				mesh.AdvanceVertex()
			end
		end
		mesh.End()

		render.SetMaterial(pMaterial)
		pMesh:Draw()
	end

	function META:PrepareScopeEffect(vm, x, y, w, h)
		if not self:IsInIronSight() then return end

		--print("prep")
		-- e
	end
	function META:RenderScopeEffect(vm, x, y, w, h)
		if not self:IsInIronSight() then return end

		-- apply the blur effect to the screen while masking out the scope lens

		--render.SetStencilEnable(true)
		--render.SetStencilReferenceValue(1)
		--render.SetStencilCompareFunction(STENCIL_NOTEQUAL)
		--render.SetStencilPassOperation(STENCILOPERATION_KEEP)
		--render.SetStencilFailOperation(STENCILOPERATION_KEEP)
		--render.SetStencilZFailOperation(STENCILOPERATION_KEEP)

		-- RENDER _rt_SmallFB0 to screen
		local pBlurOverlayMaterial = Material("dev/scope_bluroverlay")

		-- set alpha to the amount of ironsightedness
		local flAlphaVar = pBlurOverlayMaterial:GetFloat("$alpha")
		if flAlphaVar then
			pBlurOverlayMaterial:SetFloat("$alpha", Bias( self.m_flIronSightAmount, 0.2))
		end
		DrawScreenSpaceQuad(pBlurOverlayMaterial)

		-- now draw the laser dot, masked to ONLY render on the lens
		local dotCoords = self.m_vecDotCoords
		dotCoords.x = dotCoords.x * GetScreenAspectRatio(ScrW(), ScrH())

		--IMaterial *pMatDot = materials->FindMaterial(GetDotMaterial(), TEXTURE_GROUP_OTHER, true);
		local pMatDot = Material(self:GetDotMaterial())

		render.OverrideDepthEnable(true, false)

		--render.SetStencilEnable(true)
		--render.SetStencilReferenceValue(1)
		--render.SetStencilCompareFunction(STENCIL_EQUAL)
		--render.SetStencilPassOperation(STENCILOPERATION_KEEP)
		--render.SetStencilFailOperation(STENCILOPERATION_KEEP)
		--render.SetStencilZFailOperation(STENCILOPERATION_KEEP)

		local iWidth = self:GetDotWidth()

		local alphaVar2 = pMatDot:GetFloat("$alpha")
		if alphaVar2 then
			local flDotBlur = self:GetDotBlur()
			pMatDot:SetFloat("$alpha", flDotBlur == flDotBlur and flDotBlur or 0)
		end

		dotCoords.x = dotCoords.x + 0.5
		dotCoords.y = dotCoords.y + 0.5

		DrawScreenSpaceRectangle(pMatDot,
			(w * dotCoords.x) - (iWidth / 2), (h * dotCoords.y) - (iWidth / 2), iWidth, iWidth,
			0, 0, 61, 61,
			64, 64)

		render.OverrideDepthEnable(false, true)

		--clean up stencil buffer once we're done so render elements like the glow pass draw correctly
		render.ClearStencil()
		-- restore a disabled stencil state
		render.SetStencilEnable(false)
	end

	-- pull up duration is how long the pull up would take in seconds, not the speed
	function META:GetIronSightPullUpDuration()
		return self.m_flIronSightPullUpSpeed > 0 and (1 / self.m_flIronSightPullUpSpeed) or 0
	end
	function META:GetIronSightPullUpDuration()
		return self.m_flIronSightPutDownSpeed > 0 and (1 / self.m_flIronSightPutDownSpeed) or 0
	end

	debug.getregistry().IronSightController = META

	function IronSightController()
		return setmetatable({}, META)
	end

	function IsIronSightController(o)
		return getmetatable(o) == META
	end
end

-- UniformRandomStream
do
	local META = {
		m_iv = {} -- array, size == NTAB
	}
	META.__index = META
	META.__tostring = function(self)
		return "UniformRandomStream [" .. self.m_idum .. "]"
	end

	debug.getregistry().UniformRandomStream = META

	function UniformRandomStream(seed)
		local obj = setmetatable({}, META)
		obj:SetSeed(tonumber(seed) or 0)
		return obj
	end

	function IsUniformRandomStream(o)
		return getmetatable(o) == META
	end

	-- https://github.com/VSES/SourceEngine2007/blob/master/src_main/vstdlib/random.cpp#L16

	local IA = 16807
	local IM = 2147483647
	local IQ = 127773
	local IR = 2836
	local NTAB = 32
	local NDIV = (1 + (IM - 1) / NTAB)
	local MAX_RANDOM_RANGE = 0x7FFFFFFF

	-- fran1 -- return a random floating-point number on the interval [0,1])
	local AM = (1 / IM)
	local EPS = 1.2e-7
	local RNMX = (1 - EPS)

	function META:SetSeed(iSeed)
		self.m_idum = iSeed < 0 and iSeed or -iSeed
		self.m_iy = 0
	end

	local int = math.floor
	function META:GenerateRandomNumber()
		local j, k
		if (self.m_idum <= 0 or not self.m_iy) then
			if (-self.m_idum < 1) then
				self.m_idum = 1
			else
				self.m_idum = -self.m_idum
			end

			j = NTAB + 8
			while 1 do
				if j <= 0 then break end
				j = j - 1

				k = int(self.m_idum / IQ)
				self.m_idum = int(IA * (self.m_idum-k * IQ) - IR * k)
				if (self.m_idum < 0)  then
					self.m_idum = int(self.m_idum + IM)
				end
				if (j < NTAB) then
					self.m_iv[j] = int(self.m_idum)
				end
			end
			self.m_iy = self.m_iv[0]
		end

		k = int(self.m_idum / IQ)
		self.m_idum = int(IA * (self.m_idum-k * IQ) - IR * k)
		if (self.m_idum < 0) then
			self.m_idum = int(self.m_idum + IM)
		end
		j = int(self.m_iy / NDIV)

		-- We're seeing some strange memory corruption in the contents of s_pUniformStream. 
		-- Perhaps it's being caused by something writing past the end of this array? 
		-- Bounds-check in release to see if that's the case.
		if (j >= NTAB or j < 0) then
			ErrorNoHalt(string.format("CUniformRandomStream had an array overrun: tried to write to element %d of 0..31.", j))
			j = int(bit.band( j % NTAB, 0x7fffffff))
		end

		self.m_iy = int(self.m_iv[j])
		self.m_iv[j] = int(self.m_idum)

		return self.m_iy
	end

	function META:RandomFloat(flLow, flHigh)
		flLow = flLow or 0
		flHigh = flHigh or 1

		local fl = AM * self:GenerateRandomNumber()
		if fl > RNMX then
			fl = RNMX
		end

		return (fl * ( flHigh - flLow ) ) + flLow -- float in [low,high]
	end

	function META:RandomFloatExp(flMinVal, flMaxVal, flExponent)
		flMinVal = flMinVal or 0
		flMaxVal = flMaxVal or 1
		flExponent = flExponent or 1

		local fl = AM * self:GenerateRandomNumber()
		fl = math.min(fl, RNMX)

		if flExponent ~= 1 then
			fl = math.pow(fl, flExponent)
		end

		return (fl * ( flMaxVal - flMinVal ) ) + flMinVal
	end

	function META:RandomInt(iLow, iHigh)
		iLow = iLow or 0 iHigh = iHigh or 100
		iLow = math.floor(iLow) iHigh = math.floor(iHigh)
		local iMaxAcceptable, n
		local x = iHigh - iLow + 1

		if x <= 1 or MAX_RANDOM_RANGE < x-1 then
			return iLow
		end

		iMaxAcceptable = math.floor(MAX_RANDOM_RANGE - ((MAX_RANDOM_RANGE + 1) % x ))
		n = self:GenerateRandomNumber()
		while n > iMaxAcceptable do
			n = self:GenerateRandomNumber()
		end

		return iLow + (n % x)
	end

	g_ursRandom = UniformRandomStream()
end

IN_ATTACK3 = bit.lshift(1, 25)

source_weps = source_weps or {}
source_weps.ConVars = {}

local function ScreenScaleH(n)
	return n * (ScrH() / 480)
end

-- CSGO weapon specifics in here
do
	SWCS_DEBUG_AE           = CreateConVar("swcs_debug_animevent", "0", {FCVAR_REPLICATED, FCVAR_NOTIFY}, "")
	SWCS_DEBUG_RECOIL       = CreateConVar("swcs_debug_recoil", "0", {FCVAR_REPLICATED, FCVAR_NOTIFY}, "")
	SWCS_DEBUG_RECOIL_DECAY = CreateConVar("swcs_debug_decay", "0", {FCVAR_REPLICATED, FCVAR_NOTIFY}, "")
	SWCS_DEBUG_PENETRATION  = CreateConVar("swcs_debug_penetration", "0", {FCVAR_REPLICATED, FCVAR_NOTIFY}, "")

	SWCS_DEPLOY_OVERRIDE = CreateConVar("swcs_deploy_override", "1", {FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "deploy speed override multiplier")
	SWCS_SPREAD_SHARE_SEED = CreateConVar("swcs_weapon_sync_seed", "1", {FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "synchronize spread seeds on server and client")
	SWCS_INDIVIDUAL_AMMO = CreateConVar("swcs_weapon_individual_ammo", "1", {FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "weapons store their own ammo, and don't pull from player's ammo")

	CreateClientConVar("cl_bob_lower_amt", "21", nil, nil, "The amount the viewmodel lowers when running")
	CreateClientConVar("cl_crosshairstyle", "4", nil, nil, "0 = DEFAULT, 1 = DEFAULT STATIC, 2 = ACCURATE SPLIT (accurate recoil/spread feedback with a fixed inner part) 3 = ACCURATE DYNAMIC (accurate recoil/spread feedback) 4 = CLASSIC STATIC, 5 = OLD CS STYLE (fake recoil - inaccurate feedback)")
	CreateClientConVar("cl_crosshairdot", "1")
	CreateClientConVar("cl_crosshair_t", "0", nil, nil, "T style crosshair")
	CreateClientConVar("cl_crosshairthickness", "0.5")
	CreateClientConVar("cl_crosshairsize", "1")
	CreateClientConVar("cl_crosshairgap", "1")
	CreateClientConVar("cl_crosshairgap_useweaponvalue", "0", nil, nil, "If set to 1, the gap will update dynamically based on which weapon is currently equipped")
	CreateClientConVar("cl_crosshair_drawoutline", "1")
	CreateClientConVar("cl_crosshair_outlinethickness", "1", nil, nil, "Set how thick you want your crosshair outline to draw (0.1-3)")
	CreateClientConVar("cl_crosshair_dynamic_splitdist", "7", true, nil, "If using cl_crosshairstyle 2, this is the distance that the crosshair pips will split into 2. (default is 7)")
	CreateClientConVar("cl_crosshair_dynamic_splitalpha_innermod", "1", true, nil, "If using cl_crosshairstyle 2, this is the alpha modification that will be used for the INNER crosshair pips once they've split. [0 - 1]")
	CreateClientConVar("cl_crosshair_dynamic_splitalpha_outermod", "0.5", true, nil, "If using cl_crosshairstyle 2, this is the alpha modification that will be used for the OUTER crosshair pips once they've split. [0.3 - 1]")
	CreateClientConVar("cl_crosshair_dynamic_maxdist_splitratio", "0.35", true, nil, "If using cl_crosshairstyle 2, this is the ratio used to determine how long the inner and outer xhair pips will be. [inner = cl_crosshairsize*(1-cl_crosshair_dynamic_maxdist_splitratio) outer = cl_crosshairsize*cl_crosshair_dynamic_maxdist_splitratio]  [0 - 1]")
	CreateClientConVar("cl_crosshaircolor", "5")
	CreateClientConVar("cl_crosshairusealpha", "200")
	CreateClientConVar("cl_crosshaircolor_r", "220")
	CreateClientConVar("cl_crosshaircolor_g", "0")
	CreateClientConVar("cl_crosshaircolor_b", "0")
	CreateClientConVar("cl_crosshairalpha", "200")
	CreateClientConVar("cl_crosshair_sniper_width", "1", nil,nil, "If >1 sniper scope cross lines gain extra width (1 for single-pixel hairline)")
	CreateConVar("sv_showimpacts", "0", {FCVAR_REPLICATED}, "Shows client (red) and server (blue) bullet impact point (1=both, 2=client-only, 3=server-only)")
	CreateConVar("sv_showimpacts_penetration", "0", {FCVAR_REPLICATED}, "Shows extra data when bullets penetrate. (use sv_showimpacts_time to increase time shown)")
	CreateConVar("sv_showimpacts_time", "4", {FCVAR_REPLICATED}, "Duration bullet impact indicators remain before disappearing")
	CreateClientConVar("viewmodel_offset_x", "0.0")
	CreateClientConVar("viewmodel_offset_y", "0.0")
	CreateClientConVar("viewmodel_offset_z", "0.0")

	-- used in calcview to follow spray pattern
	CreateConVar("view_recoil_tracking", "0.45", {FCVAR_REPLICATED, FCVAR_CHEAT}, "How closely the view tracks with the aim punch from weapon recoil")

	-- used for view model to follow spray pattern
	CreateClientConVar("viewmodel_recoil", "1.0", nil, nil, "Amount of weapon recoil/aimpunch to display on viewmodel")

	CreateClientConVar("weapon_debug_spread_show", "0", FCVAR_CHEAT, "Enables display of weapon accuracy; 1: show accuracy box, 3: show accuracy with dynamic crosshair")
	CreateConVar("weapon_near_empty_sound", "1", {FCVAR_CHEAT, FCVAR_REPLICATED}, "")
	CreateConVar("weapon_air_spread_scale", "1.0", {FCVAR_CHEAT, FCVAR_REPLICATED}, "Scale factor for jumping inaccuracy, set to 0 to make jumping accuracy equal to standing")
	CreateConVar("weapon_recoil_decay_coefficient", "2.0", {FCVAR_CHEAT, FCVAR_REPLICATED}, "")
	CreateConVar("weapon_accuracy_forcespread", "0", FCVAR_REPLICATED, "Force spread to the specified value.")
	CreateConVar("weapon_accuracy_nospread", "0", FCVAR_REPLICATED, "Disable weapon inaccuracy spread")
	CreateConVar("weapon_accuracy_shotgun_spread_patterns", "1", {FCVAR_REPLICATED, FCVAR_NOTIFY})
	CreateConVar("weapon_recoil_cooldown", "0.55", {FCVAR_REPLICATED, FCVAR_CHEAT}, "Amount of time needed between shots before restarting recoil")
	CreateConVar("weapon_recoil_scale", "2", FCVAR_REPLICATED, "Overall scale factor for recoil.")
	CreateConVar("weapon_recoil_view_punch_extra", "0.055", FCVAR_REPLICATED, "Additional (non-aim) punched added to view from recoil")

	local genned_mats = {}
	function source_weps.GenerateEconTexture(params)
		if SERVER then return end

		local basetexture = params.basetexture
		local flWearValue = params.wearvalue
		local normalmap   = params.normal

		local filename = string.GetFileFromFilename(basetexture)
		if not filename then error("bad texture path", 2) end

		local hash = util.CRC(Format("%s_%f", filename, flWearValue))
		local mat_name = Format("swcs_%s_%x", filename, hash)

		local mat = genned_mats[mat_name]
		if not mat or mat:IsError() then
			mat = CreateMaterial(mat_name, "VertexLitGeneric", {
				["$basetexture"] = basetexture,
				["$bumpmap"] = normalmap
			})
		else
			mat:SetTexture("$basetexture", basetexture)

			if normalmap then
				mat:SetTexture("$bumpmap", normalmap)
			end

			mat:GetTexture("$basetexture"):Download()
		end

		genned_mats[mat_name] = mat

		return mat_name, mat
	end

	cvars.AddChangeCallback("sv_showimpacts", function(name,old,new)
		local num = tonumber(new)

		for k,v in next,player.GetAll() do
			v:ConCommand("developer " .. (num > 0 and 1 or 0))
		end
	end, "swcs.developer_change")

	if CLIENT then
		surface.CreateFont("_sw_wepfont_cs_0", {
			font = "csd",
			size = ScreenScaleH(64),
			weight = 0,
			antialias = true,
			additive = true,
			--blursize = 0,
			--scanlines = 0,
		})

		surface.CreateFont("_sw_wepfont_cs_1", {
			font = "csd",
			size = ScreenScaleH(64),
			weight = 0,
			antialias = true,
			additive = true,
			--blursize = ScreenScaleH(4),
			--scanlines = ScreenScaleH(2),
		})

		local mdl = "models/weapons/csgo/c_hands_translator.mdl"
		local translator = ClientsideModel(mdl)
		hook.Add("PreDrawPlayerHands", "swcs.hands", function(hands, vm, ply, wep)
			if not (IsValid(hands) and IsValid(vm) and IsValid(wep)) then return end
			if not wep.IsSWCSWeapon then return end

			if not IsValid(translator) then
				translator = ClientsideModel(mdl)
				translator:SetRenderMode(RENDERMODE_TRANSALPHA)
				translator:SetColor(Color(0,0,0,0))
			end

			if not vm:LookupBone("ValveBiped.Bip01_R_Hand") then
				translator:SetParent(vm)
				translator:SetPos(vm:GetPos())
				translator:SetAngles(vm:GetAngles())
				translator:AddEffects(EF_BONEMERGE)
				translator:AddEffects(EF_BONEMERGE_FASTCULL)

				hands:SetParent(translator)
				hands:AddEffects(EF_BONEMERGE)
				hands:AddEffects(EF_BONEMERGE_FASTCULL)
			end
		end)
	end

	hook.Add("SetupMove", "swcs.movement", function(ply, move, cmd)
		if not ply:IsValid() then return end

		local wep = ply:GetActiveWeapon()

		if IsValid(wep) then
			if SERVER and ply.swcs_canzoom == nil then
				ply.swcs_canzoom = ply:GetCanZoom()
			end

			if wep.IsSWCSWeapon then
				local mult = wep:GetMaxSpeed() / 250
				if mult <= 0 then
					mult = 1
				end

				if cmd:KeyDown(IN_ATTACK) and wep:GetShotsFired() >= 1 then
					mult = mult * wep:GetAttackMovespeedFactor()
				end

				move:SetMaxClientSpeed(math.min(move:GetMaxClientSpeed() * mult))
				move:SetMaxSpeed(math.min(move:GetMaxSpeed() * mult))

				if wep.OnMove then
					wep:OnMove(ply, move, cmd)
				end

				if SERVER then
					ply:SetCanZoom(false)
				end
			else
				if SERVER then
					ply:SetCanZoom(ply.swcs_canzoom)
				end
			end
		end
	end)

	hook.Add("ScalePlayerDamage", "swcs.dmg", function(victim, hitgroup, dmg)
		local atk = NULL
		local wep = NULL

		if dmg:GetAttacker():IsValid() and dmg:GetAttacker():IsPlayer() then
			atk = dmg:GetAttacker()
		end

		if dmg:GetInflictor():IsValid() and dmg:GetInflictor():IsWeapon() then
			wep = dmg:GetInflictor()
		end

		if atk:IsValid() and not wep:IsValid() and atk:GetActiveWeapon():IsValid() then
			wep = atk:GetActiveWeapon()
		end

		if wep:IsValid() and wep.IsSWCSWeapon then
			wep:ApplyDamageScale(dmg, {HitGroup = hitgroup}, dmg:GetDamage())
			-- return false so that the gamemode func doesnt get called
			-- TODO: add toggle for this??
			return false
		end
	end)

	-- i wrote this while intoxicated oops
	local to_disable = {
		["weapon_zm_improvised"] = true,
		["weapon_zm_mac10"] = true,
		["weapon_zm_pistol"] = true,
		["weapon_zm_revolver"] = true,
		["weapon_zm_rifle"] = true,
		["weapon_zm_shotgun"] = true,
		["weapon_zm_sledge"] = true,
		["weapon_ttt_glock"] = true,
		["weapon_ttt_m16"] = true
	}
	hook.Add("PreGamemodeLoaded", "swcs.ttt_init", function()
		local bIsTTT = util.NetworkStringToID("TTT_RoundState") ~= 0

		if not bIsTTT then return end

		local spawnable_weps = SERVER and ents.TTT.GetSpawnableSWEPs() or {}

		-- todo: add toggle to disable this?? prolly lol
		table.Empty(spawnable_weps)

		-- add our weps to auto spawn :)
		for i, t in ipairs(weapons.GetList()) do
			if weapons.IsBasedOn(t.ClassName, "weapon_swcs_base") and t.Spawnable and not t.AdminSpawnable and t.AutoSpawnable == nil then
				if t.InLoadoutFor then continue end

				Msg("[swcs] ") print(Format("made %s for ttt", t.ClassName))
				t.AutoSpawnable = true
				table.insert(spawnable_weps, t)

				local ItemVisuals = util.KeyValuesToTable(t.ItemDefVisuals, true, false)
				local ItemAttributes = util.KeyValuesToTable(t.ItemDefAttributes, true, false)
				local weapon_type = string.lower(ItemVisuals.weapon_type)

				local max_prim = tonumber(ItemAttributes["primary reserve ammo max"])
				t.Primary.ClipMax = max_prim

				if weapon_type == "pistol" then
					t.Kind = WEAPON_PISTOL
					t.Slot = 1

					if t.ClassName == "weapon_swcs_deagle" or t.ClassName == "weapon_swcs_revolver" then
						t.Primary.Ammo = "AlyxGun"
						t.AmmoEnt = "item_ammo_revolver_ttt"
					else
						t.Primary.Ammo = "pistol"
						t.AmmoEnt = "item_ammo_pistol_ttt"
					end
				elseif t.Base ~= "weapon_swcs_knife" then
					t.Kind = WEAPON_HEAVY
					t.Slot = 2

					if weapon_type == "shotgun" then
						t.Primary.Ammo = "Buckshot"
						t.AmmoEnt = "item_box_buckshot_ttt"
					elseif weapon_type == "sniperrifle" then
						t.Primary.Ammo = "357"
						t.AmmoEnt = "item_ammo_357_ttt"
					else
						t.Primary.Ammo = "smg1"
						t.AmmoEnt = "item_ammo_smg1_ttt"
					end
				end
			elseif to_disable[t.ClassName] then
				Msg("[swcs] ") print("obliterated ttt wep", t.ClassName)
				t.AutoSpawnable = false
			end
		end

		if CLIENT then return end

		-- overwrite default ttt weapons with our own
		timer.Simple(0, function()
			ents.TTT._ReplaceEntities = ents.TTT._ReplaceEntities or ents.TTT.ReplaceEntities

			local _, ReplaceAmmo = debug.getupvalue(ents.TTT._ReplaceEntities, 1)
			local _, ReplaceWeapons = debug.getupvalue(ents.TTT._ReplaceEntities, 2)
			local _, RemoveCrowbars = debug.getupvalue(ents.TTT._ReplaceEntities, 3)

			local _, _ReplaceWeaponSingle = debug.getupvalue(ReplaceWeapons, 1)
			local _, ReplaceSingle = debug.getupvalue(_ReplaceWeaponSingle, 2)

			local swcs_all_weps = {}

			for k, v in next, weapons.GetList() do
				if weapons.IsBasedOn(v.ClassName, "weapon_swcs_base") and not v.IsBaseWep then
					local keyvals = util.KeyValuesToTable(v.ItemDefVisuals)
					local strWeaponType = string.lower(keyvals.weapon_type)

					if not swcs_all_weps[strWeaponType] then
						swcs_all_weps[strWeaponType] = {}
					end

					if v.ClassName ~= "weapon_swcs_deagle" and v.ClassName ~= "weapon_swcs_revolver" then
						table.insert(swcs_all_weps[strWeaponType], v.ClassName)
					end
				end
			end

			local deagles = {
				"weapon_swcs_deagle",
				"weapon_swcs_revolver"
			}
			local ttt_weapon_replace = {
				["weapon_zm_mac10"] = function(ent)
					--print("REPLACE PLS", ent)
					return table.Random(swcs_all_weps.submachinegun)
					-- random smg
				end,
				["weapon_zm_shotgun"] = function(ent)
					--print("REPLACE PLS", ent)
					return table.Random(swcs_all_weps.shotgun)
					-- random shotgun
				end,
				["weapon_ttt_m16"] = function(ent)
					--print("REPLACE PLS", ent)
					return table.Random(swcs_all_weps.rifle)
					-- random assault rifle
				end,
				["weapon_zm_rifle"] = function(ent)
					--print("REPLACE PLS", ent)
					return table.Random(swcs_all_weps.sniperrifle)
					-- random sniper
				end,
				["weapon_zm_pistol"] = function(ent)
					return table.Random(swcs_all_weps.pistol)
					--print("REPLACE PISTOL PLS", ent)
					-- random pistol
				end,
				["weapon_zm_sledge"] = function(ent)
					--
					--print("REPLACE PLS", ent)
					return table.Random(swcs_all_weps.machinegun)
					-- random LMG
				end,
				["weapon_zm_revolver"] = function(ent)
					return table.Random(deagles)
				end,

				--["item_ammo_pistol_ttt"] = "item_ammo_pistol_ttt",
				--["weapon_zm_molotov"] = "weapon_zm_molotov"
			}

			local function ReplaceWeaponSingleSWCS(ent, cls)
				-- Loadout weapons immune
				-- we use a SWEP-set property because at this state all SWEPs identify as weapon_swep
				if ent.AllowDelete == false then
					return
				else
					if cls == nil then cls = ent:GetClass() end

					local rpl = ttt_weapon_replace[cls]
					if isfunction(rpl) then
						rpl = rpl(ent)
					end

					if rpl then
						ReplaceSingle(ent, rpl)
					end
				end
			end

			local function SWCSReplaceWeapons()
				for _, ent in ipairs(ents.FindByClass("weapon_*")) do
					ReplaceWeaponSingleSWCS(ent)
				end
			end

			ents.TTT.ReplaceEntities = function()
				ReplaceAmmo()
				ReplaceWeapons()
				RemoveCrowbars()
				ents.TTT.RemoveRagdolls()

				SWCSReplaceWeapons()
			end
		end)
	end)
end

local PLAYER = FindMetaTable "Player"

if CLIENT then
	local fov_desired = GetConVar "fov_desired"
	function PLAYER:GetDefaultFOV()
		return fov_desired:GetInt()
	end

	if not surface.GetDrawColor then
		local oSsdc = surface.SetDrawColor
		local col

		function surface.SetDrawColor(r, g, b, a)
			if istable(r) then
				col = Color(r.r or 255, r.g or 255, r.b or 255, r.a or 255)
				return oSsdc(r)
			else
				a = a or 255
				col = Color(r or 255,g or 255,b or 255,a)
				return oSsdc(col)
			end
		end

		function surface.GetDrawColor()
			return col
		end
	end

	surface.CreateFont("_sw_wepfont_0", {
		font = "HalfLife2",
		size = ScreenScaleH(64),
		weight = 0,
		antialias = true,
		additive = true,
		blursize = 0,
		scanlines = 0,
	})

	surface.CreateFont("_sw_wepfont_1", {
		font = "HalfLife2",
		size = ScreenScaleH(64),
		weight = 0,
		antialias = true,
		additive = true,
		blursize = ScreenScaleH(4),
		scanlines = ScreenScaleH(2),
	})

	--require("urlimage")
else
	function PLAYER:GetDefaultFOV()
		return self:GetInternalVariable "m_iDefaultFOV"
	end
	--AddCSLuaFile("includes/modules/urlimage.lua")
end

--game.AddParticles("particles/cs_weapon_fx.pcf")
--PrecacheParticleSystem("weapon_shell_casing_50cal")
--PrecacheParticleSystem("weapon_shell_casing_9mm")
--PrecacheParticleSystem("weapon_shell_casing_9mm_FP")
--PrecacheParticleSystem("weapon_shell_casing_rifle")
--PrecacheParticleSystem("weapon_shell_casing_shotgun")
--PrecacheParticleSystem("weapon_shell_casing_50cal_fallback")
--PrecacheParticleSystem("weapon_shell_casing_9mm_fallback")
--PrecacheParticleSystem("weapon_shell_casing_rifle_fallback")
--PrecacheParticleSystem("weapon_shell_casing_shotgun_fallback")
