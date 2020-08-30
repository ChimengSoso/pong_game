-- https://github.com/Ulydev/push
Class = require 'class'
push = require 'push'

require 'Ball'
require 'Paddle'

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

  love.window.setTitle("Pong Game!")

  paddle1 = Paddle(5, 20, 5, 20)
  paddle2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 40 , 5, 20)
   
  player1Score = 0
  player2Score = 0

  ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 5, 5)

  gameState = 'start'
  

end

function love.update(dt)
  paddle1:update(dt)
  paddle2:update(dt)
  
  -- player 1 movement
  if love.keyboard.isDown('w') then
    
    -- add negative paddle speed to current Y scaled by deltaTime
    paddle1.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('s') then

    -- add positive paddle speed to current Y scaled by deltaTime
    paddle1.dy = PADDLE_SPEED
  else
    paddle1.dy = 0
  end

  -- player 2 movement
  if love.keyboard.isDown('up') then

    -- add negative paddle speed to current Y scaled by deltaTime
    paddle2.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('down') then

    -- add positive paddle speed to current Y scaled by deltaTime 
    paddle2.dy = PADDLE_SPEED
  else
    paddle2.dy = 0
  end

  if gameState == 'play' then
    ball:update(dt)
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
      ball:reset()
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
  
  -- show score of each player
  love.graphics.setFont(scoreFont)
  love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
  love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
  
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
      "Hello Play State!",  -- text
      0,                    -- position of x-axis
      20,                   -- position of y-axis
      VIRTUAL_WIDTH,        -- size of width of text box
      'center')             -- alignment
  end
  
  -- render paddles, now using their clas's render method
  paddle1:render()
  paddle2:render()
  
  -- render ball using its class's render method
  ball:render()

  displayFPS()
    
  push:apply('end')
end

function displayFPS()
  love.graphics.setColor(0, 1, 0, 1)
  love.graphics.setFont(smallFont)
  love.graphics.print('FPS: ' ..  tostring(love.timer.getFPS()), 40, 20)
  love.graphics.setColor(1, 1, 1, 1)
end