--[[
* Handle Teams
* @author Rhys Evans
* @version 29/06/2017
]]

util.AddNetworkString("TEAM")

function printSwitchMessage(ply)
  local teamName

  if(ply:Team() == TEAM_RED) then
    ply:PrintMessage(HUD_PRINTCENTER, "You are now on team RED")
    teamName = "Red"
  elseif(ply:Team() == TEAM_BLUE) then
    ply:PrintMessage(HUD_PRINTCENTER, "You are now on team BLUE")
    teamName = "Blue"
  else
    ply:PrintMessage(HUD_PRINTCENTER, "You are now on team SPECTATING")
    teamName = "Spectator"
  end

  -- Close menu
  ply:ConCommand("menu_close")

  net.Start("TEAM")
    net.WriteEntity(ply)
    net.WriteString(teamName)
  net.Broadcast()
end

-- Moves the player to team spectator
function team_spec(ply)
  if(ply:Team() != TEAM_SPEC) then
    if(!ply:Alive()) then
      ply:SetTeam(TEAM_SPEC)
      printSwitchMessage(ply)
    elseif(getState() == STATE_WARMUP) then
      ply:SetTeam(TEAM_SPEC)
      printSwitchMessage(ply)
      ply:Spawn()
    else
      ply:PrintMessage(HUD_PRINTCENTER, "Cannot Switch Team Whilst Alive")
    end
  end
end

-- Moves the player to team red
function team_red(ply)

  -- If team is empty dont allow change
  if((ply:Team() != TEAM_SPEC) && (team.NumPlayers(TEAM_BLUE) <= 1) && (getState() != STATE_WARMUP)) then
    ply:PrintMessage(HUD_PRINTCENTER, "Not enough players to change team!")
    return
  end

  -- If other team is more full dont allow change
  if(team.NumPlayers(TEAM_BLUE) < team.NumPlayers(TEAM_RED)) then
    ply:PrintMessage(HUD_PRINTCENTER, "Team is Full!")
    return
  end

  if(ply:Team() != TEAM_RED) then
    if(!ply:Alive()) then
      ply:SetTeam(TEAM_RED)
      printSwitchMessage(ply)
    elseif(ply:Team() == TEAM_SPEC || getState() == STATE_WARMUP) then
      ply:SetTeam(TEAM_RED)
      printSwitchMessage(ply)
      ply:Spawn()
    else
      ply:PrintMessage(HUD_PRINTCENTER, "Cannot Switch Team Whilst Alive")
    end
  end
end

-- Moves the player to team blue
function team_blue(ply)

  -- If team is empty dont allow change
  if((ply:Team() != TEAM_SPEC) && (team.NumPlayers(TEAM_RED) <= 1) && (getState() != STATE_WARMUP)) then
    ply:PrintMessage(HUD_PRINTCENTER, "Not enough players to change team!")
    return
  end

  -- If other team is more full dont allow change
  if(team.NumPlayers(TEAM_RED) < team.NumPlayers(TEAM_BLUE)) then
    ply:PrintMessage(HUD_PRINTCENTER, "Team is Full!")
    return
  end


  if(ply:Team() != TEAM_BLUE) then
    if(!ply:Alive()) then
      ply:SetTeam(TEAM_BLUE)
      printSwitchMessage(ply)
    elseif(ply:Team() == TEAM_SPEC || getState() == STATE_WARMUP) then
      ply:SetTeam(TEAM_BLUE)
      printSwitchMessage(ply)
      ply:Spawn()
    else
      ply:PrintMessage(HUD_PRINTCENTER, "Cannot Switch Team Whilst Alive")
    end
  end
end

--------------------
-- Add console commands
--------------------
concommand.Add("team_red", team_red)
concommand.Add("team_blue", team_blue)
concommand.Add("team_spec", team_spec)
