AddCSLuaFile()

SWEP.Base = "weapon_hl2base"
SWEP.Category = "Counter-Strike: Global Offensive"
SWEP.IsSWCSWeapon = true

AccessorFunc(SWEP, "m_iUnsharedSeed", "UnsharedSeed", FORCE_NUMBER)

local IronSight_should_approach_unsighted = 0
local IronSight_should_approach_sighted = 1
local IronSight_viewmodel_is_deploying = 2
local IronSight_weapon_is_dropped = 3

local bIsTTT = util.NetworkStringToID("TTT_RoundState") ~= 0

if bIsTTT then
    SWEP.bIsTTT = true
    --SWEP.AutoSpawnable = false
end

AddCSLuaFile "cl_crosshair.lua"

include "sh_penetration.lua"
include "sh_recoil.lua"
include "sh_econ.lua"
include "sh_effects.lua"

local function VectorMA(start, scale, dir, dest)
    dest.x = start.x + scale * dir.x
    dest.y = start.y + scale * dir.y
    dest.z = start.z + scale * dir.z
end

SURFACE_PROP_DEFAULT = util.GetSurfaceIndex("default")

CS_MASK_SHOOT = bit.bor(MASK_SHOT, CONTENTS_DEBRIS)

Primary_Mode = 0
Secondary_Mode = 1

DEFINE_BASECLASS(SWEP.Base)

sound.Add({
    name = "Default.NearlyEmpty",
    channel = CHAN_ITEM,
    level = 65,
    volume = 1,
    sound = "weapons/csgo/lowammo_01.wav"
})
sound.Add({
    name = "Weapon.WeaponMove1",
    channel = CHAN_ITEM,
    level = 65,
    volume = {0.05, 0.1},
    pitch = {98, 101},
    sound = "weapons/csgo/movement1.wav"
})
sound.Add({
    name = "Weapon.WeaponMove2",
    channel = CHAN_ITEM,
    level = 65,
    volume = {0.05, 0.1},
    pitch = {98, 101},
    sound = "weapons/csgo/movement2.wav"
})
sound.Add({
    name = "Weapon.WeaponMove3",
    channel = CHAN_ITEM,
    level = 65,
    volume = {0.05, 0.1},
    pitch = {98, 101},
    sound = "weapons/csgo/movement3.wav"
})
sound.Add({
    name = "Weapon.AutoSemiAutoSwitch",
    channel = CHAN_STATIC,
    level = 65,
    volume = 1.0,
    pitch = {98, 101},
    sound = "weapons/csgo/auto_semiauto_switch.wav"
})

AccessorFunc(SWEP, "m_sWeaponType", "WeaponType", FORCE_STRING)
AccessorFunc(SWEP, "m_sZoomOutSound", "ZoomOutSound", FORCE_STRING)
AccessorFunc(SWEP, "m_sZoomInSound", "ZoomInSound", FORCE_STRING)
AccessorFunc(SWEP, "m_flDeploySpeed", "DeploySpeed", FORCE_NUMBER)

SWEP.UseHands = true
SWEP.ViewModelFOV = 68

function SWEP:GetShotgunReloadState() return 0 end -- only shotguns use this for multi-stage reloads

function SWEP:SetupDataTables()
    BaseClass.SetupDataTables(self)
    self:NetworkVar("Bool", 2, "InInspect")
    self:NetworkVar("Bool", 3, "SilencerOn")
    self:NetworkVar("Bool", 4, "ResumeZoom")
    self:NetworkVar("Bool", 5, "BurstMode")
    self:NetworkVar("Bool", 6, "IsLookingAtWeapon")

    self:NetworkVar("Int", 1, "ZoomLevel")
    self:NetworkVar("Int", 2, "WeaponMode")
    self:NetworkVar("Int", 3, "BurstShotsRemaining")
    self:NetworkVar("Int", 4, "SharedSeed")
    self:NetworkVar("Int", 5, "IronSightMode")
    self:NetworkVar("Int", 6, "ReserveAmmo")

    self:NetworkVar("Float", 3, "AccuracyPenalty")
    self:NetworkVar("Float", 4, "RecoilIndex")
    self:NetworkVar("Float", 5, "AccuracyFishtail")
    self:NetworkVar("Float", 6, "DoneSwitchingSilencer")
    self:NetworkVar("Float", 7, "NextBurstShot")
    self:NetworkVar("Float", 8, "PostponeFireReadyTime")
    self:NetworkVar("Float", 9, "LookWeaponEndTime")
    self:NetworkVar("Float", 10,"WeaponIdleTime")

    self:NetworkVar("Angle", 0, "RawAimPunchAngle")
    self:NetworkVar("Angle", 1, "AimPunchAngleVel")
    self:NetworkVar("Angle", 2, "ViewPunchAngle")
end

function SWEP:GetRandomSeed()
    if SWCS_SPREAD_SHARE_SEED:GetBool() then
        return bit.band(math.floor(self:GetSharedSeed()), 255)
    else
        return bit.band(math.floor(self:GetUnsharedSeed() or 0), 255)
    end
end
function SWEP:SetRandomSeed(iSeed)
    if SWCS_SPREAD_SHARE_SEED:GetBool() then
        self:SetSharedSeed(math.floor(iSeed))
    else
        self:SetUnsharedSeed(math.floor(iSeed))
    end
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
local function MACRO__SetupItemDefGetterHasAlt(tab, name, attribute, force_type, scale, default)
    local fnName = "Get" .. name

    MACRO__SetupItemDefGetter(tab, name .. "1", attribute, force_type, scale, default)
    MACRO__SetupItemDefGetter(tab, name .. "2", attribute .. " alt", force_type, scale, default)

    tab[fnName] = function(self)
        if self:GetWeaponMode() == Primary_Mode then
            return self["Get" .. name .. "1"](self)
        else
            return self["Get" .. name .. "2"](self)
        end
    end
end

local weapon_recoil_scale = GetConVar"weapon_recoil_scale"
function SWEP:GetAimPunchAngle()
    local ret = self:GetRawAimPunchAngle() * weapon_recoil_scale:GetFloat()
    ret:Normalize()
    return ret
end

local deployoverride = SWCS_DEPLOY_OVERRIDE
local deployspeed = GetConVar"sv_defaultdeployspeed"
function SWEP:GetDeploySpeed()
    if deployoverride:GetFloat() ~= 0 then
        return deployoverride:GetFloat()
    end

    return self.bIsTTT and 1.4 or deployspeed:GetFloat()
end

