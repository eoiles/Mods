-- ANOINTED

local path = "Survivors/Seraph/Skins/Anointed/"

local survivor = Survivor.find("Seraph", "Starstorm")
local sprSelect = Sprite.reload("ASeraphSelect", path.."Select", 21, 2, 0)
local ASeraph = SurvivorVariant.new(survivor, "SeraphPro", sprSelect, {
	idle = Sprite.reload("ASeraphIdle", path.."idle", 8, 7, 11),
	walk = Sprite.reload("ASeraphWalk", path.."walk", 8, 7, 11),
	jump = Sprite.reload("ASeraphJump", path.."jump", 4, 7, 11),
	climb = Sprite.reload("ASeraphClimb", path.."climb", 2, 8, 10),
	death = Sprite.reload("ASeraphDeath", path.."death", 21, 9, 24),
	decoy = Sprite.reload("ASeraphDecoy", path.."decoy", 1, 9, 10),
	
	shoot1 = Sprite.reload("ASeraphShoot1", path.."shoot1", 6, 8, 11),
	shoot2 = Sprite.reload("ASeraphShoot2", path.."shoot2", 18, 8, 11),
	shoot3_1 = Sprite.reload("ASeraphShoot3_1", path.."shoot3_1", 14, 20, 11),
	shoot3_2 = Sprite.reload("ASeraphShoot3_2", path.."shoot3_2", 13, 19, 11),
	shoot4 = Sprite.reload("ASeraphShoot4", path.."shoot4", 9, 16, 24),
	shoot5 = Sprite.reload("ASeraphShoot5", path.."shoot5", 9, 16, 24),
}, Color.fromHex(0xB5F7FF))
SurvivorVariant.setInfoStats(ASeraph, {{"Strength", 8}, {"Vitality", 3}, {"Toughness", 2}, {"Agility", 3}, {"Difficulty", 4}, {"Absolution", 10}})
SurvivorVariant.setDescription(ASeraph, "")

survivor:addCallback("useSkill", function(player, skill)
	local playerAc = player:getAccessor()

	if skill == 2 and player:get("name")=="SeraphPro" then
			player:getData().prepHspeed = playerAc.pHspeed * 3.5
	end

end)