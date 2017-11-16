local composer = require( "composer" )

local scene = composer.newScene()

local function gotoTimerMenu()
	composer.gotoScene("menu")
end
local larguraTela = display.contentWidth
local alturaTela = display.contentHeight
-- create()
function scene:create( event )

	local sceneGroup = self.view

	local centroX = display.contentCenterX
	local centroY = display.contentCenterY

	local background = display.newImageRect( sceneGroup, "imagens/bgs/back.png", larguraTela, alturaTela+450 )
	background.x = centroX
	background.y = centroY

	local fimDeJogoImg = display.newImageRect( sceneGroup, "imagens/bgs/endgame.png", larguraTela/2 + larguraTela/5, alturaTela/3 )
	fimDeJogoImg.x = centroX
	fimDeJogoImg.y = alturaTela/4

	local profundidadeTexto = display.newText(sceneGroup, "PROFUNDIDADE ATINGIDA", centroX, centroY + centroY/3, native.systemFont, 44)
	local profundidadeTotal = display.newText(sceneGroup, profundidade, centroX, centroY + centroY/2, native.systemFont, 44)
	local m = display.newText(sceneGroup, "m", profundidadeTotal.x + profundidadeTotal.contentWidth, centroY + centroY/2, native.systemFont, 44)

	local timerExampleButtonMenu = display.newImageRect( sceneGroup, "imagens/botoes/backbtn.png", larguraTela/2 + larguraTela/5, alturaTela/9)
	timerExampleButtonMenu.x = centroX
	timerExampleButtonMenu.y = alturaTela

	timerExampleButtonMenu:addEventListener("tap", gotoTimerMenu)

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
