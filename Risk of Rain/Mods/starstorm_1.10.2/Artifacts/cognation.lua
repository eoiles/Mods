local path = "Artifacts/Resources/"

-- Cognation
ar.Cognation = Artifact.new("Cognation")
ar.Cognation.loadoutSprite = Sprite.load("Cognation", path.."cognation", 2, 18, 18)
ar.Cognation.loadoutText = "Enemies create a temporary replica on death."
ar.Cognation.pickupSprite = Sprite.load("CognationPickup", path.."cognationPickup", 1, 14, 14)
ar.Cognation.pickupName = "Artifact of Cognation"

obj.CognationPickup = ar.Cognation:getObject()

local buttons = {}

callback.register("globalRoomStart", function(room)
	if room == rm.StrayTarn then
		buttons = {
			obj.ArtifactButton:create(4193, 1480),
			obj.ArtifactButton:create(4210, 1630),
			obj.ArtifactButton:create(4273, 1753)
		}
	end
end)

local arcomplete = false

table.insert(call.onStep, function()
	if Room.getCurrentRoom() == rm.StrayTarn then
		local c = 0
		for _, i in ipairs(buttons) do
			if arcomplete then
				i:set("activated", 1)
			elseif i:isValid() and i:get("activated") == 1 then
				c = c + 1
			end
		end
		if c == 3 then
			arcomplete = true
			sfx.Achievement:play()
			obj.CognationPickup:create(4194, 1887)
		end
	end
end)

local makeCognate = function(npc)
	local ac = npc:getAccessor()
	ac.maxhp = ac.maxhp * 3
	ac.hp = ac.maxhp
	ac.pHmax = ac.pHmax * 1.25
	ac.damage = ac.damage * 0.9
	ac.exp_worth = ac.exp_worth * 0.5
	ac.knockback_cap = ac.maxhp
	if ac.hit_pitch then
		ac.hit_pitch = ac.hit_pitch * 1.3
	end
	ac.can_drop = 1
	ac.can_jump = 1
	ac.prefix_type = 1
	ac.elite_type = elt.Negative.id
	ac.name = "Cognate "..ac.name
	ac.name2 = "Ephemeral Agony"
	
	if npc:getAlarm(2) then
		npc:setAlarm(2, 60)
	end
	if npc:getAlarm(3) then
		npc:setAlarm(3, 60)
	end
	if npc:getAlarm(4) then
		npc:setAlarm(4, 60)
	end
	if npc:getAlarm(5) then
		npc:setAlarm(5, 60)
	end
	
	npc.alpha = 0.8
	
	if npc:isBoss() or npc:getObject() == obj.TotemPart then
		npc:getData().arLife = 600
	else
		npc:getData().arLife = 300
	end
	
	npc:getData().arEcho = true
end

local echoFunc = setFunc(function(npc)
	npc:set("sync", 0)
	if npc and npc:isValid() then
		makeCognate(npc)
	end
	if npc:getObject() == obj.TotemController then
		for _, part in ipairs(npc:getData().parts) do
			makeCognate(part)
		end
	end
end)

callback.register("onActorStep", function(actor)
	local data = actor:getData()
	if data.arLife then
		if data.arLife > 0 then
			actor.alpha = math.min(data.arLife * 0.1, 0.8)
			if math.chance(data.arLife * 2) then
				par.RainSplash:burst("middle", actor.x, actor.y, 1, Color.RED)
			end
			data.arLife = data.arLife - 1
		else
			if net.online and actor.getNetIdentity then
				if net.host then syncInstanceDelete:sendAsHost(net.ALL, actor:getNetIdentity()) end
			end
			actor:delete()
		end
	end
end)

local blacklist = {
	[obj.Slime] = true,
	[obj.WormHead] = true,
	[obj.ImpM] = true,
	[obj.LizardFG] = true,
	[obj.LizardF] = true,
	[obj.LizardF] = true,
	[obj.Boss1] = true,
	[obj.Boss2Clone] = true,
	[obj.Boss3] = true,
	[obj.WurmHead] = true,
	[obj.WurmBody] = true,
	[obj.WurmController] = true
}
if obj.SquallElver then
	blacklist[obj.SquallElver] = true
end
if obj.TotemPart then
	blacklist[obj.TotemPart] = true
end
if obj.Arraign1 then
	blacklist[obj.Arraign1] = true
	blacklist[obj.Arraign2] = true
end

table.insert(call.onNPCDeathProc, function(npc, player)
	if not net.online or player == net.localPlayer then
		if ar.Cognation.active and not npc:getData().arEcho and npc:get("ghost") == 0 and not npc:getData().isNemesis then
			local object = npc:getObject()
			if not blacklist[object] and npc:get("team") == "enemy" then
				createSynced(object, npc.x, npc.y, echoFunc)
			end
		end
	end
end)