--[[
* Print things to the chat
* @author Rhys Evans
* @version 06/07/2017
]]


-- Get kills
net.Receive("KILL", function()
  local info = net.ReadTable()
  drawKills(info[1], info[2], info[3])
end)

net.Receive("TEAM", function()
  local ply = net.ReadEntity()
  local teamName = net.ReadString()
  drawTeamSwitch(ply, teamName)
end)

function drawKills(victim, inflictor, attacker)
  if(victim:Team() == TEAM_SPEC || attacker:Team() == TEAM_SPEC) then return end

  GAMEMODE:AddDeathNotice(attacker:Name(), attacker:Team(), attacker:GetActiveWeapon():GetClass(), victim:Name(), victim:Team())

  if CLIENT then
    if(attacker == LocalPlayer() && victim != LocalPlayer()) then
      chat.AddText(Color(100, 255, 100), "You", Color(255, 255, 255, 255), " Killed ", COLOR_RED, victim:Name())
    end
  end
end

function drawTeamSwitch(ply, teamName)

  -- delay so team can change
  timer.Simple(0.25, function()
    if CLIENT && IsValid(ply) then
      if (ply == LocalPlayer()) then
        chat.AddText(Color(100, 255, 100), "You ", Color(255, 255, 255), "joined team ", team.GetColor(ply:Team()), teamName)
      else
        chat.AddText(Color(255, 255, 255), ply:Name().." joined team ", team.GetColor(ply:Team()), teamName)
      end
    end
  end)
end
