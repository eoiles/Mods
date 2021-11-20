-- Main menu versioning
local function split(str, maxLength)
	local linetable = {}
	local line
	str:gsub('(%s*)(%S+)', 
		function(spc, word)
			if spc and spc:find("\n") then
				table.insert(linetable, line)
				line = word
			elseif not line or #line + #spc + #word > maxLength then
				table.insert(linetable, line)
				line = word
			else
				line = line..spc..word
			end
		end
	)
	table.insert(linetable, line)
	local finalstring = ""
	for i, str in ipairs(linetable) do
		local fin = "\n"
		if i == #linetable then fin = "" end
		finalstring = finalstring..str..fin
	end
	return finalstring
end

local ii = 0
local patchNotes = [[PATCH NOTES:
- New survivor variant: Guardian (Knight)!
- Added interactable scaling to properly match the amount of players in multiplayer games.
- Added "ss_disable_mp_chest_scaling" profile flag.
- Rewritten npc item library: many more items are now available for NPCs.
- Rebalanced vestige item counts and scaling.
- Dio's friend now works correctly on NPCs.
- Mimics now inherit stolen item effects.
- Reduced Empyrean spawnrate by 25%.
- Reworked Huntress' Vestige primary, can now be charged.
- HAN-D's Vestige can now use Double Shave while moving.
- Increased Miner's Vestige primary damage to 60% (from 55%).
- Decreased Miner's Vestige primary innate knockback scaling by 25%.
- Increased Executioner's Vestige primary damage to 65% per orb (from 50%).
- Decreased Executioner's Vestige special damage to 900% (from 1000%).
- Increased Scavenger's Fortune activation threshold to $10000 (from $5000).
- A lot of fixes!
- - - - - - - - - - - -
For the full log enter:
pastebin.com/JkJ2tMAB]]
--[[- - - - - - - - - - - -
For the full log enter:]]
-- pastebin.com/0xjghHLA (dev)
-- pastebin.com/JkJ2tMAB (stable)

local function drawVersionName()
	local verString = "Starstorm "..modloader.getModVersion("Starstorm")
	local w, h = graphics.getGameResolution()
	local mx, my = input.getMousePos(true)
	
	graphics.color(Color.fromHex(0x808080))
	graphics.alpha(1)
	graphics.print(verString, w - 3, 3, 3, 2)
	
	local verWidth = graphics.textWidth(verString, 3)
	local verHeight = graphics.textHeight(verString, 3)
	
	if mx > w - verWidth - 6 and my < verHeight + 3 then
		if ii < 1 then
			ii = ii + 0.2
		end
	elseif ii > 0 then
		ii = ii - 0.2
	end
	
	if ii > 0 then
		local notesString = split(patchNotes, math.floor(w * 0.05))
		
		local notesWidth = graphics.textWidth(notesString, 3)
		local notesHeight = graphics.textHeight(notesString, 3)
		
		local twidth = 3 + notesWidth + 3
		local theight = 3 + verHeight + 1 + notesHeight + 3
		
		local yy = (ii - 1) * 10
		
		graphics.color(Color.GRAY)
		graphics.alpha(ii * 0.5)
		graphics.rectangle(w - twidth, 0, w, theight + yy, false)
		graphics.rectangle(w - twidth - 1, 0, w - twidth, theight - 1 + yy, false)
		
		graphics.alpha(ii)
		graphics.color(Color.WHITE)
		graphics.print(verString, w - 3, 3, 3, 2)
		graphics.color(Color.fromHex(0x808080))
		graphics.print(notesString, w - 3 - notesWidth, 3 + verHeight + 1 + yy, 3)
	end
end
callback.register("globalRoomStart", function(room)
	if room == rm.Start then
		graphics.bindDepth(-99, drawVersionName)
	end
end)