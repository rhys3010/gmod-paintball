--[[
* Show the hud and override default hud
* @author Rhys Evans
* @version 30/06/2017
]]

local COLOR_RED = Color(255, 51, 51, 100)
local COLOR_BLUE = Color(0, 102, 255, 100)

local timeLeft = 0
local randNum = math.random(1,3)

local splat_mix = Material("vgui/pb/splat_mix.png")


local splat_red = {
  Material("vgui/pb/splat_red1.png"),
  Material("vgui/pb/splat_red2.png"),
  Material("vgui/pb/splat_red3.png"),
}

local splat_blue = {
  Material("vgui/pb/splat_blue1.png"),
  Material("vgui/pb/splat_blue2.png"),
  Material("vgui/pb/splat_blue3.png"),
}


function drawVersion()
  draw.SimpleText("Paintball Deathmatch by MoronPipllyd", "DermaDefaultBold", 10, 10, Color(255, 255, 255, 255), 0, 0)
  draw.SimpleText("Alpha "..VERSION, "DermaDefaultBold", 10, 25, Color(255, 255, 255, 255), 0, 0)
end

function drawTimeBox()

  local ply = LocalPlayer()
  if(!IsValid(ply)) then return end
  -- Udpdate remaining time
  net.Receive("TIMER", function()
    timeLeft = net.ReadInt(16)
  end)

  -- DRAW TIME LIMIT
  draw.RoundedBox(0, ScrW()/2-300, 0, 600, 50, Color(64, 65, 60, 100))
  if(timeLeft <= 10 && timeLeft > 1) then
    draw.SimpleText(string.FormattedTime(timeLeft, "%02i:%02i"), "DermaLarge", ScrW()/2, 10, Color(255, 51, 51, 255), TEXT_ALIGN_CENTER)
  elseif(timeLeft == 0) then
    if(ply:Team() == TEAM_RED) then
      draw.SimpleText("G", "csKillIcons", ScrW()/2, 10, Color(255, 51, 51, 255), TEXT_ALIGN_CENTER)
    elseif(ply:Team() == TEAM_BLUE) then
      draw.SimpleText("G", "csKillIcons", ScrW()/2, 10, Color(0, 102, 255, 255), TEXT_ALIGN_CENTER)
    else
      draw.SimpleText("G", "csKillIcons", ScrW()/2, 10, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    end
  else
    draw.SimpleText(string.FormattedTime(timeLeft, "%02i:%02i"), "DermaLarge", ScrW()/2, 10, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
  end
end

function drawScoreBar(ply)

  local barSize = 225
  local progressRed = (team.GetScore(TEAM_RED) / MAX_SCORE)
  local progressBlue = (team.GetScore(TEAM_BLUE) / MAX_SCORE)

  -- DRAW RED SCORE
  draw.RoundedBox(0, ScrW()/2 - (50+barSize)-10, 12, barSize, 12, Color(255, 51, 51, 70))
  draw.RoundedBox(0, ScrW()/2 - (50+barSize)-10, 12, progressRed*barSize , 12, Color(255, 51, 51, 255))
  draw.SimpleText(team.GetScore(TEAM_RED), "ScoreFont", ScrW()/2 - (50+barSize)-10, 25, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)

  -- DRAW BLUE SCORE
  draw.RoundedBox(0, ScrW()/2 + 60, 12, barSize, 12, Color(0, 102, 255, 70))
  draw.RoundedBox(0, (ScrW()/2 + 60 +(barSize)) - progressBlue*barSize , 12, progressBlue*barSize, 12, Color(0, 102, 255, 255))
  draw.SimpleText(team.GetScore(TEAM_BLUE), "ScoreFont", ScrW()/2 + (50+barSize), 25, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)


end

--------------------
-- NAMETAG
--------------------
function GM:HUDDrawTargetID()
  return false
end

function drawPlayerTag(ply)
  if !ply:Alive() || ply:Team() == TEAM_SPEC then
    return
  end

  local offset = Vector(0, 0, 80)
  local ang = LocalPlayer():EyeAngles()
  local pos = ply:GetPos() + offset + ang:Up()

  ang:RotateAroundAxis( ang:Forward(), 90 )
	ang:RotateAroundAxis( ang:Right(), 90 )

  cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.25)
    if ply:Team() == TEAM_RED then
      draw.DrawText(ply:GetName(), "TargetID", 2, 2, Color(255, 51, 51, 150), TEXT_ALIGN_CENTER)
    elseif ply:Team() == TEAM_BLUE then
      draw.DrawText(ply:GetName(), "TargetID", 2, 2, Color(0, 102, 255, 150), TEXT_ALIGN_CENTER)
    end
  cam.End3D2D()
end

hook.Add("PostPlayerDraw", "DrawName", drawPlayerTag)


function HUD()

  local ply = LocalPlayer()

  --Do nothing if player is dead
  if !ply:Alive() then
    return
  end

  drawTimeBox()
  drawVersion()
  drawScoreBar(ply)
end


------------------
-- DEATH SCREEN
------------------
function drawPaintSplat()
  net.Receive("NUM", function()
    randNum = net.ReadInt(3)
  end)

  local ply = LocalPlayer()
  if(!ply:Alive()) then

    -- Draw splat
    surface.SetDrawColor(255, 255, 255, 255)
    if(ply:Team() == TEAM_RED) then
      surface.SetMaterial(splat_blue[randNum])
    elseif(ply:Team() == TEAM_BLUE) then
      surface.SetMaterial(splat_red[randNum])
    elseif(ply:Team() == TEAM_SPEC) then
      surface.SetMaterial(splat_mix)
    end
    surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
  end
end

hook.Add("HUDPaint", "drawSplat", drawPaintSplat)


--------------------
-- Hide Default HUD
----------------------

local hide = {
	CHudHealth = true,
	CHudBattery = true,
  CHudAmmo = true,
  CHudDamageIndicator = true,
  CHudWeaponSelection = true,
}

hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if ( hide[ name ] ) then return false end

	-- Don't return anything here, it may break other addons that rely on this hook.
end )

hook.Add("HUDPaint", "PBHud", HUD)
