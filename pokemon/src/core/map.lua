local grid = love.graphics.newImage("assets/grid.png")

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
end

function Map:update(dt)
end

function Map:draw()
   love.graphics.setColor(1,1,1)
   love.graphics.draw(grid, self.gridQuad, self.x, self.y)
   for k, tile in pairs(self.tiles) do
      local tilesheet = tile["tilesheet"]
      local quad = tile["quad"]
      local x = tile["x"]
      local y = tile["y"]
      love.graphics.draw(tileSheets[tilesheet], quad, x+self.x, y+self.y)
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

function Map:load(project)
   local file = "/home/will-roy/dev/pokemon3/pokemon/db/tiles.snorlax"
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

function Map:move(dir)
   self.x = self.x + dir[1]
   self.y = self.y + dir[2]
end