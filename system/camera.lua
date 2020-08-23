
defaultscale = 4

function createCamera()

    local windowWidth, windowHeight = love.window.getMode()

    cam = gamera.new(0, 0, windowWidth / defaultscale, windowHeight / defaultscale)
    cam:setWindow(0, 0, windowWidth, windowHeight)
    cam:setScale(defaultscale)

end