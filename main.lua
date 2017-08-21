-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local tapCount = 0

local background = display.newImageRect( "background.png", 360, 570 )
background.x = display.contentCenterX
background.y = display.contentCenterY

local teto = display.newImageRect( "platform.png", 360, 85 )
teto.x = display.contentCenterX
teto.y = display.contentHeight1

local paredeEsquerda = display.newImageRect( "platform.png", 1, 900 )
paredeEsquerda.x = display.contentCenterX-160
paredeEsquerda.y = display.contentHeight1

local paredeDireita = display.newImageRect( "platform.png", 1, 900 )
paredeDireita.x = display.contentCenterX+160
paredeDireita.y = display.contentHeight1

local tapText = display.newText( tapCount, display.contentCenterX, 20, native.systemFont, 40 )

local platform = display.newImageRect( "platform.png", 350, 85 )
platform.x = display.contentCenterX
platform.y = display.contentHeight

local balloon = display.newImageRect( "balloon.png", 112, 112 )
balloon.x = display.contentCenterX
balloon.y = display.contentCenterY
balloon.alpha = 0.8

local physics = require( "physics" )
physics.start()

physics.addBody( platform, "static" )
physics.addBody( balloon, "dynamic", { radius=50, bounce=0.3 } )
physics.addBody( teto, "static" )
physics.addBody( paredeEsquerda, "static" )
physics.addBody( paredeDireita, "static" )

local function pushBalloon()
	balloon:applyLinearImpulse( math.random( -0.76, 0.76 ), -0.75, balloon.x, balloon.y )
	tapCount = tapCount + 1
	tapText.text = tapCount
	
	somarOuSubtrair = math.random( 1, 2 )
	if somarOuSubtrair == 1 then
		balloon.rotation = balloon.rotation + math.random( 10, 60 )
	else
		balloon.rotation = balloon.rotation - math.random( 10, 60 )
	end
end

balloon:addEventListener( "tap", pushBalloon )
