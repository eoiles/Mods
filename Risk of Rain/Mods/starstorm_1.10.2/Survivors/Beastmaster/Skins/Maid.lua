-- Maid

local path = "Survivors/Beastmaster/Skins/Maid/"

local survivor = Survivor.find("Chirr", "Starstorm")
local sprSelect = Sprite.load("MaidSelect", path.."Select", 15, 2, 0)

local Maid = SurvivorVariant.new(survivor, "Maid", sprSelect, {
	idle = Sprite.load("Maid_Idle", path.."idle", 1, 12, 11),
	walk = Sprite.load("Maid_Walk", path.."walk", 8, 13, 13),
	jump_2 = Sprite.load("Maid_Jump", path.."jump", 1, 11, 13),
	flight = Sprite.load("Maid_Flight", path.."flight", 1, 11, 15),
	wings = Sprite.load("Maid_Wings", path.."wings", 3, 11, 15),
	climb = Sprite.load("Maid_Climb", path.."climb", 2, 11, 10),
	death = Sprite.load("Maid_Death", path.."death", 8, 16, 11),
	decoy = Sprite.load("Maid_Decoy", path.."decoy", 1, 9, 10),
	
	shoot1 = Sprite.load("Maid_Shoot1", path.."shoot1", 5, 17, 11),
	shoot2 = Sprite.load("Maid_Shoot2", path.."shoot2", 7, 23, 11),
	shoot3 = Sprite.load("Maid_Shoot3", path.."shoot3", 13, 19, 27),
	shoot4 = Sprite.load("Maid_Shoot4", path.."shoot4", 10, 3, 4),
}, Color.fromHex(0x96B161))
SurvivorVariant.setInfoStats(Maid, {{"Strength", 4}, {"Vitality", 5}, {"Toughness", 2}, {"Agility", 8}, {"Difficulty", 5}, {"Healing", 10}, {"Cleanliness", 10}})
SurvivorVariant.setDescription(Maid, "&y&Maid Chirr&!& is eager to serve!")

local sprSkills = Sprite.load("MaidSkills", path.."Skills", 2, 0, 0)

Maid.endingQuote = "..and so she left, pleased to be of service."

local halloweenSave = save.read("hday1")
if not global.halloween and not global.rormlflag.ss_enable_maid and not halloweenSave then
	Maid.hidden = false
end

callback.register("onSkinInit", function(player, skin)
	if skin == Maid then
		local playerData = player:getData()
		
		playerData.skill4IconOverride = {sprite = sprSkills, index = 1}
		player:setSkillIcon(4, sprSkills, 1)

		player:setSkill(3, "Prime Natural Link", "50% chance befriend the enemy or 30% if it's a boss.Infinite maximum amount",
			sprSkills, 6, 10 * 60)

	end
end)


local sShoot4 = Sound.find("Beastmaster_Shoot3A")

-- function MakeTamed(actor, parent) -- this function sucks bad
-- 	local actorAc = actor:getAccessor()
-- 	parent:getData().tameChild_elite = actor:getElite()
-- 	actorAc.tameParent = parent.id
-- 	if not actorAc.parent then
-- 		actorAc.parent = parent.id
-- 	end
-- 	actorAc.persistent = 1
-- 	actorAc.show_boss_health = 0
-- 	actorAc.tamed = 1
-- 	actorAc.team = parent:get("team")
-- 	actorAc.name = "Friendly "..actorAc.name
-- 	actorAc.maxhp = actorAc.maxhp * 1.25
-- 	actorAc.hp = actorAc.maxhp
-- 	if actorAc.damage then
-- 		actorAc.damage = actorAc.damage * 1.25
-- 	end
-- 	actorAc.knockback_cap = actorAc.maxhp * 0.75
-- 	actor:getData().still_timer = 0
-- 	actor:getData().jumpTimer = 0
-- 	parent:getData().tameChild = actor
-- 	parent:getData().tameObject = actor:getObject()
-- 	actor:getData().parent = parent
	
-- 	if misc.hud:get("boss_id") == actor.id then
-- 		misc.hud:set("boss_id", -4)
-- 	end
	
-- 	for _, itemData in ipairs(parent:getData().items) do
-- 		NPCItems.giveItem(actor, itemData.item, itemData.count)
-- 	end
-- 	copyParentVariables(actor, parent)
	
