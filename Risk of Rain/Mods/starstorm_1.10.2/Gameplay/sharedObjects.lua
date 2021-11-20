-- Dummy Actor (For PVP)
obj.actorDummy = Object.base("Enemy", "ActorDummy")
obj.actorDummy.sprite = spr.EfBlank
obj.actorDummy:addCallback("create", function(self)
	--print("created", self, self:getData().parent)
	--self.visible = false
	self.mask = spr.PMask
	self:set("disable_ai", 1)
	self:set("hp", 99999999)
	self:set("maxhp", 99999999)
	local nearestPlayer = obj.P:findNearest(self.x, self.y)
	if nearestPlayer then
		self:set("name", nearestPlayer:get("user_name"))
	end
	self:set("exp_worh", 0)
end)
obj.actorDummy:addCallback("step", function(self)
	self:set("disable_ai", 1)
	local selfData = self:getData()
	local parent = selfData.parent
	if parent and parent:isValid() and parent:get("dead") == 0 then
		--if net.online then
		--	self:set("name", parent:get("user_name"))
		--else
		--	self:set("name", parent:get("name"))
		--end
		self:set("maxhp", parent:get("maxhp"))
		--if parent:get("invincible") > 0 then
		
		local hpDif = 0
		
		if not selfData.fake then
			
			if selfData.ready then
				if self:get("hp") ~= selfData.lastHp then
					self:setAlarm(6, 40)
					parent:set("hp", self:get("hp"))
					--selfData.lastHp = parent:get("hp") - hpDif
					--parent:set("hp", self:get("hp"))
				end
				if self:get("hp_regen") then
					self:set("hp", self:get("hp") + self:get("hp_regen")) 
				end
			else
				selfData.ready = true
				selfData.lastHp = parent:get("hp")
				self:set("hp", self:get("maxhp"))
			end
			
			self:set("m_id", parent:get("m_id"))
			self:set("moveRight", parent:get("moveRight"))
			self:set("moveLeft", parent:get("moveLeft"))
			self:set("bunker", parent:get("bunker"))
			self:set("hp_regen", parent:get("hp_regen"))
			self:set("invincible", parent:get("invincible"))
			self:set("activity_type", parent:get("activity_type"))
			self.xscale = parent.xscale
			
			self:set("hp", math.min(self:get("hp"), self:get("maxhp")))
			selfData.lastHp = self:get("hp")
			
			self:set("team", parent:get("team"))
			self.x = parent.x
			self.y = parent.y
		else
			if selfData.initHp and not selfData.noDamage then
				local dif = selfData.initHp - self:get("hp")
				selfData.parent:set("hp", selfData.parent:get("hp") - dif)
				selfData.initHp = selfData.parent:get("hp")
				self:set("hp", selfData.parent:get("hp"))
			end
			self.mask = spr.Pixel
			local difx = self.x - parent.x
			local dify = self.y - parent.y
			self.x = math.approach(self.x, parent.x, difx * 0.25)
			self.y = math.approach(self.y, parent.y, dify * 0.25)
		end
		--else
		--	self:set("team", "enemy")
		--end
		--if changed then
		--end
		if net.online and parent == net.localPlayer then
			self:setAlarm(6, -1)
		end
	else
		selfData.life = 0
		if parent and parent:isValid() and parent:get("dead") then
			self:kill()
		end
	end
	if self:isValid() then
		if selfData.life then
			selfData.life = selfData.life - 1 
		end
		if selfData.fake and self:get("hp") <= 0 or selfData.life and selfData.life <= 0 then
			self:delete()
		end
	end
end)
table.insert(call.onStep, function()
	for _, self in ipairs(obj.actorDummy:findAll()) do
		local parent = self:getData().parent
		if parent and parent:isValid() and parent:get("dead") == 0 then
			for _, buff in ipairs(self:getBuffs()) do
				if not parent:hasBuff(buff) then
					parent:applyBuff(buff, 2)
				end
			end
		end
	end
end)

