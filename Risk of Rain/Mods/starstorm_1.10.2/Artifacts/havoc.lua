local path = "Artifacts/Resources/"

-- Havoc
ar.Havoc = Artifact.new("Havoc")
ar.Havoc.loadoutSprite = Sprite.load("Havoc", path.."havoc", 2, 18, 18)
ar.Havoc.loadoutText = "A random event occurs each stage."
ar.Havoc.pickupSprite = Sprite.load("HavocPickup", path.."havocPickup", 1, 14, 14)
ar.Havoc.pickupName = "Artifact of Havoc"

obj.HavocPickup = ar.Havoc:getObject()

local storm = Event.find("Storm") -- first event is always a storm
local windl, windr = Event.find("Wind1"), Event.find("Wind2")
local flood = Event.find("Flood")
local collapse = Event.find("Collapse")

local windStages = {
	[stg.DriedLake] = true,
	[stg.BoarBeach] = true,
	[stg.UnchartedMountain] = true,
	[stg.TorridOutlands] = true,
	[stg.AncientValley] = true
}

local blacklist = {
	[stg.VoidShop] = true
}

local eliteEvents = {
	Event.find("EliteBlazing"),
	Event.find("EliteFrenzied"),
	Event.find("EliteLeeching"),
	Event.find("EliteOverloading"),
	Event.find("EliteVolatile"),
	Event.find("ElitePoisoning"),
	Event.find("EliteWeakening"),
	Event.find("EliteDazing")
}

table.insert(call.onStep, function()
	if global.inGame then
		if ar.Havoc.active and net.host then
			if not runData.havocEvent and not blacklist[Stage.getCurrentStage()] then
				Event.setActive(storm, nil, 9999999) -- funny 9999999
				runData.havocEvent = storm
			else
				local currentEvent = runData.havocEvent
				if currentEvent == windl then
					local pretimer = runData.havocWindTimer or 0
					runData.havocWindTimer = pretimer + 1
					if runData.havocWindTimer >= 30 * 60 then
						runData.havocWindTimer = 0
						Event.setActive(windr, 120, 9999999)
						runData.havocEvent = windr
					end
				elseif currentEvent == windr then
					local pretimer = runData.havocWindTimer or 0
					runData.havocWindTimer = pretimer + 1
					if runData.havocWindTimer >= 30 * 60 then
						runData.havocWindTimer = 0
						Event.setActive(windl, 120, 9999999)
						runData.havocEvent = windl
					end
				end
			end
		end
	end
end)
table.insert(call.onStageEntry, function()
	if ar.Havoc.active and runData.havocEvent then
		if blacklist[Stage.getCurrentStage()] then
			Event.setActive(nil)
			runData.havocEvent = nil
		else
			local validEvents = {}
			local eliteEventChoice = table.irandom(eliteEvents)
			for _, event in ipairs(Event.findAll()) do
				if event ~= windl then -- no need to account for both, it switches anyways
					if event ~= windr or windStages[Stage.getCurrentStage()] then
						if event ~= collapse then
							if event ~= flood or obj.Water:find(1) then
								--print(event, event.name:find("Elite"))
								if not event.name:find("Elite") or event == eliteEventChoice then
									if not runData.havocEvent or event ~= runData.havocEvent then
										table.insert(validEvents, event) -- sucks
									end
								end
							end
						end
					end
				end
			end
			local event = table.irandom(validEvents)
			Event.setActive(event, (13 * 60), 9999999)
			runData.havocEvent = event
		end
	end
end)