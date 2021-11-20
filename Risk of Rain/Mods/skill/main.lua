
callback.register("onPlayerInit", function(player)
        
        if(player:get("name")=="Commando")
        then
                for i = 1, 4 do
                        player:setSkill(i,
                        "",
                        "",
                        Sprite.find("GManSkills", "Vanilla"),
                        i,
                        0)
                end    
        end
        

end)

