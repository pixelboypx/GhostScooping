
--================================================--
--変数
--================================================--

local lg = love.graphics
local lk = love.keyboard

playerselect = {}

playerselectText = {"Character", "Config", "Exit"}

local startMode = false
startNum = 0

local backmenu_dt = 0
local backmenu_time = 1

local showBackIcon = false

local characterName = {"orin", "oku", "koishi", "satori"}


--================================================--
--シーンチェンジ
--================================================--

function playerselect.enter()

    scene = STATE_PLAYERSELECT

    player_object = {}
    sukui_object = {}
    ghost_object = {}
    animalghost_object = {}

end

--================================================--
--更新
--================================================--

function playerselect.keypressed(k)

    local the_player
    local __i
    
    if player_object then
        for i = 1, #player_object do
            if player_object[i].type == "Keyboard" then
                the_player = player_object[i]
                __i = i
            end
        end
    end

    if not the_player then
        if k == "z" then
            if not player_object then
                addPlayer("Keyboard", 0, 1)
            else
                local isPositioned = false
                for i = 1, 4 do
                    local hasPosition = true
                    for j = 1, #player_object do
                        if player_object[j].Position == i then
                            hasPosition = false
                        end
                    end
                    if not isPositioned and hasPosition then
                        addPlayer("Keyboard", __id, i)
                        isPositioned = true
                    end
                end
            end
        end
    else
        if the_player.state == 1 then
            if k == "z" then
                if playerselectText[the_player.selectNum] == "Character" then
                    the_player.state = 3
                elseif playerselectText[the_player.selectNum] == "Config" then
                elseif playerselectText[the_player.selectNum] == "Quit" then
                    table.remove(player_object, __i)
                end
            elseif k == "x" then
                if the_player.selectNum == #playerselectText then
                    table.remove(player_object, __i)
                else
                    the_player.selectNum = #playerselectText
                end
            end
        elseif the_player.state == 3 then
            if k == "z" then
                startNum = startNum + 1
            elseif k == "x" then
                the_player.state = 1
            end
        end
    end

end


--================================================--
--更新
--================================================--

function playerselect.joystickpressed(j, b)
    
    local __id = j:getID()

    local the_player
    local __i
    
    if player_object then
        for i = 1, #player_object do
            if player_object[i].id == __id then
                the_player = player_object[i]
                __i = i
            end
        end
    end

    if not the_player then
        if b == 1 then
            if not player_object then
                addPlayer("Controler", __id, 1)
            else
                local isPositioned = false
                for i = 1, 4 do
                    local hasPosition = true
                    for j = 1, #player_object do
                        if player_object[j].Position == i then
                            hasPosition = false
                        end
                    end
                    if not isPositioned and hasPosition then
                        addPlayer("Controler", __id, i)
                        isPositioned = true
                    end
                end
            end
        end
    else
        if the_player.state == 1 then
            if b == the_player.KeyConfig[1] then
                if playerselectText[the_player.selectNum] == "Character" then
                    the_player.state = 3
                elseif playerselectText[the_player.selectNum] == "Config" then
                elseif playerselectText[the_player.selectNum] == "Quit" then
                    table.remove(player_object, __i)
                end
            elseif b == the_player.KeyConfig[2] then
                if the_player.selectNum == #playerselectText then
                    table.remove(player_object, __i)
                else
                    the_player.selectNum = #playerselectText
                end
            end
        elseif the_player.state == 3 then
            if b == the_player.KeyConfig[1] then
                startNum = startNum + 1
            elseif b == the_player.KeyConfig[2] then
                the_player.state = 1
            end
        end
    end

end


--================================================--
--更新
--================================================--

