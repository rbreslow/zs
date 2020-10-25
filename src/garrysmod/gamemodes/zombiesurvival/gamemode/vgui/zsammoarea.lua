local PANEL = {}

function PANEL:Init()
    self.AmmoInClip = vgui.Create("DLabel", self)
    self.AmmoInClip:SetFont("ZSHUDFontBig")
    self.AmmoInClip:Dock(LEFT)
    self.AmmoInClip:SetTextColor(Color(245, 245, 245, 255))
    self.AmmoInClip:SetExpensiveShadow(2, Color(0, 0, 0, 100))
    self.AmmoInClip:SetText("")
    self.AmmoInClip:SetContentAlignment(9)
    self.AmmoInClip:SetPaintedManually(true)

    self.AmmoRemaining = vgui.Create("DLabel", self)
    self.AmmoRemaining:SetFont("ZSHUDFont")
    self.AmmoRemaining:Dock(LEFT)
    self.AmmoRemaining:SetTextColor(Color(245, 245, 245, 255))
    self.AmmoRemaining:SetExpensiveShadow(2, Color(0, 0, 0, 100))
    self.AmmoRemaining:SetText("")
    self.AmmoRemaining:SetContentAlignment(4)
    self.AmmoRemaining:SetPaintedManually(true)

    self:ParentToHUD()
    self:InvalidateLayout()
end

function PANEL:PerformLayout()
    local screenscale = BetterScreenScale()

    self:SetSize(screenscale * 224, screenscale * 72)

    local w, h = self:GetSize()
    self.AmmoInClip:SetSize(w / 2, h)
    self.AmmoRemaining:SetSize(w / 2, h)

    self:AlignRight(screenscale * 72)
    self:AlignBottom(screenscale * 36)
end

local gradient = {
    {offset = 0, color = Color(0, 0, 0, 0)},
    {offset = 0.4, color = Color(0, 0, 0, 100)},
    {offset = 0.8, color = Color(0, 0, 0, 100)},
    {offset = 1, color = Color(0, 0, 0, 0)}
}

function PANEL:Paint(w, h)
    local wep = MySelf:GetActiveWeapon()

    local AmmoInClip = -1
    local AmmoRemaining = -1

    if wep.CustomAmmoDisplay and wep:CustomAmmoDisplay() ~= nil then
        local t = wep:CustomAmmoDisplay()

        if not t or not t.Draw then return end
        
        AmmoInClip = t.PrimaryClip
        AmmoRemaining = t.PrimaryAmmo
    elseif wep.GetPrimaryAmmoType ~= nil and wep:GetPrimaryAmmoType() ~= -1 then
        AmmoInClip = wep:Clip1()
        AmmoRemaining = MySelf:GetAmmoCount(wep:GetPrimaryAmmoType())
    end

    if AmmoInClip ~= -1 and AmmoRemaining ~= -1 then
        -- draw.LinearGradient doesn't follow screen coordinates
        local x, y = self:LocalToScreen(0, 0)
        draw.LinearGradient(x, y, w, h, gradient, true)

        self.AmmoInClip:SetText(AmmoInClip)
        self.AmmoInClip:PaintManual()

        self.AmmoRemaining:SetText(string.format("/ %d", AmmoRemaining))
        self.AmmoRemaining:PaintManual()
    end
end

PANEL.AllowAutoRefresh = true

derma.DefineControl("ZSAmmoArea", "",  PANEL, "Panel")
