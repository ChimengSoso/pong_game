push = require 'push'

WINDOW_WIDTH = 640
WINDOW_HEIGHT = 360

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

--[[
  Start function cycle
]]
function love.load()
  math.randomseed(os.time())

  love.graphics.setDefaultFilter('nearest', 'nearest')

  smallFont = love.graphics.newFont('font.ttf', 8)
  
  scoreFont = love.graphics.newFont('font.ttf', 32)
  
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    vsync = true,
    resizable = false
  })
  
  player1Score = 0
  player2Score = 0

  player1Y = 20
  player2Y = VIRTUAL_HEIGHT - 40

  ballX = VIRTUAL_WIDTH / 2 - 2
  ballY = VIRTUAL_HEIGHT / 2 - 2

  ballDX = math.random(2) == 1 and -100 or 100
  ballDY = math.random(-50, 50) 

  gameState = 'start'

end

function love.update(dt)
  -- player 1 movement
  if love.keyboard.isDown('w') then
    
    -- add negative paddle speed to current Y scaled by deltaTime
    player1Y = math.max(0, player1Y - PADDLE_SPEED * dt)
  elseif love.keyboard.isDown('s') then

    -- add positive paddle speed to current Y scaled by deltaTime
    player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED * dt)
  end

  -- player 2 movement
  if love.keyboard.isDown('up') then

    -- add negative paddle speed to current Y scaled by deltaTime
    player2Y = math.max(0, player2Y - PADDLE_SPEED * dt)
  elseif love.keyboard.isDown('down') then

    -- add positive paddle speed to current Y scaled by deltaTime 
    player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED * dt)
  end

  if gameState == 'play' then
    ballX = ballX + ballDX * dt
    ballY = ballY + ballDY * dt
  end
end

--[[
    Keyboard hadling, called by LOVE each frame;
    passes in the key we pressed so we can access.
]]
function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 'enter' or key == 'return' then
    if gameState == 'start' then
      gameState = 'play'
    elseif gameState == 'play' then
      gameState = 'start'

      ballX = VIRTUAL_WIDTH / 2 - 2
      ballY = VIRTUAL_HEIGHT / 2 - 2

      ballDX = math.random(2) == 1 and -100 or 100
      ballDY = math.random(-50, 50) 
    end
  end


end

--[[
    Called after update by LOVE, used to draw anything to the screen,
    updated or otherwise.
]]
function love.draw()

  -- begin rendering at virtual resolution
  push:apply('start')

  love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

  -- render ball (center)
  love.graphics.rectangle('fill', ballX, ballY, 5, 5)

  -- render first paddle (left side)
  love.graphics.rectangle('fill', 5, player1Y, 5, 20)

  -- render second paddle (right side)
  love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)

  -- show text greating
  love.graphics.setFont(smallFont)
  if gameState == 'start' then
    love.graphics.printf(
      "Hello Start State!", -- text
      0,                    -- position of x-axis
      20,                   -- position of y-axis
      VIRTUAL_WIDTH,        -- size of width of text box
      'center')             -- alignment
  elseif gameState == 'play' then
    love.graphics.printf(
      "Hello Play State!", -- text
      0,                    -- position of x-axis
      20,                   -- position of y-axis
      VIRTUAL_WIDTH,        -- size of width of text box
      'center')             -- alignment
  end
  
  -- show score of each player
  love.graphics.setFont(scoreFont)
  love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
  love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
  
  push:apply('end')
end