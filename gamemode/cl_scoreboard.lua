--[[
* Custom Scoreboard
* @author Rhys Evans
* @version 24/06/2017
]]

local Scoreboard = nil
local RedPlayerList = nil
local BluePlayerList = nil
local TitlePanel = nil
local PlayerScrollPanel = nil

local COLOR_RED = Color(255, 51, 51, 200)
local COLOR_BLUE = Color(0, 102, 255, 200)

function createTitle()
  TitlePanel = vgui.Create("DPanel", Scoreboard)
  TitlePanel:SetSize(Scoreboard:GetWide(), 50)
  TitlePanel:SetPos(0, 0)
  TitlePanel.Paint = function()
    draw.RoundedBox(0, 0, 0, TitlePanel:GetWide(), TitlePanel:GetTall(), Color(70, 70, 70, 200))
    draw.SimpleText("Gmod Paintball - v"..VERSION, "HudHintTextLarge", 10, 5, Color(255, 255, 255, 255))
    draw.SimpleText("Map: "..game.GetMap(), "HudHintTextLarge", 10, 25, Color(255, 255, 255, 255))
    draw.SimpleText("Spectators: " ..team.NumPlayers(TEAM_SPEC), "HudHintTextLarge", TitlePanel:GetWide() - 120, 5, Color(255, 255, 255, 255))
  end

  local SpecJoinButton = vgui.Create("DButton", TitlePanel)
  SpecJoinButton:SetPos(TitlePanel:GetWide() - 100, 25)
  SpecJoinButton:SetSize(61,20)
  SpecJoinButton:SetText("Spectate")
  SpecJoinButton.Paint = function()
    draw.RoundedBox(0, 0, 0, SpecJoinButton:GetWide(), SpecJoinButton:GetTall(), Color(255, 255, 255, 100))
  end
  SpecJoinButton.DoClick = function()
    RunConsoleCommand("team_spec")
  end
end

function toggleTitle(bool)
  if(!IsValid(TitlePanel)) then return end
  TitlePanel:SetVisible(bool)
end

