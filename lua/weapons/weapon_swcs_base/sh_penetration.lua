AddCSLuaFile()

local sv_showimpacts = GetConVar("sv_showimpacts")
local sv_showimpacts_penetration = GetConVar("sv_showimpacts_penetration")
local sv_showimpacts_time = GetConVar("sv_showimpacts_time")

local SWITCH_BulletTypeParameters = {
    ["BULLET_PLAYER_50AE"] = {
        fPenetrationPower = 30,
        flPenetrationDistance = 1000,
    },
    ["BULLET_PLAYER_762MM"] = {
        fPenetrationPower = 39,
        flPenetrationDistance = 5000,
    },
    ["BULLET_PLAYER_556MM"] = {
        fPenetrationPower = 35,
        flPenetrationDistance = 4000,
    },
    ["BULLET_PLAYER_338MAG"] = {
        fPenetrationPower = 45,
        flPenetrationDistance = 8000,
    },
    ["BULLET_PLAYER_9MM"] = {
        fPenetrationPower = 21,
        flPenetrationDistance = 800,
    },
    ["BULLET_PLAYER_BUCKSHOT"] = {
        fPenetrationPower = 0,
        flPenetrationDistance = 0,
    },
    ["BULLET_PLAYER_45ACP"] = {
        fPenetrationPower = 15,
        flPenetrationDistance = 500,
    },
    ["BULLET_PLAYER_357SIG"] = {
        fPenetrationPower = 25,
        flPenetrationDistance = 800,
    },
    ["BULLET_PLAYER_57MM"] = {
        fPenetrationPower = 30,
        flPenetrationDistance = 2000,
    },
    ["AMMO_TYPE_TASERCHARGE"] = {
        fPenetrationPower = 0,
        flPenetrationDistance = 0,
    },
}
SWITCH_BulletTypeParameters["BULLET_PLAYER_556MM_SMALL"] = SWITCH_BulletTypeParameters["BULLET_PLAYER_556MM"]
SWITCH_BulletTypeParameters["BULLET_PLAYER_556MM_BOX"] = SWITCH_BulletTypeParameters["BULLET_PLAYER_556MM"]
SWITCH_BulletTypeParameters["BULLET_PLAYER_357SIG_SMALL"] = SWITCH_BulletTypeParameters["BULLET_PLAYER_357SIG"]
SWITCH_BulletTypeParameters["BULLET_PLAYER_357SIG_P250"] = SWITCH_BulletTypeParameters["BULLET_PLAYER_357SIG"]
SWITCH_BulletTypeParameters["BULLET_PLAYER_357SIG_MIN"] = SWITCH_BulletTypeParameters["BULLET_PLAYER_357SIG"]

local DEFAULT_PENETRATE = {
    penetrationmodifier = 1.0,
    damagemodifier = 0.5,
}
local pen_types = {}
local function new(new, base, penmod, dmgmod)
    new = string.lower(new)
    if base then base = string.lower(base) end

    pen_types[new] = pen_types[base] or table.Copy(DEFAULT_PENETRATE)

    if penmod then pen_types[new].penetrationmodifier = penmod end
    if dmgmod then pen_types[new].damagemodifier = dmgmod end
