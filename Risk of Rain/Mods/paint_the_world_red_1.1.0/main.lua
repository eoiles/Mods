local artifact = Artifact.new("Painted")
artifact.unlocked = true
artifact.loadoutSprite = Sprite.load("RedArtifact.png", 2, 18, 18)
artifact.loadoutText = "All items are replaced with Rare items."
		common_pool = ItemPool.find("common")
		uncommon_pool = ItemPool.find("uncommon")
		rare_pool = ItemPool.find("rare")

	local comitems = common_pool:toList()
	local uncomitems = uncommon_pool:toList()
	local comitemsrep = common_pool:toList()
	local uncomitemsrep = uncommon_pool:toList()
	local rareitems = rare_pool:toList()
registercallback("onGameStart", function()
    if artifact.active then
		
		for _, v in ipairs(comitemsrep) do
			ItemPool.find("common", "vanilla"):remove(Item.find(v:getName()))
		end
		for _, v in ipairs(uncomitemsrep) do
			ItemPool.find("uncommon", "vanilla"):remove(Item.find(v:getName()))
		end

		for _, v in ipairs(rareitems) do
			ItemPool.find("common", "vanilla"):add(Item.find(v:getName()))
			ItemPool.find("uncommon", "vanilla"):add(Item.find(v:getName()))
		end
	end
end)
registercallback("onGameEnd", function()
    if artifact.active then
		for _, v in ipairs(comitems) do
			ItemPool.find("common", "vanilla"):add(Item.find(v:getName()))
		end
		for _, v in ipairs(uncomitems) do
			ItemPool.find("uncommon", "vanilla"):add(Item.find(v:getName()))
		end
		for _, v in ipairs(rareitems) do
			ItemPool.find("common", "vanilla"):remove(Item.find(v:getName()))
			ItemPool.find("uncommon", "vanilla"):remove(Item.find(v:getName()))
		end
	end
end)
