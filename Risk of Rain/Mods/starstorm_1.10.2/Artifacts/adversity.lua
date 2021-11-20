local path = "Artifacts/Resources/"

-- Adversity
ar.Adversity = Artifact.new("Adversity")
ar.Adversity.loadoutSprite = Sprite.load("Adversity", path.."adversity", 2, 18, 18)
ar.Adversity.loadoutText = "Every fifth stage has an ethereal teleporter."
ar.Adversity.pickupSprite = Sprite.load("AdversityPickup", path.."adversityPickup", 1, 14, 13)
ar.Adversity.pickupName = "Artifact of Adversity"

obj.AdversityPickup = ar.Adversity:getObject()
rm.void1_1:createInstance(obj.AdversityPickup, 1480, 326)
rm.void1_1:createInstance(obj.ArtifactNoise, 1480, 326)

local syncEth = net.Packet.new("SSEthTele", function(player, teleporter)
	local teleporterI = teleporter:resolve()
	if teleporterI and teleporterI:isValid() then
		makeEthereal(teleporterI)
	end
end)

local stageBlacklist = {
	[stg.Void] = true,
	[stg.VoidShop] = true,
	[stg.PaulsLand] = true,
	[stg.BoarBeach] = true,
	[stg.RedPlane] = true
}

callback.register ("postStageEntry", function(stage)
	if ar.Multitude.active then
		misc.setGold(misc.getGold() * 2)
	end
	if ar.Adversity.active and net.host then
		if (runData.adversityStageCount) % 5 == 0 and runData.adversityStageCount > 0 and not stageBlacklist[stage] then
			for _, teleporter in ipairs(obj.Teleporter:findAll()) do
				if teleporter:isValid() and not teleporter:get("isBig") then
					makeEthereal(teleporter)
					syncEth:sendAsHost(net.ALL, nil, teleporter:getNetIdentity())
					break
				end
			end
		end
	end
end)