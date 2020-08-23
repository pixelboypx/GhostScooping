
local lg = love.graphics
score = {}

local showScore = {0, 0, 0, 0}
local showScore_isMax = {false, false, false, false}

local score_dt = 0
local score_enddt = 0
local score_starttime = 1

function score.enter()

    scene = STATE_SCORE
    score_dt = 0
    score_enddt = 0

    showScore = {0, 0, 0, 0}
    showScore_isMax = {false, false, false, false}

end

function score.keypressed( k )
    if score_enddt > 3 then
        opening.enter()
    end
end

function score.joystickpressed( j, b )
    if score_enddt > 3 then
        opening.enter()
    end
end

function score.update(dt)

    score_dt = score_dt + dt

    if score_dt > score_starttime then
    
        for i = 1, 4 do
            for j = 1, #player_object do
                if player_object[j].Position == i then
                    for k = 1, #sukui_object do
                        if sukui_object[k].id == player_object[j].id then
                            if sukui_object[k].point > showScore[i] then
                                showScore[i] = showScore[i] + 10
                                audio.count:stop()
                                audio.count:play()
                            else
                                showScore_isMax[i] = true
                            end
                        end
                    end
                end
            end
        end

        for i = 1, 4 do
            if showScore[i] == 0 then
                showScore_isMax[i] = true
            end
        end

        local __count = 0

        for i = 1, 4 do
            if showScore_isMax[i] then
                __count = __count + 1
            end
        end
        
        if __count == 4 then
            score_enddt = score_enddt + dt
        end

    end

end

function score.draw()

    local windowWidth, windowHeight = love.window.getMode()

    local gapW = 100 / defaultscale
    local gapT = 144 / defaultscale
    local gapH = 276 / defaultscale
    local gapMid = 40 / defaultscale

    local selectwidth = (windowWidth / defaultscale - gapW * 2 - gapMid * 3) / 4
    local selectheight = windowHeight / defaultscale - gapH - gapT

    local num = 0
    
    for i = 1, 4 do
        if showScore_isMax[i] then
            num = num + 1
        end
    end

    lg.setColor(1, 1, 1)
    lg.setFont(font.title)
    lg.print("Score", windowWidth / defaultscale / 2 - font.title:getWidth("Score") / 2, 20)

    local player_Num = 0
    
    for i = 1, 4 do
        lg.setFont(font.title)
        lg.print(i.."P", gapW + (gapMid + selectwidth) * (i - 1) + selectwidth / 2 - font.title:getWidth(i.."P") / 2, gapT + 16)
        for j = 1, #player_object do
            if player_object[j].Position == i then
                local characterName = {"orin", "oku", "koishi", "satori"}
                lg.draw(img[characterName[player_object[j].character]], gapW + (gapMid + selectwidth) * (i - 1) + selectwidth / 2 - 32, gapT + 40)
                player_Num = player_Num + 1
                if score_dt > score_starttime then
                    lg.setFont(font.strong)
                    lg.print(showScore[i], gapW + (gapMid + selectwidth) * (i - 1) + selectwidth / 2 - font.strong:getWidth(showScore[i]) / 2, gapT + 104)
                end
            end
        end
    end

    local maxNum = 0
    
    for i = 1, 4 do
        for j = 1, #player_object do
            if player_object[j].Position == i then
                for k = 1, #sukui_object do
                    if sukui_object[k].id == player_object[j].id then
                        if sukui_object[k].point > maxNum then
                            maxNum = sukui_object[k].point
                        end
                    end
                end
            end
        end
    end
    
    for i = 1, 4 do
        for j = 1, #player_object do
            if player_object[j].Position == i then
                for k = 1, #sukui_object do
                    if sukui_object[k].id == player_object[j].id then
                        if sukui_object[k].point == maxNum then
                            
                        end
                    end
                end
            end
        end
    end


end