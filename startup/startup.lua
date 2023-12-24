local background = love.graphics.newImage("startup/assets/background.png")

Startup = {}

function Startup:new(o)
	local o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function Startup:init()
end

function Startup:update(dt)
end

function Startup:draw()
	love.graphics.draw(background, 0, 0)
end

function Startup:mousepressed(x, y, button, istouch)
end

function Startup:mousereleased(x, y, button, istouch)
end

function Startup:keypressed(key, code)
  if key == "escape" then
    love.event.push("quit")
  end
	if key == "m" then setCurrent("pmak-menu") end
	if key == "g" then setCurrent("pmon-game") end
end

function Startup:wheelmoved(x, y)
end