SWEP.ItemDefAttributes = [=["attributes 04/22/2020" {}]=]
SWEP.ItemDefVisuals = [=["visuals 07/07/2020" {}]=]
SWEP.ItemDefPrefab = [=["prefab 08/11/2020" {}]=]
function SWEP:Initialize()
    local attributes = util.KeyValuesToTable(self.ItemDefAttributes, true, false)
    self.ItemAttributes = attributes
    local visuals = util.KeyValuesToTable(self.ItemDefVisuals, true, false)
    self.ItemVisuals = visuals
    local prefab = util.KeyValuesToTable(self.ItemDefPrefab, true, false)
    self.ItemPrefab = prefab

    -- csgo doesn't share the random seed, so we try to emulate that here
    -- servers and clients will never have the exact same uptime
    self:SetUnsharedSeed( SysTime() / engine.TickInterval() )
    self:SetSharedSeed(0)

    MACRO__SetupItemDefGetter(self, "DefCycleTime", "cycletime")
    MACRO__SetupItemDefGetterHasAlt(self, "MaxSpeed", "max player speed")
    MACRO__SetupItemDefGetter(self, "Damage", "damage")
    MACRO__SetupItemDefGetter(self, "Range", "range")
    MACRO__SetupItemDefGetter(self, "ClipSize", "primary clip size")
    MACRO__SetupItemDefGetter(self, "Penetration", "penetration")
    MACRO__SetupItemDefGetter(self, "RangeModifier", "range modifier", nil, nil, 0.980000)
    MACRO__SetupItemDefGetter(self, "Bullets", "bullets", nil, nil, 1)
    MACRO__SetupItemDefGetterHasAlt(self, "TracerFreq", "tracer frequency")

    MACRO__SetupItemDefGetter(self, "AttackMovespeedFactor", "attack movespeed factor", nil, nil, 1)

    MACRO__SetupItemDefGetterHasAlt(self, "RecoilMagnitude", "recoil magnitude")

    MACRO__SetupItemDefGetter(self, "SpreadSeed", "spread seed", nil, nil, 0)

    MACRO__SetupItemDefGetter(self, "InaccuracyAltSwitch", "inaccuracy alt switch")
    MACRO__SetupItemDefGetterHasAlt(self, "Spread", "spread", nil, 0.001)
    MACRO__SetupItemDefGetterHasAlt(self, "InaccuracyMove", "inaccuracy move", nil, 0.001)
    MACRO__SetupItemDefGetterHasAlt(self, "InaccuracyLadder", "inaccuracy ladder", nil, 0.001)
    MACRO__SetupItemDefGetterHasAlt(self, "InaccuracyFire", "inaccuracy fire", nil, 0.001)
    MACRO__SetupItemDefGetterHasAlt(self, "InaccuracyReload", "inaccuracy reload", nil, 0.001)
    MACRO__SetupItemDefGetterHasAlt(self, "InaccuracyCrouch", "inaccuracy crouch", nil, 0.001)
    MACRO__SetupItemDefGetterHasAlt(self, "InaccuracyStand", "inaccuracy stand", nil, 0.001)
    MACRO__SetupItemDefGetterHasAlt(self, "InaccuracyJump", "inaccuracy jump", nil, 0.001)
    MACRO__SetupItemDefGetterHasAlt(self, "InaccuracyJumpApex", "inaccuracy jump apex", nil, 0.001, 0)
    MACRO__SetupItemDefGetterHasAlt(self, "InaccuracyJumpInitial", "inaccuracy jump initial", nil, 0.001)

    --float GetInaccuracyLand ( const CEconItemView* pWepView = NULL, int nAlt = 0, float flScale = 0.001f ) const;

    MACRO__SetupItemDefGetter(self, "ZoomTime0", "zoom time 0")
    MACRO__SetupItemDefGetter(self, "ZoomFOV1", "zoom fov 1")
    MACRO__SetupItemDefGetter(self, "ZoomTime1", "zoom time 1")
    MACRO__SetupItemDefGetter(self, "ZoomFOV2", "zoom fov 2")
    MACRO__SetupItemDefGetter(self, "ZoomTime2", "zoom time 2")

    MACRO__SetupItemDefGetter(self, "IdleInterval", "idle interval", nil, nil, 20)
    MACRO__SetupItemDefGetter(self, "TimeToIdleAfterFire", "time to idle", nil, nil, 2)

    MACRO__SetupItemDefGetter(self, "RecoveryTimeStand", "recovery time stand")
    MACRO__SetupItemDefGetter(self, "RecoveryTimeStandFinal", "recovery time stand final")
    MACRO__SetupItemDefGetter(self, "RecoveryTimeCrouch", "recovery time crouch")
    MACRO__SetupItemDefGetter(self, "RecoveryTimeCrouchFinal", "recovery time crouch final")

    MACRO__SetupItemDefGetter(self, "RecoveryTransitionStartBullet", "recovery transition start bullet")
    MACRO__SetupItemDefGetter(self, "RecoveryTransitionEndBullet", "recovery transition end bullet")

    MACRO__SetupItemDefGetter(self, "CrosshairDeltaDistance", "crosshair delta distance")
    MACRO__SetupItemDefGetter(self, "CrosshairMinDistance", "crosshair min distance")

    MACRO__SetupItemDefGetter(self, "PrimaryReserveMax", "primary reserve ammo max", nil, nil, 40)

    MACRO__SetupItemDefGetter(self, "IsRevolver", "is revolver", FORCE_BOOL)
    MACRO__SetupItemDefGetter(self, "DoesUnzoomAfterShoot", "unzoom after shot", FORCE_BOOL)
    MACRO__SetupItemDefGetter(self, "HasBurstMode", "has burst mode", FORCE_BOOL)
    MACRO__SetupItemDefGetter(self, "DoesHideViewModelWhenZoomed", "hide view model zoomed", FORCE_BOOL)

    -- sound pitch thing that is only used by the negev
    MACRO__SetupItemDefGetter(self, "InaccuracyPitchShift", "inaccuracy pitch shift")
    MACRO__SetupItemDefGetter(self, "InaccuracyAltSoundThreshold", "inaccuracy alt sound threshold")

    -- secondary fire modes
    MACRO__SetupItemDefGetter(self, "HasSilencer", "has silencer", FORCE_BOOL)
    MACRO__SetupItemDefGetter(self, "ZoomLevels", "zoom levels")
    MACRO__SetupItemDefGetter(self, "TimeBetweenBurstShots", "time between burst shots")
    MACRO__SetupItemDefGetter(self, "CycleTimeInBurstMode", "cycletime when in burst mode")

    self:SetSilencerOn(self:GetHasSilencer())
    self:SetWeaponMode(self:GetHasSilencer() and Secondary_Mode or Primary_Mode)

    --if ( m_iRecoilSeed == 0 && IsGunWeapon(GetWeaponType()) )
    if not self.ItemAttributes["recoil seed"] then
        -- create a temporary seed value based on a hash of the weapon name
        local crc = util.CRC(self:GetClass())
        self.ItemAttributes["recoil seed"] = bit.band(crc, 0xFFFF)
        Msg( Format("RECOIL: No seed found for weapon %s, generated placeholder seed %i\n", self:GetClass(), self.ItemAttributes["recoil seed"] ))
    end

    -- recoil shit defaults
    do
        if not self.ItemAttributes["recoil angle"] then
            self.ItemAttributes["recoil angle"] = 0
        end
        if not self.ItemAttributes["recoil angle alt"] then
            self.ItemAttributes["recoil angle alt"] = 0
        end
        if not self.ItemAttributes["recoil angle variance"] then
            self.ItemAttributes["recoil angle variance"] = 0
        end
        if not self.ItemAttributes["recoil angle variance alt"] then
            self.ItemAttributes["recoil angle variance alt"] = 0
        end
        if not self.ItemAttributes["recoil magnitude"] then
            self.ItemAttributes["recoil magnitude"] = 0
        end
        if not self.ItemAttributes["recoil magnitude alt"] then
            self.ItemAttributes["recoil magnitude alt"] = 0
        end
        if not self.ItemAttributes["recoil magnitude variance"] then
            self.ItemAttributes["recoil magnitude variance"] = 0
        end
        if not self.ItemAttributes["recoil magnitude variance alt"] then
            self.ItemAttributes["recoil magnitude variance alt"] = 0
        end
    end

    self.m_RecoilData = {}
    self:GenerateRecoilTable(self.m_RecoilData)

    self:SetIronSightMode(IronSight_should_approach_unsighted)
    self.m_IronSightController = IronSightController(self)
    self:UpdateIronSightController()

    self:SetWeaponType(string.lower(self.ItemVisuals.weapon_type or ""))
    self:SetZoomOutSound(self.ItemPrefab.zoom_out_sound or "")
    self:SetZoomInSound(self.ItemPrefab.zoom_in_sound or "")
    self.SND_SINGLE = self.ItemVisuals.sound_single_shot -- default primary attack sound
    self.SND_SINGLE_ACCURATE = self.ItemVisuals.sound_single_shot_accurate -- negev uses this
    self.SND_SPECIAL1 = self.ItemVisuals.sound_special1 -- silenced weps use this
    self.SND_NEARLY_EMPTY = self.ItemVisuals.sound_nearlyempty

    self.Primary.ClipSize = self.ItemAttributes["primary clip size"]
    self.Primary.Automatic = tobool(self.ItemAttributes["is full auto"])
    self.Primary.DefaultClip = self.Primary.ClipSize
    self:SetClip1(self.Primary.DefaultClip)

    self:SetReserveAmmo(self:GetPrimaryReserveMax())
end

function SWEP:UpdateIronSightController()
    if not self.m_IronSightController then
        self.m_IronSightController = IronSightController(self)
    end

    if self.m_IronSightController then
        self.m_IronSightController:Init(self)
    end
end

function SWEP:GetCycleTime()
    local flCycleTime = self:GetDefCycleTime()
    return flCycleTime ~= 0 and flCycleTime or .15 -- .15s cycle time = 400 rpm
end

-- called whenever the lua file is reloaded
function SWEP:OnReloaded()
    self:Initialize()
end

function SWEP:GetSpread()
    if self:GetWeaponMode() == Primary_Mode then
        return self:GetSpread1()
    elseif self:GetWeaponMode() == Secondary_Mode then
        return self:GetSpread2()
    else
        return 0
    end
end

function SWEP:GetHasZoom()
    return self:GetZoomLevels() ~= 0
end

function SWEP:WeaponIdle()
    if self:GetWeaponIdleTime() > CurTime() then return end

    if self:Clip1() ~= 0 then
        self:SetWeaponIdleTime(CurTime() + self:GetIdleInterval())

        -- silencers are bodygroups, so there is no longer a silencer-specific idle.
        self:SetWeaponAnim(ACT_VM_IDLE)
    end
end

function SWEP:IsUseable()
    local owner = self:GetPlayerOwner()
    if not owner then return false end

    if self:Clip1() <= 0 then
        if self:GetAmmoCount(self:GetPrimaryAmmoType()) <= 0 and self:GetMaxClip1() ~= -1 then
            -- clip is empty ( or nonexistant ) and the player has no more ammo of this type. 
            return false
        end
    end

    return true
end

function SWEP:Think_RevolverResetHaulback(owner)
    if self:GetIsRevolver() then
        self:SetWeaponMode(Secondary_Mode)
        self:ResetPostponeFireReadyTime()

        if self:GetActivity() == ACT_VM_HAULBACK then
            self:SetWeaponAnim(ACT_VM_IDLE)
        end
    end
end

function SWEP:Think_IdleNoActions(owner)
    self:Think_RevolverResetHaulback(owner)

    if CurTime() > self:GetNextPrimaryFire() and self:Clip1() == 0 and self:IsUseable() and not self:GetInReload() then
        self:Reload()
        return
    end

    self:UpdateIronSightController()
    if self:GetIronSightMode() == IronSight_viewmodel_is_deploying and self:GetActivity() ~= ACT_VM_DEPLOY then
        self:SetIronSightMode(IronSight_should_approach_unsighted)
    end

    self:WeaponIdle()
end

function SWEP:Think_ProcessSecondaryAttack(owner)
    if self:GetIsRevolver() then
        -- check misc stuff in csgo
        -- maybe hook call?

        local m_bFireOnEmpty = false
        if ( self:Clip1() == 0 or ( self:GetMaxClip1() == -1 and self:GetAmmoCount( self:GetPrimaryAmmoType() ) == 0 ) ) then
            m_bFireOnEmpty = true
        end

        self:SetWeaponMode(Secondary_Mode)

        if not m_bFireOnEmpty then
            self:ResetPostponeFireReadyTime()

            if self:GetActivity() == ACT_VM_HAULBACK then
                self:SetWeaponAnim(ACT_VM_IDLE)
                return false
            end

            if self:GetPostponeFireReadyTime() < CurTime() then
                return false
            end
        end
    end

    return true
end

function SWEP:OnReloadFail()
    self:StopLookingAtWeapon()
end

function SWEP:CanReload()
    if self:GetInReload() then return false end
    if self:Clip1() >= self:GetMaxClip1() then return false end
    if self:GetNextPrimaryFire() > CurTime() and not (self.GetForceReload and self:GetForceReload()) then return false end

    local owner = self:GetPlayerOwner()
    if not owner then return false end
    if self:GetAmmoCount(self.Primary.Ammo) < 1 then return false end

    return true
end

