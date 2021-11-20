
-- All Achievement data

if not global.rormlflag.ss_no_survivors and not global.rormlflag.ss_disable_survivors then

-- Executioner Achievement
local acExecutioner = Achievement.new("Executioner")

table.insert(call.onHit, function(damager, hit)
	if damager:get("parent") then
		local parent = Object.findInstance(damager:get("parent"))
		if parent and isa(parent, "PlayerInstance") then
			if not net.online or parent == net.localPlayer then
				if damager:get("damage") >= hit:get("maxhp") * 10 and hit:get("team") == "enemy" then
					acExecutioner:increment(1)
				end
			end
		end
	end
end)
acExecutioner.requirement = 1
acExecutioner.deathReset = false
acExecutioner.unlockText = "This character is now playable."
acExecutioner.description = "Kill an enemy by dealing 1000% or more of its health as damage."
acExecutioner.highscoreText = "Executioner Unlocked"
acExecutioner:assignUnlockable(sur.Executioner)

-- MULE Achievement
local acMule = Achievement.new("MULE")

table.insert(call.onPlayerStep, function(player)
	if not net.online or player == net.localPlayer then
		if player:getData().survivedStorm then
			acMule:increment(1)
		end
	end
end)
acMule.requirement = 1
acMule.deathReset = false
acMule.unlockText = "This character is now playable."
acMule.description = "Survive a storm."
acMule.highscoreText = "MULE Unlocked"
acMule:assignUnlockable(sur.MULE)
acMule.sprite = sur.MULE.idleSprite

-- Cyborg Achievement
local acCyborg = Achievement.new("Cyborg")

table.insert(call.onPlayerStep, function(player)
	if not net.online or player == net.localPlayer then
		if player:countItem(it.LaserTurbine) > 0 and player:countItem(it.RepulsionArmor) > 0 then
			acCyborg:increment(1)
		end
	end
end)
acCyborg.requirement = 1
acCyborg.deathReset = false
acCyborg.unlockText = "This character is now playable."
acCyborg.description = "Carry a 'Laser Turbine' and 'Repulsion Armor' at the same time."
acCyborg.highscoreText = "Cyborg Unlocked"
acCyborg:assignUnlockable(sur.Cyborg)

-- Technician Achievement
local acTech = Achievement.new("Technician")
local objTecFlag = Object.new("TechnicianFlag")
local usedSprite = Sprite.load("TechnicianFlagUsed", "Interactables/Resources/techFlagUsed.png", 3, 20, 30)
objTecFlag.sprite = Sprite.load("TechnicianFlag", "Interactables/Resources/techFlag.png", 2, 20, 30)
objTecFlag:addCallback("create", function(self)
	self.spriteSpeed = 0.08
	self:getData().activated = false
end)
objTecFlag:addCallback("step", function(self)
	local player = obj.P:findEllipse(self.x - 20, self.y - 10, self.x + 20, self.y + 10)
	if player and player:isValid() then
		if player:control("enter") == input.PRESSED and self:getData().activated == false then
			misc.shakeScreen(4)
			self:getData().activated = true
			self.sprite = usedSprite
			self.spriteSpeed = 0.2
			local pod = obj.PodBehind:create(self.x + 200, self.y)
			pod:getData().isTech = true
			self:getData().timer = 150
		end
	end
	if self:getData().timer then
		if self:getData().timer > 0 then
			self:getData().timer = self:getData().timer - 1
		else
			acTech:increment(1)
		end
	end
end)
objTecFlag:addCallback("draw", function(self)
	if self:getData().activated == false then
		local player = obj.P:findEllipse(self.x - 20, self.y - 10, self.x + 20, self.y + 10)
		if player then
			graphics.color(Color.WHITE)
			graphics.printColor("Send coordinates? Press &y&'"..input.getControlString("enter", player).."'&!&", self.x + 2 - 70, self.y - 40)
		end
	end
end)
table.insert(call.onStageEntry, function()
	local currentStage = Stage.getCurrentStage()
	if currentStage == stg.AncientValley then
		if Stage.collidesPoint(1984, 788) == false then
			objTecFlag:create(2016, 1888)
		end
	end
end)
obj.PodBehind:addCallback("create", function(self)
	if self:getData().isTech then
		self.x = 2016
		self.y = 1888
		self:set("achievement_id", 1)
	end
end)
acTech.requirement = 1
acTech.deathReset = false
acTech.unlockText = "This character is now playable."
acTech.description = "Call the orbited survivor."
acTech.highscoreText = "Technician Unlocked"
acTech:assignUnlockable(sur.Technician)

-- Nucleator Achievement
local acNucleator = Achievement.new("Nucleator")
local relics = itp.relic

callback.register("onItemPickup", function(item, player)
	if not net.online or player == net.localPlayer then
		if relics:contains(item:getItem()) then
			if not player:getData().nucleatorAchievement then
				player:getData().nucleatorAchievement = 1
			else
				acNucleator:increment(1)
			end
		end
	end
end)
acNucleator.requirement = 1
acNucleator.deathReset = false
acNucleator.unlockText = "This character is now playable."
acNucleator.description = "Obtain two relic items in a single run."
acNucleator.highscoreText = "Nucleator Unlocked"
acNucleator:assignUnlockable(sur.Nucleator)

-- Baroness Achievement
local acBaroness = Achievement.new("Baroness")

local objBike = Object.new("BaronessBike")
objBike.sprite = Sprite.load("BaronessBike", "Interactables/Resources/baronessBike.png", 2, 11, 11)
objBike:addCallback("create", function(self)
	self.spriteSpeed = 0
end)
objBike:addCallback("step", function(self)
	local player = obj.P:findEllipse(self.x - 20, self.y - 10, self.x + 20, self.y + 10)
	if player and player:isValid() and not runData.baronessQuestActive then
		if player:control("enter") == input.PRESSED and not self:getData().activated then
			misc.shakeScreen(4)
			self:getData().activated = true
			self.subimage = 1
			local task = "Find the sunken battery"
			runData.baronessQuestActive = 1
			local baronessQuest = Quest.set("Myserious Vehicle")
			local baronessObjective = Quest.setObjective(baronessQuest, task, nil, nil, false)
			if net.host then
				createFakeItem(self.x, self.y - 20, player.id, "Quest Obtained", task)
			else
				syncFakeItem:sendAsClient(self.x, self.y - 20, player:getNetIdentity(), "Quest Obtained", task)
			end
		end
		if not self:getData().activated then
			self.subimage = 2
		end
	else
		self.subimage = 1
	end
end)
objBike:addCallback("draw", function(self)
	if not self:getData().activated and not runData.baronessQuestActive then
		local player = obj.P:findEllipse(self.x - 20, self.y - 10, self.x + 20, self.y + 10)
		if player then
			graphics.color(Color.WHITE)
			graphics.printColor("An unpowered vehicle. Press &y&'"..input.getControlString("enter", player).."'&!& to inspect", self.x + 2 - 100, self.y - 40)
		end
	end
end)

