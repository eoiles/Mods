
-- All main Interactable data

local function procFireworks(object, player)
	local fireworks = player:countItem(it.BundleofFireworks)
	if fireworks > 0 then
		local count = 8 + ((fireworks - 1) * 2)
		for i = 1, count do
			local firework = obj.EfFirework:create(object.x, object.y)
			firework:set("damage", player:get("damage") * 3)
		end
		sfx.MissileLaunch:play()
	end
end

table.insert(call.onStep, function()
	for _, crate in ipairs(pobj.commandCrates:findMatchingOp("active", ">=", 2)) do
		local player = Object.findInstance(crate:get("owner"))
		if player and player:isValid() then
			if not crate:getData().fireworkProc and ar.Sacrifice.active then
				procFireworks(crate, player)
				crate:getData().fireworkProc = true
			end
		end
	end
end)

local sprRelicCrate = Sprite.load("RelicCrate", "Interactables/Resources/relicCrate", 1, 12, 16)
local sRelicChest = Sound.load("RelicOpen", "Interactables/Resources/relicChest")
local relicCrate = itp.relic:getCrate()
relicCrate.sprite = sprRelicCrate

local sVoidPortal = Sound.load("VoidPortal", "Interactables/Resources/voidPortal")

local sEscapePod = Sound.load("EscapePod", "Interactables/Resources/escapePod")

local mimicSpawnFunc = setFunc(function(spawn)
	spawn:set("child", obj.Mimic.id)
	spawn:set("sync", 1)
	spawn.sprite = mcard.Mimic.sprite
end)
local commandMimics = not global.rormlflag.ss_disable_command_mimics

local sPylon = Sound.load("PylonActivate", "Interactables/Resources/pylon")
local revivePlayerFunc = function(player, x, y)
	local playerData = player:getData()
	player:set("dead", 0)
	player:set("hp", player:get("maxhp"))
	player:set("following_player_index", -10)
	player:set("activity", 0)
	player:set("activity_type", 0)
	player.mask = spr.PMask
	player.x = x
	player.y = y
	
	player.visible = true
	playerData.beatingHeartHide = nil
end
syncPlayerRevival = net.Packet.new("SSPlayerRevive", function(sender, player, x, y)
	if player then
		local playerI = player:resolve()
		if playerI and playerI:isValid() then
			revivePlayerFunc(playerI, x, y)
		end
	end
end)

