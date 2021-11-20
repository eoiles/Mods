local path = "Items/Resources/"

it.Roulette = Item.new("Roulette")
local rouletteVars = {{var = "maxhp_base", val = 30}, {var = "hp_regen", val = 0.004}, {var = "damage", val = 5}, {var = "attack_speed", val = 0.15}, {var = "critical_chance", val = 11}, {var = "pHmax", val = 0.2}, {var= "armor", val = 10}}
local sRoulette = Sound.load("Roulette", path.."roulette")
it.Roulette.pickupText = "Random stat increase every minute." 
it.Roulette.sprite = Sprite.load("Roulette", path.."Roulette.png", 1, 14, 9)
roulettedis = Sprite.load("RouletteDisplay", path.."roulettedis.png", 8, 20, 20)
objRoulette = Object.new("Roulette")
objRoulette.sprite = roulettedis
it.Roulette:setTier("uncommon")
it.Roulette:setLog{
	group = "uncommon_locked",
	description = "Get a &y&random stat increase every minute.",
	story = "Replacement Roulette model 144Bella-1 in follow-up to the recent events that unfolded in the casino. For further inquiries please contact us at the E-direction given by our representatives.",
	destination = "PRoom 3.1,\nSecva Casino,\nEarth",
	date = "7/17/2057"
}
callback.register("onItemRemoval", function(player, item, count)
	if item == it.Roulette then
		if count >= player:countItem(item) then
			local pData = player:getData()
			if pData._rouletteres then
				for _, data in ipairs(pData._rouletteres) do
					player:set(data.var, player:get(data.var) - data.val)
				end
			end
		end
	end
end)
objRoulette:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.subimage = 1
	selfAc.rspeed = 1
	selfAc.timer = 0
	selfAc.life = 120
	self.spriteSpeed = 0
	selfAc.blend = 1 
	sRoulette:play(0.9 + math.random() * 0.2)
end)
objRoulette:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	if selfAc.life > 80 then
		selfAc.rspeed = selfAc.rspeed * 1.1
		self.angle = self.angle + selfAc.rspeed
	else
		selfAc.blend = selfAc.blend - 0.01
		self.y = self.y - 0.05
		self.blendColor = Color.mix(Color.BLACK, Color.WHITE, selfAc.blend)
		self.alpha = selfAc.blend
		if selfAc.variable ~= nil then
			local var = selfAc.variable
			for i, t in ipairs(rouletteVars) do
				if var == t.var then
					self.subimage = i + 1
					break
				end
			end
		end
		self.angle = 0
	end
	if selfAc.life <= 0 then
		self:destroy()
	else
		selfAc.life = selfAc.life - 1
	end
end)

local function doRoulette(player, count)
	local pData = player:getData()
	local roulette_t = pData.roulette
	local roulettevalue = roulette_t.val * (0.7 + 0.3 * count)
	player:set(roulette_t.var, player:get(roulette_t.var) + roulettevalue)
	pData.lastRoulette = {roulette_t.var, roulettevalue}
	roulette = objRoulette:create(player.x, player.y - 50)
	roulette:set("variable", roulette_t.var)
	if not pData._rouletteres then
		pData._rouletteres = {}
	end
	table.insert(pData._rouletteres, {var = roulette_t.var, val = roulettevalue})
end

local syncRoulette = net.Packet.new("SSRoulette", function(player, player, value, count)
	if player and player:resolve() and value and count then
		local playerInstance = player:resolve()
		playerInstance:getData().roulette = rouletteVars[value]
		doRoulette(playerInstance, count)
	end
end)

table.insert(call.onPlayerStep, function(player)
	local playerData = player:getData()
	
	local roulette = player:countItem(it.Roulette)
	if roulette > 0 then
		if misc.director:get("time_start")%60 == 0 and misc.director:getAlarm(0) == 60 and misc.getTimeStop() == 0 then
			playerData.roulette = nil
		end
		if playerData.roulette == nil then
			if not net.online or net.host then
				local choice = math.random(1, #rouletteVars)
				playerData.roulette = rouletteVars[choice]
				if net.online then
					syncRoulette:sendAsHost(net.ALL, nil, player:getNetIdentity(), choice, roulette)
				end
				doRoulette(player, roulette)
			elseif not net.online then
			--	playerData.roulette = table.random(rouletteVars)
			---	doRoulette(player, roulette)
			end
		end
	end
end)