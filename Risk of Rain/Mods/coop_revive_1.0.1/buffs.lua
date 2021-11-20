require("sprites")
require("packets")

bSecondWind = Buff.new("Second Wind")
bSecondWind.sprite = sBuffSecondWind
bSecondWind:addCallback("start", function(player)
    local playerdata = player:getData()
    local old_pHmax = player:get("pHmax")
    local old_attack_speed = player:get("attack_speed")
    local old_damage = player:get("damage")

    player:set("pHmax", player:get("pHmax") * 1.5)
    player:set("attack_speed", player:get("attack_speed") * 1.5)
    player:set("damage", player:get("damage") * 1.5)

    playerdata.secondwind_added_pHmax = playerdata.secondwind_added_pHmax + player:get("pHmax") - old_pHmax
    playerdata.secondwind_added_attack_speed = playerdata.secondwind_added_attack_speed + player:get("attack_speed") - old_attack_speed
    playerdata.secondwind_added_damage = playerdata.secondwind_added_damage + player:get("damage") - old_damage

    if net.host then
        packetPlayerVariableSync:sendAsHost(net.ALL, nil, player:getNetIdentity(), "pHmax", player:get("pHmax"))
        packetPlayerVariableSync:sendAsHost(net.ALL, nil, player:getNetIdentity(), "attack_speed", player:get("attack_speed"))
        packetPlayerVariableSync:sendAsHost(net.ALL, nil, player:getNetIdentity(), "damage", player:get("damage"))

        packetPlayerDataSync:sendAsHost(net.ALL, nil, player:getNetIdentity(), "secondwind_added_pHmax", playerdata.secondwind_added_pHmax)
        packetPlayerDataSync:sendAsHost(net.ALL, nil, player:getNetIdentity(), "secondwind_added_attack_speed", playerdata.secondwind_added_attack_speed)
        packetPlayerDataSync:sendAsHost(net.ALL, nil, player:getNetIdentity(), "secondwind_added_damage", playerdata.secondwind_added_damage)
    else
        packetPlayerVariableSync:sendAsClient(player:getNetIdentity(), "pHmax", player:get("pHmax"))
        packetPlayerVariableSync:sendAsClient(player:getNetIdentity(), "attack_speed", player:get("attack_speed"))
        packetPlayerVariableSync:sendAsClient(player:getNetIdentity(), "damage", player:get("damage"))

        packetPlayerDataSync:sendAsClient(player:getNetIdentity(), "secondwind_added_pHmax", playerdata.secondwind_added_pHmax)
        packetPlayerDataSync:sendAsClient(player:getNetIdentity(), "secondwind_added_attack_speed", playerdata.secondwind_added_attack_speed)
        packetPlayerDataSync:sendAsClient(player:getNetIdentity(), "secondwind_added_damage", playerdata.secondwind_added_damage)
    end
end)
bSecondWind:addCallback("end", function(player)
    local playerdata = player:getData()

    player:set("pHmax", player:get("pHmax") - playerdata.secondwind_added_pHmax)
    player:set("attack_speed", player:get("attack_speed") - playerdata.secondwind_added_attack_speed)
    player:set("damage", player:get("damage") - playerdata.secondwind_added_damage)

    playerdata.secondwind_added_pHmax = 0
    playerdata.secondwind_added_attack_speed = 0
    playerdata.secondwind_added_damage = 0

    if net.host then
        packetPlayerVariableSync:sendAsHost(net.ALL, nil, player:getNetIdentity(), "pHmax", player:get("pHmax"))
        packetPlayerVariableSync:sendAsHost(net.ALL, nil, player:getNetIdentity(), "attack_speed", player:get("attack_speed"))
        packetPlayerVariableSync:sendAsHost(net.ALL, nil, player:getNetIdentity(), "damage", player:get("damage"))

        packetPlayerDataSync:sendAsHost(net.ALL, nil, player:getNetIdentity(), "secondwind_added_pHmax", playerdata.secondwind_added_pHmax)
        packetPlayerDataSync:sendAsHost(net.ALL, nil, player:getNetIdentity(), "secondwind_added_attack_speed", playerdata.secondwind_added_attack_speed)
        packetPlayerDataSync:sendAsHost(net.ALL, nil, player:getNetIdentity(), "secondwind_added_damage", playerdata.secondwind_added_damage)
    else
        packetPlayerVariableSync:sendAsClient(player:getNetIdentity(), "pHmax", player:get("pHmax"))
        packetPlayerVariableSync:sendAsClient(player:getNetIdentity(), "attack_speed", player:get("attack_speed"))
        packetPlayerVariableSync:sendAsClient(player:getNetIdentity(), "damage", player:get("damage"))

        packetPlayerDataSync:sendAsClient(player:getNetIdentity(), "secondwind_added_pHmax", playerdata.secondwind_added_pHmax)
        packetPlayerDataSync:sendAsClient(player:getNetIdentity(), "secondwind_added_attack_speed", playerdata.secondwind_added_attack_speed)
        packetPlayerDataSync:sendAsClient(player:getNetIdentity(), "secondwind_added_damage", playerdata.secondwind_added_damage)
    end
end)