local activity_buts = bit.bor(IN_ATTACK, IN_ATTACK2, IN_ZOOM)
function SWEP:Think()
    local owner = self:GetPlayerOwner()
    if not owner then return end

    self:UpdateAccuracyPenalty()

    if self:GetInReload() then
        if self:GetFinishReloadTime() > CurTime() then
            self:InReloadThink()
        else
            -- the AE_WPN_COMPLETE_RELOAD event should handle the stocking the clip, but in case it's missing, we can do it here as well
            local j = math.min(self:GetClipSize() - self:Clip1(), self:GetAmmoCount(self:GetPrimaryAmmoType()))

            -- Add them to the clip
            self:SetClip1(self:Clip1() + j)

            if SWCS_INDIVIDUAL_AMMO:GetBool() then
                self:SetReserveAmmo(self:GetReserveAmmo() - j)
            else
                owner:RemoveAmmo(j, self:GetPrimaryAmmoType())
            end

            self:SetInReload(false)
            self:OnFinishReload()
        end
    end

    if owner:KeyDown(IN_ATTACK) and self:GetNextPrimaryFire() <= CurTime() then
        -- ItemPostFrame_ProcessPrimaryAttack(owner)
    elseif owner:KeyDown(IN_ZOOM) and self:GetNextSecondaryFire() <= CurTime() then
        -- ItemPostFrame_ProcessZoomAction(owner)
    elseif owner:KeyDown(IN_ATTACK2) and self:GetNextSecondaryFire() <= CurTime() then
        if self:Think_ProcessSecondaryAttack(owner) then
            -- remove IN_ATTACK2 from buttons
        end
    elseif owner:KeyDown(IN_RELOAD) and self:GetMaxClip1() ~= -1 and not self:GetInReload() and self:GetNextPrimaryFire() < CurTime() then
        -- ItemPostFrame_ProcessReloadAction(owner)
    elseif not owner:KeyDown(activity_buts) then
        self:Think_IdleNoActions(owner)
    end

    if self:GetIsLookingAtWeapon() and self:GetLookWeaponEndTime() <= CurTime() then
        self:StopLookingAtWeapon()
    end

    if owner:KeyDown(activity_buts) then
        self:StopLookingAtWeapon()
    end

    if owner:KeyDown(IN_ATTACK3) then
        self:TertiaryAttack()
    end

    -- GOOSEMAN : Return zoom level back to previous zoom level before we fired a shot. This is used only for the AWP.
    if self:GetResumeZoom() and self:GetNextPrimaryFire() <= CurTime()
        and self:GetZoomLevel() > 0 then -- only need to re-zoom the zoom when there's a zoom to re-zoom to. who knew?
        if self:Clip1() ~= 0 then
            self:SetWeaponMode(Secondary_Mode)
            owner:SetFOV(self:GetZoomFOV(self:GetZoomLevel()), 0.1)
        end

        owner.swcs_m_bIsScoped = true
        self:SetResumeZoom(false)
    end

    if self:GetHasBurstMode() and self:GetBurstShotsRemaining() > 0 and self:GetNextBurstShot() <= CurTime() then
        self:BurstFireRemaining()
    end

    if self:GetIsRevolver() and not owner:KeyDown(bit.bor(IN_ATTACK, IN_ATTACK2, IN_ATTACK3, IN_RELOAD)) then-- not holding any weapon buttons
        self:SetWeaponMode(Secondary_Mode)
        self:ResetPostponeFireReadyTime()
        if self:GetActivity() == ACT_VM_HAULBACK then
            self:SetWeaponAnim(ACT_VM_IDLE)
        end
    end

    self:UpdateIronSightController()
    if self:GetIronSightMode() == IronSight_viewmodel_is_deploying and self:GetActivity() ~= ACT_VM_DEPLOY then
        self:SetIronSightMode(IronSight_should_approach_unsighted)
    end
end

function SWEP:GetPlayerOwner()
    local owner = self:GetOwner()
    if not (owner:IsValid() and owner:IsPlayer()) then return false end

    return owner
end

function SWEP:TertiaryAttack()
    self:LookAtHeldWeapon()
end

function SWEP:StopLookingAtWeapon()
    self:SetIsLookingAtWeapon(false)
end

function SWEP:LookAtHeldWeapon()
    if self:GetIsLookingAtWeapon() then return end

    local nSequence = ACT_INVALID

    -- Can't taunt while zoomed, reloading, or switching silencer
    if self:IsZoomed() or self:GetInReload() or self:GetDoneSwitchingSilencer() >= CurTime() then
        return
    end

    -- don't let me inspect a shotgun that's reloading
    if self:GetWeaponType() == "shotgun" and self:GetShotgunReloadState() ~= 0 then
        return
    end

    if self.m_IronSightController and self.m_IronSightController.m_iIronSightMode == IronSight_should_approach_sighted then
        return
    end

    local vm = self:GetOwner():GetViewModel()
    if vm:IsValid() then
        nSequence = vm:SelectWeightedSequence(ACT_VM_IDLE_LOWERED)

        if nSequence == ACT_INVALID then
            nSequence = vm:LookupSequence("lookat01")
        end

        if self:GetHasSilencer() then
            self:SetBodyGroup("silencer", self:GetSilencerOn() and 0 or 1)
        end

        if nSequence ~= ACT_INVALID then
            self:SetIsLookingAtWeapon(true)
            self:SetLookWeaponEndTime(CurTime() + vm:SequenceDuration(nSequence))

            self:SetWeaponSequence(nSequence)
        end
    end
end

function SWEP:BurstFireRemaining()
    local owner = self:GetPlayerOwner()
    if not owner or self:Clip1() <= 0 then
        self:SetClip1(0)
        self:SetBurstShotsRemaining(0)
        self:SetNextBurstShot(0)
        return
    end

    self:FX_FireBullets()
    self:DoFireEffects()

    self:SetWeaponAnim(self:PrimaryAttackAct())

    owner:SetAnimation(PLAYER_ATTACK1)

    self:SetBurstShotsRemaining(self:GetBurstShotsRemaining() - 1)

    if self:GetBurstShotsRemaining() > 0 then
        self:SetNextBurstShot(CurTime() + self:GetTimeBetweenBurstShots())
    else
        self:SetNextBurstShot(0)
    end

    self:SetAccuracyPenalty(self:GetAccuracyPenalty() + self:GetInaccuracyFire())

    self:Recoil(self:GetWeaponMode())

    self:SetShotsFired(self:GetShotsFired() + 1)
    self:SetRecoilIndex(self:GetRecoilIndex() + 1)
    self:TakePrimaryAmmo(1)

    self:OnPrimaryAttack()
end

