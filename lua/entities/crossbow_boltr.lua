if SERVER then AddCSLuaFile() end

local BOLT_MODEL = "models/crossbow_bolt.mdl"
local BOLT_SKIN_NORMAL = 0
local BOLT_SKIN_GLOW = 1

local DAMAGE_NO = 0

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "crossbow_boltr"
ENT.Author = "homonovus"

ENT.GlowSprite = nil

function ENT:Initialize()
	-- vphys init normal solid_bbox, fsolid_not_standable
	-- phys solid mask band(content_hitbox, bnot(contents_grate))

	self:SetModel(BOLT_MODEL)
	self:PhysicsInitBox(-Vector(1,1,1), Vector(1,1,1))
	self:SetMoveType(MOVETYPE_FLYGRAVITY) self:SetMoveCollide(MOVECOLLIDE_FLY_CUSTOM)
	self:SetGravity(.05)

	--self:UpdateWaterState()

	self:NextThink(CurTime() + .2)

	self:CreateSprites()

	self:SetSkin(BOLT_SKIN_GLOW)

	local phys = self:GetPhysicsObject()
	if phys then
		phys:Wake()
	end
end

local function SUB_Remove(self)
	self:Remove()
end

function ENT:CreateSprites()
	--[[if CLIENT then
		self.GlowSprite = CreateSprite(Material("sprites/light_glow02_noz"))
	end]]
end

function ENT:Touch(ent)
	if not ent:IsSolid() or ent:IsFlagSet(FSOLID_VOLUME_CONTENTS) then return end
	if ent == self:GetOwner() then return end

	if ent:GetInternalVariable("m_takedamage") ~= DAMAGE_NO then
		local tr, tr2
		tr = self:GetTouchTrace()
		local normalizedVel = self:GetAbsVelocity()
		normalizedVel:Normalize()

		if self:GetOwner() and self:GetOwner():IsPlayer() and ent:IsNPC() then
			local dmgInfo = DamageInfo()
			dmgInfo:SetInflictor(self)
			dmgInfo:SetAttacker(self:GetOwner())
			dmgInfo:SetDamage(self.Damage)
			dmgInfo:SetDamageType(DMG_NEVERGIB)
			util.CalculateMeleeDamageForce(dmgInfo, normalizedVel, tr.HitPos, .7)
			ent:TakeDamageInfo(dmgInfo)
		else
			local dmgInfo = DamageInfo()
			dmgInfo:SetInflictor(self)
			dmgInfo:SetAttacker(self:GetOwner())
			dmgInfo:SetDamage(self.Damage)
			dmgInfo:SetDamageType(bit.bor(DMG_BULLET, DMG_NEVERGIB))
			util.CalculateMeleeDamageForce(dmgInfo, normalizedVel, tr.HitPos, .7)
			dmgInfo:SetDamagePosition(tr.HitPos)
			ent:TakeDamageInfo(dmgInfo)
		end

		-- Adrian: keep going through the glass.
		if ent:GetCollisionGroup() == COLLISION_GROUP_BREAKABLE_GLASS then return end

		self:SetAbsVelocity(Vector(0,0,0))

		-- play body "thwack" sound
		self:EmitSound("Weapon_Crossbow.BoltHitBody")

		local vecForward = self:GetAngles():Forward()
		vecForward:Normalize()

		tr2 = util.TraceLine({
			start = self:GetPos(),
			endpos = self:GetPos() + (vecForward * 128),
			mask = MASK_OPAQUE,
			filter = ent,
			collisiongroup = COLLISION_GROUP_NONE
		})

		if tr2.Fraction ~= 1 and not tr2.Entity:IsValid() or (tr2.Entity:IsValid() and tr2.Entity:GetMoveType() == MOVETYPE_NONE) then
			local data = EffectData()
			data:SetOrigin(tr2.HitPos)
			data:SetNormal(vecForward)
			data:SetEntIndex(tr2.Fraction ~= 1 and 1 or 0)

			util.Effect("BoltImpact", data)
		end

		self:Remove()
	else
		local tr = self:GetTouchTrace()

		-- See if we struck the world
		if ent:GetMoveType() == MOVETYPE_NONE and not tr.HitSky then
			self:EmitSound("Weapon_Crossbow.BoltHitWorld")

			-- if what we hit is static architecture, can stay around for a while
			local vecDir = self:GetVelocity()
			local speed = vecDir:Length()
			vecDir:Normalize()

			-- See if we should reflect off this surface
			local hitDot = tr.HitNormal:Dot(-vecDir)
			--print(hitDot, speed)
			if hitDot < .5 and speed > 100 then
				local vreflect = 2 * tr.HitNormal * hitDot + vecDir

				self:SetVelocity(vreflect * speed * .75)
				self:SetGravity(1)
			else
				self:NextThink(CurTime() + 2)

				self:SetMoveType(MOVETYPE_NONE)

				local vecForward = self:GetAngles():Forward()
				vecForward:Normalize()

				local data = EffectData()
				data:SetOrigin(tr.HitPos)
				data:SetNormal(vecForward)
				data:SetEntIndex(0)

				util.Effect("BoltImpact", data)
				util.ImpactTrace(tr)

				self:AddEffects(EF_NODRAW)
				self.Touch = function() end
				self.Think = SUB_Remove
				self:NextThink(CurTime() + 2)

				if self.GlowSprite then
					-- do shit here
				end
			end

			if util.PointContents(self:GetPos()) ~= CONTENTS_WATER then
				local data = EffectData()
				data:SetOrigin(self:GetPos())

				util.Effect("Sparks", data)
			end
		else
			if not tr.HitSky then
				util.ImpactTrace(tr)
			end

			self:Remove()
		end
	end
end

function ENT:Think()
	local angNewAngles = self:GetAbsVelocity():Angle()
	self:SetAngles(angNewAngles)

	if self:WaterLevel() == 0 then return end

	--print"bubble trail"
	--util.BubbleTrail()
end