local objBattery = Object.new("BaronessBattery")
objBattery.sprite = Sprite.load("BaronessBattery", "Interactables/Resources/baronessBattery.png", 2, 11, 11)
objBattery:addCallback("create", function(self)
	self.spriteSpeed = 0
end)
objBattery:addCallback("step", function(self)
	local player = obj.P:findEllipse(self.x - 20, self.y - 10, self.x + 20, self.y + 10)
	if player and player:isValid() and runData.baronessQuestActive == 1 then
		if player:control("enter") == input.PRESSED and not self:getData().activated then
			misc.shakeScreen(4)
			self:getData().activated = true
			self.subimage = 1
			acBaroness:increment(1)
			obj.PodBehind:create(self.x, self.y)
			local task = "Find the sunken battery"
			runData.baronessQuestActive = 2
			local baronessQuest = Quest.set("Myserious Vehicle")
			local baronessObjective = Quest.setObjective(baronessQuest, task, nil, nil, true)
		end
		if not self:getData().activated then
			self.subimage = 2
		end
	else
		self.subimage = 1
	end
end)
objBattery:addCallback("draw", function(self)
	if not self:getData().activated and runData.baronessQuestActive == 1 then
		local player = obj.P:findEllipse(self.x - 20, self.y - 10, self.x + 20, self.y + 10)
		if player then
			graphics.color(Color.WHITE)
			graphics.printColor("A battery. Press &y&'"..input.getControlString("enter", player).."'&!& to pick up", self.x + 2 - 90, self.y - 40)
		end
	end
end)


table.insert(call.onStageEntry, function()
	local currentStage = Stage.getCurrentStage()
	if currentStage == stg.TempleoftheElders then
		objBike:create(164, 816)
	elseif currentStage == stg.SunkenTombs then
		objBattery:create(493, 800)
	end
end)
acBaroness.requirement = 1
acBaroness.deathReset = false
acBaroness.unlockText = "This character is now playable."
acBaroness.description = "Charge the mysterious unpowered vehicle."
acBaroness.highscoreText = "Baroness Unlocked"
acBaroness:assignUnlockable(sur.Baroness)


-- Chirr Achievement
local acChirr = Achievement.new("Chirr")

table.insert(call.onPlayerStep, function(player)
	if not net.online or player == net.localPlayer then
		if player:getData().achievementHives then
			acChirr:increment(1)
			player:getData().achievementHives = nil
		end
	end
end)
acChirr.requirement = 1
acChirr.deathReset = false
acChirr.unlockText = "This character is now playable."
acChirr.description = "Eliminate the infestation in the Verdant Woodland."
acChirr.highscoreText = "Chirr Unlocked"
acChirr:assignUnlockable(sur.Chirr)


-- Pyro Achievement
local acPyro = Achievement.new("Pyro")

table.insert(call.onPlayerStep, function(player)
	if not net.online or player == net.localPlayer then
		if not player:getData().achievementPyro then
			local r = 200
			if obj.Deadman:findRectangle(player.x - r, player.y - r, player.x + r, player.y + r) then
				acPyro:increment(1)
				player:getData().achievementPyro = true
			end
		end
	end
end)
table.insert(call.onStageEntry, function()
	for _, player in ipairs(misc.players) do
		player:getData().achievementPyro = nil
	end
end)
acPyro.deathReset = false
acPyro.requirement = 4
acPyro.unlockText = "This character is now playable."
acPyro.description = "Find the bloated survivor 4 times."
acPyro.highscoreText = "Pyro Unlocked"
acPyro:assignUnlockable(sur.Pyro)


-- DU-T Achievement
local acDUT = Achievement.new("DUT")

table.insert(call.onStageEntry, function()
	local stage = Stage.getCurrentStage()
	if stage == stg.Void then
		runData.lastStgVoid = true
	elseif runData.lastStgVoid then
		runData.lastStgVoid = false
		acDUT:increment(1)
		Scores.updateValue(sco.void, Scores.getValue(sco.ethereal) + 1)
	end
end)

acDUT.deathReset = false
acDUT.requirement = 3
acDUT.unlockText = "This character is now playable."
acDUT.description = "Survive The Void 3 times."
acDUT.highscoreText = "DU-T Unlocked"
acDUT:assignUnlockable(sur.DUT)


-- Knight Achievement
acKnight = Achievement.new("Knight")

callback.register("onProvidenceDefeat", function(actor)
	if ExtraDifficulty.getCurrent() > 0 then
		acKnight:increment(1)
	end
end)

acKnight.deathReset = false
acKnight.requirement = 1
acKnight.unlockText = "This character is now playable."
acKnight.description = "Defeat Ultra Providence."
acKnight.highscoreText = "Knight Unlocked"
acKnight:assignUnlockable(sur.Knight)


-- Seraph Achievement
acSeraph = Achievement.new("Seraph")

acSeraph.deathReset = false
acSeraph.requirement = 1
acSeraph.unlockText = "This character is now playable."
acSeraph.description = "Collect the 6 shards from The Stranger."
acSeraph.highscoreText = "Seraph Unlocked"
acSeraph:assignUnlockable(sur.Seraph)
end


if not global.rormlflag.ss_no_items and not global.rormlflag.ss_disable_items then
-- Counterfeit Teleporter Achievement
local acCountTele = Achievement.new("CounterfeitTeleporter")
acCountTele.requirement = 1
acCountTele.deathReset = false
acCountTele.unlockText = "This item will now drop."
acCountTele.description = "Defeat Providence."
acCountTele.highscoreText = "\"".."Counterfeit Teleporter".."\"".." Unlocked"
acCountTele:assignUnlockable(it.CounterfeitTeleporter)
callback.register("onProvidenceDefeat", function()
	acCountTele:increment(1)
end)

-- Regeneration Achievement
local acRegen = Achievement.new("Regen")
table.insert(call.onPlayerStep, function(player)
	if not net.online or player == net.localPlayer then
		if player:get("lastHp") < player:get("hp") then
			local diff = player:get("hp") - player:get("lastHp")
			acRegen:increment(math.floor(diff))
		end
	end
end)
acRegen.requirement = 20000
acRegen.deathReset = false
acRegen.unlockText = "This item will now drop."
acRegen.description = "Regenerate a total of 20,000 hp."
acRegen.highscoreText = "\"".."Distinctive Stick".."\"".." Unlocked"
acRegen:assignUnlockable(it.DistinctiveStick)

-- Fork Achievement
local acFork = Achievement.new("Fork")
callback.register("onPlayerLevelUp", function(player)
	if not net.online or player == net.localPlayer then
		if player:get("level") >= 20 then
			acFork:increment(1)
		end
	end
end)
acFork.requirement = 1
acFork.deathReset = true
acFork.unlockText = "This item will now drop."
acFork.description = "Reach level 20."
acFork.highscoreText = "\"".."Fork".."\"".." Unlocked"
acFork:assignUnlockable(it.Fork)