if CLIENT then
    function SWEP:DrawWorldModel()
        if not IsValid(self.cl_wm) and self.WorldModelPlayer then
            local mdl = ClientsideModel(self.WorldModelPlayer)
            mdl:SetNoDraw(true)
            self.cl_wm = mdl
        end

        local owner = self:GetPlayerOwner()

        if IsValid(self.cl_wm) and
                owner and ((owner == LocalPlayer() and owner:ShouldDrawLocalPlayer()) or
                ((LocalPlayer():GetObserverTarget() == owner and LocalPlayer():GetObserverMode() ~= OBS_MODE_IN_EYE) or LocalPlayer():GetObserverTarget() ~= owner )) then
            local mdl = self.cl_wm

            local attRH = owner:LookupAttachment("anim_attachment_RH")
            local attLH = owner:LookupAttachment("anim_attachment_LH")
            if attRH > 0 then
                local _t = owner:GetAttachment(attRH)
                local bnep,bnea = _t.Pos, _t.Ang

                _t = owner:GetAttachment(attLH)
                local lhp = _t.Pos

                local wep_attRH = mdl:LookupAttachment("weapon_hand_R")
                local wep_attLH = mdl:LookupAttachment("weapon_hand_L")
                local wrhp = Vector()
                if wep_attRH > 0 then
                    local __t = mdl:GetAttachment(wep_attRH)
                    wrhp = __t.Pos
                end

                local wlhp = Vector()
                if wep_attLH > 0 then
                    local __t = mdl:GetAttachment(wep_attLH)
                    wlhp = __t.Pos
                end

                -- calc angle so that rifles sit in left hand
                --[[if wep_attLH > 0 and attLH > 0 then
                    local dPos = (wlhp - lhp)
                    dPos:Normalize()

                    local ang = dPos:Angle()
                    ang:Normalize()

                    --bnea:Set(-ang)
                end]]

                -- position handle in right hand
                local mdlLocalPos = (wrhp - mdl:GetPos())
                bnep:Add(-mdlLocalPos)

                for id, val in next, self.WM_BodyGroups do
                    mdl:SetBodygroup(id, val)
                end

                -- finalize
                mdl:SetPos(bnep)
                mdl:SetAngles(bnea)
                render.SetColorModulation(1, 1, 1)

                self:PreDrawCustomWM(mdl, attRH, attLH)
                mdl:DrawModel()
                self:PostDrawCustomWM(mdl, attRH, attLH)

                return
            end
        end

        self:DrawModel()
    end

    function SWEP:PostDrawCustomWM(wm, attRH, attLH)
        --self:PreDrawCustomWM(wm, attRH, attLH)
    end

    function SWEP:PreDrawCustomWM(wm, attRH, attLH)
        --
    end

    local viewmodel_offset_x = GetConVar"viewmodel_offset_x"
    local viewmodel_offset_y = GetConVar"viewmodel_offset_y"
    local viewmodel_offset_z = GetConVar"viewmodel_offset_z"

    local function SmoothCurve(x)
        return 1 - math.cos( x * math.pi) * 0.5
    end

    local cl_gunlowerangle = CreateConVar("cl_gunlowerangle", "2")
    local cl_gunlowerspeed = CreateConVar("cl_gunlowerspeed", "0.1")
    SWEP.m_vLoweredWeaponOffset = Vector()
    function SWEP:ApplyViewModelPitchAndDip(vecNewOrigin, vecNewAngles)
        local owner = self:GetPlayerOwner()
        if not owner then return end
        --do return end
        -- Check for lowering the weapon
        -- C_CSPlayer *pPlayer = ToCSPlayer( owner );
        -- Assert( pPlayer );

        local bJumping = not owner:IsFlagSet(FL_ONGROUND)

        local bLowered = bJumping--pPlayer->IsWeaponLowered();

        local vecLoweredAngles = Angle(0,0,0)

        self.m_vLoweredWeaponOffset.x = math.Approach( self.m_vLoweredWeaponOffset.x, bLowered and cl_gunlowerangle:GetFloat() or 0, cl_gunlowerspeed:GetFloat() );
        vecLoweredAngles.x = vecLoweredAngles.x + self.m_vLoweredWeaponOffset.x
        vecNewAngles:Set(vecNewAngles - (vecLoweredAngles * 0.2))
        vecNewOrigin.z = vecNewOrigin.z - (vecLoweredAngles.x * 0.4) -- translation offset looks more natural than rotation

        local flDipAddAmt = 0.0
        local flOldFallVel = owner:GetVelocity().z
        -- This does the dip when you land
        -- m_Local.m_bInLanding gets set on the client in baseplayer_shared.cpp  -- mtw
        if ( owner and owner.m_bInLanding ) then--&& owner->m_Local.m_bInLanding == true ) then
            local flDipAmt = 0.005 --weapon_land_dip_amt.GetFloat();

            local landseconds = math.max(CurTime() - ((owner.m_flLandingTime or 0) - 0.1), 0.0)
            local landFraction = SmoothCurve( landseconds / 0.25 )
            --clamp( landFraction, 0.0, 1.0 )

            local flDipAmount = (1 / flOldFallVel) * flDipAmt

            local dipHighOffset = 64
            local dipLowOffset = dipHighOffset - flDipAmt

            local temp = owner:GetViewOffset()
            temp.z = ( ( dipLowOffset - flDipAmount ) * landFraction ) +
                ( dipHighOffset * ( 1 - landFraction ) )

            if ( temp.z > dipHighOffset ) then
                temp.z = dipHighOffset
            end

            --owner:SetViewOffset(temp) -- replicate csgo behavior by setting
            flDipAddAmt = ( dipHighOffset - temp.z )
        end
    end

    SWEP.m_angCamDriverLastAng = Angle()
    SWEP.m_vecCamDriverLastPos = Vector()
    SWEP.m_flCamDriverAppliedTime = 0
    function SWEP:PostBuildTransformations(vm)
        local iCamDriverBone = vm:LookupBone("cam_driver")
        if iCamDriverBone and iCamDriverBone ~= -1 then
            local bPos, bAng = vm:GetBonePosition(iCamDriverBone)

            --print("driver posang", bPos, bAng)

            self.m_flCamDriverAppliedTime = CurTime()
            self.m_vecCamDriverLastPos = bPos
            self.m_angCamDriverLastAng = bAng
        end
    end

    local viewmodel_recoil = GetConVar"viewmodel_recoil"
    local view_recoil_tracking = GetConVar"view_recoil_tracking"
    function SWEP:CalcViewModelView(vm, oldPos, oldAng, pos, ang)
        local ret_pos, ret_ang = oldPos * 1, oldAng * 1
        local vRight, vUp, vForward = oldAng:Right(), oldAng:Up(), oldAng:Forward()

        local ironSightController = self.m_IronSightController
        local pa = self:GetAimPunchAngle()
        if ironSightController and ironSightController:IsInIronSight() then
            local flInvIronSightAmount = ( 1.0 - ironSightController.m_flIronSightAmount )

            vForward = vForward * flInvIronSightAmount
            vUp = vUp * flInvIronSightAmount
            vRight =	vRight * flInvIronSightAmount

            pa:Normalize()
            pa = pa * math.max(flInvIronSightAmount, view_recoil_tracking:GetFloat())
            --pa:Normalize()
        end

        -- custom viewmodel offset for players
        ret_pos:Add(vForward * viewmodel_offset_y:GetFloat() + vUp * viewmodel_offset_z:GetFloat() + vRight * viewmodel_offset_x:GetFloat())

        -- little bob animation from csgo
        self:AddViewModelBob(vm, ret_pos, ret_ang)
        --self:CalcViewModelLag(vm, ret_pos, ret_ang)

        -- add aimpunch, viewpunch angles
        ret_ang:Add(pa * viewmodel_recoil:GetFloat())
        ret_ang:Add(self:GetViewPunchAngle())

        self:ApplyViewModelPitchAndDip(ret_pos, ret_ang)

        ret_ang:Normalize()

        if self.m_IronSightController then
            local iron = self.m_IronSightController

            iron:ApplyIronSightPositioning(ret_pos, ret_ang)
            if iron:IsInIronSight() then
                vm:SetLocalPos(LerpVector(iron.m_flIronSightAmountGained, vm:GetLocalPos(), ret_pos))
                vm:SetLocalAngles(LerpAngle(iron.m_flIronSightAmountGained, vm:GetLocalAngles(), ret_ang))
            end
        end

        return ret_pos, ret_ang
    end

    -- Purpose: Allow the viewmodel to layer in artist-authored additive camera animation (to make some first-person anims 'punchier')
    local CAM_DRIVER_RETURN_TO_NORMAL = 0.25
    local CAM_DRIVER_RETURN_TO_NORMAL_GAIN = 0.8
    SWEP.m_flCamDriverWeight = 0
    function SWEP:CalcAddViewmodelCameraAnimation(eyeOrigin, eyeAngles)
        local owner = self:GetPlayerOwner()
        if not owner then return end

        local vm = owner:GetViewModel(self:ViewModelIndex())
        if not vm:IsValid() then return end

        local flTimeDelta = math.Clamp(CurTime() - self.m_flCamDriverAppliedTime, 0, CAM_DRIVER_RETURN_TO_NORMAL)

        --print("wtf!!", CurTime(), CurTime() - self.m_flCamDriverAppliedTime, flTimeDelta < CAM_DRIVER_RETURN_TO_NORMAL)
        --print("e", self.m_flCamDriverWeight, flTimeDelta < CAM_DRIVER_RETURN_TO_NORMAL)

        if flTimeDelta < CAM_DRIVER_RETURN_TO_NORMAL then
            self.m_flCamDriverWeight = math.Clamp(util.Gain(util.RemapValClamped(flTimeDelta, 0, CAM_DRIVER_RETURN_TO_NORMAL, 1, 0), CAM_DRIVER_RETURN_TO_NORMAL_GAIN), 0, 1)

            --eyeOrigin:Add(self.m_vecCamDriverLastPos * self.m_flCamDriverWeight)
            --eyeAngles:Add(self.m_angCamDriverLastAng * self.m_flCamDriverWeight)
            eyeAngles:Set(self.m_angCamDriverLastAng * self.m_flCamDriverWeight)
            --eyeAngles.x = (self.m_angCamDriverLastAng * self.m_flCamDriverWeight).x
            --eyeAngles.y = (self.m_angCamDriverLastAng * self.m_flCamDriverWeight).y
            --eyeAngles.z = (self.m_angCamDriverLastAng * self.m_flCamDriverWeight).z
        else
            self.m_flCamDriverWeight = 0
        end
    end

    function SWEP:CalcView(ply,pos,ang,fov)
        local vpang = self:GetViewPunchAngle()

        local apang = self:GetAimPunchAngle()

        apang:Mul(view_recoil_tracking:GetFloat())
        ang:Add(apang)
        ang:Add(vpang)

        -- currently only used by the r8 revolver
        --self:CalcAddViewmodelCameraAnimation(pos, ang)
        ang:Normalize()

        local iron = self.m_IronSightController
        if iron and iron:IsInitializedAndAvailable() then
            fov = iron:GetIronSightFOV(fov, false)
        end

        --self.ViewModelFOV = 68
        --self.ViewModelFOV = 68 - (100 - fov)

        return pos, ang, fov
    end

    local cl_bob_lower_amt = GetConVar"cl_bob_lower_amt"
    local cl_bobcycle = CreateConVar("cl_bobcycle", "0.98", FCVAR_ARCHIVE, "aaaaaaaa")
    local cl_viewmodel_shift_left_amt = CreateConVar("cl_viewmodel_shift_left_amt", "1.5", FCVAR_ARCHIVE, "eeeeeeee")
    local cl_viewmodel_shift_right_amt = CreateConVar("cl_viewmodel_shift_right_amt", "0.75", FCVAR_ARCHIVE, "eeeeeeee")
    local cl_bobup = CreateConVar("cl_bobup", "0.5", FCVAR_CHEAT, "iiiiiii")
    local cl_bobamt_vert = CreateConVar("cl_bobamt_vert", "0.25", FCVAR_ARCHIVE, "ooooooo")
    local cl_bobamt_lat = CreateConVar("cl_bobamt_lat", "0.4", FCVAR_ARCHIVE, "uuuuuu")

    local cl_use_new_headbob = CreateClientConVar("cl_use_new_headbob", "1")
    local g_lateralBob = 0
    local g_verticalBob = 0

    local m_flGunAccuracyPosition = 0
    local function CalcViewModelBobHelper(ply, wep)
        local bobState = wep.m_bobState
        local cycle

        if FrameTime() <= 0 or not ply:IsValid() then return 0 end

        local speed = ply:GetVelocity():Length2D()

        local flSpeedFactor = 0
        local flRunAddAmt = 0.0
        local flmaxSpeedDelta = math.max( 0, (CurTime() - bobState.m_flLastBobTime ) * 640.0 )

        speed = math.Clamp( speed, bobState.m_flLastSpeed-flmaxSpeedDelta, bobState.m_flLastSpeed + flmaxSpeedDelta )
        speed = math.Clamp( speed, -320.0, 320.0 )

        bobState.m_flLastSpeed = speed

        if not wep:IsZoomed() then
            flSpeedFactor = speed * 0.006
            flSpeedFactor = math.Clamp( flSpeedFactor, 0.0, 0.5 )
            local flLowerAmt = cl_bob_lower_amt:GetFloat() * 0.2

            flRunAddAmt = ( flLowerAmt * flSpeedFactor )
        end

        local bob_offset = util.RemapVal( speed, 0.0, 320.0, 0.0, 1.0 )

        bobState.m_flBobTime =  bobState.m_flBobTime + (( CurTime() - bobState.m_flLastBobTime ) * bob_offset)
        bobState.m_flLastBobTime = CurTime()

        local flBobCycle = 0.5
        local flAccuracyDiff = 0
        local flGunAccPos = 0

        if ply:IsValid() and wep:IsValid() then
            local flMaxSpeed = wep:GetMaxSpeed()
            flBobCycle = (((1000 - flMaxSpeed) / 3.5) * 0.001) * cl_bobcycle:GetFloat()

            local flAccuracy = 0.0

            local bIsElites = wep.IsElites

            if not wep:GetInReload() and not bIsElites then
                local flCrouchAccuracy = wep:GetInaccuracyCrouch()
                local flBaseAccuracy = wep:GetInaccuracyStand()
                if ply:IsFlagSet(FL_DUCKING) then
                    flAccuracy = flCrouchAccuracy
                else
                    flAccuracy = wep:GetInaccuracy()
                end

                local bIsSniper = wep:GetWeaponType() == "sniperrifle"

                local flMultiplier = 1
                if ( flAccuracy < flBaseAccuracy ) then
                    if ( not bIsSniper ) then
                        flMultiplier = 18
                    else
                        flMultiplier = 0.15
                    end

                    flMultiplier = flMultiplier * cl_viewmodel_shift_left_amt:GetFloat()
                else
                    flAccuracy = math.min( flAccuracy, 0.082 )
                    flMultiplier = flMultiplier * cl_viewmodel_shift_right_amt:GetFloat()
                end

                flAccuracyDiff = math.max( (flAccuracy - flBaseAccuracy) * flMultiplier, -0.1)
            end

            math.Approach(m_flGunAccuracyPosition, flAccuracyDiff * 80, math.abs(((flAccuracyDiff * 80) - m_flGunAccuracyPosition) * FrameTime()) * 40)
            flGunAccPos = m_flGunAccuracyPosition
        else
            flBobCycle = (((1000.0 - 150) / 3.5) * 0.001) * cl_bobcycle:GetFloat()
        end

        cycle = bobState.m_flBobTime - math.floor(bobState.m_flBobTime / flBobCycle) * flBobCycle
        cycle = cycle / flBobCycle

        if ( cycle < cl_bobup:GetFloat() ) then
            cycle = math.pi * cycle / cl_bobup:GetFloat()
        else
            cycle = math.pi + math.pi * (cycle-cl_bobup:GetFloat()) / (1.0 - cl_bobup:GetFloat())
        end

        local flBobMultiplier = 0.00625

        if not ply:IsFlagSet(FL_ONGROUND) then
            flBobMultiplier = 0.00125
        end

        local flBobVert = bShouldIgnoreOffsetAndAccuracy and 0.3 or cl_bobamt_vert:GetFloat()
        bobState.m_flVerticalBob = speed * ( flBobMultiplier * flBobVert )
        bobState.m_flVerticalBob = ( bobState.m_flVerticalBob * 0.3 + bobState.m_flVerticalBob * 0.7 * math.sin(cycle) )
        bobState.m_flRawVerticalBob = bobState.m_flVerticalBob

        bobState.m_flVerticalBob = math.Clamp( bobState.m_flVerticalBob - ( flRunAddAmt - (flGunAccPos * 0.2) ), -7.0, 4.0 )

        cycle = bobState.m_flBobTime - math.floor(bobState.m_flBobTime / flBobCycle * 2) * flBobCycle * 2
        cycle = cycle / (flBobCycle * 2)

        if ( cycle < cl_bobup:GetFloat() ) then
            cycle = math.pi * cycle / cl_bobup:GetFloat()
        else
            cycle = math.pi + math.pi * (cycle - cl_bobup:GetFloat()) / (1.0 - cl_bobup:GetFloat())
        end

        local flBobLat = bShouldIgnoreOffsetAndAccuracy and 0.5 or cl_bobamt_lat:GetFloat()
        if ( ply:IsValid() and wep:IsValid() ) then
            bobState.m_flLateralBob = speed * ( flBobMultiplier * flBobLat )
            bobState.m_flLateralBob = bobState.m_flLateralBob * 0.3 + bobState.m_flLateralBob * 0.7 * math.sin(cycle)
            bobState.m_flRawLateralBob = bobState.m_flLateralBob

            bobState.m_flLateralBob = math.Clamp( bobState.m_flLateralBob + flGunAccPos * 0.25, -8.0, 8.0 )
        end
    end

    local function AddViewModelBobHelper(pos, ang, bobState)
        local vForward, vRight, vUp = ang:Forward(), ang:Right(), ang:Up()

        -- Apply bob, but scaled down to 40%
        VectorMA(pos, bobState.m_flVerticalBob * .4, vForward, pos)

        -- Z bob a bit more
        VectorMA(pos, bobState.m_flVerticalBob * .1, vUp, pos)

        -- bob the angles
        ang.r = ang.r + bobState.m_flVerticalBob * .5
        ang.p = ang.p - bobState.m_flVerticalBob * .4
        ang.y = ang.y - bobState.m_flLateralBob * .3

        VectorMA(pos, bobState.m_flLateralBob * 0.2, vRight, pos)
    end

    local bobtime = 0
    local lastbobtime = 0
    local lastspeed = 0
    local function CalcViewModelBob(self)
        if cl_use_new_headbob:GetBool() then
            local owner = self:GetPlayerOwner()

            return CalcViewModelBobHelper(owner, self)
        end

        local cycle

        local owner = self:GetPlayerOwner()

        if not owner or
            cl_bobcycle:GetFloat() <= 0.0 or
            cl_bobup:GetFloat() <= 0.0 or
            cl_bobup:GetFloat() >= 1.0
        then
            return
        end

        -- Find the speed of the player
        local speed = owner:GetVelocity():Length2D()
        local flmaxSpeedDelta = math.max( 0, ( CurTime() - lastbobtime ) * 320.0 )

        -- don't allow too big speed changes
        speed = math.Clamp( speed, lastspeed-flmaxSpeedDelta, lastspeed + flmaxSpeedDelta )
        speed = math.Clamp( speed, -320, 320 )

        lastspeed = speed

        -- FIXME: This maximum speed value must come from the server.
        --		 MaxSpeed() is not sufficient for dealing with sprinting - jdw

        local bob_offset = util.RemapVal( speed, 0, 320, 0.0, 1.0 );

        bobtime = bobtime + ( ( CurTime() - lastbobtime ) * bob_offset )
        lastbobtime = CurTime()

        -- Calculate the vertical bob
        cycle = bobtime - math.floor( bobtime / cl_bobcycle:GetFloat() ) * cl_bobcycle:GetFloat()
        cycle = cycle / cl_bobcycle:GetFloat()

        if ( cycle < cl_bobup:GetFloat() ) then
            cycle = math.pi * cycle / cl_bobup:GetFloat()
        else
            cycle = math.pi + math.pi * ( cycle-cl_bobup:GetFloat() ) / ( 1.0 - cl_bobup:GetFloat() )
        end

        g_verticalBob = speed * 0.005
        g_verticalBob = g_verticalBob * 0.3 + g_verticalBob * 0.7 * math.sin( cycle )

        g_verticalBob = math.Clamp( g_verticalBob, -7.0, 4.0 )

        -- Calculate the lateral bob
        cycle = bobtime - math.floor( bobtime / cl_bobcycle:GetFloat() * 2 ) * cl_bobcycle:GetFloat() * 2
        cycle = cycle / (cl_bobcycle:GetFloat() * 2)

        if ( cycle < cl_bobup:GetFloat() ) then
            cycle = math.pi * cycle / cl_bobup:GetFloat()
        else
            cycle = math.pi + math.pi * ( cycle-cl_bobup:GetFloat() ) / ( 1.0 - cl_bobup:GetFloat() )
        end

        g_lateralBob = speed * 0.005
        g_lateralBob = g_lateralBob * 0.3 + g_lateralBob * 0.7 * math.sin( cycle )
        g_lateralBob = math.Clamp( g_lateralBob, -7.0, 4.0 )
    end

    function SWEP:AddViewModelBob(vm, pos, ang)
        if cl_use_new_headbob:GetBool() then
            self.m_bobState = self.m_bobState or {
                m_flBobTime = 0,
                m_flLastBobTime = 0,
                m_flLastSpeed = 0,
                m_flVerticalBob = 0,
                m_flLateralBob = 0,
                m_flRawVerticalBob = 0,
                m_flRawLateralBob = 0,
            }

            local owner = self:GetPlayerOwner()
            if not owner then return end

            CalcViewModelBob(self)
            AddViewModelBobHelper(pos, ang, self.m_bobState)

            return
        end

        local forward, right = ang:Forward(), ang:Right()

        CalcViewModelBob(self)

        -- Apply bob, but scaled down to 40%
        VectorMA( pos, g_verticalBob * 0.4, forward, pos );

        -- Z bob a bit more
        pos[2] = pos[2] + g_verticalBob * 0.1

        -- bob the angles
        ang.r = ang.r + g_verticalBob * 0.5
        ang.p = ang.p - g_verticalBob * 0.4
        ang.y = ang.y - g_lateralBob  * 0.3
    end
