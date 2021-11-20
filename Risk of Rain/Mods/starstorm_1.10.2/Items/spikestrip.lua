if not global.rormlflag.ss_og_spikestrip then
-- Better Spikestrip
it.Spikestrip.pickupText = "Drop spikestrip on being hit, slowing and bleeding enemies."
it.Spikestrip:setLog{description = "When hit, drop spikestrips that &y&slow and bleed enemies by 20% speed and 25% damage&!&."}
obj.EfSpikestrip:addCallback("create", function(self)
	local nearestPlayer = obj.P:findNearest(self.x, self.y)
	self:getData().parent = nearestPlayer
end)
table.insert(call.onStep, function()
	for _, spikestrip in ipairs(obj.EfSpikestrip:findAll()) do
		local data = spikestrip:getData()
		if not data._updated then
			data._updated = true
			local parent = obj.P:findNearest(spikestrip.x, spikestrip.y)
			if parent and parent:isValid() then
				data.team = parent:get("team")
				data.damage = parent:get("damage") * 0.25
				data.timer = 1
			end
		elseif data.timer then
			if data.timer > 0 then
				data.timer = data.timer - 1
			else
				data.timer = 60
				misc.fireExplosion(spikestrip.x, spikestrip.y, 16/ 19, 10 / 4, data.damage, data.team):set("bleed", 1)
			end
		end
	end
end)
end 