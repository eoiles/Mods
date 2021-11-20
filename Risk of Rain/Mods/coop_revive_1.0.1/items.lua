require("sprites")
require("packets")

iDefibrillator = Item.new("Defibrillator")
iDefibrillator.pickupText = "Revive speed increased"
iDefibrillator.sprite = sDefibrillator
iDefibrillator:setTier("rare")
iDefibrillator:setLog{
    group = "rare",
    description = "Reviving requires 1 less &y&button press&!& for you and your revivees",
    destination = "Office 15\nVivifica Hospital\nMars",
    date = "12/05/2056",
    story = "A basic AED, you've probably seen one of these in a movie. They aren't that hard to use, really. Just turn it on, apply the pads and hope for the best."
}
iDefibrillator:addCallback("pickup", function(player)
    local playerdata = player:getData()
    playerdata.defibrillator = playerdata.defibrillator + 1

    if net.host then
        packetPlayerDataSync:sendAsHost(net.ALL, nil, player:getNetIdentity(), "defibrillator", playerdata.defibrillator)
    else
        packetPlayerDataSync:sendAsClient(player:getNetIdentity(), "defibrillator", playerdata.defibrillator)
    end
end)

iSecondWind = Item.new("Second Wind")
iSecondWind.pickupText = "Temporary boost after getting revived"
iSecondWind.sprite = sSecondWind
iSecondWind:setTier("uncommon")
iSecondWind:setLog{
    group = "uncommon",
    description = "You and the reviver gain &b&+50% speed and damage&!& for &y&7 seconds&!& when you are revived",
    destination = "2445\nNecromancy and Magic\nMars",
    date = "12/06/2056",
    story = "Found an entire box of these medallions in an old laboratory during my trip to one of the town ruins on Earth. Looks like they're very, VERY fragile - if you squeeze it just a little bit, the glass breaks instantly. Oh, and I was really worn out that day. Even coffee didn't help. Why I'm telling this, you might ask? Well, the broken medallion released this fantastic smell that made me feel more alive than ever! You might want to have a look at these things."
}
iSecondWind:addCallback("pickup", function(player)
    local playerdata = player:getData()
    playerdata.secondwind = playerdata.secondwind + 1

    if net.host then
        packetPlayerDataSync:sendAsHost(net.ALL, nil, player:getNetIdentity(), "secondwind", playerdata.secondwind)
    else
        packetPlayerDataSync:sendAsClient(player:getNetIdentity(), "secondwind", playerdata.secondwind)
    end
end)

iHealthPills = Item.new("Health Pills")
iHealthPills.pickupText = "More healing on revive"
iHealthPills.sprite = sHealthPills
iHealthPills:setTier("common")
iHealthPills:setLog{
    group = "common",
    description = "You and your revivees get &g&+4% more health&!& on revive",
    destination = "19 Journey St\nPolus\nEarth",
    date = "12/07/2056",
    story = "I found these while digging through my medkit, and that was the most fortunate moment in my life. Taking one every day cured my 'chronic' illness in just one week! I'm sure they'll help you with your illness as well!"
}
iHealthPills:addCallback("pickup", function(player)
    local playerdata = player:getData()
    playerdata.healthpills = playerdata.healthpills + 1

    if net.host then
        packetPlayerDataSync:sendAsHost(net.ALL, nil, player:getNetIdentity(), "healthpills", playerdata.healthpills)
    else
        packetPlayerDataSync:sendAsClient(player:getNetIdentity(), "healthpills", playerdata.healthpills)
    end
end)
