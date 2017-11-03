GM.Name = "Paintball Deathmatch"
GM.Author = "Rhys Evans"
GM.Email = "rhys301097@gmail.com"
GM.Website = "http://rhysevans.xyz"
GM.Version = "0.9.1"


-- Color Constants
COLOR_WHITE = Color(255, 255, 255, 255)
COLOR_BLACK = Color(0, 0, 0, 255)
COLOR_RED = Color(255, 51, 51, 255)
COLOR_BLUE = Color(0, 102, 255, 255)
COLOR_GREEN = Color(0, 255, 102, 255)

WARMUP_TIME = 20
GAME_TIME = 600
END_DELAY = 30

MAX_SCORE = 800

VERSION = "0.9.1"
TEAM_SPEC = 0
TEAM_RED = 1
TEAM_BLUE = 2
STATE_WARMUP, STATE_STARTING, STATE_GAME, STATE_FINISHED = 0, 1, 2, 3

surface.CreateFont( "csKillIcons",
{
  font      = "csd",
  size      = 48,
  weight    = 700
})

surface.CreateFont( "playerIcon",
{
  font      = "csd",
  size      = 72,
  weight    = 400
})

surface.CreateFont( "teamSelectFont",
{
  font      = "DermaLarge",
  size      = 72,
  weight    = 100
})

surface.CreateFont( "ammoFont",
{
  font      = "Trebuchet18",
  size      = 36,
  weight    = 100
})


function GM:CreateTeams()

  team.SetUp(1, "Red", COLOR_RED)
  team.SetUp(2, "Blue", COLOR_BLUE)
end

concommand.Add( "entity_pos", function( ply )
	local tr = ply:GetEyeTrace()
	if ( IsValid( tr.Entity ) ) then
		print( "Entity position:", tr.Entity:GetPos() )
	else
		print( "Crosshair position:", tr.HitPos )
	end
end )