end
new("default")
new("default_silent")
new("rock")
new("solidmetal", nil, 0.3, 0.27)
new("metal", "solidmetal", 0.4)
new("dirt", nil, 0.3, 0.6) new("grass", "dirt")
new("plaster", "dirt", 0.6, 0.7)
new("concrete", nil, 0.25, 0.5)
new("flesh", nil, 0.9)
new("alienflesh", "flesh")
new("plastic_barrel", nil, 0.7)
new("glass", nil, 0.99)
new("metalpanel", "metal", 0.45, 0.5)
new("Plastic_Box", nil, 0.75)
new("plastic", "Plastic_Box")
new("Wood", nil, 0.6, 0.9)
new("combine_metal", "metal")
new("wood_crate", "wood", 0.9)
new("porcelain", "rock", 0.95)
new("brick", "rock", 0.47)
new("metal_box", "solidmetal", 0.5)
new("metalvent", "metal_box", 0.6, 0.45)
new("sand", "dirt", 0.3, 0.25)
new("rubber", "dirt", 0.85, 0.5)
new("gravel", "rock", 0.4)
new("glassbottle", "glass", 0.99)
new("pottery", "glassbottle", 0.95, 0.6)
new("tile", nil, 0.7, 0.3)
new("stone", "rock")
new("wood_solid", "wood", 0.8)
new("metalvehicle", "metal", 0.5)
new("cardboard", "dirt", 0.99, 0.95)
new("popcan", "metal_box")
new("canister", "metalpanel")
new("computer", "metal_box", 0.4, 0.45)
new("wood_plank", "wood_box", 0.85)
new("ceiling_tile", "cardboard")
new("hay", "cardboard")
new("wood_furniture", "wood_box")
new("paintcan", "popcan")
new("metal_barrel", "solidmetal", 0.01, 0.01)
new("metalgrate", nil, 0.95, 0.99)
new("mud", "dirt")
new("carpet", "dirt", 0.75)
new("wood_panel", "wood_crate")
new("snow", nil, 0.85)
new("concrete_block", "concrete")
local CHAR_TEX_CARDBOARD = -1

local sv_penetration_type = CreateConVar("sv_penetration_type", "1", {FCVAR_REPLICATED, FCVAR_NOTIFY}, "What type of penertration to use. 0 = old CS, 1 = new penetration")
local MAX_PENETRATION_DISTANCE = 90 -- this is 7.5 feet

