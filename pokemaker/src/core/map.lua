require "lfs"

local collisionREQ = require("src/core/collision")
local zindexREQ = require("src/core/z-index")

local grid = love.graphics.newImage("assets/game/grid.png")
local pencil = love.graphics.newImage("assets/game/pencil.png")
local brush = love.graphics.newImage("assets/game/pen.png")
local brushXL = love.graphics.newImage("assets/game/penXL.png")
local onionON = love.graphics.newImage("assets/game/onionON.png")
local onionOFF = love.graphics.newImage("assets/game/onionOFF.png")

local background = love.graphics.newImage("assets/game/background.png")

local brushes = {
   ["pencil"]={{0,0}},
   ["brush"]={{-1,-1},{0,0},{0,1},{1,0},{1,-1},{0,-1},{-1,0},{-1,1},{1,1}},
   ["brushXL"]={{-1,-1},{0,0},{0,1},{1,0},{1,-1},{0,-1},{-1,0},{-1,1},{1,1},{-2,-2},{-2,-1},{-2,0},{-2,1},{-2,2},{-1,2},{0,2},{1,2},{2,2},{2,1},{2,0},{2,-1},{2,-2},{1,-2},{0,-2},{-1,-2}}
}

local tileSheetNames = {"interior_electronics","interior_flooring","interior_general","interior_misc","interior_misc2","interior_stairs","interior_tables","interior_walls","outside_buildings","outside_ground","outside_items","outside_misc","outside_rocks","outside_vegetation","text"}
local tileSheets = {
   ["interior_electronics"] = love.graphics.newImage("assets/tilesheets/interior-electronics.png"),
   ["interior_flooring"] = love.graphics.newImage("assets/tilesheets/interior-flooring.png"),
   ["interior_general"] = love.graphics.newImage("assets/tilesheets/interior-general.png"),
   ["interior_misc"] = love.graphics.newImage("assets/tilesheets/interior-misc.png"),
   ["interior_misc2"] = love.graphics.newImage("assets/tilesheets/interior-misc2.png"),
   ["interior_stairs"] = love.graphics.newImage("assets/tilesheets/interior-stairs.png"),
   ["interior_tables"] = love.graphics.newImage("assets/tilesheets/interior-tables.png"),
   ["interior_walls"] = love.graphics.newImage("assets/tilesheets/interior-walls.png"),
   ["outside_buildings"] = love.graphics.newImage("assets/tilesheets/outside-buildings.png"),
   ["outside_ground"] = love.graphics.newImage("assets/tilesheets/outside-ground.png"),
   ["outside_items"] = love.graphics.newImage("assets/tilesheets/outside-items.png"),
   ["outside_misc"] = love.graphics.newImage("assets/tilesheets/outside-misc.png"),
   ["outside_rocks"] = love.graphics.newImage("assets/tilesheets/outside-rocks.png"),
   ["outside_vegetation"] = love.graphics.newImage("assets/tilesheets/outside-vegetation.png"),
   ["text"] = love.graphics.newImage("assets/tilesheets/text.png")
}

Map = {}

function Map:new(o)
   local o = o or {}
   setmetatable(o, self)
   self.__index = self
   return o
end

function Map:init(id, x, y, width, height)
   self.id = id or 0
   self.x = x or 0
   self.y = y or 0
   self.moveX = 0
   self.moveY = 0
   self.width = width or 0
   self.height = height or 0
   self.backColor = {1,1,1}

   self.project = ""

   self.gridQuad = love.graphics.newQuad(0, 0, self.width, self.height, grid)
   self.brush = brushes["pencil"]
   self.layers = {{}}
   self.layer = 1
   self.onionSkin = false
   self.helpMenu = false

   self.lastUpdated = {}
   self.lastDeleted = {}

   self.mode = "tiles"
   self.collision = Collision:new()
   self.collisionINIT = false
   self.zindex = Zindex:new()
   self.zindexINIT = false

   self.start = false
end

function Map:update(dt)
   if self.mode == "tiles" then
      self:move()
      self:removeTile()
      self:placeTile()
   elseif self.mode == "collision" then
      if self.collisionINIT == false then 
         self.collision:init(self.id, self.x, self.y, self.width, self.height)
         self.collision:load(self.project)
         palette:disable()
         self.collisionINIT = true
      end
      self.collision:update(dt)
   elseif self.mode == "zindex" then
      if self.zindexINIT == false then 
         self.zindex:init(self.id, self.x, self.y, self.width, self.height)
         self.zindex:load(self.project)
         palette:disable()
         self.zindexINIT = true
      end
      self.zindex:update(dt)
   end
end

function Map:mousepressed(x, y, button, istouch)
   if self.mode == "collision" then
      self.collision:mousepressed(x, y, button, istouch)
   elseif self.mode == "zindex" then
      self.zindex:mousepressed(x, y, button, istouch)
   end
end

function Map:mousereleased(x, y, button, istouch)
   self.start = true
   if self.mode == "collision" then
      self.collision:mousereleased(x, y, button, istouch)
   elseif self.mode == "zindex" then
      self.zindex:mousereleased(x, y, button, istouch)
   end
