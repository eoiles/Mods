
-- All events

local eventSFX = {
	rain = {
		main = Sound.load("Rain", "Misc/SFX/Weather/rain1"), 
		mix = {
			Sound.load("Storm1", "Misc/SFX/Weather/rainStorm1"),
			Sound.load("Storm2", "Misc/SFX/Weather/rainStorm2"),
			Sound.load("Storm3", "Misc/SFX/Weather/rainStorm3"),
			Sound.load("Storm4", "Misc/SFX/Weather/rainStorm4")
		}
	}, 
	underground = {
		main = Sound.load("Underground", "Misc/SFX/Weather/underground1"), 
		mix = {
			Sound.load("Debris1", "Misc/SFX/Weather/underDebris1"),
			Sound.load("Debris2", "Misc/SFX/Weather/underDebris2"),
			Sound.load("Debris3", "Misc/SFX/Weather/underDebris3"),
			Sound.load("Debris4", "Misc/SFX/Weather/underDebris4")
		}
	}, 
	snow = {
		main = Sound.load("Snow", "Misc/SFX/Weather/snow1"), 
		mix = {
			Sound.load("Wind1", "Misc/SFX/Weather/snowWind1"),
			Sound.load("Wind2", "Misc/SFX/Weather/snowWind2"),
			Sound.load("Wind3", "Misc/SFX/Weather/snowWind3"),
			Sound.load("Wind4", "Misc/SFX/Weather/snowWind4")
		}
	}
}
local eventParticles = {}
eventParticles.rain = par.Rain
eventParticles.rain2 = par.Rain2
eventParticles.snow = par.Snow
eventParticles.templeSnow = par.TempleSnow
eventParticles.sandstorm = par.Rain

-- STORM

local evStorm = Event.new(
	"Storm", 
	function(strengthMult)
		local havoc = ar.Havoc and ar.Havoc.active
		
		for _, actor in pairs(pobj.actors:findMatching("stormBuffed", nil)) do
			local actorAc = actor:getAccessor()
			if actorAc.team == "enemy" then
				actorAc.stormBuffed = 1
				if not havoc or misc.director:get("stages_passed") > 0 then -- cringe exception :)
					actorAc.armor = actorAc.armor + (95 * strengthMult)
					if actorAc.critical_chance then
						actorAc.critical_chance = actorAc.critical_chance + (30 * strengthMult)
					end
					if actorAc.pHmax then
						actorAc.pHmax = actorAc.pHmax + 0.7
					end
					actorAc.exp_worth = actorAc.exp_worth * (1.5 * strengthMult)
				end
			end
		end
	end, 
	function()
		obj.EfLaserBlast:create(0, -100)
		misc.shakeScreen(math.random(2,10))
	end, 
	function(strengthMult)
		local havoc = ar.Havoc and ar.Havoc.active
		for p, player in ipairs(misc.players) do
			if player:get("dead") <= 0 then
				player:getData().survivedStorm = 1
			end
		end
		for _, actor in pairs(pobj.actors:findMatching("stormBuffed", 1)) do
			local actorAc = actor:getAccessor()
			actorAc.stormBuffed = nil
			if not havoc or misc.director:get("stages_passed") > 0 then
				actorAc.armor = actorAc.armor - (95 * strengthMult)
				if actorAc.critical_chance then
					actorAc.critical_chance = actorAc.critical_chance - (30 * strengthMult)
				end
				if actorAc.pHmax then
					actorAc.pHmax = actorAc.pHmax - 0.7
				end
				actorAc.exp_worth = actorAc.exp_worth / (1.5 * strengthMult)
			end
		end
	end
)
evStorm.alert = "A storm is approaching..."
evStorm.baseDuration = 90
evStorm.durationScaling = 1

