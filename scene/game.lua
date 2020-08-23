
--================================================--
--変数
--================================================--

local lg = love.graphics

local game_dt = 0
local game_starttime = 4
local game_finishtime = 0
local overtime = 5
local isStarted = false

local addAnotherGhost = {false, false, false}

local isPlayCount = {false, false, false}

game = {}


--================================================--
--シーンチェンジ
--================================================--

function game.enter()

    scene = STATE_GAME

    local windowWidth, windowHeight = love.window.getMode()
    local gap = 20

    for i = 1, 10 + #player_object * 20 do
        addGhost(stagesize.l + gap + math.random(stagesize.w * 10 - gap * 20) / 10, stagesize.t + gap + math.random(stagesize.h * 10 - gap * 20) / 10)
    end

    game_dt = 0
    isStarted = false
    
    game_finishtime = 40 + #player_object * 10 + game_starttime

    addAnotherGhost = {false, false, false}

    isPlayCount = {false, false, false}
    
end


--================================================--
--シーンチェンジ
--================================================--

function game.back()

end



function game.keypressed(k)

    local the_sukui
    local __i
    
    if sukui_object then
        for i = 1, #sukui_object do
            if sukui_object[i].type == "Keyboard" then
                the_sukui = sukui_object[i]
                __i = i
            end
        end
    end

    if k == "z" then
        picGhost(__i)
    end

end

function game.joystickpressed(j, b)
    
    local __id = j:getID()

    local the_sukui
    local __i
    
    if sukui_object then
        for i = 1, #sukui_object do
            if sukui_object[i].id == __id then
                the_sukui = sukui_object[i]
                __i = i
            end
        end
    end

    if b == the_sukui.KeyConfig[1] then
        picGhost(__i)
    end

end


--================================================--
--更新
--================================================--

function game.update(dt)

    updateGhost(dt)
    updateAnimalGhost(dt)
    updateSukui(dt)
    updateParticle(dt)

    game_dt = game_dt + dt
    if game_dt < game_starttime then
        isStarted = false
        for i = 1, #sukui_object do
            sukui_object[i].movable = false
        end
    else
        if not isStarted then
            isStarted = true
            for i = 1, #sukui_object do
                sukui_object[i].movable = true
            end
            audio.game:play()
        end
    end

    if game_dt > game_finishtime then
        audio.game:stop()
        for i = 1, #sukui_object do
            sukui_object[i].movable = false
        end
        if game_dt > game_finishtime + overtime then
            score.enter()
        end
    end

    for i = 1, 3 do
        if game_dt - game_starttime > (game_finishtime - game_starttime) / 4 * i and not addAnotherGhost[i] then
            audio.addGhost:stop()
            audio.addGhost:play()
            for i = 1, 5 + #player_object * 15 do
                local windowWidth, windowHeight = love.window.getMode()
                local __r = math.random(600) / 10
                local __dir = math.rad(math.random(3600) / 10)
                addGhost(windowWidth / defaultscale / 2 + math.cos(__dir) * __r, windowHeight / defaultscale / 2 + math.sin(__dir) * __r + 20)
            end
            local dobuturei = {"kawauso", "okami", "washi"}
            for i = 1, #player_object + 1 do
                local windowWidth, windowHeight = love.window.getMode()
                local __num = math.random(1, 3)
                local __r = math.random(600) / 10
                local __dir = math.rad(math.random(3600) / 10)
                addAnimalGhost(windowWidth / defaultscale / 2 + math.cos(__dir) * __r, windowHeight / defaultscale / 2 + math.sin(__dir) * __r + 20, dobuturei[__num])
            end
            addAnotherGhost[i] = true
        end
    end
    for i = 1, 3 do
        if game_starttime - i < game_dt and game_starttime - i + 1 > game_dt then
            if not isPlayCount[i] then
                audio.count:stop()
                audio.count:play()
                isPlayCount[i] = true
            end
        end
    end
end


--================================================--
--描画
--================================================--