function playerselect.update(dt)

    local movetime = 0.2

    if player_object[1] then
        for j = 1, #player_object do
            local joysticks = love.joystick.getJoysticks()
            for i, joystick in ipairs(joysticks) do
                if joystick:getID() == player_object[j].id then
                    local a1, a2 = joystick:getAxes()
                    if player_object[j].state == 1 then
                        if player_object[j].selectNum == 1 then
                            if a1 == -1 then
                                if player_object[j].character_dt == 0 then
                                    if player_object[j].character == 1 then
                                        player_object[j].character = 4
                                    else
                                        player_object[j].character = player_object[j].character - 1
                                    end
                                elseif player_object[j].character_dt > movetime then
                                    if player_object[j].character == 1 then
                                        player_object[j].character = 4
                                    else
                                        player_object[j].character = player_object[j].character - 1
                                    end
                                    player_object[j].character_dt = player_object[j].character_dt - movetime
                                end
                                player_object[j].character_dt = player_object[j].character_dt + dt
                            elseif a1 == 1 then
                                if player_object[j].character_dt == 0 then
                                    if player_object[j].character == 4 then
                                        player_object[j].character = 1
                                    else
                                        player_object[j].character = player_object[j].character + 1
                                    end
                                elseif player_object[j].character_dt > movetime then
                                    if player_object[j].character == 4 then
                                        player_object[j].character = 1
                                    else
                                        player_object[j].character = player_object[j].character + 1
                                    end
                                    player_object[j].character_dt = player_object[j].character_dt - movetime
                                end
                                player_object[j].character_dt = player_object[j].character_dt + dt
                            else
                                player_object[j].character_dt = 0
                            end
                        end
                        
                        if a2 == -1 then
                            if player_object[j].movedt == 0 then
                                if player_object[j].selectNum == 1 then
                                    player_object[j].selectNum = #playerselectText
                                else
                                    player_object[j].selectNum = player_object[j].selectNum - 1
                                end
                            elseif player_object[j].movedt > movetime then
                                if player_object[j].selectNum == 1 then
                                    player_object[j].selectNum = #playerselectText
                                else
                                    player_object[j].selectNum = player_object[j].selectNum - 1
                                end
                                player_object[j].movedt = player_object[j].movedt - movetime
                            end
                            player_object[j].movedt = player_object[j].movedt + dt
                        elseif a2 == 1 then
                            if player_object[j].movedt == 0 then
                                if player_object[j].selectNum == #playerselectText then
                                    player_object[j].selectNum = 1
                                else
                                    player_object[j].selectNum = player_object[j].selectNum + 1
                                end
                            elseif player_object[j].movedt > movetime then
                                if player_object[j].selectNum == #playerselectText then
                                    player_object[j].selectNum = 1
                                else
                                    player_object[j].selectNum = player_object[j].selectNum + 1
                                end
                                player_object[j].movedt = player_object[j].movedt - movetime
                            end
                            player_object[j].movedt = player_object[j].movedt + dt
                        else
                            player_object[j].movedt = 0
                        end
                    end
                end
            end
            
            if player_object[j].type == "Keyboard" then
                if player_object[j].state == 1 then
                    if player_object[j].selectNum == 1 then
                        if lk.isDown("left", "a") then
                            if player_object[j].character_dt == 0 then
                                if player_object[j].character == 1 then
                                    player_object[j].character = 4
                                else
                                    player_object[j].character = player_object[j].character - 1
                                end
                            elseif player_object[j].character_dt > movetime then
                                if player_object[j].character == 1 then
                                    player_object[j].character = 4
                                else
                                    player_object[j].character = player_object[j].character - 1
                                end
                                player_object[j].character_dt = player_object[j].character_dt - movetime
                            end
                            player_object[j].character_dt = player_object[j].character_dt + dt
                        elseif lk.isDown("right", "d") then
                            if player_object[j].character_dt == 0 then
                                if player_object[j].character == 4 then
                                    player_object[j].character = 1
                                else
                                    player_object[j].character = player_object[j].character + 1
                                end
                            elseif player_object[j].character_dt > movetime then
                                if player_object[j].character == 4 then
                                    player_object[j].character = 1
                                else
                                    player_object[j].character = player_object[j].character + 1
                                end
                                player_object[j].character_dt = player_object[j].character_dt - movetime
                            end
                            player_object[j].character_dt = player_object[j].character_dt + dt
                        else
                            player_object[j].character_dt = 0
                        end
                    end
                    
                    if lk.isDown("up", "w") then
                        if player_object[j].movedt == 0 then
                            if player_object[j].selectNum == 1 then
                                player_object[j].selectNum = #playerselectText
                            else
                                player_object[j].selectNum = player_object[j].selectNum - 1
                            end
                        elseif player_object[j].movedt > movetime then
                            if player_object[j].selectNum == 1 then
                                player_object[j].selectNum = #playerselectText
                            else
                                player_object[j].selectNum = player_object[j].selectNum - 1
                            end
                            player_object[j].movedt = player_object[j].movedt - movetime
                        end
                        player_object[j].movedt = player_object[j].movedt + dt
                    elseif lk.isDown("down", "s") then
                        if player_object[j].movedt == 0 then
                            if player_object[j].selectNum == #playerselectText then
                                player_object[j].selectNum = 1
                            else
                                player_object[j].selectNum = player_object[j].selectNum + 1
                            end
                        elseif player_object[j].movedt > movetime then
                            if player_object[j].selectNum == #playerselectText then
                                player_object[j].selectNum = 1
                            else
                                player_object[j].selectNum = player_object[j].selectNum + 1
                            end
                            player_object[j].movedt = player_object[j].movedt - movetime
                        end
                        player_object[j].movedt = player_object[j].movedt + dt
                    else
                        player_object[j].movedt = 0
                    end
                end
            end
        end
    end

    local allPlayerSelected = false

    if #player_object ~= 0 then
        allPlayerSelected = true
        for j = 1, #player_object do
            if player_object[j].state ~= 3 then
                allPlayerSelected = false
            end
        end
    end

    if allPlayerSelected then
        startMode = true
    else
        startMode = false
        startNum = 0
    end

    if startMode and startNum >= #player_object * 5 then
        pregame.enter()
    end

    local isDownBack = false

    if lk.isDown("x") then
        isDownBack = true
    else
        local joysticks = love.joystick.getJoysticks()
        for i, joystick in ipairs(joysticks) do
            local __id = joystick:getID()
            local isUsed = false
            for j = 1, #player_object do
                if player_object[j].id == __id then
                    if joystick:isDown(player_object[j].KeyConfig[2]) then
                        isDownBack = true
                    end
                    isUsed = true
                end
            end
            if not isUsed then
                if joystick:isDown(2) then
                    isDownBack = true
                end
            end
        end
    end

    if isDownBack then
        backmenu_dt = backmenu_dt + dt
        if backmenu_dt > backmenu_time then
            opening.enter()
        end
        showBackIcon = true
    else
        showBackIcon = false
        backmenu_dt = 0
    end

