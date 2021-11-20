local path = "Items/Resources/"

it.PoisonousGland = Item.new("Poisonous Gland")
local sPoisonousGland = sfx.MushShoot1
it.PoisonousGland.pickupText = "Create a cloud of poison on receiving damage at full health." 
it.PoisonousGland.sprite = Sprite.load("PoisonousGland", path.."Poisonous Gland.png", 1, 12, 14)
it.PoisonousGland:setTier("uncommon")
it.PoisonousGland:setLog{
	group = "uncommon_locked",
	description = "Create a &y&cloud of poison&!& when getting hit at &r&full health&!&.",
	story = "While we were in the field we found those eerie mushroom-like creatures you talked us about. We managed to take this from a dead one and keep it in cryo so you can check it out in the lab; maybe we can repurpose it, you'll determine.",
	priority = "&g&Priority/Biological&!&",
	destination = "Block 2,\nBiology,\nTeimax Station 2",
	date = "01/15/2056"
}
it.PoisonousGland:addCallback("pickup", function(player)
	player:set("gland", (player:get("gland") or 0) + 1)
end)
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.PoisonousGland then
		player:set("gland", player:get("gland") - amount)
	end
end)

table.insert(call.preHit, function(damager, hit)
	local hitAc = hit:getAccessor()
	
	local poisonousGland = hitAc.gland
	if poisonousGland and poisonousGland > 0 then
		if damager:get("damage") > 0 and hitAc.hp == hitAc.maxhp then
			if hitAc.team == "player" then
				cloud = obj.poisonCloud:create(hit.x, hit.y)
				cloud:getData().parent = hit
				cloud:getData().damage = 0.6 + (0.4 * poisonousGland)
			else
				poisonCloud = obj.MushDust:create(hit.x, hit.y)
				poisonCloud:set("team", hitAc.team or "enemy")
				poisonCloud:setAlarm(0, 300)
				poisonCloud:set("damage", 0.6 + (0.4 * poisonousGland))
			end
			misc.shakeScreen(3)
			sPoisonousGland:play(0.9 + math.random() * 0.2)
		end
	end
end)