local path = "Items/Resources/"

it.ErraticGadget = Item.new("Erratic Gadget")
local objErraticGadget = Object.new("ErraticGadget")
local sErraticGadget = Sound.load("ErraticGadget", path.."erraticGadget")
objErraticGadget.sprite = Sprite.load("ErraticGadgetDisplay", path.."erraticGadgetdis.png", 4, 5, 5)
it.ErraticGadget.pickupText = "Critical strikes deal extra damage." 
it.ErraticGadget.sprite = Sprite.load("ErraticGadget", path.."Erratic Gadget.png", 1, 11, 15)
it.ErraticGadget:setTier("rare")
it.ErraticGadget:setLog{
	group = "rare_locked",
	description = "Critical strikes deal &y&50% extra damage.",
	story = "Pulse weapons are my favorite in the battlefield, and they might be your's now too! Please take this as I can assure you it will grant you a huge advantage over your enemies if you use it wisely. Always go for the head, leave those [REDACTED] with no chances of survival. Show them what we're made of.\n-Uncle Hoogehn",
	priority = "&y&Volatile&!&",
	destination = "S159,\nNoev Londa,\nVenus",
	date = "01/15/2056"
}
objErraticGadget:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	selfData.spin = 0
	self.spriteSpeed = 0.2
end)
objErraticGadget:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	if selfData.parent and selfData.parent:isValid() then
		selfData.spin = selfData.spin + 0.04
		local xx = math.cos(selfData.spin) * 25
		local yy = math.sin(selfData.spin) * 25
		self.x = selfData.parent.x + xx
		self.y = selfData.parent.y + yy
	else
		self:destroy()
	end
end)
objErraticGadget:addCallback("draw", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	if selfData.parent and selfData.parent:isValid() then
		for _, actor in ipairs(pobj.actors:findAll()) do
			local d = actor:getData()
			if d.errGadgetP == selfData.parent then
				graphics.color(Color.fromRGB(168, 255, 255))
				graphics.line(self.x, self.y, actor.x, actor.y, 4 * d.errGadgetT)
			end
		end
	end
end)
it.ErraticGadget:addCallback("pickup", function(player)
	if player:get("erraticGadget") then
		player:set("erraticGadget", player:get("erraticGadget") + 1)
	else
		player:set("erraticGadget", 1)
	end
	
	local children = 0
	for _, object in ipairs(objErraticGadget:findAll()) do
		if object:getData().parent == player then
			children = children + 1
			break
		end
	end
	if children < player:get("erraticGadget") then
		local gadget = objErraticGadget:create(player.x, player.y)
		gadget:set("persistent", 1)
		gadget:getData().parent = player
	end
end)
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.ErraticGadget then
		--if amount >= player:countItem(it.ErraticGadget) then
			local count = 0
			for _, o in ipairs(objErraticGadget:findAll()) do
				if o:getData().parent == player then
					o:destroy()
					count = count + 1
					if count == amount then
						break
					end
				end
			end
		--end
	end
end)
callback.register("onActorStep", function(actor)
	local actorAc = actor:getAccessor()
	local actorData = actor:getData()
	if actorData.errGadgetT and actorData.errGadgetT > 0 then
		actorData.errGadgetT = actorData.errGadgetT - 0.2
	else
		actorData.errGadgetT = nil
		actorData.errGadgetP = nil
	end
end)


table.insert(call.preHit, function(damager, hit)
	local damagerAc = damager:getAccessor()
	local hitData = hit:getData()
	local parent = damager:getParent()
	
	if parent and parent:isValid() then
		local parentAc = parent:getAccessor()
		local erraticGadget = parentAc.erraticGadget
		if erraticGadget and erraticGadget > 0 and damagerAc.critical == 1 then
			if damagerAc.damage > 0 then
				damagerAc.damage = damagerAc.damage * (1 + (0.5 * erraticGadget)) 
				if global.showDamage then
					misc.damage(damagerAc.damage_fake * (0.5 * erraticGadget), hit.x - 20, hit.y - 25 - damagerAc.climb , true, Color.fromRGB(168, 255, 255))
				end
			end
			if hit:getObject() ~= obj.WormBody then
				sErraticGadget:play(0.9 + math.random() * 0.2)
				misc.shakeScreen(3)
				hitData.errGadgetT = 1
				hitData.errGadgetP = parent
			end
		end
	end
end)