--[[ Gift Card Achievement
local acGiftCard = Achievement.new("Gift Card")

callback.register("onSSInteractableAction", function(instance, player)
	if instance:getObject() == obj.EscapePod then
		if not net.online or player == net.localPlayer then
			acGiftCard:increment(1)
		end
	end
end)

acGiftCard.deathReset = false
acGiftCard.requirement = 50
acGiftCard.unlockText = "This item will now drop."
acGiftCard.description = "Open 50 broken escape pods."
acGiftCard.highscoreText = "\"".."Gift Card".."\"".." Unlocked"
acGiftCard:assignUnlockable(it.GiftCard)]]

-- Needles Achievement
local acNeedles = Achievement.new("Needles")
table.insert(call.onNPCDeathProc, function(npc, player)
	if not net.online or player == net.localPlayer then
		if npc:get("prefix_type") == 2 then
			acNeedles:increment(1)
		end
	end
end)
acNeedles.requirement = 1
acNeedles.deathReset = true
acNeedles.unlockText = "This item will now drop."
acNeedles.description = "Defeat a Blighted enemy."
acNeedles.highscoreText = "\"".."Needles".."\"".." Unlocked"
acNeedles:assignUnlockable(it.Needles)

-- Wonder Herbs Achievement
local acHerbs = Achievement.new("WonderHerbs")
buff.daze:addCallback("start", function(actor)
	if actor:isValid() and isa(actor, "PlayerInstance") then
		if not net.online or actor == net.localPlayer then
			acHerbs:increment(1)
		end
	end
end)
acHerbs.requirement = 6
acHerbs.deathReset = false
acHerbs.unlockText = "This item will now drop."
acHerbs.description = "Get dazed a total of 6 times."
acHerbs.highscoreText = "\"".."Wonder Herbs".."\"".." Unlocked"
acHerbs:assignUnlockable(it.WonderHerbs)

-- Ice Tool Achievement
local acIceTool = Achievement.new("IceTool")
table.insert(call.onPlayerStep, function(player)
	if not net.online or player == net.localPlayer then
		if player:get("distance_ran") >= 100000 then
			acIceTool:increment(1)
		end
	end
end)
acIceTool.requirement = 1
acIceTool.deathReset = true
acIceTool.unlockText = "This item will now drop."
acIceTool.description = "Travel a distance of 100,000m in a single run."
acIceTool.highscoreText = "\"".."Ice Tool".."\"".." Unlocked"
acIceTool:assignUnlockable(it.IceTool)

-- Roulette Achievement
local acRoulette = Achievement.new("Roulette")
table.insert(call.onStageEntry, function()
	if contains(Stage.progression[1]:toTable(), Stage.getCurrentStage()) then
		if misc.director:get("stages_passed") > 0 then
			acRoulette:increment(1)
		end
	end
end)
acRoulette.requirement = 3
acRoulette.deathReset = false
acRoulette.unlockText = "This item will now drop."
acRoulette.description = "Loop back to the first stage thrice."
acRoulette.highscoreText = "\"".."Roulette".."\"".." Unlocked"
acRoulette:assignUnlockable(it.Roulette)

-- Poisonous Gland Achievement
local acPoison = Achievement.new("Poison")
local poisonTimer = 0
table.insert(call.onPlayerStep, function(player)
	if not net.online or player == net.localPlayer then
		if obj.MushDust:findEllipse(player.x - 5, player.y - 5, player.x + 5, player.y + 5) then
			poisonTimer = poisonTimer + 1
		else
			poisonTimer = 0
		end
		if poisonTimer >= 300 then
			acPoison:increment(1)
		end	
	end
end)
acPoison.requirement = 1
acPoison.deathReset = false
acPoison.unlockText = "This item will now drop."
acPoison.description = "Stand on a poison cloud for 5 consecutive seconds."
acPoison.highscoreText = "\"".."Poisonous Gland".."\"".." Unlocked"
acPoison:assignUnlockable(it.PoisonousGland)

-- Crowning Valiance Achievement
local acCrown = Achievement.new("CrowningVal")
table.insert(call.onNPCDeathProc, function(_, player)
	if not net.online or player == net.localPlayer then
		if player:get("boss_count") >= 25 then
			acCrown:increment(1)
		end
	end
end)
acCrown.requirement = 1
acCrown.deathReset = true
acCrown.unlockText = "This item will now drop."
acCrown.description = "Eliminate 25 bosses in a single run."
acCrown.highscoreText = "\"".."Crowning Valiance".."\"".." Unlocked"
acCrown:assignUnlockable(it.CrowningValiance)

-- Hunter's Sigil Achievement
local acHunter = Achievement.new("HuntersSigil")
table.insert(call.onNPCDeathProc, function(npc, player)
	if not net.online or player == net.localPlayer then
		if npc:getObject() == obj.Eye then
			acHunter:increment(1)
		end
	end
end)
acHunter.requirement = 1
acHunter.deathReset = false
acHunter.unlockText = "This item will now drop."
acHunter.description = "Kill the Overseer."
acHunter.highscoreText = "\"".."Hunter's Sigil".."\"".." Unlocked"
acHunter:assignUnlockable(it.HuntersSigil)

-- Gold Medal Achievement
local acMedal = Achievement.new("GoldMedal")
table.insert(call.onStep, function()
	local gold = misc.hud:get("gold")
	
	local data = misc.hud:getData()
	
	if data.lastGold then
		if gold > data.lastGold then
			local dif = gold - data.lastGold
			
			acMedal:increment(dif)
		end
	end
	data.lastGold = gold
end)
acMedal.requirement = 1000000
acMedal.deathReset = false
acMedal.unlockText = "This item will now drop."
acMedal.description = "Earn an accumulated total of 1,000,000 gold."
acMedal.highscoreText = "\"".."Gold Medal".."\"".." Unlocked"
acMedal:assignUnlockable(it.GoldMedal)

-- Metachronic Trinket Achievement
local acMetaTrinket = Achievement.new("MetachronicTrinket")
table.insert(call.onStep, function()
	if not acMetaTrinket:isComplete() then
		local timeStop = misc.getTimeStop() > 0 and misc.director:get("time_start") > 10
		for _, tele in ipairs(obj.Teleporter:findAll()) do
			local active = tele:get("active")
			local data = tele:getData()
			if active >= 2 and data.lastActive and data.lastActive < 2 and timeStop and not obj.CustomTextbox:find(1) then
				acMetaTrinket:increment(1)
				break
			end
			data.lastActive = active
		end
	end
end)
acMetaTrinket.requirement = 1
acMetaTrinket.deathReset = false
acMetaTrinket.unlockText = "This item will now drop."
acMetaTrinket.description = "Fully charge a teleporter while time is stopped."
acMetaTrinket.highscoreText = "\"".."Metachronic Trinket".."\"".." Unlocked"
acMetaTrinket:assignUnlockable(it.Metatrinket)

