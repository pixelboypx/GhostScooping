
local lg = love.graphics

require("system/import")

STATE_SPLASH,
STATE_OPENING,
STATE_MANUAL,
STATE_PLAYERSELECT,
STATE_PREGAME,
STATE_GAME,
STATE_SCORE
= 1, 2, 3, 4, 5, 6, 7

scenestate = {
    splash,
    opening,
    manual,
    playerselect,
    pregame,
    game,
    score
}


--================================================--
--初期読み込み
--================================================--

function love.load()

    love.graphics.setDefaultFilter("nearest", "nearest", 1)
    math.randomseed(os.time())
    love.mouse.setVisible(false)

    loadResources()

    local joysticks = love.joystick.getJoysticks()
    for i, joystick in ipairs(joysticks) do
        print(joystick:getName())
    end

    setstagesize()
    createCamera()

    splash.enter()

end


--================================================--
--更新
--================================================--

function love.keypressed(k)

    if scenestate[scene].keypressed then
        scenestate[scene].keypressed(k)
    end

end


--================================================--
--更新
--================================================--

function love.joystickpressed(j, b)

    if scenestate[scene].joystickpressed then
        scenestate[scene].joystickpressed(j, b)
    end

end


--================================================--
--更新
--================================================--

function love.update(dt)

    scenestate[scene].update(dt)

    animation_dt = animation_dt + dt

end


--================================================--
--描画
--================================================--

function love.draw()

    cam:draw(function(l,t,w,h)
        scenestate[scene].draw()
    end)
    lg.setFont(font.text)
    lg.print("fps : "..love.timer.getFPS(), lg.getWidth() - 100, lg.getHeight() - 50)

end


