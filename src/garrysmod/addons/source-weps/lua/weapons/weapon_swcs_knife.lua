SWEP.Base = "weapon_swcs_base"
SWEP.Category = "Counter-Strike: Global Offensive"

SWEP.PrintName = "knife"
SWEP.Spawnable = false
SWEP.HoldType = "knife"
SWEP.WorldModel = Model"models/weapons/csgo/w_knife_default_t_dropped.mdl"
SWEP.WorldModelPlayer = Model"models/weapons/csgo/w_knife_default_t.mdl"
SWEP.ViewModel = Model"models/weapons/csgo/v_knife_default_t.mdl"

local bIsTTT = util.NetworkStringToID("TTT_RoundState") ~= 0
if bIsTTT then
	SWEP.Slot          = 0
	SWEP.Kind          = WEAPON_MELEE
	SWEP.InLoadoutFor  = {ROLE_INNOCENT, ROLE_TRAITOR, ROLE_DETECTIVE}
	SWEP.NoSights      = true
	SWEP.IsSilent      = true
	SWEP.Weight        = 5
	SWEP.AutoSpawnable = false
	SWEP.AllowDelete   = false
	SWEP.AllowDrop     = false
end

SWEP.ItemDefAttributes = [=["attributes 08/03/2020" {
	"primary clip size" "-1"
	"is full auto" "1"
	"recoil seed" "0"
	"recoil angle variance" "0"
	"recoil magnitude" "0"
	"recoil magnitude variance" "0"
	"recoil angle variance alt" "0"
	"recoil magnitude alt" "0"
	"recoil magnitude variance alt" "0"
}]=]
SWEP.ItemDefVisuals = [=["visuals 08/03/2020" {
	"weapon_type" "knife"
}]=]

SWEP.IsKnife = true

if CLIENT then
	--local knife = NULL--ClientsideModel(mdl)
	--[[hook.Add("PreDrawViewModel", "swcs.knife_shittery", function( vm, ply, wep)
		if not IsValid(vm) or not IsValid(wep) then return end
		if not (wep.IsSWCSWeapon and wep.IsKnife) then return end

		if not IsValid(knife) then
			knife = ClientsideModel(wep.VMBM)
			knife:SetRenderMode(RENDERMODE_TRANSALPHA)
			knife:SetColor(Color(0,0,0,0))
		end

		if vm:LookupBone("v_weapon") then
			knife:SetParent(vm)
			knife:SetPos(vm:GetPos())
			knife:SetAngles(vm:GetAngles())
			knife:AddEffects(EF_BONEMERGE)
			knife:AddEffects(EF_BONEMERGE_FASTCULL)

			knife:DrawModel()
		end
	end)]]
end

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = "none"
SWEP.Secondary.Automatic = true

DEFINE_BASECLASS(SWEP.Base)

sound.Add({
	name = Sound"Weapon_Knife_CSGO.Deploy",
	channel = CHAN_STATIC,
	level = 65,
	volume = 0.1,
	sound = Sound")weapons/csgo/knife/knife_deploy1.wav"
})
sound.Add({
	name = Sound"Weapon_Knife_CSGO.Hit",
	channel = CHAN_STATIC,
	level = 65,
	volume = 0.6,
	sound = {Sound")weapons/csgo/knife/knife_hit1.wav", Sound")weapons/csgo/knife/knife_hit2.wav", Sound")weapons/csgo/knife/knife_hit3.wav", Sound")weapons/csgo/knife/knife_hit4.wav"}
})
sound.Add({
	name = Sound"Weapon_Knife_CSGO.HitWall",
	channel = CHAN_STATIC,
	level = 65,
	volume = 0.6,
	sound = {Sound")weapons/csgo/knife/knife_hit_01.wav", Sound")weapons/csgo/knife/knife_hit_02.wav", Sound")weapons/csgo/knife/knife_hit_03.wav", Sound")weapons/csgo/knife/knife_hit_04.wav", Sound")weapons/csgo/knife/knife_hit_05.wav"}
})
sound.Add({
	name = Sound"Weapon_Knife_CSGO.Slash",
	channel = CHAN_WEAPON,
	level = 65,
	volume = 0.6,
	pitch = {97, 105},
	sound = {Sound")weapons/csgo/knife/knife_slash1.wav", Sound")weapons/csgo/knife/knife_slash2.wav"}
})
sound.Add({
	name = Sound"Weapon_Knife_CSGO.Stab",
	channel = CHAN_WEAPON,
	level = 65,
	volume = 0.6,
	pitch = {97, 105},
	sound = Sound")weapons/csgo/knife/knife_stab.wav"
})

if bIsTTT then
	function SWEP:OnDrop()
		self:Remove()
	end
end

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)
	self:NetworkVar("Bool", 6, "SwingLeft")
end

local hardcoded_knife_deploy_time = 1.0
function SWEP:Deploy()
	-- NOTE (wills): Knives no longer use model bodygroups to change their appearance 
	-- between CT and T versions. Team-specific knives now support team-specific
	-- viewmodel and world animations, so they are stored as unique models.
	-- If a knife needs to look aesthetically different between CT/T teams,
	-- add an asset_modifier block to the item definition to divert the whole model.

	-- Fix for different knife models having different deploy times.  If it's short,
	-- you just idle a bit before you attack.  If it's long, we animation-cancel the
	-- deploy animation and go straight into the swing/stab after a fixed amount of
	-- time.
	self:SetNextPrimaryFire(CurTime() + (hardcoded_knife_deploy_time * (1 / self:GetDeploySpeed())))
	self:SetNextSecondaryFire(CurTime() + (hardcoded_knife_deploy_time * (1 / self:GetDeploySpeed())))
	self:SetWeaponIdleTime(CurTime() + (hardcoded_knife_deploy_time * (1 / self:GetDeploySpeed())))

	local owner = self:GetPlayerOwner()
	if owner then
		local vm = owner:GetViewModel(self:ViewModelIndex())
		if vm:IsValid() then
			vm:SetPlaybackRate(self:GetDeploySpeed())
			self:ApplyWeaponSkin(vm, owner)
		end
	end

	self:SetHoldType(self.HoldType)

	return true
