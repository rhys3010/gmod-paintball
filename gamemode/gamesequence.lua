--[[
* Handle game sequence server side
* @author Rhys Evans
* @version 1/07/2017
]]

-- State of game
local state = STATE_WARMUP
timer.Create("GameTimer", GAME_TIME, 1, function() end)
timer.Create("WarmupTimer", WARMUP_TIME, 1, function() end)
timer.Create("SendTime", 0.25, 0, function() end)

function GM:Initialize()
  util.AddNetworkString("TIMER")
  util.AddNetworkString("STATE")
  util.AddNetworkString("VOTE")
  util.AddNetworkString("MAPS")
  util.AddNetworkString("PROMPT")
  startWarmup()
end


--------------
-- MAPVOTE CODE
--------------

-- Create map baseclass with attributes name and number of votes
local MapClass = {}
MapClass.Name = "map"
MapClass.Votes = 0

-- Create a new map (constructor)
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

-- Add vote to given map
function addVote(mapName)

  -- Loop through all maps and add 1 vote to the map with the same name
  for i = 1, table.Count(MAPS), 1 do
    if(MAPS[i].Name == mapName) then
      MAPS[i].Votes = MAPS[i].Votes +1
    end
  end

  sendMaps()
end

-- Every time a vote is received update the clientside map list
function sendMaps()
  net.Start("MAPS")
    net.WriteTable(MAPS)
  net.Broadcast()
end

function sendPrompt()
  net.Start("PROMPT")
  net.Broadcast()
end

-- Receive map vote
net.Receive("VOTE", function()
  addVote(net.ReadString())
end)

----------------
-- SEQUENCE CODE
----------------

function startWarmup()
  state = STATE_WARMUP
  sendState()

  timer.Adjust("WarmupTimer", WARMUP_TIME, 1, function()
    -- Check if game is possible
    if(team.NumPlayers(TEAM_RED) > 0) && (team.NumPlayers(TEAM_BLUE) > 0) then
      startGame()
    end
  end)
  timer.Start("WarmupTimer")
end

function startGame()
  if(state == STATE_WARMUP) then
    state = STATE_STARTING

    initGame()
    -- Wait 5 seconds, unlock all players and start the game
    timer.Simple(5, function()
        state = STATE_GAME
        sendState()
        -- End the game after 10 minutes
        timer.Adjust("GameTimer", GAME_TIME, 1, endGame)
        timer.Start("GameTimer")
        updateGameTime()

        for k, v in pairs(player.GetAll()) do
          v:Freeze(false)
        end
    end)
  end
end

function endGame()
  state = STATE_FINISHED
  sendState()
  timer.Stop("SendTime")

  for k, v in pairs(player.GetAll()) do
    v:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 200), 3, 60)
  end
  -- Wait 3 seconds before showing summary
  timer.Simple(3, function()
    for k, v in pairs(player.GetAll()) do
      v:Freeze(true)
      v:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 200), 1, 60)
      sendPrompt()
    end
  end)

  -- Delay before restarting
  timer.Simple(END_DELAY, restartGame)
end

function initGame()
  state = STATE_STARTING
  sendState()
  -- Reset Scores
  team.SetScore(TEAM_RED, 0)
  team.SetScore(TEAM_BLUE, 0)

  -- Respawn and lock all Players
  for k, v in pairs(player.GetAll()) do
    v:Spawn()
    v:Freeze(true)
    v:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 200), 0.5, 5)
  end
end

-- Check to see if there are enough players to start the game
function checkForPlayers(ply)
  if(state == STATE_STARTING) then
    ply:Freeze(true)
  end

  if(team.NumPlayers(TEAM_RED) > 0) && (team.NumPlayers(TEAM_BLUE) > 0) then
    if(not timer.Exists("WarmupTimer")) then
      startGame()
    end
  end
end

hook.Add("PlayerSpawn", "checkForPlayers", checkForPlayers)

function checkForWin(victim, inflictor, attacker)
  if(team.GetScore(attacker:Team()) >= MAX_SCORE) then
    endGame()
  end
end

hook.Add("PlayerDeath", "checkForWin", checkForWin)

function stopDamage()
  if(state != STATE_GAME) then
    return false
  end
end

hook.Add("PlayerShouldTakeDamage", "stopDamage", stopDamage)


function restartGame()
  -- Get most voted Map
  table.sort(MAPS, function(a, b) return a.Votes > b.Votes end)
  RunConsoleCommand("changelevel", MAPS[1].Name)
end

function sendGameTime()
  net.Start("TIMER")
    net.WriteInt(timer.TimeLeft("GameTimer"), 16)
  net.Broadcast()
end

function sendState()
  net.Start("STATE")
    net.WriteInt(state, 3)
  net.Broadcast()
end

function getState()
  return state
end

hook.Add("PlayerInitialSpawn", "sendState", sendState)

function updateGameTime()
  timer.Adjust("SendTime", 0.25, 3000, sendGameTime)
  timer.Start("SendTime")
end

-- Force start game
concommand.Add("start_game", startGame)
-- Force end game
concommand.Add("end_game", endGame)