-- 	local nearenemy = pobj.enemies:findMatchingOp("team", "~=", actorAc.team)
-- 	if nearenemy and isa(nearenemy, "ActorInstance") then
-- 		actorAc.target = nearenemy
-- 	end
-- 	if modloader.checkFlag("ss_no_elites") and not modloader.checkFlag("ss_disable_elites") then
-- 		actor.blendColor = Color.LIGHT_GREEN
-- 	else
-- 		tameSetElite(actor)
-- 	end
	
-- 	local providenceObjects = {[obj.Boss1] = true, [obj.Boss3] = true}
-- 	if providenceObjects[actor:getObject()] and not net.online then
-- 		friendProvidence(actor)
-- 	end
	
-- 	if actor:getObject() == obj.GiantJelly then
-- 		for _, leg in ipairs(obj.JellyLegs:findMatching("parent", actor.id)) do
-- 			leg:set("persistent", 1)
-- 			for _, leg2 in ipairs(obj.JellyLegs:findMatching("parent", leg.id)) do
-- 				leg2:set("persistent", 1)
-- 				for _, leg3 in ipairs(obj.JellyLegs:findMatching("parent", leg2.id)) do
-- 					leg3:set("persistent", 1)
-- 				end
-- 			end
-- 		end
-- 	elseif actor:getObject() == obj.JellyG2 then
-- 		for _, leg in ipairs(obj.JellyLegs:findMatching("parent", actor.id)) do
-- 			leg:set("persistent", 1)
-- 			for _, leg2 in ipairs(obj.JellyLegs:findMatching("parent", leg.id)) do
-- 				leg2:set("persistent", 1)
-- 			end
-- 		end
-- 	end
-- end

local syncTamed = net.Packet.new("sSSTamedActor", function(player, actor, parent)
	local actorI = actor:resolve()
	local parentI = parent:resolve()
	if actorI and actorI:isValid() and parentI and parentI:isValid() then
		makeTamed(actorI, parentI)
	end
end)

local hostSyncTamed = net.Packet.new("sSSTamedActor2", function(player, actor, parent)
	local actorI = actor:resolve()
	local parentI = parent:resolve()
	if actorI and actorI:isValid() and parentI and parentI:isValid() then
		syncTamed:sendAsHost(net.ALL, nil, actor, parent)
		makeTamed(actorI, parentI)
	end
end)

local tameBlacklist = {
	[obj.LizardF] = true,
	[obj.LizardFG] = true,
	[obj.Turtle] = true,
	[obj.Worm] = true,
	[obj.WormBody] = true,
	[obj.WormHead] = true,
	[obj.WurmBody] = true,
	[obj.WurmHead] = true
}

if obj.ArcherBugHive then
	tameBlacklist[obj.ArcherBugHive] = true
end
if obj.TotemPart then
	tameBlacklist[obj.TotemPart] = true
end
if obj.Arraign1 then
	tameBlacklist[obj.Arraign1] = true
	tameBlacklist[obj.Arraign2] = true
end


-- SurvivorVariant.setSkill(Maid, 4, function(player)

	
-- 	local playerAc = player:getAccessor()
	
-- 	local display = obj.EfSparks:create(player.x, player.y - 15)
-- 	display.sprite = player:getAnimation("shoot4")
-- 	display.yscale = 1
-- 	sShoot4:play(0.9 + math.random() * 0.07, 0.8)	
-- 	if player:getData().TlastHit and player:getData().TlastHit:isValid() then
-- 		local actor = player:getData().TlastHit
-- 		local actorAc = actor:getAccessor()
-- 		if actorAc.team ~= playerAc.team and not tameBlacklist[actor:getObject()] and not isa(actor, "PlayerInstance") then
-- 			if true or actor:isBoss() == false and actorAc.show_boss_health == 0 and actorAc.hp <= actorAc.maxhp * 0.5 or playerAc.scepter > 0 and actorAc.hp <= actorAc.maxhp * 0.3 then
-- 				if net.online then
-- 					if net.localPlayer == player then
-- 						if net.host then
-- 							makeTamed(actor, player)
-- 							syncTamed:sendAsHost(net.ALL, nil, actor:getNetIdentity(), player:getNetIdentity())
-- 						else
-- 							hostSyncTamed:sendAsClient(actor:getNetIdentity(), player:getNetIdentity())
-- 						end
-- 					end
-- 				else
-- 					makeTamed(actor, player)
-- 				end
-- 			end
			
-- 		end
-- 	end

-- end)
local actors = pobj.actors
local sShoot3a = Sound.find("Beastmaster_Shoot2A")
local sShoot3b = Sound.find("Beastmaster_Shoot2B")

