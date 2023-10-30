local coreREQ = require("pokemon/src/core/core")

core = Core:new()

PokemonGame = {}

function PokemonGame:new(o)
   local o = o or {}
   setmetatable(o, self)
   self.__index = self
   return o
end

function PokemonGame:init()
   print("yo")
   core:init(1, 0, 0, 1300, 1000)
end

function PokemonGame:update(dt)
   core:update(dt)
end

function PokemonGame:draw()
   core:draw(dt)
end

function PokemonGame:mousepressed(x, y, button, istouch)
   core:mousepressed(x, y, button, istouch)
end

function PokemonGame:mousereleased(x, y, button, istouch)
   core:mousereleased(x, y, button, istouch)
end

function PokemonGame:keypressed(key, code)
   core:keypressed(key, code)
end

function PokemonGame:wheelmoved(x, y)
   core:wheelmoved(x, y)
end