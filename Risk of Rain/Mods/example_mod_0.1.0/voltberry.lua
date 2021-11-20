
------ voltberry.lua
---- Adds a new use item which summons an overloading Magma Worm when used

-- Creates a new item and sets the pickup text, just like in the first example item
local item = Item("Voltberry")
item.pickupText = "Summon an Overloading Magma Worm."

-- Unlike the other example item, the sprite for this item has 2 frames
-- The first frame of the sprite has the 'use' label while the second does not
item.sprite = Sprite.load("example use item.png", 2, 12, 15)

-- Set isUseItem to make the item into a use item
item.isUseItem = true
-- And set useCooldown, which is the cooldown of our use item in seconds
-- By default, this value is 45
item.useCooldown = 90

-- Make the item show up as a use item
item:setTier("use")

-- If you want the Artifact of Enigma to be able to activate your item, add it to the 'enigma' item pool
-- ItemPool.find("enigma", "vanilla"):add(item)

-- Get the Magma Worm object for later use
local worm = Object.find("worm")
-- Add code to the use callback
item:addCallback("use", function(player, embryo)
	local count = 1
	-- Increase spawn count if embryo is procced
	if embryo then
		count = 2
	end
	
	for i = 1, count do
		-- Create an instance of the worm object at 0, 0 (the top left of the map)
		local spawned = worm:create(player.x, player.y)
		-- Set the 'elite' variable of our newly spawned worm to 1, forcing it to turn overloading
		-- Doing this only works on newly spawned bosses, on other enemies it will not have expected behavior
		spawned:set("elite", 1)
	end
end)

-- Set the log for the item, just like the first example item
item:setLog{
	group = "use",
	description = "Summons an &y&overloading Magma Worm&!& to fight you.",
	story = "An example use item which uses some more complicated features",
	destination = "Some (other) Guy's House,\nSome City,\nSome Planet",
	date = "4/30/2018"
}
