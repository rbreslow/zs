local ScoreBoard
function GM:ScoreboardShow()
    gui.EnableScreenClicker(true)
    PlayMenuOpenSound()

    if not ScoreBoard then
        ScoreBoard = vgui.Create("ZSScoreBoard")
    end

    local screenscale = BetterScreenScale()

    ScoreBoard:SetSize(math.min(974, ScrW() * 0.65) * math.max(1, screenscale), ScrH() * 0.75)
    ScoreBoard:Center()
    ScoreBoard:SetAlpha(0)
    ScoreBoard:AlphaTo(255, 0.15, 0)
    ScoreBoard:SetVisible(true)
end

function GM:ScoreboardRebuild()
    self:ScoreboardHide()
    ScoreBoard = nil
end

function GM:ScoreboardHide()
    gui.EnableScreenClicker(false)

    if ScoreBoard then
        PlayMenuCloseSound()
        ScoreBoard:SetVisible(false)
    end
end

local PANEL = {}

PANEL.RefreshTime = 2
PANEL.NextRefresh = 0

function PANEL:Init()
    self.NextRefresh = RealTime() + 0.1

    self.m_Header = vgui.Create("Panel", self)
    self.m_Header:Dock(TOP)
    self.m_Header:DockPadding(16, 0, 16, 0)

    self.m_Header.Paint = function(self, w, h)
        surface.SetDrawColor(5, 5, 5, 220)
        PaintGenericFrame(self, 0, 0, w, h, 32)
    end

    self.m_TitleLabel = vgui.Create("DLabel", self.m_Header)
    self.m_TitleLabel:SetFont("ZSScoreBoardSubTitle")
    self.m_TitleLabel:SetText(string.format("%s | %s", GAMEMODE.Name, translate.Get(game.GetMap())))
    self.m_TitleLabel:SetTextColor(COLOR_GRAY)
    self.m_TitleLabel:Dock(LEFT)
    self.m_TitleLabel:SetContentAlignment(5)
    self.m_TitleLabel:SizeToContents()

    self.MapChangesLabel = vgui.Create("DLabel", self.m_Header)
    self.MapChangesLabel:SetFont("ZSScoreBoardSubTitle")
    self.MapChangesLabel:SetTextColor(COLOR_GRAY)
    self.MapChangesLabel:Dock(RIGHT)
    self.MapChangesLabel:SetContentAlignment(5)
    self.MapChangesLabel:SizeToContents()

    local texRightEdge = surface.GetTextureID("gui/gradient")
    local texCorner = surface.GetTextureID("zombiesurvival/circlegradient")
    local texDownEdge = surface.GetTextureID("gui/gradient_down")

    self.grid = vgui.Create("ZSGrid", self)
    self.grid:Dock(FILL)
    self.grid:SetColumns(2)
    self.grid:SetHorizontalMargin(16 * BetterScreenScale())
    self.grid:SetVerticalMargin(16 * BetterScreenScale())

    self.grid:SetZPos(-1)
    self.grid.Paint = function(self, w, h)
        surface.SetDrawColor(5, 5, 5, 180)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(90, 90, 90, 180)
        self:DrawOutlinedRect()

        local barw = 64
        surface.SetDrawColor(5, 5, 5, 160)
        surface.DrawRect(w * 0.5 - 16, 0, 32, h - 64)
        surface.SetTexture(texRightEdge)
        surface.DrawTexturedRect(w * 0.5 + 16, 0, barw, h - 64)
        surface.DrawTexturedRectRotated(w * 0.5 - 16 - barw / 2, (h - 64) / 2, barw, h - 64, 180)
        surface.SetTexture(texCorner)
        surface.DrawTexturedRectRotated(w * 0.5 - 16 - barw / 2, h - 32, barw, 64, 90)
        surface.DrawTexturedRectRotated(w * 0.5 + 16 + barw / 2, h - 32, barw, 64, 180)
        surface.SetTexture(texDownEdge)
        surface.DrawTexturedRect(w * 0.5 - 16, h - 64, 32, 64)
    end

    self.humanContainer = vgui.Create("Panel")
    self.grid:AddCell(self.humanContainer)

    self.m_HumanHeading = vgui.Create("DTeamHeading", self.humanContainer)
    self.m_HumanHeading:SetTeam(TEAM_HUMAN)
    self.m_HumanHeading:Dock(TOP)
    self.m_HumanHeading:DockMargin(0, 0, 8, 0)

    self.humanColumnNames = vgui.Create("ZSPlayerPanelHeader", self.humanContainer)
    self.humanColumnNames:Dock(TOP)
    self.humanColumnNames:DockMargin(0, 0, 8, 0)

    self.HumanList = vgui.Create("DScrollPanel", self.humanContainer)
    self.HumanList:Dock(FILL)
    self.HumanList:DockMargin(0, 0, 8, 0)

    self.zombieContainer = vgui.Create("Panel")
    self.grid:AddCell(self.zombieContainer)

    self.m_ZombieHeading = vgui.Create("DTeamHeading", self.zombieContainer)
    self.m_ZombieHeading:SetTeam(TEAM_UNDEAD)
    self.m_ZombieHeading:Dock(TOP)
    self.m_ZombieHeading:DockMargin(8, 0, 0, 0)

    self.zombieColumnNames = vgui.Create("ZSPlayerPanelHeader", self.zombieContainer)
    self.zombieColumnNames:Dock(TOP)
    self.zombieColumnNames:DockMargin(8, 0, 0, 0)
    self.zombieColumnNames:SetTeam(TEAM_UNDEAD)

    self.ZombieList = vgui.Create("DScrollPanel", self.zombieContainer)
    self.ZombieList:Dock(FILL)
    self.ZombieList:DockMargin(8, 0, 0, 0)

    self:InvalidateLayout()
