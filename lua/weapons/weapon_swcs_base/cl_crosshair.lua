SWEP.m_fAnimInset = 0
SWEP.m_fLineSpreadDistance = 0

local cl_crosshair_sniper_show_normal_inaccuracy = CreateClientConVar("cl_crosshair_sniper_show_normal_inaccuracy", "0", nil, nil, "Include standing inaccuracy when determining sniper crosshair blur")
local cl_crosshair_sniper_width = GetConVar"cl_crosshair_sniper_width"

local matDust = Material"overlays/scope_lens_csgo"
local matArc  = Material"sprites/scope_arc_csgo"
local matBlur = Material"sprites/scope_line_blur"

function SWEP:DrawHUD()
    local owner = self:GetPlayerOwner()
    if not owner then return end

    self:DrawCrosshair()

    if self:GetWeaponType() ~= "sniperrifle" then return end

    local kScopeMinFOV = 25.0 -- Clamp scope FOV to this value to prevent blur from getting too big when double-scoped
    local flTargetFOVForZoom = math.max( self:GetZoomFOV( self:GetZoomLevel() ), kScopeMinFOV )

    if flTargetFOVForZoom ~= owner:GetDefaultFOV() and self:IsZoomed() and not self:GetResumeZoom() then
        local screenWide, screenTall = ScrW(), ScrH()

        local vm = owner:GetViewModel(0)
        if not vm:IsValid() then return end

        local fHalfFov = math.rad(flTargetFOVForZoom) * 0.5
        local fInaccuracyIn640x480Pixels = 320.0 / math.tan( fHalfFov ) -- 640 = "reference screen width"

        -- Get the weapon's inaccuracy
        local fWeaponInaccuracy = self:GetInaccuracy() + self:GetSpread()

        -- Optional: Ignore "default" inaccuracy
        if not cl_crosshair_sniper_show_normal_inaccuracy:GetBool() then
            fWeaponInaccuracy = fWeaponInaccuracy - self:GetInaccuracyStand(Secondary_Mode) + self:GetSpread()
        end

        fWeaponInaccuracy = math.max( fWeaponInaccuracy, 0 )

        local fRawSpreadDistance = fWeaponInaccuracy * fInaccuracyIn640x480Pixels
        local fSpreadDistance = math.Clamp( fRawSpreadDistance, 0, 100 )

        -- reduce the goal  (* 0.4 / 30.0f)
        -- then animate towards it at speed 19.0f
        -- (where did these numbers come from?)
        local flInsetGoal = fSpreadDistance * (0.4 / 30.0);
        self.m_fAnimInset = math.Approach(self.m_fAnimInset, flInsetGoal, math.abs((flInsetGoal - self.m_fAnimInset) - FrameTime()) * 19)

        -- Approach speed chosen so we get 90% there in 3 frames if we are running at 192 fps vs a 64tick client/server.
        -- If our fps is lower we will reach the target faster, if higher it is slightly slower
        -- (since this is a framerate-dependent approach function).
        self.m_fLineSpreadDistance = util.RemapValClamped(FrameTime() * 140, 0, 1, self.m_fLineSpreadDistance, fRawSpreadDistance)

        local flAccuracyFishtail = self:GetAccuracyFishtail()
        local offsetX = math.floor(self.m_bobState.m_flRawLateralBob * (screenTall / 14) + flAccuracyFishtail)
        local offsetY = math.floor(self.m_bobState.m_flRawVerticalBob * (screenTall / 14))

        local flInacDisplayBlur = self.m_fAnimInset * 0.04
        if flInacDisplayBlur > 0.22 then
            flInacDisplayBlur = 0.22
        end

        -- calculate the bounds in which we should draw the scope
        local inset = math.floor((screenTall / 14) + (flInacDisplayBlur * (screenTall * 0.5)))
        local y1 = inset
        local x1 = (screenWide - screenTall) / 2 + inset
        local y2 = screenTall - inset
        local x2 = screenWide - x1

        y1 = y1 + offsetY
        y2 = y2 + offsetY
        x1 = x1 + offsetX
        x2 = x2 + offsetX

        local x = (screenWide / 2) + offsetX
        local y = (screenTall / 2) + offsetY

        local uv1 = 0.5 / 256
        local uv2 = 1 - uv1

        local vert = {{}, {}, {}, {}}

        local uv11 = Vector(uv1, uv1, 0)
        local uv12 = Vector(uv1, uv2, 0)
        local uv21 = Vector(uv2, uv1, 0)
        local uv22 = Vector(uv2, uv2, 0)

        local xMod = (screenWide / 2) + offsetX + (flInacDisplayBlur * screenTall)
        local yMod = (screenTall / 2) + offsetY + (flInacDisplayBlur * screenTall)

        local iMiddleX = (screenWide / 2) + offsetX
        local iMiddleY = (screenTall / 2) + offsetY

        surface.SetMaterial(matDust)
        surface.SetDrawColor(255, 255, 255, 200)

        -- bottom right
        vert[1].x = iMiddleX + xMod
        vert[1].y = iMiddleY + yMod
        vert[1].u = uv21.x
        vert[1].v = uv21.y

        -- bottom left
        vert[2].x = iMiddleX - xMod
        vert[2].y = iMiddleY + yMod
        vert[2].u = uv11.x
        vert[2].v = uv11.y

        -- top left
        vert[3].x = iMiddleX - xMod
        vert[3].y = iMiddleY - yMod
        vert[3].u = uv12.x
        vert[3].v = uv12.y

        -- top right
        vert[4].x = iMiddleX + xMod
        vert[4].y = iMiddleY - yMod
        vert[4].u = uv22.x
        vert[4].v = uv22.y

        surface.DrawPoly(vert)

        -- The math.pow here makes the blur not quite spread out quite as much as the actual inaccuracy;
        -- doing so is a bit too sudden and also leads to just a huge blur because the snipers are
        -- *extremely* inaccurate while scoped and moving.  This way we get a slightly smoother animation
        -- as well as not quite blowing up the blurred area by such a large amount.
        local fBlurWidth = math.pow(self.m_fLineSpreadDistance, 0.75)
        local fScreenBlurWidth = fBlurWidth * screenTall / 640.0  -- scale from 'reference screen size' to actual screen

        local nSniperCrosshairThickness = cl_crosshair_sniper_width:GetInt()
        if nSniperCrosshairThickness < 1 then
            nSniperCrosshairThickness = 1
        end

        local kMaxVarianceWithFullAlpha = 1.8 -- Tuned to look good
        local fBlurAlpha
        if fScreenBlurWidth <= nSniperCrosshairThickness + 0.5 then
            fBlurAlpha = (fBlurWidth < 1) and 1 or 1 / fBlurWidth
        else
            fBlurAlpha = (fBlurWidth < kMaxVarianceWithFullAlpha) and 1 or kMaxVarianceWithFullAlpha / fBlurWidth
        end

        -- This is a break from physical reality to make the look a bit better.  An actual Gaussian
        -- blur spreads the energy out over the entire blurred area, dropping the total opacity by the amount
        -- of the spread.  However, this leads to not being able to see the effect at all.  We solve this in 
        -- 2 ways:
        --   (1) use sqrt on the alpha to bring it closer to 1, kind of like a gamma curve.
        --   (2) clamp the alpha at the lower end to 55% to make sure you can see *something* no matter
        --       how spread out it gets.
        fBlurAlpha = math.sqrt(fBlurAlpha)
        local iBlurAlpha = math.floor(math.Clamp(fBlurAlpha * 255, 140, 255))

        -- //DevMsg( "blur: %8.5f fov: %8.5f alpha: %8.5f\n", fBlurWidth, flTargetFOVForZoom, fBlurAlpha );

        if fScreenBlurWidth <= nSniperCrosshairThickness + 0.5 then
            surface.SetDrawColor(0, 0, 0, iBlurAlpha)

            -- Draw the reticle with primitives
            if nSniperCrosshairThickness <= 1 then
                surface.DrawLine(0, y, screenWide + offsetX, y)
                surface.DrawLine(x, 0, x, screenTall + offsetY)
            else
                local nStep = math.floor(nSniperCrosshairThickness / 2)
                surface.DrawRect(0, y - nStep, screenWide + offsetX, y + nSniperCrosshairThickness - nStep)
                surface.DrawRect(x - nStep, 0, x + nSniperCrosshairThickness - nStep, screenTall + offsetY)
            end
        else
            surface.SetDrawColor(0, 0, 0, iBlurAlpha)
            surface.SetMaterial(matBlur)

            -- vertical blurred line
            vert[1].x = iMiddleX - fScreenBlurWidth
            vert[1].y = offsetY
            vert[1].u = uv11.x
            vert[1].v = uv11.y

            vert[2].x = iMiddleX + fScreenBlurWidth
            vert[2].y = offsetY
            vert[2].u = uv21.x
            vert[2].v = uv21.y

            vert[3].x = iMiddleX + fScreenBlurWidth
            vert[3].y = screenTall + offsetY
            vert[3].u = uv22.x
            vert[3].v = uv22.y

            vert[4].x = iMiddleX - fScreenBlurWidth
            vert[4].y = screenTall + offsetY
            vert[4].u = uv12.x
            vert[4].v = uv12.y
            surface.DrawPoly(vert)

            -- horizontal blurred line
            vert[1].x = screenWide + offsetX
            vert[1].y = iMiddleY - fScreenBlurWidth
            vert[1].u = uv12.x
            vert[1].v = uv12.y

            vert[2].x = screenWide + offsetX
            vert[2].y = iMiddleY + fScreenBlurWidth
            vert[2].u = uv22.x
            vert[2].v = uv22.y

            vert[3].x = offsetX
            vert[3].y = iMiddleY + fScreenBlurWidth
            vert[3].u = uv21.x
            vert[3].v = uv21.y

            vert[4].x = offsetX
            vert[4].y = iMiddleY - fScreenBlurWidth
            vert[4].u = uv11.x
            vert[4].v = uv11.y
            surface.DrawPoly(vert)
        end

        surface.SetDrawColor(0, 0, 0, 255)
        surface.SetMaterial(matArc)

        -- bottom right
        vert[1].x = x
        vert[1].y = y
        vert[1].u = uv11.x
        vert[1].v = uv11.y

        vert[2].x = x2
        vert[2].y = y
        vert[2].u = uv21.x
        vert[2].v = uv21.y

        vert[3].x = x2
        vert[3].y = y2
        vert[3].u = uv22.x
        vert[3].v = uv22.y

        vert[4].x = x
        vert[4].y = y2
        vert[4].u = uv12.x
        vert[4].v = uv12.y
        surface.DrawPoly(vert)

        -- top right
        vert[1].x = x - 1
        vert[1].y = y1
        vert[1].u = uv12.x
        vert[1].v = uv12.y

        vert[2].x = x2
        vert[2].y = y1
        vert[2].u = uv22.x
        vert[2].v = uv22.y

        vert[3].x = x2
        vert[3].y = y + 1
        vert[3].u = uv21.x
        vert[3].v = uv21.y

        vert[4].x = x - 1
        vert[4].y = y + 1
        vert[4].u = uv11.x
        vert[4].v = uv11.y
        surface.DrawPoly(vert)

        -- bottom left
        vert[1].x = x1
        vert[1].y = y
        vert[1].u = uv21.x
        vert[1].v = uv21.y

        vert[2].x = x
        vert[2].y = y
        vert[2].u = uv11.x
        vert[2].v = uv11.y

        vert[3].x = x
        vert[3].y = y2
        vert[3].u = uv12.x
        vert[3].v = uv12.y

        vert[4].x = x1
        vert[4].y = y2
        vert[4].u = uv22.x
        vert[4].v = uv22.y
        surface.DrawPoly(vert)

        -- top left
        vert[1].x = x1
        vert[1].y = y1
        vert[1].u = uv22.x
        vert[1].v = uv22.y

        vert[2].x = x
        vert[2].y = y1
        vert[2].u = uv12.x
        vert[2].v = uv12.y

        vert[3].x = x
        vert[3].y = y
        vert[3].u = uv11.x
        vert[3].v = uv11.y

        vert[4].x = x1
        vert[4].y = y
        vert[4].u = uv21.x
        vert[4].v = uv21.y
        surface.DrawPoly(vert)

        surface.DrawRect(0, 0, screenWide, y1) -- top
        surface.DrawRect(0, y2, screenWide, screenTall) -- bottom
        surface.DrawRect(0, y1, x1, screenTall) -- left
        surface.DrawRect(x2, y1, screenWide, screenTall) -- right
    end