end

local AE_CL_BODYGROUP_SET_VALUE = 39
local AE_CL_BODYGROUP_SET_TO_CLIP = 41
local AE_CL_BODYGROUP_SET_TO_NEXTCLIP = 42
local AE_CL_HIDE_SILENCER = 43
local AE_CL_ATTACH_SILENCER_COMPLETE = 44
local AE_CL_SHOW_SILENCER = 45
local AE_CL_DETACH_SILENCER_COMPLETE = 46
local AE_WPN_PRIMARYATTACK = 49
local AE_WPN_COMPLETE_RELOAD = 54
local AE_BEGIN_TAUNT_LOOP = 72
local AE_CL_SET_STATTRAK_GLOW = 73
local AE_WPN_CZ_DUMP_CURRENT_MAG = 74
local AE_WPN_CZ_UPDATE_BODYGROUP = 75
local AE_MUZZLEFLASH = 5001

local SILENCER_VISIBLE = 0
local SILENCER_HIDDEN = 1

function SWEP:GetReloadActivity()
    return self.m_iReloadActivityIndex or ACT_VM_RELOAD
end

SWEP.VM_BodyGroups = {}
SWEP.WM_BodyGroups = {}
function SWEP:SetBodyGroup(bodygroup, p_value)
    local owner = self:GetPlayerOwner()
    if not owner then return end

    local vm = owner:GetViewModel(self:ViewModelIndex())
    if not vm:IsValid() then return end

    local index, value = nil, tonumber(p_value)
    if string.find(bodygroup, " ") then
        value = bodygroup:match("%s(%d+)$")
        bodygroup = bodygroup:match("%b\"\""):sub(2, -2)
    end

    if not index then
        index = vm:FindBodygroupByName(bodygroup)
    end
    value = tonumber(value)

    if not (isnumber(index) and isnumber(value)) then return end

    self.VM_BodyGroups[index] = value
    if SERVER then
        self:CallOnClient("SetBodyGroup", Format("\"%s\" %s", bodygroup, value))
    end
