local path = "Items/Resources/"

it.MoltenCoin = Item.new("Molten Coin")
local sMoltenCoin = Sound.load("MoltenCoin", path.."moltenCoin")
it.MoltenCoin.pickupText = "Chance to incinerate on hit, +$1." 
it.MoltenCoin.sprite = Sprite.load("MoltenCoin", path.."Molten Coin.png", 1, 11, 13)
it.MoltenCoin:setTier("common")
it.MoltenCoin:setLog{
	group = "common",
	description = "&y&6% chance to incinerate enemies&!& on hit, &y&earning $1&!&.",
	story = "Hey! Uh, I am sorry, I am really sorry... I know you really wanted me to keep this coin but I can't take the responsibility any more...\nSee, I accidentally put the coin at the edge of a plasma furnance so... well... it's a bit burnt on the side, please don't get mad at me.",
	destination = "Toera 2,\nB44,\nMother Station",
	date = "05/22/2056"
}

table.insert(call.onFireSetProcs, function(damager, parent)
	if parent and parent:isValid() and isa(parent, "PlayerInstance") then
		local moltenCoin = parent:countItem(it.MoltenCoin)
		damager:set("moltenCoin", moltenCoin)
	end
end)

table.insert(call.onHit, function(damager, hit)
	local damagerAc = damager:getAccessor()
	
	local moltenCoin = damagerAc.moltenCoin
	if moltenCoin and moltenCoin > 0 and math.chance(6) then
		sMoltenCoin:play(0.9 + math.random() * 0.2)
		DOT.applyToActor(hit, DOT_FIRE, damagerAc.damage * 0.2, 2 + (moltenCoin * 4), "moltenCoin", false)
		for i = 0, moltenCoin do
			obj.EfGold:create(hit.x, hit.y)
		end
	end
end)