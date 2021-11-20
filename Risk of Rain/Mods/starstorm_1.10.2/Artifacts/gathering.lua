local path = "Artifacts/Resources/"

-- Gathering
ar.Gathering = Artifact.new("Gathering")
ar.Gathering.loadoutSprite = Sprite.load("Gathering", path.."gathering", 2, 18, 18)
ar.Gathering.loadoutText = "Money is worth 200% but it must be picked up."
ar.Gathering.pickupSprite = Sprite.load("GatheringPickup", path.."gatheringPickup", 1, 14, 14)
ar.Gathering.pickupName = "Artifact of Gathering"

obj.GatheringPickup = ar.Gathering:getObject()
rm.Overgrowth:createInstance(obj.GatheringPickup, 176, 660)
rm.Overgrowth:createInstance(obj.ArtifactNoise, 196, 660)

table.insert(call.onStep, function()
	if ar.Gathering.active then
		local teleActive = nil
		for _, teleporter in ipairs(obj.Teleporter:findAll()) do
			if teleporter:get("active") >= 3 then
				teleActive = true
				break
			end
		end
		for _, gold in ipairs(obj.EfGold:findAll()) do
			local data = gold:getData()
			if not data.edited then
				data.edited = true
				gold:set("value", gold:get("value") * 2)
				gold:set("target", -4)
				data.life = 1000
			end
			if gold:getAlarm(1) ~= -1 then
				gold:setAlarm(1, -1)
			end
			local n = 0
			while gold:collidesMap(gold.x, gold.y) and n < 20 do
				gold.y = gold.y - 1
				n = n + 1
			end
			if data.life > 0 then
				data.life = data.life - 1
				if data.life < 100 and data.life % 10 < 2 then
					gold.visible = false
				else
					gold.visible = true
				end
			else
				gold:destroy()
			end
		end
	else
		local dif = misc.director:get("enemy_buff")
		for _, gold in ipairs(obj.EfGold:findAll()) do
			if not gold:getData().edited then
				gold:getData().edited = true
				if dif > 8 then
					local val = gold:get("value")
					misc.setGold(misc.getGold() + val)
					gold:destroy()
				end
			end
		end
	end
end)