end

function PANEL:PerformLayout(w, h)
    local screenscale = math.max(0.95, BetterScreenScale())
    self.m_Header:SetSize(w, 32)
    self.grid:SetRowHeight(h - 32 - self.grid:GetVerticalMargin() * 1.5)
end

function PANEL:Think()
    if RealTime() >= self.NextRefresh then
        self.NextRefresh = RealTime() + self.RefreshTime
        self:RefreshScoreboard()
    end
end

function PANEL:GetPlayerPanel(pl)
    for _, panel in pairs(self.PlayerPanels) do
        if panel:IsValid() and panel:GetPlayer() == pl then
            return panel
        end
    end
end

function PANEL:CreatePlayerPanel(pl)
    local curpan = self:GetPlayerPanel(pl)
    if curpan and curpan:IsValid() then return curpan end

    if pl:Team() == TEAM_SPECTATOR then return end

    local parent = pl:Team() == TEAM_UNDEAD and self.ZombieList or self.HumanList
    local panel = vgui.Create("ZSPlayerPanel", parent)
    panel:SetPlayer(pl)
    panel:Dock(TOP)

    self.PlayerPanels[pl] = panel

    return panel
end

function PANEL:RefreshScoreboard()
    local roundsLeft = GAMEMODE.RoundLimit - GAMEMODE.CurrentRound
    local timeLeft = util.ToMinutesSecondsCD(math.max(0, GAMEMODE.TimeLimit - CurTime()))
    self.MapChangesLabel:SetText(translate.Format("map_changes_in_or_in", roundsLeft, timeLeft))
    self.MapChangesLabel:SizeToContents()

    if self.PlayerPanels == nil then self.PlayerPanels = {} end

    for pl, panel in pairs(self.PlayerPanels) do
        if not panel:IsValid() or pl:IsValid() and pl:IsSpectator() then
            self:RemovePlayerPanel(panel)
        end
    end

    for _, pl in pairs(player.GetAllActive()) do
        self:CreatePlayerPanel(pl)
    end
end

function PANEL:RemovePlayerPanel(panel)
    if panel:IsValid() then
        self.PlayerPanels[panel:GetPlayer()] = nil
        panel:Remove()
    end
end

vgui.Register("ZSScoreBoard", PANEL, "Panel")

PANEL = {}

