include("shared.lua")
include("cl_menu.lua")
include("cl_hud.lua")
include("cl_scoreboard.lua")
include("cl_transitions.lua")
include("cl_chat.lua")
include("cl_killfeed.lua")
include("cl_weaponselect.lua")
include("cl_summary.lua")



surface.CreateFont("ScoreFont",{
  font = "Roboto", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
  extended = false,
  size = 24,
  weight = 500,
  blursize = 0,
  scanlines = 0,
  antialias = true,
  underline = false,
  italic = false,
  strikeout = false,
  symbol = false,
  rotary = false,
  shadow = false,
  additive = false,
  outline = false,
})
