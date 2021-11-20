-- ELECTROCUTIONER

local path = "Survivors/Executioner/Skins/Electrocutioner/"

local survivor = Survivor.find("Executioner", "Starstorm")
local sprSelect = Sprite.load("ElectrocutionerSelect", path.."Select", 14, 2, 0)
local Electrocutioner = SurvivorVariant.new(survivor, "Electrocutioner", sprSelect, {
	idle = Sprite.load("ElectrocutionerIdle", path.."Idle", 1, 5, 6),
	walk = Sprite.load("ElectrocutionerWalk", path.."Walk", 8, 5, 7),
	jump = Sprite.load("ElectrocutionerJump", path.."Jump", 1, 5, 6),
	climb = Sprite.load("ElectrocutionerClimb", path.."Climb", 2, 4, 7),
	death = Sprite.load("ElectrocutionerDeath", path.."Death", 5, 7, 3),
	decoy = Sprite.load("ElectrocutionerDecoy", path.."Decoy", 1, 9, 10),
	
	shoot1 = Sprite.load("ElectrocutionerShoot1", path.."Shoot1", 3, 9, 10),
	shoot2 = Sprite.load("ElectrocutionerShoot2", path.."Shoot2", 22, 9, 10),
	shoot3 = Sprite.load("ElectrocutionerShoot3", path.."Shoot3", 8, 24, 20),
	shoot4 = Sprite.load("ElectrocutionerShoot4", path.."Shoot4", 14, 17, 34),
	shoot5 = Sprite.load("ElectrocutionerShoot5", path.."Shoot5", 14, 17, 34),
}, Color.fromHex(0x8882C4))
SurvivorVariant.setInfoStats(Electrocutioner, {{"Strength", 8}, {"Vitality", 5}, {"Toughness", 4}, {"Agility", 6}, {"Difficulty", 4}, {"Social Skills", 0}})
SurvivorVariant.setDescription(Electrocutioner, "The &y&Electrocutioner&!& is a crowd control unit turning voltage manipulation into deadly doses of electric bolts to stop all his contenders.")

local sprSkill = Sprite.load("ElectrocutionerSkill", path.."Skill", 1, 0, 0)
local sShoot = Sound.load("ElectrocutionerShoot1", path.."Shoot1")
local sShootOriginal = Sound.find("ExecutionerShoot1", "Starstorm")

SurvivorVariant.setLoadoutSkill(Electrocutioner, "Deadly Voltage", "Shoot lightning forward for up to &y&150% damage.", sprSkill)

Electrocutioner.endingQuote = "..and so he left, with a spark of uncertainty."

callback.register("onSkinInit", function(player, skin)
	if skin == Electrocutioner then
		player:getData().skin_skill1Override = true
		player:getData()._EfColor = Color.fromHex(0xA6EAEA)
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(152, 12, 0.042)
		else
			player:survivorSetInitialStats(102, 12, 0.012)
		end
		player:setSkill(1,
		"Deadly Voltage",
		"Shoot lightning forward for up to 150% damage.",
		sprSkill, 1, 23)
	end
end)
survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == Electrocutioner then
		player:survivorLevelUpStats(5, -2, 0.002, 1)
	end
end)
survivor:addCallback("onSkill", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	if SurvivorVariant.getActive(player) == Electrocutioner then
		if skill == 1 then
			if relevantFrame == 1 then
				player:getData().skin_onActivity = true
				sShoot:play(1 + math.random() * 0.2)
				if not player:survivorFireHeavenCracker(1.4) then
					for i = 0, playerAc.sp do
							local lightning = obj.ChainLightning:create(player.x + 10 * player.xscale, player.y + math.random(-4, 2))
							lightning:set("parent", player.id)
							lightning:set("bounce", 3)
							lightning:set("damage", math.round(playerAc.damage * 0.4))
							lightning:set("team", player:get("team"))
							lightning:set("blend", Color.fromHex(0xA6EAEA).gml)
						bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 125, 0.7, nil, DAMAGER_BULLET_PIERCE)
						bullet:set("skin_electricDamage", 1)
						bullet:set("stun", 0.4)
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end
			end
		end
		
	end
end)