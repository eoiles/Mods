local relicColor = Color.fromHex(0xC649AD)

local itRelicForce = Item.new("Relic of Force") 
local parRelicForce = par.FloatingRocks
itRelicForce.pickupText = "Huge damage boost BUT greatly reduced attack speed and higher cooldowns." 
itRelicForce.sprite = Sprite.load("RelicForce", "Items/Resources/Relic of Force.png", 1, 14, 14)
itp.relic:add(itRelicForce)
itRelicForce.color = relicColor
itRelicForce:setLog{
	group = "end",
	description = "&y&Increase your damage by 100% &p&BUT &r&reduce your attack speed and cooldowns by 40%.",
	story = "Nothing in life is free. This strange object glows with a power I can only harness with concentration. I can become vigorous, unstoppable, but I will never be the same ever again, I lost something and I can't recall what it was... Once again, nothing in life was free.",
	priority = "&b&Field-Found&!&",
	destination = "Unknown",
	date = "Unknown"
}
itRelicForce:addCallback("pickup", function(player)
	player:set("attack_speed", math.max(player:get("attack_speed") * 0.6, 0.03))
	player:set("cdr", player:get("cdr") - 0.4)
	player:set("damage", player:get("damage") * 2)
end)
callback.register("onItemRemoval", function(player, item, amount)
	if item == itRelicForce then
		player:set("attack_speed", player:get("attack_speed") / (0.6 ^ amount))
		player:set("cdr", player:get("cdr") + 0.4 * amount)
		player:set("damage", player:get("damage") / (2 ^ amount))
	end
end)

callback.register ("onPlayerDraw", function(player)
	local relicForce = player:countItem(itRelicForce)
	if relicForce > 0 and math.chance(7) then
		if global.quality > 1 then
			if math.chance(50) then
				parRelicForce:burst("below", player.x, player.y + 1, 1, relicColor)
			else
				parRelicForce:burst("below", player.x, player.y + 1, 1, Color.fromRGB(122,122,122))
			end
		end
	end
end)