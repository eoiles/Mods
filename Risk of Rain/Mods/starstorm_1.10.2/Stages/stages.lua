
bkgStages = {
	[stg.DriedLake] = {color = Color.fromHex(0x38465A)},
	[stg.DampCaverns] = {layers = 3},
	[stg.SkyMeadow] = {color = Color.fromHex(0x6166A7)},
	[stg.AncientValley] = {color = Color.fromHex(0x7994A5)},
	[stg.SunkenTombs] = {layers = 3},
	[stg.MagmaBarracks] = {color = Color.fromHex(0x726458), layers = 3},
	[stg.HiveCluster] = {color = Color.fromHex(0x667B42), layers = 3},
	[stg.TempleoftheElders] = {color = Color.fromHex(0xA48D7B)}
}

local stageData = {
	[stg.DesolateForest] = 
	{
		{
			sprite = spr.Stars,
			xParallax = 1,
			yParallax = 1,
			xOffset = 0,
			yOffset = 0,
			xOffsetPercent = 0,
			yOffsetPercent = 0,
			xPattern = true,
			yPattern = true
		},
		{
			sprite = spr.Planets,
			xParallax = 1,
			yParallax = 1,
			xOffset = 0,
			yOffset = 0,
			xOffsetPercent = 0.78,
			yOffsetPercent = 0.02,
			xPattern = false,
			yPattern = false
		},
		{
			sprite = spr.Mountains,
			xParallax = 0.8,
			yParallax = 0.8,
			xOffset = 0,
			yOffset = 0,
			xOffsetPercent = 0,
			yOffsetPercent = 0.9,
			xPattern = true,
			yPattern = false,
			colorFill = Color.fromHex(0x231F34)
		},
		{
			sprite = spr.Clouds2,
			xParallax = 0.8,
			yParallax = 0.7,
			xOffset = -50,
			yOffset = 0,
			xOffsetPercent = 0,
			yOffsetPercent = 0.25,
			xPattern = true,
			yPattern = false,
			alpha = 0.6
		},
		{
			sprite = spr.Clouds2,
			xParallax = 0.7,
			yParallax = 0.6,
			xOffset = 0,
			yOffset = 0,
			xOffsetPercent = 0,
			yOffsetPercent = 0.3,
			xPattern = true,
			yPattern = false
		},
	},
	[stg.AncientValley] = 
	{
		{
			sprite = spr.Stars1_2,
			xParallax = 1,
			yParallax = 1,
			xOffset = 0,
			yOffset = 0,
			xOffsetPercent = 0,
			yOffsetPercent = 0,
			xPattern = true,
			yPattern = true
		},
		{
			sprite = spr.SnowPlanets,
			xParallax = 1,
			yParallax = 1,
			xOffset = 0,
			yOffset = 0,
			xOffsetPercent = 0.8,
			yOffsetPercent = 0.02,
			xPattern = false,
			yPattern = false
		},
		{
			sprite = spr.SnowClouds3,
			xParallax = 0.8,
			yParallax = 1,
			xOffset = -50,
			yOffset = 0,
			xOffsetPercent = 0,
			yOffsetPercent = 0,
			xPattern = true,
			yPattern = false
		},
		{
			sprite = spr.SnowClouds1,
			xParallax = 0.7,
			yParallax =  1,
			xOffset = 0,
			yOffset = 0,
			xOffsetPercent = 0,
			yOffsetPercent = 0,
			xPattern = true,
			yPattern = false
		},
	}
}

local drawables = {pobj.actors, pobj.mapObjects, pobj.items, pobj.commandCrates, obj.Spawn, obj.EfGrenadeEnemy, obj.IfritTower, obj.Elevator}
if obj.ArraignDeath then
	table.insert(drawables, obj.ArraignDeath)
end
obj.mirrorFloor = Object.new("MirrorFloor")
obj.mirrorFloor.depth = 5
obj.mirrorFloor:addCallback("create", function(self)
	self:getData().timer = 0
	self:getData().animate = false
end)
obj.mirrorFloor:addCallback("step", function(self)
	self:getData().timer = self:getData().timer + 1
end)
obj.mirrorFloor:addCallback("draw", function(self)
	if global.quality > 1 then 
		local refraction = 0
		if self:getData().animate then
			refraction = math.sin(self:getData().timer * 0.024) * 0.04
		end
		
		local yadd = 0
		if self:getData().parentWater then
			local parent = self:getData().parentWater
			if parent and parent:isValid() then
				self.y = parent.y - 3
				yadd = parent:get("yy")
			else
				self:destroy()
			end
		end
		
		if not self:getData().normal then
			graphics.setBlendMode("additive")
		end
		if self:isValid() then
			for _, object in ipairs(drawables) do
				for _, instance in ipairs(object:findAll()) do
					if instance.visible and instance.y < self.y + 1 then
						if onScreenPos(instance.x, self.y) then
							if object ~= pobj.items or instance:get("used") == 0 then
								local dif = self.y - instance.y
								
								if instance.sprite then
									graphics.drawImage{
										image = instance.sprite,
										subimage = instance.subimage,
										x = instance.x,
										y = self.y + dif - refraction + (refraction * instance.sprite.height * -1) + (refraction * dif * -1) + yadd,
										xscale = instance.xscale,
										yscale = (instance.yscale * -1) + refraction,
										alpha = instance.alpha * 0.7,
										color = instance.blendColor,
										angle = instance.angle * -1
									}
								end
							end
						end
					end
				end
			end
		end
		if not self:getData().normal then
			graphics.setBlendMode("normal")
		end
	end
end)
if modloader.checkMod("VFXPlus") then
obj.Water:addCallback("create", function(self)
	if global.quality > 2 then
		local mirror = obj.mirrorFloor:create(self.x, self.y)
		mirror:getData().parentWater = self
		mirror:getData().animate = true
		mirror:getData().normal = true
	end
end)
end