function game.draw()

    local windowWidth, windowHeight = love.window.getMode()

    lg.setColor(1, 1, 1)

    lg.draw(img.yatai)

    for i = 1, 3 do
        if game_dt - game_starttime < (game_finishtime - game_starttime) / 4 * i and game_dt - game_starttime > (game_finishtime - game_starttime) / 4 * i - 5 then
            lg.setColor(1, 0, 0, (1 - ((game_finishtime - game_starttime) / 4 * i - (game_dt - game_starttime)) / 5) * 0.4)
            lg.circle("fill", windowWidth / defaultscale / 2, windowHeight / defaultscale / 2 + 20, 60)
        end
    end

    lg.setColor(1, 1, 1)

    drawGhost()
    drawAnimalGhost()
    --drawGhostAI()

    drawParticle()

    drawSukui()

    lg.setFont(font.strong)

    for i = 1, #player_object do
        lg.print(player_object[i].Position.."P", stagesize.l + stagesize.w / (#player_object + 1) * i - font.strong:getWidth(player_object[i].Position.."P") - 8, 220)
        lg.draw(img.sukui_icon, stagesize.l + stagesize.w / (#player_object + 1) * i - 6, 220)
        for j = 1, #sukui_object do
            if sukui_object[j].id == player_object[i].id then
                lg.print("*"..sukui_object[j].stock, stagesize.l + stagesize.w / (#player_object + 1) * i - font.strong:getWidth("*"..sukui_object[j].stock) + 24, 220)
            elseif sukui_object[j].id == 0 then
                lg.print("*"..sukui_object[j].stock, stagesize.l + stagesize.w / (#player_object + 1) * i - font.strong:getWidth("*"..sukui_object[j].stock) + 24, 220)
            end
        end
    end
    
    if game_dt < game_starttime then
        lg.setColor(0, 0, 0)
        for i = 1, 8 do
            lg.draw(img.sankaku_down, 40 * (i - 1), windowHeight / defaultscale - game_dt * 350)
        end
        lg.rectangle("fill", 0, - game_dt * 350, windowWidth / defaultscale, windowHeight / defaultscale)
        for i = 1, 3 do
            if game_starttime - i < game_dt and game_starttime - i + 1 > game_dt then
                lg.setFont(font.title)
                lg.setColor(1, 1, 1, game_starttime - i + 1 - game_dt)
                lg.print(i, windowWidth / defaultscale / 2 - font.title:getWidth(i) / 2, windowHeight / defaultscale / 2 - 20)
            end
        end
    elseif game_dt < game_finishtime then
        if game_dt < game_starttime + 1 then
            lg.setFont(font.title)
            lg.setColor(1, 1, 1, (game_starttime + 1 - game_dt) / 2)
            lg.print("Start!", windowWidth / defaultscale / 2 - font.title:getWidth("Start!") / 2, windowHeight / defaultscale / 2 - 20)
        end

        lg.setColor(1, 1, 1)
        lg.setFont(font.strong)
        if addAnotherGhost[3] then
            lg.print("おわりまで", windowWidth / defaultscale / 2 - font.strong:getWidth("おわりまで") / 2, 14)
        else
            lg.print("つぎのウェーブまで", windowWidth / defaultscale / 2 - font.strong:getWidth("つぎのウェーブまで") / 2, 14)
        end
        lg.setFont(font.title)
        local showNum = (game_finishtime - game_starttime) / 4 - (game_dt - game_starttime) % ((game_finishtime - game_starttime) / 4)
        if showNum < 1 then
            showNum = showNum - showNum % 0.1
            lg.print(showNum, windowWidth / defaultscale / 2 - font.strong:getWidth(showNum) / 2 - 4, 31)
        else
            showNum = showNum - showNum % 1
            lg.print(showNum, windowWidth / defaultscale / 2 - font.strong:getWidth(showNum) + 2, 31)
        end
    end

    if game_dt > game_finishtime then
        lg.setColor(0, 0, 0, (game_dt - game_finishtime) / (overtime - 1))
        lg.rectangle("fill", 0, 0, windowWidth / defaultscale, windowHeight / defaultscale)
        lg.setColor(1, 1, 1)
        lg.setFont(font.title)
        lg.print("Finish!", windowWidth / defaultscale / 2 - font.title:getWidth("Finish!") / 2, windowHeight / defaultscale / 2 - 14)
    end

    lg.setColor(1, 1, 1)

end


