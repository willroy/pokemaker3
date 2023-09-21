require "lfs"

local grid = love.graphics.newImage("assets/game/grid.png")

local brushes = {
   ["pencil"]={{0,0}},
   ["brush"]={{0,0},{0,1},{1,1},{1,0},{1,-1},{0,-1},{-1,-1},{-1,0},{-1,1}}
}

local tileSheetNames = {"interior_electronics","interior_flooring","interior_general","interior_misc","interior_misc2","interior_stairs","interior_tables","interior_walls","outside_buildings","outside_ground","outside_items","outside_misc","outside_rocks","outside_vegetation"}
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
   ["outside_vegetation"] = love.graphics.newImage("assets/tilesheets/outside-vegetation.png")
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
   self.width = width or 0
   self.height = height or 0
   self.backColor = {1,1,1}
   self.tiles = {}

   self.gridQuad = love.graphics.newQuad(0, 0, self.width, self.height, grid)

   self.lastUpdated = {}

   self.brush = brushes["pencil"]
end

function Map:update(dt)
   self:placeTile()
end

function Map:placeTile()
   local x, y = love.mouse.getPosition()
   local pressed = love.mouse.isDown(1)

   if not pressed then return false end
   if x < self.x or x > (self.x+self.width) then return false end
   if y < self.y or y > (self.y+self.height) then return false end

   local relativeX = math.floor((x)/32)*32+5
   local relativeY = math.floor((y)/32)*32-14

   if self.lastUpdated[1] == relativeX and self.lastUpdated[2] == relativeY then return false end
   
   local selectedTile = palette:getSelected()
   local tileQuad = love.graphics.newQuad(selectedTile[2]["x"], selectedTile[2]["y"], selectedTile[2]["w"], selectedTile[2]["h"], tileSheets[selectedTile[1]])

   for i = 1, #self.brush do
      local newTile = {
         ["id"]=#self.tiles+1,
         ["tilesheet"]=selectedTile[1],
         ["quad"]=tileQuad, 
         ["quadX"]=selectedTile[2]["x"], 
         ["quadY"]=selectedTile[2]["y"],
         ["quadW"]=selectedTile[2]["w"], 
         ["quadH"]=selectedTile[2]["h"], 
         ["x"]=relativeX+(self.brush[i][1]*32), 
         ["y"]=relativeY+(self.brush[i][2]*32)
      }
      
      local replaced = false
      for k, tile in pairs(self.tiles) do
         local x = relativeX+(self.brush[i][1]*32)
         local y = relativeY+(self.brush[i][2]*32)
         local tileX = tonumber(tile["x"])
         local tileY = tonumber(tile["y"])
         if x == tileX and y == tileY then
            self.tiles[k] = newTile
            replaced = true
         end
      end

      if not replaced then self.tiles[#self.tiles+1] = newTile end
   end

   self.lastUpdated = {relativeX, relativeY}
end

function Map:draw()
   love.graphics.setColor(1,1,1)
   love.graphics.draw(grid, self.gridQuad, self.x, self.y)
   for k, tile in pairs(self.tiles) do
      local tilesheet = tile["tilesheet"]
      local quad = tile["quad"]
      local x = tile["x"]
      local y = tile["y"]
      love.graphics.draw(tileSheets[tilesheet], quad, x, y)
   end
end

function Map:mousepressed(x, y, button, istouch)
end

function Map:mousereleased(x, y, button, istouch)
end

function Map:keypressed(key, code)
end

function Map:wheelmoved(x, y)
end

function Map:save(project)
   if not self:FolderExists("/home/will-roy/dev/pokemon3/pokemaker/projects/"..project.."/") then
      lfs.mkdir("/home/will-roy/dev/pokemon3/pokemaker/projects/"..project.."/")
   end

   local file = io.open("/home/will-roy/dev/pokemon3/pokemaker/projects/"..project.."/tiles.snorlax", "w")

   for k, tile in pairs(self.tiles) do
      local id = tile["id"]
      local tilesheet = tile["tilesheet"]
      local quadX = tile["quadX"]
      local quadY = tile["quadY"]
      local quadW = tile["quadW"]
      local quadH = tile["quadH"]
      local x = tile["x"]
      local y = tile["y"]
      file:write(id..","..tilesheet..","..quadX..","..quadY..","..quadW..","..quadH..","..x..","..y.."\n")
   end

  file:close()
end

function Map:load(project)
   local file = "/home/will-roy/dev/pokemon3/pokemaker/projects/"..project.."/tiles.snorlax"
   local f = io.open(file, "r")
   if f then f:close() end
   if f == nil then return false end

   local newTiles = {}

   for line in io.lines(file) do
      local lineSplit = {}
      for str in string.gmatch(line, "([^,]+)") do
         table.insert(lineSplit, str)
      end
      newTiles[#newTiles+1] = {
         ["id"]=lineSplit[1],
         ["tilesheet"]=lineSplit[2],
         ["quad"]=love.graphics.newQuad(lineSplit[3], lineSplit[4], lineSplit[5], lineSplit[6], tileSheets[lineSplit[2]]),
         ["quadX"]=lineSplit[3], 
         ["quadY"]=lineSplit[4],
         ["quadW"]=lineSplit[5], 
         ["quadH"]=lineSplit[6], 
         ["x"]=lineSplit[7], 
         ["y"]=lineSplit[8]
      }
   end

   self.tiles = newTiles
end

function Map:FolderExists(folder)
  if lfs.attributes(folder:gsub("\\$",""),"mode") == "directory" then
    return true
  else
    return false
  end
end

function Map:getTileToDelete(x, y)
end