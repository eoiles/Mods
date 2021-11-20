Sprite.reload=function(name,...)

	return Sprite.find(name)

end


local path = "Survivors/Huntress/Skins/AHuntress/"

local survivor = sur.Huntress
local sprSelect = Sprite.reload("AHuntressSelect", path.."Select", 16, 2, 0)
local Arbator = SurvivorVariant.new(survivor, "Arbator", sprSelect, {
	idle = Sprite.reload("AHuntressIdle", path.."Idle", 1, 3, 5),
	idlehalf = Sprite.reload("AHuntressIdleHalf", path.."IdleHalf", 1, 3, 5),
	walk = Sprite.reload("AHuntressWalk", path.."Walk", 8, 4, 5),
	walkhalf = Sprite.reload("AHuntressWalkHalf", path.."WalkHalf", 8, 4, 5),
	jump = Sprite.reload("AHuntressJump", path.."Jump", 1, 3, 6),
	climb = Sprite.reload("AHuntressClimb", path.."Climb", 2, 2, 6),
	death = Sprite.reload("AHuntressDeath", path.."Death", 10, 14, 3),
	decoy = Sprite.reload("AHuntressDecoy", path.."Decoy", 1, 9, 18),
	
	shoot1 = Sprite.reload("AHuntressShoot1", path.."Shoot1", 9, 6, 6),
	shoot2 = Sprite.reload("AHuntressShoot2", path.."Shoot2", 9, 10, 7),
	shoot4 = Sprite.reload("AHuntressShoot4", path.."Shoot4", 10, 15, 12),
	shoot5 = Sprite.reload("AHuntressShoot5", path.."Shoot5", 10, 15, 12),
}, Color.fromHex(0xFFFFFF))

SurvivorVariant.setInfoStats(Arbator, {{"Strength", 9}, {"Vitality", 3}, {"Toughness", 1}, {"Agility", 3}, {"Difficulty", 3}, {"Temperament", 6}})
SurvivorVariant.setDescription(Arbator, "A lower firerate but two extra arrow for every attack makes the &y&Arbator&!& a highly versatile alternative to common archery.")
Arbator.forceApply = true

Arbator.endingQuote = "..and so she left, unwilling to relive the catastrophe."

-- local sprSkill = Sprite.reload("ArbalistSkill", path.."Skill", 1, 0, 0)
local sprOriginalSkills = spr.Huntress1Skills
local sprSkill = Sprite.reload("NemesisHuntressSkill", path.."Skill", 1, 0, 0)

local sShoot = sfx.HuntressShoot1

SurvivorVariant.setLoadoutSkill(Arbator, "Triple Serving", "Each &b&attack ability &y&fires two extra arrow in front of you.", sprSkill)


callback.register("onSkinInit", function(player, skin)
	if skin == Arbator then
		player:set("pHmax", player:get("pHmax") - 0.05)
		player:set("pVmax", player:get("pVmax") + 0.5)
		player:set("attack_speed", player:get("attack_speed") - 0.4)
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(148, 10.5, 0.05)
		else
			player:survivorSetInitialStats(98, 10.5, 0.02)
		end
		player:setSkill(1,
		"Triple Serving",
		"Fire three arrows for 120% damage. You can shoot while moving.",
		sprOriginalSkills, 1, 43)
		player:setSkill(2,
		"Laser Glaives",
		"Throw three glaives that bounce to up to 4 enemies for 300% damage. Increases by 30% per bounce",
		sprOriginalSkills, 2, 60 * 4)
		player:setSkill(4,
		"Triple Serving",
		"Fire three explosive arrows for 320% damage. The arrows drop bomblets that detonate for 6x80%.",
		sprOriginalSkills, 4, 60 * 7)
	end
end)
survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == Arbator then
		player:survivorLevelUpStats(3, -0.5, 0, -0.5)
		player:set("attack_speed", player:get("attack_speed") - 0.025)
	end
end)




me=function ()
	for _, player in ipairs(misc.players) do
		if player:get("name") == "Arbator" then
			return player
		end
	end
end

n=0
x=3
h=3

obj.HuntressBolt1:addCallback("create", function(self)
	n=n+1
	if  n <x and me() then
		bullet = obj.HuntressBolt1:create(self.x  , self.y-h)
		bullet:set("parent", me().id)
		bullet:set("direction", me():getFacingDirection())
	else
		n=0
	end
end)
obj.HuntressBoomerang:addCallback("create", function(self)
	n=n+1
	if  n <x and me() then
		bullet = obj.HuntressBoomerang:create(self.x  , self.y-h)
		bullet:set("parent", me().id)
		bullet:set("direction", me():getFacingDirection())
	else
		n=0
	end
end)
obj.HuntressBolt2:addCallback("create", function(self)
	n=n+1
	if  n <x and me() then
		bullet = obj.HuntressBolt2:create(self.x  , self.y-h)
		bullet:set("parent", me().id)
		bullet:set("direction", me():getFacingDirection())
	else
		n=0
	end
end)
obj.HuntressBolt3:addCallback("create", function(self)
	n=n+1
	if  n <x and me() then
		bullet = obj.HuntressBolt3:create(self.x  , self.y-4)
		bullet:set("parent", me().id)
		bullet:set("direction", me():getFacingDirection())
	else
		n=0
	end
end)
