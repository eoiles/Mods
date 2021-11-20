-- if an item is picked by a player
-- all the others get the item too
registercallback("onItemPickup", function(item_inst, player)
	local item = item_inst:getItem()

	for index, a_player in ipairs(misc.players) do

		if a_player ~= nil and a_player:isValid() then

			if player ~= a_player and item.isUseItem == false then
				a_player:giveItem(item, 1)
			end
		end
	end
end)