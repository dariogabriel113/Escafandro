local composer = require( "composer" )

local scene = composer.newScene()

local physics = require("physics")
physics.start()
physics.setGravity(0, 0)

local alturaTela = display.contentHeight
local larguraTela = display.contentWidth

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

local contador = 0
local joystick1
local joystick2

local function setupController(displayGroup)
	local joystick1Properties = {
		nToCRatio = 0.5,
		radius = 60,
		x = 200,
		y = alturaTela,
		restingXValue = 0,
		restingYValue = 0,
		rangeX = 200,
		rangeY = 200
	}

	local joystick1Name = "joystick1"
	joystick1 = controller:addJoystick(joystick1Name, joystick1Properties)

	local joystick2Properties = {
		nToCRatio = 0.5,
		radius = 60,
		x = larguraTela - 200,
		y = alturaTela,
		restingXValue = 0,
		restingYValue = 0,
		rangeX = 600,
		rangeY = 600
	}

	local joystick2Name = "joystick2"
	joystick2 = controller:addJoystick(joystick2Name, joystick2Properties)

	controller:displayController(displayGroup)

end

----------------------------------------------------------------------------------------
-- END VIRTUAL CONTROLLER CODE
----------------------------------------------------------------------------------------

--------------------------------------------------------------------
local centroX = display.contentCenterX
local centroY = display.contentCenterY

local enemyTable = {}
local maxEnemies = 5

local died = false

local player
local gameLoopTimer
local fireTimer
local movementTimer

local backGroup
local mainGroup
local uiGroup
-----------------------------------------------------------------

-----------------------------------------------------------------
local function createEnemy()
	if(#enemyTable == maxEnemies) then
		return true
	end

	local newenemy = display.newImageRect(mainGroup, "imagens/inimigos/enemy.png" , 100, 100)


	table.insert(enemyTable, newenemy)
	physics.addBody(newenemy, "dynamic", {width = 40, height = 40, bounce = 0.8})
	newenemy.myName = "enemy"

	local whereFrom =  math.random(4)

	newenemy.y = alturaTela
	newenemy.x = math.random(0, (larguraTela))
	newenemy.isFixedRotation = true
	newenemy:setLinearVelocity(0, math.random(2, 6))

end
-------------------------------------------------------------------------------

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

		if(en.y + en.contentHeight < 0) then
			en.y = alturaTela + en.contentHeight
			en.x = math.random((larguraTela - larguraTela + en.contentWidth), (larguraTela+ en.contentWidth))
			else
	        en.y = en.y - 5
		end
	end
end
-----------------------------------------------------------------------------------
local function gameLoop()
	createEnemy()

	for i = #enemyTable, 1, -1 do
		local en = enemyTable[i]

		if(en.x < -500 or en.x > display.contentWidth + 500
			or en.y < -700 or en.y > display.contentHeight + 500) then

			display.remove(en)
			table.remove(enemyTable, i)
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
--------------------------------------------------------------------------------------
local function endGame()
	composer.gotoScene("menu")
end

local function gameOver()
	if(contadorVida <= 0) then
		composer.gotoScene("gameOver")
	end
end

Runtime:addEventListener("enterFrame", gameOver)
--------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------
local function onCollision(event)
	if(event.phase == "began") then
		local ob1 = event.object1
		local ob2 = event.object2

		if((ob1.myName == "bullet" and ob2.myName == "enemy")
		or (ob1.myName == "enemy" and ob2.myName == "bullet"))
		then
			display.remove(ob1)
			display.remove(ob2)

			audio.play(explosionSound)

			for i = #enemyTable, 1, -1 do
				if(enemyTable[i] == ob1 or enemyTable[i] == ob2) then
					table.remove(enemyTable, i)
					contador = contador + 1
					break
				end
			end


		elseif(ob1.myName == "player" and ob2.myName == "enemy" or
				ob1.myName == "enemy" and ob2.myName == "player")
		then
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

	local background = display.newImageRect(backGroup, "imagens/bgs/bg.png", 800, 1400)
	background.x = centroX
	background.y = centroY

	player = display.newImageRect(sceneGroup, "imagens/player/escafandro.png", 70, 70 )
	player.x = centroX
	player.y = centroY/4
	physics.addBody(player, {radius = 15, isSensor = true})
	player.myName = "player"

	barraDeVida = display.newImageRect(sceneGroup, "imagens/bgs/life.png", 200, 50)
	barraDeVida.x = 200
	barraDeVida.y = alturaTela-alturaTela-100

	hp1 = display.newImageRect(sceneGroup, "imagens/bgs/vidaEsquerda.png", 50, 50)
	hp1.x = barraDeVida.y + barraDeVida.contentWidth + (hp1.contentWidth/2)
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

	titleHP = display.newText(sceneGroup, "Vida", hp1.x - 55, barraDeVida.y, native.systemFont, 29)


	local menuButton = display.newImageRect(uiGroup, "imagens/botoes/pause.png", 120, 120 )
	menuButton.x = centroX
	menuButton.y = alturaTela
	menuButton.alpha = 0.25
	menuButton:addEventListener("tap", endGame)

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
		gameLoopTimer = timer.performWithDelay(500, gameLoop, 0)
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		timer.cancel(gameLoopTimer)
		timer.cancel(fireTimer)
		timer.cancel(movementTimer)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		Runtime:removeEventListener("collision", onCollision)
		Runtime:removeEventListener("enterFrame", moveInimigos)
		Runtime:removeEventListener("enterFrame", vida)
		physics.pause()
		composer.removeScene("timerbasedexample")
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
