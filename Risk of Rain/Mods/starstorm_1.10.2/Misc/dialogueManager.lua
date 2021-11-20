-- CUSTOM TEXTBOX
spr.ProvidencePortrait = Sprite.load("ProvidencePortrait", "Actors/Providence/portraitOg", 4, 0, 0)
spr.NemesisCommandoPortrait = Sprite.load("NemesisCommandoPortrait", "Survivors/Commando/Skins/Nemesis/portrait", 1, 0, 0)
obj.CustomTextbox = Object.new("CustomTextbox")
obj.CustomTextbox.depth = -99999
obj.CustomTextbox:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.img = {spr.ProvidencePortrait}
	selfData.text = {"Thanks for spawning me!", "I have no text assigned, though.", "Sorry!"}
	selfData.step = 1
end)
obj.CustomTextbox:addCallback("step", function(self)
	if net.online or getRule(5, 16) ~= true and not self:getData().bypassRule then
		self:destroy()
	else
		local selfData = self:getData()
		local controller
		if net.online then
			controller = net.localPlayer
		else
			controller = misc.players[1]
		end
		
		if controller:control("enter") == input.PRESSED then
			if selfData.step < #selfData.text then
				selfData.step = selfData.step + 1
			else
				self:destroy()
			end
		end
	end
end)
table.insert(call.postStep, function()
	if obj.CustomTextbox:find(1) then
		for _, player in ipairs(misc.players) do
			if not player:getData().stopped then
				player:getData().stopped = {x = player.x, y = player.y, hp = player:get("hp")}
				player:set("disable_ai", 1)
				player:set("true_invincible", 1)
				
			else
				player.x = player:getData().stopped.x
				player.y = player:getData().stopped.y
				player:set("hp", player:getData().stopped.hp)
			end
		end
		for _, tele in ipairs(obj.Teleporter:findAll()) do
			if not tele:getData().txtLock then
				tele:getData().txtLock = true
				tele:set("locked", tele:get("locked") + 1)
			end
		end
	else
		for _, player in ipairs(misc.players) do
			if player:getData().stopped then
				player:getData().stopped = false
				player:set("disable_ai", 0)
				player:set("true_invincible", 0)
			end
		end
		for _, tele in ipairs(obj.Teleporter:findAll()) do
			if tele:getData().txtLock then
				tele:getData().txtLock = nil
				tele:set("locked", tele:get("locked") - 1)
			end
		end
	end
end)
obj.CustomTextbox:addCallback("destroy", function(self)
	local selfData = self:getData()
	if selfData.endFunc then
		local endF = selfData.endFunc
		endF[1](endF[2], endF[3], endF[4], endF[5])
	end
end)
table.insert(call.onHUDDraw, function()
	local w, h = graphics.getHUDResolution()
	for _, textbox in ipairs(obj.CustomTextbox:findAll()) do
		local controller = misc.players[1]
		local data = textbox:getData()
		graphics.color(Color.BLACK)
		graphics.alpha(0.7)
		graphics.rectangle(8, 8, w - 8, 73, false)
		
		local currentFrame = data.img[math.min(data.step, #data.img)]
		local currentImage = nil
		local subImage = 1
		if type(currentFrame) == "table" then
			currentImage = currentFrame[1]
			subImage = currentFrame[2]
		else
			currentImage = data.img[math.min(data.step, #data.img)]
		end
		graphics.drawImage{
			image = currentImage,
			subimage = subImage,
			x = 12,
			y = 12
		}
		
		graphics.color(Color.WHITE)
		graphics.alpha(1)
		
		local speechString = nil
		if type(data.text[data.step]) == "table" then
			if #misc.players > 1 then
				speechString = data.text[2][data.step]
			else
				speechString = data.text[1][data.step]
			end
		else
			speechString = data.text[data.step]
		end
		
		local threshold = w * 0.07
		for i = 1, math.floor(string.len(speechString) / threshold) do
			local place = string.find(speechString, " ", i * threshold)
			if place then
				speechString = string.sub(speechString, 0, place).."\n"..string.sub(speechString, place + 1)
			end
		end
		graphics.print(speechString, 74, 12, 2)
		
		local acceptString = "Press "
		if input.getPlayerGamepad(controller) then
			acceptString = acceptString.."'"..input.getControlString("enter", controller).."'"
		else
			acceptString = acceptString.."&y&'"..input.getControlString("enter", controller).."'&!&"
		end
		graphics.printColor(acceptString, w - 62, 57)	
	end
end)

function createDialogue(text, images, onStart, onEnd, bypassRule)
	if net.online then
		return nil
	elseif getRule(5, 18) == true or bypassRule then
		local txtBox = obj.CustomTextbox:create(0, 0)
		txtBox:getData().bypassRule = bypassRule
		txtBox:getData().text = text
		txtBox:getData().img = images
		if onStart and txtBox and txtBox:isValid() then
			onStart[1](onStart[2], onStart[3], onStart[4], onStart[5])
		end
		if onEnd then
			txtBox:getData().endFunc = onEnd
		end
		return txtBox
	end
end

local notrail = false

local lastnohud = false

table.insert(call.onStep, function()
	local nohud = false
	if obj.Textbox:find(1) or obj.CustomTextbox:find(1) then
		misc.setTimeStop(4)
		notrail = true
		nohud = true
		for _, actor in ipairs(pobj.actors:findAll()) do
			actor:set("invincible", 4)
		end
	elseif notrail == true then
		notrail = false
	end
	if nohud == true then
		misc.hud:set("show_boss", 0)
		misc.hud:set("show_time", 0)
		misc.hud:set("show_gold", 0)
		misc.hud:set("show_skills", 0)
		lastnohud = true
	elseif lastnohud == true then
		lastnohud = false
		misc.hud:set("show_boss", 1)
		misc.hud:set("show_time", 1)
		misc.hud:set("show_gold", 1)
		misc.hud:set("show_skills", 1)
	end
end)

table.insert(call.postStep, function()
	if notrail == true then
		for _, v in pairs(obj.EfTrail:findAll()) do
			v:destroy()
		end
	end
end)

local teleCount = 0

local dialogueOptions = {
	{
		{"Who are you?", "Why are you here?", "..."},
		{{"I sense your presence, stranger.", "And I do not tolerate it."}, {"I sense your presence, strangers.", "And I do not tolerate it."}},
		{{"Huh?", "A survivor?", "I'll make sure you are no more."}, {"Huh?", "Survivors?", "I'll make sure you are no more."}},
		{"...", "How can you be here?", "I was sure nobody made it out alive..."},
		{"What are you doing?", "Who are you?"},
		{{"Stranger, this is no place for you.", "There is no point in your actions.", "Stop."}, {"Strangers, this is no place for you.", "There is no point in your actions.", "Stop."}},
		{"I am disturbed by your presence.", "What is your goal?"},
		{{"What is this?", "...", "Survivor, I am sorry for I cannot let you thrive.", "Not any longer..."}, {"What is this?", "...", "Survivors, I am sorry for I cannot let you thrive.", "Not any longer..."}},
		{{"Interesting...", "So you are the last one."}, {"Interesting...", "So you are the last ones."}},
		{"If your intent is to sabotage my work; you are wasting time."},
	},
	{
		{{"What do you think you are doing?", "You pilferer."}, {"What do you think you are doing?", "You pilferers..."}},
		{"I can't withstand your actions...", "You will be judged."},
		{"Judgement is upon you."},
		{"The end is coming for you."},
		{"You have had enough!", "Stop this now."},
		{"You will pay for what you are doing..."},
		{"My patience is invaluable, yet you are consuming it."},
		{"Life gave you another chance, yet all you do is hinder my efforts to bring peace."},
		{"You are war, you are hatred.", "You are not welcome."}
	},
	{
		{"The worst is yet to come for you.", "And it's deserved..."},
		{"This won't last for ever.", "You know it.", "Yet you resist..."},
		{"The end of times is near", "You will perish alongside it."},
		{"Stop resisting, this is only right.", "But you are too selfish to see it."},
		{"I am doing this for justice.", "Your interferance tips the balance to the wrong side."},
		{"You can't justify your actions on survival.", "What you've done is reprehensible."},
		{"Over and over again, you do the same thing carelessly.", "Your kind is ill of a ceaseless aversion."}
	},
	{
		{"...", "Are you satisfied now? Haven't you had enough?"},
		{"Survivor...", "The extent of your destruction is beyond a justified goal.", "Do you realize?"},
		{"I had enough of your slaughtering.", "You are going to be ended."},
		{"They won't stop coming for you.", "You are repudiated."},
		{"You are the embodiment of everything that is wrong with your kind.", "Chaos, desperation, acrimony."},
		{"Your acts of belligerence won't change your fate.", "There's no room for remorse now."}
	},
	
}

table.insert(call.onStep, function()
	for _, teleporter in ipairs(obj.Teleporter:findAll()) do
		if teleporter:get("active") > 2 and not obj.CommandFinal:find(1) then
			if not teleporter:getData().storyChecked then
				teleCount = teleCount + 1
				if teleCount == 3  then
					local dialogue = table.irandom(dialogueOptions[1])
					createDialogue(dialogue, {spr.ProvidencePortrait})
				elseif teleCount == 7 then
					local dialogue = table.irandom(dialogueOptions[2])
					createDialogue(dialogue, {spr.ProvidencePortrait})
				elseif teleCount == 12 then
					local dialogue = table.irandom(dialogueOptions[3])
					createDialogue(dialogue, {spr.ProvidencePortrait})
				elseif teleCount == 16 then
					local dialogue = table.irandom(dialogueOptions[4])
					createDialogue(dialogue, {{spr.ProvidencePortrait, 2}})
				elseif teleCount == 25 then
					createDialogue({"...", "... ...", "End the cowardice.", "Come to me, face your reckoning."}, {{spr.ProvidencePortrait, 3}, {spr.ProvidencePortrait, 3}, {spr.ProvidencePortrait, 2}})
				end
				teleporter:getData().storyChecked = true
			end
		end
	end
end)

callback.register("onGameEnd", function()
	teleCount = 0
end)