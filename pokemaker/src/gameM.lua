local mapREQ = require("pokemaker/src/core/mapM")
local paletteREQ = require("pokemaker/src/core/paletteM")

local tileSheetNames = {"interior_electronics","interior_flooring","interior_general","interior_misc","interior_misc2","interior_stairs","interior_tables","interior_walls","outside_buildings","outside_ground","outside_items","outside_misc","outside_rocks","outside_vegetation","text"}
local tileSheets = {
   ["interior_electronics"] = love.graphics.newImage("pokemaker/assets/tilesheets/interior-electronics.png"),
   ["interior_flooring"] = love.graphics.newImage("pokemaker/assets/tilesheets/interior-flooring.png"),
   ["interior_general"] = love.graphics.newImage("pokemaker/assets/tilesheets/interior-general.png"),
   ["interior_misc"] = love.graphics.newImage("pokemaker/assets/tilesheets/interior-misc.png"),
   ["interior_misc2"] = love.graphics.newImage("pokemaker/assets/tilesheets/interior-misc2.png"),
   ["interior_stairs"] = love.graphics.newImage("pokemaker/assets/tilesheets/interior-stairs.png"),
   ["interior_tables"] = love.graphics.newImage("pokemaker/assets/tilesheets/interior-tables.png"),
   ["interior_walls"] = love.graphics.newImage("pokemaker/assets/tilesheets/interior-walls.png"),
   ["outside_buildings"] = love.graphics.newImage("pokemaker/assets/tilesheets/outside-buildings.png"),
   ["outside_ground"] = love.graphics.newImage("pokemaker/assets/tilesheets/outside-ground.png"),
   ["outside_items"] = love.graphics.newImage("pokemaker/assets/tilesheets/outside-items.png"),
   ["outside_misc"] = love.graphics.newImage("pokemaker/assets/tilesheets/outside-misc.png"),
   ["outside_rocks"] = love.graphics.newImage("pokemaker/assets/tilesheets/outside-rocks.png"),
   ["outside_vegetation"] = love.graphics.newImage("pokemaker/assets/tilesheets/outside-vegetation.png"),
   ["text"] = love.graphics.newImage("pokemaker/assets/tilesheets/text.png")
}

GameM = {}

function GameM:new(o)
   local o = o or {}
   setmetatable(o, self)
   self.__index = self
   return o
end

function GameM:init(project, new)
   self.project = project or "project1"

   if new then
      if self.project == "" then self.project = "New-Project" end
      self:save()
   end

   local mainX = 1300
   local mainY = 1000

   self.palette = PaletteM:new()
   self.map = MapM:new()

   self.palette:init(1, 40, 38, 224, mainY-40, tileSheets["outside_buildings"], "outside_buildings")

   self.map:init(1, 38, 38, mainX-40, mainY-32)
   self.map:load(self.project)

   self.selectedTileSheet = 0
end

function GameM:update(dt)
   self.palette:update(dt)
   self.map:update(dt)
end

function GameM:draw()
   self.map:draw(dt)
   self.palette:draw(dt)
end

function GameM:mousepressed(x, y, button, istouch)
   self.palette:mousepressed(x, y, button, istouch)
   self.map:mousepressed(x, y, button, istouch)
end

function GameM:mousereleased(x, y, button, istouch)
   self.palette:mousereleased(x, y, button, istouch)
   self.map:mousereleased(x, y, button, istouch)
end

function GameM:keypressed(key, code)
   if key == "escape" then
      self:save()
      setCurrent("pmak-menu")
   end

   -- if key == "s" then self:save() end
   -- if key == "l" then self:load() end#

   if key == "right" and self.selectedTileSheet < #tileSheetNames then
      self.selectedTileSheet = self.selectedTileSheet + 1
      self.palette:setTileSheet(tileSheets[tileSheetNames[self.selectedTileSheet]],tileSheetNames[self.selectedTileSheet])
   end
   if key == "left" and self.selectedTileSheet > 1 then
      self.selectedTileSheet = self.selectedTileSheet - 1
      self.palette:setTileSheet(tileSheets[tileSheetNames[self.selectedTileSheet]],tileSheetNames[self.selectedTileSheet])
   end

   self.palette:keypressed(key, code)
   self.map:keypressed(key, code)
end

function GameM:wheelmoved(x, y)
   self.palette:wheelmoved(x, y)
   self.map:wheelmoved(x, y)
end

function GameM:save()
   self.map:save(self.project)
end

function GameM:load()
   self.map:load(self.project)
end

function GameM:setFolder(project)
   self.project = project
end

function GameM:getPalette()
   return self.palette
end