end

function Map:keypressed(key, code)
   if self.mode == "tiles" then
      if key == "b" then
         if self.brush == brushes["pencil"] then self.brush = brushes["brush"]
         elseif self.brush == brushes["brush"] then self.brush = brushes["brushXL"]
         elseif self.brush == brushes["brushXL"] then self.brush = brushes["pencil"] end
      end

      if key == "[" and self.layer > 1 then
         self.layer = self.layer - 1
      elseif key == "]" then
         self.layer = self.layer + 1
         if self.layers[self.layer] == nil then self.layers[self.layer] = {} end 
      end

      if key == "o" then self.onionSkin = not self.onionSkin end
      if key == "h" then self.helpMenu = not self.helpMenu end
      if key == "c" then self.mode = "collision" end
      if key == "z" then self.mode = "zindex" end
   elseif self.mode == "collision" then
      self.collision:keypressed(key, code)
   elseif self.mode == "zindex" then
      self.zindex:keypressed(key, code)
   end
end

function Map:wheelmoved(x, y)
end

-- UPDATE METHODS --

function Map:move()
   if love.keyboard.isDown("w") then self.moveY = self.moveY + 16
   elseif love.keyboard.isDown("a") then self.moveX = self.moveX + 16
   elseif love.keyboard.isDown("s") then self.moveY = self.moveY - 16
   elseif love.keyboard.isDown("d") then self.moveX = self.moveX - 16 end
end

