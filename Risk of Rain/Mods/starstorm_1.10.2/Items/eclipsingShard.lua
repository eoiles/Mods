local path = "Items/Resources/"

it.EclipsingShard = Item.new("Eclipsing Shard")
local sEclipsingShard = Sound.load("EclipsingShard", path.."eclipsingShard")
it.EclipsingShard.pickupText = "You feel the void merging with your soul.." 
it.EclipsingShard.sprite = Sprite.load("EclipsingShard", path.."Eclipsing Shard.png", 2, 11, 15)
it.EclipsingShard.isUseItem = true
it.EclipsingShard.useCooldown = 0
it.EclipsingShard.color = "or"
itp.elite:add(it.EclipsingShard)
it.EclipsingShard:setLog{
	group = "use_locked",
	description = "&y&Become an aspect of The Void.",
	story = "I used to be scared of The Void, all I could feel was a sorrow, dreadful feeling of despair, but this... This shard opened a door I will never be able to close, a door towards empathy with the unknown, The Void and everything born from Condemnation.",
	priority = "&b&Field-Found&!&",
	destination = "Unknown",
	date = "Unknown"
}
table.insert(specialUseItems, it.EclipsingShard)
it.EclipsingShard:addCallback("use", function(player)
	sfx.Pickup:stop()
end)
callback.register("postPlayerStep", function(player)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	if player.useItem == it.EclipsingShard or contains(player:getData().mergedItems, it.EclipsingShard) then
		if not playerData.eclipsingShardEf then
			if sEclipsingShard then 
				sEclipsingShard:play(0.7)
			end
			playerAc.void = 1
			playerAc.hit_pitch = 0.5
			playerAc.armor = playerAc.armor + 50
			if not playerAc.malice then
				playerAc.malice = 1
			else
				playerAc.malice = playerAc.malice + 1
			end
			playerData.eclipsingShardEf = true
		end
	elseif playerData.eclipsingShardEf then
		playerData.eclipsingShardEf = nil
		playerAc.void = nil
		playerAc.hit_pitch = 1
		playerAc.armor = playerAc.armor - 50
		playerAc.malice = playerAc.malice - 1
	end
end)
itp.use:remove(it.EclipsingShard)