-- Will-o-jelly Achievement
local acWillojelly = Achievement.new("willojelly")
table.insert(call.onNPCDeathProc, function(npc, player)
	if not net.online or player == net.localPlayer then
		if npc:getObject() == obj.Jelly then
			acWillojelly:increment(1)
		end
	end
end)
acWillojelly.requirement = 150
acWillojelly.deathReset = false
acWillojelly.unlockText = "This item will now drop."
acWillojelly.description = "Slay 150 jellyfishes."
acWillojelly.highscoreText = "\"".."Will-o'-the-jelly".."\"".." Unlocked"
acWillojelly:assignUnlockable(it.Willojelly)

-- Insecticide Achievement
local acInsecticide = Achievement.new("Insecticide")
onNPCDeath.insecticide = function(npc, object)
	if npc:isValid() then
		if object == obj.Bug then
			acInsecticide:increment(1)
		end
	end
end
acInsecticide.requirement = 150
acInsecticide.deathReset = false
acInsecticide.unlockText = "This item will now drop."
acInsecticide.description = "Slay 150 Archer Bugs."
acInsecticide.highscoreText = "\"".."Insecticide".."\"".." Unlocked"
acInsecticide:assignUnlockable(it.Insecticide)

-- Critical Achievement
local acCrit = Achievement.new("Critical")
table.insert(call.onPlayerStep, function(player)
	if not net.online or player == net.localPlayer then
		if player:get("critical_chance") >= 99 then
			acCrit:increment(1)
		end
	end
end)
acCrit.requirement = 1
acCrit.deathReset = true
acCrit.unlockText = "This item will now drop."
acCrit.description = "Achieve a 99% critical strike chance."
acCrit.highscoreText = "\"".."Erratic Gadget".."\"".." Unlocked"
acCrit:assignUnlockable(it.ErraticGadget)

-- Toys Achievement
local acToys = Achievement.new("Toys")
callback.register("onPlayerDeath", function(player)
	if not net.online or player == net.localPlayer then
		for _, tele in ipairs(obj.Teleporter:findMatchingOp("active", ">=", 2)) do
			acToys:increment(1)
			break
		end
	end
end)
acToys.requirement = 1
acToys.deathReset = true
acToys.unlockText = "This item will now drop."
acToys.description = "Die after fully charging a teleporter."
acToys.highscoreText = "\"".."Baby's Toys".."\"".." Unlocked"
acToys:assignUnlockable(it.BabyToys)

-- Injector Achievement
local acInjector = Achievement.new("Injector")
table.insert(call.onStageEntry, function()
	if misc.director:get("stages_passed") == 3 then
		if not net.online then
			for _, player in ipairs(misc.players) do
				if player.useItem == nil then
					acInjector:increment(1)
				end
			end
		else
			local player = net.localPlayer
			if player.useItem == nil then
				acInjector:increment(1)
			end
		end
	end
end)
acInjector.requirement = 1
acInjector.deathReset = true
acInjector.unlockText = "This item will now drop."
acInjector.description = "Reach stage 4 without an use item."
acInjector.highscoreText = "\"".."Composite Injector".."\"".." Unlocked"
acInjector:assignUnlockable(it.CompositeInjector)

-- Swift Skateboard Achievement
local acSkateboard = Achievement.new("Skateboard")
callback.register("postPlayerStep", function(player)
	if not net.online or player == net.localPlayer and not acSkateboard:isComplete() then
		local data = player:getData()
		if data.airTime then
			if player:get("free") == 1 and player:get("activity") < 30 and not player:collidesWith(obj.Elevator, player.x, player.y + 3) then
				data.airTime = data.airTime + 1
				if data.airTime == 10 * 60 then
					acSkateboard:increment(1)
				end
			else
				data.airTime = 0
			end
		else
			data.airTime = 0
		end
	end
end)
acSkateboard.requirement = 1
acSkateboard.deathReset = false
acSkateboard.unlockText = "This item will now drop."
acSkateboard.description = "Spend a total of 10 consecutive seconds mid-air."
acSkateboard.highscoreText = "\"".."Swift Skateboard".."\"".." Unlocked"
acSkateboard:assignUnlockable(it.SwiftSkateboard)

-- Egg Achievement
local acEgg = Achievement.new("Egg")
table.insert(call.onNPCDeathProc, function(npc, player)
	if not net.online or player == net.localPlayer then
		if npc:get("prefix_type") == 1 and npc:get("elite_type") == elt.Ethereal.id then
			acEgg:increment(1)
		end
	end
end)
acEgg.requirement = 1
acEgg.deathReset = true
acEgg.unlockText = "This item will now drop."
acEgg.description = "Slay an ethereal mob."
acEgg.highscoreText = "\"".."Juddering Egg".."\"".." Unlocked"
acEgg:assignUnlockable(it.JudderingEgg)

-- Galvanic Core Achievement
local acGalvanicCore = Achievement.new("GalvanicCore")
acGalvanicCore.requirement = 1
acGalvanicCore.deathReset = false
acGalvanicCore.unlockText = "This item will now drop."
acGalvanicCore.description = "Apply a total of 5 debuffs to a single enemy."
acGalvanicCore.highscoreText = "\"".."Galvanic Core".."\"".." Unlocked"
acGalvanicCore:assignUnlockable(it.GalvanicCore)
if not acGalvanicCore:isComplete() then
	callback.register("postLoad", function()
		for _, buff in ipairs(Buff.findAll()) do
			buff:addCallback("start", function(actor)
				if not isa(actor,"PlayerInstance") then
					if #actor:getBuffs() >= 5 then
						acGalvanicCore:increment(1)
					end
				end
			end)
		end
	end)
end

-- Roller Achievement
local acRoller = Achievement.new("Roller")
if itp.curse then
	for _, item in ipairs(itp.curse:toList()) do
		item:addCallback("pickup", function(player)
			if not net.online or player == net.localPlayer then
				acRoller:increment(1)
			end
		end)
	end
end
acRoller.requirement = 1
acRoller.deathReset = false
acRoller.unlockText = "This item will now drop."
acRoller.description = "Obtain a curse."
acRoller.highscoreText = "\"".."Roller".."\"".." Unlocked"
acRoller:assignUnlockable(it.Roller)

-- White Flag Achievement
local acWhiteFlag = Achievement.new("WhiteFlag")
callback.register("onPlayerDeath", function(player)
	if player:get("lastHp") == player:get("maxhp") then
		acWhiteFlag:increment(1)
	end
end)
acWhiteFlag.requirement = 1
acWhiteFlag.deathReset = false
acWhiteFlag.unlockText = "This item will now drop."
acWhiteFlag.description = "Die from a single hit at full health."
acWhiteFlag.highscoreText = "\"".."White Flag".."\"".." Unlocked"
acWhiteFlag:assignUnlockable(it.WhiteFlag)

