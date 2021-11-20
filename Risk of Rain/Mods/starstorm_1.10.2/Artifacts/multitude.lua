local path = "Artifacts/Resources/"

-- Multitude
ar.Multitude = Artifact.new("Multitude")
ar.Multitude.loadoutSprite = Sprite.load("Multitude", path.."multitude", 2, 18, 18)
ar.Multitude.loadoutText = "Enemies come in hordes."
ar.Multitude.pickupSprite = Sprite.load("MultitudePickup", path.."multitudePickup", 1, 14, 14)
ar.Multitude.pickupName = "Artifact of Multitude"

obj.MultitudePickup = ar.Multitude:getObject()
rm.UnchartedMountain:createInstance(obj.MultitudePickup, 2816, 3327)
rm.UnchartedMountain:createInstance(obj.ArtifactNoise, 2816, 3327)

table.insert(call.onStep, function()
	local spawn = true
	for _, teleporter in ipairs(obj.Teleporter:findAll()) do
		if teleporter:get("time") >= teleporter:get("maxtime") then
			spawn = false
			break
		end
	end
	if ar.Multitude.active then
		local director = misc.director
		local directorAc = director:getAccessor()
		local directorData = director:getData()
		local mtime = (6500 + directorAc.time_start) / ((#misc.players * 0.3) + 0.7)
		if spawn and misc.getTimeStop() == 0 then
			if not directorData.multitudetimer then
				directorData.multitudetimer = 100
			end
			if directorData.multitudetimer < mtime then
				directorData.multitudetimer = directorData.multitudetimer + 1
				
				if directorData.multitudetimer > mtime - 100 then
					director:set("points", director:get("points") + (directorAc.enemy_buff))
					misc.shakeScreen(40)
					if math.chance(50) and #pobj.enemies:findMatchingOp("team", "==", "enemy") < 60 then
						director:setAlarm(1, 1)
					end
				end
			else
				directorData.multitudetimer = 0
			end
		end
	end
end)

table.insert(call.onHUDDraw, function()
	local director = misc.director
	local directorAc = director:getAccessor()
	local directorData = director:getData()
	local width, height = graphics.getHUDResolution()
	local spawn = true
	for _, teleporter in ipairs(obj.Teleporter:findMatchingOp("active", ">=", 3)) do
		spawn = false
		break
	end
	
	if ar.Multitude.active and misc.hud:get("show_skills") == 1 then
		local mtime = (6500 + directorAc.time_start) / ((#misc.players * 0.3) + 0.7)
		if spawn and directorData.multitudetimer then
			if directorData.multitudetimer < mtime - 200 then
				if directorData.multitudetimer > mtime - 1000 then
					graphics.print("Prepare yourself...", width / 2, height * 0.79, graphics.FONT_DEFAULT, graphics.ALIGN_MIDDLE, graphics.ALIGN_CENTRE)
				elseif directorData.multitudetimer > mtime - 2000 then
					graphics.print("A horde of enemies is approaching.", width / 2, height * 0.79, graphics.FONT_DEFAULT, graphics.ALIGN_MIDDLE, graphics.ALIGN_CENTRE)
				end
			end
		end
	end
end)

callback.register("onTrueActorInit", function(actor)
	if actor:isValid() then
		local actorAc = actor:getAccessor()
		
		if ar.Multitude.active then
			if actorAc.team == "enemy" and not actor:isBoss() then
				if actorAc.exp_worth then
					actorAc.exp_worth = actorAc.exp_worth * 0.4
				end
				actorAc.maxhp = actorAc.maxhp * 0.7
				actorAc.armor = actorAc.armor * 0.8
				actorAc.damage = math.round(actorAc.damage * 0.7)
			end
		end
	end
end)