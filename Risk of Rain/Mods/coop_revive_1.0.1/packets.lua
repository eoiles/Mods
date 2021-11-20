packetPlayerDataSync = nil
packetPlayerDataSync = net.Packet.new("Co-op Revive Player Data Sync", function(caller, playerNetIdentity, valuename, newvalue)
    local player = playerNetIdentity:resolve()
    if player ~= nil and player:isValid() then
        local playerdata = player:getData()
        local newvalue_set = newvalue
        if isa(newvalue, "NetInstance") then
            newvalue_set = newvalue:resolve()
        end
        playerdata[valuename] = newvalue_set

        if net.host then
            packetPlayerDataSync:sendAsHost(net.EXCLUDE, caller, playerNetIdentity, valuename, newvalue)
        end
    end
end)

packetPlayerVariableSync = nil
packetPlayerVariableSync = net.Packet.new("Co-op Revive Player Variable Sync", function(caller, playerNetIdentity, varname, newvalue)
    local player = playerNetIdentity:resolve()
    if player ~= nil and player:isValid() then
        local newvalue_set = newvalue
        if isa(newvalue, "NetInstance") then
            newvalue_set = newvalue:resolve()
        end
        player:set(varname, newvalue_set)

        if net.host then
            packetPlayerVariableSync:sendAsHost(net.EXCLUDE, caller, playerNetIdentity, varname, newvalue)
        end
    end
end)

packetPlayerVisibleFix = nil
packetPlayerVisibleFix = net.Packet.new("Co-op Revive Player Visible Fix", function(caller, playerNetIdentity)
    local player = playerNetIdentity:resolve()
    if player ~= nil and player:isValid() then
        player.visible = true

        if net.host then
            packetPlayerVisibleFix:sendAsHost(net.EXCLUDE, caller, playerNetIdentity)
        end
    end
end)