-- Back Thruster Achievement
local acBackThruster = Achievement.new("BackThruster")
callback.register("onPlayerStep", function(player)
	if player:get("pHmax") >= 10 then
		acBackThruster:increment(1)
	end
end)
acBackThruster.requirement = 1
acBackThruster.deathReset = false
acBackThruster.unlockText = "This item will now drop."
acBackThruster.description = "Reach a speed stat of 10."
acBackThruster.highscoreText = "\"".."Back Thruster".."\"".." Unlocked"
acBackThruster:assignUnlockable(it.BackThruster)

end

if not global.rormlflag.ss_no_submenu and not global.rormlflag.ss_disable_submenu and not global.rormlflag.ss_no_skins and not global.rormlflag.ss_disable_skins then
-- Commando
local commando = sur.Commando
	
	-- Specialist
	local acSpecialist = Achievement.new("Specialist")
	acSpecialist.sprite = Sprite.find("SpecialistIdle", "Starstorm")
	acSpecialist.requirement = 1
	acSpecialist.deathReset = true
	acSpecialist.description = "Commando: Reach the fourth stage in 15 minutes or less."

	table.insert(call.onPlayerStep, function(player)
		if not net.online or player == net.localPlayer then
			if player:getSurvivor() == commando then
				if misc.director:get("stages_passed") == 3 and misc.hud:get("minute") < 15 then
					acSpecialist:increment(1)
				end
			end
		end
	end)	
	
	local specialist = SurvivorVariant.find(commando, "Specialist")
	SurvivorVariant.setRequirement(specialist, acSpecialist)
	
	
	-- Fatmando
	local fatmando = SurvivorVariant.find(commando, "Fatmando")
	local acFatmando = HiddenAchievement.new("Fatmando", fatmando)
	acFatmando.sprite = Sprite.find("FatmandoIdle", "Starstorm")
	acFatmando.requirement = 1
	acFatmando.deathReset = true
	acFatmando.description = "Commando: Reach a total of 5001 hp."

	table.insert(call.onPlayerStep, function(player)
		if not net.online or player == net.localPlayer then
			if player:getSurvivor() == commando and player:get("maxhp") >= 5001 then
				HiddenAchievement.increment(acFatmando, 1)
			end
		end
	end)	


-- Enforcer
local enforcer = sur.Enforcer
	
	-- Heavy
	local acHeavy = Achievement.new("Heavy")
	acHeavy.sprite = Sprite.find("HeavyIdleA", "Starstorm")
	acHeavy.requirement = 1
	acHeavy.deathReset = true
	acHeavy.description = "Enforcer: Stay in Shield Mode for a total of 8 minutes in a single run."

	table.insert(call.onPlayerStep, function(player)
		if not net.online or player == net.localPlayer then
			if player:getSurvivor() == enforcer and player:get("bunker") > 0 then
				if not player:getData().heavyAchievementProgress then
					player:getData().heavyAchievementProgress = 1
				else
					player:getData().heavyAchievementProgress = player:getData().heavyAchievementProgress + 1
				end
				if player:getData().heavyAchievementProgress == 28800 then
					acHeavy:increment(1)
				end
			end
		end
	end)	
	
	local heavy = SurvivorVariant.find(enforcer, "Heavy")
	SurvivorVariant.setRequirement(heavy, acHeavy)

-- Bandit
local bandit = sur.Bandit
	
	-- Reaper
	local acReaper = Achievement.new("Reaper")
	acReaper.sprite = Sprite.find("ReaperIdle", "Starstorm")
	acReaper.requirement = 1
	acReaper.deathReset = true
	acReaper.description = "Bandit: Obtain 'Harvester's Scythe' and 'Golden Gun' in the same run."

	table.insert(call.onPlayerStep, function(player)
		if not net.online or player == net.localPlayer then
			if player:getSurvivor() == bandit then
				if player:countItem(it.HarvestersScythe) > 0 and player:countItem(it.GoldenGun) > 0 then
					acReaper:increment(1)
				end
			end
		end
	end)	
	
	local reaper = SurvivorVariant.find(bandit, "Reaper")
	SurvivorVariant.setRequirement(reaper, acReaper)

-- Huntress
local huntress = sur.Huntress
	
	-- Arbalist
	local acArbalist = Achievement.new("Arbalist")
	acArbalist.sprite = Sprite.find("ArbalistIdle", "Starstorm")
	acArbalist.requirement = 1
	acArbalist.deathReset = true
	acArbalist.description = "Huntress: Slay 20 enemies in less than a second."
	
	local count = 0
	local timer = 0
	table.insert(call.onNPCDeathProc, function(npc, player)
		if not net.online or player == net.localPlayer then
			if player:getSurvivor() ==  huntress then
				count = count + 1
				if timer == 0 then
					timer = 60
				end
			end
		end
	end)
	table.insert(call.onStep, function()
		if timer > 0 then
			if count >= 20 then
				acArbalist:increment(1)
			end
			timer = timer - 1
		else
			count = 0
		end
	end)	
	
	local arbalist = SurvivorVariant.find(huntress, "Arbalist")
	SurvivorVariant.setRequirement(arbalist, acArbalist)
	
-- HAN-D
local hand = sur.HAND
	
	-- R-MOR
	local acRMOR = Achievement.new("R-MOR")
	acRMOR.sprite = Sprite.find("RMORIdleA", "Starstorm")
	acRMOR.requirement = 1
	acRMOR.deathReset = true
	acRMOR.description = "HAN-D: Reach a total of 150 armor."
	
	table.insert(call.onPlayerStep, function(player)
		if not net.online or player == net.localPlayer then
			if player:getSurvivor() == hand and player:get("armor") >= 150 then
				acRMOR:increment(1)
			end
		end
	end)	
	
	local rmor = SurvivorVariant.find(hand, "R-MOR")
	SurvivorVariant.setRequirement(rmor, acRMOR)
	
-- Engineer
local engineer = sur.Engineer
	
	-- Fungus Man
	local fungusman = SurvivorVariant.find(engineer, "Fungus Man")
	local acFungusMan = HiddenAchievement.new("Fungus Man", fungusman)
	acFungusMan.sprite = Sprite.find("FungusManIdle", "Starstorm")
	acFungusMan.requirement = 1
	acFungusMan.deathReset = true
	acFungusMan.description = "Engineer: Obtain 5 'Bustling fungus' in a single run."
	
	table.insert(call.onPlayerStep, function(player)
		if not net.online or player == net.localPlayer then
			if player:getSurvivor() == engineer and player:countItem(it.BustlingFungus) >= 5 then
				HiddenAchievement.increment(acFungusMan, 1)
			end
		end
	end)	
	