end

local cl_crosshairdot = GetConVar"cl_crosshairdot"
local cl_crosshairstyle = GetConVar"cl_crosshairstyle"
local cl_crosshaircolor = GetConVar"cl_crosshaircolor"
local cl_crosshairalpha = GetConVar"cl_crosshairalpha"
local cl_crosshaircolor_r = GetConVar"cl_crosshaircolor_r"
local cl_crosshaircolor_g = GetConVar"cl_crosshaircolor_g"
local cl_crosshaircolor_b = GetConVar"cl_crosshaircolor_b"
local cl_crosshair_dynamic_splitdist = GetConVar"cl_crosshair_dynamic_splitdist"
local cl_crosshairgap_useweaponvalue = GetConVar"cl_crosshairgap_useweaponvalue"
local cl_crosshairgap = GetConVar"cl_crosshairgap"
local cl_crosshairsize = GetConVar"cl_crosshairsize"
local cl_crosshairthickness = GetConVar"cl_crosshairthickness"
local cl_crosshair_dynamic_splitalpha_innermod = GetConVar"cl_crosshair_dynamic_splitalpha_innermod"
local cl_crosshair_dynamic_splitalpha_outermod = GetConVar"cl_crosshair_dynamic_splitalpha_outermod"
local cl_crosshair_dynamic_maxdist_splitratio = GetConVar"cl_crosshair_dynamic_maxdist_splitratio"
local cl_crosshair_drawoutline = GetConVar"cl_crosshair_drawoutline"
local cl_crosshair_outlinethickness = GetConVar"cl_crosshair_outlinethickness"
local cl_crosshairusealpha = GetConVar"cl_crosshairusealpha"
local weapon_debug_spread_show = GetConVar"weapon_debug_spread_show"
local weapon_debug_spread_gap = CreateConVar("weapon_debug_spread_gap", "0.67", {FCVAR_REPLICATED})

