require("sprites")
require("particles")
require("packets")
if modloader.checkFlag("coop_revive_items") then require("items") end
require("buffs")
require("util")

callback.register("onStep", function()
    for _, player in ipairs(misc.players) do
        if player:isValid() and player:get("dead") ~= 1 then
            local playerdata = player:getData()
            if playerdata.init == nil then
                playerdata.init = true
                playerdata.revive_target = nil
                playerdata.dead = false
                playerdata.death_x = 0
                playerdata.death_y = 0
                playerdata.presses_remaining = 0
                playerdata.maxpresses = 6
                playerdata.accuracy = 0
                playerdata.linepassed = 0
                playerdata.line = 0
                playerdata.maxline = 2
                playerdata.linespeed = 0.065
                playerdata.regenpower = 0.4
                playerdata.press_bump = 0
                playerdata.press_bump_max = 6
                playerdata.percentage = 0
                playerdata.percentage_target = 0
                playerdata.defibrillator = 0
                playerdata.secondwind = 0
                playerdata.secondwind_added_pHmax = 0
                playerdata.secondwind_added_attack_speed = 0
                playerdata.secondwind_added_damage = 0
                playerdata.healthpills = 0
                playerdata.time = 0
                if net.host then
                    for key, value in pairs(playerdata) do
                        packetPlayerDataSync:sendAsHost(net.ALL, nil, player:getNetIdentity(), key, value)
                    end
                else
                    for key, value in pairs(playerdata) do
                        packetPlayerDataSync:sendAsClient(player:getNetIdentity(), key, value)
                    end
                end
            end
            playerdata.time = playerdata.time + 1
            if player:get("hp") <= 0 and player:get("hippo") <= 0 and (not net.online or player == net.localPlayer) then
                player:set("hp", 0.01)
                player:set("lastHp", 0.01)
                player:set("true_invincible", 1)
                playerdata.dead = true
                playerdata.death_x = player.x
                playerdata.death_y = player.y

                local poi = Object.findInstance(player:get("child_poi"))
                if poi ~= nil and poi:isValid() then
                    poi:destroy()
                end

                if net.host then
                    packetPlayerDataSync:sendAsHost(net.ALL, nil, player:getNetIdentity(), "dead", playerdata.dead)
                    packetPlayerDataSync:sendAsHost(net.ALL, nil, player:getNetIdentity(), "death_x", playerdata.death_x)
                    packetPlayerDataSync:sendAsHost(net.ALL, nil, player:getNetIdentity(), "death_y", playerdata.death_y)

                    packetPlayerVariableSync:sendAsHost(net.ALL, nil, player:getNetIdentity(), "hp", player:get("hp"))
                    packetPlayerVariableSync:sendAsHost(net.ALL, nil, player:getNetIdentity(), "lastHp", player:get("lastHp"))
                    packetPlayerVariableSync:sendAsHost(net.ALL, nil, player:getNetIdentity(), "true_invincible", player:get("true_invincible"))
                else
                    packetPlayerDataSync:sendAsClient(player:getNetIdentity(), "dead", playerdata.dead)
                    packetPlayerDataSync:sendAsClient(player:getNetIdentity(), "death_x", playerdata.death_x)
                    packetPlayerDataSync:sendAsClient(player:getNetIdentity(), "death_y", playerdata.death_y)

                    packetPlayerVariableSync:sendAsClient(player:getNetIdentity(), "hp", player:get("hp"))
                    packetPlayerVariableSync:sendAsClient(player:getNetIdentity(), "lastHp", player:get("lastHp"))
                    packetPlayerVariableSync:sendAsClient(player:getNetIdentity(), "true_invincible", player:get("true_invincible"))
                end
            end
            if playerdata.dead then
                local one_alive = false
                for _, player2 in ipairs(misc.players) do
                    if player2:isValid() then
                        local playerdata2 = player2:getData()
                        if not playerdata2.dead and player2:get("dead") ~= 1 then
                            one_alive = true
                        end
                    end
                end
                if one_alive then
                    if player:getAlarm(0) < 2 then player:setAlarm(0, 2) end
                    if player:getAlarm(2) < 2 then player:setAlarm(2, 2) end
                    if player:getAlarm(3) < 2 then player:setAlarm(3, 2) end
                    if player:getAlarm(4) < 2 then player:setAlarm(4, 2) end
                    if player:getAlarm(5) < 2 then player:setAlarm(5, 2) end
                    player:set("hp", 0.01)
                    player:set("lastHp", 0.01)
                    player:set("true_invincible", 1)
                    player:set("activity_type", 1)
                    player:set("activity", 95)
                    player:set("pVspeed", 0)
                    player:set("pVspeed", 0)
                    player.visible = false

                    player.x = playerdata.death_x
                    player.y = playerdata.death_y

                    playerdata.line = playerdata.line + playerdata.linespeed
                    playerdata.linepassed = playerdata.linepassed + math.abs(playerdata.linespeed)
                    if playerdata.line > playerdata.maxline then
                        playerdata.line = playerdata.maxline
                        playerdata.linespeed = -math.abs(playerdata.linespeed)
                    end
                    if playerdata.line < 0 then
                        playerdata.line = 0
                        playerdata.linespeed = math.abs(playerdata.linespeed)
                    end

                    if playerdata.press_bump > 0 then
                        playerdata.press_bump = playerdata.press_bump - 0.7
                    end
                    if playerdata.press_bump < 0 then
                        playerdata.press_bump = 0
                    end
                    playerdata.percentage = playerdata.percentage + (playerdata.percentage_target - playerdata.percentage) * 0.3
                else
                    if player:get("dead") ~= 1 then
                        player:set("force_death", 1)
                        player:set("true_invincible", 0)
                    end
                end
            else
                if playerdata.revive_target == nil or not playerdata.revive_target:isValid() then
                    if player:control("enter") == input.PRESSED and player:get("activity") == 0 then
                        for _, player2 in ipairs(misc.players) do
                            local playerdata2 = player2:getData()
                            if player2 ~= player and point_distance(player.x, player.y, player2.x, player2.y) <= 20 then
                                if playerdata2.dead then
                                    playerdata.revive_target = player2
                                    playerdata2.percentage = 0
                                    playerdata2.percentage_target = 0
                                    playerdata2.presses_remaining = playerdata2.maxpresses - playerdata2.defibrillator - playerdata.defibrillator
                                    if playerdata2.presses_remaining < 1 then
                                        playerdata2.presses_remaining = 1
                                    end
                                    if playerdata2.defibrillator > 0 then
                                        Sound.find("Drill", "vanilla"):play(1.5)
                                        pElectrospark:burst("above", playerdata2.death_x, playerdata2.death_y, 5 * playerdata2.defibrillator)
                                        playerdata2.percentage_target = (1 - playerdata2.presses_remaining / playerdata2.maxpresses) * 100
                                    end
                                    playerdata2.accuracy = 0
                                    if net.host then
                                        packetPlayerDataSync:sendAsHost(net.ALL, nil, player:getNetIdentity(), "revive_target", playerdata.revive_target:getNetIdentity())
                                        packetPlayerDataSync:sendAsHost(net.ALL, nil, player2:getNetIdentity(), "presses_remaining", playerdata2.presses_remaining)
                                        packetPlayerDataSync:sendAsHost(net.ALL, nil, player2:getNetIdentity(), "accuracy", playerdata2.accuracy)
                                        packetPlayerDataSync:sendAsHost(net.ALL, nil, player2:getNetIdentity(), "percentage", playerdata2.percentage)
                                        packetPlayerDataSync:sendAsHost(net.ALL, nil, player2:getNetIdentity(), "percentage_target", playerdata2.percentage_target)
                                    else
                                        packetPlayerDataSync:sendAsClient(player:getNetIdentity(), "revive_target", playerdata.revive_target:getNetIdentity())
                                        packetPlayerDataSync:sendAsClient(player2:getNetIdentity(), "presses_remaining", playerdata2.presses_remaining)
                                        packetPlayerDataSync:sendAsClient(player2:getNetIdentity(), "accuracy", playerdata2.accuracy)
                                        packetPlayerDataSync:sendAsClient(player2:getNetIdentity(), "percentage", playerdata2.percentage)
                                        packetPlayerDataSync:sendAsClient(player2:getNetIdentity(), "percentage_target", playerdata2.percentage_target)
                                    end
                                end
                            end
                        end
                    end
                else
                    local player2 = playerdata.revive_target
                    local playerdata2 = player2:getData()

                    if player:getAlarm(0) < 2 then player:setAlarm(0, 2) end
                    if player:getAlarm(2) < 2 then player:setAlarm(2, 2) end
                    if player:getAlarm(3) < 2 then player:setAlarm(3, 2) end
                    if player:getAlarm(4) < 2 then player:setAlarm(4, 2) end
                    if player:getAlarm(5) < 2 then player:setAlarm(5, 2) end
                    player:set("activity_type", 1)
                    player:set("activity", 95)
                    player:set("pHspeed", 0)
                    player.x = player2.x
                    player.visible = false

                    if player2 ~= nil and player2:isValid() then
                        if player:control("enter") == input.PRESSED then
                            playerdata2.presses_remaining = playerdata2.presses_remaining - 1
                            local this_press_accuracy = (1 - math.abs(playerdata2.line - (playerdata2.maxline / 2)) / (playerdata2.maxline / 2)) * (1 - math.clamp(playerdata2.maxline - playerdata2.linepassed, 0, playerdata2.maxline) / playerdata2.maxline)
                            playerdata2.linepassed = 0
                            if playerdata2.accuracy == 0 then
                                playerdata2.accuracy = this_press_accuracy
                            else
                                playerdata2.accuracy = (playerdata2.accuracy + this_press_accuracy) / 2
                            end
                            playerdata2.press_bump = playerdata2.press_bump_max
                            playerdata2.percentage_target = (1 - playerdata2.presses_remaining / playerdata2.maxpresses) * 100
                            if playerdata2.presses_remaining == 1 and playerdata2.percentage_target < 95 then
                                playerdata2.percentage_target = 95
                            end

                            if net.host then
                                packetPlayerDataSync:sendAsHost(net.ALL, nil, player2:getNetIdentity(), "presses_remaining", playerdata2.presses_remaining)
                                packetPlayerDataSync:sendAsHost(net.ALL, nil, player2:getNetIdentity(), "linepassed", playerdata2.linepassed)
                                packetPlayerDataSync:sendAsHost(net.ALL, nil, player2:getNetIdentity(), "accuracy", playerdata2.accuracy)
                                packetPlayerDataSync:sendAsHost(net.ALL, nil, player2:getNetIdentity(), "press_bump", playerdata2.press_bump)
                                packetPlayerDataSync:sendAsHost(net.ALL, nil, player2:getNetIdentity(), "line", playerdata2.line)
                                packetPlayerDataSync:sendAsHost(net.ALL, nil, player2:getNetIdentity(), "percentage_target", playerdata2.percentage_target)
                            else
                                packetPlayerDataSync:sendAsClient(player2:getNetIdentity(), "presses_remaining", playerdata2.presses_remaining)
                                packetPlayerDataSync:sendAsClient(player2:getNetIdentity(), "linepassed", playerdata2.linepassed)
                                packetPlayerDataSync:sendAsClient(player2:getNetIdentity(), "accuracy", playerdata2.accuracy)
                                packetPlayerDataSync:sendAsClient(player2:getNetIdentity(), "press_bump", playerdata2.press_bump)
                                packetPlayerDataSync:sendAsClient(player2:getNetIdentity(), "line", playerdata2.line)
                                packetPlayerDataSync:sendAsClient(player2:getNetIdentity(), "percentage_target", playerdata2.percentage_target)
                            end
                        end

                        if playerdata2.presses_remaining <= 0 then
                            local revive_effect = Object.find("EfSparks", "vanilla"):create(player2.x, player2.y - 50)
                            revive_effect.sprite = Sprite.find("EfRevive", "vanilla")
                            revive_effect.yscale = 1
                            Sound.find("Revive", "vanilla"):play()
                            player2:set("activity", 0)
                            player2:set("activity_type", 0)
                            local revive_heal = player:get("maxhp") * playerdata2.accuracy * (playerdata2.regenpower + playerdata.healthpills * 0.04)
                            misc.damage(revive_heal, player2.x, player2.y, false, Color.DAMAGE_HEAL)
                            player2:set("hp", revive_heal)
                            player2:set("lastHp", revive_heal)
                            player2:set("true_invincible", 0)
                            player2.visible = true
                            playerdata2.dead = false
                            playerdata2.linespeed = playerdata2.linespeed
                            playerdata2.regenpower = playerdata2.regenpower
                            playerdata2.percentage = 0
                            playerdata2.percentage_target = 0

                            if playerdata2.secondwind > 0 then
                                local bufftime = 60 * (7 + (playerdata2.secondwind - 1))
                                player:applyBuff(bSecondWind, bufftime)
                                player2:applyBuff(bSecondWind, bufftime)
                            end

                            playerdata.revive_target = nil
                            player.visible = true
                            player:set("activity", 0)
                            player:set("activity_type", 0)

                            local new_poi = Object.find("POI", "vanilla"):create(player2.x, player2.y)
                            player2:set("child_poi", new_poi.id)
                            new_poi:set("parent", player2.id)

                            if net.host then
                                packetPlayerDataSync:sendAsHost(net.ALL, nil, player2:getNetIdentity(), "dead", playerdata2.dead)
                                packetPlayerDataSync:sendAsHost(net.ALL, nil, player2:getNetIdentity(), "linespeed", playerdata2.linespeed)
                                packetPlayerDataSync:sendAsHost(net.ALL, nil, player2:getNetIdentity(), "regenpower", playerdata2.regenpower)
                                packetPlayerDataSync:sendAsHost(net.ALL, nil, player2:getNetIdentity(), "percentage", playerdata2.percentage)
                                packetPlayerDataSync:sendAsHost(net.ALL, nil, player2:getNetIdentity(), "percentage_target", playerdata2.percentage_target)
                                packetPlayerDataSync:sendAsHost(net.ALL, nil, player:getNetIdentity(), "revive_target", playerdata.revive_target)

                                packetPlayerVariableSync:sendAsHost(net.ALL, nil, player2:getNetIdentity(), "activity", player2:get("activity"))
                                packetPlayerVariableSync:sendAsHost(net.ALL, nil, player2:getNetIdentity(), "activity_type", player2:get("activity_type"))
                                packetPlayerVariableSync:sendAsHost(net.ALL, nil, player2:getNetIdentity(), "hp", player2:get("hp"))
                                packetPlayerVariableSync:sendAsHost(net.ALL, nil, player2:getNetIdentity(), "lastHp", player2:get("lastHp"))
                                packetPlayerVariableSync:sendAsHost(net.ALL, nil, player2:getNetIdentity(), "true_invincible", player2:get("true_invincible"))
                                packetPlayerVariableSync:sendAsHost(net.ALL, nil, player:getNetIdentity(), "activity", player:get("activity"))
                                packetPlayerVariableSync:sendAsHost(net.ALL, nil, player:getNetIdentity(), "activity_type", player:get("activity_type"))

                                packetPlayerVisibleFix:sendAsHost(net.ALL, nil, player:getNetIdentity())
                                packetPlayerVisibleFix:sendAsHost(net.ALL, nil, player2:getNetIdentity())
                            else
                                packetPlayerDataSync:sendAsClient(player2:getNetIdentity(), "dead", playerdata2.dead)
                                packetPlayerDataSync:sendAsClient(player2:getNetIdentity(), "linespeed", playerdata2.linespeed)
                                packetPlayerDataSync:sendAsClient(player2:getNetIdentity(), "regenpower", playerdata2.regenpower)
                                packetPlayerDataSync:sendAsClient(player2:getNetIdentity(), "percentage", playerdata2.percentage)
                                packetPlayerDataSync:sendAsClient(player2:getNetIdentity(), "percentage_target", playerdata2.percentage_target)
                                packetPlayerDataSync:sendAsClient(player:getNetIdentity(), "revive_target", playerdata.revive_target)

                                packetPlayerVariableSync:sendAsClient(player2:getNetIdentity(), "activity", player2:get("activity"))
                                packetPlayerVariableSync:sendAsClient(player2:getNetIdentity(), "activity_type", player2:get("activity_type"))
                                packetPlayerVariableSync:sendAsClient(player2:getNetIdentity(), "hp", player2:get("hp"))
                                packetPlayerVariableSync:sendAsClient(player2:getNetIdentity(), "lastHp", player2:get("lastHp"))
                                packetPlayerVariableSync:sendAsClient(player2:getNetIdentity(), "true_invincible", player2:get("true_invincible"))
                                packetPlayerVariableSync:sendAsClient(player:getNetIdentity(), "activity", player:get("activity"))
                                packetPlayerVariableSync:sendAsClient(player:getNetIdentity(), "activity_type", player:get("activity_type"))

                                packetPlayerVisibleFix:sendAsClient(player:getNetIdentity())
                                packetPlayerVisibleFix:sendAsClient(player2:getNetIdentity())
                            end
                        end
                    end
                end
            end
        end
    end
end)

