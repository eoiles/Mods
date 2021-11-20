local path = "Artifacts/Resources/"

-- Eminence
ar.Eminence = Artifact.new("Eminence")
ar.Eminence.loadoutSprite = Sprite.load("Eminence", path.."eminence", 2, 18, 18)
ar.Eminence.loadoutText = "Bosses are scarce but pose a greater threat."
ar.Eminence.pickupSprite = Sprite.load("EminencePickup", path.."eminencePickup", 1, 14, 14)
ar.Eminence.pickupName = "Artifact of Eminence"

obj.EminencePickup = ar.Eminence:getObject()
rm.TorridOutlands:createInstance(obj.EminencePickup, 966, 1007)
rm.TorridOutlands:createInstance(obj.ArtifactNoise, 966, 1007)

local cardIds = {}
local cardObjs = {}
local allCards

callback.register("postLoad", function()
	allCards = MonsterCard.findAll()
	for _, card in ipairs(allCards) do
		cardIds[card.id] = card
		cardObjs[card.object] = card
	end
end)

local stageBossCost = {}

local emSize = 1.2
local emCost = 3.5

table.insert(call.onStep, function()
	if ar.Eminence.active then
		local dirAc = misc.director:getAccessor()
		
		local currentStage = Stage.getCurrentStage()
		local stageEnemies = currentStage.enemies:toTable()
		
		if not stageBossCost[currentStage] then
			for _, card in ipairs(allCards) do
				if card.isBoss then
					if not stageBossCost[currentStage] or stageBossCost[currentStage] > card.cost then
						stageBossCost[currentStage] = card.cost
					end
				end
			end
		end
		
		local mcard = cardIds[dirAc.card_choice]
		if stageBossCost[currentStage] and dirAc.points >= stageBossCost[currentStage] and dirAc.spawn_boss > 0 then
			if dirAc.points < stageBossCost[currentStage] * emCost then
				dirAc.spawn_boss = dirAc.spawn_boss - 1
				dirAc.points = stageBossCost[currentStage] - 1 -- no spawnies for you ugly bwoss onó
				misc.director:setAlarm(0, 1)
			end
		end
		
		for _, worm in ipairs(obj.WormBody:findAll()) do
			if not worm:getData().eminenceEdited then
				worm:getData().eminenceEdited = true
				worm.xscale = worm.xscale * emSize
				worm.yscale = worm.yscale * emSize
			end
		end
	end
end)

local varExceptions = {
	[obj.WormBody] = true,
	[obj.WormHead] = true
}
local scaleExceptions = {
	[obj.Scavenger] = true -- messes up their attack's direction
}

callback.register("onTrueActorInit", function(actor)
	if ar.Eminence.active then
		if actor:isBoss() and not actor:getData().isNemesis then
			obj.EfFlash:create(0,0):set("parent", actor.id):set("rate", 0.08)
			
			local object = actor:getObject()
			
			local cost = 1
			
			local card = cardObjs[object]
			
			if card then
				cost = card.cost * (emCost - 1)
			end
			
			misc.director:set("points", misc.director:get("points") - cost)
			
			local actorAc = actor:getAccessor()
			
			if not varExceptions[object] then
				if actorAc.pHmax then
					actorAc.pHmax = actorAc.pHmax + 0.2
				end
				if actorAc.damage then
					actorAc.damage = actorAc.damage * 2.2
				end
				if actor:getObject() == obj.ImpGS then
					actorAc.maxhp = actorAc.maxhp * 1.5
				else
					actorAc.maxhp = actorAc.maxhp * 3
				end
				actorAc.hp = actorAc.maxhp
				if actorAc.critical_chance then 
					actorAc.critical_chance = 5
				end
				actorAc.blast = 1
				if actorAc.exp_worth then
					actorAc.exp_worth = actorAc.exp_worth * 3.5
				end
				actorAc.stun_immune = 1
				actorAc.knockback = 3
				actorAc.cdr = 0.3
				if actorAc.attack_speed then
					actorAc.attack_speed = actorAc.attack_speed * 1.3
				end
				
				if actorAc.hit_pitch then
					actorAc.hit_pitch = actorAc.hit_pitch * 0.9
				end
				
				if actor:getObject() == obj.TotemController then
					for _, part in ipairs(actor:getData().parts) do
						part:set("maxhp", actorAc.maxhp / 4)
						part:set("hp", part:get("maxhp"))
						part:set("stun_immune", actorAc.stun_immune)
					end
				end
			end
			
			if not scaleExceptions[object] then
				actor.xscale = actor.xscale * emSize
				actor.yscale = actor.yscale * emSize
			end
			
			local image = actor.mask or actor.sprite
			local dumb = (image.yorigin - image.height)
			actor.y = actor.y + math.round((dumb * emSize) - dumb)
		end
	end
end)
table.insert(call.postStep, function()
	for _, actor in ipairs(pobj.actors:findAll()) do
		if ar.Eminence.active then
			if actor:isBoss() and actor:getObject() ~= obj.WormBody and not actor:get("isUltra") then
				actor.xscale = math.sign(actor.xscale) * emSize
				actor.yscale = math.sign(actor.yscale) * emSize -- stay big, ok colossus? 
				
				if actor:isClassic() then
					local n = 0
					while actor:collidesMap(actor.x, actor.y - (n * 2)) and n < 55 do
						n = n + 1
					end
					if not actor:collidesWith(obj.BNoSpawn, actor.x, actor.y - (n * 2) + 2) then
						actor.y = actor.y - n * 2
					end
				end
			end
		end
	end
end)
local biggerObjects = {obj.WormBody, obj.WormHead}
for _, obj in ipairs(biggerObjects) do
	obj:addCallback("create", function(self)
		if ar.Eminence.active then
			self.xscale = self.xscale * emSize
			self.yscale = self.yscale * emSize
		end
	end)
end

obj.BoarCorpse:addCallback("create", function(self)
	if ar.Eminence.active then
		self.y = self.y + 8
	end
	local n = 0
	while n < 50 and not self:collidesMap(self.x, self.y + 1) do
		n = n + 1
		self.y = self.y + 2
	end
end)