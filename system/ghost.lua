
local lg = love.graphics

ghost_class = {
    x = 0, y = 0,
    state = "", state_dt = 0, state_time = 0,
    dir = 0
}

ghost_object = {}

function addGhost(__x, __y)

    local insertTable = {}

    for k, v in pairs(ghost_class) do
        if type(v) == "function" then
            insertTable[k] = v()
        else
            insertTable[k] = v
        end
    end
    
    insertTable.x = __x
    insertTable.y = __y

    insertTable.dir = math.rad(math.random(3600) / 10 - 180)
    insertTable.state_time = math.random(0, 30) / 10
    
    insertTable.state = "wait"

    table.insert(ghost_object, insertTable)
    
end

function updateGhost(dt)

    local function orderY(a, b)
        return a.y < b.y
    end

    table.sort(ghost_object, orderY)

    if ghost_object[1] then
        for i = 1, #ghost_object do
            ghost_object[i].state_dt = ghost_object[i].state_dt + dt
            ghostAI[ghost_object[i].state](ghost_object[i], dt)
        end
    end
    
end

function drawGhost()

    if ghost_object[1] then
        local rad = math.rad
        for i = 1, #ghost_object do
            local __dir = ghost_object[i].dir % math.rad(360)
            if __dir > rad(90) and rad(270) > __dir then
                lg.draw(img.ghost_r, ghost_object[i].x - 8, ghost_object[i].y - 8)
            else
                lg.draw(img.ghost_l, ghost_object[i].x - 8, ghost_object[i].y - 8)
            end
        end
    end
    
end