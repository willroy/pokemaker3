local coreREQ = require("pokemon/src/core/core")

Game = {}

function Game:new(o)
  local o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Game:init(project)
  self.core = Core:new()
  self.core:init(project)
end

function Game:update(dt)
  self.core:update(dt)
end

function Game:draw()
  self.core:draw(dt)
end

function Game:mousepressed(x, y, button, istouch)
  self.core:mousepressed(x, y, button, istouch)
end

function Game:mousereleased(x, y, button, istouch)
  self.core:mousereleased(x, y, button, istouch)
end

function Game:keypressed(key, code)
  if key == "escape" then
    setCurrent("startup")
  end
  self.core:keypressed(key, code)
end

function Game:wheelmoved(x, y)
  self.core:wheelmoved(x, y)
end