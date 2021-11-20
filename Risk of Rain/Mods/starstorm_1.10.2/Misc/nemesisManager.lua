local nemesisData = {}
local nemesisList = {}
if obj.NemesisCommando then
nemesisData = {
	[obj.NemesisCommando] = {aura = 1, dialogue = {txt = {"*Radio chatter*", "...", "*Unintelligible*"}, portrait = {spr.NemesisCommandoPortrait}}},
	[obj.NemesisEnforcer] = {aura = 2},
	[obj.NemesisBandit] = {aura = 3},
	[obj.NemesisHuntress] = {aura = 4},
	[obj.NemesisJanitor] = {aura = 5},
	[obj.NemesisMiner] = {aura = 7},
	[obj.NemesisSniper] = {aura = 8},
	[obj.NemesisExecutioner] = {aura = 13}
}
end
local nemAura = Sprite.load("NemesisAura", "Gameplay/nemesisAura.png", 13, 25, 25)

NemesisBoss = {}
NemesisBoss.add = function(obj)
	nemesisData[obj] = {}
end
export("NemesisBoss")

table.insert(call.onDraw, function()
	for o, d in pairs(nemesisData) do
		if d.aura then
			local i = o:find(1)
			if i and i:isValid() then
				local a = 0.35 + math.sin(global.timer * 0.03) * 0.15
				graphics.drawImage{
					nemAura, i.x, i.y, d.aura, alpha = a
				}
			end
		end
	end
end)

local syncNemesisIndex = net.Packet.new("SSNemIndex", function(player, index, object)
	nemesisList[index] = object
end)

callback.register("onPlayerDeath", function(player)
	local survivor = player:getSurvivor()
	if net.online then
		if player == net.localPlayer then
			save.write("lastDeath", survivor:getName())
		end
	else
		if player == misc.players[1] then
			save.write("lastDeath", survivor:getName())
		end
	end
end)

local survivorToNemesis = {
	["Commando"] = obj.NemesisCommando,
	["Enforcer"] = obj.NemesisEnforcer,
	["Bandit"] = obj.NemesisBandit,
	["Huntress"] = obj.NemesisHuntress,
	["Han-D"] = obj.NemesisJanitor,
	["Miner"] = obj.NemesisMiner,
	["Sniper"] = obj.NemesisSniper,
	["Executioner"] = obj.NemesisExecutioner
}

callback.register("onGameStart", function()
	nemesisList = {}
	if net.host then
		local rollableNemeses = {}
		for o, d in pairs(nemesisData) do
			table.insert(rollableNemeses, o)
		end
		
		local lastDeath = save.read("lastDeath")
		if lastDeath then
			local nemObj = survivorToNemesis[lastDeath]
			local nemIndex
			for i, o in pairs(rollableNemeses) do
				if o == nemObj then
					nemIndex = i
					break
				end
			end
			if nemIndex then
				table.insert(nemesisList, rollableNemeses[nemIndex])
				table.remove(rollableNemeses, nemIndex)
			end
		end
		
		
		local nemCount = #rollableNemeses
		for i = 1, nemCount do
			local indexRoll = math.random(1, #rollableNemeses)
			table.insert(nemesisList, rollableNemeses[indexRoll])
			table.remove(rollableNemeses, indexRoll)
		end
	end
end)
callback.register("postSelection", function()
	if net.host and net.online then
		for i, o in ipairs(nemesisList) do
			syncNemesisIndex:sendAsHost(net.ALL, nil, i, o)
		end
	end
end)
for o, _ in pairs(nemesisData) do
	o:addCallback("destroy", function()
		runData["killed"..o:getName()] = true
	end)
end

local blacklistedStages = {
	[stg.Unknown] = true,
	[stg.Void] = true,
	[stg.VoidShop] = true
}

local voidPortal2Func = setFunc(function(portal)
	local data = portal:getData()
	data.stage = stg.VoidShop
	data.color = Color.fromHex(0x00AEFF)
	data.sprite = spr.VoidPortal2
	data.particles = par.BluePortal
end)

local stageTimer = 0

table.insert(call.onStageEntry, function()
	stageTimer = 0
end)

table.insert(call.onStep, function()
	stageTimer = stageTimer + 1
	
	if not blacklistedStages[Stage:getCurrentStage()] then
		if runData.visitedVoid then
			if stageTimer == 120 then
				if not runData.postEntryTxt then
					runData.postEntryTxt = true
					createDialogue({"...", "What have you done?.."}, {spr.ProvidencePortrait, {spr.ProvidencePortrait, 2}})
				elseif runData.canSpawnNemesis then
					--print((runData.teleCount / 3) + (2 / 3))
					local availableNemesis = nemesisList[(runData.teleCount / 3) + (2 / 3)]
					if availableNemesis then
						local object = availableNemesis
						local data = nemesisData[availableNemesis]
						
						if not runData["killed"..object:getName()] and Stage.getCurrentStage() ~= stg.RedPlane then
							local grounds = {}
							for _, ground in ipairs(obj.B:findAll()) do
								if not obj.TeleporterFake:findEllipse(ground.x - 500, ground.y - 500, ground.x + 500, ground.y + 500) then
									table.insert(grounds, ground)
								end
							end
							local ground = table.irandom(grounds)
							local groundL = ground.x - (ground.sprite.boundingBoxLeft * ground.xscale)
							local groundR = ground.x + (ground.sprite.boundingBoxRight * ground.xscale)
							local x = math.random(groundL, groundR)
							local y = ground.y
							
							if data.dialogue and getRule(5, 18) == true then
								createDialogue(data.dialogue.txt, data.dialogue.portrait, {cameraCutscene, x, y}, {resetCameraCutscene})
							end
							
							if net.host then
								object:create(x, y):set("sync", 1)
							end
							--canSpawnNemesis = false
						end
					end
				end
			end
		end
		local teleDone = nil
		for _, teleporter in ipairs(obj.Teleporter:findAll()) do
			if teleporter:get("active") > 2 then
				if not teleporter:getData().counted then
					teleporter:getData().counted = true
					teleDone = teleporter
					if runData.visitedVoid then
						local preCount = runData.teleCount or 0
						runData.teleCount = preCount + 1
					end
				end
			end
		end
		if teleDone then
			if net.host and getRule(5, 20) == true and getRule(5, 22) == true then
				local chance = (Difficulty.getScaling() - 1) * 1.70 * getRule(5, 23)
				if math.chance(chance) and not runData.visitedVoid then
					local ground = table.irandom(obj.B:findAll())
					local groundL = ground.x - (ground.sprite.boundingBoxLeft * ground.xscale)
					local groundR = ground.x + (ground.sprite.boundingBoxRight * ground.xscale)
					local x = math.random(groundL, groundR)
					local y = ground.y
					
					obj.VoidPortal:create(x, y)
					
					syncInteractableSpawn:sendAsHost(net.ALL, nil, obj.VoidPortal, x, y)
				end
			end
			
			if teleDone:get("isBig") == 1 and getRule(5, 20) ~= false and getRule(5, 24) == true and not teleDone:getData().portalRoll then
				teleDone:getData().portalRoll = true
				
				--if math.chance(50) then
					local ground = table.irandom(obj.B:findAll())
					local groundL = ground.x - (ground.sprite.boundingBoxLeft * ground.xscale)
					local groundR = ground.x + (ground.sprite.boundingBoxRight * ground.xscale)
					local x = math.random(groundL, groundR)
					local y = ground.y
					
					createSynced(obj.VoidPortal, x, y, voidPortal2Func)
				--end
			end
		end
	end
end)