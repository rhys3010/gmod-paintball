--[[
* Handle transitions between states
* @author Rhys Evans
* @version 3/07/2017
]]

-- Default state
local state = STATE_WARMUP
local timeLeft = 30
local COLOR_RED = Color(255, 51, 51, 100)
local COLOR_BLUE = Color(0, 102, 255, 100)

-- Get state
net.Receive("STATE", function()
  state = net.ReadInt(3)
end)


function drawTransition()
  if(state == STATE_WARMUP) then
    drawWarmup()
  end

  if(state == STATE_STARTING) then
    drawStarting()
  end

  if(state == STATE_FINISHED) then
    drawEnd()
  end

end

function drawWarmup()
  draw.RoundedBox(10, ScrW()/2-200, ScrH()/4-100, 400, 50, Color(64, 65, 60, 100))
  draw.SimpleText("Waiting for players...", "CloseCaption_Normal", ScrW()/2-100, ScrH()/4-90, Color(255, 255, 255, 255))
end

function drawStarting()
  draw.RoundedBox(10, ScrW()/2-200, ScrH()/4-100, 400, 50, Color(64, 65, 60, 100))
  draw.SimpleText("Game is starting...", "CloseCaption_Normal", ScrW()/2-100, ScrH()/4-90, Color(255, 255, 255, 255))
end

function drawEnd()
  toggleTitle(false)

  if(team.GetScore(TEAM_RED) > team.GetScore(TEAM_BLUE)) then
    draw.RoundedBox(10, ScrW()/2-200, ScrH()/4-150, 400, 50, COLOR_RED)
    draw.SimpleText("Red Team Wins!", "CloseCaption_Normal", ScrW()/2, ScrH()/4-140, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
  end

  if(team.GetScore(TEAM_BLUE) > team.GetScore(TEAM_RED)) then
    draw.RoundedBox(10, ScrW()/2-200, ScrH()/4-150, 400, 50, COLOR_BLUE)
    draw.SimpleText("Blue Team Wins!", "CloseCaption_Normal", ScrW()/2, ScrH()/4-140, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
  end

  if(team.GetScore(TEAM_BLUE) == team.GetScore(TEAM_RED)) then
    draw.RoundedBox(10, ScrW()/2-200, ScrH()/4-150, 400, 50, Color(64, 65, 60, 100))
    draw.SimpleText("DRAW!", "CloseCaption_Normal", ScrW()/2, ScrH()/4-140, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
  end
end


hook.Add("HUDPaint", "drawWarmupHUD", drawTransition)
