AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_menu.lua")
AddCSLuaFile("cl_scoreboard.lua")
AddCSLuaFile("cl_transitions.lua")
AddCSLuaFile("cl_chat.lua")
AddCSLuaFile("cl_killfeed.lua")
AddCSLuaFile("cl_weaponselect.lua")
AddCSLuaFile("cl_summary.lua")

include("shared.lua")
include("cl_menu.lua")
include("cl_hud.lua")
include("cl_scoreboard.lua")
include("cl_transitions.lua")
include("cl_chat.lua")
include("teams.lua")
include("player.lua")
include("gamesequence.lua")
include("cl_weaponselect.lua")
include("cl_summary.lua")

util.PrecacheModel("models/Combine_Super_Soldier.mdl")
util.PrecacheModel("models/Combine_Soldier_PrisonGuard.mdl")

--Disable BLOOD
RunConsoleCommand("violence_ablood", "0")
RunConsoleCommand("violence_agibs", "0")
RunConsoleCommand("violence_hblood", "0")
RunConsoleCommand("violence_hgibs", "0")


function switchBotTeams()
  for k, v in pairs(player:GetAll()) do
    if v:IsBot() then
      if v:UserID() % 2 == 0 then
        v:SetTeam(TEAM_RED)
        v:Spawn()
      else
        v:SetTeam(TEAM_BLUE)
        v:Spawn()
      end
    end
  end

end

concommand.Add("shuffle_bots", switchBotTeams)
