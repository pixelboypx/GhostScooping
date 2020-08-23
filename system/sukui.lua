
local lg = love.graphics
local lk = love.keyboard

local vibration_time = 0.3

local repic_time = 1

sukui_class = {
    durability = {100, 100, 100, 100},
    x = 0, y = 0, type = "",
    isFlont = true,
    vibration_dt = vibration_time,
    movable = true,
    pic_dt = repic_time,
    KeyConfig = {1, 2, 3, 4},
    innerR = 8, outerR = 16,
    hp = 100, stock = 5,
    point = 0,
    damage = 5, getPointRatio = 1,
}

sukui_object = {}

function addSukui(__x, __y, __id, __type)

    insertTable = {}

    for k, v in pairs(sukui_class) do
        if type(v) == "function" then
            insertTable[k] = v()
        else
            insertTable[k] = v
        end
    end
    
    insertTable.x = __x
    insertTable.y = __y
    insertTable.id = __id
    insertTable.type = __type
    
    insertTable.washi = {state = false, dt = 0, time = 0}
    insertTable.okami = {state = false, dt = 0, time = 0}
    insertTable.kawauso = {state = false, dt = 0, time = 0}

    table.insert(sukui_object, insertTable)

    if __type == "Controler" then
        print("addSukui ID : "..__id)
    elseif __type == "Keyboard" then
        print("addSukui ID : 0")
    end

end

function picGhost(i)

    if sukui_object[i].pic_dt > repic_time and sukui_object[i].movable and sukui_object[i].hp > 0 then

        audio.pic:stop()
        audio.pic:play()

        sukui_object[i].pic_dt = 0

        local count = 0

        local __n = #ghost_object

        for j = __n, 1, -1 do
            if Distance(sukui_object[i].x, sukui_object[i].y, ghost_object[j].x, ghost_object[j].y) < sukui_object[i].innerR then
                sukui_object[i].hp = sukui_object[i].hp - sukui_object[i].damage * 8
                table.remove(ghost_object, j)
                count = count + 1
            elseif Distance(sukui_object[i].x, sukui_object[i].y, ghost_object[j].x, ghost_object[j].y) < sukui_object[i].outerR then
                sukui_object[i].hp = sukui_object[i].hp - sukui_object[i].damage
                table.remove(ghost_object, j)
                count = count + 1
            end
        end
        
        local __n = #animalghost_object

        if animalghost_object[1] then
            for j = __n, 1, -1 do
                if Distance(sukui_object[i].x, sukui_object[i].y, animalghost_object[j].x, animalghost_object[j].y) < sukui_object[i].innerR then
                    if animalghost_object[j].type == "washi" then
                        sukui_object[i].washi.state = true
                        sukui_object[i].washi.time = sukui_object[i].washi.time + 10
                    elseif animalghost_object[j].type == "okami" then
                        sukui_object[i].okami.state = true
                        sukui_object[i].okami.time = sukui_object[i].okami.time + 10
                    elseif animalghost_object[j].type == "kawauso" then
                        sukui_object[i].kawauso.state = true
                        sukui_object[i].kawauso.time = sukui_object[i].kawauso.time + 10
                    end
                    sukui_object[i].hp = sukui_object[i].hp - sukui_object[i].damage * 8
                    table.remove(animalghost_object, j)
                    count = count + 1
                elseif Distance(sukui_object[i].x, sukui_object[i].y, animalghost_object[j].x, animalghost_object[j].y) < sukui_object[i].outerR then
                    if animalghost_object[j].type == "washi" then
                        sukui_object[i].washi.state = true
                        sukui_object[i].washi.time = sukui_object[i].washi.time + 10
                    elseif animalghost_object[j].type == "okami" then
                        sukui_object[i].okami.state = true
                        sukui_object[i].okami.time = sukui_object[i].okami.time + 10
                    elseif animalghost_object[j].type == "kawauso" then
                        sukui_object[i].kawauso.state = true
                        sukui_object[i].kawauso.time = sukui_object[i].kawauso.time + 10
                    end
                    sukui_object[i].hp = sukui_object[i].hp - sukui_object[i].damage
                    table.remove(animalghost_object, j)
                    count = count + 1
                end
            end
        end

        local givePoint = 100

        if count == 1 then
            sukui_object[i].point = sukui_object[i].point + 100 * sukui_object[i].getPointRatio
            if sukui_object[i].okami.state then
                addParticle(sukui_object[i].x + math.random(300) / 10 - 15, sukui_object[i].y + math.random(300) / 10 - 15, "pointRatio", "*2.0")
            end
        elseif count > 1 then
            sukui_object[i].point = sukui_object[i].point + 100 * count * (1 + count * 0.1) * sukui_object[i].getPointRatio
            addParticle(sukui_object[i].x + math.random(300) / 10 - 15, sukui_object[i].y + math.random(300) / 10 - 15, "pointRatio", "*"..tostring(1 + count * 0.1))
            if sukui_object[i].okami.state then
                addParticle(sukui_object[i].x + math.random(300) / 10 - 15, sukui_object[i].y + math.random(300) / 10 - 15, "pointRatio", "*2.0")
            end
        end

    end
    