function createScorePanel()
  local ScorePanel = vgui.Create("DPanel", Scoreboard)
  ScorePanel:SetSize(Scoreboard:GetWide()-100, 70)
  ScorePanel:SetPos(50, 70)
  ScorePanel.Paint = function()
    draw.RoundedBox(10, 0, 0, ScorePanel:GetWide()/2-50, ScorePanel:GetTall(), COLOR_RED)
    draw.SimpleText("RED", "DermaLarge", 10, 19, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
    draw.SimpleText(team.GetScore(TEAM_RED), "DermaLarge", ScorePanel:GetWide()/2 - 100, 19, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)

    draw.RoundedBox(10, ScorePanel:GetWide()/2 + 50, 0, ScorePanel:GetWide()/2 - 50, ScorePanel:GetTall(), COLOR_BLUE, TEXT_ALIGN_CENTER)
    draw.SimpleText("BLUE", "DermaLarge", ScorePanel:GetWide() - 10, 19, Color(255, 255, 255, 255),TEXT_ALIGN_RIGHT)
    draw.SimpleText(team.GetScore(TEAM_BLUE), "DermaLarge", ScorePanel:GetWide()/2 + 100, 19, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
  end

  local RedJoinButton = vgui.Create("DButton", ScorePanel)
  RedJoinButton:SetPos(70, 25)
  RedJoinButton:SetSize(41, 20)
  RedJoinButton:SetText("Join")
  RedJoinButton.Paint = function()
    draw.RoundedBox(0, 0, 0, RedJoinButton:GetWide(), RedJoinButton:GetTall(), Color(255, 255, 255, 100))
  end
  RedJoinButton.DoClick = function()
    RunConsoleCommand("team_red")
  end

  local BlueJoinButton = vgui.Create("DButton", ScorePanel)
  BlueJoinButton:SetPos(ScorePanel:GetWide() - 130, 25)
  BlueJoinButton:SetSize(41, 20)
  BlueJoinButton:SetText("Join")
  BlueJoinButton.Paint = function()
    draw.RoundedBox(0, 0, 0, BlueJoinButton:GetWide(), BlueJoinButton:GetTall(), Color(255, 255, 255, 100))
  end
  BlueJoinButton.DoClick = function()
    RunConsoleCommand("team_blue")
  end
end

function createPlayerPanel(ply, team)
  local PlayerPanel = nil
  if team == TEAM_RED then
    PlayerPanel = vgui.Create("DPanel", RedPlayerList)
    PlayerPanel:SetSize(RedPlayerList:GetWide(), 40)
    PlayerPanel:SetPos(0,0)
    PlayerPanel.Paint = function()

      if(ply == LocalPlayer()) then
        draw.RoundedBox(0, PlayerPanel:GetWide() - BluePlayerList:GetWide(), 0, PlayerPanel:GetWide(), PlayerPanel:GetTall(), Color(111, 112, 109, 220))
      else
        draw.RoundedBox(0, 0, 0, PlayerPanel:GetWide(), PlayerPanel:GetTall(), Color(64, 65, 60, 220))
      end
      draw.RoundedBox(0, 0, 39, PlayerPanel:GetWide(), 10, Color(0, 0, 0, 100))

      draw.SimpleText(ply:GetName(), "DermaDefaultBold", 52, 12, Color(255, 255, 255))
      draw.SimpleText(ply:Ping(), "DermaDefaultBold", PlayerPanel:GetWide()-20, 12, Color(255, 255, 255), TEXT_ALIGN_CENTER)
      draw.SimpleText(ply:Deaths(), "DermaDefaultBold", PlayerPanel:GetWide()-70, 12, Color(255, 255, 255), TEXT_ALIGN_CENTER)
      draw.SimpleText(ply:Frags(), "DermaDefaultBold", PlayerPanel:GetWide()-120, 12, Color(255, 255, 255), TEXT_ALIGN_CENTER)

      if(!ply:Alive()) then
        draw.SimpleText("DEAD", "DermaDefaultBold", PlayerPanel:GetWide()/2, 12, Color(255, 0, 0, 200), TEXT_ALIGN_CENTER)
      end
    end
  end

  if team == TEAM_BLUE then
    PlayerPanel = vgui.Create("DPanel", BluePlayerList)
    PlayerPanel:SetSize(BluePlayerList:GetWide(), 40)
    PlayerPanel:SetPos(BluePlayerList:GetWide()/2, 0)
    PlayerPanel.Paint = function()

      if(ply == LocalPlayer()) then
        draw.RoundedBox(0, PlayerPanel:GetWide() - BluePlayerList:GetWide(), 0, PlayerPanel:GetWide(), PlayerPanel:GetTall(), Color(111, 112, 109, 220))
      else
        draw.RoundedBox(0, PlayerPanel:GetWide() - BluePlayerList:GetWide(), 0, PlayerPanel:GetWide(), PlayerPanel:GetTall(), Color(64, 65, 60, 220))
      end
      draw.RoundedBox(0, PlayerPanel:GetWide() - BluePlayerList:GetWide(), 39, PlayerPanel:GetWide(), 10, Color(0, 0, 0, 100))

      draw.SimpleText(ply:GetName(), "DermaDefaultBold", 52, 12, Color(255, 255, 255))
      draw.SimpleText(ply:Ping(), "DermaDefaultBold", PlayerPanel:GetWide()-20, 12, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
      draw.SimpleText(ply:Deaths(), "DermaDefaultBold", PlayerPanel:GetWide()-70, 12, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
      draw.SimpleText(ply:Frags(), "DermaDefaultBold", PlayerPanel:GetWide()-120, 12, Color(255, 255, 255), TEXT_ALIGN_RIGHT)

      if(!ply:Alive()) then
        draw.SimpleText("DEAD", "DermaDefaultBold", PlayerPanel:GetWide()/2, 12, Color(255, 0, 0, 200), TEXT_ALIGN_CENTER)
      end
    end
  end

  if IsValid(PlayerPanel) then
    local PlayerAvatar = vgui.Create("AvatarImage", PlayerPanel)
    PlayerAvatar:SetSize(32, 32)
    PlayerAvatar:SetPos(10, 4)
    PlayerAvatar:SetPlayer(ply, 32)
  end
end


function GM:ScoreboardShow()
  -- Create scoreboard
  if !IsValid(Scoreboard) then
    Scoreboard = vgui.Create("DFrame")
    Scoreboard:SetSize(1500, 850)
    Scoreboard:Center()
    Scoreboard:SetTitle("")
    Scoreboard:SetDraggable(false)
    Scoreboard:ShowCloseButton(false)
    Scoreboard.Paint = function()
    end

    createTitle()
    createScorePanel()

    PlayerScrollPanel = vgui.Create("DScrollPanel", Scoreboard)
    PlayerScrollPanel:SetSize(Scoreboard:GetWide(), Scoreboard:GetTall() - 20)
    PlayerScrollPanel:SetPos(0, 150)

    RedPlayerList = vgui.Create("DListLayout", PlayerScrollPanel)
    RedPlayerList:SetSize(PlayerScrollPanel:GetWide()/2-100, PlayerScrollPanel:GetTall())
    RedPlayerList:SetPos(50,0)
    RedPlayerList:MakeDroppable("PlayerPanel")
    RedPlayerList:DockPadding(0, 50, 0, 10)
    RedPlayerList.Paint = function()
      draw.RoundedBox(0, 0, 0, RedPlayerList:GetWide(), 40, Color(24, 24, 24, 255))
      draw.SimpleText("Player", "DermaDefaultBold", 52, 12, Color(255, 255, 255, 255))
      draw.SimpleText("Kills", "DermaDefaultBold", RedPlayerList:GetWide()-120, 12, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
      draw.SimpleText("Deaths", "DermaDefaultBold", RedPlayerList:GetWide()-70, 12, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
      draw.SimpleText("Ping", "DermaDefaultBold", RedPlayerList:GetWide()-20, 12, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
      draw.SimpleText(team.NumPlayers(TEAM_RED).." /16", "DermaDefaultBold", RedPlayerList:GetWide()/2, 12, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
      draw.RoundedBox(0, 0, 40, RedPlayerList:GetWide(), 10, COLOR_RED)
      draw.RoundedBox(0, 0, RedPlayerList:GetTall()-10, RedPlayerList:GetWide(), 10, COLOR_RED)
    end

    BluePlayerList = vgui.Create("DListLayout", PlayerScrollPanel)
    BluePlayerList:SetSize(PlayerScrollPanel:GetWide()/2-100, PlayerScrollPanel:GetTall())
    BluePlayerList:SetPos(PlayerScrollPanel:GetWide()/2+50, 0)
    BluePlayerList:MakeDroppable("PlayerPanel")
    BluePlayerList:DockPadding(0, 50, 0, 10)
    BluePlayerList.Paint = function()
      draw.RoundedBox(0, 0, 0, RedPlayerList:GetWide(), 40, Color(24, 24, 24, 255))
      draw.SimpleText("Player", "DermaDefaultBold", 52, 12, Color(255, 255, 255, 255))
      draw.SimpleText("Kills", "DermaDefaultBold", RedPlayerList:GetWide()-120, 12, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
      draw.SimpleText("Deaths", "DermaDefaultBold", RedPlayerList:GetWide()-70, 12, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
      draw.SimpleText("Ping", "DermaDefaultBold", RedPlayerList:GetWide()-20, 12, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
      draw.SimpleText(team.NumPlayers(TEAM_BLUE).." /16", "DermaDefaultBold", BluePlayerList:GetWide()/2, 12, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
      draw.RoundedBox(0, 0, 40, BluePlayerList:GetWide(), 10, COLOR_BLUE)
      draw.RoundedBox(0, 0, BluePlayerList:GetTall()-10, BluePlayerList:GetWide(), 10, COLOR_BLUE)
    end
  end

  -- Print names in order of teams
  if IsValid(Scoreboard) then
    RedPlayerList:Clear()
    BluePlayerList:Clear()
    local PLAYERS = player.GetAll()

    -- Sort table by Kills
    table.sort(PLAYERS, function(a, b) return a:Frags() > b:Frags() end)

    for k, v in pairs(PLAYERS) do
      if IsValid(v) then
        createPlayerPanel(v, v:Team())
      end
    end

    Scoreboard:Show()
    Scoreboard:MakePopup()
    Scoreboard:SetKeyboardInputEnabled(false)
  end
end

function GM:ScoreboardHide()
  if IsValid(Scoreboard) then
    Scoreboard:Hide()
  end

end