function SWEP:BulletCallback(atk, tr, dmg, vecDirBullet)
    local owner = self:GetPlayerOwner()
    if not owner then return end

    local nPenetrationCount = 4
    local iDamage = dmg:GetDamage()
    local vecDirShooting = vecDirBullet

    local fCurrentDamage = iDamage -- damage of the bullet at its current trajectory
    local flCurrentDistance = 0 -- distance that the bullet has traveled so far

    local _angShooting = vecDirShooting:Angle() _angShooting:Normalize()

    local flPenetration = self:GetPenetration()
    local flPenetrationPower = 0		-- thickness of a wall that this bullet can penetrate
    local flPenetrationDistance = 0		-- distance at which the bullet is capable of penetrating a wall
    local flDamageModifier = 0.5		-- default modification of bullets power after they go through a wall.
    local flPenetrationModifier = 1.0

    local params = SWITCH_BulletTypeParameters[self.ItemVisuals.primary_ammo]
    if sv_penetration_type:GetInt() == 1 then
        flPenetrationPower = 35
        flPenetrationDistance = 3000
    elseif params then
        flPenetrationPower = params.fPenetrationPower
        flPenetrationDistance = params.flPenetrationDistance
    end

    -- we use the max penetrations on this gun to figure out how much penetration it's capable of
    if sv_penetration_type:GetInt() == 1 then
        flPenetrationPower = self:GetPenetration()
    end

    local bFirstHit = true
    local lastPlayerHit = NULL -- includes players, bots, and npcs
    local bBulletHitPlayer = false

    local flDist_aim = 0
    local vHitLocation = Vector(0,0,0)

    local flDistance = self:GetRange()
    local vecSrc = owner:GetShootPos()

    local arrPendingDamage = {}
    local arrAlreadyHit = {[tr.Entity] = true}
    while fCurrentDamage > 0 do
        local vecEnd = vecSrc + vecDirShooting * (flDistance - flCurrentDistance)
        local tr = {} -- main enter bullet trace

        util.TraceLine({
            start = vecSrc,
            endpos = vecEnd,
            mask = bit.bor(CS_MASK_SHOOT, CONTENTS_HITBOX),
            filter = {owner, lastPlayerHit},
            collisiongroup = COLLISION_GROUP_NONE,
            output = tr
        })

        if flDist_aim == 0 then
            flDist_aim = (tr.Fraction ~= 1) and (tr.StartPos - tr.HitPos):Length() or 0
        end

        if flDist_aim ~= 0 then
             vHitLocation = tr.HitPos
        end

        lastPlayerHit = tr.Entity

        if lastPlayerHit:IsValid() then
            -- more stuff
            --[[
                if ( lastPlayerHit->GetTeamNumber() == GetTeamNumber() )
                {
                    bShotHitTeammate = true;
                }

                bBulletHitPlayer = true;
            ]]
        end

        -- we didn't hit anything, stop tracing shoot
        if tr.Fraction == 1 then break end

        --[[
            client accuracy debug here
        ]]

        -- /************* MATERIAL DETECTION ***********/
        local iEnterMaterial
        if tr.SurfaceProps == -1 then
            if SWCS_DEBUG_PENETRATION:GetBool() then
                print(Format("enter material not engine registered at (%f %f %f), using default instead",
                    tr.HitPos.x, tr.HitPos.y, tr.HitPos.z))
            end
            tr.SurfaceProps = 0
        end

        local enterData = util.GetSurfaceData(tr.SurfaceProps)

        if enterData then
            iEnterMaterial = enterData.material
        end

        local pen_mat = pen_types[string.lower(util.GetSurfacePropName(tr.SurfaceProps))]
        if not pen_mat then
            if SWCS_DEBUG_PENETRATION:GetBool() then
                print(Format("no penetration material for %s, using default instead", util.GetSurfacePropName(tr.SurfaceProps)))
            end
            pen_mat = DEFAULT_PENETRATE
        end

        flPenetrationModifier = pen_mat.penetrationmodifier
        flDamageModifier = pen_mat.damagemodifier

        local bHitGrate = bit.band(tr.Contents, CONTENTS_GRATE) ~= 0

        if CLIENT then
            if sv_showimpacts:GetInt() == 1 or sv_showimpacts:GetInt() == 2 then
                -- draw red client impact markers
                debugoverlay.Box(tr.HitPos, -Vector(2,2,2), Vector(2,2,2), sv_showimpacts_time:GetFloat(), Color(255,0,0,127))
            end
        else
            if sv_showimpacts:GetInt() == 1 or sv_showimpacts:GetInt() == 3 then
                -- draw blue server impact markers
                debugoverlay.Box(tr.HitPos, -Vector(2,2,2), Vector(2,2,2), sv_showimpacts_time:GetFloat(), Color(0,0,255,127))
            end
        end

        flCurrentDistance = flCurrentDistance + (tr.Fraction * (flDistance - flCurrentDistance))
        fCurrentDamage = fCurrentDamage * math.pow(self:GetRangeModifier(), flCurrentDistance / 500)

        if bFirstHit then
            dmg:SetDamage(fCurrentDamage)
        end

        -- check if we reach penetration distance, no more penetrations after that
        -- or if our modifyer is super low, just stop the bullet
        if (flCurrentDistance > flPenetrationDistance and flPenetration > 0) or
            flPenetrationModifier < 0.1 then
            -- Setting nPenetrationCount to zero prevents the bullet from penetrating object at max distance
            -- and will no longer trace beyond the exit point, however "numPenetrationsInitiallyAllowedForThisBullet"
            -- is saved off to allow correct determination whether the hit on the object at max distance had
            -- *previously* penetrated anything or not. In case of a direct hit over 3000 units the saved off
            -- value would be max penetrations value and will determine a direct hit and not a penetration hit.
            -- However it is important that all tracing further stops past this point (as the code does at
            -- the time of writing) because otherwise next trace will think that 4 penetrations have already
            -- occurred.
            nPenetrationCount = 0;
        end

        local iDamageType = bit.bor(DMG_BULLET, DMG_NEVERGIB)
        -- if wep is taser, DMG_SHOCK | DMG_NEVERGIB
        dmg:SetDamageType(iDamageType)

        if not bFirstHit then
            util.ImpactTrace(tr, DMG_BULLET, "Impact")
            --util.BulletImpact(tr, owner)
        end

        bFirstHit = false

        if SERVER then
            local ent = tr.Entity

            table.insert(arrPendingDamage, {
                ent = ent,
                dmg = fCurrentDamage,
                dmgtype = iDamageType,
                trace = tr,
            })
        end

        if sv_showimpacts_penetration:GetInt() > 0 then
            local text = "^"
            local text2 = Format("%s%d", sv_showimpacts_penetration:GetInt() == 2 and "" or "DAMAGE APPLIED:  ", math.ceil(fCurrentDamage))
            local text3
            -- convert to meters
            --(100%% of shots will fall within a 30cm circle.)
            local flDistMeters = flCurrentDistance * 0.0254
            if flDistMeters >= 1 then
                text3 = Format("%s%0.1fm", sv_showimpacts_penetration:GetInt() == 2 and "" or "TOTAL DISTANCE:  ", flDistMeters)
            else
                text3 = Format("%s%0.1fcm", sv_showimpacts_penetration:GetInt() == 2 and "" or "TOTAL DISTANCE:  ", flDistMeters / 0.01)
            end

            local textPos = tr.HitPos

            debugoverlay.EntityTextAtPosition(textPos, 1, text, sv_showimpacts_time:GetFloat(), Color(255,128,64,255))
            debugoverlay.EntityTextAtPosition(textPos, 2, text2, sv_showimpacts_time:GetFloat(), Color(255,64,0,255))
            debugoverlay.EntityTextAtPosition(textPos, 3, text3, sv_showimpacts_time:GetFloat(), Color(255,128,0,255))

            debugoverlay.Box(tr.HitPos, -Vector(0.8,0.8,0.8), Vector(0.8,0.8,0.8), sv_showimpacts_time:GetFloat(), Color(255,100,50,64))
        end

        local bulletStopped
        bulletStopped, nPenetrationCount, flPenetration, fCurrentDamage = self:HandleBulletPenetration( flPenetration, iEnterMaterial, hitGrate, tr, vecDirShooting, flPenetrationModifier,
            flDamageModifier, iDamageType, flPenetrationPower, nPenetrationCount, vecSrc, flDistance,
            flCurrentDistance, fCurrentDamage )

        if bulletStopped then break end
    end

    for i, t in ipairs(arrPendingDamage) do
        local ent = t.ent
        if arrAlreadyHit[ent] then continue end

        local dmg2 = DamageInfo()
        dmg2:SetAttacker(owner)
        dmg2:SetInflictor(self)

        dmg2:SetDamage(t.dmg)
        dmg2:SetDamageType(t.dmgtype)
        dmg2:SetDamageForce(t.trace.Normal)
        dmg2:SetDamagePosition(t.trace.StartPos)

        if ent:IsPlayer() then
            ent:SetLastHitGroup(t.trace.HitGroup)
        end

        hook.Run("ScalePlayerDamage", ent, t.trace.HitGroup, dmg2)
        ent:TakeDamageInfo(dmg2)

        arrAlreadyHit[ent] = true
    end

    return false