bkg = Object.new("DrawBackground")
bkg.depth = 1000
bkg:addCallback("draw", function(self)
	local currentStage = Stage.getCurrentStage()
	
	local layers = stageData[currentStage]
	if self:getData().stage then layers = stageData[self:getData().stage] end
	
	local currentRoom = Room.getCurrentRoom()
	local roomWidth, roomHeight = Stage.getDimensions()
	local cameraWidth, cameraHeight = misc.camera.width, misc.camera.height
	
	local yOffset = 1000
	
	if layers then
		for _, layer in ipairs(layers) do
			local sprite = layer.sprite
			local width = sprite.width
			local height = sprite.height
			
			local xParallax = layer.xParallax
			local yParallax = layer.yParallax
			local xOffset = layer.xOffset
			local yOffset = layer.yOffset
			local xOffsetPercent = layer.xOffsetPercent
			local yOffsetPercent = layer.yOffsetPercent
			local alpha = 1
			if layer.alpha then alpha = layer.alpha end
			
			local xRepeat = 0
			if layer.xPattern then xRepeat = 1 + math.ceil((cameraWidth / xParallax + 0.1) / width) end
			
			local yRepeat = 0
			if layer.yPattern then yRepeat = 1 + math.ceil((cameraHeight / yParallax + 0.1) / height) end
			
			for xx = 0, xRepeat + 1 do
				for yy = 0, yRepeat do
					graphics.drawImage{
						image = sprite,
						x = (misc.camera.x * xParallax) + (cameraWidth * xOffsetPercent) + (xx * width) + xOffset,
						y = (misc.camera.y * yParallax) + (cameraHeight * yOffsetPercent) + (yy * height) + yOffset,
						alpha = alpha
					}
				end
			end
			if layer.colorFill then
				graphics.color(layer.colorFill)
				graphics.alpha(1)
				graphics.rectangle(misc.camera.x, (misc.camera.y * yParallax) + (cameraHeight * yOffsetPercent) + height, misc.camera.x + cameraWidth, misc.camera.y + cameraHeight, false)
			end
		end
	end
end)

------------------------------- VARIANTS --------------------------------

local stage4_3 = rm["4_2_2old"]
stage4_3:createInstance(obj.Deadman, 2956, 432)

stage4_3:createInstance(obj.Geyser, 2024, 736)
stage4_3:createInstance(obj.Geyser, 1094, 736)

for i = 1 , 8 do
	stage4_3:createInstance(obj.B, 32 + (16 * i), 416)
end
for i = 1 , 5 do
	stage4_3:createInstance(obj.BNoSpawn, 48, 416 + (16 * i))
end
for i = 1 , 10 do
	stage4_3:createInstance(obj.B, 160 + (16 * i), 432)
end
stage4_3:createInstance(obj.BNoSpawn, 336, 448)

stg.HiveCluster.rooms:add(stage4_3)

require("Stages.DesolateForest.variant")
stg.DesolateForest.rooms:add(rm.DesolateVariant)

------------------------------- VOID1 --------------------------------

local sprVoidTileset = Sprite.load("VoidTileset", "Stages/Void/voidTileset.png", 1, 0, 0)
local sprVoidTeleporter = Sprite.load("VoidTeleporter", "Stages/Void/voidTele.png", 2, 35, 40)

obj.bkgVoid, obj.bkgVoid2 = require("Stages.Void.Background")

rm.void1_1 = require("Stages.Void.Void1_1")
rm.void1_2 = require("Stages.Void.Void1_2")

stg.Void = Stage.new("The Void")
stg.Void.displayName = "???"
stg.Void.subname = "Somewhere In The Void"
local voidMusic = Sound.load("MusicVoidStage", "Misc/Music/musicVoid")
stg.Void.music = voidMusic
stg.Void.enemies:add(mcard["Evolved Lemurian"])
stg.Void.enemies:add(mcard.Ifrit)
stg.Void.enemies:add(mcard["Archaic Wisp"])
stg.Void.enemies:add(mcard["Elder Lemurian"])
if mcard.Wayfarer then
	stg.Void.enemies:add(mcard.Wayfarer)
end
if mcard.Gatekeeper then
	stg.Void.enemies:add(mcard.Gatekeeper)
end
if mcard.Overseer then
	stg.Void.enemies:add(mcard.Overseer)
end
stg.Void.rooms:add(rm.void1_1)
stg.Void.rooms:add(rm.void1_2)


------------------------------- VOID2 --------------------------------

Sprite.load("Void2Background", "Stages/Void/void2Bkg.png", 1, 0, 0)
local sprVoidTileset2 = Sprite.load("VoidTileset2", "Stages/Void/void2Tileset.png", 1, 0, 0)
local sprVoidTeleporter2 = Sprite.load("VoidTeleporter2", "Stages/Void/void2Tele.png", 2, 35, 40)

rm.void2 = require("Stages.Void.Void2")

stg.VoidShop = Stage.new("The Void Shop")
stg.VoidShop.displayName = "???"
stg.VoidShop.subname = "The Stranger's Hideout"
local voidMusic2 = Sound.load("MusicVoidShopStage", "Misc/Music/musicVoidShop")
stg.VoidShop.music = voidMusic2

stg.VoidShop.rooms:add(rm.void2)

table.insert(call.onStep, function()
	if Stage.getCurrentStage() == stg.VoidShop then
		Sound.setMusic(voidMusic2)
		for _, trail in ipairs(obj.EfTrail:findAll()) do
			trail:destroy()
		end
	end
end)
table.insert(call.onStageEntry, function()
	if Stage.getCurrentStage() == stg.VoidShop then
		if misc.hud:get("show_boss") then
			misc.hud:set("show_boss", 0)
			runData.lastShowBoss = true
		end
	elseif runData.lastShowBoss then
		misc.hud:set("show_boss", 1)
		runData.lastShowBoss = nil
	end
end)


------------------------------- RED PLANE --------------------------------

Sprite.load("rpBack", "Stages/RedPlane/back.png", 1, 0, 0)
Sprite.load("rpFarBottom", "Stages/RedPlane/farBottom.png", 1, 0, 0)
Sprite.load("rpFarTop", "Stages/RedPlane/farTop.png", 1, 0, 0)
Sprite.load("rpMid", "Stages/RedPlane/mid.png", 1, 0, 0)
Sprite.load("rpMidTall", "Stages/RedPlane/midTall.png", 1, 0, 0)
Sprite.load("rpTileset", "Stages/RedPlane/tileset.png", 1, 0, 0)

stg.RedPlane, rm.RedPlane = require("Stages.RedPlane.Stage")
stg.RedPlane.music = sfx.musicStage3


------------------------------- THE UNKNOWN --------------------------------

Sprite.load("UnknownTileset", "Stages/Unknown/tileset.png", 1, 0, 0)
Sprite.load("unBack", "Stages/Unknown/back.png", 1, 0, 0)
Sprite.load("unFill", "Stages/Unknown/fill.png", 1, 0, 0)
Sprite.load("unMid", "Stages/Unknown/mid.png", 1, 0, 0)
Sprite.load("unMountains", "Stages/Unknown/mountains.png", 1, 0, 0)

stg.Unknown, rm.Unknown = require("Stages.Unknown.Stage")
rm.Unknown:createInstance(obj.mirrorFloor, 0, 992)
stg.Unknown.displayName = "???"
stg.Unknown.subname = "Somewhere In Time"
local unknownMusic = Sound.load("MusicUnknownStage", "Misc/Music/musicUnknown")
stg.Unknown.music = unknownMusic