-- Custom Poison Cloud
obj.poisonCloud = Object.new("PoisonCloud")
obj.poisonCloud:addCallback("create", function(self)
	local selfData = self:getData()
	
	selfData.timer = 0
	selfData.life = 210
	selfData.parent = nil
	
	selfData.height = 10
	selfData.width = 39
	selfData.color = Color.fromHex(0x15D860)
	selfData.damage = 1
end)
obj.poisonCloud:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	local height = selfData.height
	local width = selfData.width
	if math.chance(height + width) then
		par.Spore:burst("above", self.x + math.random(-width, width), self.y + math.random(-height, height), 1, selfData.color)
	end
	if selfData.parent and selfData.parent:isValid() then
		if selfData.timer > 0 then
			selfData.timer = selfData.timer - 1
		else 
			local explosion = selfData.parent:fireExplosion(self.x, self.y, width / 19, height / 4, selfData.damage, nil, nil, DAMAGER_NO_PROC)
			explosion:set("damage_fake", explosion:get("damage"))
			explosion:set("critical", 0)
			selfData.timer = 30
		end
	end
	if selfData.life > 0 then
		selfData.life = selfData.life - 1
	else
		self:destroy()
	end
end)

-- Elevator
sprElevatorMask = Sprite.load("ElevatorMask", "Gameplay/elevatorMask.png", 1, spr.ElevatorFloor.xorigin, spr.ElevatorFloor.yorigin)

obj.ElevatorEnd = Object.new("ElevatorEnd")

local syncElevator = net.Packet.new("SSElevator", function(player, x, y)
	local elevator = obj.Elevator:findRectangle(x - 10, y - 1000, x + 10, y + 1000)
	
	if elevator and elevator:isValid() then
		local player = net.localPlayer
		if player.x > elevator.x + 800 or player.x < elevator.x - 800 then
			elevator.x = x
			elevator.y = y
		end
	end
end)

obj.ElevatorEnd.sprite = spr.ElevatorFloor
obj.ElevatorEnd:addCallback("create", function(self)
	self.y = self.y - self.sprite.height + self.sprite.yorigin + 1 -- correction for provedit
	self.visible = false
end)

obj.Elevator = Object.new("Elevator")
obj.Elevator.sprite = spr.ElevatorFloor
obj.Elevator.depth = 12
obj.Elevator:addCallback("create", function(self)
	self.y = self.y - self.sprite.height + self.sprite.yorigin + 1 --cringe + 1
	self.mask = sprElevatorMask
	local data = self:getData()
	--local b = obj.BNoSpawn:create(self.x - self.sprite.xorigin, self.y):set("width_box", 18):set("dont_delete", 1)
	--b.xscale = 18
	--data.b = b
	data.sPoint = self.y
	data.timer = 200
	data.down = false
	data.speed = 2
end)
obj.Elevator:addCallback("step", function(self)
	local data = self:getData()
	
	if not data.tPoint then
		local t
		for _, e in ipairs(obj.ElevatorEnd:findAll()) do
			if e.x == self.x then t = e break end
		end
		if t then t = t.y end
		data.tPoint = t or data.sPoint
		if data.tPoint > self.y then 
			data.down = true
		end
	else
		
		--if data.b and data.b:isValid() then
		--	data.b:destroy()
		--end
		--local b = obj.BNoSpawn:create(self.x - self.sprite.xorigin, self.y):set("width_box", 18):set("dont_delete", 1)
		--b.xscale = 18
		--data.b = b
		
		if misc.getTimeStop() == 0 then
			if net.host and global.timer % (60 * 15) == 0 then
				syncElevator:sendAsHost(net.ALL, nil, self.x, self.y)
			end
			if data.timer == 0 then
				local currentPoint
				
				if data.down then
					currentPoint = data.sPoint
				else
					currentPoint = data.tPoint
				end
				
				if self.y == currentPoint then
					if data.down then data.down = false else data.down = true end
					data.timer = 200
				else
					self.y = math.approach(self.y, currentPoint, data.speed)
				end
				
			else
				data.timer = data.timer - 1
			end
		end
		
		local dir = 0
		if data.timer == 0 then
			if data.down then dir = 1 else dir = -1 end
		end
		
		local e = 1
		if data.down then e = 1 + data.speed end
		
		
		for _, actor in ipairs(pobj.actors:findAll()) do
			if actor:isClassic() and self:collidesWith(actor, self.x , self.y - e) then
				local actorAc = actor:getAccessor()
				actorAc.pVspeed = 0
				actorAc.free = 0
				actor.y = math.approach(actor.y, actor.y + (dir * data.speed), data.speed)
				
				while actor:collidesWith(self, actor.x, actor.y) do
					actor.y = actor.y - 1
				end
			end
		end
		for _, item in ipairs(pobj.items:findAll()) do
			if self:collidesWith(item, self.x , self.y - e) then
				itemAc = item:getAccessor()
				itemAc.pVspeed = 0
				item.y = math.approach(item.y, item.y + (dir * data.speed), data.speed)
				
				while item:collidesWith(self, item.x, item.y) do
					item.y = item.y - 1
				end
			end
		end
		for _, ball in ipairs(obj.EfGrenadeEnemy:findAll()) do
			if self:collidesWith(ball, self.x , self.y - e) then
				ballAc = ball:getAccessor()
				ballAc.speed = ballAc.speed * 0.7
				ballAc.direction = ballAc.direction * -1
				ballAc.bounces = ballAc.bounces - 1
				ball.y = math.approach(ball.y, ball.y + (dir * data.speed), data.speed)
				
				while ball:collidesWith(self, ball.x, ball.y) do
					ball.y = ball.y - 1
				end
				
				if ballAc.speed < 2 then
					ball:destroy()
				end
			end
		end
		for _, ball in ipairs(obj.EngiGrenade:findAll()) do
			if self:collidesWith(ball, self.x , self.y - e) then
				ballAc = ball:getAccessor()
				ballAc.speed = ballAc.speed * 0.7
				ballAc.direction = ballAc.direction * -1
				ballAc.bounces = ballAc.bounces - 1
				ball.y = math.approach(ball.y, ball.y + (dir * data.speed), data.speed)
				
				while ball:collidesWith(self, ball.x, ball.y) do
					ball.y = ball.y - 4
				end
				
				if ballAc.speed < 0.2 then
					ball:destroy()
				end
			end
		end
		
	end
end)

