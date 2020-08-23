
--================================================--
--変数
--================================================--

local lg = love.graphics
local lk = love.keyboard

local openingSelectNum = 1
local openingSelectText = {"start", "manual", "quit"}
local openingSelect_dt = 0
local openingSelect_time = 0.2

opening = {}


--================================================--
--シーンチェンジ
--================================================--

function opening.enter()

    scene = STATE_OPENING
    audio.title:play()

end

function opening.keypressed(k)
    if k == "z" then
        if openingSelectNum == 1 then
            playerselect.enter()
        elseif openingSelectNum == 2 then
            manual.enter()
        elseif openingSelectNum == 3 then
            love.event.quit()
        end
    elseif k == "x" then
        if openingSelectNum == 3 then
            love.event.quit()
        else
            openingSelectNum = 3
        end
    end
end

function opening.joystickpressed(j, b)
    if b == 1 then
        if openingSelectNum == 1 then
            playerselect.enter()
        elseif openingSelectNum == 2 then
            manual.enter()
        elseif openingSelectNum == 3 then
            love.event.quit()
        end
    elseif b == 2 then
        if openingSelectNum == 3 then
            love.event.quit()
        else
            openingSelectNum = 3
        end
    end
end


--================================================--
--更新
--================================================--

function opening.update(dt)

    if lk.isDown("up") then
        if openingSelect_dt == 0 then
            if openingSelectNum == 1 then
                openingSelectNum = 3
            else
                openingSelectNum = openingSelectNum - 1
            end
        elseif openingSelect_dt > openingSelect_time then
            if openingSelectNum == 1 then
                openingSelectNum = 3
            else
                openingSelectNum = openingSelectNum - 1
            end
            openingSelect_dt = openingSelect_dt - openingSelect_time
        end
        openingSelect_dt = openingSelect_dt + dt
    elseif lk.isDown("down") then
        if openingSelect_dt == 0 then
            if openingSelectNum == 3 then
                openingSelectNum = 1
            else
                openingSelectNum = openingSelectNum + 1
            end
        elseif openingSelect_dt > openingSelect_time then
            if openingSelectNum == 3 then
                openingSelectNum = 1
            else
                openingSelectNum = openingSelectNum + 1
            end
            openingSelect_dt = openingSelect_dt - openingSelect_time
        end
        openingSelect_dt = openingSelect_dt + dt
    else
        local joysticks = love.joystick.getJoysticks()
        local isPushed = false
        for i, joystick in ipairs(joysticks) do
            local a1, a2 = joystick:getAxes()
            if a2 == -1 then
                if openingSelect_dt == 0 then
                    if openingSelectNum == 1 then
                        openingSelectNum = 3
                    else
                        openingSelectNum = openingSelectNum - 1
                    end
                elseif openingSelect_dt > openingSelect_time then
                    if openingSelectNum == 1 then
                        openingSelectNum = 3
                    else
                        openingSelectNum = openingSelectNum - 1
                    end
                    openingSelect_dt = openingSelect_dt - openingSelect_time
                end
                openingSelect_dt = openingSelect_dt + dt
                isPushed = true
                break
            elseif a2 == 1 then
                if openingSelect_dt == 0 then
                    if openingSelectNum == 3 then
                        openingSelectNum = 1
                    else
                        openingSelectNum = openingSelectNum + 1
                    end
                elseif openingSelect_dt > openingSelect_time then
                    if openingSelectNum == 3 then
                        openingSelectNum = 1
                    else
                        openingSelectNum = openingSelectNum + 1
                    end
                    openingSelect_dt = openingSelect_dt - openingSelect_time
                end
                isPushed = true
                openingSelect_dt = openingSelect_dt + dt
                break
            end
        end
        if not isPushed then
            openingSelect_dt = 0
        end
    end
    
end



--================================================--
--描画
--================================================--

function opening.draw()

    drawBackground()

    local windowWidth, windowHeight = love.window.getMode()

    lg.setFont(font.title)
    lg.print("GHOST", windowWidth / defaultscale / 2 - font.title:getWidth("GHOST") / 2, windowHeight / defaultscale / 2 - 20)
    lg.print("SCOOPING", windowWidth / defaultscale / 2 - font.title:getWidth("SCOOPING") / 2, windowHeight / defaultscale / 2)
    
    lg.setFont(font.strong)
    for i = 1, #openingSelectText do
        lg.print(openingSelectText[i], windowWidth / defaultscale / 2 - font.strong:getWidth(openingSelectText[i]) / 2, windowHeight / defaultscale / 2 + 28 + 12 * i)
    end
    lg.print(">", windowWidth / defaultscale / 2 - font.strong:getWidth(openingSelectText[openingSelectNum]) / 2 - 10, windowHeight / defaultscale / 2 + 28 + 12 * openingSelectNum)
    lg.print("<", windowWidth / defaultscale / 2 + font.strong:getWidth(openingSelectText[openingSelectNum]) / 2 + 2, windowHeight / defaultscale / 2 + 28 + 12 * openingSelectNum)

end

