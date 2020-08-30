WINDOW_WIDTH = 640
WINDOW_HEIGHT = 360

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

push = require 'push'


function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  smallFont = love.graphics.newFont('font.ttf', 8)
  love.graphics.setFont(smallFont )

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    vsync = true,
    resizable = false
  })

  
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
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

  love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 5, 5)

  love.graphics.rectangle('fill', 5, 20, 5, 20)
  love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 40, 5, 20)

  love.graphics.printf(
    "Hello Pong!",
    0,
    20, 
    VIRTUAL_WIDTH, 
    'center')
  
  push:apply('end')
end