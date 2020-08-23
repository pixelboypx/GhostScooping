
local lg = love.graphics

particle_class = {
    x = 0, y = 0, type = "", 
    dt = 0, data = nil
}
particle_data = {
    pointRatio = {
        time = 1
    }
}
particle_object = {}

function addParticle(__x, __y, __type, __data)
    local insertTable = {}
    insertTable.x = __x
    insertTable.y = __y
    insertTable.type = __type
    insertTable.dt = 0
    if __data then
        insertTable.data = __data
    end
    table.insert(particle_object, insertTable)
end

function updateParticle(dt)

    local __num = #particle_object

    for i = __num, 1, -1 do
        particle_object[i].dt = particle_object[i].dt + dt
        if particle_object[i].dt > particle_data[particle_object[i].type].time then
            table.remove( particle_object, i )
        end
    end

    for i = 1, #particle_object do
        if particle_object[i].type == "pointRatio" then
        end

    end

end

function drawParticle()
    
    for i = 1, #particle_object do
        if particle_object[i].type == "pointRatio" then
            lg.setFont(font.strong)
            lg.setColor(0.4, 0.3, 1 , (particle_data[particle_object[i].type].time - particle_object[i].dt) /particle_data[particle_object[i].type].time)
            lg.print(particle_object[i].data, particle_object[i].x - font.strong:getWidth(particle_object[i].data) / 2, particle_object[i].y - font.strong:getHeight(particle_object[i].data) / 2)
        end
    end
    lg.setColor(1, 1, 1)

end