function PANEL:Init()
    local screenscale = math.max(0.95, BetterScreenScale())

    self.m_SpecialImageContainer = vgui.Create("Panel", self)
    self.m_SpecialImageContainer:Dock(LEFT)
    self.m_SpecialImageContainer:SetWide(20)

    self.m_AvatarButtonContainer = vgui.Create("Panel", self)
    self.m_AvatarButtonContainer:Dock(LEFT)
    self.m_AvatarButtonContainer:SetWide(32 * screenscale)

    self.m_PlayerLabelContainer = vgui.Create("Panel", self)
    self.m_PlayerLabelContainer:Dock(FILL)
    self.m_PlayerLabelContainer:DockMargin(4, 0, 0, 0)

    self.m_PingMeterContainer = vgui.Create("Panel", self)
    self.m_PingMeterContainer:Dock(RIGHT)
    self.m_PingMeterContainer:SetWide((32 * screenscale) - 4)

    self.m_MuteContainer = vgui.Create("Panel", self)
    self.m_MuteContainer:SetWide(24)
    self.m_MuteContainer:Dock(RIGHT)

    self.m_FriendContainer = vgui.Create("Panel", self)
    self.m_FriendContainer:Dock(RIGHT)
    self.m_FriendContainer:SetWide(24)

    self.m_ClassImageContainer = vgui.Create("Panel", self)
    self.m_ClassImageContainer:Dock(RIGHT)
    self.m_ClassImageContainer:SetWide(22 * screenscale)

    self.m_RemortLabel = EasyLabel(self, "Remort", "ZSScoreBoardPlayer", COLOR_WHITE)
    self.m_RemortLabel:Dock(RIGHT)
    self.m_RemortLabel:SetWide(50)
    self.m_RemortLabel:SetContentAlignment(4)

    self.m_ScoreLabel = EasyLabel(self, "Score", "ZSScoreBoardPlayer", COLOR_WHITE)
    self.m_ScoreLabel:Dock(RIGHT)
    self.m_ScoreLabel:SetWide(50)
    self.m_ScoreLabel:SetContentAlignment(4)
end

function PANEL:SetTeam(team)
    if team == TEAM_UNDEAD then
        self.m_ScoreLabel:SetText("Brains")
    end
end

vgui.Register("ZSPlayerPanelHeader", PANEL, "Panel")

PANEL = {}

PANEL.RefreshTime = 1

PANEL.m_Player = NULL
PANEL.NextRefresh = 0

local function MuteDoClick(self)
    local pl = self:GetParent():GetParent():GetPlayer()
    if pl:IsValid() then
        pl:SetMuted(not pl:IsMuted())
        self:GetParent().NextRefresh = RealTime()
    end
end

GM.ZSFriends = {}

local function ToggleZSFriend(self)
    if MySelf.LastFriendAdd and MySelf.LastFriendAdd + 2 > CurTime() then return end

    local pl = self:GetParent():GetParent():GetPlayer()
    if pl:IsValid() then
        if GAMEMODE.ZSFriends[pl:SteamID()] then
            GAMEMODE.ZSFriends[pl:SteamID()] = nil
        else
            GAMEMODE.ZSFriends[pl:SteamID()] = true
        end

        self:GetParent().NextRefresh = RealTime()

        net.Start("zs_zsfriend")
        net.WriteString(pl:SteamID())
        net.WriteBool(GAMEMODE.ZSFriends[pl:SteamID()])
        net.SendToServer()

        MySelf.LastFriendAdd = CurTime()
        --file.Write(GAMEMODE.FriendsFile, Serialize(GAMEMODE.ZSFriends))
    end
end

net.Receive("zs_zsfriendadded", function()
    local pl = net:ReadEntity()
    pl.ZSFriendAdded = net:ReadBool()
end)

local function AvatarDoClick(self)
    local pl = self.PlayerPanel:GetPlayer()
    if pl:IsValidPlayer() then
        pl:ShowProfile()
    end
end

