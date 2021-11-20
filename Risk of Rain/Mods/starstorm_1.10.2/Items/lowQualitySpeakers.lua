local path = "Items/Resources/"

it.LowQualitySpeakers = Item.new("Low Quality Speakers")
local sLowQualitySpeakers = Sound.load("LowQualitySpeakers", path.."lowQualitySpeakers")
it.LowQualitySpeakers.pickupText = "Gain a speed boost below half your health." 
it.LowQualitySpeakers.sprite = Sprite.load("LowQualitySpeakers", path.."Low Quality Speakers.png", 1, 10, 12)
it.LowQualitySpeakers:setTier("uncommon")
it.LowQualitySpeakers:setLog{
	group = "uncommon",
	description = "Gain a &b&55% speed boost&!& while at below 50% health.",
	story = "Congratulations [REDACTED]! Thank you for participating in our monthly raffle, this is your prize, in case you have any doubts or for further information on your product visit RERAFFLES.mul/help.",
	destination = "Floor 2,\nBetween Ridy & Low,\nEarth",
	date = "03/30/2058"
}
it.LowQualitySpeakers:addCallback("pickup", function(player)
	player:set("speakers", (player:get("speakers") or 0) + 1)
end)
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.LowQualitySpeakers then
		player:set("speakers", player:get("speakers") - amount)
	end
end)

table.insert(call.onPlayerStep, function(actor)
	local actorData = actor:getData()
	local actorAc = actor:getAccessor()
	
	local lowQualitySpeakers = actorAc.speakers
	if lowQualitySpeakers and lowQualitySpeakers > 0 then
		if actorAc.hp < actorAc.maxhp * 0.5 then 
			if not actorData.lqc then
				local add = 0.2 + 0.35 * lowQualitySpeakers
				actorData.lqc = add
				
				sLowQualitySpeakers:play(0.9 + math.random() * 0.2)
				
				actorAc.pHmax = actorAc.pHmax + add
			end
		elseif actorData.lqc then
			actorAc.pHmax = actorAc.pHmax - actorData.lqc
			actorData.lqc = nil
		end
	end
end)


callback.register ("onPlayerDraw", function(player)
	local playerData = player:getData()
	
	-- Low Quality Speakers
	local lowQualitySpeakers = player:countItem(it.LowQualitySpeakers)
	if lowQualitySpeakers > 0 then
		if not playerData.lqc then
			if playerData.speakersCounter then
				if playerData.speakersCounter >= math.pi * 2 then
					playerData.speakersCounter = 0
				else
					playerData.speakersCounter = math.min(playerData.speakersCounter + 0.1, math.pi * 2)
				end
				graphics.color(Color.WHITE)
				graphics.alpha(math.cos(playerData.speakersCounter)-0.73)
				graphics.circle(player.x, player.y - 3, math.cos(playerData.speakersCounter - 1) * 25 , true)
				graphics.circle(player.x, player.y - 3, math.sin(playerData.speakersCounter) * 50 , true)
				
			else
				playerData.speakersCounter = 0
			end
		else
			graphics.drawImage{
				image = player.sprite,
				x = player.x + math.random(-10, 10) * 0.1,
				y = player.y + math.random(-10, 10) * 0.1,
				xscale = player.xscale,
				yscale = player.yscale,
				angle = player.angle,
				alpha = player.alpha * 0.4,
				solidColor = Color.WHITE,
				subimage = player.subimage
			}
		end
	end
end)