--[[
* Show a menu and prompt the user to vote for next map
* @author Rhys Evans
* @version 24/07/2017
]]

local VotePrompt = nil
local MapList = nil
local SummaryPanel = nil
local hasVoted = false

-- Create map baseclass with attributes name and number of votes
local MapClass = {}
MapClass.Name = "map"
MapClass.Votes = 0

-- Create a new map
function Map(name)
  local newMap = table.Copy(MapClass)

  if name then
    newMap.Name = name
  end

  return newMap
end

-- Table to store maps
local MAPS =
{
  Map("gmpb_valley"),
  Map("gm_hazardville"),
  Map("gm_sevenhedges"),
  Map("cs_office"),
  Map("de_dust2"),
  Map("de_inferno"),
  Map("de_nuke"),
  Map("de_train")
}

-- Receive map vote
net.Receive("MAPS", function()
  -- Store date in temp array
  local maps = net.ReadTable()

  for i = 1, table.Count(maps), 1 do
    MAPS[i] = maps[i]
  end
end)


function createMapPanel(index)
  local MapPanel = vgui.Create("DButton", MapList)
  MapPanel:SetSize(MapList:GetWide(), 30)
  MapPanel:SetPos(0, 0)
  MapPanel:SetText("")
  MapPanel:DockMargin(0, 5, 0, 0)
  MapPanel.Paint = function()
    draw.RoundedBox(10, 0, 0, MapPanel:GetWide(), MapPanel:GetTall(), Color(24, 24, 24, 200))
    --Selected
    if(MapPanel:IsHovered()) then
      draw.RoundedBox(10, 0, 0, MapPanel:GetWide(), MapPanel:GetTall(), Color(0, 255, 102, 200))
    end
    draw.SimpleText(MAPS[index].Name, "DermaDefaultBold", 20, 7, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
    draw.SimpleText(MAPS[index].Votes, "DermaDefaultBold", MapPanel:GetWide()-20, 7, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)
  end

  -- Add vote on click
  MapPanel.DoClick = function()
    -- Only register vote if user hasn't voted
    if !hasVoted then
      sendVote(MAPS[index].Name)
    end
  end
end

-- Create game summary (different for each player)
function createSummary()

  local ply = LocalPlayer()
  if(!IsValid(ply)) then return end

  SummaryPanel = vgui.Create("DPanel", VotePrompt)
  SummaryPanel:SetSize(VotePrompt:GetWide(), 300)
  SummaryPanel:SetPos(0, VotePrompt:GetTall()/2)
  SummaryPanel.Paint = function()
    -- Draw background
    draw.RoundedBox(10, 0, 0, SummaryPanel:GetWide(), SummaryPanel:GetTall(), Color(24, 24, 24, 200))

    -- Draw border
    draw.RoundedBox(0, 0, 49, SummaryPanel:GetWide(), 1, Color(100, 100, 100, 255))
    draw.RoundedBox(0, 0, 149, SummaryPanel:GetWide(), 1, Color(100, 100, 100, 255))


    -- Outcome message
    if(hasWon(ply)) then
      draw.SimpleText("Victory!", "ammoFont", SummaryPanel:GetWide()/2, 10, COLOR_GREEN, TEXT_ALIGN_CENTER)
    elseif(ply:Team() == TEAM_SPEC) then
      -- Do nothing
    elseif(team.GetScore(TEAM_RED) == team.GetScore(TEAM_BLUE)) then
      draw.SimpleText("Draw!", "ammoFont", SummaryPanel:GetWide()/2, 10, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    else
      draw.SimpleText("Defeat!", "ammoFont", SummaryPanel:GetWide()/2, 10, COLOR_RED, TEXT_ALIGN_CENTER)
    end
  end

  createPlayerSummary(ply)
  createMVPSummary()
end

function createPlayerSummary(ply)
  local PlayerSummary = vgui.Create("DPanel", SummaryPanel)
  PlayerSummary:SetSize(SummaryPanel:GetWide()/2 - 40, SummaryPanel:GetTall()-50)
  PlayerSummary:SetPos(20, 70)
  PlayerSummary.Paint = function()
    -- Draw player name
    draw.SimpleText(ply:Name(), "CloseCaption_Normal", 75, 12, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
    draw.SimpleText("You", "CloseCaption_Normal", 75, 37, COLOR_GREEN, TEXT_ALIGN_LEFT)

    -- Draw player stats
    draw.SimpleText("Kills: "..ply:Frags(), "ChatFont", 0, 100, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
    draw.SimpleText("Deaths: "..ply:Deaths(), "ChatFont", 0, 140, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
    if(ply:Team() == TEAM_RED) then
      draw.SimpleText("Team: RED", "ChatFont", 0, 180, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
    elseif(ply:Team() == TEAM_BLUE) then
      draw.SimpleText("Team: BLUE", "ChatFont", 0, 180, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
    else
      draw.SimpleText("Team: N/A", "ChatFont", 0, 180, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
    end

  end

  local PlayerAvatar = vgui.Create("AvatarImage", PlayerSummary)
  PlayerAvatar:SetSize(64, 64)
  PlayerAvatar:SetPos(0, 0)
  PlayerAvatar:SetPlayer(ply, 64)
end

function createMVPSummary()
  local PLAYERS = player.GetAll()
  -- Sort table by Kills
  table.sort(PLAYERS, function(a, b) return a:Frags() > b:Frags() end)
  -- Assign mvp
  local mvp = PLAYERS[1]

  local MVPSummary = vgui.Create("DPanel", SummaryPanel)
  MVPSummary:SetSize(SummaryPanel:GetWide()/2 - 40, SummaryPanel:GetTall()-50)
  MVPSummary:SetPos(SummaryPanel:GetWide()/2 + 20, 70)
  MVPSummary.Paint = function()
    -- Draw player name
    draw.SimpleText(mvp:Name(), "CloseCaption_Normal", 75, 12, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
    draw.SimpleText("MVP", "CloseCaption_Normal", 75, 37, Color(255, 215, 0, 255), TEXT_ALIGN_LEFT)

    -- Draw player stats
    draw.SimpleText("Kills: "..mvp:Frags(), "ChatFont", 0, 100, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
    draw.SimpleText("Deaths: "..mvp:Deaths(), "ChatFont", 0, 140, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
    if(mvp:Team() == TEAM_RED) then
      draw.SimpleText("Team: RED", "ChatFont", 0, 180, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
    elseif(mvp:Team() == TEAM_BLUE) then
      draw.SimpleText("Team: BLUE", "ChatFont", 0, 180, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
    else
      draw.SimpleText("Team: N/A", "ChatFont", 0, 180, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
    end


  end

  local PlayerAvatar = vgui.Create("AvatarImage", MVPSummary)
  PlayerAvatar:SetSize(64, 64)
  PlayerAvatar:SetPos(0, 0)
  PlayerAvatar:SetPlayer(mvp, 64)
end

function createPrompt()

  VotePrompt = vgui.Create("DFrame")
  VotePrompt:SetSize(1000, 750)
  VotePrompt:SetPos(ScrW()/2-500, ScrH()/2-300)
  VotePrompt:SetTitle("")
  VotePrompt:SetDraggable(false)
  VotePrompt:ShowCloseButton(false)
  VotePrompt:SetDeleteOnClose(false)
  VotePrompt:MakePopup()
  VotePrompt.Paint = function()
    draw.SimpleText("Vote for the next map...", "CloseCaption_Normal", VotePrompt:GetWide()/2, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
  end

  MapList = vgui.Create("DListLayout", VotePrompt)
  MapList:SetSize(VotePrompt:GetWide()/2, VotePrompt:GetTall()/2)
  MapList:SetPos(VotePrompt:GetWide()/2 - VotePrompt:GetWide()/4, 50)

  for i = 1, table.Count(MAPS), 1 do
    createMapPanel(i)
  end

  createSummary()
end

-- Receive map vote prompt
net.Receive("PROMPT", function()
  openPanel()
end)


function openPanel()
  if(!IsValid(VotePrompt)) then
    createPrompt()
  end
end

function sendVote(map)
  net.Start("VOTE")
    net.WriteString(map)
  net.SendToServer()

  hasVoted = true
end

function hasWon(ply)

  if(ply:Team() == TEAM_RED && team.GetScore(TEAM_RED) > team.GetScore(TEAM_BLUE)) then
    return true
  elseif(ply:Team() == TEAM_BLUE && team.GetScore(TEAM_BLUE) > team.GetScore(TEAM_RED)) then
    return true
  else
    return false
  end

end
