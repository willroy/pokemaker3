local tilegridREQ = require("src/core/tile-grid")

local background = love.graphics.newImage("assets/menu/background.png")

Menu = {}

function Menu:new(o)
	local o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function Menu:init()
end

function Menu:update(dt)
end

function Menu:draw()
	love.graphics.draw(background, 0, 0)
end

function Menu:mousepressed(x, y, button, istouch)
end

function Menu:mousereleased(x, y, button, istouch)
end

function Menu:keypressed(key, code)
end

function Menu:wheelmoved(x, y)
end