end

local function IsBreakableEntity(ent)
    if not IsValid(ent) then return false end

    -- first check to see if it's already broken
    if ent:Health() < 0 and ent:GetMaxHealth() > 0 then
        return true
    end

    -- If we won't be able to break it, don't try
    if SERVER then
        local var = ent:GetInternalVariable("m_takedamage")
        if tonumber(var) and tonumber(var) ~= 2 then
            return false
        end
    end

    if ent:GetCollisionGroup() ~= COLLISION_GROUP_PUSHAWAY and ent:GetCollisionGroup() ~= COLLISION_GROUP_BREAKABLE_GLASS and ent:GetCollisionGroup() ~= COLLISION_GROUP_NONE then
        return false
    end

    if ent:Health() > 200 then
        return false
    end

    if ent:GetClass() == "func_breakable" or ent:GetClass() == "func_breakable_surf" then
        return true
    end

    return true
end

function SWEP:TraceToExit(start, dir, endpos, trEnter, trExit, flStepSize, flMaxDistance)
    local flDistance = 0
    local nStartContents = 0

    while flDistance <= flMaxDistance do
        flDistance = flDistance + flStepSize

        endpos:Set(start + (flDistance * dir))

        local vecTrEnd = endpos - (flStepSize * dir)

        if nStartContents == 0 then
            nStartContents = bit.band(util.PointContents(endpos), bit.bor(CS_MASK_SHOOT, CONTENTS_HITBOX))
        end

        local nCurrentContents = bit.band(util.PointContents(endpos), bit.bor(CS_MASK_SHOOT, CONTENTS_HITBOX))

        if bit.band(nCurrentContents, CS_MASK_SHOOT) == 0 or ((bit.band(nCurrentContents, CONTENTS_HITBOX) ~= 0) and nStartContents ~= nCurrentContents) then
            -- this gets a bit more complicated and expensive when we have to deal with displacements
            util.TraceLine({
                start = endpos,
                endpos = vecTrEnd,
                mask = bit.bor(CS_MASK_SHOOT, CONTENTS_HITBOX),
                output = trExit,
            })

            -- we exited the wall into a player's hitbox
            if trExit.StartSolid and (bit.band(trExit.SurfaceFlags, SURF_HITBOX) ~= 0) then
                -- do another trace, but skip the player to get the actual exit surface
                util.TraceLine({
                    start = endpos,
                    endpos = start,
                    mask = bit.bor(CS_MASK_SHOOT, CONTENTS_HITBOX),
                    filter = trExit.Entity,
                    collisiongroup = COLLISION_GROUP_NONE,
                    output = trExit
                })

                if trExit.Hit and not trExit.StartSolid then
                    endpos:Set(trExit.HitPos)
                    return true
                end
            elseif trExit.Hit and not trExit.StartSolid then
                local bStartIsNodraw = bit.band(trEnter.SurfaceFlags, SURF_NODRAW) ~= 0
                local bExitIsNodraw = bit.band(trExit.SurfaceFlags, SURF_NODRAW) ~= 0

                if bExitIsNodraw and IsBreakableEntity(trExit.Entity) and IsBreakableEntity(trEnter.Entity) then
                    -- we have a case where we have a breakable object, but the mapper put a nodraw on the backside
                    endpos:Set(trExit.HitPos)
                    return true
                elseif not bExitIsNodraw or (bStartIsNodraw and bExitIsNodraw) then -- exit nodraw is only valid if our entrace is also nodraw
                    local vecNormal = trExit.HitNormal
                    local flDot = dir:Dot(vecNormal)
                    if flDot <= 1 then
                        -- get the real end pos
                        endpos:Set(endpos - ((flStepSize * trExit.Fraction) * dir))
                        return true
                    end
                end
            elseif (trEnter.Entity ~= game.GetWorld()) and IsBreakableEntity(trEnter.Entity) then
                -- if we hit a breakable, make the assumption that we broke it if we can't find an exit (hopefully..)
                -- fake the end pos
                table.CopyFromTo(trEnter, trExit)
                trExit.HitPos = start + (1 * dir)
                return true
            end
        end
    end

    return false