Event.setFX(evStorm, eventParticles.rain, eventSFX.rain.main, eventSFX.rain.mix, Color.WHITE, 0.20)
Event.setStageFX(evStorm, stg.DesolateForest, eventParticles.rain2, eventSFX.rain.main, eventSFX.rain.mix, Color.WHITE, 0.14)
Event.setStageFX(evStorm, stg.DriedLake, eventParticles.rain2, eventSFX.rain.main, eventSFX.rain.mix, Color.WHITE, 0.14)
Event.setStageFX(evStorm, stg.DampCaverns, eventParticles.templeSnow, eventSFX.underground.main, eventSFX.underground.mix, Color.fromRGB(95, 95, 122), 0.4, true)
Event.setStageFX(evStorm, stg.SkyMeadow, eventParticles.rain2, eventSFX.rain.main, eventSFX.rain.mix, Color.WHITE, 0.2)
Event.setStageFX(evStorm, stg.AncientValley, eventParticles.snow, eventSFX.snow.main, eventSFX.snow.mix, Color.WHITE, 0.2)
Event.setStageFX(evStorm, stg.SunkenTombs, eventParticles.templeSnow, eventSFX.underground.main, eventSFX.underground.mix, Color.WHITE, 0.2)
Event.setStageFX(evStorm, stg.BoarBeach, eventParticles.rain, eventSFX.rain.main, eventSFX.rain.mix, Color.fromRGB(119, 104, 34), 0.2)
Event.setStageFX(evStorm, stg.MagmaBarracks, eventParticles.rain, eventSFX.underground.main, eventSFX.underground.mix, Color.fromRGB(160, 89, 64), 0.4)
Event.setStageFX(evStorm, stg.HiveCluster, eventParticles.templeSnow, eventSFX.underground.main, eventSFX.underground.mix, Color.fromRGB(122, 70, 104), 0.3)
Event.setStageFX(evStorm, stg.TempleoftheElders, eventParticles.rain, eventSFX.rain.main, eventSFX.rain.mix, Color.WHITE, 0.2)
Event.setStageFX(evStorm, stg.RiskofRain, eventParticles.rain, eventSFX.rain.main, eventSFX.rain.mix, Color.WHITE, 0.14)

Event.setStageFX(evStorm, stg.Overgrowth, eventParticles.rain, eventSFX.rain.main, eventSFX.rain.mix, Color.fromHex(0xC6E5B5), 0.25)
Event.setStageFX(evStorm, stg.UnchartedMountain, eventParticles.snow, eventSFX.snow.main, eventSFX.snow.mix, Color.fromHex(0xFFE0E0), 0.25)
Event.setStageFX(evStorm, stg.TorridOutlands, eventParticles.rain, eventSFX.rain.main, eventSFX.rain.mix, Color.fromHex(0xFFB2C1), 0.1)
Event.setStageFX(evStorm, stg.Void, eventParticles.rain, eventSFX.rain.main, eventSFX.rain.mix, Color.PINK, 0.18)
Event.setStageFX(evStorm, stg.VoidShop, eventParticles.rain, eventSFX.rain.main, eventSFX.rain.mix, Color.LIGHT_BLUE, 0.15)
Event.setStageFX(evStorm, stg.Unknown, eventParticles.rain2, eventSFX.rain.main, eventSFX.rain.mix, Color.BLUE, 0.14)
Event.setStageFX(evStorm, stg.RedPlane, eventParticles.rain, eventSFX.rain.main, eventSFX.rain.mix, Color.RED, 0.14)

local points = 0

callback.register("onGameStart", function()
	points = 0
end)

