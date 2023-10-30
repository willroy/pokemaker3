local gameREQ = require("src/game")
local menuREQ = require("src/menu")

local menu = Menu:new()
local game = Game:new()

local icon = love.image.newImageData("assets/icon.png");

local current = menu

local mainX = 1300
local mainY = 1000

function love.load()
	love.window.setTitle("pokemaker3")
	love.window.setMode(mainX, mainY, {resizable=true})
	love.graphics.setBackgroundColor(1,1,1)
	local font = love.graphics.newFont(16)
	love.graphics.setFont(font)
	io.stdout:setvbuf("no")
 	love.window.setIcon(icon);
	current:init(mainX, mainY)
	-- openFile("project1")
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
	if text == "game" then current = game end
	if text == "menu" then current = menu end
	current:init()
end

function openFile(project)
	current = game
	current:init(mainX, mainY, project)
end