end

function SWEP:HandleBulletPenetration(flPenetration,
                iEnterMaterial,
                bHitGrate,
                tr,
                vecDir,
                flPenetrationModifier,
                flDamageModifier,
                iDamageType,
                flPenetrationPower,
                nPenetrationCount,
                vecSrc,
                flDistance,
                flCurrentDistance,
                fCurrentDamage)

    local bIsNodraw = bit.band(tr.SurfaceFlags, SURF_NODRAW) ~= 0
    local bFailedPenetrate = false

    -- check if bullet can penetrarte another entity
    if nPenetrationCount == 0 and not bHitGrate and not bIsNodraw
        and iEnterMaterial ~= MAT_GLASS and iEnterMaterial ~= MAT_GRATE then
        bFailedPenetrate = true -- no, stop
    end

    -- If we hit a grate with iPenetration == 0, stop on the next thing we hit
    if flPenetration <= 0 or nPenetrationCount <= 0 then
        bFailedPenetrate = true
    end

    local penetrationEnd = Vector()

    -- find exact penetration exit
    local exitTr = {}
    if not self:TraceToExit(tr.HitPos, vecDir, penetrationEnd, tr, exitTr, 4, MAX_PENETRATION_DISTANCE) then
        -- ended in solid
        if bit.band(util.PointContents(tr.HitPos), CS_MASK_SHOOT) == 0 then
            bFailedPenetrate = true
        end
    end

    if bFailedPenetrate then
        local flTraceDistance = (penetrationEnd - tr.HitPos):Length()

        -- this is copy pasted from below, it should probably be its own function
        local flPenMod = math.max(0, 1 / flPenetrationModifier)
        local flPercentDamageChunk = fCurrentDamage * 0.15
        local flDamageLostImpact = flPercentDamageChunk + math.max(0, ( 3 / flPenetrationPower) * 1.18) * (flPenMod * 2.8)

        local flLostDamageObject = ( ( flPenMod * (flTraceDistance * flTraceDistance) ) / 24)
        local flTotalLostDamage = flDamageLostImpact + flLostDamageObject

        self:DisplayPenetrationDebug( tr.HitPos, penetrationEnd, flTraceDistance, fCurrentDamage, flDamageLostImpact, flTotalLostDamage, tr.SurfaceProps, -100 )
        return true, nPenetrationCount, flPenetration, fCurrentDamage
    end

    local iExitMaterial
    if table.IsEmpty(exitTr) then
        if SWCS_DEBUG_PENETRATION:GetBool() then
            print("exit trace empty???, stopping penetration!!!!")
        end

        return true, nPenetrationCount, flPenetration, fCurrentDamage
    end
    local exitSurfaceData = util.GetSurfaceData(exitTr.SurfaceProps)

    if exitSurfaceData then
        iExitMaterial = exitSurfaceData.material
    end
    if not iExitMaterial then
        if SWCS_DEBUG_PENETRATION:GetBool() then
            print(Format("exit material not engine registered at (%f %f %f), using default instead",
                tr.HitPos.x, tr.HitPos.y, tr.HitPos.z))
        end
        iExitMaterial = util.GetSurfaceData(SURFACE_PROP_DEFAULT).material
    end

    -- new penetration method
    if sv_penetration_type:GetInt() == 1 then
        -- percent of total damage lost automatically on impacting a surface
        local flDamLostPercent = 0.16

        -- since some railings in de_inferno are CONTENTS_GRATE but CHAR_TEX_CONCRETE, we'll trust the
        -- CONTENTS_GRATE and use a high damage modifier.
        if bHitGrate or bIsNodraw or iEnterMaterial == MAT_GLASS or iEnterMaterial == MAT_GRATE then
            -- If we're a concrete grate (TOOLS/TOOLSINVISIBLE texture) allow more penetrating power.
            if iEnterMaterial == MAT_GRATE or iEnterMaterial == MAT_GRATE then
                flPenetrationModifier = 3
                flDamLostPercent = 0.05
            else
                flPenetrationModifier = 1
            end

            flDamageModifier = 0.99
        else
            -- check the exit material and average the exit and entrace values
            local pen_mat
            if exitSurfaceData then
                pen_mat = pen_types[string.lower(exitSurfaceData.name)]
            end

            if not pen_mat then
                pen_mat = DEFAULT_PENETRATE
            end

            local flExitPenetrationModifier = pen_mat.penetrationmodifier
            local flExitDamageModifier = pen_mat.damagemodifier
            flPenetrationModifier = (flPenetrationModifier + flExitPenetrationModifier) / 2
            flDamageModifier = (flDamageModifier + flExitDamageModifier) / 2
        end

        -- if enter & exit point is wood we assume this is 
        -- a hollow crate and give a penetration bonus
        if iEnterMaterial == iExitMaterial then
            if iExitMaterial == MAT_WOOD or iExitMaterial == CHAR_TEX_CARDBOARD then
                flPenetrationModifier = 3
            elseif iExitMaterial == MAT_PLASTIC then
                flPenetrationModifier = 2
            end
        end

        local flTraceDistance = (exitTr.HitPos - tr.HitPos):Length()
        local flPenMod = math.max(0, 1 / flPenetrationModifier)

        local flPercentDamageChunk = fCurrentDamage * flDamLostPercent
        local flPenWepMod = flPercentDamageChunk + math.max(0, (3 / flPenetrationPower) * 1.25) * (flPenMod * 3)

        local flLostDamageObject = ((flPenMod * (flTraceDistance * flTraceDistance)) / 24)
        local flTotalLostDamage = flPenWepMod + flLostDamageObject

        if sv_showimpacts_penetration:GetInt() > 0 then
            local vecStart = tr.HitPos
            local vecEnd = penetrationEnd
            local flTotalTraceDistance = (penetrationEnd - tr.HitPos):Length()

            self:DisplayPenetrationDebug(vecStart, vecEnd, flTotalTraceDistance, fCurrentDamage, flPenWepMod, flTotalLostDamage, tr.SurfaceProps, exitTr.SurfaceProps ) -- extra shit here pls dont forget novus
        end

        -- reduce damage each time we hit something other than a grate
        fCurrentDamage = fCurrentDamage - math.max(0, flTotalLostDamage)
        if fCurrentDamage < 1 then
            return true, nPenetrationCount, flPenetration, fCurrentDamage
        end

        -- penetration was successful

        -- bullet did penetrate object, exit Decal
        if self:GetPlayerOwner() then
            --util.BulletImpact(exitTr, self:GetPlayerOwner())
        end

        -- setup new start end parameters for successive trace
        flCurrentDistance = flCurrentDistance + flTraceDistance
        vecSrc:Set(exitTr.HitPos)
        flDistance = (flDistance - flCurrentDistance) * 0.5

        nPenetrationCount = nPenetrationCount - 1
        return false, nPenetrationCount, flPenetration, fCurrentDamage
    else
        -- old, gay method
        --[[
            // get material at exit point
            surfacedata_t *pExitSurfaceData = physprops->GetSurfaceData( exitTr.surface.surfaceProps );
            int iExitMaterial = pExitSurfaceData->game.material;

            // old penetration method
            if ( sv_penetration_type.GetInt() != 1 )
            {
                // since some railings in de_inferno are CONTENTS_GRATE but CHAR_TEX_CONCRETE, we'll trust the
                // CONTENTS_GRATE and use a high damage modifier.
                if ( hitGrate || bIsNodraw )
                {
                    // If we're a concrete grate (TOOLS/TOOLSINVISIBLE texture) allow more penetrating power.
                    flPenetrationModifier = 1.0f;
                    flDamageModifier = 0.99f;
                }
                else
                {
                    // Check the exit material to see if it is has less penetration than the entrance material.
                    float flExitPenetrationModifier = pExitSurfaceData->game.penetrationModifier;
                    float flExitDamageModifier = pExitSurfaceData->game.damageModifier;
                    if ( flExitPenetrationModifier < flPenetrationModifier )
                    {
                        flPenetrationModifier = flExitPenetrationModifier;
                    }
                    if ( flExitDamageModifier < flDamageModifier )
                    {
                        flDamageModifier = flExitDamageModifier;
                    }
                }

                // if enter & exit point is wood or metal we assume this is 
                // a hollow crate or barrel and give a penetration bonus
                if ( iEnterMaterial == iExitMaterial )
                {
                    if ( iExitMaterial == CHAR_TEX_WOOD ||
                        iExitMaterial == CHAR_TEX_METAL )
                    {
                        flPenetrationModifier *= 2;
                    }
                }

                float flTraceDistance = VectorLength( exitTr.endpos - tr.endpos );

                // check if bullet has enough power to penetrate this distance for this material
                if ( flTraceDistance > ( flPenetrationPower * flPenetrationModifier ) )
                    return true; // bullet hasn't enough power to penetrate this distance

                // reduce damage power each time we hit something other than a grate
                fCurrentDamage *= flDamageModifier;

                // penetration was successful

                // bullet did penetrate object, exit Decal
                if ( bDoEffects )
                {
                    UTIL_ImpactTrace( &exitTr, iDamageType );
                }

                #ifndef CLIENT_DLL
                    // decal players on the server to eliminate the disparity between where the client thinks the decal went and where it actually went
                    // we want to eliminate the case where a player sees a blood decal on someone, but they are at 100 health
                    if ( sv_server_verify_blood_on_player.GetBool() && tr.DidHit() && tr.m_pEnt && tr.m_pEnt->IsPlayer() )
                    {
                        UTIL_ImpactTrace( &tr, iDamageType );
                    }
                #endif

                //setup new start end parameters for successive trace

                flPenetrationPower -= flTraceDistance / flPenetrationModifier;
                flCurrentDistance += flTraceDistance;

                // NDebugOverlay::Box( exitTr.endpos, Vector(-2,-2,-2), Vector(2,2,2), 0,255,0,127, 8 );

                vecSrc = exitTr.endpos;
                flDistance = ( flDistance - flCurrentDistance ) * 0.5;

                // reduce penetration counter
                nPenetrationCount--;
                return false;
            }
        ]]
    end
    return true, nPenetrationCount, flPenetration, fCurrentDamage
