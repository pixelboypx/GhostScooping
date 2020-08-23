
--================================================--
--変数
--================================================--

local lg = love.graphics

splash = {}

local splash_dt = 0
local opening_time = 5
local show_title = 3.5
local title_time = 4
local toho_time = 1
local splash_mode = 1


--================================================--
--シーンチェンジ
--================================================--

function splash.enter()

    scene = STATE_SPLASH

    splash_dt = 0
    splash_mode = 1

end


--================================================--
--更新
--================================================--

function splash.update(dt)

    splash_dt = splash_dt + dt

    if splash_dt > opening_time then
        opening.enter()
    end
    
end



--================================================--
--描画
--================================================--

function splash.draw()
    
    local windowWidth, windowHeight = love.window.getMode()

    if splash_dt > title_time then
        lg.setColor(1, 1, 1)
        drawBackground()
        lg.setColor(0, 0, 0, 1 - (splash_dt - title_time) / (opening_time - title_time))
        lg.rectangle("fill", 0, 0, windowWidth / defaultscale, windowHeight / defaultscale)
        lg.setColor(1, 1, 1)
        lg.setFont(font.title)
        lg.print("GHOST", windowWidth / defaultscale / 2 - font.title:getWidth("GHOST") / 2, windowHeight / defaultscale / 2 - 20)
        lg.print("SCOOPING", windowWidth / defaultscale / 2 - font.title:getWidth("SCOOPING") / 2, windowHeight / defaultscale / 2)
    elseif  splash_dt > show_title then
        lg.setFont(font.title)
        lg.print("GHOST", windowWidth / defaultscale / 2 - font.title:getWidth("GHOST") / 2, windowHeight / defaultscale / 2 - 20)
        lg.print("SCOOPING", windowWidth / defaultscale / 2 - font.title:getWidth("SCOOPING") / 2, windowHeight / defaultscale / 2)
    elseif  splash_dt > 3 then
    elseif  splash_dt > toho_time then
        lg.setFont(font.title)
        lg.print("ORIGINAL", windowWidth / defaultscale / 2 - font.title:getWidth("ORIGINAL") / 2, windowHeight / defaultscale / 2 - 20)
        lg.print("TOHO PROJECT", windowWidth / defaultscale / 2 - font.title:getWidth("TOHO PROJECT") / 2, windowHeight / defaultscale / 2)
    end


end

