function love.load()
	love.window.setTitle("pokemon3")
	love.window.setMode(1300, 1000)
	love.graphics.setBackgroundColor(1,1,1)
	io.stdout:setvbuf("no")
end

function love.update(dt)
end

function love.draw()
end

function love.mousepressed(x, y, button, istouch)
end

function love.mousereleased(x, y, button, istouch)
end

function love.keypressed(key, code)
	if key == "escape" then
      love.event.push("quit")
    end
end

function love.wheelmoved(x, y)
end

function love.conf(t)
  t.console = true
end