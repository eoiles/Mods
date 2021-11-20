if not global.rormlflag.ss_og_lantern then
-- Better Lantern
it.SafeguardLantern.pickupText = "Hold a lantern that fears and damages enemies for 10 seconds"
it.SafeguardLantern:setLog{description = "Carry a lantern for 10 seconds. &r&Fears&!& and damges enemies for &y&20% damage."}
obj.EfLantern.sprite = Sprite.load("EfLantern", "Gameplay/EfLantern", 1, 2, 10)
obj.EfLantern.depth = -10
obj.EfLantern:addCallback("create", function(self)
	local nearestPlayer = obj.P:findNearest(self.x, self.y)
	self:getData().parent = nearestPlayer
end)
table.insert(call.onStep, function()
	for _, lantern in ipairs(obj.EfLantern:findAll()) do
		local parent = lantern:getData().parent
		if parent and parent:isValid() then
			lantern:set("team", parent:get("team"))
			lantern.x = parent.x
			lantern.y = parent.y + 6
		end
	end
end)
end