_newInteractables = {
	[require("Interactables.activator")] = {
		name = "Activator",
		activation = function(object, player)
			onSSInteractableAction(object, player)
			procFireworks(object, player)
			object.subimage = 1
			object:set("activator", player.id)
			object:set("active", 2)
			object:set("cost", math.ceil(object:get("cost") * 1.5))
			object:getData().timer = 240
			player:activateUseItem(true, object:getData().item)
		end,
		data = {chance = 65, min = 0, max = 2, mpScale = 0, stages = NORMAL_STAGES, ignoreSacrifice = true},
	},
	[require("Interactables.relicShrine")] = {
		name = "Relic Shrine",
		activation = function(object, player)
			onSSInteractableAction(object, player)
			procFireworks(object, player)
			sRelicChest:play()
			object:set("activator", player.id)
			object:set("active", 2)
			object.spriteSpeed = 0.15
			if net.host then
				if ar.Command.active then
					createdItem = relicCrate:create(object.x,object.y - 12)
				else
					createdItem = object:getData().item:create(object.x, object.y - 14)
				end
			end
		end,
		data = {chance = 100, min = 1, max = 1, mpScale = 1, stages = {stg.TempleoftheElders, stg.UnchartedMountain}, ignoreSacrifice = true},
	},
	[require("Interactables.questShrine")] = {
		name = "Quest Shrine",
		activation = function(object, player)
			onSSInteractableAction(object, player)
			procFireworks(object, player)
			sfx.Shrine1:play()
			object:set("activator", player.id)
			object:set("active", 2)
			object.spriteSpeed = 0.15
		end,
		data = {chance = 32, min = 0, max = 3, mpScale = 0.6, stages = NORMAL_STAGES, ignoreSacrifice = false},
	},
	[require("Interactables.deglassifier")] = {
		name = "De-Glassifier",
		activation = function(object, player)
			onSSInteractableAction(object, player)
			object.subimage = 1
			object:set("activator", player.id)
			object:set("active", 2)
			object:getData().timer = 30
			sfx.Frozen:play(0.5)
			if not player:getData().setting_deglassified then
				player:getData().setting_deglassified = true
				player:set("hud_health_color", Color.fromHex(0x88D367).gml)
				player:set("maxhp_base", player:get("maxhp_base") * 10)
				player:set("maxhp", player:get("maxhp_base"))
				player:set("hp", player:get("maxhp"))
				player:set("damage", player:get("damage") / 5)
			end
		end,
	},
	[require("Interactables.voidPortal")] = {
		name = "Void Portal",
		activation = function(object, player)
			onSSInteractableAction(object, player)
			object.subimage = 1
			object:set("activator", player.id)
			object:set("active", 2)
			awaitingVoid = true
			sVoidPortal:play()
			if net.host then
				Stage.transport(object:getData().stage or stg.Void)
			end
		end,
	},
	[require("Interactables.escapePod")] = {
		name = "Broken Escape Pod",
		activation = function(object, player)
			onSSInteractableAction(object, player)
			procFireworks(object, player)
			sEscapePod:play(0.9 + math.random() * 0.2)
			object:set("activator", player.id)
			object:set("active", 2)
			if global.quality > 1 then
				par.Debris:burst("middle", object.x, object.y, 4)
			end
			object:getData().timer = 15
		end,
		data = {chance = 65, min = 0, max = 3, mpScale = 0, stages = NORMAL_STAGES, ignoreSacrifice = false, chanceScaling = - 7}
	},
	[require("Interactables.feralCage")] = {
		name = "Acrid Cage",
		activation = function(object, player)
			object:set("activator", player.id)
			object:set("active", 2)
		end,
	},
	[require("Interactables.swordShrine")] = {
		name = "Sword Shrine",
		activation = function(object, player)
			onSSInteractableAction(object, player)
			sfx.Shrine1:play(0.7)
			procFireworks(object, player)
			object:set("activator", player.id)
			object:set("active", 2)
			object.spriteSpeed = 0.15
			object:getData().activator = player
			
			local items = getTrueItems(player)
			if items and #items > 0 then
				local itd = {}
				object:getData().input = {}
				object:getData()._draw = {}
				
				for i, item in ipairs(items) do
					for ii = 1, item.count do
						table.insert(itd, item.item)
					end
				end
				
				local amount = math.floor(#itd / 4)
				
				for i = 1, amount do
					local index = (i * 4) - 3
					local item = itd[index]
					player:removeItem(item, 1)
					table.insert(object:getData().input, item)
					object:getData()._draw[i] = {x = player.x, y = player.y, item = item}
				end
			end
			
			object:getData().timer = 140
			
			object:getData().useCount = object:getData().useCount + 1
			--for _, itemData in ipairs(items) do
			--	player:removeItem(itemData.item, itemData.count)
			--end
		end,
		data = {chance = 2, min = 0, max = 1, mpScale = 0.5, stages = NORMAL_STAGES, ignoreSacrifice = true},
	},
	[require("Interactables.mimicChest")] = {
		name = "Mimic Chest",
		activation = function(object, player)
			onSSInteractableAction(object, player)
			mcard.Mimic.sound:play(0.9 + math.random() * 0.2)
			object:set("active", 2)
			if net.host then
				createSynced(obj.Spawn, object.x, object.y - 8, mimicSpawnFunc)
			end
			object:destroy()
		end,
		data = {chance = 5, min = 0, max = 3, mpScale = 0.5, stages = NORMAL_STAGES, ignoreSacrifice = commandMimics}
	},
	[require("Interactables.crystal")] = {
		name = "Crystal",
		activation = function(object, player)
			onSSInteractableAction(object, player)
			--procFireworks(object, player)
			object:set("active", 2)
			player:set("activity", 23)
			player:set("activity_type", 1)
			player:set("pHspeed", 0)
			local idleAnim = player:getAnimation("idle")
			if idleAnim then
				player.sprite = player:getAnimation("idle")
			end			
			if not net.online or player == net.localPlayer then
				object:getData().ignoreFrame = 5
			end
		end,
	},
	[require("Interactables.itemChest")] = {
		name = "Item Chest",
		activation = function(object, player)
			local data = object:getData()
			onSSInteractableAction(object, player)
			--procFireworks(object, player)
			object.subimage = 2
			object.spriteSpeed = 0.2
			object:set("activator", player.id)
			object:set("active", 2)
			object:set("cost", math.ceil(object:get("cost") * 2))
			data.uses = data.uses - 1
			sfx.Chest1:play(0.95)
			if net.host then
				for i = 1, data.amount do
					data.item:create(object.x, object.y - 25)
				end
			end
		end,
	},
	[require("Interactables.darkCrystal")] = {
		name = "Dark Crystal",
		activation = function(object, player)
			local data = object:getData()
			onSSInteractableAction(object, player)
			--procFireworks(object, player)
			object.subimage = 2
			object.spriteSpeed = 0.2
			object:set("activator", player.id)
			object:set("active", 2)
			--sfx.Chest1:play(0.95)
			player:giveItem(data.curseItem, 1)
			player:set("item_count_total", player:get("item_count_total") + 1)
			if not net.online or player == net.localPlayer then
				runData.cursePickupDisplay = 180
			end
			player:getData().cursePickupDisplay = {title = data.curseItem.displayName, text = data.curseItem.pickupText, i = 520}
			sfx.CursePickup:play()
			if net.host then
				local item = data.item:create(object.x, object.y - 25)
				item:getData().misfortune = true -- So it doesn't get deleted by the just obtained curse.
				data.item = itp.rare:roll()
				data.curseItem = itp.curse:roll()
				data.synctimer = 0
			end
			data.uses = data.uses - 1
		end,
	},
	[require("Interactables.pylon")] = {
		name = "Pylon",
		activation = function(object, player)
			local objectData = object:getData()
			onSSInteractableAction(object, player)
			procFireworks(object, player)
			sPylon:play()
			object:set("activator", player.id)
			object:set("active", 2)
			
			local flash = obj.EfFlash:create(0,0):set("parent", object.id):set("rate", 0.08)
			flash.alpha = 0.75
			flash.blendColor = Color.RED
			
			runData.pylonTimer = 3600
			
			objectData.targetSize = objectData.targetSize + 4
			
			for _, player in ipairs(misc.players) do
				local playerData = player:getData()
				if playerData.beatingHeartEffect then
					playerData.beatingHeartEffect = false
					
					player.alpha = player.alpha / 0.5
				end
			end
			
			if objectData.count == 0 then
				Quest.setObjective("Escape the planet", "Find a Silver Lining.", nil, nil, true)
				if runData.bossBarHidden then
					misc.hud:set("show_boss", 1)
				end
			elseif objectData.count == 9 then
				Sound.setMusic(sfx.musicStage10)
			end
			
			if net.host then
				if objectData.count > 0 then
					local amountToRevive = math.ceil(objectData.playersCount / 5)
					local count = 0
					local revivedCount = 0
					for _, _ in pairs(objectData.revivedPlayers) do
						revivedCount = revivedCount + 1
					end
					
					local allRevivedOnce = revivedCount >= objectData.deadPlayersCount
					
					for player, _ in pairs(objectData.deadPlayers) do
						if count <= amountToRevive then
							if allRevivedOnce or not objectData.revivedPlayers[player] then
								count = count + 1
								local x, y = object.x, object.y - 7
								syncPlayerRevival:sendAsHost(net.ALL, nil, player:getNetIdentity(), x, y)
								revivePlayerFunc(player, x, y)
							end
						else
							break
						end
					end
					
				end
			end
			objectData.count = objectData.count + 1
		end,
	},
	[require("Interactables.peculiarRock")] = {
		name = "Peculiar Rock",
		activation = function(object, player)
			onSSInteractableAction(object, player)
			object:set("activator", player.id)
			object:set("active", 2)
			if net.host then
				it.PeculiarRock:getObject():create(object.x, object.y - 10)
			end
			object.visible = false
		end,
	},
	[require("Interactables.expChest")] = {
		name = "Experience Chest",
		activation = function(object, player)
			local data = object:getData()
			onSSInteractableAction(object, player)
			procFireworks(object, player)
			object.subimage = 2
			object.spriteSpeed = 0.25
			object:set("activator", player.id)
			object:set("active", 2)
			for i = 1, math.ceil(data.amount) do
				obj.EfExp:create(object.x, object.y - 5):set("value", math.ceil(Difficulty.getScaling() * 3)):set("target", player.id)
			end
			sfx.Chest1:play(1.4)
		end,
	}
}

syncInteractableSpawn = net.Packet.new("SSInteractableSpawn", function(player, interactable, x, y)
	if interactable and x and y then
		local instance = interactable:create(x, y)
	end
end)

syncInteractableActivation = net.Packet.new("SSInteractableActivation", function(player, player, x, y, object)
	if object then
		local playerI = player:resolve()
		local interactableI = object:findNearest(x, y)
		if playerI and playerI:isValid() and interactableI and interactableI:isValid() then
			for obj, int in pairs(_newInteractables) do
				if object == obj then
					int.activation(interactableI, playerI)
				end
			end
		end
	end
end)
hostSyncInteractableActivation = net.Packet.new("SSInteractableActivation2", function(sender, player, x, y, object)
	if object then
		local playerI = player:resolve()
		local interactableI = object:findNearest(x, y)
		if playerI and playerI:isValid() and interactableI and interactableI:isValid() then
			syncInteractableActivation:sendAsHost(net.EXCLUDE, sender, player, x, y, object)
			for obj, int in pairs(_newInteractables) do
				if object == obj then
					int.activation(interactableI, playerI)
				end
			end
		end
	end
end)

-- Interactable Objects

for obj, int in pairs(_newInteractables) do
	Interactable.new(obj, int.name)
	local ssint = SSInteractable.new(obj, int.name)
	if int.data then
		for k, v in pairs(int.data) do
			ssint[k] = v
		end
	end
end