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
		y = alturaTela - 100,
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
		y = alturaTela - 100,
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
local maxEnemies = 50

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

	if(whereFrom == 1) then
		newenemy.x = -60
		newenemy.y = math.random(display.contentHeight)
		newenemy:setLinearVelocity(math.random(40, 120), math.random(-40, 40))
	elseif(whereFrom == 2) then
		newenemy.x = math.random(display.contentWidth)
		newenemy.y = -60
		newenemy:setLinearVelocity(math.random(-40, 40), math.random(40, 120))
	elseif(whereFrom == 3) then
		newenemy.x = display.contentWidth + 60
		newenemy.y = math.random(display.contentHeight)
		newenemy:setLinearVelocity(math.random(-120, -40), math.random(-40, 40))
	elseif(whereFrom == 4) then
		newenemy.x = math.random(display.contentWidth)
		newenemy.y = -60
		newenemy:setLinearVelocity(math.random(-40, 40), math.random(-120, -40))
	end
	newenemy:applyTorque(math.random(-1, 1))
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

-----------------------------------------------------------------------------------
local function gameLoop()
	createEnemy()

	for i = #enemyTable, 1, -1 do
		local en = enemyTable[i]

		if(en.x < -100 or en.x > display.contentWidth + 100
			or en.y < -100 or en.y > display.contentHeight + 100) then

			display.remove(en)
			table.remove(enemyTable, i)
		end
	end
end
-------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------
local function endGame()
	composer.gotoScene("menu")
end
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

				player.alpha = 0
				transition.to(player, {x = centroX, y = centroY, alpha = 1, time = 500,
					onComplete = function()
						died = false
					end
				})
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------
local indicadorContagem = display.newText(contador, centroX, centroX, native.systemFont, 80 )

local function mostraContagem( event )
	count = contador
	indicadorContagem.text = count
	indicadorContagem:setFillColor(1, 1, 1, 1)
end
---------------------------------------------------------------------------------------------------------------------------------

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

	player = display.newImageRect( "imagens/player/escafandro.png", 20, 20 )
	player.x = centroX
	player.y = centroY
	physics.addBody(player, {radius = 15, isSensor = true})
	player.myName = "player"


	local menuButton = display.newText(uiGroup, "Menu", centroX, 920, native.systemFont, 44)
	menuButton:setFillColor(1, 1, 1, 1)
	menuButton:addEventListener("tap", endGame)

	setupGun()
	setupjoystick1()
end

Runtime:addEventListener("enterFrame", mostraContagem)


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
