local mapREQ = require("src/core/map")
local playerREQ = require("src/core/player")

map = Map:new()
player = Player:new()

Core = {}

function Core:new(o)
   local o = o or {}
   setmetatable(o, self)
   self.__index = self
   return o
end

function Core:init()
   map:init(1, 0, 0, 1300, 1000)
   map:load()

   player:init(618, 468)
end

function Core:update(dt)
   map:update(dt)
   player:update(dt)
end

function Core:draw()
   map:draw(dt)
   player:draw(dt)
end

function Core:mousepressed(x, y, button, istouch)
   map:mousepressed(x, y, button, istouch)
   player:mousepressed(x, y, button, istouch)
end

function Core:mousereleased(x, y, button, istouch)
   map:mousereleased(x, y, button, istouch)
   player:mousereleased(x, y, button, istouch)
end

function Core:keypressed(key, code)
   map:keypressed(key, code)
   player:keypressed(key, code)
end

function Core:wheelmoved(x, y)
   map:wheelmoved(x, y)
   player:wheelmoved(x, y)
end