table.insert(call.onStep, function()
	if Stage.getCurrentStage() ~= stg.VoidShop then
		local teleporterDone = #obj.Teleporter:findMatchingOp("active", ">", 1) > 0
		
		if teleporterDone == false and not Event.getActive() then
			local rateMult = getRule(5, 3)
			
			for p, player in pairs(misc.players) do
				if player:get("hp") >= player:get("maxhp") * 0.95 then
					points = points + ((0.002 * player:get("level")) * rateMult)
				end
			end
			if misc.director:getAlarm(0) == 60 then
				points = points + 0.5
			end
			if points >= 1500 * (0.5 + 0.5 * #misc.players) then
				if not net.online or net.host then
					Event.setActive(evStorm)
					points = 0
				end
			end
		end
	end
end)
table.insert(call.onDraw, function()
	if Event.getActive() == evStorm then
		graphics.setBlendMode("additive")
		for _, actor in pairs(pobj.actors:findMatching("stormBuffed", 1)) do
			if actor.visible and onScreen(actor) then
				graphics.drawImage{
				image = actor.sprite,
				x = actor.x + math.random(-0.5, 0.5),
				y = actor.y + math.random(-1, -0.5),
				subimage = actor.subimage,
				solidColor = Color.WHITE,
				alpha = 0.2 * actor.alpha,
				angle = actor.angle,
				xscale = actor.xscale,
				yscale = actor.yscale,
				width = actor.sprite.width + 3,
				height = actor.sprite.height + 3
				}
			end
		end
		graphics.setBlendMode("normal")
	end
end)

-- WIND (RIGHT)

local evWind1 = Event.new(
	"Wind1", 
	function(strengthMult, timeLeft)
		
		local strength = 7 * strengthMult
		
		local windSpeed = 0.1 + strength + (strength * math.sin(timeLeft * 0.01))
		
		for _, actor in pairs(pobj.actors:findMatchingOp("team", "~=", "enemy")) do
			local actorAc = actor:getAccessor()
			
			local hitbox
			if actor.mask then hitbox = actor.mask else hitbox = actor.sprite end
			
			local size = (hitbox.width + hitbox.height) / 2
			
			local actorPush = windSpeed / size
			
			if actor:isClassic() and not actor:collidesMap(actor.x + actorPush, actor.y) and actorAc.activity ~= 30 then
				actor.x = actor.x + actorPush
			end
		end
	end, 
	nil, 
	nil
)
evWind1.alert = "The wind blows with great force..."
evWind1.baseDuration = 60
evWind1.durationScaling = 0.5
evWind1.persistent = false

local evWind1FX = Event.setFX(evWind1, par.SandCloud, eventSFX.snow.main, eventSFX.snow.mix, Color.WHITE, 0.20, true)
evWind1FX.xoffset = - 300
evWind1FX.particleAmount = 0.7

local evWind1FXDD = Event.setStageFX(evWind1, stg.DriedLake, par.SandCloud, eventSFX.snow.main, eventSFX.snow.mix, Color.fromHex(0xC1A876), 0.22, true)
evWind1FXDD.xoffset = - 300
evWind1FXDD.particleAmount = 0.7
evWind1FXDD.particleColor = Color.fromHex(0xC1A876)
local evWind1FXBB = Event.setStageFX(evWind1, stg.BoarBeach, par.SandCloud, eventSFX.snow.main, eventSFX.snow.mix, Color.fromHex(0xC1A876), 0.4, true)
evWind1FXBB.xoffset = - 300
evWind1FXBB.particleAmount = 0.7
evWind1FXBB.particleColor = Color.fromHex(0xC1A876)
local evWind1FXTO = Event.setStageFX(evWind1, stg.TorridOutlands, par.SandCloud, eventSFX.snow.main, eventSFX.snow.mix, Color.fromHex(0xEF9175), 0.4, true)
evWind1FXTO.xoffset = - 300
evWind1FXTO.particleAmount = 0.7
evWind1FXTO.particleColor = Color.fromHex(0xEF9175)

-- WIND (LEFT)

local evWind2 = Event.new(
	"Wind2", 
	function(strengthMult, timeLeft)
		
		local strength = 7 * strengthMult
		
		local windSpeed = 0.1 + strength + (strength * math.sin(timeLeft * 0.01))
		
		for _, actor in pairs(pobj.actors:findMatchingOp("team", "~=", "enemy")) do
			local actorAc = actor:getAccessor()
			
			local hitbox
			if actor.mask then hitbox = actor.mask else hitbox = actor.sprite end
			
			local size = (hitbox.width + hitbox.height) / 2
			
			local actorPush = windSpeed / size
			
			if not actor:isClassic() or not actor:collidesMap(actor.x - actorPush, actor.y) and actorAc.activity ~= 30 then
				actor.x = actor.x - actorPush
			end
		end
	end, 
	nil, 
	nil
)
evWind2.alert = "The wind blows with great force..."
evWind2.baseDuration = 60
evWind2.durationScaling = 0.5
evWind2.persistent = false

local evWind2FX = Event.setFX(evWind2, par.SandCloudLeft, eventSFX.snow.main, eventSFX.snow.mix, Color.WHITE, 0.20, true)
evWind2FX.xoffset = 300
evWind2FX.particleAmount = 1

local evWind2FXDD = Event.setStageFX(evWind2, stg.DriedLake, par.SandCloudLeft, eventSFX.snow.main, eventSFX.snow.mix, Color.fromHex(0xC1A876), 0.22, true)
evWind2FXDD.xoffset = 300
evWind2FXDD.particleAmount = 0.7
evWind2FXDD.particleColor = Color.fromHex(0xC1A876)
local evWind2FXBB = Event.setStageFX(evWind2, stg.BoarBeach, par.SandCloudLeft, eventSFX.snow.main, eventSFX.snow.mix, Color.fromHex(0xC1A876), 0.4, true)
evWind2FXBB.xoffset = 300
evWind2FXBB.particleAmount = 0.7
evWind2FXBB.particleColor = Color.fromHex(0xC1A876)
local evWind2FXTO = Event.setStageFX(evWind2, stg.TorridOutlands, par.SandCloudLeft, eventSFX.snow.main, eventSFX.snow.mix, Color.fromHex(0xEF9175), 0.4, true)
evWind2FXTO.xoffset = 300
evWind2FXTO.particleAmount = 0.7
evWind2FXTO.particleColor = Color.fromHex(0xEF9175)

local points = 0
local sandstormStages = {
[stg.DriedLake] = true,
[stg.BoarBeach] = true,
[stg.UnchartedMountain] = true,
[stg.AncientValley] = true
}

callback.register("onGameStart", function()
	points = 0
end)

table.insert(call.onStep, function()
	if sandstormStages[Stage.getCurrentStage()] then
		local teleporterDone = #obj.Teleporter:findMatchingOp("active", ">", 1) > 0
			
		if teleporterDone == false and not Event.getActive() then
			local rateMult = getRule(5, 3)
			
			for p, player in pairs(misc.players) do
				if player:get("hp") >= player:get("maxhp") * 0.95 then
					points = points + ((0.002 * player:get("level")) * rateMult)
				end
			end
			if misc.director:getAlarm(0) == 60 then
				points = points + 0.5
			end
			if points >= 1300 * (0.5 + 0.5 * #misc.players) then
				if not net.online or net.host then
					if math.chance(50) then
						Event.setActive(evWind1)
					else
						Event.setActive(evWind2)
					end
					points = 0
				end
			end
		end
	end
end)

-- COLLAPSE

local sprBoulder = Sprite.load("Boulder", "Gameplay/boulder", 4, 10, 10)
local sprBoulderWarning = Sprite.load("BoulderWarning", "Gameplay/boulderWarning", 4, 25, 13)
local sRockDestroy = Sound.load("RockDestroy", "Misc/SFX/rockDestroy")

local objBoulder = Object.new("Boulder")
objBoulder.sprite = sprBoulder

objBoulder:addCallback("create", function(self)
	local data = self:getData()
	local n = 2
	while not data.ground and n < 80 do
		local yy = self.y + 10 + (n * 10)
		if self:collidesMap(self.x, yy) then
			data.ground = yy
		end
		n = n + 1
	end
	
	data.timer = 100
	data.speed = 0.5
	data.team = "enemy"
	data.damage = 10
	self.spriteSpeed = 0
	self.angle = math.random(360)
	data.range = 25
end)
objBoulder:addCallback("step", function(self)
	local data = self:getData()
	
	data.timer = data.timer - 1
	
	if data.timer < 90 then
		data.speed = data.speed + 0.1
		
		self.angle = self.angle + 5
	end
	
	self.y = self.y + data.speed
	
	if data.timer < 75 and self:collidesMap(self.x, self.y) then
		misc.fireExplosion(self.x, self.y, data.range / 19, data.range / 4, data.damage, data.team, nil, spr.Sparks5)
		if global.quality > 1 then
			par.Rubble:burst("middle", self.x, self.y, 10)
		end
		if onScreen(self) then
			sRockDestroy:play(0.9 + math.random() * 0.2)
		end
		self:destroy()
	end
end)
objBoulder:addCallback("draw", function(self)
	local data = self:getData()
	
	if data.timer > 0 and data.ground then
		graphics.drawImage{
			image = sprBoulderWarning,
			subimage == math.ceil(data.timer / 2) % 4,
			x = self.x,
			y = data.ground
		}
	
	end
end)

local syncBoulder = net.Packet.new("SSCollapseBoulder", function(player, x, y, damage)
	--[[local boulder = obj.EfGrenadeEnemy:create(x, y)
	boulder.sprite = sprBoulder
	boulder.subimage = math.random(1, 4)
	boulder.spriteSpeed = 0
	boulder:set("damage", damage)
	boulder:set("direction", direction)
	boulder:set("speed", speed)]]
	local b = objBoulder:create(x, y)
	b.subimage = math.random(1, 4)
	local bd = b:getData()
	bd.damage = damage
end)

local evCollapse = Event.new(
	"Collapse", 
	nil, 
	function(strengthMult)
		if net.host then
			local grounds = obj.B:findAll()
			local ground = table.irandom(grounds)
			local groundL = ground.x - (ground.sprite.boundingBoxLeft * ground.xscale) + 8
			local groundR = ground.x + (ground.sprite.boundingBoxRight * ground.xscale) - 8
			local x = math.random(groundL, groundR)
			local y = ground.y - 10
			
			local ii = 0
			while not Stage.collidesPoint(x, y - 10) and ii < 100 do
				ii = ii + 1
				y = y - 6
			end
			if ii < 200 then
				local damage = 40 * Difficulty.getScaling("damage") * strengthMult
				local b = objBoulder:create(x, y)
				b.subimage = math.random(1, 4)
				local bd = b:getData()
				bd.damage = damage
				syncBoulder:sendAsHost(net.ALL, nil, x, y, damage)
			end
		end
	end, 
	nil
)
evCollapse.alert = "The surroundings start to rumble..."
evCollapse.baseDuration = 55
evCollapse.durationScaling = 0.25
evCollapse.persistent = false
evCollapse.subeventChance = 15

local evCollapseFX = Event.setFX(evCollapse, nil, eventSFX.underground.main, nil, Color.BLACK, 0.25)

local points = 0
local collapseStages = {
[stg.MagmaBarracks] = true, 
[stg.HiveCluster] = true,
[stg.DampCaverns] = true,
[stg.SunkenTombs] = true,
[stg.SlateMines] = true
}

callback.register("onGameStart", function()
	points = 0
end)

table.insert(call.onStep, function()
	if collapseStages[Stage.getCurrentStage()] then
		local teleporterDone = #obj.Teleporter:findMatchingOp("active", ">", 1) > 0
			
		if teleporterDone == false and not Event.getActive() then
			local rateMult = getRule(5, 3)
			
			for p, player in pairs(misc.players) do
				if player:get("hp") >= player:get("maxhp") * 0.95 then
					points = points + ((0.002 * player:get("level")) * rateMult)
				end
			end
			if misc.director:getAlarm(0) == 60 then
				points = points + 0.5
			end
			if points >= 2000 * (0.5 + 0.5 * #misc.players) then
				if not net.online or net.host then
					Event.setActive(evCollapse)
					points = 0
				end
			end
		end
	end
end)


local dissonanceBlacklist = {
	[mcard.Cremator] = true,
	[mcard["Magma Worm"]] = true
}

-- Dissonance
local allCards = {}
callback.register("postLoad", function()
	for _, card in ipairs(MonsterCard.findAll()) do
		if card ~= mcard.Cremator then 
			table.insert(allCards, card)
		end
	end
end)

local evDissonance = Event.new(
	"Dissonance", 
	function()
		if net.host then
			misc.director:set("card_choice", table.irandom(allCards).id)
			misc.director:set("points", misc.director:get("points") + 0.25)
			if math.chance(4) and #pobj.enemies:findMatchingOp("team", "==", "enemy") < 20 then
				misc.director:setAlarm(1, 1)
			end
		end
	end, 
	nil, 
	nil
)
evDissonance.alert = "The planet dissonates..."
evDissonance.baseDuration = 90
evDissonance.durationScaling = 0.25
evDissonance.persistent = true
evDissonance.subeventChance = 0

local evDissonanceFX = Event.setFX(evDissonance, nil, nil, nil, Color.PURPLE, 0.15)

local points = 0
local dissonanceStages = NORMAL_STAGES

callback.register("onGameStart", function()
	points = 0
end)

table.insert(call.onStep, function()
	local currentStage = Stage.getCurrentStage()
	
	if contains(dissonanceStages, currentStage) then
		local teleporterDone = #obj.Teleporter:findMatchingOp("active", ">", 1) > 0
			
		if teleporterDone == false and not Event.getActive() then
			local rateMult = getRule(5, 3)
			
			for p, player in pairs(misc.players) do
				if player:get("hp") >= player:get("maxhp") * 0.95 then
					points = points + ((0.002 * player:get("level")) * rateMult)
				end
			end
			if misc.director:getAlarm(0) == 60 then
				points = points + 0.5
			end
			if points >= 3400 * (0.5 + 0.5 * #misc.players) then
				if not net.online or net.host then
					Event.setActive(evDissonance)
					points = 0
				end
			end
		end
	end
end)


-- Flood

local evFlood = Event.new(
	"Flood", 
	function(strengthMult)
		local water = obj.Water:find(1)
		if water and not water:getData().tideRise then
			water:getData().tideRise = true
			water:getData().newPos = water.y - 600 * strengthMult
			water:getData().ogPos = water.y
		end
	end, 
	nil, 
	function()
		local water = obj.Water:find(1)
		if water and water:getData().tideRise then
			water:getData().tideRise = false
		end
	end
)
evFlood.alert = "The tides begin to rise..."
evFlood.baseDuration = 60
evFlood.durationScaling = 0.08
evFlood.persistent = false
evFlood.subeventChance = 0

local evFloodFX = Event.setFX(evFlood, nil, nil, nil, Color.BLUE, 0.08)

local points = 0

callback.register("onGameStart", function()
	points = 0
end)

table.insert(call.onStep, function()
	local water = obj.Water:find(1)
	
	if water and Stage.getCurrentStage() ~= stg.RiskofRain then
		local teleporterDone = #obj.Teleporter:findMatchingOp("active", ">", 1) > 0
			
		if teleporterDone == false and not Event.getActive() then
			local rateMult = getRule(5, 3)
			
			for p, player in pairs(misc.players) do
				if player:get("hp") >= player:get("maxhp") * 0.95 then
					points = points + ((0.002 * player:get("level")) * rateMult)
				end
			end
			if misc.director:getAlarm(0) == 60 then
				points = points + 0.5
			end
			if points >= 1550 * (0.5 + 0.5 * #misc.players) then
				if not net.online or net.host then
					Event.setActive(evFlood)
					points = 0
				end
			end
		end
		
		if water:getData().tideRise ~= nil then
			if water:getData().tideRise then
				if water.y ~= water:getData().newPos then
					water.y = math.approach(water.y + math.sin(global.timer * 0.02), water:getData().newPos, 0.5)
				end
			else -- (== false)
				water.y = math.approach(water.y + math.sin(global.timer * 0.02), water:getData().ogPos, 0.5)
				if water.y == water:getData().ogPos then
					water:getData().tideRise = nil
				end
			end
		end
	end
end)


-- Artifact of Havoc exclusives:

-- UNCERTAINTY (FOG)

local allObjs = {obj.Teleporter, obj.Geyser, obj.GeyserWeak}
callback.register("postLoad", function()
	for _, namespace in ipairs(namespaces) do
		for _, int in ipairs(Interactable.findAll(namespace)) do
			table.insert(allObjs, int:getObject())
		end
	end
end)

local uncertaintyRange = 150

local evUncertainty = Event.new(
	"Uncertainty", 
	function(strengthMult)
		for _, actor in pairs(pobj.actors:findMatching("team", "enemy")) do
			local player = obj.P:findNearest(actor.x, actor.y)
			local dis = distance(actor.x, actor.y, player.x, player.y)
			
			local mult = (uncertaintyRange - dis) * 0.01
			actor.alpha = mult
			if mult <= 0 then
				actor.visible = false
			elseif not actor.visible then
				actor.visible = true
			end
		end
		for _, item in pairs(pobj.items:findMatching("used", 0)) do
			local player = obj.P:findNearest(item.x, item.y)
			local dis = distance(item.x, item.y, player.x, player.y)
			
			local mult = (uncertaintyRange - dis) * 0.01
			item.alpha = mult
			if mult <= 0 then
				item.visible = false
			elseif not item.visible then
				item.visible = true
			end
		end
		for _, object in pairs(allObjs) do
			for _, instance in pairs(object:findAll()) do
				local player = obj.P:findNearest(instance.x, instance.y)
				local dis = distance(instance.x, instance.y, player.x, player.y)
				
				local doParticles
				
				if object == obj.Teleporter and instance:get("active") > 1 then
					if not instance.visible then
						instance.visible = true
						doParticles = true
					end
				else
					if dis > uncertaintyRange and instance.visible then
						instance.visible = false
						doParticles = true
					elseif dis <= uncertaintyRange and not instance.visible then
						instance.visible = true
						doParticles = true
					end
				end
				if doParticles and instance.sprite and global.quality > 1 then
					local w = instance.sprite.width
					local h = instance.sprite.height
					
					local coef = (w + h) / 2
					for i = 1, math.ceil(coef * 0.5) do
						local x = instance.x + math.random(0, w) - instance.sprite.xorigin
						local y = instance.y + math.random(0, h) - instance.sprite.yorigin
						par.HiddenSmoke:burst("above", x, y, 1)
					end
				end
			end
		end
	end, 
	nil, 
	function(strengthMult)
		for _, actor in pairs(pobj.actors:findMatching("team", "enemy")) do
			actor.alpha = 1
			actor.visible = true
		end
		for _, item in pairs(pobj.items:findAll()) do
			item.alpha = 1
			item.visible = true
		end
		for _, object in pairs(allObjs) do
			for _, instance in pairs(object:findAll()) do
				instance.visible = true
				if instance.sprite and global.quality > 1 then
					local w = instance.sprite.width
					local h = instance.sprite.height
					
					local coef = (w + h) / 2
					for i = 1, math.ceil(coef * 0.5) do
						local x = instance.x + math.random(0, w) - instance.sprite.xorigin
						local y = instance.y + math.random(0, h) - instance.sprite.yorigin
						par.HiddenSmoke:burst("above", x, y, 1)
					end
				end
			end
		end
	end
)
evUncertainty.alert = "A thick fog builds up..."
evUncertainty.baseDuration = 80 -- doesnt really matter here...
evUncertainty.durationScaling = 1

local evUnFX = Event.setFX(evUncertainty, par.Fog, nil, nil, Color.WHITE, 0.25, true)
evUnFX.particleAmount = 0.03


-- UMBRA

local umbraSpawnFunc = setFunc(function(actor)
	actor:set("maxhp", actor:get("maxhp") * 0.1)
	actor:set("hp", actor:get("maxhp"))
	actor:set("damage", actor:get("damage") * 0.4)
	--actor:setAnimation("death", spr.Nothing)
end)

local evUmbra = Event.new(
	"Umbra", 
	function()
		if Stage.getCurrentStage() ~= stg.RiskofRain then
			for _, actor in ipairs(obj.Boss2Clone:findAll()) do
				if actor:collidesMap(actor.x, actor.y) then
					local nearGround = obj.B:findNearest(actor.x, actor.y)
					if nearGround then
						local target = Object.findInstance(actor:get("target")) or actor
						actor.x = math.clamp(target.x, nearGround.x, nearGround.x + nearGround.xscale * 16)
						actor.y = nearGround.y - actor.mask.height + actor.mask.yorigin
					else
						actor.y = actor.y - 2
					end
				end
			end
		end
	end, 
	function(strengthMult)
		if net.host and #obj.Boss2Clone:findAll() < #misc.players then
			if #obj.Teleporter:findMatchingOp("active", ">", 1) > 0 then
				for _, actor in ipairs(obj.Boss2Clone:findAll()) do
					if net.online then
						syncDestroy(actor)
					else
						actor:destroy()
					end
				end
			else
				if math.chance(math.max(50 * strengthMult, 1)) then
					for _, player in ipairs(misc.players) do
						local ground = obj.B:findNearest(player.x, player.y)
						if ground then
							local x = math.random(ground.x, ground.x + ground.xscale * 16)
							createSynced(obj.Boss2Clone, x, ground.y, umbraSpawnFunc)
						else
							createSynced(obj.Boss2Clone, player.x, player.y, umbraSpawnFunc)
						end
					end
				end
			end
		end
	end, 
	function(strengthMult)
		for _, actor in ipairs(obj.Boss2Clone:findAll()) do
			actor:destroy()
		end
	end
)
evUmbra.alert = "The shadows condense..."
evUmbra.baseDuration = 55
evUmbra.durationScaling = 1
evUmbra.subeventChance = 0.25

local evUmFX = Event.setFX(evUmbra, par.Fog, nil, nil, Color.BLACK, 0.08, true)
evUmFX.particleAmount = 0.07
evUmFX.particleColor = Color.BLACK

-- Elite Events
-- Blazing
local evEliteBlazing = Event.new(
	"EliteBlazing", 
	function(strengthMult)
		for _, spawn in ipairs(obj.Spawn:findAll()) do
			if spawn:get("prefix_type") == 1 then
				spawn:set("elite_type", 0)
			end
		end
	end
)
evEliteBlazing.alert = "A blazing heat spills forth..."
evEliteBlazing.baseDuration = 55
evEliteBlazing.durationScaling = 1
evEliteBlazing.subeventChance = 0.25
Event.setFX(evEliteBlazing, nil, nil, nil, Color.RED, 0.1, true)
-- Frenzied
local evEliteFrenzied = Event.new(
	"EliteFrenzied", 
	function(strengthMult)
		for _, spawn in ipairs(obj.Spawn:findAll()) do
			if spawn:get("prefix_type") == 1 then
				spawn:set("elite_type", 1)
			end
		end
	end
)
evEliteFrenzied.alert = "The creatures enter a frenzy..."
evEliteFrenzied.baseDuration = 55
evEliteFrenzied.durationScaling = 1
evEliteFrenzied.subeventChance = 0.25
Event.setFX(evEliteFrenzied, nil, nil, nil, Color.YELLOW, 0.1, true)
-- Leeching
local evEliteLeeching = Event.new(
	"EliteLeeching", 
	function(strengthMult)
		for _, spawn in ipairs(obj.Spawn:findAll()) do
			if spawn:get("prefix_type") == 1 then
				spawn:set("elite_type", 2)
			end
		end
	end
)
evEliteLeeching.alert = "Leeching growths take hold..."
evEliteLeeching.baseDuration = 55
evEliteLeeching.durationScaling = 1
evEliteLeeching.subeventChance = 0.25
Event.setFX(evEliteLeeching, nil, nil, nil, Color.GREEN, 0.1, true)
-- Overloading
local evEliteOverloading = Event.new(
	"EliteOverloading", 
	function(strengthMult)
		for _, spawn in ipairs(obj.Spawn:findAll()) do
			if spawn:get("prefix_type") == 1 then
				spawn:set("elite_type", 3)
			end
		end
	end
)
evEliteOverloading.alert = "An overloaded shockwave materializes..."
evEliteOverloading.baseDuration = 55
evEliteOverloading.durationScaling = 1
evEliteOverloading.subeventChance = 0.25
Event.setFX(evEliteOverloading, nil, nil, nil, Color.LIGHT_BLUE, 0.1, true)
-- Volatile
local evEliteVolatile = Event.new(
	"EliteVolatile", 
	function(strengthMult)
		for _, spawn in ipairs(obj.Spawn:findAll()) do
			if spawn:get("prefix_type") == 1 then
				spawn:set("elite_type", 4)
			end
		end
	end
)
evEliteVolatile.alert = "A volatile energy grows..."
evEliteVolatile.baseDuration = 55
evEliteVolatile.durationScaling = 1
evEliteVolatile.subeventChance = 0.25
Event.setFX(evEliteVolatile, nil, nil, nil, Color.ORANGE, 0.1, true)
-- Poisoning
local evElitePoisoning = Event.new(
	"ElitePoisoning", 
	function(strengthMult)
		for _, spawn in ipairs(obj.Spawn:findAll()) do
			if spawn:get("prefix_type") == 1 then
				spawn:set("elite_type", elt.Poisoning.id)
			end
		end
	end
)
evElitePoisoning.alert = "The environment becomes poisonous..."
evElitePoisoning.baseDuration = 55
evElitePoisoning.durationScaling = 1
evElitePoisoning.subeventChance = 0.25
Event.setFX(evElitePoisoning, nil, nil, nil, Color.PURPLE, 0.1, true)
-- Weakening
local evEliteWeakening = Event.new(
	"EliteWeakening", 
	function(strengthMult)
		for _, spawn in ipairs(obj.Spawn:findAll()) do
			if spawn:get("prefix_type") == 1 then
				spawn:set("elite_type", elt.Weakening.id)
			end
		end
	end
)
evEliteWeakening.alert = "The heavy atmosphere weakens..."
evEliteWeakening.baseDuration = 55
evEliteWeakening.durationScaling = 1
evEliteWeakening.subeventChance = 0.25
Event.setFX(evEliteWeakening, nil, nil, nil, Color.BLACK, 0.1, true)
-- Dazing
local evEliteDazing = Event.new(
	"EliteDazing", 
	function(strengthMult)
		for _, spawn in ipairs(obj.Spawn:findAll()) do
			if spawn:get("prefix_type") == 1 then
				spawn:set("elite_type", elt.Dazing.id)
			end
		end
	end
)
evEliteDazing.alert = "Dazing visions manifest..."
evEliteDazing.baseDuration = 55
evEliteDazing.durationScaling = 1
evEliteDazing.subeventChance = 0.25
Event.setFX(evEliteDazing, nil, nil, nil, Color.WHITE, 0.1, true)

local eventEliteIds = {
	[evEliteBlazing] = 0,
	[evEliteFrenzied] = 1,
	[evEliteLeeching] = 2,
	[evEliteOverloading] = 3,
	[evEliteVolatile] = 4,
	[evElitePoisoning] = elt.Poisoning.id,
	[evEliteWeakening] = elt.Weakening.id,
	[evEliteDazing] = elt.Dazing.id
}

callback.register("onActorInit", function(actor)
	local event = Event.getActive()
	if eventEliteIds[event] then
		if actor:get("prefix_type") == 1 then
			actor:set("elite_type", eventEliteIds[event])
		end
	end
end)