
------ juice.lua
---- Adds a new common tier item which grants +30 max health when collected

-- Creates a new item with the name Example Juice
local item = Item("Example Juice")

-- Set the text displayed when collected
item.pickupText = "Increases maximum health by 30." 

-- Load the item's sprite
-- The first string is the sprite name and the second is the filename
-- It has 1 frame of animation, and the origin is located at 12, 13 (the middle)
item.sprite = Sprite.load("example item.png", 1, 12, 13)

-- Make the item appear as a common item
item:setTier("common")


-- Add code to the pickup callback
-- Our code will simply set the player's maxhp_base variable to its current value + 30
item:addCallback("pickup", function(player)
	player:set("maxhp_base", player:get("maxhp_base") + 30)
end)

-- Set the log for the item
item:setLog{
	-- The tier of the item
	group = "common",
	-- A description of what the item does
	-- Usually is similar to the item's pickup text, but goes into more detail
	-- This part of the log may use colored text codes, here we use them to make the text 'by 30 points' yellow
	description = "Permanently increases your maximum health &y&by 30 points&!&.",
	-- The main part of the item log
	-- Usually includes some lore about the item
	-- Will automatically wrap around when it reaches the edge of the text area
	story = "This is an example item! Isn't that cool? \nImagine all the possibilities of what could be made with this!",
	-- The item's destination, shown on the top right of the log
	destination = "Some Guy's House,\nSome City,\nSome Planet",
	-- The package estimated arrival date
	date = "4/24/2018"
}
