-- LEGIONARY

local path = "Survivors/Mercenary/Skins/Legionary/"

local survivor = sur.Mercenary
local sprSelect = Sprite.load("LegionarySelect", path.."Select", 15, 2, 0)
local Legionary = SurvivorVariant.new(survivor, "Legionary", sprSelect, {
	idle = Sprite.load("LegionaryIdle", path.."Idle", 1, 3, 7),
	walk = Sprite.load("LegionaryWalk", path.."Walk", 8, 6, 7),
	jump = Sprite.load("LegionaryJump", path.."Jump", 1, 6, 6),
	climb = Sprite.load("LegionaryClimb", path.."Climb", 2, 3, 7),
	death = Sprite.load("LegionaryDeath", path.."Death", 8, 17, 2),
	decoy = Sprite.load("LegionaryDecoy", path.."Decoy", 1, 9, 18),
	
	shoot1_1 = Sprite.load("LegionaryShoot1A", path.."Shoot1_1", 20, 8, 25),
	shoot1_2 = Sprite.load("LegionaryShoot1B", path.."Shoot1_2", 20, 8, 25),
	shoot2 = Sprite.load("LegionaryShoot2", path.."Shoot2", 8, 15, 15),
	shoot3 = Sprite.load("LegionaryShoot3", path.."Shoot3", 8, 10, 8),
	shoot4 = Sprite.load("LegionaryShoot4", path.."Shoot4", 18, 30, 16),
	shoot5 = Sprite.load("LegionaryShoot5", path.."Shoot5", 18, 30, 16),
}, Color.fromHex(0xF8D83C))
SurvivorVariant.setInfoStats(Legionary, {{"Strength", 8}, {"Vitality", 5.5}, {"Toughness", 6}, {"Agility", 3.1}, {"Difficulty", 3.5}, {"Blessing", 7.5}})
SurvivorVariant.setDescription(Legionary, "The &y&Legionary&!& is an elder warrior who fights in favor of glory with heavy equipment.")

local sprSkill = Sprite.load("LegionarySkill", path.."Skill", 1, 0, 0)
local sShoot1_1 = Sound.load("LegionaryShoot1A", path.."Shoot1_1")
local sShoot1_2 = Sound.load("LegionaryShoot1B", path.."Shoot1_2")
local sShootOriginal = sfx.SamuraiShoot1
local sprSparks = spr.Sparks11

SurvivorVariant.setLoadoutSkill(Legionary, "Sovereign Bash", "Impact a sword against the ground for &y&340% damage on nearby enemies.", sprSkill)

Legionary.endingQuote = "..and so he left, willing to retire from his role."

callback.register("onSkinInit", function(player, skin)
	if skin == Legionary then
		player:set("armor", player:get("armor") + 5)
		player:set("pHmax", player:get("pHmax") - 0.15)
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(167, 12.5, 0.043)
		else
			player:survivorSetInitialStats(117, 12.5, 0.013)
		end
		player:setSkill(1,
		"Sovereign Bash",
		"Impact your sword against the ground for 340% damage on nearby enemies.",
		sprSkill, 1, 85)
	end
end)
survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == Legionary then
		player:survivorLevelUpStats(3, 0.3, -0.002, 1)
	end
end)
SurvivorVariant.setSkill(Legionary, 1, function(player)
	SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1_1"), 0.25, true, true)
end)
callback.register("onSkinSkill", function(player, skill, relevantFrame)
	if SurvivorVariant.getActive(player) == Legionary then
		local playerAc = player:getAccessor()
		if skill == 1 then
			if relevantFrame == 4 then
				if onScreen(player) then
					misc.shakeScreen(1)
				end
			end
			if relevantFrame == 1 then
				sShoot1_1:play(1 + math.random() * 0.2)
			elseif relevantFrame == 10 then
				if onScreen(player) then
					misc.shakeScreen(10)
				end
				sShoot1_2:play(1 + math.random() * 0.2)
				player:survivorFireHeavenCracker(3)
				for i = 0, playerAc.sp do
					local bullet = player:fireExplosion(player.x + 30 * player.xscale, player.y, 40 / 19, 10 / 4, 4.4, nil, sprSparks)
					bullet:set("direction", player:getFacingDirection())
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
			end
		end
	end
end)