function PANEL:Init()
    local screenscale = math.max(0.95, BetterScreenScale())
    self:SetTall(32 * screenscale)

    self.m_SpecialImageContainer = vgui.Create("Panel", self)
    self.m_SpecialImageContainer:Dock(LEFT)
    self.m_SpecialImageContainer:SetWide(20)

    self.m_SpecialImage = vgui.Create("DImage", self.m_SpecialImageContainer)
    self.m_SpecialImage:SetSize(16, 16)
    self.m_SpecialImage:SetMouseInputEnabled(true)
    self.m_SpecialImage:SetVisible(false)

    self.m_AvatarButton = self:Add("DButton", self)
    self.m_AvatarButton:Dock(LEFT)
    self.m_AvatarButton:SetSize(32 * screenscale, 32 * screenscale)
    self.m_AvatarButton:SetText("")
    self.m_AvatarButton:Center()
    self.m_AvatarButton.DoClick = AvatarDoClick
    self.m_AvatarButton.Paint = function() end
    self.m_AvatarButton.PlayerPanel = self

    self.m_Avatar = vgui.Create("AvatarImage", self.m_AvatarButton)
    self.m_Avatar:SetSize(32 * screenscale, 32 * screenscale)
    self.m_Avatar:SetVisible(false)
    self.m_Avatar:SetMouseInputEnabled(false)

    self.m_PlayerLabel = EasyLabel(self, " ", "ZSScoreBoardPlayer", COLOR_WHITE)
    self.m_PlayerLabel:Dock(FILL)
    self.m_PlayerLabel:DockMargin(4, 0, 0, 0)

    self.m_PingMeterContainer = vgui.Create("Panel", self)
    self.m_PingMeterContainer:Dock(RIGHT)
    self.m_PingMeterContainer:SetWide(self:GetTall() - 4)

    self.m_PingMeter = vgui.Create("DPingMeter", self.m_PingMeterContainer)
    self.m_PingMeter:SetSize(self:GetTall() - 4, self:GetTall() - 4)
    self.m_PingMeter.PingBars = 5

    self.m_MuteContainer = vgui.Create("Panel", self)
    self.m_MuteContainer:Dock(RIGHT)
    self.m_MuteContainer:SetWide(24)

    self.m_Mute = vgui.Create("DImageButton", self.m_MuteContainer)
    self.m_Mute:SetSize(16, 16)
    self.m_Mute.DoClick = MuteDoClick

    self.m_FriendContainer = vgui.Create("Panel", self)
    self.m_FriendContainer:Dock(RIGHT)
    self.m_FriendContainer:SetWide(24)

    self.m_Friend = vgui.Create("DImageButton", self.m_FriendContainer)
    self.m_Friend:SetSize(16, 16)
    self.m_Friend.DoClick = ToggleZSFriend

    self.m_ClassImageContainer = vgui.Create("Panel", self)
    self.m_ClassImageContainer:Dock(RIGHT)
    self.m_ClassImageContainer:SetWide(22 * screenscale)

    self.m_ClassImage = vgui.Create("DImage", self.m_ClassImageContainer)
    self.m_ClassImage:SetSize(22 * screenscale, 22 * screenscale)
    self.m_ClassImage:SetMouseInputEnabled(false)
    self.m_ClassImage:SetVisible(false)

    self.m_RemortLabel = EasyLabel(self, " ", "ZSScoreBoardPlayerSmaller", COLOR_WHITE)
    self.m_RemortLabel:Dock(RIGHT)
    self.m_RemortLabel:SetWide(50)
    self.m_RemortLabel:SetContentAlignment(5)

    self.m_ScoreLabel = EasyLabel(self, " ", "ZSScoreBoardPlayerSmall", COLOR_WHITE)
    self.m_ScoreLabel:Dock(RIGHT)
    self.m_ScoreLabel:SetWide(50)
    self.m_ScoreLabel:SetContentAlignment(5)
end

local colTemp = Color(255, 255, 255, 200)
function PANEL:Paint()
    local col = color_black_alpha220
    local mul = 0.5
    local pl = self:GetPlayer()
    if pl:IsValid() then
        col = team.GetColor(pl:Team())

        if self.m_Flash then
            mul = 0.6 + math.abs(math.sin(RealTime() * 6)) * 0.4
        elseif pl == MySelf then
            mul = 0.8
        end
    end

    if self.Hovered then
        mul = math.min(1, mul * 1.5)
    end

    colTemp.r = col.r * mul
    colTemp.g = col.g * mul
    colTemp.b = col.b * mul
    draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(), colTemp)

    return true