end

function SWEP:Holster()
	return true
end

function SWEP:PrimaryAttack()
	if self:GetPlayerOwner() then
		self:GetPlayerOwner():LagCompensation(true)
	end

	self:SwingOrStab(Primary_Mode)

	if self:GetPlayerOwner() then
		self:GetPlayerOwner():LagCompensation(false)
	end
end

function SWEP:SecondaryAttack()
	if self:GetPlayerOwner() then
		self:GetPlayerOwner():LagCompensation(true)
	end

	self:SwingOrStab(Secondary_Mode)

	if self:GetPlayerOwner() then
		self:GetPlayerOwner():LagCompensation(false)
	end
end

local KNIFE_RANGE_LONG = 48
local KNIFE_RANGE_SHORT = 32

function SWEP:SwingOrStab(weaponMode)
	local owner = self:GetPlayerOwner()
	if not owner then return end

	local fRange = (weaponMode == Primary_Mode) and KNIFE_RANGE_LONG or KNIFE_RANGE_SHORT

	local vForward = owner:GetAimVector()
	local vecSrc	= owner:GetShootPos()
	local vecEnd	= vecSrc + vForward * fRange

	local tr = util.TraceLine({
		start = vecSrc,
		endpos = vecEnd,
		mask = MASK_SOLID,
		collisiongroup = COLLISION_GROUP_NONE,
		filter = owner
	})
	if not tr.Hit then
		util.TraceHull({
			start = vecSrc,
			endpos = vecEnd,
			mask = MASK_SOLID,
			collisiongroup = COLLISION_GROUP_NONE,
			filter = owner,
			mins = vector_origin,
			maxs = vector_origin,
			output = tr
		})
	end

	local bDidHit = tr.Fraction < 1

	local bFirstSwing = (self:GetNextPrimaryFire() + 0.4) < CurTime()
	if bFirstSwing then
		self:SetSwingLeft(true)
	end

	local fPrimDelay, fSecDelay

	if weaponMode == Secondary_Mode then
		fPrimDelay = bDidHit and 1.1 or 1
		fSecDelay = fPrimDelay
	else -- swing
		fPrimDelay = bDidHit and 0.5 or 0.4
		fSecDelay = 0.5
	end

	self:SetNextPrimaryFire(CurTime() + fPrimDelay)
	self:SetNextSecondaryFire(CurTime() + fSecDelay)

	local bBackStab = false

	if bDidHit then
		local ent = tr.Entity

		local fDamage = 0

		if ent:IsValid() and (ent:IsPlayer() or ent:IsNPC()) then
			local vTargetForward = ent:GetAngles():Forward()

			local vecLOS = (ent:GetPos() - owner:GetPos())
			vecLOS.z = 0
			vecLOS:Normalize()

			vTargetForward.z = 0
			local flDot = vecLOS:Dot(vTargetForward)

			if flDot > .475 then
				bBackStab = true
			end
		end

		if weaponMode == Secondary_Mode then
			if bBackStab then
				fDamage = 180
			else
				fDamage = 65
			end
		else
			if bBackStab then
				fDamage = 90
			elseif bFirstSwing then
				fDamage = 40
			else
				fDamage = 25
			end
		end

		if weaponMode == Secondary_Mode then
			self:SetWeaponAnim( bBackStab and ACT_VM_SWINGHARD or ACT_VM_HITCENTER2 )
		else
			self:SetWeaponAnim( bBackStab and ACT_VM_SWINGHIT or ACT_VM_HITCENTER )
		end

		if SERVER then
			local info = DamageInfo()
			info:SetInflictor(owner)
			info:SetAttacker(owner)
			info:SetDamage(fDamage)
			info:SetDamageType(DMG_CLUB)
			info:SetDamagePosition(tr.HitPos)

			local force = vForward:GetNormal() * GetConVar("phys_pushscale"):GetFloat()
			info:SetDamageForce(force)

			ent:TakeDamageInfo(info)
		end

		if ent:IsValid() or ent == game.GetWorld() then
			if ( ent:IsPlayer() or ent:IsNPC()  ) then
				-- when gmod fixes _G.EmitSound to allow lua sound scripts
				-- uncomment this
				--EmitSound((weaponMode == Secondary_Mode) and "Weapon_Knife_CSGO.Stab" or "Weapon_Knife_CSGO.Hit", tr.HitPos, self:EntIndex())
				self:EmitSound((weaponMode == Secondary_Mode) and "Weapon_Knife_CSGO.Stab" or "Weapon_Knife_CSGO.Hit")
			else
				--EmitSound("Weapon_Knife_CSGO.HitWall", tr.HitPos, self:EntIndex())
				self:EmitSound("Weapon_Knife_CSGO.HitWall")
			end
		end

		if SERVER then
			SuppressHostEvents(owner)
		end

		util.ImpactTrace(tr, DMG_CLUB) --, "KnifeSlash")
	else
		self:EmitSound("Weapon_Knife_CSGO.Slash")

		if ( weaponMode == Secondary_Mode ) then
			self:SetWeaponAnim( ACT_VM_MISSCENTER2 );
		else
			self:SetWeaponAnim( ACT_VM_MISSCENTER );
		end
	end

	owner:SetAnimation(PLAYER_ATTACK1)

	--print(tr, tr.Hit, tr.Entity)

end
