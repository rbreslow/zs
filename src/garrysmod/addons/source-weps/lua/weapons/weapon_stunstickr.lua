SWEP.PrintName = "#HL2_Stunbaton"
SWEP.Base = "weapon_hl2basebludgeon"
SWEP.Category = "Half-Life 2 Remake"

DEFINE_BASECLASS("weapon_hl2basebludgeon")

SWEP.Spawnable = true

SWEP.CharLogo = "n"
SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl"

SWEP.Range = 75
SWEP.MELEE_HITWORLD = "Weapon_Stunstick.Melee_HitWorld"
SWEP.MELEE_HIT = "Weapon_Stunstick.Melee_Hit"
SWEP.SINGLE = "Weapon_Stunstick.Melee_Miss"

SWEP.SwungLastFrame = false
SWEP.FadeTime = 0

SWEP.Primary.Damage = 40
SWEP.Primary.Delay = .8

SWEP.IconOverride = "entities/weapon_stunstick.png"

function SWEP:SetupDataTables()
    BaseClass.SetupDataTables(self)
    self:NetworkVar("Bool", 1, "StunState")
end

function SWEP:Deploy()
    self:SetStunState(true)
    return BaseClass.Deploy(self)
end

--[=[function SWEP:SetStunState(state)
    self.Active = true

    if self.Active then
        local _ = self:GetAttachment(1)
        local Attachment = _.Pos
        local AttachmentAngles = _.Ang

        --[[local data = EffectData()
        data:SetOrigin(Attachment)]]

        self:EmitSound("Weapon_Stunstick.Activate")
    else
        self:EmitSound("Weapon_Stunstick.Deactivate")
    end
end

function SWEP:GetStunState()
    return self.Active
end]=]

function SWEP:OnHit(traceHit, hitActivity, bIsSecondary)
    local data = EffectData()
    data:SetOrigin(traceHit.HitPos)
    data:SetNormal(traceHit.HitNormal)

    if SERVER then
        SuppressHostEvents(self:GetOwner())
    end
    util.Effect("StunstickImpact", data, not game.SinglePlayer())
end

function SWEP:OnDrop()
    self:SetStunState(false)
end

function SWEP:InSwing()
    local activity = self:GetActivity();

    -- These are the swing activities this weapon can play
    if activity == ACT_VM_MISSCENTER or activity == ACT_VM_HITCENTER then
        return true
    end

    return false
end

function SWEP:Think()
    if CLIENT then
        if not self:InSwing() then
            if self.SwungLastFrame then
                -- Start fading
                self.FadeTime = CurTime()
                self.SwungLastFrame = false
            end

            return
        end

        -- Remember if we swung last frame
        self.SwungLastFrame = self:InSwing()

        -- Update our effects
        if FrameTime() ~= 0 and util.SharedRandom("", 0, 3) == 0 then
            local origin
            local angles

            local beamInfo

            local attachemnt = math.random(0, 15)

            --[[
                Vector	vecOrigin;
                QAngle	vecAngles;

                // Inner beams
                BeamInfo_t beamInfo;

                int attachment = random->RandomInt( 0, 15 );

                UTIL_GetWeaponAttachment( this, attachment, vecOrigin, vecAngles );
                ::FormatViewModelAttachment( vecOrigin, false );

                CBasePlayer *pOwner = ToBasePlayer( GetOwner() );
                CBaseEntity *pBeamEnt = pOwner->GetViewModel();

                beamInfo.m_vecStart = vec3_origin;
                beamInfo.m_pStartEnt= pBeamEnt;
                beamInfo.m_nStartAttachment = attachment;

                beamInfo.m_pEndEnt	= NULL;
                beamInfo.m_nEndAttachment = -1;
                beamInfo.m_vecEnd = vecOrigin + RandomVector( -8, 8 );

                beamInfo.m_pszModelName = STUNSTICK_BEAM_MATERIAL;
                beamInfo.m_flHaloScale = 0.0f;
                beamInfo.m_flLife = 0.05f;
                beamInfo.m_flWidth = random->RandomFloat( 1.0f, 2.0f );
                beamInfo.m_flEndWidth = 0;
                beamInfo.m_flFadeLength = 0.0f;
                beamInfo.m_flAmplitude = random->RandomFloat( 16, 32 );
                beamInfo.m_flBrightness = 255.0;
                beamInfo.m_flSpeed = 0.0;
                beamInfo.m_nStartFrame = 0.0;
                beamInfo.m_flFrameRate = 1.0f;
                beamInfo.m_flRed = 255.0f;;
                beamInfo.m_flGreen = 255.0f;
                beamInfo.m_flBlue = 255.0f;
                beamInfo.m_nSegments = 16;
                beamInfo.m_bRenderable = true;
                beamInfo.m_nFlags = 0;

                beams->CreateBeamEntPoint( beamInfo );
            ]]
        end
    end
end

function SWEP:PostDrawViewModel(vm, this, ply)
    --
end