-- Miner
local miner = sur.Miner
	
	-- Blacksmith
	local acBlacksmith = Achievement.new("Blacksmith")
	acBlacksmith.sprite = Sprite.find("BlacksmithIdle", "Starstorm")
	acBlacksmith.requirement = 1
	acBlacksmith.deathReset = true
	acBlacksmith.description = "Miner: Finish 3 Shrine of Trial quests in a single run."
	
	table.insert(call.onPlayerStep, function(player)
		if not net.online or player == net.localPlayer then
			if player:getSurvivor() == miner and player:getData().finishedQuests and player:getData().finishedQuests >= 3 then
				acBlacksmith:increment(1)
			end
		end
	end)	
	
	local blacksmith = SurvivorVariant.find(miner, "Blacksmith")
	SurvivorVariant.setRequirement(blacksmith, acBlacksmith)
	
-- Sniper
local sniper = sur.Sniper
	
	-- Assassin
	local acAssassin = Achievement.new("Assassin")
	acAssassin.sprite = Sprite.find("AssassinIdle", "Starstorm")
	acAssassin.requirement = 1
	acAssassin.deathReset = true
	acAssassin.description = "Sniper: Deal a total of 2500% damage in a single shot."
	
	table.insert(call.onHit, function(damager)
		local player = damager:getParent()
		if player and isa(player, "PlayerInstance") then
			if not net.online or player == net.localPlayer then
				if player:getSurvivor() == sniper and damager:get("damage") >= 2500 then
					acAssassin:increment(1)
				end
			end
		end
	end)	
	
	local assassin = SurvivorVariant.find(sniper, "Assassin")
	SurvivorVariant.setRequirement(assassin, acAssassin)

-- Acrid
local acrid = sur.Acrid
	
	-- Acerbid
	local acAcerbid = Achievement.new("Acerbid")
	acAcerbid.sprite = Sprite.find("AcerbidIdle", "Starstorm")
	acAcerbid.requirement = 1
	acAcerbid.deathReset = true
	acAcerbid.description = "Acrid: Reach a regeneration of 5 HP per second."
	
	table.insert(call.onPlayerStep, function(player)
		if not net.online or player == net.localPlayer then
			if player:getSurvivor() == acrid and player:get("hp_regen") >= 0.08 then
				acAcerbid:increment(1)
			end
		end
	end)	
	
	local acerbid = SurvivorVariant.find(acrid, "Acerbid")
	SurvivorVariant.setRequirement(acerbid, acAcerbid)
	
-- Mercenary
local mercenary = sur.Mercenary
	
	-- Legionary
	local acLegionary = Achievement.new("Legionary")
	acLegionary.sprite = Sprite.find("LegionaryIdle", "Starstorm")
	acLegionary.requirement = 1
	acLegionary.deathReset = true
	acLegionary.description = "Mercenary: Succesfully charge an Ethereal Teleporter without dying."
	
	table.insert(call.onStep, function()
		if not runData.legionaryAchievement then
			for _, teleporter in ipairs(obj.Teleporter:findMatchingOp("active", ">", 1)) do
				if teleporter:get("isBig") then
					for _, player in ipairs(misc.players) do
						if not net.online or player == net.localPlayer then
							if player:getSurvivor() == mercenary and player:get("hp") >= 0 then
								acLegionary:increment(1)
								runData.legionaryAchievement = true
							end
						end
					end
					break
				end
			end
		end
	end)	
	
	local legionary = SurvivorVariant.find(mercenary, "Legionary")
	SurvivorVariant.setRequirement(legionary, acLegionary)
	
-- Loader
local loader = sur.Loader
	
	-- Prosecutor
	local acProsecutor = Achievement.new("Prosecutor")
	acProsecutor.sprite = Sprite.find("ProsecutorIdle", "Starstorm")
	acProsecutor.requirement = 1
	acProsecutor.deathReset = true
	acProsecutor.description = "Loader: Grapple 60 times in a single run."
	
	loader:addCallback("useSkill", function(player, skill)
		if skill == 3 then
			if not net.online or player == net.localPlayer then
				if not player:getData().skill3count then
					player:getData().skill3count = 1
				else
					player:getData().skill3count = player:getData().skill3count + 1
				end
				if player:getData().skill3count == 60 then
					acProsecutor:increment(1)
				end
			end
		end
	end)	
	
	local prosecutor = SurvivorVariant.find(loader, "Prosecutor")
	SurvivorVariant.setRequirement(prosecutor, acProsecutor)
	
-- CHEF
local chef = sur.CHEF
	
	-- NINJA
	local acNINJA = Achievement.new("NINJA")
	acNINJA.sprite = Sprite.find("NINJAIdle", "Starstorm")
	acNINJA.requirement = 1
	acNINJA.deathReset = true
	acNINJA.description = "CHEF: Reach an attack speed of 290%."
	
	table.insert(call.onPlayerStep, function(player)
		if not net.online or player == net.localPlayer then
			if player:getSurvivor() == chef and player:get("attack_speed") >= 2.9 then
				acNINJA:increment(1)
			end
		end
	end)	
	
	local ninja = SurvivorVariant.find(chef, "NINJA")
	SurvivorVariant.setRequirement(ninja, acNINJA)
	
if not global.rormlflag.ss_no_survivors and not global.rormlflag.ss_disable_survivors then
	
-- Executioner
local executioner = Survivor.find("Executioner", "Starstorm")
	
	-- Electrocutioner
	local acElectrocutioner = Achievement.new("Electrocutioner")
	acElectrocutioner.sprite = Sprite.find("ElectrocutionerIdle", "Starstorm")
	acElectrocutioner.requirement = 1
	acElectrocutioner.deathReset = true
	acElectrocutioner.description = "Executioner: Slay 12 overloading enemies in a single run."
	
	table.insert(call.onNPCDeathProc, function(npc, player)
		if npc:get("prefix_type") == 1 and npc:get("elite_type") == 3 then
			if not net.online or player == net.localPlayer then
				if player:getSurvivor() == executioner and player:get("hp") > 0 then
					if not player:getData().killedOverloading then
						player:getData().killedOverloading = 1
					else
						player:getData().killedOverloading = player:getData().killedOverloading + 1
					end
					if player:getData().killedOverloading == 12 then
						acElectrocutioner:increment(1)
					end
				end
			end
		end
	end)	
	
	local electrocutioner = SurvivorVariant.find(executioner, "Electrocutioner")
	SurvivorVariant.setRequirement(electrocutioner, acElectrocutioner)

-- Beta
local cyborg = Survivor.find("Cyborg", "Starstorm")
	
	-- Beta
	local acBeta = Achievement.new("Beta")
	acBeta.sprite = Sprite.find("CyImpIdle", "Starstorm")
	acBeta.requirement = 1
	acBeta.deathReset = true
	acBeta.description = "Survive wave 7 of the Red Plane."
	
	table.insert(call.onPlayerStep, function(player)
		if player:getData().survivedWave then
			if Achievement.find("Cyborg"):isComplete() then
				acBeta:increment(1)
			end
			player:getData().survivedWave = nil
		end
	end)	
	
	local beta = SurvivorVariant.find(cyborg, "Beta")
	SurvivorVariant.setRequirement(beta, acBeta)

