
local lg = love.graphics
animation_dt = 0

function Distance(ax, ay, bx, by)
    return ((ax - bx) ^ 2 + (ay - by) ^ 2) ^ 0.5
end

function isInBox(l, t, w, h, x, y)
    if x > l and x <= l + w then
        if y > t and y <= t + h then
            return true
        end
    end
end

function drawBackground()

    lg.draw(img.background)

    lg.draw(img.chochin, -2, 110)
    lg.draw(img.chochin, 60, 105)
    lg.draw(img.chochin, 120, 90)
    lg.draw(img.chochin, 180, 70)
    lg.draw(img.chochin, 235, 42)

end