local function DrawCrosshairRect(r,g,b,a, x0, y0, x1, y1, bAdditive)
    local w = math.max(x0, x1) - math.min(x0, x1)
    local h = math.max(y0, y1) - math.min(y0, y1)

    if cl_crosshair_drawoutline:GetBool() then
        local flThick = cl_crosshair_outlinethickness:GetFloat() * 2
        surface.SetDrawColor(0,0,0,a)
        surface.DrawRect(x0 - math.floor(flThick / 2), y0 - math.floor(flThick / 2), w + flThick, h + flThick)
    end

    surface.SetDrawColor(r,g,b,a)

    if bAdditive then
        surface.DrawTexturedRect(x0, y0, w, h)
    else
        surface.DrawRect(x0, y0, w, h)
    end
end

local SWITCH_CrosshairColor = {
    [0] = Color(250, 50, 50),
    Color(50, 250, 50),
    Color(250, 250, 50),
    Color(50, 50, 250),
    Color(50, 250, 250),
    function ()
        return Color(
            cl_crosshaircolor_r:GetInt(),
            cl_crosshaircolor_g:GetInt(),
            cl_crosshaircolor_b:GetInt()
        )
    end,
}

local function XRES(x)
    return x * (ScrW() / 640)
end
local function YRES(y)
    return y * (ScrH() / 480)
