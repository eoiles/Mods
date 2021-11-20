local relicColor = Color.fromHex(0xC649AD)

local itRelicGratification = Item.new("Relic of Gratification")
sRelicGratification = Sprite.load("RelicGratificationDisplay", "Items/Resources/relicGratificationdis.png", 1, 18, 18)
itRelicGratification.pickupText = "Enemies drop 50% more experience and gold BUT enemies deal 50% more damage to you." 
itRelicGratification.sprite = Sprite.load("RelicGratification", "Items/Resources/Relic of Gratification.png", 1, 10, 13)
itp.relic:add(itRelicGratification)
itRelicGratification.color = relicColor
itRelicGratification:setLog{
	group = "end",
	description = "&y&Enemies drop 150% experience and gold &p&BUT &r&enemies deal 150% damage to you.",
	story = "As I started to think the universe wasn't compensating my effort I stumbled upon a new challenge, which delivered great wealth, at the cost of my own blood.",
	priority = "&b&Field-Found&!&",
	destination = "Unknown",
	date = "Unknown"
}


table.insert(call.preHit, function(damager, hit)
	local damagerParent = damager:getParent()
	if damagerParent and damagerParent:isValid() then
		local damagerAc = damager:getAccessor()
		local hitAc = hit:getAccessor()
		if isa(damagerParent, "PlayerInstance") then
			local relicGratification = damagerParent:countItem(itRelicGratification)
			if relicGratification > 0 then
				if hitAc.hp < damagerAc.damage then
					if hitAc.exp_worth then
						hitAc.exp_worth = math.min(hitAc.exp_worth * (0.25 + (relicGratification * 0.25)), 5000000)
					end
				end
			end
		elseif isa(damagerParent, "ActorInstance") and damagerParent:get("team") == "enemy" then
			if isa(hit, "PlayerInstance") then
				local relicGratification = hit:countItem(itRelicGratification)
				if relicGratification > 0 then
					damagerAc.damage = damagerAc.damage * (0.25 + (relicGratification * 0.25))
				end
			end
		end
	end
end)

callback.register ("onPlayerDraw", function(player)
	local relicGratification = player:countItem(itRelicGratification)
	if relicGratification > 0 then
		graphics.drawImage{image = sRelicGratification, x = player.x, y = player.y, alpha = 0.25}
	end
end)