end
function SWEP:SetWMBodyGroup(bodygroup, p_value)
    local owner = self:GetPlayerOwner()
    if not owner then return end

    local index, value = nil, tonumber(p_value)
    if string.find(bodygroup, " ") then
        value = bodygroup:match("%s(%d+)$")
        bodygroup = bodygroup:match("%b\"\""):sub(2, -2)
    end

    if CLIENT and not index and self.cl_wm then
        index = self.cl_wm:FindBodygroupByName(bodygroup)
    end
    value = tonumber(value)

    if SERVER then
        self:CallOnClient("SetWMBodyGroup", Format("\"%s\" %s", bodygroup, p_value))
        return
    end

    if not (isnumber(index) and isnumber(value)) then return end

    self.WM_BodyGroups[index] = value
end

function SWEP:PreDrawViewModel(vm, _, owner)
    for id, val in next, self.VM_BodyGroups do
        vm:SetBodygroup(id, val)
    end

    self:ApplyWeaponSkin(vm, owner)

    return not self:ShouldDrawViewModel()
end
function SWEP:PostDrawViewModel(vm, _, owner)
    self:RemoveWeaponSkin(vm, owner)
end

local SWITCH_ANIMEVENT = {
    [AE_BEGIN_TAUNT_LOOP] = function(self, _, _, options)
        local owner = self:GetPlayerOwner()
        if not owner then return end

        local vm = owner:GetViewModel(self:ViewModelIndex())
        if not vm:IsValid() then return end

        options = tonumber(options)

        -- when gmod lets me :SetCycle() on VMs, i will finish this
        -- homonovus, 08/12/2020

        -- pViewModel->ForceCycle( 0 );
        -- pViewModel->ResetSequence( nSequence );

        --vm:SetCycle(options)
        --vm:ResetSequence(vm:GetSequence())
        --vm:SetCycle(options)
        --print(self, "cycle", vm, options, vm:GetCycle())
    end,
    [AE_CL_BODYGROUP_SET_VALUE] = function(self, _, _, options)
        options = options:Split" "
        local bodygroup = options[1]
        local value = tonumber(options[2])

        if not IsValid(self) then return end
        local owner = self:GetPlayerOwner()
        if not owner then return end

        self:SetBodyGroup(bodygroup, value)
    end,
    [AE_WPN_PRIMARYATTACK] = function(self, _, _, options)
        local time = tonumber(options)
        if time then
            self:SetPostponeFireReadyTime(CurTime() + time)

            -- send everyone else the "click" back noise
            -- except in eye observers
            self:EmitSound("Weapon_Revolver_CSGO.Prepare")
        end
    end,
    [AE_WPN_CZ_DUMP_CURRENT_MAG] = function(self)
        -- csgo used to empty the mag when you reloaded the cz??!?!
        -- self:SetClip1(0)
        self:SetBodyGroup("front_mag", 1)
        self:SetWMBodyGroup("front_mag", 1)

        local vm = self:GetOwner():GetViewModel(self:ViewModelIndex())
        -- if the front mag is removed, all subsequent anims use the non-front mag reload
        self.m_iReloadActivityIndex = vm:GetSequenceActivity(vm:LookupSequence("reload2"))

        -- lua: cz is the only thing that uses this, so i'm just gonna...
        -- as opposed to checking inside :Deploy() whether it has ammo or not
        self.m_bAlreadyReloaded = true
    end,
    [AE_CL_BODYGROUP_SET_TO_CLIP] = function(self)
        local owner = self:GetPlayerOwner()
        if not owner then return end

        local vm = owner:GetViewModel(self:ViewModelIndex())
        if not vm:IsValid() then return end

        for i = 0, vm:GetNumBodyGroups() - 1 do
            self:SetBodyGroup(vm:GetBodygroupName(i), (self:Clip1() < i) and 1 or 0)
        end
    end,
    [AE_CL_BODYGROUP_SET_TO_NEXTCLIP] = function(self)
        local owner = self:GetPlayerOwner()
        local vm = owner:GetViewModel(self:ViewModelIndex())

        local iNextClip = math.min( self:GetMaxClip1(), self:Clip1() + self:GetAmmoCount(self:GetPrimaryAmmoType()))
        for i = 0, vm:GetNumBodyGroups() - 1 do
            self:SetBodyGroup(vm:GetBodygroupName(i), (iNextClip >= i) and 0 or 1)
        end
    end,
    [AE_CL_HIDE_SILENCER] = function(self)
        self:SetBodyGroup("silencer", SILENCER_HIDDEN)
    end,
    [AE_CL_SHOW_SILENCER] = function(self)
        self:SetBodyGroup("silencer", SILENCER_VISIBLE)
    end,
    [AE_WPN_COMPLETE_RELOAD] = function(self)
        local owner = self:GetPlayerOwner()
        if not owner then return end

        self.m_bReloadVisuallyComplete = true
        local j = math.min(self:GetClipSize() - self:Clip1(), self:GetAmmoCount(self:GetPrimaryAmmoType()))

        self:SetClip1(self:Clip1() + j)

        if SWCS_INDIVIDUAL_AMMO:GetBool() then
            self:SetReserveAmmo(self:GetReserveAmmo() - j)
        else
            owner:RemoveAmmo(j, self:GetPrimaryAmmoType())
        end

        self:SetRecoilIndex(0)
    end,
    [AE_CL_DETACH_SILENCER_COMPLETE] = function(self)
        self:SetWeaponMode(Primary_Mode)
        self:SetSilencerOn(false)
        self:SetWMBodyGroup("silencer", SILENCER_HIDDEN)
    end,
    [AE_CL_ATTACH_SILENCER_COMPLETE] = function(self)
        self:SetWeaponMode(Secondary_Mode)
        self:SetSilencerOn(true)
        self:SetWMBodyGroup("silencer", SILENCER_VISIBLE)
    end,
    [AE_MUZZLEFLASH] = function(self, _, _, options)
        if self:GetSilencerOn() then
            return true
        end

        local data = EffectData()
        data:SetFlags( 0 )
        data:SetEntity( self:GetPlayerOwner():GetViewModel(self:ViewModelIndex()) )
        data:SetAttachment( tonumber(options) )
        data:SetScale( 1 )

        --print(self.ItemVisuals["muzzle_flash_effect_1st_person"])

        util.Effect( "CS_MuzzleFlash", data )
        return true
    end
}

function SWEP:FireAnimationEvent(pos, ang, event, options, src_ent)
    if SWCS_DEBUG_AE:GetBool() then
        print("csgo AE", self, event, options, src_ent)
    end

    if SWITCH_ANIMEVENT[event] then
        local fn = SWITCH_ANIMEVENT[event]
        local ret = fn(self,pos,ang,options,src_ent)

        if ret ~= nil then
            return ret
        end
    end
end

function SWEP:TakePrimaryAmmo(num)
    if not SWCS_INDIVIDUAL_AMMO:GetBool() then
        return BaseClass.TakePrimaryAmmo(self, num)
    end

    local owner = self:GetPlayerOwner()
    if not owner then return end

    if self:Clip1() <= 0 then
        if self:Ammo1() <= 0 then return end

        self:SetReserveAmmo(math.max(self:GetReserveAmmo() - num, 0))
        return
    end

    self:SetClip1(self:Clip1() - num)
end

function SWEP:CustomAmmoDisplay()
    if self:Clip1() < 0 then return end

    if SWCS_INDIVIDUAL_AMMO:GetBool() then
        return {
            Draw = true,
            PrimaryClip = self:Clip1(),
            PrimaryAmmo = self:GetReserveAmmo()
        }
    end
end

function SWEP:GetAmmoCount(type)
    if SWCS_INDIVIDUAL_AMMO:GetBool() then
        return self:GetReserveAmmo()
    end

    local owner = self:GetPlayerOwner()
    if not owner then return 0 end

    return owner:GetAmmoCount(type)
end

-- sandbox lets ppl deploy weps at 4x speed
-- sometimes servers will lower this
local cl_crosshairstyle = GetConVar"cl_crosshairstyle"
function SWEP:Deploy()
    self:SetHoldType(self.HoldType)

    if CLIENT and (cl_crosshairstyle:GetInt() == 4 or cl_crosshairstyle:GetInt() == 5) then
        self.m_flCrosshairDistance = 1
    end

    self:SetRecoilIndex(0)

    if self:GetHasZoom() then
        self:SetZoomLevel(0)
        self:SetWeaponMode(Primary_Mode)
    end

    if self:GetSilencerOn() then
        self:SetWeaponAnim(ACT_VM_DRAW_SILENCED, self:GetDeploySpeed())
    elseif self.m_bAlreadyReloaded then -- cz alt draw anim; i do it like this instead of checking if they have ammo
        local seq = self:LookupSequence("draw2")
        local act

        if seq then
            act = self:GetSequenceActivity(seq)
            self:SetWeaponAnim(act, self:GetDeploySpeed())
        end

        self:SetBodyGroup("front_mag", 1)
    end

    local owner = self:GetPlayerOwner()
    if owner then
        local vm = owner:GetViewModel(self:ViewModelIndex())
        if vm:IsValid() then
            vm:SetPlaybackRate(self:GetDeploySpeed())
            self:SetWeaponIdleTime(CurTime() + (self:SequenceDuration() * (1 / self:GetDeploySpeed())))

            local oPrim = self:GetNextPrimaryFire()
            local oSec = self:GetNextSecondaryFire()
            self:SetNextPrimaryFire(oPrim < self:GetWeaponIdleTime() and self:GetWeaponIdleTime() or oPrim)
            self:SetNextSecondaryFire(oSec < self:GetWeaponIdleTime() and self:GetWeaponIdleTime() or oSec)
        end
    end

    self:SetIronSightMode(IronSight_viewmodel_is_deploying)
    if self.m_IronSightController then
        self.m_IronSightController:SetState(IronSight_viewmodel_is_deploying)
    end

    if self:GetIsRevolver() then
        self:SetWeaponMode(Secondary_Mode)
    end

    return true
