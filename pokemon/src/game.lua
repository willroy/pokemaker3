local coreREQ = require("src/core/core")

core = Core:new()

Game = {}

function Game:new(o)
   local o = o or {}
   setmetatable(o, self)
   self.__index = self
   return o
end

function Game:init()
   core:init(1, 0, 0, 1300, 1000)
end

function Game:update(dt)
   core:update(dt)
end

function Game:draw()
   core:draw(dt)
end

function Game:mousepressed(x, y, button, istouch)
   core:mousepressed(x, y, button, istouch)
end

function Game:mousereleased(x, y, button, istouch)
   core:mousereleased(x, y, button, istouch)
end

function Game:keypressed(key, code)
   core:keypressed(key, code)
end

function Game:wheelmoved(x, y)
   core:wheelmoved(x, y)
end