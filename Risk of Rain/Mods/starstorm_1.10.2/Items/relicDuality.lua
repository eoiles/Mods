local relicColor = Color.fromHex(0xC649AD)

local itRelicDuality = Item.new("Relic of Duality")
local parRelicDuality = par.Fire3
parRelicDuality:color(Color.YELLOW,Color.RED,Color.BLACK)
parRelicDuality:scale(0.6, 0.6)
itRelicDuality.pickupText = "All attacks deal blazing damage BUT all taken damage freezes you." 
itRelicDuality.sprite = Sprite.load("RelicDuality", "Items/Resources/Relic of Duality.png", 1, 13, 14)
itp.relic:add(itRelicDuality)
itRelicDuality.color = relicColor
itRelicDuality:setLog{
	group = "end",
	description = "&y&All attacks deal blazing damage &p&BUT &r&all taken damage freezes you.",
	story = "A strange, yet familiar force was awakened as I approached, a risk to be taken in exchange for valuable power, as every light comes with darkness and every pain comes with great joy.",
	priority = "&b&Field-Found&!&",
	destination = "Unknown",
	date = "Unknown"
}

table.insert(call.preHit, function(damager, hit)
	local damagerParent = damager:getParent()
	if damagerParent and damagerParent:isValid() then
		local damagerAc = damager:getAccessor()
		
		if isa(damagerParent, "PlayerInstance") then
			local relicDuality = damagerParent:countItem(itRelicDuality)
			if relicDuality > 0 then
				DOT.applyToActor(hit, DOT_FIRE, damagerAc.damage * 0.4, relicDuality * 6, "relicDuality", false)
			end
		elseif isa(damagerParent, "ActorInstance") and damagerParent:get("team") == "enemy" then
			if isa(hit, "PlayerInstance") then
				local relicDuality = hit:countItem(itRelicDuality)
				if relicDuality > 0 then
					if not hit:hasBuff(buff.slow) then
						hit:applyBuff(buff.slow, 110)
					else
						damagerAc.freeze = (relicDuality / 2) * 0.5
					end
				end
			end
			
		end
	end
end)

callback.register ("onPlayerDraw", function(player)
	local relicDuality = player:countItem(itRelicDuality)
	if global.quality > 1 and relicDuality > 0 and math.chance(21) then
		parRelicDuality:burst("below", player.x + math.random(-3,3), player.y + math.random(-5,3), 1)
	end
end)