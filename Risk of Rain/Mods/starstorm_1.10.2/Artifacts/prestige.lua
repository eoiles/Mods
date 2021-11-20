local path = "Artifacts/Resources/"

-- Prestige
ar.Prestige = Artifact.new("Prestige")
ar.Prestige.loadoutSprite = Sprite.load("Prestige", path.."prestige", 2, 18, 18)
ar.Prestige.loadoutText = "A tenth of the enemies spawn as Blighted."
ar.Prestige.pickupSprite = Sprite.load("PrestigePickup", path.."prestigePickup", 1, 14, 14)
ar.Prestige.pickupName = "Artifact of Prestige"

obj.PrestigePickup = ar.Prestige:getObject()
rm.SlateMinesVariant:createInstance(obj.PrestigePickup, 313, 400)
rm.SlateMinesVariant:createInstance(obj.ArtifactNoise, 313, 400)

local function makePrestigeBlight(actor, blight)
	local actorAc = actor:getAccessor()
	if not actor:getData().arEcho then
		if actorAc.prefix_type == 1 then
			if actorAc.elite_type ~= elt.Empyrean.id then
				for _, elt in ipairs(EliteType.findAll()) do
					if elt.id == actorAc.elite_type then
						actorAc.name = string.gsub(actorAc.name, elt.displayName.." ", "")
						break
					end
				end
			end
		end
		actorAc.name = string.gsub(actorAc.name, "Blighted ", "")
		
		actorAc.prefix_type = 2
		actorAc.blight_type = blight
		actorAc.maxhp = actorAc.maxhp * 5
		actorAc.hp = actorAc.maxhp
		if actorAc.damage then
			actorAc.damage = actorAc.damage * 3
		end
		if actorAc.exp_worth then
			actorAc.exp_worth = actorAc.exp_worth * 0.75
		end
		actorAc.name = "Blighted "..actorAc.name
		actorAc.name2 = "Phantasm"
		if not obj.WurmController:find(1) then
			actorAc.show_boss_health = 1
		end
	end
end

local syncPrestigeBlight = net.Packet.new("SSPrestigeBlight", function(player, inst, blight)
	if inst then
		local insti = inst:resolve()
		if insti and insti:isValid() then
			makePrestigeBlight(insti, blight)
		end
	end
end)

local blacklist = {
	[obj.ImpM] = true,
	[obj.WormBody] = true,
	[obj.WormHead] = true,
	[obj.WurmBody] = true,
	[obj.WurmHead] = true,
	[obj.WurmController] = true,
	[obj.Boss1] = true,
	[obj.Boss2Clone] = true,
	[obj.Boss3] = true,
	[obj.LizardF] = true,
	[obj.LizardFG] = true
}
if obj.SquallElver then
	blacklist[obj.SquallElver] = true
	blacklist[obj.SquallElverC] = true
end
if obj.TotemPart then
	blacklist[obj.TotemPart] = true
	blacklist[obj.TotemController] = true
end

callback.register("onTrueActorInit", function(actor)
	if ar.Prestige.active and Stage.getCurrentStage() ~= stg.Unknown then
		if net.host and math.chance(10) and actor:get("team") == "enemy" and actor:get("prefix_type") ~= 2 and not actor:getData().arEcho and not actor:getData().isNemesis then
			if not blacklist[actor:getObject()] then
				if not actor:isBoss() or misc.director:get("stages_passed") > 1 then
					local actorAc = actor:getAccessor()
					
					local blightType = table.irandom({3, 5, 7, 11, 13})
					makePrestigeBlight(actor, blightType)
					
					if net.host then
						actor:getData().prestigeTimer = 15
					end
				end
			end
		end
	end
end)
callback.register("onActorStep", function(actor)
	local actorData = actor:getData()
	
	if actorData.prestigeTimer then
		if actorData.prestigeTimer > 0 then
			actorData.prestigeTimer = actorData.prestigeTimer - 1
		else
			syncPrestigeBlight:sendAsHost(net.ALL, nil, actor:getNetIdentity(), actor:get("blight_type"))
			actorData.prestigeTimer = nil
		end
	end
end)