-- Technician
local technician = Survivor.find("Technician", "Starstorm")
	
	-- Operator
	local acOperator = Achievement.new("Operator")
	acOperator.sprite = Sprite.find("Operator_IdleR", "Starstorm")
	acOperator.requirement = 10
	acOperator.deathReset = false
	acOperator.description = "Technician: Eliminate 10 enemies by dropping a vending machine on them."
	
	table.insert(call.onHit, function(damager, hit)
		if damager:getData().vendingImpact and damager:getData().vendingImpact:isValid() then
			if damager:get("damage") > hit:get("hp") then
				acOperator:increment(1)
			end
		end
	end)
	
	local operator = SurvivorVariant.find(technician, "Operator")
	SurvivorVariant.setRequirement(operator, acOperator)

-- Baroness
local baroness = Survivor.find("Baroness", "Starstorm")
	
	-- Boaroness
	local boaroness = SurvivorVariant.find(baroness, "Boaroness")
	local acBoaroness = HiddenAchievement.new("Boaroness", boaroness)
	acBoaroness.sprite = Sprite.find("Boaroness_Idle", "Starstorm")
	acBoaroness.requirement = 1
	acBoaroness.deathReset = true
	acBoaroness.description = "Baroness: Collect a White Undershirt."
	
	callback.register("onItemPickup", function(item, player)
		if player:getSurvivor() == baroness and item:getItem() == it["WhiteUndershirt(M)"] then
			if not net.online or net.localPlayer == player then
				HiddenAchievement.increment(acBoaroness, 1)
			end
		end
	end)

-- Knight
local knight = Survivor.find("Knight", "Starstorm")
	
	-- Guardian
	local acGuardian = Achievement.new("Guardian")
	acGuardian.sprite = Sprite.find("Guardian_Idle", "Starstorm")
	acGuardian.requirement = 20
	acGuardian.deathReset = false
	acGuardian.description = "Knight: Deflect a total of 50 attacks."
	
	sur.Knight:addCallback("step", function(player)
		if player:getData().achievementAdd then
			acGuardian:increment(player:getData().achievementAdd)
			player:getData().achievementAdd = nil
		end
	end)
	
	local guardian = SurvivorVariant.find(knight, "Guardian")
	SurvivorVariant.setRequirement(guardian, acGuardian)
end
end

if not global.rormlflag.ss_no_enemies and not global.rormlflag.ss_disable_enemies then
	-- Nemesis Commando
	local acNemesisCommando = Achievement.new("NemesisCommando")
	acNemesisCommando.sprite = Sprite.find("NemesisCommandoIdle", "Starstorm")
	acNemesisCommando.requirement = 1
	acNemesisCommando.deathReset = true
	acNemesisCommando.description = "Defeat Commando's Vestige."
	
	-- Nemesis Enforcer
	local acNemesisEnforcer = Achievement.new("NemesisEnforcer")
	acNemesisEnforcer.sprite = Sprite.find("NemesisEnforcerIdleA", "Starstorm")
	acNemesisEnforcer.requirement = 1
	acNemesisEnforcer.deathReset = true
	acNemesisEnforcer.description = "Defeat Enforcer's Vestige."
	--acNemesisEnforcer.parent = Achievement.find("unlock_enforcer")
	
	-- Nemesis Bandit
	local acNemesisBandit = Achievement.new("NemesisBandit")
	acNemesisBandit.sprite = Sprite.find("NemesisBanditIdle", "Starstorm")
	acNemesisBandit.requirement = 1
	acNemesisBandit.deathReset = true
	acNemesisBandit.description = "Defeat Bandit's Vestige."
	--acNemesisBandit.parent = Achievement.find("unlock_bandit")
	
	-- Nemesis Huntress
	local acNemesisHuntress = Achievement.new("NemesisHuntress")
	acNemesisHuntress.sprite = Sprite.find("NemesisHuntressIdle", "Starstorm")
	acNemesisHuntress.requirement = 1
	acNemesisHuntress.deathReset = true
	acNemesisHuntress.description = "Defeat Huntress' Vestige."
	--acNemesisHuntress.parent = Achievement.find("unlock_huntress")
	
	-- Nemesis HAN-D
	local acNemesisJanitor = Achievement.new("NemesisJanitor")
	acNemesisJanitor.sprite = Sprite.find("NemJanitorIdleA", "Starstorm")
	acNemesisJanitor.requirement = 1
	acNemesisJanitor.deathReset = true
	acNemesisJanitor.description = "Defeat HAN-D's Vestige."
	--acNemesisJanitor.parent = Achievement.find("unlock_hand")
	
	-- Nemesis Miner
	local acNemesisMiner = Achievement.new("NemesisMiner")
	acNemesisMiner.sprite = Sprite.find("NemesisMinerIdle", "Starstorm")
	acNemesisMiner.requirement = 1
	acNemesisMiner.deathReset = true
	acNemesisMiner.description = "Defeat Miner's Vestige."
	
	-- Nemesis Sniper
	local acNemesisSniper = Achievement.new("NemesisSniper")
	acNemesisSniper.sprite = Sprite.find("NemesisSniperIdle", "Starstorm")
	acNemesisSniper.requirement = 1
	acNemesisSniper.deathReset = true
	acNemesisSniper.description = "Defeat Sniper's Vestige."
	
	
	local acNemesisExecutioner
	
	if not global.rormlflag.ss_no_survivors and not global.rormlflag.ss_disable_survivors then
		
		-- Nemesis Executioner
		acNemesisExecutioner = Achievement.new("NemesisExecutioner")
		acNemesisExecutioner.sprite = Sprite.find("NemesisExecutionerIdle", "Starstorm")
		acNemesisExecutioner.requirement = 1
		acNemesisExecutioner.deathReset = true
		acNemesisExecutioner.description = "Defeat Executioner's Vestige."
		
	end

	onNPCDeath.nemesisac = function(actor)
		if actor:getData().isNemesis then
			if actor:getData().isNemesis == "Commando" then
				acNemesisCommando:increment(1)
			elseif actor:getData().isNemesis == "Enforcer" and Achievement.find("unlock_enforcer"):isComplete() then
				acNemesisEnforcer:increment(1)
			elseif actor:getData().isNemesis == "Bandit" and Achievement.find("unlock_bandit"):isComplete() then
				acNemesisBandit:increment(1)
			elseif actor:getData().isNemesis == "Huntress" and Achievement.find("unlock_huntress"):isComplete() then
				acNemesisHuntress:increment(1)
			elseif actor:getData().isNemesis == "HAN-D" and Achievement.find("unlock_hand"):isComplete() then
				acNemesisJanitor:increment(1)
			elseif actor:getData().isNemesis == "Miner" and Achievement.find("unlock_miner"):isComplete() then
				acNemesisMiner:increment(1)
			elseif actor:getData().isNemesis == "Sniper" and Achievement.find("unlock_sniper"):isComplete() then
				acNemesisSniper:increment(1)
			elseif actor:getData().isNemesis == "Miner" and Achievement.find("unlock_miner"):isComplete() then
				acNemesisMiner:increment(1)
			elseif actor:getData().isNemesis == "Executioner" and Achievement.find("Executioner"):isComplete() then
				acNemesisExecutioner:increment(1)
			end
		end
	end
	
	if not global.rormlflag.ss_disable_skins then
		SurvivorVariant.setRequirement(SurvivorVariant.find(sur.Commando, "Nemesis Commando"), acNemesisCommando)
		SurvivorVariant.setRequirement(SurvivorVariant.find(sur.Enforcer, "Nemesis Enforcer"), acNemesisEnforcer)
		SurvivorVariant.setRequirement(SurvivorVariant.find(sur.Bandit, "Nemesis Bandit"), acNemesisBandit)
		SurvivorVariant.setRequirement(SurvivorVariant.find(sur.Huntress, "Nemesis Huntress"), acNemesisHuntress)
		SurvivorVariant.setRequirement(SurvivorVariant.find(sur.HAND, "Nemesis HAN-D"), acNemesisJanitor)
		SurvivorVariant.setRequirement(SurvivorVariant.find(sur.Miner, "Nemesis Miner"), acNemesisMiner)
		SurvivorVariant.setRequirement(SurvivorVariant.find(sur.Sniper, "Nemesis Sniper"), acNemesisSniper)
		
		if not global.rormlflag.ss_no_survivors and not global.rormlflag.ss_disable_survivors then
			SurvivorVariant.setRequirement(SurvivorVariant.find(sur.Executioner, "Nemesis Executioner"), acNemesisExecutioner)
		end
	end