callback.register("onDraw", function()
    graphics.resetTarget()
    graphics.alpha(1)
    graphics.color(Color.WHITE)
    for _, player in ipairs(misc.players) do
        if player:isValid() and player:get("dead") ~= 1 then
            local playerdata = player:getData()
            if playerdata.dead then
                local squish = 0.5 * (playerdata.press_bump / playerdata.press_bump_max)
                graphics.drawImage{
                    image = player:getAnimation("death"),
                    x = playerdata.death_x,
                    y = playerdata.death_y,
                    subimage = player:getAnimation("death").frames,
                    color = player.blendColor,
                    angle = player.angle,
                    xscale = player.xscale,
                    yscale = player.yscale * (1 - squish),
                    alpha = player.alpha
                }
                if playerdata.presses_remaining ~= nil and playerdata.presses_remaining > 0 then
                    local line_x = playerdata.death_x
                    local line_y = playerdata.death_y - 50 - playerdata.press_bump
                    local linewidth = 60
                    local lineheight = 4
                    local bar_x = line_x - linewidth / 2 + linewidth * (playerdata.line / playerdata.maxline)
                    local barwidth = 2
                    graphics.color(Color.ROR_RED)
                    graphics.line(line_x - linewidth / 2, line_y, line_x + linewidth / 2, line_y, lineheight)
                    graphics.color(Color.WHITE)
                    graphics.line(bar_x, line_y - lineheight - 2, bar_x, line_y + lineheight + 2, barwidth)
                    graphics.drawImage{sReviveHeart, line_x, line_y, color = Color.ROR_RED}

                    print_color_ext("&w&Press &y&'A'&w&! (" .. tostring(math.round(playerdata.percentage)) .. "%)", playerdata.death_x, playerdata.death_y - 60 - playerdata.press_bump, graphics.FONT_DEFAULT, graphics.ALIGN_MIDDLE, graphics.ALIGN_CENTER)
                else
                    print_color_ext("&w&Press &y&'A'&w& to revive " .. player:get("user_name"), playerdata.death_x, playerdata.death_y - 60, graphics.FONT_DEFAULT, graphics.ALIGN_MIDDLE, graphics.ALIGN_CENTER)
                end
            end
        end
    end

    for _, player in ipairs(misc.players) do
        if player:isValid() then
            local playerdata = player:getData()
            if not playerdata.dead then
                if playerdata.revive_target ~= nil and playerdata.revive_target:isValid() then
                    local player2 = playerdata.revive_target
                    local playerdata2 = player2:getData()
                    local squish = 0.5 * (playerdata2.press_bump / playerdata2.press_bump_max)
                    graphics.drawImage{
                        image = player:getAnimation("climb"),
                        x = player.x,
                        y = player.y + 2,
                        subimage = player:getAnimation("climb").frames,
                        color = player.blendColor,
                        angle = player.angle,
                        xscale = player.xscale,
                        yscale = player.yscale * (1 - squish),
                        alpha = player.alpha
                    }

                    print_color_ext(player:get("user_name") .. " reviving " .. player2:get("user_name"), playerdata2.death_x, playerdata2.death_y - 80, graphics.FONT_DEFAULT, graphics.ALIGN_MIDDLE, graphics.ALIGN_CENTER)
                end
            end
        end
    end
end)
