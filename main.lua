local pokemakerGameREQ = require("pokemaker/src/game")
local pokemakerMenuREQ = require("pokemaker/src/menu")
local pokemakerGame = PokemakerGame:new()
local pokemakerMenu = PokemakerMenu:new()

local pokemonGameREQ = require("pokemon/src/game")
local pokemonMenuREQ = require("pokemon/src/menu")
local pokemonGame = PokemonGame:new()
local pokemonMenu = PokemonMenu:new()

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
	if text == "startup" then current = startup end
	if text == "pmak-game" then current = pokemakerGame end
	if text == "pmak-menu" then current = pokemakerMenu end
	if text == "pmon-game" then current = pokemonGame end
	if text == "pmon-menu" then current = pokemonMenu end
	current:init()
end

function openFile(project, inPokemon)
	if inPokemon then
		current = pokemonGame
	else
		current = pokemakerGame
	end

	current:init(project)
end