





allItems=ItemPool.new("all items")

callback.register("onGameStart", function()


    for a, b in pairs(it) do
        allItems:add(b)
    end

end)

registercallback("onNPCDeathProc", function(npc, players)


    allItems:roll():getObject():create(npc.x, npc.y)


end)