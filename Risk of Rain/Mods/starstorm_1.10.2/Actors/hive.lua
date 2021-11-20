local path = "Actors/Archer Bug Hive/"

local sprMask = Sprite.load("ArcherBugHiveMask", path.."Mask", 1, 31, 46)
local sprMain = Sprite.load("ArcherBugHive", path.."Main", 7, 93, 59)
local sprDeath = Sprite.load("ArcherBugHiveDeath", path.."Death", 7, 93, 138)
local sprPalette = Sprite.load("ArcherBugHivePal", path.."Palette", 1, 0, 0)

--local sHit = Sound.load("ArcherBugHiveHit", path.."Hit")

obj.ArcherBugHive = Object.base("BossClassic", "Archer Bug Hive")
obj.ArcherBugHive.sprite = sprMain
obj.ArcherBugHive.depth = 1

EliteType.registerPalette(sprPalette, obj.ArcherBugHive)

NPC.setSkill(obj.ArcherBugHive, 1, 400, 60 * 5, sprMain, 0.2, function(actor)

end, function(actor, relevantFrame)
	if relevantFrame == 2 then
		sfx.Embryo:play(1.2)
		if net.host then
			local bug = obj.Bug:create(actor.x - 20 * actor.xscale, actor.y - 31 * actor.yscale)
			local elite = actor:getElite()
			if elite then
				bug:makeElite(elite)
			end
			bug:set("sync", 1)
		end
	end
end)

obj.ArcherBugHive:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = sprMask
	selfAc.name = "Archer Bug Hive"
	selfAc.name2 = "Resilient Swarm"
	selfAc.team = "enemy"
	selfAc.damage = 0
	selfAc.maxhp = 1000 * Difficulty.getScaling("hp")
	selfAc.armor = 100
	selfAc.hp = selfAc.maxhp
	selfAc.pHmax = 0
	selfAc.knockback_cap = selfAc.maxhp
	selfAc.exp_worth = 30 * Difficulty.getScaling()
	selfAc.can_drop = 0
	selfAc.can_jump = 0
	selfAc.sound_hit = sfx.LizardGHit.id
	selfAc.hit_pitch = 1.2
	selfAc.sound_death = sfx.MushDeath.id
	selfAc.sprite_palette = sprPalette.id
	selfAc.sprite_idle = sprMain.id
	selfAc.sprite_walk = sprMain.id
	selfAc.sprite_jump = sprMain.id
	selfAc.sprite_death = sprDeath.id
	
	local n = 0
	while n < 200 and not self:collidesMap(self.x, self.y + 1) do
		n = n + 1
		self.y = self.y + 1
	end
	
	if not self:getData().located then
		local ground = obj.B:findNearest(self.x, self.y)
		if ground then
			self.x = ground.x
			self.y = ground.y
		end
	end
end)

obj.ArcherBugHive:addCallback("step", function(self)
	local selfAc = self:getAccessor() 
	local object = self:getObject()
	local selfData = self:getData()
	
	selfAc.pHmax = 0
	
	local activity = selfAc.activity
	
	self.xscale = math.abs(self.xscale)
	
	if misc.getTimeStop() == 0 then
		if activity == 0 then
			self.subimage = 1
			self.spriteSpeed = 0
			for k, v in pairs(NPC.skills[object]) do
				if self:get(v.key.."_skill") > 0 and self:getAlarm(k + 1) == -1 then
					selfData.attackFrameLast = 0
					self:set(v.key.."_skill", 0)
					if v.start then
						v.start(self)
						selfAc.activity = k
					end
					self.subimage = 1
					if v.cooldown then
						self:setAlarm(k + 1, v.cooldown * (1 - self:get("cdr")))
					end
				else
					self:set(v.key.."_skill", 0)
				end
			end
		else
			local skill = NPC.skills[object][activity]
			if skill then
				local relevantFrame = 0
				local newFrame = math.floor(self.subimage)
				if newFrame > selfData.attackFrameLast then
					relevantFrame = newFrame
					selfData.attackFrameLast = newFrame
				end
				if selfAc.free == 0 then
					selfAc.pHspeed = 0
				end
				if skill.update then
					skill.update(self, relevantFrame)
				end
				self.spriteSpeed = skill.speed * selfAc.attack_speed
				self:set("activity_type", 1)
				if skill.sprite then
					self.sprite = skill.sprite
					if newFrame == self.sprite.frames then
						self:set("activity", 0)
						self:set("activity_type", 0)
						self:set("state", "chase")
					end
				else
					self:set("activity", 0)
					self:set("activity_type", 0)
					self:set("state", "chase")
				end
			end
		end
	else
		self.spriteSpeed = 0
	end
end)

table.insert(call.preHit, function(damager, hit)
	if hit:getObject() == obj.ArcherBugHive then
		damager:set("knockback", 0)
		damager:set("knockup", 0)
		damager:set("knockback_glove", 0)
		damager:set("stun", 0)
	end
end)

local hiveLocations
callback.register("postLoad", function()
	if rm.Overgrowth then
		hiveLocations = {
			[rm.Overgrowth] = {
				{1183, 960},
				{2318, 912},
				{1872, 1312},
				{1850, 2272},
				{2173, 2688},
				{721, 3248},
			},
			[rm.OvergrowthVariant] = {
				{1619, 960},
				{363, 1376},
				{2332, 1856},
				{890, 2544},
				{2368, 2944},
				{1445, 1936},
			},
		}
	end
end)
local hives = {}

table.insert(call.onStageEntry, function()
	local currentStage = Stage.getCurrentStage()
	
	if currentStage == stg.Overgrowth then
		if misc.director:get("stages_passed") > 5 and not runData.woodlandInfestation then
			for i, coords in ipairs(hiveLocations[Room.getCurrentRoom()]) do
				local hive = obj.ArcherBugHive:create(coords[1], coords[2])
				hive:set("m_id", i)
				hive:getData().located = true
				table.insert(hives, hive)
			end
		end
	end
end)

local killedHives = 0

onNPCDeath.hive = function(npc, object)
	local currentStage = Stage.getCurrentStage()
	if object == obj.ArcherBugHive and currentStage == stg.Overgrowth and misc.director:get("stages_passed") > 5 and not runData.woodlandInfestation then
		killedHives = killedHives + 1
		if killedHives >= #hives then
			for _, player in ipairs(misc.players) do
				player:getData().achievementHives = true
			end
			runData.woodlandInfestation = true
		end
	end
end

callback.register("onGameStart", function()
	killedHives = 0
	hives = {}
end)

mcard.ArcherBugHive = MonsterCard.new("Archer Bug Hive", obj.ArcherBugHive)
mcard.ArcherBugHive.type = "offscreen"
mcard.ArcherBugHive.cost = 450
mcard.ArcherBugHive.isBoss = true
mcard.ArcherBugHive.canBlight = false