end

local cl_crosshair_t = GetConVar"cl_crosshair_t"
local cl_weapon_debug_print_accuracy = CreateConVar("cl_weapon_debug_print_accuracy", 0)
local cl_cam_driver_compensation_scale = CreateClientConVar("cl_cam_driver_compensation_scale", "0.75")

local VIEWPUNCH_COMPENSATE_MAGIC_SCALAR = 0.65

SWEP.m_flCrosshairDistance = 0
SWEP.m_iAmmoLastCheck = 0
function SWEP:DrawCrosshair()
    local owner = self:GetPlayerOwner()
    if not owner then return end

    assert(owner == LocalPlayer() or LocalPlayer():GetObserverMode() == OBS_MODE_IN_EYE)

    -- no crosshair for sniper rifles

    -- localplayer must be owner if not in Spec mode

    local r,g,b = 50, 250, 50
    if SWITCH_CrosshairColor[cl_crosshaircolor:GetInt()] then
        local col = SWITCH_CrosshairColor[cl_crosshaircolor:GetInt()]

        if isfunction(col) then
            col = col()
        end

        r,g,b = col.r, col.g, col.b
    end

    local alpha = math.Clamp(cl_crosshairalpha:GetInt(), 0, 255)

    if not self.m_iCrosshairTextureID then
        self.m_iCrosshairTextureID = surface.GetTextureID("vgui/white_additive")
    end

    local bAdditive = not cl_crosshairusealpha:GetBool()
    if bAdditive then
        surface.SetTexture(self.m_iCrosshairTextureID)
        alpha = 200
    end

    local iron = self.m_IronSightController
    if iron and iron:ShouldHideCrossHair() then
        alpha = 0
    end

    if self:GetWeaponType() == "sniperrifle" then
        return true
    end

    local fHalfFov = math.rad(owner:GetFOV()) * 0.5
    local flInaccuracy = self:GetInaccuracy()
    local flSpread = self:GetSpread()

    local fSpreadDistance = ((flInaccuracy + flSpread) * 320 / math.tan(fHalfFov))
    local flCappedSpreadDistance = fSpreadDistance
    local flMaxCrossDistance = cl_crosshair_dynamic_splitdist:GetFloat()
    if fSpreadDistance > flMaxCrossDistance then
        flCappedSpreadDistance = flMaxCrossDistance
    end

    local iSpreadDistance = cl_crosshairstyle:GetInt() < 4 and math.floor(YRES(fSpreadDistance)) or 2
    local iCappedSpreadDistance = cl_crosshairstyle:GetInt() < 4 and math.floor(YRES(flCappedSpreadDistance)) or 2

    local flAccuracyFishtail = self:GetAccuracyFishtail()

    if cl_weapon_debug_print_accuracy:GetInt() == 1 then
        local flVel = owner:GetVelocity():Length()
        if flVel > 0 then
            Msg(Format("Inaccuracy =\t%f\tSpread =\t%f\tSpreadDistance =\t%f\tPlayer Velocity =\t%f\n", flInaccuracy, flSpread, fSpreadDistance, flVel))
        end
    end

    local iDeltaDistance = self:GetCrosshairDeltaDistance() -- amount by which the crosshair expands when shooting (per frame)
    local fCrosshairDistanceGoal = cl_crosshairgap_useweaponvalue:GetBool() and self:GetCrosshairMinDistance() or 4 -- The minimum distance the crosshair can achieve...

    -- 0 = default
    -- 1 = default static
    -- 2 = classic standard
    -- 3 = classic dynamic
    -- 4 = classic static
    -- if ( cl_dynamiccrosshair.GetBool() )
    if cl_crosshairstyle:GetInt() ~= 4 and (cl_crosshairstyle:GetInt() == 2 or cl_crosshairstyle:GetInt() == 3) then
        if not owner:IsOnGround() then
            fCrosshairDistanceGoal = fCrosshairDistanceGoal * 2
        elseif owner:Crouching() then
            fCrosshairDistanceGoal = fCrosshairDistanceGoal * 0.5
        elseif owner:GetVelocity():Length() > 100 then
            fCrosshairDistanceGoal = fCrosshairDistanceGoal * 1.5
        end
    end

    -- [jpaquin] changed to only bump up the crosshair size if the player is still shooting or is spectating someone else
    if self:GetShotsFired() > self.m_iAmmoLastCheck and (owner:KeyDown(IN_ATTACK) or owner:KeyDown(IN_ATTACK2)) and self:Clip1() >= 0 then
        if cl_crosshairstyle:GetInt() == 5 then
            self.m_flCrosshairDistance = self.m_flCrosshairDistance + (self:GetRecoilMagnitude(self:GetWeaponMode()) / 3.5)
        elseif cl_crosshairstyle:GetInt() ~= 4 then
            fCrosshairDistanceGoal = fCrosshairDistanceGoal + iDeltaDistance
        end
    end

    self.m_iAmmoLastCheck = self:GetShotsFired()

    if self.m_flCrosshairDistance > fCrosshairDistanceGoal then
        if cl_crosshairstyle:GetInt() == 5 then
            self.m_flCrosshairDistance = self.m_flCrosshairDistance - 42 * FrameTime()
        else
            self.m_flCrosshairDistance = Lerp(FrameTime() / 0.025, fCrosshairDistanceGoal, self.m_flCrosshairDistance)
        end
    end

    -- clamp max crosshair expansion
    self.m_flCrosshairDistance = math.Clamp(self.m_flCrosshairDistance, fCrosshairDistanceGoal, 25.0)

    local iCrosshairDistance, iBarSize, iBarThickness
    local iCappedCrosshairDistance = 0

    iCrosshairDistance = math.floor((self.m_flCrosshairDistance * ScrH() / 1200.0) + cl_crosshairgap:GetFloat())
    iBarSize = math.floor( YRES( cl_crosshairsize:GetFloat() ))
    iBarThickness = math.max( 1, math.floor( YRES( cl_crosshairthickness:GetFloat() )) )

    -- 0 = default
    -- 1 = default static
    -- 2 = classic standard
    -- 3 = classic dynamic
    -- 4 = classic static
    -- if weapon_debug_spread_show:GetInt() == 2
    if iSpreadDistance > 0 and cl_crosshairstyle:GetInt() == 2 or cl_crosshairstyle:GetInt() == 3 then
        iCrosshairDistance = iSpreadDistance + cl_crosshairgap:GetFloat()

        if cl_crosshairstyle:GetInt() == 2 then
            iCappedCrosshairDistance = iCappedSpreadDistance + cl_crosshairgap:GetFloat()
        end
    elseif cl_crosshairstyle:GetInt() == 4 or (iSpreadDistance == 0 and (cl_crosshairstyle:GetInt() == 2 or cl_crosshairstyle:GetInt() == 3)) then
        iCrosshairDistance = fCrosshairDistanceGoal + cl_crosshairgap:GetFloat()
        iCappedCrosshairDistance = 4 + cl_crosshairgap:GetFloat()
    end

    local iCenterX = math.floor(ScrW() / 2)
    local iCenterY = math.floor(ScrH() / 2)

    local flAngleToScreenPixel = 0


    -- subtract a ratio of cam driver motion from crosshair according to cl_cam_driver_compensation_scale
    if cl_cam_driver_compensation_scale:GetFloat() ~= 0 and owner then
        local vm = owner:GetViewModel(self:ViewModelIndex())
        --print(vm, self.m_flCamDriverWeight)

        if vm:IsValid() and self.m_flCamDriverWeight > 0 then
            local angCamDriver = self.m_flCamDriverWeight * self.m_angCamDriverLastAng * math.Clamp(cl_cam_driver_compensation_scale:GetFloat(), -10, 10)

            if angCamDriver.x ~= 0 or angCamDriver.y ~= 0 then
                flAngleToScreenPixel = VIEWPUNCH_COMPENSATE_MAGIC_SCALAR * 2 * (ScrH() / (2 * math.tan(math.rad(owner:GetFOV()) / 2)))
                iCenterY = iCenterY - (flAngleToScreenPixel * math.sin(math.rad(angCamDriver.x)))
                iCenterX = iCenterX + (flAngleToScreenPixel * math.sin(math.rad(angCamDriver.y)))
            end
        end
    end
    --[[
        if ( cl_cam_driver_compensation_scale.GetFloat() != 0 )
        {
            CBasePlayer *pOwner = ToBasePlayer( GetPlayerOwner() );
            if ( pOwner )
            {
                CBaseViewModel *vm = pOwner->GetViewModel( m_nViewModelIndex );
                if ( vm && vm->m_flCamDriverWeight > 0 )
                {
                    QAngle angCamDriver = vm->m_flCamDriverWeight * vm->m_angCamDriverLastAng * clamp( cl_cam_driver_compensation_scale.GetFloat(), -10.0f, 10.0f );
                    if ( angCamDriver.x != 0 || angCamDriver.y != 0  )
                    {
                        flAngleToScreenPixel = VIEWPUNCH_COMPENSATE_MAGIC_SCALAR * 2 * ( ScreenHeight() / ( 2.0f * tanf(DEG2RAD( pPlayer->GetFOV() ) / 2.0f) ) );
                        iCenterY -= ( flAngleToScreenPixel * sinf( DEG2RAD( angCamDriver.x ) ) ) ;
                        iCenterX += ( flAngleToScreenPixel * sinf( DEG2RAD( angCamDriver.y ) ) ) ;
                    }
                }
            }
        }

        /*
            // Optionally subtract out viewangle since it doesn't affect shooting.
            if ( cl_flinch_compensate_crosshair.GetBool() )
            {
                QAngle viewPunch = pPlayer->GetViewPunchAngle();

                if ( viewPunch.x != 0 || viewPunch.y != 0 )
                {
                    if ( flAngleToScreenPixel == 0 )
                        flAngleToScreenPixel = VIEWPUNCH_COMPENSATE_MAGIC_SCALAR * 2 * ( ScreenHeight() / ( 2.0f * tanf(DEG2RAD( pPlayer->GetFOV() ) / 2.0f) ) );

                    iCenterY -= flAngleToScreenPixel * sinf( DEG2RAD( viewPunch.x ) );
                    iCenterX += flAngleToScreenPixel * sinf( DEG2RAD( viewPunch.y ) );
                }
            }
        */
    ]]

    local nFishTaleShift = (flAccuracyFishtail * (ScrW() / 500))

    -- 0 = default
    -- 1 = default static
    -- 2 = classic standard
    -- 3 = classic dynamic
    -- 4 = classic static
    if cl_crosshairstyle:GetInt() == 4 then
        nFishTaleShift = 0
    end

    local flAlphaSplitInner = cl_crosshair_dynamic_splitalpha_innermod:GetFloat()
    local flAlphaSplitOuter = cl_crosshair_dynamic_splitalpha_outermod:GetFloat()
    local flSplitRatio = cl_crosshair_dynamic_maxdist_splitratio:GetFloat()
    local iInnerCrossDist = iCrosshairDistance
    local flLineAlphaInner = alpha
    local flLineAlphaOuter = alpha
    local iBarSizeInner = iBarSize
    local iBarSizeOuter = iBarSize

    -- draw the crosshair that splits off from the main xhair
    if cl_crosshairstyle:GetInt() == 2 and fSpreadDistance > flMaxCrossDistance then
        iInnerCrossDist = iCappedCrosshairDistance
        flLineAlphaInner = alpha * flAlphaSplitInner
        flLineAlphaOuter = alpha * flAlphaSplitOuter
        iBarSizeInner = math.ceil(iBarSize * (1.0 - flSplitRatio))
        iBarSizeOuter = math.floor(iBarSize * flSplitRatio)

        -- draw horizontal crosshair lines
        local iInnerLeft = (iCenterX - iCrosshairDistance - iBarThickness / 2 + nFishTaleShift) - iBarSizeInner
        local iInnerRight = iInnerLeft + 2 * (iCrosshairDistance + iBarSizeInner) + iBarThickness + nFishTaleShift
        local iOuterLeft = iInnerLeft - iBarSizeOuter
        local iOuterRight = iInnerRight + iBarSizeOuter
        local y0 = iCenterY - iBarThickness / 2
        local y1 = y0 + iBarThickness
        DrawCrosshairRect(r, g, b, flLineAlphaOuter, iOuterLeft, y0, iInnerLeft, y1, bAdditive)
        DrawCrosshairRect(r, g, b, flLineAlphaOuter, iInnerRight, y0, iOuterRight, y1, bAdditive)

        -- draw vertical crosshair lines
        local iInnerTop = (iCenterY - iCrosshairDistance - iBarThickness / 2) - iBarSizeInner
        local iInnerBottom = iInnerTop + 2 * (iCrosshairDistance + iBarSizeInner) + iBarThickness
        local iOuterTop = iInnerTop - iBarSizeOuter
        local iOuterBottom = iInnerBottom + iBarSizeOuter
        local x0 = iCenterX - iBarThickness / 2
        local x1 = x0 + iBarThickness
        if not cl_crosshair_t:GetBool() then DrawCrosshairRect(r, g, b, flLineAlphaOuter, x0, iOuterTop, x1, iInnerTop, bAdditive) end
        DrawCrosshairRect(r, g, b, flLineAlphaOuter, x0, iInnerBottom, x1, iOuterBottom, bAdditive)
    end

    -- draw horizontal crosshair lines
    local iInnerLeft = iCenterX - iInnerCrossDist - (iBarThickness / 2) + nFishTaleShift
    local iInnerRight = iInnerLeft + (2 * iInnerCrossDist) + iBarThickness + nFishTaleShift
    local iOuterLeft = iInnerLeft - iBarSizeInner
    local iOuterRight = iInnerRight + iBarSizeInner
    local y0 = iCenterY - (iBarThickness / 2)
    local y1 = y0 + iBarThickness
    DrawCrosshairRect(r, g, b, flLineAlphaInner, iOuterLeft, y0, iInnerLeft, y1, bAdditive)
    DrawCrosshairRect(r, g, b, flLineAlphaInner, iInnerRight, y0, iOuterRight, y1, bAdditive)

    -- draw vertical crosshair lines
    local iInnerTop = iCenterY - iInnerCrossDist - (iBarThickness / 2)
    local iInnerBottom = iInnerTop + (2 * iInnerCrossDist) + iBarThickness
    local iOuterTop = iInnerTop - iBarSizeInner
    local iOuterBottom = iInnerBottom + iBarSizeInner
    local x0 = iCenterX - (iBarThickness / 2)
    local x1 = x0 + iBarThickness
    if not cl_crosshair_t:GetBool() then DrawCrosshairRect(r, g, b, flLineAlphaInner, x0, iOuterTop, x1, iInnerTop, bAdditive) end
    DrawCrosshairRect(r, g, b, flLineAlphaInner, x0, iInnerBottom, x1, iOuterBottom, bAdditive)

    -- draw dot
    if cl_crosshairdot:GetBool() then
        local x0 = iCenterX - iBarThickness / 2
        local x1 = x0 + iBarThickness
        local y0 = iCenterY - iBarThickness / 2
        local y1 = y0 + iBarThickness
        DrawCrosshairRect(r, g, b, alpha, x0, y0, x1, y1, bAdditive)
    end

    if weapon_debug_spread_show:GetInt() == 1 then
        r, g, b = 250, 250, 50
        iBarThickness = math.max(1, math.floor(YRES( cl_crosshairthickness:GetFloat() )))

        iInnerLeft	= iCenterX - iSpreadDistance
        iInnerRight	= iCenterX + iSpreadDistance
        iOuterLeft	= iInnerLeft - iBarThickness
        iOuterRight	= iInnerRight + iBarThickness
        iInnerTop		= iCenterY - iSpreadDistance
        iInnerBottom	= iCenterY + iSpreadDistance
        iOuterTop		= iInnerTop - iBarThickness
        iOuterBottom	= iInnerBottom + iBarThickness

        local iGap = math.floor( weapon_debug_spread_gap:GetFloat() * iSpreadDistance )

        -- draw horizontal lines
        DrawCrosshairRect( r, g, b, alpha, iOuterLeft, iOuterTop, iCenterX - iGap, iInnerTop, bAdditive )
        DrawCrosshairRect( r, g, b, alpha, iCenterX + iGap, iOuterTop, iOuterRight, iInnerTop, bAdditive )
        DrawCrosshairRect( r, g, b, alpha, iOuterLeft, iInnerBottom, iCenterX - iGap, iOuterBottom, bAdditive )
        DrawCrosshairRect( r, g, b, alpha, iCenterX + iGap, iInnerBottom, iOuterRight, iOuterBottom, bAdditive )

        -- draw vertical lines
        DrawCrosshairRect( r, g, b, alpha, iOuterLeft, iOuterTop, iInnerLeft, iCenterY - iGap, bAdditive )
        DrawCrosshairRect( r, g, b, alpha, iOuterLeft, iCenterY + iGap, iInnerLeft, iOuterBottom, bAdditive )
        DrawCrosshairRect( r, g, b, alpha, iInnerRight, iOuterTop, iOuterRight, iCenterY - iGap, bAdditive )
        DrawCrosshairRect( r, g, b, alpha, iInnerRight, iCenterY + iGap, iOuterRight, iOuterBottom, bAdditive )
    end

    return true
end
function SWEP:DoDrawCrosshair() return true end
