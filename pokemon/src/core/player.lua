local characters = love.graphics.newImage("pokemon/assets/characters.png")
local character = {
	["front"] = love.graphics.newQuad(206, 0, 28, 42, characters),
	["frontWalk"] = love.graphics.newQuad(296, 0, 30, 42, characters),
	["back"] = love.graphics.newQuad(236, 0, 28, 42, characters),
	["backWalk"] = love.graphics.newQuad(328, 0, 28, 42, characters),
	["left"] = love.graphics.newQuad(266, 0, 28, 42, characters),
	["leftWalk"] = love.graphics.newQuad(358, 0, 28, 42, characters),
	["right"] = love.graphics.newQuad(266, 0, 28, 42, characters),
	["rightWalk"] = love.graphics.newQuad(358, 0, 28, 42, characters)
}

Player = {}

function Player:new(o)
	local o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function Player:init(x, y)
	self.x = x or 0
	self.y = y or 0
	self.dir = "front"
	self.img = character["front"]

	self.walkTimer = 0
	self.animationSpeed = 30
end

function Player:update(dt)
	if     love.keyboard.isDown("w") then self.dir = "back"
	elseif love.keyboard.isDown("a") then self.dir = "left"
	elseif love.keyboard.isDown("s") then self.dir = "front"
	elseif love.keyboard.isDown("d") then self.dir = "right" end

	self:updateAnimation()
end

function Player:updateAnimation()
	if current.core.move["busy"] then
		self.walkTimer = self.walkTimer + 1
		if self.walkTimer < (self.animationSpeed / 2) then 
			self.img = character[self.dir.."Walk"]
		elseif self.walkTimer < self.animationSpeed then
			self.img = character[self.dir]
		elseif self.walkTimer == self.animationSpeed then
			self.img = character[self.dir]
			self.walkTimer = 0
		end
	else
		self.img = character[self.dir]
	end
end

function Player:draw()
	local rotate = {0,0,1,1}
	if self.dir == "right" then rotate = {32,0,-1,1} end 
	love.graphics.draw(characters, self.img, self.x+rotate[1], self.y, rotate[2], rotate[3], rotate[4])
end

function Player:mousepressed(x, y, button, istouch)
end

function Player:mousereleased(x, y, button, istouch)
end

function Player:keypressed(key, code)
end

function Player:wheelmoved(x, y)
end

function Player:getPos()
	return {["x"]=self.x,["y"]=self.y}
end