local grid = love.graphics.newImage("assets/game/grid.png")

Palette = {}

function Palette:new(o)
   local o = o or {}
   setmetatable(o, self)
   self.__index = self
   return o
end

function Palette:init(id, x, y, width, height, tileSheet, tileSheetText)
   self.id = id or 0
   self.x = x or 0
   self.y = y or 0
   self.width = width or 0
   self.height = height or 0
   self.backColor = {1,1,1}

   self.tileSheet = tileSheet or nil
   self.tileSheetText = tileSheetText or ""
   self.gridQuad = love.graphics.newQuad(0, 0, self.width, self.height, grid)

   self.tileSheetOffset = 32

   self.selectedTile = {["x"]=0,["y"]=0,["w"]=0,["h"]=0}

   self.selectionW = 32
   self.selectionH = 32
   self.startSquare = {}
end

function Palette:update(dt)
   local x, y = love.mouse.getPosition()
   self:selectMultipleTiles(x, y, button)
end

function Palette:selectMultipleTiles(x, y)
   if not love.mouse.isDown(2) then return false end
   if x < self.x or x > (self.x+self.width) then return false end
   if y < self.y or y > (self.y+self.height) then return false end

   if #self.startSquare == 0 then
      local relativeX = math.floor((x-self.x)/32)*32
      local relativeY = math.floor((y-(self.y+self.tileSheetOffset))/32)*32
      self.startSquare = {relativeX, relativeY}
      self.selectedTile["x"] = relativeX
      self.selectedTile["y"] = relativeY
      self.selectedTile["w"] = self.selectionW
      self.selectedTile["h"] = self.selectionH
   else
      local relativeX = math.floor((x-self.x)/32)*32
      local relativeY = math.floor((y-(self.y+self.tileSheetOffset))/32)*32
      self.selectionW = relativeX - self.startSquare[1] + 32
      self.selectionH = relativeY - self.startSquare[2] + 32
   end
end

function Palette:draw()
   love.graphics.draw(grid, self.gridQuad, self.x, self.y)
   love.graphics.draw(self.tileSheet, self.x, self.y+self.tileSheetOffset)
	love.graphics.setColor(0.9, 0.2, 0.2,0.9)
   love.graphics.rectangle("line", self.x+self.selectedTile["x"], self.y+self.tileSheetOffset+self.selectedTile["y"], self.selectionW, self.selectionH)

	love.graphics.setColor(1,1,1)
end

function Palette:mousepressed(x, y, button, istouch)
   self:selectTile(x, y, button)
end

function Palette:selectTile(x, y, button)
   if button ~= 1 then return false end
   if x < self.x or x > (self.x+self.width) then return false end
   if y < self.y or y > (self.y+self.height) then return false end

   local relativeX = math.floor((x-self.x)/32)*32
   local relativeY = math.floor((y-(self.y+self.tileSheetOffset))/32)*32
   self.selectedTile["x"] = relativeX
   self.selectedTile["y"] = relativeY
   self.selectedTile["w"] = self.selectionW
   self.selectedTile["h"] = self.selectionH
end

function Palette:mousereleased(x, y, button, istouch)
   if #self.startSquare ~= 0 then
      self.selectedTile["x"] = self.startSquare[1]
      self.selectedTile["y"] = self.startSquare[2]
      self.selectedTile["w"] = self.selectionW
      self.selectedTile["h"] = self.selectionH
      self.startSquare = {}
   end
end

function Palette:keypressed(key, code)
end

function Palette:wheelmoved(x, y)
   local mouseX, mouseY = love.mouse.getPosition()
   local lctrlDown = love.keyboard.isDown("lctrl")

   if mouseX < self.x or mouseX > (self.x+self.width) then return false end
   if mouseY < self.y or mouseY > (self.y+self.height) then return false end

   local offset = 64
   if lctrlDown then offset = 128 end 
   if y < 0 then self.tileSheetOffset = self.tileSheetOffset - (-y*offset) end
   if y > 0 then self.tileSheetOffset = self.tileSheetOffset + (y*offset) end
end

function Palette:getSelected()
   return {self.tileSheetText, self.selectedTile}
end

function Palette:setTileSheet(tilesheet, tilesheetText)
   self.tileSheet = tilesheet
   self.tileSheetText = tilesheetText
end