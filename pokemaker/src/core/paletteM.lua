local grid = love.graphics.newImage("pokemaker/assets/game/grid.png")

PaletteM = {}

function PaletteM:new(o)
   local o = o or {}
   setmetatable(o, self)
   self.__index = self
   return o
end

function PaletteM:init(id, x, y, width, height, tileSheet, tileSheetText)
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

   self.disabled = false
end

function PaletteM:update(dt)
   if self.disabled then return end
   local x, y = love.mouse.getPosition()
   self:selectMultipleTiles(x, y, button)
end

function PaletteM:selectMultipleTiles(x, y)
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

local function drawStencil(x,y,w,h)
   return function()
      love.graphics.rectangle("fill", x,y,w,h)
   end
end

function PaletteM:draw()
   if self.disabled then return end
   
   love.graphics.stencil(drawStencil(self.x,self.y,self.width,self.height), "replace", 1)
   love.graphics.setStencilTest("greater", 0)

   love.graphics.draw(grid, self.gridQuad, self.x, self.y)
   love.graphics.draw(self.tileSheet, self.x, self.y+self.tileSheetOffset)
	love.graphics.setColor(0.9, 0.2, 0.2,0.9)
   love.graphics.rectangle("line", self.x+self.selectedTile["x"], self.y+self.tileSheetOffset+self.selectedTile["y"], self.selectionW, self.selectionH)

   love.graphics.setStencilTest()
	love.graphics.setColor(1,1,1)
end

function PaletteM:mousepressed(x, y, button, istouch)
   if self.disabled then return end
   self:selectTile(x, y, button)
end

function PaletteM:selectTile(x, y, button)
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

function PaletteM:mousereleased(x, y, button, istouch)
   if self.disabled then return end
   if #self.startSquare ~= 0 then
      self.selectedTile["x"] = self.startSquare[1]
      self.selectedTile["y"] = self.startSquare[2]
      self.selectedTile["w"] = self.selectionW
      self.selectedTile["h"] = self.selectionH
      self.startSquare = {}
   end
end

function PaletteM:keypressed(key, code)
   if self.disabled then return end
end

function PaletteM:wheelmoved(x, y)
   if self.disabled then return end
   local mouseX, mouseY = love.mouse.getPosition()
   local lctrlDown = love.keyboard.isDown("lctrl")

   if mouseX < self.x or mouseX > (self.x+self.width) then return false end
   if mouseY < self.y or mouseY > (self.y+self.height) then return false end

   local offset = 64
   if lctrlDown then offset = 128 end 
   if y < 0 then self.tileSheetOffset = self.tileSheetOffset - (-y*offset) end
   if y > 0 then self.tileSheetOffset = self.tileSheetOffset + (y*offset) end
end

function PaletteM:getSelected()
   local selectedTiles = {}
   if self.selectedTile["w"] > 32 or self.selectedTile["h"] > 32 then
      local x = self.selectedTile["x"]
      local y = self.selectedTile["y"]
      local w = self.selectedTile["w"]
      local h = self.selectedTile["h"]
      local quads = self:getCoordsInQuad(x, y, w, h)
      for i = 1, #quads do
         selectedTiles[#selectedTiles+1] = {quads[i][1], quads[i][2], quads[i][3], quads[i][4]}
      end
   else
      selectedTiles[1] = {self.selectedTile["x"], self.selectedTile["y"], 0, 0}
   end
   return {self.tileSheetText, selectedTiles}
end

function PaletteM:setTileSheet(tilesheet, tilesheetText)
   self.tileSheet = tilesheet
   self.tileSheetText = tilesheetText
   self.tileSheetOffset = 32
end

function PaletteM:getCoordsInQuad(x, y, w, h)
   local countW = w/32
   local countH = h/32
   local tiles = {}

   for i = 1, countW do
      for a = 1, countH do
         tiles[#tiles+1] = {x+(i*32)-32, y+(a*32)-32, i-1, a-1}
      end 
   end

   return tiles
end

function PaletteM:disable()
   self.disabled = true
end