-- DIFFICULTIES

dif.Typhoon = Difficulty.new("Typhoon")
dif.Typhoon.displayName = "Typhoon"
dif.Typhoon.icon = Sprite.load("Difficulty_Typhoon2", "Gameplay/HUD/difTyphoonMenu", 3, 13, 11)
dif.Typhoon.scale = 0.2
dif.Typhoon.scaleOnline = 0.026
local color = tostring(Color.fromHex(0xE550A7).gml)
dif.Typhoon.description = "&"..color.."&-TYPHOON-&!&\n&r&The maximum challenge.&!&\nThe planet is a nightmare, survival is merely an illusion.\nNobody has what it takes."
dif.Typhoon.enableMissileIndicators = false
dif.Typhoon.forceHardElites = true
dif.Typhoon.enableBlightedEnemies = true

dif.Monsoon.description = "&r&-MONSOON-&!&\nFor hardcore players.\nEvery bend introduces pain and horrors of the planet.\nYou might die."

obj.Teleporter:addCallback("create", function(self)
	if Difficulty.getActive() == dif.Typhoon and Stage.getCurrentStage() ~= stg.BoarBeach then
		self:set("maxtime", 7200)
	end
end)
obj.BlastdoorPanel:addCallback("create", function(self)
	if Difficulty.getActive() == dif.Typhoon then
		self:set("maxtime", 2700)
	end
end)

table.insert(call.onPlayerStep, function(player)
	if Difficulty.getActive() == dif.Typhoon then
		if misc.director:getAlarm(0) == 30 then
			if player:collidesWith(obj.Lava, player.x, player.y) then
				DOT.applyToActor(player, DOT_FIRE, player:get("maxhp") * 0.05, 5, "lava", false)
			end
		end
		
		local sw, sh = Stage.getDimensions()
		
		if player.y > sh then
			if not player:getData().fallen then
				player:getData().fallen = true
				player:set("hp", player:get("hp") - player:get("hp") * 0.5)
			end
		elseif player:getData().fallen then
			player:getData().fallen = nil
		end
	end
end)