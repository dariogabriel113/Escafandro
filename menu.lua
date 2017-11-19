local composer = require( "composer" )

local scene = composer.newScene()
--display.remove(sceneGroup)
local function gotoTimerBasedExample()
	contadorOx = 4
	profundidade = 10
	criar = true
	composer.gotoScene("level1")
end

-- create()
function scene:create( event )

	local sceneGroup = self.view

	alturaTela = display.contentHeight
	larguraTela = display.contentWidth

	local centroX = display.contentCenterX
	local centroY = display.contentCenterY

	local background = display.newImageRect( sceneGroup, "imagens/bgs/back.png", larguraTela, alturaTela+450 )
	background.x = centroX
	background.y = centroY

	local logo = display.newImageRect( sceneGroup, "imagens/title.png", larguraTela, alturaTela/6 )
	logo.x = centroX
	logo.y = centroY-centroY/2

	local timerExampleButton = display.newImageRect( sceneGroup, "imagens/botoes/playbtn.png", larguraTela/2, alturaTela/9)
	timerExampleButton.x = centroX
	timerExampleButton.y = centroY+centroY/2

	local bolhaMediumTop = display.newImageRect( sceneGroup, "imagens/bgs/bubble.png", larguraTela/15, larguraTela/15 )
	bolhaMediumTop.x = centroX-centroX/2
	bolhaMediumTop.y = alturaTela - alturaTela - alturaTela/11

	local bolhaMediumCenterback = display.newImageRect( sceneGroup, "imagens/bgs/bubble.png", larguraTela/15, larguraTela/15 )
	bolhaMediumCenterback.x = larguraTela - larguraTela/5.5
	bolhaMediumCenterback.y = centroX + (centroX/8)/2

	local bolhaMediumCenter = display.newImageRect( sceneGroup, "imagens/bgs/bubble.png", larguraTela/15, larguraTela/15 )
	bolhaMediumCenter.x = larguraTela - larguraTela/5.5
	bolhaMediumCenter.y = centroX + (centroX/8)/2

	local bolhaLargeback = display.newImageRect( sceneGroup, "imagens/bgs/bubble.png", larguraTela/10, larguraTela/10 )
	bolhaLargeback.x = larguraTela - larguraTela/20
	bolhaLargeback.y = (centroX + (centroX/8)/2) + alturaTela/10

	local bolhaLarge = display.newImageRect( sceneGroup, "imagens/bgs/bubble.png", larguraTela/10, larguraTela/10 )
	bolhaLarge.x = larguraTela - larguraTela/20
	bolhaLarge.y = (centroX + (centroX/8)/2) + alturaTela/10

	local bolhaMediumDownback = display.newImageRect( sceneGroup, "imagens/bgs/bubble.png", larguraTela/15, larguraTela/15 )
	bolhaMediumDownback.x = timerExampleButton.contentWidth/2
	bolhaMediumDownback.y = timerExampleButton.y + centroX/5

	local bolhaMediumDown = display.newImageRect( sceneGroup, "imagens/bgs/bubble.png", larguraTela/15, larguraTela/15 )
	bolhaMediumDown.x = timerExampleButton.contentWidth/2
	bolhaMediumDown.y = timerExampleButton.y + centroX/5

	local bolhaSmallback = display.newImageRect( sceneGroup, "imagens/bgs/bubble.png", larguraTela/20, larguraTela/20 )
	bolhaSmallback.x = bolhaMediumDown.x - bolhaMediumDown.x/2 + bolhaMediumDown.x/5
	bolhaSmallback.y = bolhaMediumDown.y + bolhaMediumDown.y/10

	local bolhaSmall = display.newImageRect( sceneGroup, "imagens/bgs/bubble.png", larguraTela/20, larguraTela/20 )
	bolhaSmall.x = bolhaMediumDown.x - bolhaMediumDown.x/2 + bolhaMediumDown.x/5
	bolhaSmall.y = bolhaMediumDown.y + bolhaMediumDown.y/10

	timerExampleButton:addEventListener("tap", gotoTimerBasedExample)
end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
	end
end

-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
