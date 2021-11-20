
------ scarf.lua
---- Adds a new uncommon item which gives you a chance to apply an attack speeed slowing debuff to enemies you hit

-- Basic item setup
-- Covered in example item.lua
local item = Item("Scarf of Slowing")
item.pickupText = "Chance to slow the attacks of enemies on hit."
item.sprite = Sprite.load("scarf.png", 1, 9, 9)
item:setTier("uncommon")
item:setLog{
	group = "uncommon",
	description = "Chance to apply a &y&debuff&!& to hit enemies which decreases their attack speed.",
	story = "A more advanced example item. Makes use of a custom buff and applies effects outside of the item's callbacks.",
	destination = "Some Person's House,\nSome City,\nSome Planet",
	date = "7/29/2018"
}

-- Create a new buff which will be used for the item's effect
local buff = Buff.new()

-- Load the buff's sprite
buff.sprite = Sprite.load("scarf buff.png", 1, 5, 4)

-- Callback fired when the buff is applied to the actor
buff:addCallback("start", function(actor)
	-- Subtract form the actor's attack speed
	local aactor = actor:getAccessor()
	aactor.attack_speed = aactor.attack_speed - 0.6
end)

-- Callback fired when the buff is removed from the actor
buff:addCallback("end", function(actor)
	-- Add back to the actor's attack speed
	local aactor = actor:getAccessor()
	aactor.attack_speed = aactor.attack_speed + 0.6
end)

-- When an attack is fired
registercallback("onFire", function(bullet)
	-- Get the parent of the damager
	local parent = bullet:getParent()
	-- Check if it's a player
	if type(parent) == "PlayerInstance" then
		-- If it is, then get the stack of our item
		local count = parent:countItem(item)
		-- And roll to see whether the buff should proc
		-- Chance is 20% + 10% per stack
		if count > 0 and math.random(100) < count * 10 + 10 then
			bullet:set("slow_scarf_proc", 1)
		end
	end
end)

-- When an attack hits an actor
-- The coordinates of the impact are passed to the callback, but we won't use those here
registercallback("onHit", function(bullet, hit, hitx, hity)
	-- Check to see if our damager should apply the buff
	if bullet:get("slow_scarf_proc") then
		-- And apply it
		hit:applyBuff(buff, 60 * 5)
	end
end)


