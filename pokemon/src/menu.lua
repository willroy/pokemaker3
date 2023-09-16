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
end

function Menu:mousepressed(x, y, button, istouch)
end

function Menu:mousereleased(x, y, button, istouch)
end

function Menu:keypressed(key, code)
end

function Menu:wheelmoved(x, y)
end