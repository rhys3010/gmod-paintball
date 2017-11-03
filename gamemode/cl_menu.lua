--[[
* Handle clientside menu (Team Select, Weapon Select)
* @author Rhys Evans
* @version 19/07/2017
]]

local Menu = nil
local TopPanel = nil
local TeamPanel = nil
local HomePanel = nil


function createMenu()
  Menu = vgui.Create("DFrame")
  Menu:SetSize(1000, 750)
  Menu:SetPos(ScrW()/2 - Menu:GetWide()/2, ScrH() / 2 - Menu:GetTall()/2)
  Menu:SetTitle("Menu - Press F4 to Close")
  Menu:SetDraggable(false)
  Menu:ShowCloseButton(false)
  Menu:SetDeleteOnClose(false)

  Menu.Paint = function()

    -- Draw main window
    surface.SetDrawColor(70, 70, 70, 255)
    surface.DrawRect(0, 0, Menu:GetWide(), Menu:GetTall())

    -- Draw spacer
    surface.SetDrawColor(40, 40, 40, 255)
    surface.DrawRect(0, 24, Menu:GetWide(), 1)
  end

  createTopPanel()
  createHomePanel()
  createTeamPanel()
end

function createTopPanel()
  TopPanel = vgui.Create("DIconLayout", Menu)
  TopPanel:SetSize(Menu:GetWide(), 50)
  TopPanel:SetPos(0, 25)
  TopPanel.Paint = function()
    surface.SetDrawColor(50, 50, 50, 255)
    surface.DrawRect(0, 0, TopPanel:GetWide(), TopPanel:GetTall())
  end

  createButton("Home")
  createButton("Team Select")
  createButton("Loadout")
  createButton("Rules")
  createButton("Submit Report")
end

function createButton(title)
  local button = vgui.Create("DButton", TopPanel)
  button:SetText("")
  button:SetSize(125, 50)
  button:SetPos(0, 0)
  button.Paint = function()

    -- Background
    surface.SetDrawColor(50, 50, 50, 255)
    surface.DrawRect(0, 0, button:GetWide(), button:GetTall())

    if(button:IsHovered()) then
      -- Button border
      surface.SetDrawColor(255, 255, 255, 200)
      surface.DrawRect(0, 48, button:GetWide(), 2)
    end

    -- Draw Title
    draw.DrawText(title, "DermaDefaultBold", button:GetWide()/2, 17, Color(255, 255, 255, 255),1)
  end

  button.DoClick = function()

    if(title == "Team Select") then
      togglePanel(TeamPanel)
    end

    if(title == "Home") then
      togglePanel(HomePanel)
    end

  end

  return button
end


function togglePanel(panel)

  HomePanel:SetVisible(false)
  TeamPanel:SetVisible(false)

  if panel:IsVisible() then
    panel:SetVisible(false)
  else
    panel:SetVisible(true)
  end
end

function createHomePanel()
  HomePanel = vgui.Create("DPanel", Menu)
  HomePanel:SetSize(Menu:GetWide(), Menu:GetTall()-75)
  HomePanel:SetPos(0, 75)

  local html = vgui.Create( "HTML", HomePanel )
  html:Dock( FILL )
  html:OpenURL("rhysevans.xyz/paintball")
end