end

function SWEP:DoFireEffects()
    if self:GetSilencerOn() then
        return
    end

    local owner = self:GetPlayerOwner()
    if owner then
        owner:MuzzleFlash()
    end
end

function SWEP:CalculateNextAttackTime(fCycleTime)
    local fCurAttack = self:GetNextPrimaryFire()
    local fDeltaAttack = CurTime() - fCurAttack
    if fDeltaAttack < 0 or fDeltaAttack > engine.TickInterval() then
        fCurAttack = CurTime()
    end
    self:SetNextPrimaryFire(fCurAttack + fCycleTime)
    self:SetNextSecondaryFire(fCurAttack + fCycleTime)

    return fCurAttack
end

function SWEP:IsPistol()
    return self:GetWeaponType() == "pistol"
end

function SWEP:PlayEmptySound()
    if self:IsPistol() then
        self:EmitSound("Default.ClipEmpty_Pistol")
    else
        self:EmitSound("Default.ClipEmpty_Rifle")
    end
end

function SWEP:GetTracerFrequency(weaponMode)
    if weaponMode == Primary_Mode then
        return self:GetTracerFreq1()
    else
        return self:GetTracerFreq2()
    end
end

function SWEP:PrimaryAttackAct()
    return ACT_VM_PRIMARYATTACK
end

function SWEP:GetFinalAimAngle()
    local owner = self:GetPlayerOwner()
    if not owner then return Angle(0,0,0) end

    local angShooting = owner:GetAimVector():Angle() + self:GetAimPunchAngle()
    angShooting:Normalize()

    return angShooting
end

local MaxPitchShiftInaccuracy = 0.05
local weapon_near_empty_sound = GetConVar"weapon_near_empty_sound"
local weapon_accuracy_shotgun_spread_patterns = GetConVar"weapon_accuracy_shotgun_spread_patterns"
function SWEP:FX_FireBullets()
    local owner = self:GetPlayerOwner()
    if not owner then return end

    local iSeed = self:GetRandomSeed()
    iSeed = iSeed + 1
    self:SetRandomSeed(iSeed)

    local fInaccuracy = self:GetInaccuracy()
    local soundToPlay = self:GetHasSilencer() and self:GetSilencerOn() and self.SND_SPECIAL1 or self.SND_SINGLE

    local flPitchShift = self:GetInaccuracyPitchShift() * (fInaccuracy < MaxPitchShiftInaccuracy and fInaccuracy or MaxPitchShiftInaccuracy)
    if soundToPlay == self.SND_SINGLE and self:GetInaccuracyAltSoundThreshold() > 0 and fInaccuracy < self:GetInaccuracyAltSoundThreshold() then
        soundToPlay = self.SND_SINGLE_ACCURATE
        flPitchShift = 0
    end
    self:EmitSound(soundToPlay, nil, 100 + math.floor(flPitchShift))

    -- If the gun's nearly empty, also play a subtle "nearly-empty" sound, since the weapon 
    -- is lighter and acoustically different when weighed down by fewer bullets.
    -- But really it's so you get a fun low ammo warning from an audio cue.
    if weapon_near_empty_sound:GetBool() and
        self:GetMaxClip1() > 1 and -- not a single-shot weapon
        (self:Clip1() / self:GetMaxClip1()) <= 0.2 -- 20% or fewer bullets remaining
    then
        self:EmitSound(self.SND_NEARLY_EMPTY or "Default.nearlyempty")
    end

    local bForceMaxInaccuracy = false
    local bForceInaccuracyDirection = false

    local rand = UniformRandomStream(iSeed) -- init random system with this seed

    -- Accuracy curve density adjustment FOR R8 REVOLVER SECONDARY FIRE, NEGEV WILD BEAST
    local flRadiusCurveDensity = rand:RandomFloat()
    if self.IsR8Revolver and self:GetWeaponMode() == Secondary_Mode then -- R8 REVOLVER SECONDARY FIRE
        flRadiusCurveDensity = 1 - (flRadiusCurveDensity * flRadiusCurveDensity)
    elseif self.IsNegev and self:GetRecoilIndex() < 3 then -- NEGEV WILD BEAST
        for j = 3, self:GetRecoilIndex(), -1 do
            flRadiusCurveDensity = flRadiusCurveDensity * flRadiusCurveDensity
        end

        flRadiusCurveDensity = 1 - flRadiusCurveDensity
    end

    if bForceMaxInaccuracy then
        flRadiusCurveDensity = 1
    end

    -- Get accuracy displacement
    local fTheta0 = rand:RandomFloat(0, 2 * math.pi)
    if bForceInaccuracyDirection then
        fTheta0 = math.pi * 0.5
    end

    local fRadius0 = flRadiusCurveDensity * fInaccuracy
    local x0 = fRadius0 * math.cos(fTheta0)
    local y0 = fRadius0 * math.sin(fTheta0)

    local x1, y1 = {}, {}
    assert(self:GetBullets() <= 16, "too many bullets in weapon")

    local x2, y2 = {}, {}
    -- shotguns have a spread seed, which is used to calculate a pattern
    --[[local spreadRandom = UniformRandomStream(self:GetSpreadSeed())
    if self:GetBullets() > 1 and weapon_accuracy_shotgun_spread_patterns:GetBool() then
        for iBullet = 1, self:GetBullets() do
            local fTheta2 = spreadRandom:RandomFloat(0, 2 * math.pi)
            local flSpreadCurveDensity = spreadRandom:RandomFloat()

            local fRadius2 = flSpreadCurveDensity * self:GetSpread()
            x2[iBullet] = fRadius2 * math.cos(fTheta2)
            y2[iBullet] = fRadius2 * math.sin(fTheta2)
        end
    end]]

    -- calculate random spread for every bullet
    for iBullet = 1, self:GetBullets() do
        local flSpreadCurveDensity = rand:RandomFloat()
        if self:GetIsRevolver() and self:GetWeaponMode() == Secondary_Mode then
            flSpreadCurveDensity = 1 - (flSpreadCurveDensity * flSpreadCurveDensity)
        elseif self.IsNegev and self:GetRecoilIndex() < 3 then
            for j = 3, self:GetRecoilIndex(), -1 do
                flSpreadCurveDensity = flSpreadCurveDensity * flSpreadCurveDensity
            end

            flSpreadCurveDensity = 1 - flSpreadCurveDensity
        end

        if bForceMaxInaccuracy then
            flSpreadCurveDensity = 1
        end

        local fTheta1 = rand:RandomFloat(0, 2 * math.pi)
        if bForceInaccuracyDirection then
            fTheta1 = math.pi * .5
        end

        local fRadius1 = flSpreadCurveDensity * self:GetSpread()
        x1[iBullet] = fRadius1 * math.cos(fTheta1)
        y1[iBullet] = fRadius1 * math.sin(fTheta1)
    end

    local angShooting = self:GetFinalAimAngle()

    local vecDirShooting, vecRight, vecUp = angShooting:Forward(), angShooting:Right(), angShooting:Up()

    -- fire bullets individually to avoid getting shotguns clipped to bbox
    for iBullet = 1, self:GetBullets() do
        local xSpread, ySpread = x0 + x1[iBullet] + (x2[iBullet] or 0), y0 + y1[iBullet] + (y2[iBullet] or 0)

        local vecDir = vecDirShooting + (xSpread * vecRight) + (ySpread * vecUp)
        vecDir:Normalize()

        owner:FireBullets({
            Src = owner:GetShootPos(),
            Dir = vecDir,
            Num = 1,
            AmmoType = self.Primary.Ammo,
            Tracer = self:GetTracerFrequency(self:GetWeaponMode()),
            TracerName = self.Tracer,
            Attacker = owner,
            Distance = self:GetRange(),
            Spread = vector_origin,
            Damage = self:GetDamage(),
            Callback = function(atk, tr, dmg)
                if SERVER or (CLIENT and IsFirstTimePredicted()) then
                    self:BulletCallback(atk, tr, dmg, vecDir)
                end
            end
        })
    end
end

-- head = 4x; chest & arms = 1x; stomach = 1.25x; legs = .75x
local HITGROUP_DAMAGE_SCALE = {
    [HITGROUP_HEAD] = 4,
    [HITGROUP_STOMACH] = 1.25,
    [HITGROUP_CHEST] = 1,
    [HITGROUP_LEFTARM] = 1,
    [HITGROUP_RIGHTARM] = 1,
    [HITGROUP_LEFTLEG] = .75,
    [HITGROUP_RIGHTLEG] = .75
}
function SWEP:ApplyDamageScale(dmgInfo, tr, flBaseDamage)

    -- rescale damage bc gmod has its own scalar
    -- we are trying to recreate csgo weps and how ppl expect them to be :)
    if HITGROUP_DAMAGE_SCALE[tr.HitGroup] then
        dmgInfo:SetDamage(flBaseDamage)
        dmgInfo:ScaleDamage(HITGROUP_DAMAGE_SCALE[tr.HitGroup])
    end
end

local ironsight_rand = UniformRandomStream()

function SWEP:CSBaseGunFire(flCycleTime, weaponMode)
    local owner = self:GetPlayerOwner()
    if not owner then
        return false end

    if self:Clip1() <= 0 then
        self:PlayEmptySound()
        self:SetNextPrimaryFire(CurTime() + .2)

        if self:GetIsRevolver() then
            self:SetNextPrimaryFire(CurTime() + self:GetCycleTime(weaponMode))
            self:SetNextSecondaryFire(CurTime() + self:GetCycleTime(weaponMode))
            self:SetWeaponAnim(ACT_VM_DRYFIRE)
        end

        return false
    end

    if (self:GetWeaponType() ~= "sniperrifle" and self:IsZoomed()) or (self:GetIsRevolver() and weaponMode == Secondary_Mode) then
        self:SetWeaponAnim(ACT_VM_SECONDARYATTACK)
    elseif self:GetIsRevolver() then
        self:SetWeaponAnim(self:PrimaryAttackAct())
    else
        self:SetWeaponAnim(self:PrimaryAttackAct())
    end

    owner:SetAnimation(PLAYER_ATTACK1)

    self:FX_FireBullets()
    self:DoFireEffects()

    local iron = self.m_IronSightController
    if iron then
        iron:IncreaseDotBlur(ironsight_rand:RandomFloat(.22, .28))
    end

    self:SetWeaponIdleTime(CurTime() + self:GetTimeToIdleAfterFire())

    self:SetAccuracyPenalty(self:GetAccuracyPenalty() + self:GetInaccuracyFire())

    self:Recoil(self:GetWeaponMode())

    self:SetShotsFired(self:GetShotsFired() + 1)
    self:SetRecoilIndex(self:GetRecoilIndex() + 1)
    self:TakePrimaryAmmo(1)

    self:OnPrimaryAttack()

    self:SetNextPrimaryFire(self:CalculateNextAttackTime(flCycleTime))
    self:SetNextSecondaryFire(self:CalculateNextAttackTime(flCycleTime))
    self:SetLastShootTime()

    return true
