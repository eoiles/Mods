local path = "Items/Resources/"


it.Insecticide = Item.new("Insecticide")
local sInsecticide = Sound.load("Insecticide", path.."insecticide")
it.Insecticide.pickupText = "All attacks deal poison damage." 
it.Insecticide.sprite = Sprite.load("Insecticide", path.."Insecticide.png", 1, 10, 15)
it.Insecticide:setTier("rare")
it.Insecticide:setLog{
	group = "rare_locked",
	description = "All dealt damage is &y&poisonous&!&, inflicting &r&damage over time.",
	story = "I heard you were having trouble with the 'quitoes, this stuff is wonderful! I always keep two in reserve so I wanted to give you one; it'll save you a bunch of troubles.\nI recommend applying it in the corners, works everytime!",
	priority = "&y&Volatile&!&",
	destination = "d3,\nMimnat,\nEarth",
	date = "04/02/2056"
}
it.Insecticide:addCallback("pickup", function(player)
	player:set("insecticide", (player:get("insecticide") or 0) + 1)
end)
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.Insecticide then
		player:set("insecticide", player:get("insecticide") - amount)
	end
end)

table.insert(call.onFireSetProcs, function(damager, parent)
	local insecticide = parent:get("insecticide")
	if insecticide then
		damager:set("insecticide", insecticide)
	end
end)

table.insert(call.onHit, function(damager, hit)
	local damagerAc = damager:getAccessor()
	
	local insecticide = damagerAc.insecticide
	if insecticide and insecticide > 0 and damagerAc.damage > 0 then
		if onScreen(hit) then
			sInsecticide:play(0.9 + math.random() * 0.2, 0.65)
		end
		DOT.applyToActor(hit, DOT_POISON, damagerAc.damage * 0.175, 2 + (2 * insecticide), "insecticide", true)
	end	
end)