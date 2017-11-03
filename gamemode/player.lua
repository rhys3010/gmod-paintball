--[[
* Handle Players
* @author Rhys Evans
* @version 29/06/2017
]]

local SCORE_INCREMENT = 10
local RESPAWN_TIME = 4
local protected = false
util.AddNetworkString("NUM")
util.AddNetworkString("KILL")

-- What to do when player initially spawns in
function GM:PlayerInitialSpawn(ply)
  ply:ConCommand("menu_toggle")
end

-- On Player spawn
function GM:PlayerSpawn(ply)
  ply:StripWeapons()
  ply:UnSpectate()
  if ply:Team() == TEAM_RED then
    ply:Give("weapon_pb_rifle_red")
    ply:Give("weapon_pb_pistol_red")
    ply:Give("weapon_pb_fists")
    --ply:SetPos(Vector(2635.274414, -659.998474, 40.031250))
    ply:SetModel("models/player/guerilla.mdl")
    ply:SetHealth(10)

  elseif ply:Team() == TEAM_BLUE then
    ply:Give("weapon_pb_rifle_blue")
    ply:Give("weapon_pb_pistol_blue")
    ply:Give("weapon_pb_fists")
    --ply:SetPos(Vector(-832.226685, -716.074585, 40.031250))
    ply:SetModel("models/player/gasmask.mdl")
    ply:SetHealth(10)

  else
    if (!ply:IsBot()) then
      ply:Spectate(6)
    else
      ply:SetPos(Vector(-832.226685, -716.074585, 40.031250))
    end
  end
end

function GM:PlayerConnect(name, ip)
  PrintMessage(HUD_PRINTTALK, name .. " has joined the game.")
end

function sendRandNum()
  local randNum = math.random(1,3)
  net.Start("NUM")
    net.WriteInt(randNum, 3)
  net.Broadcast()
end

function sendKill(victim, inflictor, attacker)
  -- Send data in table
  local info = {victim, inflictor, attacker}

  net.Start("KILL")
    net.WriteTable(info)
  net.Broadcast()
end


---------------------
-- Handle Player Death
---------------------
function GM:PlayerDeath(victim, inflictor, attacker)
  sendRandNum()
  sendKill(victim, inflictor, attacker)
  -- (not suicide)
  if (attacker != victim) then
    if attacker:Team() == TEAM_RED then
      team.AddScore(TEAM_RED, SCORE_INCREMENT)
    elseif attacker:Team() == TEAM_BLUE then
      team.AddScore(TEAM_BLUE, SCORE_INCREMENT)
    end
  end
  --Print to console
  MsgC( Color( 255, 0, 0 ), "["..string.FormattedTime( os.time(), "%02i:%02i:%02i").."] - "..attacker:Name().." killed "..victim:Name())
  PrintMessage(HUD_PRINTCONSOLE, "["..string.FormattedTime( os.time(), "%02i:%02i:%02i").."] - "..attacker:Name().." killed "..victim:Name())

  --Play death sound
  victim:EmitSound("/pb/death.wav", 75, 100, 1, CHAN_AUTO)

end

function showDeathScreen(ply, weapon, killer)
  local timeLeft = 3

  if (IsValid(killer) && ply != killer && killer:IsPlayer()) then
    if killer:GetPos():Distance( ply:GetPos() ) < 5000 then
  		ply:SpectateEntity(killer)
  		ply:Spectate(OBS_MODE_DEATHCAM)
    end
  end

  timer.Create("MessageTimer"..ply:UserID(), 1, 3, function()
    if(IsValid(ply)) then
      ply:PrintMessage(HUD_PRINTCENTER, "You were killed by "..killer:GetName().."    ["..timeLeft.."]")
    end
    timeLeft = timeLeft - 1
  end)
end


------------------
-- Respawn Time
------------------
function spawnDelay(ply, weapon, killer)
	ply:Lock()
  showDeathScreen(ply, weapon, killer)

	timer.Create("DeathTimer"..ply:UserID(), RESPAWN_TIME, 1, function()
    ply:PrintMessage(HUD_PRINTCENTER, "")
		ply:UnLock()
		ply:Spawn()
	end)
end

hook.Add("PlayerDeath","spawnDelay",spawnDelay)

function disableDamage()
  return false
end

----------------
-- Mute death sound
----------------
function mutePlayerDeathSound()
  return true
end

hook.Add("PlayerDeathSound", "muteDeathSound", mutePlayerDeathSound)


-----------------
-- Handle spawn protection
-- Give 2 seconds of protection if user does not move
-----------------
function spawnProtection(ply)
  --Make invincible for 2 seconds
  protected = true
  ply:GodEnable()
  ply:SetRenderMode(RENDERMODE_TRANSCOLOR)
  ply:SetColor(Color(255, 255, 255, 150))

  timer.Simple(2, function()
    protected = false
    ply:GodDisable()
    ply:SetRenderMode(RENDERMODE_NORMAL)
  end)
end

hook.Add("PlayerSpawn", "spawnProtection", spawnProtection)

function GM:Move(ply)
  --Check if player has moved and disable godmode
  if(ply:GetVelocity():Length() > 0 && protected == true) then
    ply:GodDisable()
    ply:SetRenderMode(RENDERMODE_NORMAL)
    protected = false
  end
end


--------------------
-- Friendly Fire
--------------------
function GM:PlayerShouldTakeDamage(ply, attacker)
  if ply:Team() == attacker:Team() then
    return false
  elseif ply:Team() == TEAM_SPEC then
    return false
  end
  return true

end
