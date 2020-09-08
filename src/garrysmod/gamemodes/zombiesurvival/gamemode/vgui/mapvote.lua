local PANEL = {}

AccessorFunc(PANEL, "title", "Title", FORCE_STRING)
AccessorFunc(PANEL, "image", "Image", FORCE_STRING)
AccessorFunc(PANEL, "group", "Group")
AccessorFunc(PANEL, "checked", "Checked", FORCE_BOOL)

function PANEL:Init()
    self.anim = {}
    self.anim.scale = 1
    self.anim.scaleTo = 1

    self.image = vgui.Create("DImage", self)
    self.image:SetTall(160 * BetterScreenScale())
    self.image:SetKeepAspect(true)
    self.image:SetPaintedManually(true)

    self.title = vgui.Create("DLabel", self)
    self.title:Dock(BOTTOM)
    self.title:DockMargin(8 * BetterScreenScale(), -8 * BetterScreenScale(), 8 * BetterScreenScale(), 0)
    self.title:SetFont("ZSHUDFontSmall")
    self.title:SetPaintedManually(true)
    self.title:SetContentAlignment(5)
    
    self:SizeToChildren(false, true)
end

function PANEL:SetTitle(title)
    self.title:SetText(title)
    self.title:SizeToContents()
end

function PANEL:SetImage(image)
    self.image:SetImage(image)
end

function PANEL:SetWide(wide)
    self.BaseClass.SetWide(self, wide)
    self.image:SetWide(wide)
end

function PANEL:Winner()
    self.flash = true
    surface.PlaySound("hl1/fvox/blip.wav")
    timer.Simple(0.2, function() self.flash = false end)

    timer.Create("zs_mapvote_winner_sound", 0.4, 2, function() 
        self.flash = true
        timer.Simple(0.2, function() self.flash = false end)
        surface.PlaySound("hl1/fvox/blip.wav") 
    end)
end

function PANEL:GrabAnim()
    self.anim.scaleTo = 1.05
end

function PANEL:ReleaseAnim()
    self.anim.scaleTo = 1
end

function PANEL:OnCursorEntered()
    self:GrabAnim()
end

function PANEL:OnCursorExited()
    self:ReleaseAnim()
end

function PANEL:OnMouseReleased(code)
    surface.PlaySound("buttons/button17.wav")
    
    self:SetChecked(true)
    self:ReleaseAnim()
    
    if code == MOUSE_LEFT then
        local group = self:GetGroup()
        for i=1,#group do
            if group[i] == self then
                GAMEMODE.MapVote:Vote(i)
            else
                group[i]:SetChecked(false)
            end
        end
    end
end

function PANEL:Paint(w, h)
    self.anim.scale = Lerp(FrameTime() * 12, self.anim.scale, self.anim.scaleTo)
    
    local mat = Matrix()
    
    local x,y = self:LocalToScreen(w / 2, h / 2)
    x, y = -x * (self.anim.scale - 1), -y * (self.anim.scale - 1)
    
    mat:SetTranslation(Vector(x, y, 0))
    mat:Scale(Vector(self.anim.scale, self.anim.scale, 0))
    
    cam.PushModelMatrix(mat)
    
    self.image:PaintManual()
    self.title:PaintManual()
    
    if self.flash ~= nil then
        if self.flash then
            surface.SetDrawColor(COLOR_YELLOW)
            self:DrawOutlinedRect()
        end
    end
    
    if self:GetChecked() then
        self:DrawOutlinedRect()
    end
    
    cam.PopModelMatrix()
end

function PANEL:PerformLayout()
    self.BaseClass.PerformLayout(self)
end

PANEL.AllowAutoRefresh = true

derma.DefineControl("ZSMapVote_Element", "", PANEL, "DPanel")

local PANEL = {}

AccessorFunc(PANEL, "endsAt", "EndsAt", FORCE_NUMBER)
AccessorFunc(PANEL, "maps", "Maps")

function PANEL:Init()
    self:SetTitle("")
    
    self.header = vgui.Create("ZSGrid", self)
    self.header:Dock(TOP)
    self.header:SetColumns(2)
    self.header:SetHorizontalMargin(8 * BetterScreenScale())
    self.header:SetVerticalMargin(8 * BetterScreenScale())
    
    self.title = vgui.Create("DLabel")
    self.title:SetFont("ZSHUDFont")
    self.title:SetText(translate.Get("vote_for_the_next_map"))
    self.title:SizeToContents()
    self.header:AddCell(self.title)
    
    -- The first container will be sized to half the width of the grid, the
    -- second container we can size to the text and align to the right of the
    -- first container
    self.countdown2 = vgui.Create("Panel")
    self.header:AddCell(self.countdown2)
    
    self.countdown = vgui.Create("Panel", self.countdown2)
    self.countdown:Dock(RIGHT)
    
    self.subtitle = vgui.Create("DLabel", self.countdown)
    self.subtitle:SetFont("ZSHUDFontSmall")
    self.subtitle:SetText(translate.Get("map_vote_ends_in") .. " ")
    self.subtitle:SizeToContents()
    self.subtitle:Dock(LEFT)
    
    self.timer = vgui.Create("DLabel", self.countdown)
    self.timer:SetFont("ZSHUDFont")
    self.timer:SetText("00:30")
    self.timer:SizeToContents()
    self.timer:Dock(RIGHT)
    
    self.countdown:SetWide(self.subtitle:GetWide() + self.timer:GetWide())
    
    self.grid = vgui.Create("ZSGrid", self)
    self.grid:SetColumns(4)
    self.grid:SetHorizontalMargin(8 * BetterScreenScale())
    self.grid:SetVerticalMargin(8 * BetterScreenScale())
end

function PANEL:Winner(winner)
    self.group[winner]:Winner()
end

function PANEL:SetMaps(maps)
    self.maps = maps
    
    self.group = {}
    
    for _,v in ipairs(maps) do
        local map = vgui.Create("ZSMapVote_Element")
        
        map:SetTitle(translate.Get(v))
        map:SetImage(string.format("zombiesurvival/maps/%s.jpg", v))
        map:SetGroup(self.group)
        
        self.grid:AddCell(map)
        table.insert(self.group, map)
    end
end

function PANEL:Think()
    if self.endsAt then
        self.timer:SetText(util.ToMinutesSecondsCD(math.max(0, self.endsAt - CurTime())))
    end
end

function PANEL:PerformLayout(w, h)
    local _,height = self:GetDockPadding()
    
    for _,v in ipairs(self:GetChildren()) do
        if v:GetName() == "ZSGrid" then
            v:InvalidateLayout(true)
            height = height + v:GetTall()
        end
    end
    
    self:SetTall(height)
    self.BaseClass.PerformLayout(self, w, h)
end

PANEL.AllowAutoRefresh = true

derma.DefineControl("ZSMapVote", "", PANEL, "DFrame")
