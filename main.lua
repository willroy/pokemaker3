local pokemakerGameREQ = require("pokemaker/src/game")
local pokemakerMenuREQ = require("pokemaker/src/menu")
local pokemonGameREQ = require("pokemon/src/game")
local pokemonMenuREQ = require("pokemon/src/menu")

local startupREQ = require("startup")
local startup = Startup:new()
local current = startup

function love.load()
	local icon = love.image.newImageData("pokemaker/assets/icon.png");
	local font = love.graphics.newFont(16)

	love.window.setTitle("pokemaker3")
	love.window.setMode(1300, 1000, {vsync=1})

 	love.window.setIcon(icon);

	love.graphics.setBackgroundColor(1,1,1)
	love.graphics.setFont(font)

	io.stdout:setvbuf("no")

	current:init()
end

function love.update(dt)
	current:update(dt)
end

function love.draw()
	current:draw()
end

function love.mousepressed(x, y, button, istouch)
	current:mousepressed(x, y, button, istouch)
end

function love.mousereleased(x, y, button, istouch)
	current:mousereleased(x, y, button, istouch)
end

function love.keypressed(key, code)
	current:keypressed(key, code)
end

function love.wheelmoved(x, y)
	current:wheelmoved(x, y)
end

function love.conf(t)
  t.console = true
end

function setCurrent(text)
	if text == "startup" then current = Startup:new() end
	if text == "pmak-game" then current = PokemakerGame:new() end
	if text == "pmak-menu" then current = PokemakerMenu:new() end
	if text == "pmon-game" then current = PokemonGame:new() end
	if text == "pmon-menu" then current = PokemonMenu:new() end
	current:init()
end

function openFile(project, inPokemon)
	if inPokemon then
		current = PokemonGame:new()
	else
		current = PokemakerGame:new()
	end
	current:init(project)
end