
local lg = love.graphics
local lk = love.keyboard

ghostAI = {}

local function isCatchSukui(__x, __y)
    for i = 1, #sukui_object do
        if sukui_object[i].type == "Controler" then
            local joysticks = love.joystick.getJoysticks()
            for j, joystick in ipairs(joysticks) do
                if joystick:getID() == sukui_object[i].id then
                    if joystick:isDown(sukui_object[i].KeyConfig[3]) and Distance(sukui_object[i].x, sukui_object[i].y, __x, __y) < 25 then
                        return true
                    elseif joystick:isDown(sukui_object[i].KeyConfig[1]) and Distance(sukui_object[i].x, sukui_object[i].y, __x, __y) < 25 then
                        return true
                    end
                end
            end
        elseif sukui_object[i].type == "Keyboard" then
            if lk.isDown("lshift") and Distance(sukui_object[i].x, sukui_object[i].y, __x, __y) < 50 then
                return true
            end
        end
    end
    return false
end

local function runOver(__table)

    if isCatchSukui(__table.x, __table.y) then

        local __minDistance = nil
        local __minsukuiNum = nil

        for i = 1, #sukui_object do
            local __distance = Distance(sukui_object[i].x, sukui_object[i].y, __table.x, __table.y)

            if not __minDistance then
                __minDistance = __distance
                __minsukuiNum = i
            elseif __distance < __minDistance then
                __minDistance = __distance
                __minsukuiNum = i
            end
        end

        __table.state_dt = 0
        __table.dir = math.atan2(__table.y - sukui_object[__minsukuiNum].y, __table.x - sukui_object[__minsukuiNum].x)
        __table.state_time = math.random(5, 20) / 10
        __table.state = "run"

    end

end

local function changeDir(__table)

    local gap = 30 / defaultscale

    function returnRandomRad(a, b)

        return math.rad(math.random((a + 360) * 10, (b + 360) * 10) / 10)
        
    end

    if isInBox(stagesize.l, stagesize.t, gap, gap, __table.x, __table.y) then
        __table.dir = returnRandomRad(0, 90)
    end
    if isInBox(stagesize.l + stagesize.w - gap, stagesize.t, gap, gap, __table.x, __table.y) then
        __table.dir = returnRandomRad(90, 180)
    end
    if isInBox(stagesize.l + stagesize.w - gap, stagesize.t + stagesize.h - gap, gap, gap, __table.x, __table.y) then
        __table.dir = returnRandomRad(-180, -90)
    end
    if isInBox(stagesize.l, stagesize.t + stagesize.h - gap, gap, gap, __table.x, __table.y) then
        __table.dir = returnRandomRad(-90, 0)
    end
    
    if isInBox(stagesize.l + gap, stagesize.t, stagesize.w - gap * 2, gap, __table.x, __table.y) then
        __table.dir = returnRandomRad(0, 180)
    end
    if isInBox(stagesize.l + stagesize.w - gap, stagesize.t + gap, gap, stagesize.h - gap * 2, __table.x, __table.y) then
        local __num = math.random(1, 2) 
        if __num == 1 then
            __table.dir = returnRandomRad(90, 180)
        else
            __table.dir = returnRandomRad(-180, -90)
        end
    end
    if isInBox(stagesize.l + gap, stagesize.t + stagesize.h - gap, stagesize.w - gap * 2, gap, __table.x, __table.y) then
        __table.dir = returnRandomRad(-180, 0)
    end
    if isInBox(stagesize.l, stagesize.t + gap, gap, stagesize.h - gap * 2, __table.x, __table.y) then
        __table.dir = returnRandomRad(-90, 90)
    end

end

local function changestate(__table)

    local gapDir = 40

    if __table.state_dt > __table.state_time then
        __table.state_dt = 0
        __table.dir = __table.dir + math.rad(math.random(gapDir * 20) / 10 - gapDir)
        __table.state_time = math.random(5, 50) / 10
        local __num = math.random(1, 10) 
        if __num == 1 then
            __table.state = __table.state
        elseif __num == 2 then
            __table.state = "move"
        elseif __num == 3 or __num == 4 or __num == 5 then
            __table.state = "move"
        else
            __table.state = "wait"
        end
    end

end

ghostAI.wait = function(__table, dt)

    local speed = 30 / defaultscale
    local cos = math.cos
    local sin = math.sin

    __table.x = __table.x + cos(__table.dir) * speed * dt
    __table.y = __table.y + sin(__table.dir) * speed * dt

    changeDir(__table)
    changestate(__table)
    runOver(__table)
    
end


ghostAI.move = function(__table, dt)

    local speed = 120 / defaultscale
    local cos = math.cos
    local sin = math.sin

    __table.x = __table.x + cos(__table.dir) * speed * dt
    __table.y = __table.y + sin(__table.dir) * speed * dt

    changeDir(__table)
    changestate(__table)
    runOver(__table)
    
end


ghostAI.dash = function(__table, dt)

    local speed = 180 / defaultscale
    local cos = math.cos
    local sin = math.sin

    __table.x = __table.x + cos(__table.dir) * speed * dt
    __table.y = __table.y + sin(__table.dir) * speed * dt

    changeDir(__table)
    changestate(__table)
    runOver(__table)
    
end


ghostAI.run = function(__table, dt)

    local speed = 225 / defaultscale
    local cos = math.cos
    local sin = math.sin

    __table.x = __table.x + cos(__table.dir) * speed * dt
    __table.y = __table.y + sin(__table.dir) * speed * dt

    changeDir(__table)

    if __table.state_dt > __table.state_time then
        __table.state_dt = 0
        __table.dir = __table.dir + math.rad(math.random(2000) / 10 - 100)
        __table.state_time = math.random(20, 40) / 10
        __table.state = "dash"
    end
    
end

function drawGhostAI()
    
    local gap = 10

    lg.setColor(0, 0.8, 0, 0.5)

    lg.rectangle("line", stagesize.l, stagesize.t, gap, gap)
    lg.rectangle("line", stagesize.l + stagesize.w - gap, stagesize.t, gap, gap)
    lg.rectangle("line", stagesize.l + stagesize.w - gap, stagesize.t + stagesize.h - gap, gap, gap)
    lg.rectangle("line", stagesize.l, stagesize.t + stagesize.h - gap, gap, gap)
    
    lg.rectangle("line", stagesize.l + gap, stagesize.t, stagesize.w - gap * 2, gap)
    lg.rectangle("line", stagesize.l + stagesize.w - gap, stagesize.t + gap, gap, stagesize.h - gap * 2)
    lg.rectangle("line", stagesize.l + gap, stagesize.t + stagesize.h - gap, stagesize.w - gap * 2, gap)
    lg.rectangle("line", stagesize.l, stagesize.t + gap, gap, stagesize.h - gap * 2)

    lg.setColor(0.8, 0, 0, 0.8)

    for i = 1, #ghost_object do
        lg.line(ghost_object[i].x, ghost_object[i].y, ghost_object[i].x + 8 * math.cos(ghost_object[i].dir), ghost_object[i].y + 8 * math.sin(ghost_object[i].dir)) 
    end
    
    lg.setColor(1, 1, 1)

end