end


--================================================--
--描画
--================================================--

function playerselect.draw()

    drawBackground()

    local gapW = 100 / defaultscale
    local gapT = 144 / defaultscale
    local gapH = 276 / defaultscale
    local gapMid = 40 / defaultscale
    
    local windowWidth, windowHeight = love.window.getMode()
    local selectwidth = (windowWidth / defaultscale - gapW * 2 - gapMid * 3) / 4
    local selectheight = windowHeight / defaultscale - gapH - gapT

    local player_Num = 0

    for i = 1, 4 do
        local hasPlayer = false
        if player_object then
            for j = 1, #player_object do
                if player_object[j].Position == i then
                    lg.setColor(1, 1, 1, 0.6)
                    lg.rectangle("fill", gapW + (gapMid + selectwidth) * (i - 1), gapT, selectwidth, selectheight)
                    lg.setColor(1, 1, 1)
                    if player_object[j].state == 1 then
                        lg.setFont(font.text)
                        for k = 1, #playerselectText do
                            lg.print(playerselectText[k], gapW + (gapMid + selectwidth) * (i - 1) + 13, gapT + selectheight / 2 + 15 + 10 * k)
                        end
                        lg.print("-", gapW + (gapMid + selectwidth) * (i - 1) + 7, gapT + selectheight / 2 + 15 + 10 * player_object[j].selectNum)
                        lg.setFont(font.strong)
                        lg.print("<", gapW + (gapMid + selectwidth) * (i - 1) + selectwidth / 2 - 22, gapT + 48)
                        lg.print(">", gapW + (gapMid + selectwidth) * (i - 1) + selectwidth / 2 + 16, gapT + 48)
                    elseif player_object[j].state == 3 then
                        lg.setFont(font.strong)
                        lg.print("ジュンビ", gapW + (gapMid + selectwidth) * (i - 1) + 14, gapT + selectheight / 2 + 25)
                        lg.print("カンリョウ", gapW + (gapMid + selectwidth) * (i - 1) + 10, gapT + selectheight / 2 + 35)
                    end
                    if player_object[j].state == 3 then
                        if player_object[j].type == "Keyboard" then
                            if lk.isDown("z") then
                                lg.draw(img[characterName[player_object[j].character].."_2"], gapW + (gapMid + selectwidth) * (i - 1) + selectwidth / 2 - 32, gapT + 20)
                            else
                                lg.draw(img[characterName[player_object[j].character]], gapW + (gapMid + selectwidth) * (i - 1) + selectwidth / 2 - 32, gapT + 20)
                            end
                        else
                            local joysticks = love.joystick.getJoysticks()
                            for i, joystick in ipairs(joysticks) do
                                if joystick:getID() == player_object[j].id then
                                    if joystick:isDown(player_object[j].KeyConfig[1]) then
                                        lg.draw(img[characterName[player_object[j].character].."_2"], gapW + (gapMid + selectwidth) * (i - 1) + selectwidth / 2 - 32, gapT + 20)
                                    else
                                        lg.draw(img[characterName[player_object[j].character]], gapW + (gapMid + selectwidth) * (i - 1) + selectwidth / 2 - 32, gapT + 20)
                                    end
                                end
                            end
                        end

                    else
                        lg.draw(img[characterName[player_object[j].character]], gapW + (gapMid + selectwidth) * (i - 1) + selectwidth / 2 - 32, gapT + 20)
                    end
                    hasPlayer = true
                    player_Num = player_Num + 1
                end
            end
        end
        if not hasPlayer then
            lg.setColor(1, 1, 1, 0.3)
            lg.rectangle("fill", gapW + (gapMid + selectwidth) * (i - 1), gapT, selectwidth, selectheight)
            lg.setColor(1, 1, 1, 0.6)
            lg.setFont(font.strong)
            lg.print("Press", gapW + (gapMid + selectwidth) * (i - 1) + selectwidth / 2 - font.strong:getWidth("Press") / 2, gapT + selectheight / 2)
            lg.print("button", gapW + (gapMid + selectwidth) * (i - 1) + selectwidth / 2 - font.strong:getWidth("button") / 2, gapT + selectheight / 2 + 12)
        end
        lg.setColor(1, 1, 1)
        lg.setFont(font.title)
        lg.print(i.."P", gapW + (gapMid + selectwidth) * (i - 1) + selectwidth / 2 - font.title:getWidth(i.."P") / 2, gapT + 8)
    end

    if startMode then
        lg.setColor(1, 1, 1, 0.6)
        lg.arc("line", "open", windowWidth / defaultscale / 2, gapT + selectheight + 33, 15, math.rad(-90), math.rad(startNum * 360 / player_Num / 5 - 90), 100)
        lg.setColor(1, 1, 1)
        lg.setFont(font.strong)
        lg.print("ボタンをおしてスタート", gapW + gapMid + selectwidth + 22, gapT + selectheight + 25)
    end
    
    lg.setColor(1, 1, 1)
    lg.draw(img.back, 10, 10)

    if showBackIcon then
        lg.setColor(1, 0, 0)
        lg.rectangle("fill", 29, 26 - backmenu_dt / backmenu_time * 16, 4, backmenu_dt / backmenu_time * 16)
        lg.setColor(1, 1, 1)
    end

    lg.setColor(1, 1, 1)

end

