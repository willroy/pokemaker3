Game = {}

function Game:new(o)
   local o = o or {}
   setmetatable(o, self)
   self.__index = self
   return o
end

function Game:init()
end

function Game:update(dt)
end

function Game:draw()
end

function Game:mousepressed(x, y, button, istouch)
end

function Game:mousereleased(x, y, button, istouch)
end

function Game:keypressed(key, code)
end

function Game:wheelmoved(x, y)
end