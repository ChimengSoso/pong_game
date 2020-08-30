WINDOW_WIDTH = 640
WINDOW_HEIGHT = 360

function love.load()
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    vsync = true,
    resizable = false
  })
end

function love.update(dt)

end

function love.draw()
  love.graphics.printf("Hello Pong!",
                        0, 
                        WINDOW_HEIGHT / 2 - 6, 
                        WINDOW_WIDTH, 
                        'center')
end