stageGrounds[stg.Unknown] = Sprite.load("Starstorm_GroundStripUN", "Misc/Menus/grounds/groundStrip16", 2, 0, 0)
bkgStages[stg.Unknown] = {color = Color.WHITE}

local enemyBlacklist = {[mcard["Snow Golem"]] = true, [mcard["Jellyfish"]] = true, [mcard["Evolved Lemurian"]] = true, [mcard["Archer Bug"]] = true}

if mcard.SquallElver then
	enemyBlacklist[mcard.SquallElver] = true
	enemyBlacklist[mcard.Mimic] = true
	enemyBlacklist[mcard.ArcherBugHive] = true
end

local enemyBuffBlacklist = {[obj.LizardFG] = true, [obj.LizardF] = true, [obj.Worm] = true, [obj.WormHead] = true, [obj.WormBody] = true}
if obj.Arraign1 then
	enemyBuffBlacklist[obj.Arraign1] = true
	enemyBuffBlacklist[obj.Arraign2] = true
end
local itemBlacklist = {[it.ShellPiece] = true, [it.DiosFriend] = true, [it.FiremansBoots] = true}

local bossNames = {"Natnat", "Bralbral", "Ketket", "Fyzfyz", "Pefpef", "Turatura", "Thethe", "Wecwec", "Eteete", "Niania", "Gtolgtol", "Plipli", "Konkon", "Worwor", "Sabsab", "Nennen", "Plapla", "Afuafu", "Ploplo", "Potopoto", "Perper", "Tonton", "Netsnets", "Poipoi", "Tejtej"} -- suckssucks
local bossAffixes = {
	{name = " The Swift", var = "pHmax", mult = 1},
	{name = " The Unbreakable", var = "armor", mult = 18},

	{name = " The Brisk", var = "attack_speed", mult = 1},
	{name = " The Mighty", var = "damage", mult = 16},
	{name = " The Eternal", var = "maxhp", mult = 2000},
	{name = " The Wise", var = "critical_chance", mult = 25},
}
	--{name = " the Gigantic", var = "size", mult = 1},

local enemySequence = {}
local enemySequenceItems = {}
local currentEnemyIndex = 1

local aeonianBossMusic = Sound.load("MusicUnknownBoss", "Misc/Music/musicUnknownBoss")

local kills = 0

local function getRarityVal(item)
	if item.color == "w" then
		return 1
	elseif item.color == "g" then
		return 2
	elseif item.color == "r" then
		return 4
	else
		return 5
	end
end

local endingGame = false
local aeonianEnding = false 
local aeonianEndingTimer = 0

local function drawEnding1()
	graphics.color(Color.WHITE)
	graphics.alpha(1)
	graphics.rectangle(0, 0, 9999, 9999, false)
end
local sprAeonianEndGraphic = Sprite.load("UnknownEndGraphic", "Stages/Unknown/endingGraphic.png", 1, 0, 0)
local function drawEnding2()
	local w, h = graphics.getGameResolution()
	
	graphics.color(Color.WHITE)
	graphics.rectangle(0, 0, 9999, 100 + h * 0.3, false)
	
	local spr = Sprite.find("unBack")
	if spr then
		for i = 0, 20 do
			graphics.drawImage{
				x = i * spr.width,
				y = 100,
				image = spr
			}
		end
	end
	
	graphics.color(Color.fromHex(0xD7EBED))
	graphics.alpha(1)
	graphics.rectangle(0, 100 + h * 0.5, 9999, 9999, false)
	graphics.drawImage{
		x = 200 + w * 0.5,
		y = 120 + h * 0.5,
		image = sprAeonianEndGraphic
	}
end

local judgementEndType1 = {
	name = "Judgement1",
	draw = drawEnding1,
	quote = "..and so they vanished, nothing was heard of them ever again.",
	music = sfx.musicStage11,
}
local judgementEndType2 = {
	name = "Judgement2",
	draw = drawEnding2,
	quote = "..and so they triumphed, bequeathing the sovereignty.",
	music = sfx.musicStage11,
}
callback.register("onLoad", function()
	judgementEndType1.sound = Sound.find("Wind1", "Starstorm")
	judgementEndType2.sound = Sound.find("Wind1", "Starstorm")
end)

local syncAeonianEnding = net.Packet.new("SSAeonianEnd", function(player, value)
	if not aeonianEnding then
		aeonianEnding = value
		Sound.setMusic(nil)
		if misc.hud:isValid() then
			misc.hud:set("objective_text", "???")
		end
	end
end)

local syncAeonianItem = net.Packet.new("SSAeonianItem", function(player, object, item)
	if object and item then
		if not enemySequenceItems[object] then
			enemySequenceItems[object] = {}
		end
		enemySequenceItems[object][item] = 1
	end
end)

local syncAeonianVals = net.Packet.new("SSAeonianVals", function(player, index)
	currentEnemyIndex = index
	kills = 0
end)

