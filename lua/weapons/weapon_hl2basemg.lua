SWEP.Base = "weapon_hl2base"
SWEP.Category = "Half-Life 2 Remake"

DEFINE_BASECLASS("weapon_hl2base")

SWEP.Cone = Vector( .03, .03, 0)
SWEP.TraceFreq = 3

SWEP.Primary.Damage = 5

function SWEP:GetPrimaryAttackActivity()
    if self:GetShotsFired() < 2 then
        return ACT_VM_PRIMARYATTACK
    elseif self:GetShotsFired() < 3 then
        return ACT_VM_RECOIL1
    elseif self:GetShotsFired() < 4 then
        return ACT_VM_RECOIL2
    end

    return ACT_VM_RECOIL3
end

function SWEP:PrimaryAttack()
    if not self:CanPrimaryAttack() then return end
    local owner = self:GetOwner()

    owner:MuzzleFlash()

    self:EmitSound(self.SINGLE)
    self:SetWeaponAnim(self:GetPrimaryAttackActivity())

    -- player "shoot" animation
    owner:SetAnimation(PLAYER_ATTACK1)

    self:GetOwner():FireBullets({
        Src = owner:GetShootPos(),
        Dir = (owner:GetAimVector():Angle() + owner:GetViewPunchAngles()):Forward(),
        Num = self.BulletsPerShot,
        AmmoType = self.Primary.Ammo,
        Tracer = self.TracerFreq,
        TracerName = self.Tracer,
        Attacker = self:GetOwner(),
        Spread = self:GetAimCone(),
        Damage = self.Primary.Damage,
        Callback = function(atk, tr, dmg)
            self:BulletCallback(atk, tr, dmg)
        end
    })

    self:TakePrimaryAmmo(1)
    self:SetNextPrimaryFire(self:GetRapidFire() and 0 or CurTime() + self.Primary.Delay)
    self:SetNextSecondaryFire(self:GetRapidFire() and 0 or CurTime() + self.Primary.Delay)

    self:SetShotsFired(self:GetShotsFired() + 1)

    self:OnPrimaryAttack()
    self:AddViewKick()
end

function SWEP:AddViewKick()
    local MAX_VERTICAL_KICK = 1
    local SLIDE_LIMIT = 2

    self:DoMachineGunKick(nil, MAX_VERTICAL_KICK, self:GetFireDuration(), SLIDE_LIMIT)
end

function SWEP:DoMachineGunKick(_, maxVerticalKickAngle, fireDurationTime, slideLimitTime)
    local KICK_MIN_X = 0.2 --Degrees
    local KICK_MIN_Y = 0.2 --Degrees
    local KICK_MIN_Z = 0.1 --Degrees

    local angScratch = Angle(0,0,0)

    -- Find how far into our accuracy degradation we are
    local duration = ( fireDurationTime > slideLimitTime ) and slideLimitTime or fireDurationTime
    local kickPerc = duration / slideLimitTime

    -- do this to get a hard discontinuity, clear out anything under 10 degrees punch
    self:GetOwner():ViewPunchReset( 10 )

    -- Apply this to the view angles as well
    angScratch.x = -( KICK_MIN_X + ( maxVerticalKickAngle * kickPerc ) )
    angScratch.y = -( KICK_MIN_Y + ( maxVerticalKickAngle * kickPerc ) ) / 3
    angScratch.z = KICK_MIN_Z + ( maxVerticalKickAngle * kickPerc ) / 8

    -- Wibble left and right
    if util.SharedRandom("KickBackY", -1, 1 ) >= 0 then
        angScratch.y = angScratch.y * -1
    end

    -- Wobble up and down
    if util.SharedRandom("KickBackZ", -1, 1 ) >= 0 then
        angScratch.z = angScratch.z * -1
    end

    -- Clip this to our desired min/max
    angScratch = util.ClipPunchAngleOffset( angScratch, self:GetOwner():GetViewPunchAngles(), Angle( 24.0, 3.0, 1.0 ) );

    -- Add it to the view punch
    -- NOTE: 0.5 is just tuned to match the old effect before the punch became simulated
    self:GetOwner():ViewPunch( angScratch * 0.5 );
end

function SWEP:Think()
    BaseClass.Think(self)
    local owner = self:GetOwner()
    if not owner then return end

    if owner:KeyDown(IN_ATTACK) and self:Clip1() > 0 then
        self:SetFireDuration(self:GetFireDuration() + FrameTime())
    else
        self:SetFireDuration(0)
    end

    if not owner:KeyDown(IN_ATTACK) or self:Clip1() <= 0 then
        self:SetShotsFired(0)
    end
end
