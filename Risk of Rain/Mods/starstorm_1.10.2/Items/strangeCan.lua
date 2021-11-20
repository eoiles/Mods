local path = "Items/Resources/"

it.StrangeCan = Item.new("Strange Can")
local parStrangeCan = par.Radioactive
local sStrangeCan = Sound.load("StrangeCan", path.."strangeCan")
it.StrangeCan.pickupText = "Chance to intoxicate enemies." 
it.StrangeCan.sprite = Sprite.load("StrangeCan", path.."Strange Can.png", 1, 14, 11)
it.StrangeCan:setTier("uncommon")
it.StrangeCan:setLog{
	group = "uncommon",
	description = "Chance to &y&intoxicate&!& enemies, causing &r&damage over time&!&.",
	story = "These are as delicious as I told you, I just hope it doesn't crack open on the way there like the last one.\nI should get a job...",
	destination = "1530,\n563,\nA-LC12",
	date = "05/22/2056"
}
it.StrangeCan:addCallback("pickup", function(player)
	player:set("strangeCan", (player:get("strangeCan") or 0) + 1)
end)
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.StrangeCan then
		player:set("strangeCan", player:get("strangeCan") - amount)
	end
end)

table.insert(call.onFireSetProcs, function(damager, parent)
	local strangeCan = parent:get("strangeCan")
	if strangeCan and strangeCan > 0 then
		damager:set("intoxicate", strangeCan)
	end
end)

table.insert(call.onHit, function(damager, hit)
	local damagerAc = damager:getAccessor()
	
	if damagerAc.intoxicate and math.chance(3.5 + (5 * damagerAc.intoxicate)) then
		if onScreen(hit) then
			sStrangeCan:play(0.9 + math.random() * 0.2)
		end
		applySyncedBuff(hit, buff.intoxication, 5 * 60, true)
	end
end)

callback.register ("onPlayerDraw", function(player)
	local strangeCan = player:countItem(it.StrangeCan)
	if global.quality > 1 and strangeCan > 0 and math.chance(10) then
		parStrangeCan:burst("below", player.x + math.random(-5, 5), player.y + math.random(-5, 3), 1)
	end
end)