obj.CorrosiveTrail = Object.new("CorrosiveTrail")
obj.CorrosiveTrail.sprite = Sprite.load("CorrosiveTrail", "Gameplay/corrosiveTrail", 4, 7, 0)
obj.CorrosiveTrail:addCallback("create", function(self)
	self:getData().damage = 5
	self:getData().team = "enemy"
	self:getData().life = 160
	self.subimage = math.random(1, self.sprite.frames)
	self.spriteSpeed = 0
	local i = 0
	while not Stage.collidesPoint(self.x, self.y) and i < 100 do
		i = i + 1
		self.y = self.y + 1
	end
	if i == 100 then
		self:destroy()
	end
end)
obj.CorrosiveTrail:addCallback("step", function(self)
	local parent = self:getData().parent
		if misc.director:getAlarm(0) % 30 == 0 then
		if parent and parent:isValid() and not isa(parent, "PlayerInstance") then
			local expl = parent:fireExplosion(self.x, self.y, 12 / 19, 14 / 9, 0.1, nil, nil, DAMAGER_NO_PROC)
			DOT.addToDamager(expl, DOT_CORROSION, self:getData().damage, 4, "corrosive_elite_trail", false)
		else
			local expl = misc.fireExplosion(self.x, self.y, 12 / 19, 14 / 9, self:getData().damage, self:getData().team)
			DOT.addToDamager(expl, DOT_CORROSION, self:getData().damage, 4, "corrosive_elite_trail", false)
		end
	end
	if self:getData().life > 0 then
		self:getData().life = self:getData().life - 1
	elseif self.alpha > 0 then
		self.alpha = self.alpha - 0.1
	else
		self:destroy()
	end
end)

obj.AttackMissed = Object.new("AttackMissed")
obj.AttackMissed.sprite = Sprite.load("EfMissed", "Gameplay/missed", 1, 18, 3)
obj.AttackMissed:addCallback("create", function(self)
	self.alpha = 3
end)
obj.AttackMissed:addCallback("step", function(self)
	if self.alpha > 0 then
		self.y = self.y - 0.3
		self.alpha = self.alpha - 0.05
	else
		self:destroy()
	end
end)