end

function SWEP:ResetPostponeFireReadyTime()
    self:SetPostponeFireReadyTime(math.huge)
end

function SWEP:PrimaryAttack()
    local owner = self:GetPlayerOwner()
    if not owner then return end

    if self:GetIsRevolver() then -- holding primary, will fire when time is elapsed
        -- don't allow a rapid fire shot instantly in the middle of a haul back hold, let the hammer return first
        self:SetNextSecondaryFire(CurTime() + .25)
        if self:GetActivity() ~= ACT_VM_HAULBACK then
            self:SetWeaponAnim(ACT_VM_HAULBACK)
            self:ResetPostponeFireReadyTime()
            return
        end

        self:SetWeaponMode(Primary_Mode)

        if self:GetPostponeFireReadyTime() > CurTime() then return end

        --if ( m_bFireOnEmpty )
        --{
        --  ResetPostponeFireReadyTime();
        --  m_flNextPrimaryAttack = m_flNextSecondaryAttack = gpGlobals->curtime + 0.5f;
        --}

        -- we're going to fire after this point
    end

    -- cant shoot underwater thing

    local flCycleTime = self:GetCycleTime()

    -- change a few things if we're in burst mode
    if self:GetBurstMode() then
        flCycleTime = self:GetCycleTimeInBurstMode()
        self:SetBurstShotsRemaining(2)
        self:SetNextBurstShot(CurTime() + self:GetTimeBetweenBurstShots())
    end

    if not self:CSBaseGunFire(flCycleTime, self:GetWeaponMode()) then
        return
    end

    if self:GetSilencerOn() then
        self:SetWeaponAnim(ACT_VM_SECONDARYATTACK)
    end

    if self:IsZoomed() and self:GetDoesUnzoomAfterShoot() then
        owner.swcs_m_bIsScoped = false
        self:SetResumeZoom(true)
        owner:SetFOV(0, 0.05)
        self:SetWeaponMode(Primary_Mode)
    end
end

function SWEP:IsZoomed()
    return self:GetZoomLevel() > 0
end

function SWEP:GetZoomFOV(iZoomLevel)
    if iZoomLevel == 0 then return 0 -- not used, always return default FOV
    elseif iZoomLevel == 1 then return self:GetZoomFOV1()
    elseif iZoomLevel == 2 then return self:GetZoomFOV2()
    else return 0 end
end
function SWEP:GetZoomTime(iZoomLevel)
    if iZoomLevel == 0 then return self:GetZoomTime0()
    elseif iZoomLevel == 1 then return self:GetZoomTime1()
    elseif iZoomLevel == 2 then return self:GetZoomTime2()
    else return 0 end
end

function SWEP:SecondaryAttack()
    if self:GetNextPrimaryFire() >= CurTime() then return end
    local owner = self:GetPlayerOwner()
    if not owner then return end

    if self:GetHasZoom() then
        self:SetZoomLevel(self:GetZoomLevel() + 1)
        if self:GetZoomLevel() > self:GetZoomLevels() then
            self:SetZoomLevel(0)
        end

        if self:IsZoomed() then
            self:EmitSound(self:GetZoomInSound())

            owner.swcs_m_bIsScoped = true
            self:SetWeaponMode(Secondary_Mode)
            owner:SetFOV(self:GetZoomFOV(self:GetZoomLevel()), self:GetZoomTime(self:GetZoomLevel()))
            self:SetAccuracyPenalty(self:GetAccuracyPenalty() + self:GetInaccuracyAltSwitch())

            if self.m_IronSightController and self.m_IronSightController.m_pAttachedWeapon:IsValid() then
                self:UpdateIronSightController()
                owner:SetFOV(self.m_IronSightController.m_flIronSightFOV, self.m_IronSightController:GetIronSightPullUpDuration())
                self.m_IronSightController:SetState(IronSight_should_approach_sighted)

                self:StopLookingAtWeapon()

                -- force idle
                self:SetWeaponAnim(ACT_VM_IDLE)
            end
        else
            self:EmitSound(self:GetZoomOutSound())

            owner.swcs_m_bIsScoped = false
            self:SetWeaponMode(Primary_Mode)
            owner:SetFOV(0, self:GetZoomTime(0))
            self:SetWeaponAnim(ACT_VM_FIDGET)

            if self.m_IronSightController then
                self.m_IronSightController:SetState(IronSight_should_approach_unsighted)
            end
        end
    elseif self:GetHasSilencer() and self:GetDoneSwitchingSilencer() <= CurTime() then
        if self:GetSilencerOn() then
            self:SetWeaponAnim(ACT_VM_DETACH_SILENCER)
        else
            self:SetWeaponAnim(ACT_VM_ATTACH_SILENCER)
        end

        local nextAttackTime = CurTime() + self:SequenceDuration()
        self:SetDoneSwitchingSilencer(nextAttackTime)
        self:SetNextPrimaryFire(nextAttackTime)
        self:SetNextSecondaryFire(nextAttackTime)
    elseif self:GetHasBurstMode() then
        if self:GetBurstMode() then
            owner:PrintMessage(HUD_PRINTCENTER, "auto")
            self:SetBurstMode(false)
            self:SetWeaponMode(Primary_Mode)
        else
            owner:PrintMessage(HUD_PRINTCENTER, "burst")
            self:SetBurstMode(true)
            self:SetWeaponMode(Secondary_Mode)
        end

        self:EmitSound("Weapon.AutoSemiAutoSwitch")
    elseif self:GetIsRevolver() and self:GetNextSecondaryFire() < CurTime() then
        local flCycletimeAlt = self:GetCycleTime( Secondary_Mode );
        self:SetWeaponMode(Secondary_Mode)
        self:UpdateAccuracyPenalty()

        self:CSBaseGunFire( flCycletimeAlt, Secondary_Mode )
        self:SetNextSecondaryFire(CurTime() + flCycletimeAlt)
        return
    end
end

function SWEP:OnStartReload()
    local owner = self:GetPlayerOwner()

    if self:GetZoomLevel() > 0 and owner.swcs_m_bIsScoped then
        owner:SetFOV(0, 0)
        owner.swcs_m_bIsScoped = false
    end

    if self:GetHasZoom() then
        self:SetZoomLevel(0)
        self:SetResumeZoom(false)
        self:SetWeaponMode(Primary_Mode)
    end

    self.m_bReloadVisuallyComplete = false
    self:SetIronSightMode(IronSight_should_approach_unsighted)

    self:SetShotsFired(0)
    self:SetRecoilIndex(self:GetRecoilIndex() + 1)
end

function SWEP:Holster()
    local owner = self:GetPlayerOwner()

    -- silencer stuff here
    if (self:GetActivity() == ACT_VM_ATTACH_SILENCER and not self:GetSilencerOn()) or
        (self:GetActivity() == ACT_VM_DETACH_SILENCER and self:GetSilencerOn())
    then
        self:SetDoneSwitchingSilencer(CurTime())
        self:SetNextPrimaryFire(CurTime())
        self:SetNextSecondaryFire(CurTime())
    end

    if self:GetHasZoom() then
        self:SetZoomLevel(0)
        self:SetWeaponMode(Primary_Mode)
        if owner then
            owner:SetFOV(self:GetZoomFOV(0))
        end
    end

    -- animation cancel for unfinished reload
    if self:GetInReload() and not self.m_bReloadVisuallyComplete then
        self:SetNextPrimaryFire(CurTime())
        self:SetNextSecondaryFire(CurTime())
    end

    -- lua: reset bodygroups bc gmod doesnt
    -- :Holster() is only called when owner is valid
    if owner then
        local vm = owner:GetViewModel()
        if vm:IsValid() then
            for i = 0, vm:GetNumBodyGroups() - 1 do
                vm:SetBodygroup(i, 0)
            end

            self:RemoveWeaponSkin(vm, owner)
        end
    end

    if self.m_IronSightController then
        self.m_IronSightController:SetState(IronSight_viewmodel_is_deploying)
    end

    return BaseClass.Holster(self)
end

local function ApplyIronSightScopeEffect(wep, vm, x, y, w, h, bPreparationStage)
    local ply = wep:GetPlayerOwner()
    if not ply then return end

    local iron = wep.m_IronSightController
    if not iron then return end

    if bPreparationStage then
        return iron:PrepareScopeEffect(vm, x, y, w, h)
    else
        iron:RenderScopeEffect(vm, x, y, w, h)
    end
end

function SWEP:ViewModelDrawn(vm)
    if not vm.swcs_cb_idx then
        vm.swcs_cb_idx = vm:AddCallback("BuildBonePositions", function()
            if not self:IsValid() then
                vm:RemoveCallback("BuildBonePositions", vm.swcs_cb_idx)
                vm.swcs_cb_idx = nil
                return
            end

            self:PostBuildTransformations(vm)
        end)
    end

    ApplyIronSightScopeEffect(self, vm, 0, 0, ScrW(), ScrH(), true)
    -- draw vms again, put into stencil buffer?
    ApplyIronSightScopeEffect(self, vm, 0, 0, ScrW(), ScrH(), false) -- which will render the dot and blur into the screen
end

function SWEP:ShouldDrawViewModel()
    local owner = self:GetPlayerOwner()
    if owner and owner:GetFOV() ~= owner:GetDefaultFOV() and self:IsZoomed() and (self:GetDoesHideViewModelWhenZoomed() and not self:GetResumeZoom()) then
        return false
    end

    return true
end