callback.register("postLoad", function()
	mcard["Child"].cost = mcard["Child"].cost + 0.1 
	local enemies = {}
	for _, namespace in ipairs(namespaces) do
		for _, monsterCard in ipairs(MonsterCard.findAll(namespace)) do
			if not enemyBlacklist[monsterCard] then
				table.insert(enemies, monsterCard)
			end
		end
	end
	table.sort(enemies, function (e1, e2) return e1.cost < e2.cost end)
	mcard["Child"].cost = mcard["Child"].cost - 0.1 -- whew 
	enemySequence = enemies
	global.aeonianEnemies = enemySequence
end)
table.insert(call.onStep, function()
	local currentStage = Stage.getCurrentStage()
	
	if currentStage == stg.Unknown then
		
		for _, obj in ipairs(pobj.commandCrates:findAll()) do
			obj:destroy()
		end
		for _, obj in ipairs(obj.EfGold:findAll()) do
			obj:destroy()
		end
		for _, obj in ipairs(obj.EfExp:findAll()) do
			obj:destroy()
		end
		for _, obj in ipairs(pobj.items:findAll()) do
			if obj:getItem() ~= it.DivineRight then
				obj:destroy()
			end
		end
		
		local currentEnemy = enemySequence[currentEnemyIndex]
		
		--if input.checkKeyboard("o") == input.PRESSED then
		--	currentEnemyIndex = currentEnemyIndex + 1
		--end
		
		if currentEnemy or not runData.defeatedArraign then
			for _, actor in ipairs(pobj.actors:findAll()) do
				local actorObj = actor:getObject()
				if actor:get("team") == "enemy" and not enemyBuffBlacklist[ actorObj] then
					if actorObj ~= obj.Slime or actor:get("size_s") == 1 then
						if actor:getData().aeonianBuffed then
							otherNpcItems(actor)
						else
							local actorData = actor:getData()
							if enemySequenceItems[actorObj] then
								local items = enemySequenceItems[actorObj]
								local difScale = ((Difficulty.getScaling() - 0.8) * 1.8)
								for item, _ in pairs(items) do
									--items[item] = math.min(math.ceil(difScale / getRarityVal(item)), 100)
									NPCItems.giveItem(actor, item, math.min(math.ceil(difScale / getRarityVal(item)), 100))
								end
								--copyParentVariables(actor, nil, items)
							end
							if actor:get("damage") then
								actor:set("damage", actor:get("damage") * 2.5)
							end
							if actor:get("pHmax") then
								actor:set("pHmax", actor:get("pHmax") * 1.5)
							end
							actor:set("maxhp", actor:get("maxhp") * 6)
							actor:set("hp", actor:get("maxhp"))
							if actorObj == obj.TotemController then
								for _, part in ipairs(actor:getData().parts) do
									part:set("maxhp", actor:get("maxhp") / 8) 
									part:set("hp", part:get("maxhp"))
								end
							end
							actor:set("knockback_cap", actor:get("maxhp"))
							if actor:get("exp_worth") then
								actor:set("exp_worth", 0)
							end
							actor:getData().aeonianBuffed = true
						end
					end
				end
			end
			if getRule(5, 2) ~= false then
				for _, actor in ipairs(pobj.actors:findAll()) do
					if actor:get("team") == "enemy" and actor:getObject() ~= obj.Arraign1 and actor:getObject() ~= obj.Arraign2 then
						if not actor:getData().aeonianElited then
							local elited = actor:makeElite(elt.Aeonian)
							if elited == false then
								if not string.find(actor:get("name"), "Aeonian") then 
									actor:set("name", "Aeonian "..actor:get("name"))
									actor:set("elite_type", elt.Aeonian.id)
									actor:set("prefix_type", 1)
								end
							end
							actor:set("name", string.gsub(actor:get("name"), "Aeonian Aeonian", "Aeonian"))
							actor:set("name2", "Quiescent Ultimatum")
							actor:set("show_boss_health", 1)
							
							--[[if actor:getObject() == obj.Scavenger then
								local affix = table.irandom(bossAffixes)
								actor:set("name2", "Condemned Endeavor")
								actor:set("maxhp", actor:get("maxhp") * 4)
								actor:set("hp", actor:get("maxhp"))
								if net.host then
									actor:set("name", table.irandom(bossNames)..affix.name)
									actor:set(affix.var, actor:get(affix.var) + (affix.mult * math.min(8, Difficulty.getScaling())))
									syncInstanceVar:sendAsHost(net.ALL, nil, actor:getNetIdentity(), "name", actor:get("name"))
									syncInstanceVar:sendAsHost(net.ALL, nil, actor:getNetIdentity(), affix.var, actor:get(affix.var))
									syncInstanceVar:sendAsHost(net.ALL, nil, actor:getNetIdentity(), "hp", actor:get("maxhp"))
								end
							end]]
							
							actor:getData().aeonianElited = true
						end
					end
				end
				for _, spawn in ipairs(obj.Spawn:findAll()) do
					spawn:set("elite_type", elt.Aeonian.id)
					spawn:set("prefix_type", 1)
				end
			end
			
			for _, wave in ipairs(obj.TurtleWave:findAll()) do
				wave:destroy()
			end
			
			for _, actor in ipairs(pobj.actors:findAll()) do
				if actor:get("team") == "enemy" then
					local target = Object.findInstance(actor:get("target") or -4)
					if target and target:isValid() then
						actor:set("disable_ai", 0)
						if actor:get("moveRight") then
							if target.x > actor.x + 500 then
								actor:set("moveRight", 1)
							elseif target.x < actor.x - 500 then
								actor:set("moveLeft", 1)
							end
						end
					end
				end
			end
		end
		
		if currentEnemy then
			if not currentStage.enemies:contains(currentEnemy) then
				for _, enemy in ipairs(currentStage.enemies:toTable()) do
					currentStage.enemies:remove(enemy)
				end
				currentStage.enemies:add(currentEnemy)
			end
			
			misc.director:set("card_choice", currentEnemy.id)
			
			misc.hud:set("objective_text", "Survive the judgement.")
			
			for _, actor in ipairs(pobj.actors:findAll()) do
				if actor:get("team") == "enemy" then
					if actor:getObject() ~= currentEnemy.object then
						actor:set("show_boss_health", 0)
						--par.Assassin:burst("above", actor.x + math.random(-4, 4), actor.y + math.random(-4, 4), 1)
					end
				end
			end
			
			local calc = math.round(math.clamp((Difficulty.getScaling() * 60) / (currentEnemy.cost * 0.3), 1, 5))
			
			--print(calc, #currentEnemy.object:findAll())
			if #currentEnemy.object:findMatching("team", "enemy") >= calc - kills then
				misc.director:set("points", 0)
				misc.director:setAlarm(1, 100)
			else
				misc.director:set("points", math.clamp(misc.director:get("points") + 1, currentEnemy.cost * 0.5, currentEnemy.cost * 4))
				misc.director:setAlarm(1, math.max(misc.director:getAlarm(1) - 4, 1))
			end
			
			local tele = obj.Teleporter:find(1)
			if tele then
				obj.BossSkill2old:create(tele.x, tele.y):setAlarm(0, 1)
				tele:destroy()
			end
			
			if kills >= calc then
				kills = 0
				sfx.Difficulty:play(0.75)
				currentEnemyIndex = currentEnemyIndex + 1
				if net.host and net.online then
					syncAeonianVals:sendAsHost(net.ALL, nil, currentEnemyIndex)
				end
			end
			
		else
			if net.host and not runData.judgementClear then
				runData.judgementClear = true
				syncAeonianVals:sendAsHost(net.ALL, nil, currentEnemyIndex)
			end
			
			local aliveEnemies = 0
			for _, actor in ipairs(pobj.actors:findAll()) do
				if actor:get("team") == "enemy" then
					aliveEnemies = aliveEnemies + 1
				end
			end
			
			if aliveEnemies <= 0 then
				--local tele = obj.Teleporter:find(1) or obj.Teleporter:create(0, -10)
				--tele:set("active", 4)
				if not runData.doneAllWaves then
					runData.doneAllWaves = true
					-- aeonian unlocks
					for _, player in ipairs(misc.players) do
						if not net.online or net.localPlayer == player then
							local survivor = player:getSurvivor()
							save.write("judgement_"..survivor:getName(), true)
							
							local aSkin = SurvivorVariant.find(survivor, "Anointed "..survivor.displayName)
							if aSkin then
								aSkin.hidden = false
								sfx.Achievement:play()
							end
						end
					end
				end
				if obj.Arraign1 and not runData.defeatedArraign then
					if not runData.spawnedArraign then
						obj.WhiteFlash:create(0, 0)
						Sound.setMusic(aeonianBossMusic)
						local sw, sh = Stage.getDimensions() 
						obj.Arraign1:create(sw * 0.5, 400)
						
						for _, enemy in ipairs(enemySequence) do
							currentStage.enemies:add(enemy)
						end
						
						runData.spawnedArraign = true
					end
				else
					aeonianEnding = 2
					Sound.setMusic(nil)
					misc.hud:set("objective_text", "???")
					
					if net.host and net.online then
						syncAeonianEnding:sendAsHost(net.ALL, nil, 2)
					end
				end
			else
				if #obj.P:findMatching("dead", 0) == 0 then
					Sound.setMusic(nil)
					misc.hud:set("objective_text", "???")
					
					for _, player in ipairs(obj.EfPlayerDead:findAll()) do
						player:set("post_game", 0)
						player:set("show_post_game", 0)
						player:set("death_message", "")
					end
					
					if not aeonianEnding then
						aeonianEnding = 1
						if net.host and net.online then
							syncAeonianEnding:sendAsHost(net.ALL, nil, 1)
						end
					end
				end
			end
			if aeonianEnding then
				if aeonianEndingTimer < 700 then
					aeonianEndingTimer = aeonianEndingTimer + 1
				elseif not endingGame then
					endingGame = true
					if aeonianEnding == 1 then
						endGame(judgementEndType1)
					else
						endGame(judgementEndType2)
					end
				end
			end
		end
	elseif currentStage == stg.RiskofRain then
		local final = obj.CommandFinal:find(1)
		if final and final:isValid() then
			local tele = obj.Teleporter:find(1)
			if tele and tele:isValid() then
				final:set("cost", math.huge)
				if tele:get("active") < 4 then
					tele:set("active", 4)
				elseif tele:get("active") == 5 and net.host then
					Stage.transport(stg.Unknown)
				end
			end
		end
	end
end)
table.insert(call.onHit, function(damager, hit)
	if Stage.getCurrentStage() == stg.Unknown and hit:get("team") == "enemy" then
		damager:set("knockback", 0)
		damager:set("knockup", 0)
		damager:set("knockback_glove", 0)
		damager:set("stun", 0)
	end
end)
table.insert(call.onHUDDraw, function()
	if aeonianEnding then
		local w, h = graphics.getHUDResolution()
		graphics.color(Color.WHITE)
		local calc = math.max(0, (aeonianEndingTimer - 200) / 500)
		graphics.alpha(calc)
		graphics.rectangle(0, 0, w, h)
	end
end)
table.insert(call.onDraw, function()
	if Stage.getCurrentStage() == stg.Unknown then
		graphics.alpha(0.9)
		graphics.color(Color.BLACK)
		for _, missile in ipairs(obj.JellyMissile:findAll()) do
			graphics.circle(missile.x, missile.y, 5, false)
		end
	end
end)
local reenableKin = false
callback.register("onGameEnd", function()
	currentEnemyIndex = 1
	endingGame = false
	aeonianEnding = false
	aeonianEndingTimer = 0
	if reenableKin then
		ar.Kin.active = true
		reenableKin = false
	end
end)
callback.register("onGameStart", function()
	endingGame = false
	aeonianEnding = false
	aeonianEndingTimer = 0
end)
--onNPCDeath.aeonian = function(npc)
table.insert(call.onNPCDeathProc, function(npc, player)
	if getAlivePlayer() == player then
		local currentStage = Stage.getCurrentStage()
		
		local cenemy = enemySequence[currentEnemyIndex]
		local cobj = nil
		if cenemy then
			if cenemy == mcard["Magma Worm"] then
				cobj = obj.WormHead
			elseif mcard.SquallElver and cenemy == mcard.SquallElver then
				cobj = obj.SquallElver
			else
				cobj = cenemy.object 
			end
		end
		
		if currentStage == stg.Unknown and cenemy and npc and npc:get("team") == "enemy" and npc:getObject() == cobj then
			kills = kills + 1
		end
	end
end)

local onUnknown = false

local voidBackgroundBlacklist = {
	[stg.Unknown] = true,
	[stg.RedPlane] = true
}

table.insert(call.onStageEntry, function()
	local currentStage = Stage:getCurrentStage()
	
	misc.hud:set("title_alpha", 0)
	
	if currentStage == stg.Void then
		local flash = obj.WhiteFlash:create(0, 0)
		flash.blendColor = Color.fromHex(0xEB4AF9)
		flash.alpha = 0.7
		flash:set("rate", 0.009)
		local flash = obj.WhiteFlash:create(0, 0)
		flash.depth = flash.depth + 1
		flash.blendColor = Color.BLACK
		flash.alpha = 0.6
		flash:set("rate", 0.003)
		obj.bkgVoid:create(0, 0)
		local spawn = obj.TeleporterFake:find(1)
		if spawn then
			spawn.visible = false
		end
		local tele = obj.Teleporter:find(1)
		if tele and tele:isValid() then
			tele.sprite = sprVoidTeleporter
			tele:set("epic", 0)
			tele:set("maxtime", math.round(tele:get("maxtime") / 60 * 1.5) * 60)
		end
	elseif currentStage == stg.VoidShop then
		local flash = obj.WhiteFlash:create(0, 0)
		flash.blendColor = Color.fromHex(0x00AEFF)
		flash.alpha = 0.7
		flash:set("rate", 0.009)
		local flash = obj.WhiteFlash:create(0, 0)
		flash.depth = flash.depth + 1
		flash.blendColor = Color.BLACK
		flash.alpha = 0.6
		flash:set("rate", 0.004)
		local spawn = obj.TeleporterFake:find(1)
		if spawn then
			spawn.visible = false
		end
		local tele = obj.Teleporter:find(1)
		if tele and tele:isValid() then
			--tele.sprite = sprVoidTeleporter
			tele:set("epic", 0)
			tele:set("maxtime", 1)
		end
	else
		if runData.visitedVoid and not voidBackgroundBlacklist[currentStage] then
			obj.bkgVoid:create(0, 0)
		end
	end
	if currentStage == stg.Unknown then
		if ar.Kin.active then
			reenableKin = true
			ar.Kin.active = false
		end
		runData.visitedUnknown = true
		misc.hud:set("show_gold", 0)
		runData.staticDiff = misc.director:get("enemy_buff")
		if runData.aonianArraignBackup then
			runData.aonianArraignBackup:create(300, 400)
			runData.aonianArraignBackup = nil
		end
		if runData.resetAeonianEnd then
			aeonianEnding = false
			aeonianEndingTimer = 0
			runData.resetAeonianEnd = nil
		end
		if net.host then
			local allItems = {}
			for _, item in ipairs(itp.npc:toList()) do
				if not itemBlacklist[item] then
					table.insert(allItems, item)
				end
			end
			for i, enemy in ipairs(enemySequence) do
				enemySequenceItems[enemy.object] = {}
				local item = table.irandom(allItems)
				enemySequenceItems[enemy.object][item] = 1
				if i > 1 then
					for item, _ in pairs(enemySequenceItems[enemySequence[i - 1].object]) do
						enemySequenceItems[enemy.object][item] = 1
					end
				end
			end
			if net.online then
				for object, items in pairs(enemySequenceItems) do
					for item, _ in pairs(items) do
						syncAeonianItem:sendAsHost(net.ALL, nil, object, item)
					end
				end
			end
		end
		for i = 0, 5 do
			local fakeLava = obj.Lava:create(i * (16 * 60), 992)
			fakeLava:set("damage", 0)
			fakeLava:set("damage_original", 0)
			fakeLava:set("width_b", 60)
			fakeLava:set("lava_timer", 99999999) -- This doesn't really do anything does it? yikes.
			fakeLava:set("lava_timer_previous", 99999999) -- yikesssss.
		end
		toggleElites(originalElites, false)
		toggleElites(newBaseElites, false)
		toggleElites(newHardElites, false)
		toggleElites({elt.Aeonian}, true, true)
		onUnknown = true
		local tele = obj.Teleporter:find(1)
		if tele then tele:destroy() end
	elseif onUnknown then
		onUnknown = false
		toggleElites({elt.Aeonian}, false, true)
	end
end)

table.insert(call.onStep, function()
	local currentStage = Stage:getCurrentStage()
	
	if currentStage == stg.Void then
		if Sound.getMusic() ~= voidMusic then
			Sound.setMusic(voidMusic)
		end
		local tele = obj.Teleporter:find(1)
		if tele and tele:isValid() then
			if tele:get("active") == 3 and not runData.createdTxt then
				runData.createdTxt = true
				createDialogue({"...", "You are fighting against forces you don't understand.", "Your fate is going to be sealed the very moment you go through that teleporter."}, {spr.ProvidencePortrait, spr.ProvidencePortrait})
			end
			if tele:get("active") > 2 and not runData.visitedVoid then
				if getRule(5, 2) ~= false then
					toggleElites(newHardElites, true)
				end
				misc.director:set("enemy_buff", misc.director:get("enemy_buff") + 2)
				runData.canSpawnNemesis = true
				runData.visitedVoid = true
			end
			if tele:get("active") == 1 then
				misc.director:set("points", misc.director:get("points") + 0.15 * Difficulty.getScaling())
			end
		end
		if global.timer % 300 == 0 then
			misc.director:setAlarm(1, misc.director:getAlarm(1) + 20)
		end
		for _, actor in ipairs(pobj.actors:findAll()) do
			if actor:get("team") == "enemy" and actor:getObject() ~= obj.LizardFG and actor:getObject() ~= obj.LizardF then
				if not actor:getData().voidBuffed then
					actor:set("name2", "Spawn of Condemnation")
					if actor:get("damage") then
						actor:set("damage", actor:get("damage") * 1.55)
					end
					actor:set("maxhp", actor:get("maxhp") * 1.35)
					actor:set("hp", actor:get("maxhp"))
					if actor:get("exp_worth") then
						actor:set("exp_worth", actor:get("exp_worth") * 1.4)
					end
					actor:getData().voidBuffed = true
				end
			end
		end
		if getRule(5, 2) ~= false then
			for _, actor in ipairs(pobj.actors:findAll()) do
				if actor:get("team") == "enemy" then
					if not actor:getData().voidElited then
						local elited = actor:makeElite(elt.Void)
						if elited == false then
							if not string.find(actor:get("name"), "Void") then 
								actor:set("name", "Void "..actor:get("name"))
								actor:set("void", 1)
								actor:set("elite_type", elt.Void.id)
								actor:set("prefix_type", 1)
							end
						end
						actor:set("name", string.gsub(actor:get("name"), "Void Void", "Void"))
						actor:getData().voidElited = true
					end
				end
			end
			for _, spawn in ipairs(obj.Spawn:findAll()) do
				spawn:set("elite_type", elt.Void.id)
				spawn:set("prefix_type", 1)
			end
		end
	end
end)

------------------------------- Uncharted Mountain --------------------------------
Sprite.load("umTileset", "Stages/UnchartedMountain/tileset.png", 1, 0, 0)
Sprite.load("umMountains", "Stages/UnchartedMountain/mountains.png", 1, 0, 0)
Sprite.load("umPlanets", "Stages/UnchartedMountain/planets.png", 1, 0, 0)
Sprite.load("umBack", "Stages/UnchartedMountain/back.png", 1, 0, 0)
Sprite.load("umSky1", "Stages/UnchartedMountain/sky1.png", 1, 0, 0)
Sprite.load("umSky2", "Stages/UnchartedMountain/sky2.png", 1, 0, 0)

stg.UnchartedMountain, rm.UnchartedMountain = require("Stages.UnchartedMountain.Stage")

local umMusic = Sound.load("MusicUnchartedMountain", "Misc/Music/musicUnchartedMountain")
stg.UnchartedMountain.music = umMusic

rm.UnchartedMountainVariant = require("Stages.UnchartedMountain.Variant")
stg.UnchartedMountain.rooms:add(rm.UnchartedMountainVariant)

if mcard.Gatekeeper then
	stg.UnchartedMountain.enemies:add(mcard.Gatekeeper)
end
if mcard.Exploder then
	stg.UnchartedMountain.enemies:add(mcard.Exploder)
end
if mcard.Wayfarer then
	stg.UnchartedMountain.enemies:add(mcard.Wayfarer)
end

Stage.progression[5]:add(stg.UnchartedMountain)

stageGrounds[stg.UnchartedMountain] = Sprite.load("Starstorm_GroundStripM", "Misc/Menus/grounds/groundStrip13", 2, 0, 0)
bkgStages[stg.UnchartedMountain] = {color = Color.fromHex(0x705A4E)}

------------------------------- Overgrowth --------------------------------
Sprite.load("ovTileset", "Stages/Overgrowth/tileset.png", 1, 0, 0)
Sprite.load("ovBack", "Stages/Overgrowth/ovBack.png", 1, 0, 0)
Sprite.load("ovMid", "Stages/Overgrowth/ovMid.png", 1, 0, 0)
Sprite.load("ovTrees", "Stages/Overgrowth/ovTrees.png", 1, 0, 0)
Sprite.load("ovTrees2", "Stages/Overgrowth/ovTrees2.png", 1, 0, 0)
Sprite.load("ovTrees3", "Stages/Overgrowth/ovTrees3.png", 1, 0, 0)
stg.Overgrowth, rm.Overgrowth = require("Stages.Overgrowth.Stage")
stg.Overgrowth.music = sfx.musicStage6

rm.OvergrowthVariant = require("Stages.Overgrowth.Variant")
stg.Overgrowth.rooms:add(rm.OvergrowthVariant)

if mcard.Overseer then
	stg.Overgrowth.enemies:add(mcard.Overseer)
end

Stage.progression[4]:add(stg.Overgrowth)

stageGrounds[stg.Overgrowth] = Sprite.load("Starstorm_GroundStripN", "Misc/Menus/grounds/groundStrip14", 2, 0, 0)
bkgStages[stg.Overgrowth] = {color = Color.fromHex(0x38683C), layers = 0}

------------------------------- Slate Mines --------------------------------
Sprite.load("smTileset", "Stages/SlateMines/E slate mine", 1, 0, 0)
Sprite.load("smDustMotes", "Stages/SlateMines/EbDustMotes1", 1, 0, 0)
Sprite.load("smClouds", "Stages/SlateMines/EbSlateClouds1", 1, 0, 0)
Sprite.load("smFar", "Stages/SlateMines/EbSlateFarland1", 1, 0, 0)
Sprite.load("smSpires", "Stages/SlateMines/EbSlateSpires2", 1, 0, 0)
Sprite.load("smStars", "Stages/SlateMines/stars1", 1, 0, 0)

stg.SlateMines, rm.SlateMines = require("Stages.SlateMines.Stage")
stg.SlateMines.music = sfx.musicStage2

rm.SlateMinesVariant = require("Stages.SlateMines.Variant")
stg.SlateMines.rooms:add(rm.SlateMinesVariant)

if mcard.Wayfarer then
	stg.SlateMines.enemies:add(mcard.Wayfarer)
end
if mcard.Overseer then
	stg.SlateMines.enemies:add(mcard.Overseer)
end

stageGrounds[stg.SlateMines] = Sprite.load("Starstorm_GroundStripO", "Misc/Menus/grounds/groundStrip15", 2, 0, 0)
bkgStages[stg.SlateMines] = {color = Color.fromHex(0x738696), layers = 4}
table.insert(call.onStageEntry, function()
	local stage = Stage.getCurrentStage()
	if misc.director:get("stages_passed") == 0 then
		if stage == stg.SlateMines then
			local fakeTele = obj.TeleporterFake:find(1)
			if fakeTele then
				obj.Base:create(fakeTele.x - 60, fakeTele.y)
				fakeTele:destroy()
			end
		end
	end
	if misc.director:get("stages_passed") == 5 then
		if getRule(5, 21) ~= false then
			Stage.progression[2]:add(stg.SlateMines)
		end
	end
end)
callback.register("onGameEnd", function()
	if Stage.progression[2]:contains(stg.SlateMines) then
		Stage.progression[2]:remove(stg.SlateMines)
	end
end)

------------------------------- Torrid Outlands --------------------------------
Sprite.load("toBack", "Stages/TorridOutlands/back.png", 1, 0, 0)
Sprite.load("toArch1", "Stages/TorridOutlands/arch1.png", 1, 0, 0)
Sprite.load("toArch2", "Stages/TorridOutlands/arch2.png", 1, 0, 0)
Sprite.load("toArch3", "Stages/TorridOutlands/arch3.png", 1, 0, 0)
Sprite.load("toClouds", "Stages/TorridOutlands/clouds.png", 1, 0, 0)
Sprite.load("toFront", "Stages/TorridOutlands/front.png", 1, 0, 0)
Sprite.load("toPlanet", "Stages/TorridOutlands/planet.png", 1, 0, 0)
Sprite.load("toSky", "Stages/TorridOutlands/sky.png", 1, 0, 0)
Sprite.load("toTileset", "Stages/TorridOutlands/tileset.png", 1, 0, 0)

stg.TorridOutlands, rm.TorridOutlands = require("Stages.TorridOutlands.Stage")

local toMusic = Sound.load("MusicTorridOutlands", "Misc/Music/musicTorridOutlands")
stg.TorridOutlands.music = toMusic--sfx.musicBoss1c

rm.TorridOutlandsVariant = require("Stages.TorridOutlands.Variant")
stg.TorridOutlands.rooms:add(rm.TorridOutlandsVariant)

if mcard.MechanicalTotem then
	stg.TorridOutlands.enemies:add(mcard.MechanicalTotem)
end

Stage.progression[3]:add(stg.TorridOutlands)

stageGrounds[stg.TorridOutlands] = Sprite.load("Starstorm_GroundStripS", "Misc/Menus/grounds/groundStrip18", 2, 0, 0)
bkgStages[stg.TorridOutlands] = {color = Color.fromHex(0xC5917D), layers = 0}


----------------------- POST LOOP 6TH STAGES --------------------------

local extendedLimitStages = {}

local progressionLimit = getMaxStageProgression()
callback.register("postLoad", function() progressionLimit = getMaxStageProgression() end)

local progressionLimitReplaced = false

callback.register("onGameStart", function()
	if progressionLimitReplaced then
		Stage.progressionLimit(progressionLimit)
		
		Stage.getProgression(progressionLimit + 1):remove(stg.RiskofRain)
		Stage.getProgression(progressionLimit):add(stg.RiskofRain)
		for _, stage in ipairs(extendedLimitStages) do
			Stage.getProgression(progressionLimit):remove(stage)
		end
		
		progressionLimitReplaced = false
	end
end)

table.insert(call.onStageEntry, function()
	if getRule(5, 21) == true and misc.director:get("stages_passed") >= progressionLimit then
		if not progressionLimitReplaced and #extendedLimitStages > 0 then
			Stage.progressionLimit(progressionLimit + 1)
			
			Stage.getProgression(progressionLimit):remove(stg.RiskofRain)
			Stage.getProgression(progressionLimit + 1):add(stg.RiskofRain)
			for _, stage in ipairs(extendedLimitStages) do
				Stage.getProgression(progressionLimit):add(stage)
			end
			
			progressionLimitReplaced = true
		end
	end
end)

------------------------------- Stray Tarn --------------------------------
Sprite.load("newTileset", "Stages/StrayTarn/tileset.png", 1, 0, 0)
Sprite.load("nStars", "Stages/StrayTarn/stars.png", 1, 0, 0)
Sprite.load("nMid", "Stages/StrayTarn/mid.png", 1, 0, 0)
Sprite.load("nFar", "Stages/StrayTarn/far.png", 1, 0, 0)
Sprite.load("nSky", "Stages/StrayTarn/sky.png", 1, 0, 0)
Sprite.load("nSky2", "Stages/StrayTarn/sky2.png", 1, 0, 0)
stg.StrayTarn, rm.StrayTarn = require("Stages.StrayTarn.Stage")
stg.StrayTarn.music = sfx.musicStage8

rm.StrayTarnVariant = require("Stages.StrayTarn.Variant")
stg.StrayTarn.rooms:add(rm.StrayTarnVariant)

if mcard.Overseer then
	stg.StrayTarn.enemies:add(mcard.Overseer)
end
if mcard.Scrounger then
	stg.StrayTarn.enemies:add(mcard.Scrounger)
end

if not global.rormlflag.ss_disable_straytarn then -- wew
	table.insert(extendedLimitStages, stg.StrayTarn)
end

stageGrounds[stg.StrayTarn] = Sprite.load("Starstorm_GroundStripNew", "Misc/Menus/grounds/groundStrip17", 2, 0, 0)
bkgStages[stg.StrayTarn] = {color = Color.fromHex(0x38683C), layers = 0}

------------------------------- Paul's Land --------------------------------

stg.PaulsLand = Stage.new("Mount of the Goats")
stg.PaulsLand.subname = "Place of Worship"
stg.PaulsLand.music = sfx.musicStage11
local rmGoatMount = require("Stages.Other.GoatMount")
stg.PaulsLand.rooms:add(rmGoatMount)
bkgStages[stg.PaulsLand] = {color = Color.fromHex(0x738696), layers = 4}
table.insert(call.onStageEntry, function()
	local stage = Stage.getCurrentStage()
	if stage == stg.PaulsLand then
		local bk = bkg:create(0, 0)
		bk:getData().stage = stg.AncientValley
		
		obj.Geyser:create(2231, 1024)
		
		local tp = obj.Teleporter:find(1)
		if tp and tp:isValid() then
			tp.x = 3016
			tp.y = 944
			tp:set("maxtime", 0)
		end
		local sp = obj.TeleporterFake:find(1)
		if sp and sp:isValid() then
			sp.x = 1141
			sp.y = 896
		end
	end
end)
if obj.Goat and obj.Paul then
	rmGoatMount:createInstance(obj.Goat, 165, 697)
	rmGoatMount:createInstance(obj.Goat, 1369, 905)
	rmGoatMount:createInstance(obj.Goat, 1696, 889)
	rmGoatMount:createInstance(obj.Goat, 2163, 1017)
	rmGoatMount:createInstance(obj.Goat, 2361, 841)
	rmGoatMount:createInstance(obj.Goat, 2444, 841)
	rmGoatMount:createInstance(obj.Goat, 2544, 841)
	rmGoatMount:createInstance(obj.Paul, 2978, 937)
end

table.insert(call.onStageEntry, function()
	local room = Room.getCurrentRoom()
	if room == rm.UnchartedMountainVariant then
		local b = obj.Pigbeach:create(4029, 1152)
		b.xscale = -1
	end
end)
table.insert(call.onPlayerStep, function(player)
	if player:collidesWith(obj.Pigbeach, player.x, player.y) then
		local room = Room.getCurrentRoom()
		if room == rm.UnchartedMountainVariant then
			if player:get("ropeUp") == 1 then
				if net.host then
					Stage.transport(stg.PaulsLand)
					sfx.MS:play()
					syncSound:sendAsHost(net.ALL, nil, sfx.MS)
				else
					hostSyncInstanceVar:sendAsClient(player:getNetIdentity(), "ropeUp", player:get("ropeUp"))
				end
			end
		end
	end
end)

-------------------------------------------------------------------------------------

local customStages = {
	[stg.TorridOutlands] = 3,
	[stg.Overgrowth] = 4,
	[stg.UnchartedMountain] = 5
}
local customRooms = {
	[stg.DesolateForest] = {rm.DesolateVariant},
	[stg.HiveCluster] = {stage4_3}
}

callback.register("postLoad", function()
	callback.register("postSelection", function()
		local currentStage = Stage.getCurrentStage()
		if getRule(5, 20) == false then
			for stage, prog in pairs(customStages) do
				if Stage.progression[prog]:contains(stage) then
					Stage.progression[prog]:remove(stage)
				end
			end
			for stage, list in pairs(customRooms) do
				for _, room in ipairs(list) do
					stage.rooms:remove(room)
				end
			end
			if net.host then
				if customStages[currentStage] or customRooms[currentStage] and contains(customRooms[currentStage], Room.getCurrentRoom()) then
					Stage.transport(stg.DesolateForest)
				end
			end
		else
			for stage, prog in pairs(customStages) do
				if not Stage.progression[prog]:contains(stage) then
					Stage.progression[prog]:add(stage)
				end
			end
			for stage, list in pairs(customRooms) do
				for _, room in ipairs(list) do
					stage.rooms:add(room)
				end
			end
		end
	end)
end)

callback.register("onGameEnd", function()
	for stage, prog in pairs(customStages) do
		if not Stage.progression[prog]:contains(stage) then
			Stage.progression[prog]:add(stage)
		end
	end
end)

local allStages = {}
local allNormalStages = {}
local exceptions = {stg.RiskofRain, stg.Void, stg.VoidShop, stg.Unknown, stg.RedPlane}
callback.register("postLoad", function()
	for _, namespace in ipairs(namespaces) do
		for _, stage in ipairs(Stage.findAll(namespace)) do
			table.insert(allStages, stage)
			if not contains(exceptions, stage) then
				table.insert(allNormalStages, stage)
			end
		end
	end
end)

ALL_STAGES = allStages
NORMAL_STAGES = allNormalStages
SPECIAL_STAGES = {stg.Void, stg.VoidShop, stg.Unknown, stg.RedPlane}

export("ALL_STAGES")
export("NORMAL_STAGES")
export("SPECIAL_STAGES")


table.insert(call.onStep, function()
	if runData.staticDiff then
		misc.director:set("enemy_buff", runData.staticDiff)
		if sfx.Watch:isPlaying() then
			sfx.Watch:stop()
		end
	end
end)


-- Generate Boss Spawnpoints for missing stages
local bossSpawns = {obj.BossSpawn, obj.BossSpawn2}
local postEntry = false
table.insert(call.onStageEntry, function()
	postEntry = true
end)
table.insert(call.onStep, function()
	if postEntry then
		postEntry = false
		for _, spawnType in ipairs(bossSpawns) do
			if not spawnType:find(1) then
				for _, btype in ipairs({obj.B}) do
					for _, b in ipairs(btype:findAll()) do
						if b.xscale >= 15 then
							spawnType:create(b.x, b.y)
						end
					end
				end
			end
		end
	end
end)