end

function PANEL:DoClick()
    local pl = self:GetPlayer()
    if pl:IsValid() then
        gamemode.Call("ClickedPlayerButton", pl, self)
    end
end

function PANEL:PerformLayout()
    self.m_SpecialImage:Center()
    self.m_Friend:Center()
    self.m_PingMeter:Center()
    self.m_Mute:Center()
    self.m_ClassImage:Center()

    if self:GetParent():GetParent().VBar.Enabled then
        self:DockMargin(0, 2, 8, 2)
    else
        self:DockMargin(0, 2, 0, 2)
    end
end

function PANEL:RefreshPlayer()
    local pl = self:GetPlayer()
    if not pl:IsValid() then
        self:Remove()
        return
    end

    local name = pl:Name()
    if #name > 23 then
        name = string.sub(name, 1, 21)..".."
    end
    self.m_PlayerLabel:SetText(name)
    self.m_PlayerLabel:SetAlpha(240)

    self.m_ScoreLabel:SetText(pl:Frags())
    self.m_ScoreLabel:SetAlpha(240)

    local rlvl = pl:GetZSRemortLevel()
    self.m_RemortLabel:SetText(rlvl > 0 and rlvl or "")

    local rlvlmod = math.floor((rlvl % 40) / 4)
    local hcolor, hlvl = COLOR_GRAY, 0
    for rlvlr, rcolor in pairs(GAMEMODE.RemortColors) do
        if rlvlmod >= rlvlr and rlvlr >= hlvl then
            hlvl = rlvlr
            hcolor = rcolor
        end
    end
    self.m_RemortLabel:SetColor(hcolor)
    self.m_RemortLabel:SetAlpha(240)

    if MySelf:Team() == TEAM_UNDEAD and pl:Team() == TEAM_UNDEAD and pl:GetZombieClassTable().Icon then
        self.m_ClassImage:SetVisible(true)
        self.m_ClassImage:SetImage(pl:GetZombieClassTable().Icon)
        self.m_ClassImage:SetImageColor(pl:GetZombieClassTable().IconColor or color_white)
    else
        self.m_ClassImage:SetVisible(false)
    end

    if pl == MySelf then
        self.m_Mute:SetVisible(false)
        self.m_Friend:SetVisible(false)
    else
        if pl:IsMuted() then
            self.m_Mute:SetImage("icon16/sound_mute.png")
        else
            self.m_Mute:SetImage("icon16/sound.png")
        end

        self.m_Friend:SetColor(pl.ZSFriendAdded and COLOR_LIMEGREEN or COLOR_GRAY)
        self.m_Friend:SetImage(GAMEMODE.ZSFriends[pl:SteamID()] and "icon16/heart_delete.png" or "icon16/heart.png")
    end

    self:SetZPos(-pl:Frags())

    if pl:Team() ~= self._LastTeam then
        self._LastTeam = pl:Team()
        self:SetParent(self._LastTeam == TEAM_HUMAN and ScoreBoard.HumanList or ScoreBoard.ZombieList)
    end

    self:InvalidateLayout()
end

function PANEL:Think()
    if RealTime() >= self.NextRefresh then
        self.NextRefresh = RealTime() + self.RefreshTime
        self:RefreshPlayer()
    end
end

function PANEL:SetPlayer(pl)
    self.m_Player = pl or NULL

    if pl:IsValidPlayer() then
        self.m_Avatar:SetPlayer(pl)
        self.m_Avatar:SetVisible(true)

        if gamemode.Call("IsSpecialPerson", pl, self.m_SpecialImage) then
            self.m_SpecialImage:SetVisible(true)
        else
            self.m_SpecialImage:SetTooltip()
            self.m_SpecialImage:SetVisible(false)
        end
    else
        self.m_Avatar:SetVisible(false)
        self.m_SpecialImage:SetVisible(false)
    end

    self.m_PingMeter:SetPlayer(pl)

    self:RefreshPlayer()
end

function PANEL:GetPlayer()
    return self.m_Player
end

vgui.Register("ZSPlayerPanel", PANEL, "Button")
