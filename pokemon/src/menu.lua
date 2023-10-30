PokemonMenu = {}

function PokemonMenu:new(o)
	local o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function PokemonMenu:init()
end

function PokemonMenu:update(dt)
end

function PokemonMenu:draw()
end

function PokemonMenu:mousepressed(x, y, button, istouch)
end

function PokemonMenu:mousereleased(x, y, button, istouch)
end

function PokemonMenu:keypressed(key, code)
end

function PokemonMenu:wheelmoved(x, y)
end