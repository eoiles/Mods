local path = "Items/Resources/"

it.GildedOrnament = Item.new("Gilded Ornament")
it.GildedOrnament.pickupText = "A miracle?" 
it.GildedOrnament.sprite = Sprite.load("GildedOrnament", path.."Gilded Ornament.png", 1, 15, 15)
it.GildedOrnament.color = "p"

it.GildedOrnament:addCallback("pickup", function(player)
	
end)
table.insert(call.onPlayerStep, function(player)
	local count = player:countItem(it.GildedOrnament)
	if count > 0 then
		local playerAc = player:getAccessor()
		playerAc.sp = 1
		playerAc.sp_dur = 5
	end
end)
