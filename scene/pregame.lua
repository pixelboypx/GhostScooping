
local lg = love.graphics

pregame = {}

local characterName = {"orin", "oku", "koishi", "satori"}

local pregame_dt = 0
local pregame_time = 0.6
local scroll_time = 0.8
local gamestart_time = 2

function pregame.enter()
    scene = STATE_PREGAME
    pregame_dt = 0
end

function pregame.update(dt)

    pregame_dt = pregame_dt + dt

    if pregame_dt > gamestart_time then
        for i = 1, #player_object do
            if player_object[i].type == "Keyboard" then
                addSukui(stagesize.l + stagesize.w / (#player_object + 1) * i, 200, 0, "Keyboard")
            elseif player_object[i].type == "Controler" then
                addSukui(stagesize.l + stagesize.w / (#player_object + 1) * i, 200, player_object[i].id, "Controler")
            end
            sukui_object[#sukui_object].KeyConfig = player_object[i].KeyConfig
        end
        audio.title:stop()
        game.enter()
    end

end

function pregame.draw()

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
                    hasPlayer = true
                    player_Num = player_Num + 1
                end
            end
        end
        if not hasPlayer then
            lg.setColor(1, 1, 1, 0.3)
            lg.rectangle("fill", gapW + (gapMid + selectwidth) * (i - 1), gapT, selectwidth, selectheight)
        end
        lg.setColor(1, 1, 1)
        lg.setFont(font.title)
        lg.print(i.."P", gapW + (gapMid + selectwidth) * (i - 1) + selectwidth / 2 - font.title:getWidth(i.."P") / 2, gapT + 8)
    end

    lg.setColor(1, 1, 1, 0.6)
    lg.arc("line", "open", windowWidth / defaultscale / 2, gapT + selectheight + 33, 15, math.rad(-90), math.rad(startNum * 360 / player_Num / 5 - 90), 100)
    lg.setColor(1, 1, 1)
    lg.setFont(font.strong)
    lg.print("ボタンをおしてスタート", gapW + gapMid + selectwidth + 22, gapT + selectheight + 25)
    if pregame_dt < pregame_time then
        lg.setColor(1, 1, 1, ((pregame_time - pregame_dt) / pregame_time) ^ 2)
        local scaleratio = 16
        lg.print(
            "ボタンをおしてスタート",
            gapW + gapMid + selectwidth + 22 - 8 * 11 / 2 * (1 + pregame_dt * scaleratio) + 8 * 11 / 2,
            gapT + selectheight + 25 - 12 / 2 * (1 + pregame_dt * scaleratio),
            0,
            1 + pregame_dt * scaleratio
        )
    end

    if pregame_dt > scroll_time then
        lg.setColor(0, 0, 0)
        for i = 1, 8 do
            lg.draw(img.sankaku_up, 40 * (i - 1), windowHeight / defaultscale - (pregame_dt - scroll_time) * 350)
        end
        lg.rectangle("fill", 0, windowHeight / defaultscale - (pregame_dt - scroll_time) * 350 + 40, windowWidth / defaultscale, 2000)
    end

    for i = 1, 4 do
        local hasPlayer = false
        if player_object then
            for j = 1, #player_object do
                if player_object[j].Position == i then
                    local gapY = 0
                    local speed = 10000
                    if pregame_dt < gamestart_time / 5 then
                        gapY = gapY + ((gamestart_time / 5 - pregame_dt) / gamestart_time / 5) ^ 2 * speed
                    else
                        gapY = gapY + ((gamestart_time / 5 - pregame_dt) / gamestart_time / 5) ^ 2 * speed
                    end
                    lg.setColor(1, 1, 1)
                    lg.draw(img[characterName[player_object[j].character].."_2"], gapW + (gapMid + selectwidth) * (i - 1) + selectwidth / 2 - 32, gapT + 20 + gapY)
                end
            end
        end
    end

    lg.setColor(1, 1, 1)

end