end

function updateSukui(dt)

    if lk.isDown("up", "down", "left", "right", "w", "a", "s", "d") then
        for j = 1, #sukui_object do
            if sukui_object[j].id == 0 and sukui_object[j].movable then
    
                local speed = 400 / defaultscale
 
                if lk.isDown("lshift", "rshift") then
                    speed = speed * 0.5
                end

                if lk.isDown("up", "w") then
                    if lk.isDown("left", "a") then
                        sukui_object[j].x = sukui_object[j].x - speed / 2 ^ 0.5 * dt
                        sukui_object[j].y = sukui_object[j].y - speed / 2 ^ 0.5 * dt
                    elseif lk.isDown("right", "d") then
                        sukui_object[j].x = sukui_object[j].x + speed / 2 ^ 0.5 * dt
                        sukui_object[j].y = sukui_object[j].y - speed / 2 ^ 0.5 * dt
                    else
                        sukui_object[j].y = sukui_object[j].y - speed * dt
                    end
                elseif lk.isDown("down", "s") then
                    if lk.isDown("left", "a") then
                        sukui_object[j].x = sukui_object[j].x - speed / 2 ^ 0.5 * dt
                        sukui_object[j].y = sukui_object[j].y + speed / 2 ^ 0.5 * dt
                    elseif lk.isDown("right", "d") then
                        sukui_object[j].x = sukui_object[j].x + speed / 2 ^ 0.5 * dt
                        sukui_object[j].y = sukui_object[j].y + speed / 2 ^ 0.5 * dt
                    else
                        sukui_object[j].y = sukui_object[j].y + speed * dt
                    end
                elseif lk.isDown("left", "a") then
                    sukui_object[j].x = sukui_object[j].x - speed * dt
                elseif lk.isDown("right", "d") then
                    sukui_object[j].x = sukui_object[j].x + speed * dt
                end

                break

            end
        end
    end

    local joysticks = love.joystick.getJoysticks()
    for i, joystick in ipairs(joysticks) do
        for j = 1, #sukui_object do
            if sukui_object[j].id == joystick:getID() and sukui_object[j].movable then
    
                local speed = 400 / defaultscale

                if joystick:isDown(sukui_object[j].KeyConfig[3]) then speed = speed * 0.5 end

                local n1, n2 = joystick:getAxes()
                if n1 ~= 0 or n2 ~= 0 then
                    local dir = math.atan2(n2, n1)
                    local cos = math.cos
                    local sin = math.sin
                    sukui_object[j].x = sukui_object[j].x + cos(dir) * speed * dt
                    sukui_object[j].y = sukui_object[j].y + sin(dir) * speed * dt
                end

            end
        end
    end

    for j = 1, #sukui_object do
        local windowWidth, windowHeight = love.window.getMode()
        local gap = 30
        if not isInBox(-gap, -gap, windowWidth / defaultscale + gap * 2, windowHeight / defaultscale + gap * 2, sukui_object[j].x, sukui_object[j].y) then
            sukui_object[j].x = stagesize.l + stagesize.w / (#sukui_object + 1) * j
            sukui_object[j].y = 200
            sukui_object[j].vibration_dt = 0
        end

        local joysticks = love.joystick.getJoysticks()
        for i, joystick in ipairs(joysticks) do
            local __id = joystick:getID()
            if __id == sukui_object[j].id then
                if sukui_object[j].vibration_dt < vibration_time then
                    joystick:setVibration(0.6, 0.6)
                    sukui_object[j].vibration_dt = sukui_object[j].vibration_dt + dt
                    sukui_object[j].movable = false
                else
                    joystick:setVibration()
                    sukui_object[j].movable = true
                end
            end
        end
        if sukui_object[j].type == "Keyboard" then
            if sukui_object[j].vibration_dt < vibration_time then
                sukui_object[j].vibration_dt = sukui_object[j].vibration_dt + dt
                sukui_object[j].movable = false
            else
                sukui_object[j].movable = true
            end
        end

        sukui_object[j].pic_dt = sukui_object[j].pic_dt + dt

        if sukui_object[j].washi.state then
            sukui_object[j].washi.dt = sukui_object[j].washi.dt + dt
            if sukui_object[j].washi.dt > sukui_object[j].washi.time then
                sukui_object[j].washi.state = false
                sukui_object[j].washi.dt = 0
            end
        end
        if sukui_object[j].okami.state then
            sukui_object[j].okami.dt = sukui_object[j].okami.dt + dt
            if sukui_object[j].okami.dt > sukui_object[j].okami.time then
                sukui_object[j].okami.state = false
                sukui_object[j].okami.dt = 0
            end
        end
        if sukui_object[j].kawauso.state then
            sukui_object[j].kawauso.dt = sukui_object[j].kawauso.dt + dt
            if sukui_object[j].kawauso.dt > sukui_object[j].kawauso.time then
                sukui_object[j].kawauso.state = false
                sukui_object[j].kawauso.dt = 0
            end
        end

        if sukui_object[j].washi.state then
            sukui_object[j].outerR = sukui_class.outerR * 2
        else
            sukui_object[j].outerR = sukui_class.outerR
        end
        if sukui_object[j].okami.state then
            sukui_object[j].getPointRatio = sukui_class.getPointRatio * 2
        else
            sukui_object[j].getPointRatio = sukui_class.getPointRatio
        end
        if sukui_object[j].kawauso.state then
            sukui_object[j].damage = sukui_class.damage / 2
        else
            sukui_object[j].damage = sukui_class.damage
        end

        if sukui_object[j].hp <= 0 then
            if sukui_object[j].stock > 0 then
                sukui_object[j].stock = sukui_object[j].stock - 1
                sukui_object[j].hp = 100
            else
                sukui_object[j].hp = 0
            end
        end
            
    end
        
end

function drawSukui()

    for i = 1, #sukui_object do
        if sukui_object[i].washi.state then
            if sukui_object[i].hp > 75 then
                lg.draw(img["maku_1"], sukui_object[i].x - 32, sukui_object[i].y - 32, 0, 2)
            elseif sukui_object[i].hp > 50 then
                lg.draw(img["maku_2"], sukui_object[i].x - 32, sukui_object[i].y - 32, 0, 2)
            elseif sukui_object[i].hp > 25 then
                lg.draw(img["maku_3"], sukui_object[i].x - 32, sukui_object[i].y - 32, 0, 2)
            elseif sukui_object[i].hp > 0 then
                lg.draw(img["maku_4"], sukui_object[i].x - 32, sukui_object[i].y - 32, 0, 2)
            end
            lg.draw(img["sukui_"..i], sukui_object[i].x - 32, sukui_object[i].y - 32, 0, 2)
        else
            if sukui_object[i].hp > 75 then
                lg.draw(img["maku_1"], sukui_object[i].x - 16, sukui_object[i].y - 16)
            elseif sukui_object[i].hp > 50 then
                lg.draw(img["maku_2"], sukui_object[i].x - 16, sukui_object[i].y - 16)
            elseif sukui_object[i].hp > 25 then
                lg.draw(img["maku_3"], sukui_object[i].x - 16, sukui_object[i].y - 16)
            elseif sukui_object[i].hp > 0 then
                lg.draw(img["maku_4"], sukui_object[i].x - 16, sukui_object[i].y - 16)
            end
            lg.draw(img["sukui_"..i], sukui_object[i].x - 16, sukui_object[i].y - 16)
        end
        --lg.print(sukui_object[i].id, sukui_object[i].x, sukui_object[i].y + 5)

        if sukui_object[i].pic_dt < repic_time then
            lg.setColor(1, 1, 1)
            local __w = 20
            lg.rectangle("fill", sukui_object[i].x - (repic_time - sukui_object[i].pic_dt) / repic_time * __w, sukui_object[i].y + 20, (repic_time - sukui_object[i].pic_dt) / repic_time * __w, 2)
            lg.rectangle("fill", sukui_object[i].x, sukui_object[i].y + 20, (repic_time - sukui_object[i].pic_dt) / repic_time * __w, 2)
        end
    end
    
end

