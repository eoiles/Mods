
local path = "Items/Resources/"
it.BanFlask = Item.new("Bane Flask")
it.BanFlask.pickupText = "Inflicts bane. Debuffs spread on enemy death." 
it.BanFlask.sprite = Sprite.load("BaneFlask", path.."Bane Flask", 1, 15, 15)
it.BanFlask:setTier("rare")
it.BanFlask:setLog{
	group = "rare",
	description = "Inflicts bane which &y&deals 30% damage every 2 seconds&!&. &y&Debuffs spread&!& on enemy death.",
	story = "Our team has finally created a valuable product, incomparable to the ones before it. While the rival team has done nothing but dawdle and laze about, creating pointless tonics and volatile barrels, we were successful in harvesting the deadliest property from this beast. We extracted the contagious toxin EBBA-33 and materialied this deadly compound which behaves similarly to a virus, with extremely contagious properties. However, our compound takes no time to begin spreading.\n\nI firmly believe no other laboratory will top this for the next century. We have made a large step in chemical warfare and we are just awaiting your command, sir.",
	priority = "&r&High Priority/Biological&!&",
	destination = "Delta M,\nZeus Complex,\nPXP Central",
	date = "2/10/2057"
}

-- debuff manager
local debuffs = {
  buff.slow,
  buff.slow2,
  buff.snare,
  buff.thallium,
  buff.oil,
  buff.disease,
  buff.intoxication,
  buff.disease,
  buff.daze,
  buff.voided,
  buff.needles,
  buff.weaken1,
  buff.slowdown,
  buff.damageshare,
  buff.seraph
}

for _, buff in ipairs(debuffs) do
  buff:addCallback("start", function(actor)
    if not isa(actor, "PlayerInstance") then
      if not actor:getData().activeDebuffs then
        actor:getData().activeDebuffs = {}
      end
      actor:getData().activeDebuffs[buff] = 2 -- placeholder time, since we cant get the time at the start
    end
  end)
  buff:addCallback("step", function(actor, timer)
    if not isa(actor, "PlayerInstance") then
      actor:getData().activeDebuffs[buff] = timer -- the actual time
    end
  end)
  buff:addCallback("end", function(actor, timer)
	if not isa(actor, "PlayerInstance") then
      actor:getData().activeDebuffs[buff] = nil
	end
  end)
end

-- spread
table.insert(call.onNPCDeathProc, function(npc, player)
	local tubeCount = player:countItem(it.BanFlask)
	if tubeCount > 0 and npc:getData().lastHitBy == player then
		local ellipsX = 50 + tubeCount * 50
		local ellipsY = 30 + tubeCount * 30
		local enemies = pobj.actors:findAllEllipse(npc.x - ellipsX, npc.y + ellipsY, npc.x + ellipsX, npc.y - ellipsY)
		if npc:getData().activeDebuffs then
			for _, actor in ipairs(enemies) do
				if actor:get("team") ~= player:get("team") then
					for buff, timer in pairs(npc:getData().activeDebuffs) do
						actor:applyBuff(buff, timer * (1 + tubeCount))
                    end
				end
			end
		end
		if npc:getData().dotData then
			for _, actor in ipairs(enemies) do
				if actor:get("team") ~= player:get("team") and actor ~= npc then
					for _, dot in ipairs(npc:getData().dotData) do
						if dot.stacks and not DOT.checkActor(actor, dot.dotType) then
							DOT.applyToActor(actor, dot.dotType, dot.damage, dot.tics * (tubeCount + 1), dot.index, dot.stacks)
						elseif not dot.stacks then 
							DOT.applyToActor(actor, dot.dotType, dot.damage, dot.tics + tubeCount, dot.index, dot.stacks)
						end
					end
				end
				--actor:getData().lastHitBy = player this is absolutely op
			end
		end
	end
end)

table.insert(call.onFireSetProcs, function(damager, parent)
	if parent and parent:isValid() then
		if isa(parent, "PlayerInstance") then
			tubeCount = parent:countItem(it.BanFlask)
			if tubeCount > 0 then
				DOT.addToDamager(damager, DOT_BANE, math.max(parent:get("damage") * 0.3, 1), 5 + tubeCount, "BanFlask", false)
			end
		end
	end
end)

table.insert(call.onHit, function(damager, hit)
	local parent = damager:getParent()
	if parent then
		hit:getData().lastHitBy = parent
	end
end)