survivor:addCallback("onSkill", function(player, skill, relevantFrame)

	if string.find(player:get("name"),"Maid") then
		player:set("name","Maid")
		
	local playerAc = player:getAccessor()
	if skill == 3 and not player:getData().skin_skill3Override then
        -- Headbutt
		local range = 150
		
		local size = player:getData().skillCircleAnim
		if relevantFrame < player.sprite.frames - 1 then
			if size then
				player:getData().skillCircleAnim = math.approach(size, 1, (1 - size) * 0.2)
			else
				player:getData().skillCircleAnim = 0
			end
			size = player:getData().skillCircleAnim
			if	player:getData().skillCircle then
				player:getData().skillCircle.radius = size * range -- ugly code ugh.
			end
		end

		if relevantFrame > 0 and relevantFrame < player.sprite.frames - 1 then
			local power = relevantFrame / (player.sprite.frames - 1)
			player:getData().skillCircle = {alpha = power, color = Color.mix(Color.WHITE, Color.DAMAGE_HEAL, power), radius = size * range}
			if relevantFrame == 1 then
				sShoot3a:play(0.9 + math.random() * 0.07, 0.7)
			end
        elseif relevantFrame == player.sprite.frames - 1 then
			sShoot3b:play(0.9 + math.random() * 0.07, 0.8)
			player:getData().skillCircle = nil
			for _, actor in ipairs(actors:findAllEllipse(player.x - range, player.y - range, player.x + range, player.y + range)) do
				if actor:get("team") == player:get("team") then
					if not actor:get("dead") or actor:get("dead") == 0 then 
						par.HealPixel:burst("above", actor.x, actor.y, 1, Color.DAMAGE_HEAL)
						local dif = actor:get("maxhp") - actor:get("hp")
						local heal = (actor:get("maxhp") * 0.25)
						actor:set("hp", actor:get("hp") + heal)
						if not isaDrone(actor) then
							actor:applyBuff(buff.chirrHeal, 360)
						end
						if dif > 0 then
							local circle = obj.EfCircle:create(actor.x, actor.y)
							circle:set("radius", 0.1)
							circle:set("rate", 5)
							circle.blendColor = Color.DAMAGE_HEAL
							if global.showDamage then
								misc.damage(math.min(heal, dif), actor.x, actor.y - 7, false, Color.DAMAGE_HEAL)
							end
						end
						if not isa(actor, "PlayerInstance") then
							actor:setAlarm(6, math.max(360, actor:getAlarm(6)))
						end
					end


					
					-- if net.online then
					-- 	if net.localPlayer == player then
					-- 		if net.host then
					-- 			makeTamed(actor, player)
					-- 			syncTamed:sendAsHost(net.ALL, nil, actor:getNetIdentity(), player:getNetIdentity())
					-- 		else
					-- 			hostSyncTamed:sendAsClient(actor:getNetIdentity(), player:getNetIdentity())
					-- 		end
					-- 	end
					-- else
					-- 	makeTamed(actor, player)
					-- end
					
					
				else
					
					local display = obj.EfSparks:create(player.x, player.y - 15)
					display.sprite = player:getAnimation("shoot4")
					display.yscale = 1
					sShoot4:play(0.9 + math.random() * 0.07, 0.8)
					local actorAc = actor:getAccessor()

					--growths
					if actorAc.team ~= playerAc.team and not tameBlacklist[actor:getObject()] and not isa(actor, "PlayerInstance") then
						if actor:isBoss() == false and actorAc.show_boss_health == 0 and math.random() <= 0.5 or playerAc.scepter > 0 and math.random() <= 0.3 then
							if net.online then
								if net.localPlayer == player then
									if net.host then
										makeTamed(actor, player)
										syncTamed:sendAsHost(net.ALL, nil, actor:getNetIdentity(), player:getNetIdentity())
									else
										hostSyncTamed:sendAsClient(actor:getNetIdentity(), player:getNetIdentity())
									end
								end
							else
								makeTamed(actor, player)
							end
						end
						
					end

				end
			end
			player:getData().skillCircleAnim = 0
			local circle = obj.EfCircle:create(player.x, player.y)
			circle:set("radius", range)
			circle.blendColor = Color.DAMAGE_HEAL
		end
		
	end

end
end)