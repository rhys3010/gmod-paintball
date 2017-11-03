--[[
* Override default weapon select interface
* @author MoronPipllyd
* @version 12/07/2017
]]

local rifleMat = Material("vgui/pb/icons/rifle_select.png")
local pistolMat = Material("vgui/pb/icons/pistol_select.png")
local fistsMat = Material("vgui/pb/icons/fists_select.png")

function switchWeapon(weapon)
  if IsValid(weapon) then
    -- Force the user to change weapon
    RunConsoleCommand( "use", weapon:GetClass())
  end
end

-- Override Default weapon switch
function GM:PlayerBindPress( ply, bind, pressed )

  -- Table to store all player's weapons
  local weapons = ply:GetWeapons()
  local nextWep
  -- Current selected weapon
  if(IsValid(ply:GetActiveWeapon())) then
    if(bind == "invprev") then
      nextWep = ply:GetActiveWeapon():GetSlot() -1

      if(nextWep < 0) then
        nextWep = table.Count(weapons)-1
      end

      switchWeapon(weapons[nextWep+1])
    end

    if(bind == "invnext") then
      nextWep = ply:GetActiveWeapon():GetSlot()+1

      -- Shuffle back through weapons
      if(nextWep >= table.Count(weapons)) then
        nextWep = nextWep % table.Count(weapons)
      end

      switchWeapon(weapons[nextWep+1])
    end

  	if(bind == "slot1") then
      switchWeapon(weapons[1])
    end

    if(bind == "slot2") then
      switchWeapon(weapons[2])
    end

    if(bind == "slot3") then
      switchWeapon(weapons[3])
    end

    if(bind == "slot4") then
      switchWeapon(weapons[4])
    end
  end
end

function createWeaponPanel()

end

function drawWeapons()

  local ply = LocalPlayer()

  if(!IsValid(ply)) then return end
  if(!ply:Alive()) then return end
  local weapons = ply:GetWeapons()
  local boxHeight = 70

  -- loop through all weapons creating a display Fix this later it's hack-ey as hell
  for i = 1, table.Count(weapons), 1 do

    draw.RoundedBox(0, ScrW()-70, ScrH()-(boxHeight+5)*(i+1), 70, boxHeight, Color(24, 24, 24, 200))

    -- Show rifle icon
    if (weapons[table.Count(weapons)-i+1]:GetClass() == "weapon_pb_rifle_red" || weapons[table.Count(weapons)-i+1]:GetClass() == "weapon_pb_rifle_blue") then
      surface.SetMaterial(rifleMat)
    end

    -- Show pistol icon
    if(weapons[table.Count(weapons)-i+1]:GetClass() == "weapon_pb_pistol_red" || weapons[table.Count(weapons)-i+1]:GetClass() == "weapon_pb_pistol_blue") then
      surface.SetMaterial(pistolMat)
    end

    -- Show fists icon
    if(weapons[table.Count(weapons)-i+1]:GetClass() == "weapon_pb_fists") then
      surface.SetMaterial(fistsMat)
    end

    -- If active (selected)
    if(weapons[table.Count(weapons)-i+1] == ply:GetActiveWeapon()) then
      surface.SetDrawColor(255, 255, 255, 255)
      surface.DrawTexturedRect(ScrW()-70, ScrH()-(boxHeight+5)*(i+1), 70, 70)
    else
      surface.SetDrawColor(64, 64, 64, 255)
      surface.DrawTexturedRect(ScrW()-70, ScrH()-(boxHeight+5)*(i+1), 70, 70)
    end
  end
end

hook.Add("HUDPaint", "drawWeapons", drawWeapons)

function drawAmmo()

  local ply = LocalPlayer()

  if(!ply:Alive()) then return end
  if(!IsValid(ply)) then return end
  if(!IsValid(ply:GetActiveWeapon())) then return end
  if(ply:Team() == TEAM_SPEC) then return end

  draw.RoundedBox(0, ScrW()-200, ScrH()-60, 200, 60, Color(24, 24, 24, 200))
  -- Draw ammo
  if(ply:GetActiveWeapon():Clip1() <= 5) then
    draw.SimpleText(ply:GetActiveWeapon():Clip1().." / "..ply:GetAmmoCount(ply:GetActiveWeapon():GetPrimaryAmmoType()), "ammoFont", ScrW()-140, ScrH()-45, Color(255, 0, 0, 200))
  else
    draw.SimpleText(ply:GetActiveWeapon():Clip1().." / "..ply:GetAmmoCount(ply:GetActiveWeapon():GetPrimaryAmmoType()), "ammoFont", ScrW()-140, ScrH()-45, Color(255, 255, 255, 200))
  end

  -- Draw icon
  if(ply:GetActiveWeapon():GetClass() == "weapon_pb_rifle_red" || ply:GetActiveWeapon():GetClass() == "weapon_pb_rifle_blue") then
    if(ply:Team() == TEAM_BLUE) then
      draw.SimpleText("N", "csKillIcons", ScrW()-195, ScrH()-25, Color(0, 102, 255, 200))
    elseif(ply:Team() == TEAM_RED) then
      draw.SimpleText("N", "csKillIcons", ScrW()-195, ScrH()-25, Color(255, 0, 0, 200))
    end
  elseif(ply:GetActiveWeapon():GetClass() == "weapon_pb_pistol_red" || ply:GetActiveWeapon():GetClass() == "weapon_pb_pistol_blue") then
    if(ply:Team() == TEAM_BLUE) then
      draw.SimpleText("R", "csKillIcons", ScrW()-195, ScrH()-25, Color(0, 102, 255, 200))
    elseif(ply:Team() == TEAM_RED) then
      draw.SimpleText("R", "csKillIcons", ScrW()-195, ScrH()-25, Color(255, 0, 0, 200))
    end
  end


end

hook.Add("HUDPaint", "drawAmmo", drawAmmo)
