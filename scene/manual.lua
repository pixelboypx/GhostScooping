
local lg = love.graphics

manual = {}

function manual.enter()
    scene = STATE_MANUAL
end

function manual.keypressed( k )
    if k then
        opening.enter()
    end
end

function manual.joystickpressed( j, b )
    if b then
        opening.enter()
    end
end

function manual.update( dt )
    
end

function manual.draw()

    drawBackground()

    lg.setFont(font.strong)
    lg.print("あらすじ\n　ちていのまつりではきんぎょすくいならぬゆうれいすくいがおこなわれていた!\n　どうやらどうぶつれいもまぎれこんでいるらしい…", 10, 10)
    lg.print("そうさ\n　いどう　:　じゅうじキー or スティックにゅうりょく\n　すくう　:　Zキー or Aボタン\n　ていそく　:　Shiftキー or Xボタン", 10, 50)
    lg.print("システム\n　ゆうれいをすくいですくおう！\n　どうじにたくさんゆうれいをすくうとポイントアップ！\n　すくいのまんなかですくうとすくいがかなりきずつくぞ！\n　オオカミれいをすくうとすくいでとれるとくてんが２ばい！\n　オオワシれいをすくうとすくいのおおきさが２ばい！\n　カワウソれいをすくうとすくいのたいきゅうちが２ばい！", 10, 106)
    
end