
function setstagesize()

    local windowWidth, windowHeight = love.window.getMode()
    local gap = 60 / defaultscale

    stagesize = {
        l = gap, t = 250 / defaultscale,
        w = windowWidth / defaultscale - gap * 2, h = windowHeight / defaultscale - 400 / defaultscale
    }

end