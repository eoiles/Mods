local path = "Items/Resources/"

it.LifetimeFortune = Item.new("")
it.LifetimeFortune.pickupText = "Begin each stage with extra gold." 
it.LifetimeFortune.sprite = Sprite.load("", path..".png", 1, 15, 15)
it.LifetimeFortune:setTier("uncommon")
it.LifetimeFortune:setLog{
	group = "uncommon",
	description = "&y&Grants gold&!& on entering a stage. The amount scales over time.",
	story = "",
	priority = "&b&Field-Found&!&",
	destination = "R#2,\nYacks St.,\nEarth",
	date = "Unknown"
}

table.insert(call.onStageEntry, function()
	for _, player in ipairs(misc.players) do
		if not net.online or net.localPlayer == player then
			local lifetimeFortune = player:countItem(it.LifetimeFortune)
			if lifetimeFortune > 0 then
				local bonusGold = math.ceil((misc.director:get("enemy_buff") - 0.5) * (75 + 100 * lifetimeFortune))
				misc.setGold(misc.getGold() + bonusGold)
			end
		end
	end
end)