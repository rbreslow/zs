INC_CLIENT()

SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false

SWEP.Slot = 4
SWEP.SlotPos = 0

function SWEP:ShootBullets()
	local owner = self:GetOwner()
	self:SendWeaponAnim(ACT_VM_THROW)
	owner:DoAttackEvent()
end

function SWEP:DrawWeaponSelection(x, y, w, h, alpha)
	self:BaseDrawWeaponSelection(x, y, w, h, alpha)
end

local colBG = Color(16, 16, 16, 90)
local colWhite = Color(220, 220, 220, 230)

function SWEP:DrawHUD()
	self:DrawWeaponCrosshair()
end
