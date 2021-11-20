if not global.rormlflag.ss_no_enemies and not global.rormlflag.ss_disable_enemies then
	-- NEMESIS MERCENARY
	
	local path = "Survivors/Mercenary/Skins/Nemesis/"
	
	local survivor = sur.Mercenary
	local sprSelect = Sprite.load("NemesisMercenarySelect", path.."Select", 18, 2, 0)
	local NemesisMercenary = SurvivorVariant.new(survivor, "Nemesis Mercenary", sprSelect, {
		idle = Sprite.find("NemesisMercenaryIdle", "Starstorm"),
		walk = Sprite.find("NemesisMercenaryWalk", "Starstorm"),
		jump = Sprite.find("NemesisMercenaryJump", "Starstorm"),
		climb = Sprite.find("NemesisMercenaryClimb", "Starstorm"),
		death = Sprite.find("NemesisMercenaryDeath", "Starstorm"),
		decoy = Sprite.load("NemesisMercenaryDecoy", path.."Decoy", 1, 9, 18),
		
		shoot1 = Sprite.find("NemesisMercenaryShoot1", "Starstorm"),
		shoot2_1 = Sprite.find("NemesisMercenaryShoot2_1", "Starstorm"),
		shoot2_2 = Sprite.find("NemesisMercenaryShoot2_2", "Starstorm"),
		shoot3 = Sprite.find("NemesisMercenaryShoot3", "Starstorm"),
		shoot4_1 = Sprite.load("NemesisMercenaryShoot4A", path.."Shoot4A", 15, 19, 7),
		shoot4_2 = Sprite.find("NemesisMercenaryShoot4B", "Starstorm"),
		shoot5_1 = Sprite.load("NemesisMercenaryShoot5A", path.."Shoot5A", 23, 38, 20),
		shoot5_2 = Sprite.load("NemesisMercenaryShoot5B", path.."Shoot5B", 24, 19, 7),
	}, Color.fromHex(0xFC4E45))
	SurvivorVariant.setInfoStats(NemesisMercenary, {{"Strength", 7}, {"Vitality", 6}, {"Toughness", 3}, {"Agility", 6}, {"Difficulty", 3}, {"Mercy", 1}})
	SurvivorVariant.setDescription(NemesisMercenary, "The &y&Nemesis Mercenary&!&'s origins are unknown, but something is clear, he's not who he used to be.")
	
	NemesisMercenary.endingQuote = "..and so he left, carrying new sense of humanity within."
	
	local sprSparks = spr.Sparks9r
	local sprSkills = Sprite.load("NemesisMercenarySkill", path.."Skill", 2, 0, 0)
	local sShoot1 = Sound.find("NemesisMercenaryShoot1", "Starstorm")
	local sShoot2 = Sound.find("NemesisMercenaryShoot2", "Starstorm")

	SurvivorVariant.setLoadoutSkill(NemesisMercenary, "Blade of Cessation", "Cut through close enemies for &y&230% bleeding damage.", sprSkills)
	SurvivorVariant.setLoadoutSkill(NemesisMercenary, "Distant Gash", "Slash forward in a line forward for &y&180% bleeding damage&!&.", sprSkills, 2)
	
	callback.register("onSkinInit", function(player, skin)
		if skin == NemesisMercenary then
			player:set("pHmax", player:get("pHmax") + 0.1)
			if Difficulty.getActive() == dif.Drizzle then
				player:survivorSetInitialStats(165, 11, 0.041)
			else
				player:survivorSetInitialStats(115, 11, 0.011)
			end
			player:setSkill(1,
			"Blade of Cessation",
			"Swing a blade for 230% bleeding damage at close range.",
			sprSkills, 1, 39)
			player:setSkill(2,
			"Distant Gash",
			"Slash forward in a line forward for 180% bleeding damage.",
			sprSkills, 2, 3 * 60)
		end
	end)
	survivor:addCallback("levelUp", function(player)
		if SurvivorVariant.getActive(player) == NemesisMercenary then
			player:survivorLevelUpStats(4, 0, -0.001, 0)
		end
	end)
	SurvivorVariant.setSkill(NemesisMercenary, 1, function(player)
		SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1"), 0.2, true, true)
	end)
	SurvivorVariant.setSkill(NemesisMercenary, 2, function(player)
		SurvivorVariant.activityState(player, 2, player:getAnimation("shoot2_1"), 0.2, true, true)
	end)
	callback.register("onSkinSkill", function(player, skill, relevantFrame)
		if SurvivorVariant.getActive(player) == NemesisMercenary then
			local playerAc = player:getAccessor()
			if skill == 1 then
				if relevantFrame == 1 then
					sShoot1:play(1 + math.random() * 0.2)
					if not player:survivorFireHeavenCracker(2.3) then
						for i = 0, playerAc.sp do
							local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 25, 2.3, nil, DAMAGER_BULLET_PIERCE)
							bullet:getData().skin_spark = sprSparks
							bullet:set("bleed", bullet:get("bleed") + 0.2)
							if i ~= 0 then
								bullet:set("climb", i * 8)
							end
						end
					end
				end
			elseif skill == 2.01 then
				if relevantFrame == 1 then
					sShoot2:play(0.9 + math.random() * 0.2)
					local slash = obj.NemesisSlash:create(player.x + player.xscale * 3, player.y + 6)
					slash:getData().direction = player.xscale
					slash:getData().parent = player
					slash:getData().team = player:get("team")
				end
			end
		end
	end)
end