end

function SWEP:DisplayPenetrationDebug(vecEnter, vecExit, flDistance, flInitialDamage, flDamageLostImpact, flTotalLostDamage, nEnterSurf, nExitSurf)
    if SERVER and sv_showimpacts_penetration:GetInt() > 0 then
        local vecStart = vecEnter
        local vecEnd = vecExit
        local flTotalTraceDistance = (vecExit - vecEnd):Length()

        if flTotalLostDamage >= flInitialDamage then
            nExitSurf = -100

            local flLostDamageObject = (flTotalLostDamage - flDamageLostImpact)
            local flFrac = math.max(0, (flInitialDamage - flDamageLostImpact) / flLostDamageObject)
            vecEnd = vecEnd - vecStart
            vecEnd:Normalize()
            vecEnd = vecStart + (vecEnd * flTotalTraceDistance * flFrac)

            if flDamageLostImpact >= flInitialDamage then
                flDistance = 0
                vecStart = vecEnd
            end

            flTotalLostDamage = math.ceil(flInitialDamage)
        end

        local textPos = vecEnd * 1
        local text = ""

        if flTotalLostDamage < flInitialDamage then
            local flDistMeters = flDistance * 0.0254
            if flDistMeters >= 1 then
                text = Format("%s%0.1fm", sv_showimpacts_penetration:GetInt() == 2 and "" or "THICKNESS:		", flDistMeters)
            else
                text = Format("%s%0.1fcm", sv_showimpacts_penetration:GetInt() == 2 and "" or "THICKNESS:		", flDistMeters / 0.01)
            end
        else
            text = "STOPPED!"
        end

        debugoverlay.EntityTextAtPosition(textPos, -3, text, sv_showimpacts_time:GetFloat(), Color(220, 128, 128, 255))

        local text3 = Format("%s%0.1f", sv_showimpacts_penetration:GetInt() == 2 and "-" or "LOST DAMAGE:		", flTotalLostDamage)
        debugoverlay.EntityTextAtPosition(textPos, -2, text3, sv_showimpacts_time:GetFloat(), Color(90, 22, 0, 160))

        local textmat1 = Format("%s", nEnterSurf and util.GetSurfacePropName(nEnterSurf) or "nil")
        debugoverlay.EntityTextAtPosition(vecStart, -1, textmat1, sv_showimpacts_time:GetFloat(), Color(0,255,0,128))

        if nExitSurf ~= -100 then
            debugoverlay.Box(vecStart, -Vector(0.4,0.4,0.4), Vector(0.4,0.4,0.4), sv_showimpacts_time:GetFloat(), Color(0,255,0,128))

            local textmat2 = Format("%s", nExitSurf and nExitSurf == -1 and "" or (nExitSurf and util.GetSurfacePropName( nExitSurf ) or "nil") )
            debugoverlay.Box(vecEnd, -Vector(0.4,0.4,0.4), Vector(0.4,0.4,0.4), sv_showimpacts_time:GetFloat(), Color(0,128,255,128))
            debugoverlay.EntityTextAtPosition(vecEnd, -1, textmat2, sv_showimpacts_time:GetFloat(), Color(0,128,255,128))

            if flDistance > 0 and vecStart ~= vecEnd then
                debugoverlay.Line(vecStart, vecEnd, sv_showimpacts_time:GetFloat(), Color(0,190,190), true)
            end
        else
            -- different color
            debugoverlay.Box(vecStart, -Vector(0.4,0.4,0.4), Vector(0.4,0.4,0.4), sv_showimpacts_time:GetFloat(), Color(160,255,0,128))
            debugoverlay.Line(vecStart, vecEnd, sv_showimpacts_time:GetFloat(), Color(190,190,0), true)
        end
    end
end