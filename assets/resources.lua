
local lg = love.graphics
local la = love.audio

imgNameTable = {
    "orin", "oku", "koishi", "satori",
    "orin_2", "oku_2", "koishi_2", "satori_2",
    "sankaku_up", "sankaku_down",
    "background", "chochin",
    "back",
    "sukui_1", "sukui_2", "sukui_3", "sukui_4",
    "maku_1", "maku_2", "maku_3", "maku_4",
    "ghost_l", "ghost_r",
    "yatai",
    "okami", "washi", "kawauso",
    "sukui_icon"
}
fontNameTable = {
    text = "k8x12S",
    strong = {"x8y12pxTheStrongGamer", 12},
    title = {"x14y20pxScoreDozer", 20},
}
audioNameTable = {
    "count", "title", "game", "addGhost", "pic"
}

img = {}
font = {}
audio = {}

local function readImage(__name)
    img[__name] = lg.newImage("assets/img/"..tostring(__name)..".png")
end

function loadResources()

    for i = 1, #imgNameTable do
        readImage(imgNameTable[i])
    end

    for k, v in pairs(fontNameTable) do
        if type(v) == "table" then
            font[k] = lg.newFont("assets/fonts/"..v[1]..".ttf", v[2])
        else
            font[k] = lg.newFont("assets/fonts/"..v..".ttf")
        end
    end

    for i = 1, #audioNameTable do
        audio[audioNameTable[i]] = la.newSource("assets/audio/"..audioNameTable[i]..".ogg", "static")
    end
    audio.title:setLooping(true)
    audio.game:setLooping(true)

end