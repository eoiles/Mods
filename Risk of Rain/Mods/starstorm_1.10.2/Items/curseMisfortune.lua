local path = "Items/Resources/"

it.CurseMisfortune = Item.new("Curse of Misfortune")
it.CurseMisfortune.pickupText = "Downgrade nearby items."
it.CurseMisfortune.sprite = Sprite.load("CurseMisfortune", path.."Curse of Misfortune.png", 1, 15, 15)
itp.curse:add(it.CurseMisfortune)
it.CurseMisfortune.color = "dk"

callback.register("onItemRemoval", function(player, item, amount)
	if item == it.CurseMisfortune and player:countItem(it.CurseMisfortune) == 0 then
		local playerData = player:getData()
		local playerAc = player:getAccessor()
		if playerData.curseMisfortune then
			playerAc.hp_regen = playerAc.hp_regen + playerData.curseMisfortune
			playerData.curseMisfortune = nil
		end
	end	
end)

local r = 50

table.insert(call.onPlayerStep, function(player)
	if net.host then
		local playerData = player:getData()
		local playerAc = player:getAccessor()
		local curseMisfortune = player:countItem(it.CurseMisfortune)
		if curseMisfortune > 0 then
			for _, item in ipairs(pobj.items:findAllEllipse(player.x - r, player.y - r, player.x + r, player.y + r)) do
				if not item:getData().misfortune then
					local bitem = item:getItem()
					local toCreate
					local x, y = item.x, item.y
					if bitem.color == "r" then
						if curseMisfortune > 1 then
							toCreate = itp.common
						else
							toCreate = itp.uncommon
						end
						syncDestroy(item)
						item:destroy()
					elseif bitem.color == "g" then
						toCreate = itp.common
						syncDestroy(item)
						item:destroy()
					elseif bitem.color == "y" and not bitem == it.DivineRight then
						if curseMisfortune > 1 then
							toCreate = itp.common
						else
							toCreate = itp.uncommon
						end
						syncDestroy(item)
						item:destroy()
					end
					if toCreate then
						local newItem = toCreate:roll():create(x, y)
						newItem:getData().misfortune = true
					end
				end
			end
		end
	end
end)