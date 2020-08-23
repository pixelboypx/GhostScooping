
local lg = love.graphics

animalghost_class = {
    type = "",
    x = 0, y = 0,
    state = "wait", state_dt = 0, state_time = 0,
    dir = 0
}

animalghost_object = {}

function addAnimalGhost(__x, __y, __type)

    local insertTable = {}

    for k, v in pairs(animalghost_class) do
        if type(v) == "function" then
            insertTable[k] = v()
        else
            insertTable[k] = v
        end
    end
    
    insertTable.type = __type
    
    insertTable.x = __x
    insertTable.y = __y

    insertTable.dir = math.rad(math.random(3600) / 10 - 180)
    insertTable.state_time = math.random(0, 30) / 10
    
    insertTable.state = "wait"

    table.insert(animalghost_object, insertTable)
    
end

function updateAnimalGhost(dt)

    if animalghost_object[1] then
        for i = 1, #animalghost_object do
            animalghost_object[i].state_dt = animalghost_object[i].state_dt + dt
            ghostAI[animalghost_object[i].state](animalghost_object[i], dt)
        end
    end

end

function drawAnimalGhost()

    if animalghost_object[1] then
        for i = 1, #animalghost_object do
            lg.draw(img[animalghost_object[i].type], animalghost_object[i].x - 8, animalghost_object[i].y - 8)
        end
    end

end