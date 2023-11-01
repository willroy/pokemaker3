local coreREQ = require("pokemon/src/core/core")



PokemonGame = {}

function PokemonGame:new(o)
   local o = o or {}
   setmetatable(o, self)
   self.__index = self
   return o
end

function PokemonGame:init()
   self.core = Core:new()
   self.core:init(1, 0, 0, 1300, 1000)
end

function PokemonGame:update(dt)
   self.core:update(dt)
end

function PokemonGame:draw()
   self.core:draw(dt)
end

function PokemonGame:mousepressed(x, y, button, istouch)
   self.core:mousepressed(x, y, button, istouch)
end

function PokemonGame:mousereleased(x, y, button, istouch)
   self.core:mousereleased(x, y, button, istouch)
end

function PokemonGame:keypressed(key, code)
   self.core:keypressed(key, code)
end

function PokemonGame:wheelmoved(x, y)
   self.core:wheelmoved(x, y)
end