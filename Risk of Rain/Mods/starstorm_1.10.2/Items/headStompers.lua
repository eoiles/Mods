if not global.rormlflag.ss_og_headstompers then
it.Headstompers.pickupText = "Hurt enemies by falling, hold down to fall faster."

table.insert(call.onPlayerStep, function(player)
	local playerAc = player:getAccessor()
	
	local headstompers = player:countItem(it.Headstompers)
	if headstompers > 0 then
		if playerAc.free == 1 and playerAc.ropeDown == 1 then
			playerAc.pVspeed = playerAc.pVspeed + (0.25 * headstompers)
		end
	end
end)
end