function createTeamPanel()
  TeamPanel = vgui.Create("DPanel", Menu)
  TeamPanel:SetSize(Menu:GetWide(), Menu:GetTall()-75)
  TeamPanel:SetPos(0, 75)
  TeamPanel:SetVisible(false)
  TeamPanel.Paint = function()

    -- Draw Background
    surface.SetDrawColor(70, 70, 70, 255)
    surface.DrawRect(0, 0, TeamPanel:GetWide(), TeamPanel:GetTall())

    -- Draw border
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawRect(0, 48, TeamPanel:GetWide(), 2)

    -- Draw title
    draw.DrawText("Select a Team", "DermaDefaultBold", TeamPanel:GetWide()/2, 15, Color(255, 255, 255, 255),1)

  end

  ------------------
  -- RED TEAM
  ------------------
  local RedButton = vgui.Create("DButton", TeamPanel)
  RedButton:SetSize(TeamPanel:GetWide()/2, TeamPanel:GetTall()-25)
  RedButton:SetPos(0, 50)
  RedButton:SetText("")
  RedButton.Paint = function()
    surface.SetDrawColor(255, 51, 51, 200)
    surface.DrawRect(0, 0, RedButton:GetWide(), RedButton:GetTall())
    draw.DrawText("RED", "teamSelectFont", RedButton:GetWide()/2, 15, Color(255, 255, 255, 255),1)
    draw.DrawText("H", "playerIcon", RedButton:GetWide()/2-25, RedButton:GetTall()-100, Color(255, 255, 255, 255), 1)
    draw.DrawText(" - "..team.NumPlayers(TEAM_RED), "DermaLarge", RedButton:GetWide()/2, RedButton:GetTall()-90, Color(255, 255, 255, 255),1 )
  end
  RedButton.DoClick = function()
    RunConsoleCommand("team_red")
  end

  local RedModelPanel = vgui.Create("DModelPanel", RedButton)
  RedModelPanel:SetSize(360, 640)
  RedModelPanel:SetPos(RedButton:GetWide()/2-180, RedButton:GetTall()/2-320)
  RedModelPanel:SetModel("models/player/guerilla.mdl")
  RedModelPanel.DoClick = function()
    RunConsoleCommand("team_red")
  end


  ------------------
  -- BLUE TEAM
  ------------------
  local BlueButton = vgui.Create("DButton", TeamPanel)
  BlueButton:SetSize(TeamPanel:GetWide()/2, TeamPanel:GetTall()-25)
  BlueButton:SetPos(TeamPanel:GetWide()/2, 50)
  BlueButton:SetText("")
  BlueButton.Paint = function()
    surface.SetDrawColor(0, 102, 255, 200)
    surface.DrawRect(0, 0, BlueButton:GetWide(), BlueButton:GetTall())
    draw.DrawText("BLUE", "teamSelectFont", BlueButton:GetWide()/2, 15, Color(255, 255, 255, 255),1)
    draw.DrawText("H", "playerIcon", BlueButton:GetWide()/2-25, BlueButton:GetTall()-100, Color(255, 255, 255, 255), 1)
    draw.DrawText(" - "..team.NumPlayers(TEAM_BLUE), "DermaLarge", BlueButton:GetWide()/2, BlueButton:GetTall()-90, Color(255, 255, 255, 255),1 )
  end
  BlueButton.DoClick = function()
    RunConsoleCommand("team_blue")
  end

  local BlueModelPanel = vgui.Create("DModelPanel", BlueButton)
  BlueModelPanel:SetSize(360, 640)
  BlueModelPanel:SetPos(BlueButton:GetWide()/2-180, BlueButton:GetTall()/2-320)
  BlueModelPanel:SetModel("models/player/gasmask.mdl")
  BlueModelPanel.DoClick = function()
    RunConsoleCommand("team_blue")
  end

end


function openMenu()

  if !IsValid(Menu) then
    createMenu()
    gui.EnableScreenClicker(true)
    return
  end

  if Menu:IsVisible() then
    gui.EnableScreenClicker(false)
    Menu:Close()
  else
    Menu:SetVisible(true)
    gui.EnableScreenClicker(true)
  end
end

function closeMenu()

  if !IsValid(Menu) then
    createMenu()
    gui.EnableScreenClicker(true)
    return
  end

  if Menu:IsVisible() then
    gui.EnableScreenClicker(false)
    Menu:Close()
  end
end

concommand.Add("menu_close", closeMenu)
concommand.Add("menu_toggle", openMenu)

-- Keybind to open menu
function GM:ShowSpare2(ply)
  ply:ConCommand("menu_toggle")
end
