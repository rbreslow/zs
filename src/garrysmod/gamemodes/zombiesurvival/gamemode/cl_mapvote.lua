GM.MapVote = GM.MapVote or {}

function GM.MapVote:Show()
    if not self.Active then return end

    GAMEMODE.MapVote.Panel = vgui.Create("ZSMapVote")
    GAMEMODE.MapVote.Panel:SetEndsAt(self.EndsAt)
    GAMEMODE.MapVote.Panel:SetMaps(self.Maps)

    GAMEMODE.MapVote.Panel:SetWide(math.min(974, ScrW() * 0.65) * math.max(1, BetterScreenScale()))
    GAMEMODE.MapVote.Panel:Center()

    GAMEMODE.MapVote.Panel:MakePopup()
end

function GM.MapVote:Vote(vote)
    net.Start("zs_mapvote_vote")
    net.WriteUInt(vote - 1, 3)
    net.SendToServer()
end

net.Receive("zs_mapvote_start", function(length)
    GAMEMODE.MapVote.Active = true
    GAMEMODE.MapVote.EndsAt = net.ReadUInt(16)
    GAMEMODE.MapVote.Maps = net.ReadTable()

    -- If the round is over, we want to delegate displaying the panel to the
    -- GM:EndRound function so that we can ensure the panel appears ontop of the
    -- end board.
    if not GAMEMODE.RoundEnded then
        GAMEMODE.MapVote:Show()
    end
end)

net.Receive("zs_mapvote_winner", function(length)
    -- Check if valid in case someone exited out of the DFrame
    if IsValid(GAMEMODE.MapVote.Panel) then
        GAMEMODE.MapVote.Panel:Winner(net.ReadUInt(3) + 1)
    end
end)
