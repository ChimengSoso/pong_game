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
  
  -- set LOVE's default filter to "nearest-neighbor", which essentially
  -- means there will be no filtering of pixels (blurriness), which is
  -- important for a nice crisp, 2D look
  love.graphics.setDefaultFilter('nearest', 'nearest')

  love.window.setTitle("Pong Game!")
  
  -- "seed" the RNG so that calls to fandom are always random
  -- use the current time, since that will very on startup every time
  math.randomseed(os.time())

  -- more "retro-looking" font object we can use for any text
  smallFont = love.graphics.newFont('font.ttf', 8)
  
  -- large fon for drawing the score on the screen
  scoreFont = love.graphics.newFont('font.ttf', 32)
  
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    vsync = true,
    resizable = false
  })
  
  player1Score = 0
  player2Score = 0

  servingPlayer = math.random(2) == 1 and 2
  
  -- initialize our player paddles; make them global so that they can be
  -- detedted by other functions and modules
  paddle1 = Paddle(5, 20, 5, 20)
  paddle2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 40 , 5, 20)

  -- place a ball in the middle of the screen
  ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 5, 5)

  -- game state varibable used to transition between different parts of the game
  -- (used for beginning, munus, main game, high score list, etc.)
  -- we will use this to determine behavior during render and update
  gameState = 'start'
  

end

function love.update(dt)
  if gameState == 'play' then

    if ball.x <= 0 then
      player2Score = player2Score + 1
      ball:reset()
      gameState = 'start'
    end

    if ball.x >= VIRTUAL_WIDTH - 4 then
      player1Score = player1Score + 1
      ball:reset()
      gameState = 'start'
    end

    if ball:collides(paddle1) then
      -- deflect ball to the right
      ball.dx = -ball.dx * 1.03
      ball.x = ball.x + 5

      if ball.dy < 0 then
        ball.dy = -math.random(10, 150)
      else
        ball.dy = math.random(10, 150)
      end
    end
    
    if ball:collides(paddle2) then
      -- deflect ball to the left
      ball.dx = -ball.dx * 1.03
      ball.x = ball.x - 5

      if ball.dy < 0 then
        ball.dy = -math.random(10, 150)
      else
        ball.dy = math.random(10, 150)
      end
    end
    
    if ball.y <= 0 then
      -- delfect the ball down
      ball.dy = -ball.dy
      ball.y = 0
    end
    
    if ball.y > VIRTUAL_HEIGHT - 4 then
      ball.dy = -ball.dy
      ball.y = VIRTUAL_HEIGHT - 4
    end
    
    
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
    
    paddle1:update(dt)
    paddle2:update(dt)
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
  
  -- clear the screen with a specific color; in this cas, a color similar
  -- to some versions of the original Pong
  love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)
  
  -- draw different thins based on the state of the game
  love.graphics.setFont(smallFont)

  love.graphics.printf("Welcome to Pong!", 0, 20, VIRTUAL_WIDTH, 'center')
  love.graphics.printf("Press Enter to Play!", 0, 32, VIRTUAL_WIDTH, 'center')
  
  -- draw score on the left and right center of the creen
  -- need o switch font to draw before actually printing
  love.graphics.setFont(scoreFont)
  love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
  love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
  
  -- show text greating
  love.graphics.setFont(smallFont)
  
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