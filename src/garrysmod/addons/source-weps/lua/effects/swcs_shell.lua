local ang
EFFECT.ParticleName = "weapon_empty"

function EFFECT:FindShell(wep)
	if not IsValid(wep) then return "weapon_shell_casing_rifle_fallback" end
	local ammotype = (wep.Primary.Ammo or wep:GetPrimaryAmmoType()):lower()
	local guntype = (wep.Type or wep:GetHoldType()):lower()

	if guntype:find("sniper") or ammotype:find("sniper") or guntype:find("dmr") then
		return "weapon_shell_casing_rifle_fallback"
	elseif guntype:find("rifle") or ammotype:find("rifle") then
		return "weapon_shell_casing_rifle_fallback"
	elseif ammotype:find("pist") or guntype:find("pist") then
		return "weapon_shell_casing_9mm_fallback"
	elseif ammotype:find("357") and wep:GetClass("tfa_csgo_deagle") then
	    return "weapon_shell_casing_9mm_fallback"
	elseif ammotype:find("smg") or guntype:find("smg") then
		return "weapon_shell_casing_9mm_fallback"
	elseif ammotype:find("buckshot") or ammotype:find("shotgun") or guntype:find("shot") then
		return "weapon_shell_casing_shotgun_fallback"
	end

	return "weapon_shell_casing_rifle_fallback"
end

function EFFECT:Init(data)
	self.WeaponEnt = data:GetEntity()
	self.WeaponEntOG = self.WeaponEnt
	--print(self, self.WeaponEnt)
	if not IsValid(self.WeaponEnt) then return end
	self.Attachment = data:GetAttachment()
	self.Position = self:GetTracerShootPos(data:GetOrigin(), self.WeaponEnt, self.Attachment)

	if IsValid(self.WeaponEnt.Owner) then
		if self.WeaponEnt.Owner == LocalPlayer() then
			if not self.WeaponEnt:IsFirstPerson() then
				ang = self.WeaponEnt.Owner:EyeAngles()
				ang:Normalize()
				--ang.p = math.max(math.min(ang.p,55),-55)
				self.Forward = ang:Forward()
			else
				self.WeaponEnt = self.WeaponEnt.Owner:GetViewModel()
			end
			--ang.p = math.max(math.min(ang.p,55),-55)
		else
			ang = self.WeaponEnt.Owner:EyeAngles()
			ang:Normalize()
			self.Forward = ang:Forward()
		end
	end

	self.Forward = self.Forward or data:GetNormal()
	self.Angle = self.Forward:Angle()
	self.ParticleName = self:FindShell(self.WeaponEntOG)
	local pcf = CreateParticleSystem(self.WeaponEnt, self.ParticleName, PATTACH_POINT_FOLLOW, self.Attachment)

	if IsValid(pcf) then
		pcf:StartEmission()
	end

	timer.Simple(0.5, function()
		if IsValid(pcf) then
			pcf:StopEmissionAndDestroyImmediately()
		end
	end)
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end