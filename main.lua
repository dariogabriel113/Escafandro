-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local physics = require("physics")
physics.start()
physics.setGravity(0,0)

local centroX = display.contentCenterX
local centroY = display.contentCenterY

local larguraTela = display.contentWidth
local alturaTela = display.contentHeight+100

local bg = display.newImage("imagens/bgs/bg.png")
bg.width = larguraTela
bg.height = alturaTela
bg.x = centroX
bg.y = centroY

local stars = {}
for i=0, 4 do
  stars[i] = display.newImage("imagens/bgs/stars.png")
  stars[i].x = centroX
  stars[i].y = alturaTela - i * stars[i].contentHeight
end


local escafandro = display.newImageRect( "imagens/player/escafandro.png", 20, 20 )
escafandro.x = display.contentCenterX
escafandro.y = alturaTela - alturaTela + 100
escafandro.alpha = 0.8
physics.addBody(escafandro, "dynamic")
--escafandro.isFixedRotation = true

local inimigos = {}
for i=0, 4 do
  inimigos[i] = display.newImage("imagens/objetos/asteroid1.png")
  inimigos[i].y = alturaTela * 2
  inimigos[i].x = math.random((larguraTela - larguraTela + inimigos[i].contentWidth), (larguraTela+ inimigos[i].contentWidth))
  physics.addBody(inimigos[i], "dynamic")
  inimigos[i].isFixedRotation = true
  inimigos[i]:setLinearVelocity(0, math.random(2, 6))
end

local btLeft1 = display.newImage("imagens/bts/btLeft1.png")
btLeft1.width = centroX/4
btLeft1.height = centroX/4
btLeft1.y = (centroY*2) + 10
btLeft1.x = centroX/4 - 10

local btRight1 = display.newImage("imagens/bts/btRight1.png")
btRight1.width = centroX/4
btRight1.height = centroX/4
btRight1.y = (centroY*2) + 10
btRight1.x = centroX/4 + btLeft1.x

local function moveInimigos( event )
  for i = 0, 4 do
    if (inimigos[i].y + inimigos[i].contentHeight < 0) then
      inimigos[i].y = alturaTela + inimigos[i].contentHeight
      inimigos[i].x = math.random((larguraTela - larguraTela + inimigos[i].contentWidth), (larguraTela+ inimigos[i].contentWidth))
    else
      inimigos[i].y = inimigos[i].y - 5
    end
  end
end

local function colideInimigo( event )
  if (event.phase == "began") then
    Runtime:removeEventListener("enterFrame", atualizaMergulho)
    escafandro:removeSelf()
  end
end

local xAxys = 0
local function moveEsquerda( event )
  if (event.phase == "began") then
    xAxys = -5
  elseif (event.phase == "ended") then
    xAxys = 0
  end
end

local function moveDireita( event )
  if (event.phase == "began") then
    xAxys = 5
  elseif (event.phase == "ended") then
    xAxys = 0
  end
end

local function atualizaMergulho( event )
  escafandro.x = escafandro.x + xAxys
end



local function moveEstrelas( event )
  for i = 0, 4 do
    if (stars[i].y + stars[i].contentHeight < 0) then
      stars[i].y = alturaTela + stars[i].contentHeight
    else
      stars[i].y = stars[i].y - 5
    end
  end

end

btLeft1:addEventListener("touch", moveEsquerda)
btRight1:addEventListener("touch", moveDireita)

Runtime:addEventListener("enterFrame", atualizaMergulho)
Runtime:addEventListener("enterFrame", moveEstrelas)
Runtime:addEventListener("enterFrame", moveInimigos)
