-- Item Chest

local sprItemChest = Sprite.load("ItemChest", "Interactables/Resources/itemChest", 15, 21, 24)

obj.ItemChest = Object.new("ItemChest")
obj.ItemChest.sprite = sprItemChest
obj.ItemChest.depth = -9

local syncItemChestItem = net.Packet.new("SSItemChestItem", function(player, x, y, item, cost, amount)
	local instanceI = obj.ItemChest:findNearest(x, y)
	if instanceI and instanceI:isValid() and item then
		instanceI:getData().item = item
		instanceI:getData().amount = amount
		instanceI:set("cost", cost)
	end
end)

local rarityCosts = {
	[itp.common] = 400,
	[itp.uncommon] = 700,
	[itp.rare] = 1000
}
local rarityMults = {
	[itp.common] = 1.8,
	[itp.uncommon] = 0.6,
	[itp.rare] = 0.1
}

obj.ItemChest:addCallback("create", function(self)
	local selfData = self:getData()
	local pool = table.irandom({itp.common, itp.uncommon, itp.rare})
	selfData.item = pool:roll()
	self:set("f", 0)
	self:set("yy", 0)
	self:set("active", 0)
	
	local dif = misc.director:get("enemy_buff")
	local range = (math.random(3, 12) * 0.1)
	if pool == itp.rare then
		range = (math.random(6, 11) * 0.1)
	end
	local dif2 = dif * range
	
	if misc.director and misc.director:isValid() then
		local cost = math.ceil(((dif * math.max(dif2 * 0.2 * 0.25, 1)) - 0.5) * rarityCosts[pool]) * getRule(1, 16)
		self:set("cost", math.max(cost, 0))
	end
	selfData.amount = math.ceil(dif2 * rarityMults[pool])
	selfData.uses = 3
	self:set("myplayer", -4)
	self:set("activator", 3)
	for i = 0, 500 do
		if self:collidesMap(self.x, self.y + i) then
			self.y = self.y + i - 1 
			break
		end
	end
	self.spriteSpeed = 0
	
	selfData.synctimer = 20
	selfData.yoffset = 0
end)

obj.ItemChest:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfData.synctimer and net.online and net.host then
		if selfData.synctimer > 0 then
			selfData.synctimer = selfData.synctimer - 1
		else
			syncItemChestItem:sendAsHost(net.ALL, nil, self.x, self.y, selfData.item, selfAc.cost, selfData.amount)
			selfData.synctimer = nil
		end
	end
	
	selfAc.f = selfAc.f + 0.05
	selfAc.yy = math.cos(selfAc.f) * 2
	
	if selfAc.active == 0 then
		for _, player in ipairs(obj.P:findAllRectangle(self.x - 14, self.y - 42,self.x + 14, self.y + 2)) do
			selfAc.myplayer = player.id
			
			if player:isValid() and player:control("enter") == input.PRESSED then
				if not net.online or net.localPlayer == player then
					if misc.getGold() >= selfAc.cost and selfData.uses > 0 then
						
						if net.online then
							if net.host then
								syncInteractableActivation:sendAsHost(net.ALL, nil, player:getNetIdentity(), self.x, self.y, self:getObject())
							else
								hostSyncInteractableActivation:sendAsClient(player:getNetIdentity(), self.x, self.y, self:getObject())
							end	
						end
						
						misc.setGold(misc.getGold() - selfAc.cost)
						
						_newInteractables[obj.ItemChest].activation(self, player)
					else
						sfx.Error:play()
					end
				end
			end
		end
	elseif selfAc.active == 2 then
		if selfData.uses > 0 then
			if self.subimage < 2 then
				selfAc.active = 0
				self.spriteSpeed = 0
				self.subimage = 1
			end
		else
			if self.subimage >= 9 then
				self.spriteSpeed = 0
				self.subimage = 9
			end
		end
	end
end)

obj.ItemChest:addCallback("draw", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfAc.active == 0 then
		graphics.color(Color.WHITE)
		local image = selfData.item.sprite
		local yy = self:get("yy")
		graphics.drawImage{
			image = image,
			x = self.x,
			y = self.y - 37 + yy,
			alpha = 0.7,
			subimage = 2
		}
		
		if selfData.amount > 1 then
			graphics.alpha(0.7)
			graphics.print("x"..selfData.amount, self.x - 11, math.round(self.y - 31 + yy), nil, graphics.ALIGN_LEFT)
		end
		
	
		if obj.P:findRectangle(self.x - 14, self.y - 42, self.x + 14, self.y + 2) and selfAc.myplayer ~= -4 then
			local player = Object.findInstance(selfAc.myplayer)
			
			local keyStr = "Activate"
			if player and player:isValid() then
				keyStr = input.getControlString("enter", player)
			end
			
			local costStr = ""
			if selfAc.cost > 0 then
				costStr = " &y&($"..selfAc.cost..")"
			end
			
			local text = ""
			local pp = not net.online or player == net.localPlayer
			if input.getPlayerGamepad(player) and pp then
				text = "Press ".."'"..keyStr.."'".." to purchase item"..costStr
			else
				text = "Press ".."&y&'"..keyStr.."'&!&".." to purchase item"..costStr
			end
			graphics.alpha(1)
			graphics.printColor(text, self.x - 78, self.y - 57)
		end
	end
	
	if selfAc.cost > 0 and selfAc.active == 0 then
		graphics.alpha(0.85 - (math.random(0, 15) * 0.01))
		graphics.color(Color.fromHex(0xEFD27B))
		graphics.print("&y&$"..selfAc.cost, self.x - 3, self.y + 6 + selfData.yoffset, graphics.FONT_DAMAGE, graphics.ALIGN_MIDDLE, graphics.ALIGN_TOP)
	end
end)

return obj.ItemChest