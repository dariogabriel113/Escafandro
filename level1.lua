local composer = require( "composer" )

local scene = composer.newScene()
composer.recycleOnSceneChange = true

local physics = require("physics")
physics.start()
physics.setGravity(0, 0)

alturaTela = display.contentHeight
larguraTela = display.contentWidth
local centroX = display.contentCenterX
local centroY = display.contentCenterY
criar = true
profundidade = 10
contadorOx = 4
msmProfundidade = 0

--------------------------------------------------------------------------------------
-- VIRTUAL CONTROLLER CODE
--------------------------------------------------------------------------------------
-- This section contains everything you need to create and display the controller
-- This isn't the best place to have all of this code, but I wanted to keep it all
-- in one place so you can find it easily
-- setupController gets called in scene:create()
--------------------------------------------------------------------------------------

-- This line brings in the controller which basically acts like a class
local factory = require("controller.virtual_controller_factory")
local controller = factory:newController()

-- This enables both joysticks to be used at the same time. All of the code to make
-- sure that touch events are handled by the correct joystick is encased in the controller
-- so you don't have to worry about that.
system.activate("multitouch")

-- These are variables to hold the joysticks so that I can
-- use them in a timer later on

local joystick1
local joystick2

local function setupController(displayGroup)
	local joystick1Properties = {
		nToCRatio = 0.5,
		radius = 80,
		x = centroX - (centroX/2 + centroX/15),
		y = alturaTela + alturaTela/35,
		restingXValue = 0,
		restingYValue = 0,
		rangeX = 300,
		rangeY = 300
	}

	local joystick1Name = "joystick1"
	joystick1 = controller:addJoystick(joystick1Name, joystick1Properties)

	local joystick2Properties = {
		nToCRatio = 0.5,
		radius = 80,
		x = larguraTela - 166,
		y = alturaTela + 30,
		restingXValue = 0,
		restingYValue = 0,
		rangeX = 600,
		rangeY = 600
	}

	--print(joystick2Properties.x)
  --print(joystick2Properties.y)

	local joystick2Name = "joystick2"
	joystick2 = controller:addJoystick(joystick2Name, joystick2Properties)

	controller:displayController(displayGroup)

end

----------------------------------------------------------------------------------------
-- END VIRTUAL CONTROLLER CODE
----------------------------------------------------------------------------------------

--------------------------------------------------------------------
centroX = display.contentCenterX
centroY = display.contentCenterY

local enemyTable = {}
maxEnemies = 5

local died = false

