-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local background = display.newImageRect( "background.png", 360, 570 )
background.x = display.contentCenterX
background.y = display.contentCenterY

local escafandro = display.newImageRect( "escafandro.png", 112, 112 )
escafandro.x = display.contentCenterX
escafandro.y = display.contentCenterY
escafandro.alpha = 0.8

local paredeEsquerda = display.newImageRect( "platform.png", 1, 900 )
paredeEsquerda.x = display.contentCenterX-160
paredeEsquerda.y = display.contentHeight1

local paredeDireita = display.newImageRect( "platform.png", 1, 900 )
paredeDireita.x = display.contentCenterX+160
paredeDireita.y = display.contentHeight1

local platform = display.newImageRect( "platform.png", 350, 85 )
platform.x = display.contentCenterX
platform.y = display.contentHeight



local physics = require( "physics" )
physics.start()

physics.addBody( escafandro, "dynamic", { radius=50, bounce=0.0 } )
physics.addBody( paredeEsquerda, "static" )
physics.addBody( paredeDireita, "static" )
physics.addBody( platform, "static" )


local function pushMan()
  escafandro:applyLinearImpulse( math.random( -0.76, 0.76 ), -0.75, escafandro.x, escafandro.y )
end

escafandro:addEventListener( "tap", pushMan )
