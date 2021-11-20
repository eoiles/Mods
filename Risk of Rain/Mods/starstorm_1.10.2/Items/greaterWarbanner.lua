local path = "Items/Resources/"

it.GreaterWarbanner = Item.new("Greater Warbanner")
it.GreaterWarbanner.pickupText = "Place a warbanner for great buffs." 
it.GreaterWarbanner.sprite = Sprite.load("GreaterWarbanner", path.."Greater Warbanner.png", 2, 15, 16)
it.GreaterWarbanner.isUseItem = true
it.GreaterWarbanner.useCooldown = 80
it.GreaterWarbanner:setTier("use")
itp.enigma:add(it.GreaterWarbanner)
it.GreaterWarbanner:setLog{
	group = "use",
	description = "Place a warbanner which &b&decreases skill cooldowns&!&, &y&increasing critical strike chance&!& and &g&health.",
	story = "Strength my children, strength! We're closer to the armageddon, we must fight or else we will succumb. This is a gift from the elders, to aid you in your future confrontations.",
	destination = "L2,\nNorthern Outpost,\nEarth",
	date = "03/01/2056"
}

local sprGreaterWarbanner = Sprite.load("GreaterWarbannerDis", path.."greaterWarbannerdis.png", 5, 9, 28)

local buffWarbannerG = Buff.new("warbannerG")
buffWarbannerG.sprite = spr.Buffs
buffWarbannerG.subimage = 58
buffWarbannerG:addCallback("start", function(actor)
	local actorAc = actor:getAccessor()
	
	if isa(actor, "PlayerInstance") then
		actorAc.maxhp_base  = actorAc.maxhp_base + 100
	else
		actorAc.maxhp = actorAc.maxhp + 100
	end
	actorAc.pHmax = actorAc.pHmax + 0.6
	actorAc.critical_chance = actorAc.critical_chance + 20
end)
buffWarbannerG:addCallback("step", function(actor)
	if actor:isValid() then
		local actorAc = actor:getAccessor()
		
		actor:setAlarm(3, math.max(actor:getAlarm(3) - 1, -1))
		actor:setAlarm(4, math.max(actor:getAlarm(4) - 1, -1))
		actor:setAlarm(5, math.max(actor:getAlarm(5) - 1, -1))
	end
end)
buffWarbannerG:addCallback("end", function(actor)
	local actorAc = actor:getAccessor()
	
	if isa(actor, "PlayerInstance") then
		actorAc.maxhp_base  = actorAc.maxhp_base - 100
	else
		actorAc.maxhp = actorAc.maxhp - 100
	end
	actorAc.pHmax = actorAc.pHmax - 0.6
	actorAc.critical_chance = actorAc.critical_chance - 20
end)

local objWarbannerG = Object.new("WarbannerG")
objWarbannerG.sprite = sprGreaterWarbanner
objWarbannerG.depth = 9

local range = 200

objWarbannerG:addCallback("create", function(self)
	local selfData = self:getData()
	self.spriteSpeed = 0.2
	self.subimage = 1
	
	local n = 0
	while not self:collidesMap(self.x, self.y + 1) and n < 200 do
		self.y = self.y + 2
		n = n + 1
	end
	if n == 200 then
		self:destroy()
	end
end)
objWarbannerG:addCallback("step", function(self)
	local selfData = self:getData()
	if selfData.team then
		for _, actor in ipairs(pobj.actors:findAllEllipse(self.x - range, self.y - range, self.x + range, self.y + range)) do
			if actor:get("team") == selfData.team and not isaDrone(actor) then
				actor:applyBuff(buffWarbannerG, 60)
			end
		end
	end
	if self.subimage >= 5 then
		self.spriteSpeed = 0
		self.subimage = 5
	end
end)
objWarbannerG:addCallback("draw", function(self)
	graphics.color(Color.fromHex(0xEF8340))
	local sine = math.sin(global.timer * 0.08) * 0.2
	graphics.alpha(0.6 + sine)
	graphics.circle(self.x, self.y, range, true)
end)

it.GreaterWarbanner:addCallback("use", function(player)
	local beatingEmbryo = player:countItem(it.BeatingEmbryo)
	--sGreaterWarbanner:play()
	
	local o = objWarbannerG:create(player.x, player.y)
	o:getData().team = player:get("team")
end)
table.insert(call.onPlayerStep, function(player)
	local playerData = player:getData()
	if playerData.generatePOITimer then
		if playerData.generatePOITimer > 0 then
			playerData.generatePOITimer = playerData.generatePOITimer - 1
			
			local poi = Object.findInstance(player:get("child_poi")) or obj.POI:findMatchingOp("parent", "==", player.id)
			if type(poi) == "table" and poi[1] then poi = poi[1] elseif type(poi) == "table" then poi = nil end -- aaaaaaaaaaaa i hate this
			if poi and poi:isValid() then
				player.alpha = 0.1
				poi:destroy()
			end
		else
			player.alpha = 1
			
			local poi = Object.findInstance(player:get("child_poi"))
			
			if not poi or not poi:isValid() then
				local newpoi = obj.POI:create(player.x, player.y)
				newpoi:set("parent", player.id)
				player:set("child_poi ", newpoi.id)
			end
			
			playerData.generatePOITimer = nil
		end
	end
end)
callback.register("onPlayerDrawAbove", function(player)
	if player:getData().generatePOITimer then
		local alpha = 0.1 + (math.random(1, 20) * 0.01)
		graphics.setBlendMode("additive")
		graphics.drawImage{
			image = player.sprite,
			angle = player.angle,
			alpha = alpha,
			solidColor = Color.AQUA,
			x = player.x,
			y = player.y,
			xscale = player.xscale,
			yscale = player.yscale,
			subimage = player.subimage
		}
		graphics.setBlendMode("normal")
	end
end)