end

if not global.rormlflag.ss_no_submenu and not global.rormlflag.ss_disable_submenu then -- whew

local sprite = Sprite.load("GenericUnlock", "Misc/Menus/unlock.png", 1, 15, 15)

local acRule1 = Achievement.new("RulesetSettings1")
acRule1.sprite = sprite
acRule1.requirement = 1
acRule1.unlockText = "New ruleset settings are now available."
acRule1.description = "Beat the game."
acRule1.highscoreText = "'Basic ruleset settings' Unlocked"
callback.register("onGameBeat", function()
	acRule1:increment(1)
end)
Rule.find("Difficulty Scaling", "Global").parentAchievement = acRule1
Rule.find("Gravity", "Global").parentAchievement = acRule1
Rule.find("Disable Water", "Global").parentAchievement = acRule1
Rule.find("Bypass 'Kill Remaining Enemies'", "Global").parentAchievement = acRule1
Rule.find("Shared Items", "Global").parentAchievement = acRule1
Rule.find("Item Blacklist", "Global").parentAchievement = acRule1
Rule.find("Reroll Blacklist Tiers", "Global").parentAchievement = acRule1
Rule.find("Eggplants", "Global").parentAchievement = acRule1
Rule.find("Ultras Before Ethereal", "Starstorm").parentAchievement = acRule1
Rule.find("Ultra Spawn Rate", "Starstorm").parentAchievement = acRule1
Rule.find("Ultra Spawn Rate", "Starstorm").parentAchievement = acRule1
Rule.find("Void Portal Spawn Rate", "Starstorm").parentAchievement = acRule1
Rule.find("HP Cap", "Players").parentAchievement = acRule1
Rule.find("Initial Jump Height", "Players").parentAchievement = acRule1
Rule.find("Jump Height", "Enemies").parentAchievement = acRule1
Rule.find("Critical Strike Chance", "Enemies").parentAchievement = acRule1

local acRule2 = Achievement.new("RulesetSettings2")
acRule2.sprite = sprite
acRule2.requirement = 3
acRule2.deathReset = false
acRule2.unlockText = "New ruleset settings are now available."
acRule2.description = "Beat the game 3 times."
acRule2.highscoreText = "'Advantageous ruleset settings' Unlocked"
callback.register("onGameBeat", function()
	acRule2:increment(1)
end)
Rule.find("Head Start", "Global").parentAchievement = acRule2
Rule.find("Item amount", "Global").parentAchievement = acRule2
Rule.find("Added Difficulty", "Global").parentAchievement = acRule2
Rule.find("Base Interactable Cost", "Global").parentAchievement = acRule2
Rule.find("Base Teleporter Charge Time", "Global").parentAchievement = acRule2
Rule.find("Initial HP", "Players").parentAchievement = acRule2
Rule.find("HP Multiplier", "Players").parentAchievement = acRule2
Rule.find("Initial Regeneration", "Players").parentAchievement = acRule2
Rule.find("Initial Speed", "Players").parentAchievement = acRule2
Rule.find("Initial Gold", "Players").parentAchievement = acRule2
Rule.find("Initial Damage", "Players").parentAchievement = acRule2
Rule.find("Initial Attack Speed", "Players").parentAchievement = acRule2
Rule.find("Initial Critical Strike Chance", "Players").parentAchievement = acRule2
Rule.find("Initial Armor", "Players").parentAchievement = acRule2
Rule.find("Skill Cooldowns", "Players").parentAchievement = acRule2
Rule.find("HP", "Enemies").parentAchievement = acRule2
Rule.find("Speed", "Enemies").parentAchievement = acRule2
Rule.find("Spawn Rate", "Enemies").parentAchievement = acRule2
Rule.find("Director Budget", "Enemies").parentAchievement = acRule2
Rule.find("Can Jump", "Enemies").parentAchievement = acRule2
Rule.find("Damage", "Enemies").parentAchievement = acRule2
Rule.find("Armor", "Enemies").parentAchievement = acRule2
Rule.find("Worth Value", "Enemies").parentAchievement = acRule2
Rule.find("High Difficulty Elite Attacks", "Enemies").parentAchievement = acRule2

local acRule3 = Achievement.new("RulesetSettings3")
acRule3.sprite = sprite
acRule3.requirement = 1
acRule3.unlockText = "New ruleset settings are now available."
acRule3.description = "Beat the game with a friend."
acRule3.highscoreText = "'Multiplayer ruleset settings' Unlocked"
callback.register("onGameBeat", function()
	if #misc.players > 1 then
		acRule3:increment(1)
	end
end)
Rule.find("Shared Spawn", "Global").parentAchievement = acRule3
Rule.find("Level Up Auto-Balance", "Players").parentAchievement = acRule3
Rule.find("Leveling Bias", "Players").parentAchievement = acRule3
Rule.find("PVP", "Players").parentAchievement = acRule3
Rule.find("Versus Mode", "Players").parentAchievement = acRule3
Rule.find("Teams", "Players").parentAchievement = acRule3
Rule.find("Objective", "Players").parentAchievement = acRule3
end