function Map:removeTile()
   local x, y = love.mouse.getPosition()
   local pressed = love.mouse.isDown(2)

   if not pressed then return false end
   if x < self.x or x > (self.x+self.width) then return false end
   if y < self.y or y > (self.y+self.height) then return false end

   local relativeX = math.floor((x)/32)*32+5
   local relativeY = math.floor((y)/32)*32-14

   if self.lastDeleted[1] == relativeX and self.lastDeleted[2] == relativeY then return false end

   local newLayers = {}
   newLayers[self.layer] = {}

   for k, tile in pairs(self.layers[self.layer]) do
      local found = false
      for i = 1, #self.brush do
         local brushX = relativeX+(self.brush[i][1]*32)
         local brushY = relativeY+(self.brush[i][2]*32)
         local x = tonumber(tile["x"])
         local y = tonumber(tile["y"])
         if ( x == brushX and y == brushY ) then found = true end
      end
      if not found then
         newLayers[self.layer][#newLayers[self.layer]+1] = tile
         newLayers[self.layer][#newLayers[self.layer]]["id"] = #newLayers[self.layer]
      end
   end

   self.layers[self.layer] = newLayers[self.layer]
   self.lastDeleted = {relativeX, relativeY}
end

function Map:placeTile()
   local x, y = love.mouse.getPosition()
   local pressed = love.mouse.isDown(1)

   if not self.start then return end
   if not pressed then return false end
   if x < self.x or x > (self.x+self.width) then return false end
   if y < self.y or y > (self.y+self.height) then return false end
   
   local relativeX = math.floor((x)/32)*32+5
   local relativeY = math.floor((y)/32)*32-14

   if self.lastUpdated[1] == relativeX and self.lastUpdated[2] == relativeY then return false end

   local selectedTiles = palette:getSelected()
   local selectedTileSheet = selectedTiles[1]
   local selectedTiles = selectedTiles[2]
   local brush = self.brush
   if #selectedTiles > 1 then brush = brushes["pencil"] end
   if self.layers[self.layer] == nil then self.layers[self.layer] = {} end

   for s = 1, #selectedTiles do
      for i = 1, #brush do
         local x = relativeX+(brush[i][1]*32)+(selectedTiles[s][3]*32)
         local y = relativeY+(brush[i][2]*32)+(selectedTiles[s][4]*32)
         local newTile = {
            ["tilesheet"]=selectedTileSheet,
            ["id"] = #self.layers[self.layer]+1,
            ["quad"] = love.graphics.newQuad(selectedTiles[s][1], selectedTiles[s][2], 32, 32, tileSheets[selectedTileSheet]),
            ["quadX"] = selectedTiles[s][1],
            ["quadY"] = selectedTiles[s][2],
            ["x"] = x,
            ["y"] = y
         }

         local replaced = false
         for k, tile in pairs(self.layers[self.layer]) do
            local tileX = tonumber(tile["x"])
            local tileY = tonumber(tile["y"])
            if x == tileX and y == tileY then
               newTile["id"] = self.layers[self.layer][k]["id"]
               self.layers[self.layer][k] = newTile
               replaced = true
            end
         end

         if not replaced then self.layers[self.layer][#self.layers[self.layer]+1] = newTile end
      end
   end

   self.lastUpdated = {relativeX, relativeY}
end

-- DRAW METHODS --

function Map:draw()
   
   self:drawMap()

   if self.mode == "tiles" then
      self:drawMenuBackground()
      self:drawMenuBar()
      self:drawToolBar()
   elseif self.mode == "collision" then
      self.collision:draw()
   elseif self.mode == "zindex" then
      self.zindex:draw()
   end

   if self.helpMenu then self:drawHelpMenu() end   
end

function Map:drawMap()
   love.graphics.setColor(1,1,1)
   love.graphics.draw(grid, self.gridQuad, self.x, self.y)
   for k1, layer in pairs(self.layers) do
      if self.layer == k1 or not self.onionSkin then love.graphics.setColor(1,1,1)
      else love.graphics.setColor(1,1,1,0.6) end
      for k2, tile in pairs(layer) do
         local tilesheet = tile["tilesheet"]
         local quad = tile["quad"]
         local x = tile["x"]
         local y = tile["y"]
         love.graphics.draw(tileSheets[tilesheet], quad, x, y)
      end
   end

   local x, y = love.mouse.getPosition()
   if x > self.x and x < (self.x+self.width) then 
      if y > self.y and y < (self.y+self.height) then
         love.graphics.setColor(0.4,0.4,0.4)
         local relativeX = (math.floor((x)/32)*32+5)
         local relativeY = (math.floor((y)/32)*32-14)
         local relativeW = 32
         local relativeH = 32
         if self.brush == brushes["brush"] then
            relativeX = relativeX - 32
            relativeY = relativeY - 32
            relativeW = 96
            relativeH = 96
         end
         if self.brush == brushes["brushXL"] then
            relativeX = relativeX - 64
            relativeY = relativeY - 64
            relativeW = 160
            relativeH = 160
         end
         love.graphics.rectangle("line", relativeX, relativeY, relativeW, relativeH)
      end
   end
   love.graphics.setColor(1,1,1)
end

function Map:drawMenuBackground()
   love.graphics.setColor(0.9,0.9,0.9)
   love.graphics.rectangle("fill", 0, 0, 40, love.graphics.getHeight())
   love.graphics.setColor(0.8,0.8,0.8)
   love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), 40)
   love.graphics.setColor(1,1,1)
end

function Map:drawToolBar()
   if self.brush == brushes["pencil"] then love.graphics.draw(pencil, 5, 100) end
   if self.brush == brushes["brush"] then love.graphics.draw(brush, 5, 100) end
   if self.brush == brushes["brushXL"] then love.graphics.draw(brushXL, 5, 100) end
end

function Map:drawMenuBar()
end

function Map:drawHelpMenu()
   love.graphics.setColor(1,1,1)
   love.graphics.rectangle("fill", 500, 200, 300, 500)
   love.graphics.setColor(0,0,0)
   love.graphics.print("right: next spritesheet", 520,220)
   love.graphics.print("left: previous spritesheet", 520,240)
   love.graphics.print("[: down a layer", 520,260)
   love.graphics.print("]: up a layer", 520,280)
   love.graphics.print("b: cycle brush types", 520,300)
   love.graphics.print("o: Onion Skin on/off", 520,320)
   love.graphics.setColor(1,1,1)
end

-- SAVE LOAD --

function Map:save(project)
   if not self:FolderExists("/home/will-roy/dev/pokemon3/pokemaker/projects/"..project.."/") then
      lfs.mkdir("/home/will-roy/dev/pokemon3/pokemaker/projects/"..project.."/")
   end

   for k1, layer in pairs(self.layers) do
      if #layer > 0 then
         local file = io.open("/home/will-roy/dev/pokemon3/pokemaker/projects/"..project.."/tiles-l"..k1..".snorlax", "w")
         for k2, tile in pairs(layer) do
            local id = tile["id"]
            local tilesheet = tile["tilesheet"]
            local quadX = tile["quadX"]
            local quadY = tile["quadY"]
            local x = tile["x"]
            local y = tile["y"]
            file:write(id..","..tilesheet..","..quadX..","..quadY..","..x..","..y.."\n")
         end
         file:close()
      end
   end
end

function Map:load(project)
   self.project = project
   local newLayers = {}

   for i = 1, 10 do
      local file = "/home/will-roy/dev/pokemon3/pokemaker/projects/"..project.."/tiles-l"..i..".snorlax"
      local f = io.open(file, "r")
      if f then f:close() end
      if f ~= nil then
         newLayers[i] = {}
         for line in io.lines(file) do
            local lineSplit = {}
            for str in string.gmatch(line, "([^,]+)") do
               table.insert(lineSplit, str)
            end
            newLayers[i][#newLayers[i]+1] = {
               ["id"]=lineSplit[1],
               ["tilesheet"]=lineSplit[2],
               ["quad"]=love.graphics.newQuad(lineSplit[3], lineSplit[4], 32, 32, tileSheets[lineSplit[2]]),
               ["quadX"]=lineSplit[3], 
               ["quadY"]=lineSplit[4],
               ["x"]=lineSplit[5], 
               ["y"]=lineSplit[6]
            }
         end
      end
   end


   self.layers = newLayers
end

function Map:FolderExists(folder)
  if lfs.attributes(folder:gsub("\\$",""),"mode") == "directory" then
    return true
  else
    return false
  end
end

function Map:setLayer(layer)
   self.layer = layer
end

function Map:setOnionSkin(onion)
   self.onionSkin = onion
end