local backGroup
local mainGroup
local uiGroup
-----------------------------------------------------------------
parar = 1
-----------------------------------------------------------------
local function createEnemy()
	if(parar == 1) then
		if(#enemyTable == maxEnemies) then
			return true
		end

		local enemyEscolhido

		imgEnemy = math.random(1, 3)

		if (imgEnemy == 1) then
			enemyEscolhido = "imagens/inimigos/purple_octopus.png"
		elseif (imgEnemy == 2) then
			enemyEscolhido = "imagens/inimigos/pink_octopus.png"
		elseif (imgEnemy == 3) then
			enemyEscolhido = "imagens/inimigos/orange_octopus.png"
		end

		local newenemy = display.newImageRect(mainGroup, enemyEscolhido , 100, 100)


		table.insert(enemyTable, newenemy)
		physics.addBody(newenemy, "dynamic", {width = 40, height = 40, bounce = 0.8})
		newenemy.myName = "enemy"

		newenemy.y = alturaTela+(alturaTela/4)
		newenemy.x = math.random(0, (larguraTela))
		newenemy.isFixedRotation = true
		newenemy:setLinearVelocity(0, math.random(2, 6))
	end
end
------------------
-------------------------------------------------------------------------------
local function createOxi()
	if(criar == true) then
		oxigenio = display.newImageRect(mainGroup, "imagens/bgs/vida.png", 100, 100)
		physics.addBody(oxigenio, "dynamic", {isSensor = true, width = 40, height = 40, bounce = 0.8})
		oxigenio.myName = "oxigenio"

		oxigenio.y = centroX
		oxigenio.x = centroY
		oxigenio.isFixedRotation = true
	end
end
-----------------------------------------------------------------
local function setupjoystick1()
	movementTimer = timer.performWithDelay(100, movePlayer, 0)
end
-----------------------------------------------------------------

------------------------------------------------------------------
function movePlayer()
	local coords = joystick1:getXYValues()
	player:setLinearVelocity(coords.x, coords.y)
end
---------------------------------------------------------------------

-----------------------------------------------------------------------
local function setupGun()
	fireTimer = timer.performWithDelay(300, fireSinglebullet, 0)
end
-----------------------------------------------------------------------

--------------------------------------------------------------------
function fireSinglebullet()
	local pos = joystick2:getXYValues()
	if(pos.x == 0 and pos.y == 0) then
		return true
	end

	local newbullet = display.newCircle(mainGroup, player.x, player.y, 5)
	physics.addBody(newbullet, "dynamic", {isSensor = true})
	newbullet.isBullet = true
	newbullet.myName = "bullet"

	newbullet:toBack()

	transition.to(newbullet, {x = player.x + pos.x, y = player.y + pos.y, time = 500,
		onComplete = function() display.remove( newbullet ) end
	})

	return true
end
--------------------------------------------------------------------------------------
local function moveInimigos( event )
	for i = #enemyTable, 1, -1 do
		local en = enemyTable[i]

		if(en.y + en.contentHeight < -100) then
			en.y = alturaTela + (alturaTela/4)
			en.x = math.random(((larguraTela - larguraTela) + en.contentWidth + (en.contentWidth/2)), (larguraTela - en.contentWidth - (en.contentWidth/2)))
		else
			en.y = en.y - 10
			randomEsqDir = math.random(1, 2)
			if(en.x <= (larguraTela - larguraTela) + en.contentWidth + (en.contentWidth/2)) then
				en.x = en.x + 7
			elseif(en.x >= (larguraTela - en.contentWidth - (en.contentWidth/2))) then
				en.x = en.x - 7
			elseif (randomEsqDir == 1) then
				en.x = en.x - 7
			else
				en.x = en.x + 7
			end
		end

		transition.to( en[4], { time=1500, x=(player.x), y=(player.y) } )
	end
end
-------------------------------------------------------------------------------------------------------
local function moveOxigenio( event )
	for i = 0, 4 do
		if (oxigenio.y + oxigenio.contentHeight < 0) then
			oxigenio.y = alturaTela + oxigenio.contentHeight
			--oxigenio.x = math.random((larguraTela - larguraTela + oxigenio.contentWidth), (larguraTela+ oxigenio.contentWidth))
			oxigenio.x = centroX
		else
			oxigenio.y = oxigenio.y - 1
		end
	end
end
-----------------------------------------------------------------------------------
local function gameLoop()
	if(parar == 1) then
		createEnemy()
	end

	for i = #enemyTable, 1, -1 do
		local en = enemyTable[i]

		if(en.x < larguraTela - larguraTela or en.x > larguraTela
			or en.y < -700 or en.y > display.contentHeight + 500) then

			display.remove(en)
			table.remove(enemyTable, i)
		end
		if(parar == 0) then
			if(en.x < -500 or en.x > display.contentWidth + 500
				or en.y < -700 or en.y > display.contentHeight + 500) then
				display.remove(en)
				table.remove(enemyTable, i)
			end
		end
	end
end
-------------------------------------------------------------------------------------
contadorVida = 4
local function vida( event )

  if (player.y < (alturaTela - alturaTela) - 200) then
    player.y = alturaTela - alturaTela
    contadorVida = contadorVida-1
  end
	if (contadorVida == 3) then
		hp4.alpha = 0
	end

	if (contadorVida == 2) then
		hp3.alpha = 0
	end

	if (contadorVida == 1) then
		hp2.alpha = 0
	end
end

local function oxi( event )
	passe = false
	
	if(profundidade == 15) then
		profundidade = 15
		contadorOx = 4
	end
	
	if (profundidade ~= msmProfundidade and profundidade == 20 or profundidade == 40 or profundidade == 60 or profundidade == 80 or profundidade == 100 or profundidade%105 == 0) then
		print("chamando decremento")
		print(profundidade)
		if(contadorOx >= 0) then
			if(contadorOx == 4 and passe == false) then
				contadorOx = 3
				print("contadorOx = 3")
				print(passe)
				passe = true
				print(passe)
				msmProfundidade = profundidade
			elseif(contadorOx == 3 and passe == false and profundidade ~= msmProfundidade) then
				contadorOx = 2
				print("contadorOx = 2")
				print(passe)
				passe = true
				print(passe)
				msmProfundidade = profundidade
			elseif(contadorOx == 2 and passe == false and profundidade ~= msmProfundidade) then
				contadorOx = 1
				print("contadorOx = 1")
				print(passe)
				passe = true
				print(passe)
				msmProfundidade = profundidade
			elseif(contadorOx == 1 and passe == false and profundidade ~= msmProfundidade) then
				contadorOx = 0
				print("contadorOx = 0")
				print(passe)
				passe = true
				print(passe)
				msmProfundidade = profundidade
			end
		end
		if(contadorOx < 4 and criar == true) then
			createOxi()
			criar = false
			Runtime:addEventListener("enterFrame", moveOxigenio)
		end
	end

	--if (contadorOx == 3) then
		--ox4.alpha = 0
	--elseif (contadorOx == 2) then
		--ox3.alpha = 0 

	--elseif (contadorOx == 1) then
		--ox2.alpha = 0
	--elseif (contadorOx == 0) then
		--ox1.alpha = 0
	--end

	if(contadorOx == 4) then
		ox4.alpha = 1
		ox3.alpha = 1
		ox2.alpha = 1
		ox1.alpha = 1
	elseif(contadorOx == 3) then
		ox4.alpha = 0
		ox3.alpha = 1
		ox2.alpha = 1
		ox1.alpha = 1
	elseif(contadorOx == 2) then
		ox4.alpha = 0
		ox3.alpha = 0
		ox2.alpha = 1
		ox1.alpha = 1
	elseif(contadorOx == 1) then
		ox4.alpha = 0
		ox3.alpha = 0
		ox2.alpha = 0
		ox1.alpha = 1
	elseif(contadorOx == 0) then
		ox4.alpha = 0
		ox3.alpha = 0
		ox2.alpha = 0
		ox1.alpha = 0
	end

	if(ox1.alpha == 0 and contadorOx <= 0) then
		contadorVida = contadorVida-1
	end
	passe = false
end
--------------------------------------------------------------------------------------
local function endGame()
	timer.pause(gameLoopTimer)
	print("gameLoopTimer")
	timer.pause(fireTimer)
	print("fireTimer")
	timer.pause(movementTimer)
	print("movementTimer")
	timer.pause(contadorDeTempoTimer)
	print("contadorDeTempoTimer")
	composer.gotoScene("pause")
end

local function gameOver()
	if(contadorVida <= 0) then
		timer.cancel(gameLoopTimer)
		timer.cancel(fireTimer)
		timer.cancel(movementTimer)
		timer.cancel(contadorDeTempoTimer)
		composer.gotoScene("gameOver")
	end
	--print(contadorOx)
end


Runtime:addEventListener("enterFrame", gameOver)
--------------------------------------------------------------------------------------
print(contadorOx)
-------------------------------------------------------------------------------------
local function onCollision(event)
	if(event.phase == "began") then
		local ob1 = event.object1
		local ob2 = event.object2
		
		if((ob1.myName == "bullet" and ob2.myName == "enemy") or (ob1.myName == "enemy" and ob2.myName == "bullet")) then
			display.remove(ob1)
			display.remove(ob2)
			audio.play(explosionSound)
			
			for i = #enemyTable, 1, -1 do
				if(enemyTable[i] == ob1 or enemyTable[i] == ob2) then
					table.remove(enemyTable, i)
					break
				end
			end
		
		elseif(ob1.myName == "player" and ob2.myName == "enemy" or ob1.myName == "enemy" and ob2.myName == "player") then 
			if(died == false) then 
				died = true 
				contadorVida = contadorVida-1
				player.alpha = 0
				transition.to(player, {x = centroX, y = centroY/4, time = 1000,
				onComplete = function()
					died = false
					player.alpha = 1
				end
				})
			end
		
		elseif(ob1.myName == "player" and ob2.myName == "oxigenio" or ob1.myName == "oxigenio" and ob2.myName == "player") then
			print(contadorOx)
			if(contadorOx < 4) then
				contadorOx = contadorOx + 1
				criar = false
				--if(ob1.myName == "oxigenio") then
					--display.remove(ob1)
				--elseif(ob2.myName == "oxigenio") then
					--display.remove(ob2)
				--end
				
			end
			print(contadorOx)
		end
	end
end


---------------------------------------------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	physics.pause()

	backGroup = display.newGroup()
	sceneGroup:insert(backGroup)

	mainGroup = display.newGroup()
	sceneGroup:insert(mainGroup)

	uiGroup = display.newGroup()
	sceneGroup:insert(uiGroup)

	setupController(uiGroup)

	local background = display.newImageRect(backGroup, "imagens/bgs/gameplay_back.png", larguraTela, alturaTela+450)
	background.x = centroX
	background.y = centroY

	player = display.newImageRect(sceneGroup, "imagens/player/escafandro.png", 80, 80 )
	player.x = centroX
	player.y = centroY/4
	physics.addBody(player, {isSensor = true})
	player.myName = "player"

	local paredeEsquerda = display.newImageRect(sceneGroup, "imagens/bgs/paredeEsquerda.png", larguraTela/8, alturaTela+400)
	paredeEsquerda.x = larguraTela - larguraTela
	paredeEsquerda.y = centroY
	physics.addBody( paredeEsquerda, {isSensor = true}, "static" )

	local paredeDireita = display.newImageRect(sceneGroup, "imagens/bgs/paredeDireita.png", larguraTela/8, alturaTela+400)
	paredeDireita.x = larguraTela
	paredeDireita.y = centroY
	physics.addBody( paredeDireita, {isSensor = true}, "static" )

----------------------------------------------------------------------------------------------
-- Barra de Vida
----------------------------------------------------------------------------------------------
	local barraDeVida = display.newImageRect(sceneGroup, "imagens/bgs/life.png", 200, 50)
	barraDeVida.x = 230
	barraDeVida.y = alturaTela-alturaTela-100

	hp1 = display.newImageRect(sceneGroup, "imagens/bgs/vidaEsquerda.png", 50, 50)
	hp1.x = barraDeVida.x - barraDeVida.contentWidth/2 + (hp1.contentWidth/2)
	hp1.y = barraDeVida.y

	hp2 = display.newImageRect(sceneGroup, "imagens/bgs/vida.png", 50, 50)
	hp2.x = hp1.x + hp1.contentWidth
	hp2.y = barraDeVida.y

	hp3 = display.newImageRect(sceneGroup, "imagens/bgs/vida.png", 50, 50)
	hp3.x = hp2.x + hp2.contentWidth
	hp3.y = barraDeVida.y

	hp4 = display.newImageRect(sceneGroup, "imagens/bgs/vidaDireita.png", 50, 50)
	hp4.x = hp3.x + hp3.contentWidth
	hp4.y = barraDeVida.y

	local titleHP = display.newText(sceneGroup, "Vida", hp1.x - 55, barraDeVida.y, native.systemFont, 29)
------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------
-- Barra Oxigênio
----------------------------------------------------------------------------------------------
	local barraOx = display.newImageRect(sceneGroup, "imagens/bgs/life.png", 200, 50)
	barraOx.x = hp4.x + 300
	barraOx.y = alturaTela-alturaTela-100

	ox1 = display.newImageRect(sceneGroup, "imagens/bgs/vidaEsquerda.png", 50, 50)
	ox1.x = barraOx.x - barraOx.contentWidth/2 + (ox1.contentWidth/2)
	ox1.y = barraOx.y

	ox2 = display.newImageRect(sceneGroup, "imagens/bgs/vida.png", 50, 50)
	ox2.x = ox1.x + ox1.contentWidth
	ox2.y = barraOx.y

	ox3 = display.newImageRect(sceneGroup, "imagens/bgs/vida.png", 50, 50)
	ox3.x = ox2.x + ox2.contentWidth
	ox3.y = barraOx.y

	ox4 = display.newImageRect(sceneGroup, "imagens/bgs/vidaDireita.png", 50, 50)
	ox4.x = ox3.x + ox3.contentWidth
	ox4.y = barraOx.y

	local titleOx = display.newText(sceneGroup, "Ox", ox1.x - 55, barraOx.y, native.systemFont, 29)
------------------------------------------------------------------------------------------------------------

	local indicadorProfundidade = display.newText(sceneGroup, profundidade, centroX, alturaTela+100, native.systemFont, 50)

	function contadorDeTempo( event )
		--print( "contadorDeTempo called" )
		profundidade = profundidade + 1
		--print( profundidade )

		if(profundidade == 1010) then
			maxEnemies = maxEnemies - 9
			parar = 0
			timer.pause(contadorDeTempoTimer)
			physics.setGravity(0, 0.3)

			local enemyEscolh

			imgEnemy = math.random(1, 3)

			if (imgEnemy == 1) then
				enemyEscolh = "imagens/inimigos/purple_octopus.png"
			elseif (imgEnemy == 2) then
				enemyEscolh = "imagens/inimigos/pink_octopus.png"
			elseif (imgEnemy == 3) then
				enemyEscolh = "imagens/inimigos/orange_octopus.png"
			end

			maeEnemy = display.newImageRect(sceneGroup, enemyEscolh , 500, 500 )
			maeEnemy.x = centroX
			maeEnemy.y = centroY
			physics.addBody(player, {radius = 15, isSensor = true})
			maeEnemy.myName = "maeEnemy"
		elseif(profundidade == 500) then
			maxEnemies = maxEnemies + 1
		elseif(profundidade == 1000) then
				maxEnemies = maxEnemies + 4
		end

		--print( maxEnemies )
	end

	contadorDeTempoTimer = timer.performWithDelay( 1000, contadorDeTempo, 1000 )

function mostraProfundidade( event )
	indicadorProfundidade.text = profundidade
end

local menuButton = display.newImageRect(uiGroup, "imagens/botoes/pause2.png", 100, 100 )
	menuButton.x = centroX
	menuButton.y = alturaTela
	menuButton.alpha = 0.5
	menuButton:addEventListener("tap", endGame)

	Runtime:addEventListener("enterFrame", mostraProfundidade)

	setupGun()
	setupjoystick1()
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		physics.start()
		Runtime:addEventListener("collision", onCollision)
		Runtime:addEventListener("enterFrame", moveInimigos)
		Runtime:addEventListener("enterFrame", vida)
		--Runtime:addEventListener("enterFrame", oxi)
		gameLoopTimer = timer.performWithDelay(500, gameLoop, 0)
		--oxiTimer = timer.performWithDelay(1000, oxi, 0)
		--if(profundidade%10 == 0) then
		oxiTimer = timer.performWithDelay(1000, oxi, 2000)
			--Runtime:addEventListener("enterFrame", oxi)
		--end
		
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		Runtime:removeEventListener("collision", onCollision)
		Runtime:removeEventListener("enterFrame", moveInimigos)
		Runtime:removeEventListener("enterFrame", vida)
		Runtime:removeEventListener("enterFrame", gameOver)
		Runtime:removeEventListener("enterFrame", moveOxigenio)
		Runtime:removeEventListener("enterFrame", mostraProfundidade)
		physics.pause()
		composer.removeScene("timerbasedexample")
		--display.remove(sceneGroup)		
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	controller = nil
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
