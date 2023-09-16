local tilegridREQ = require("src/core/tile-grid")
local tilepaletteREQ = require("src/core/tile-palette")

local background = love.graphics.newImage("assets/game/background.png")

local interior_electronics = love.graphics.newImage("assets/tilesheets/interior-electronics.png")
local interior_flooring = love.graphics.newImage("assets/tilesheets/interior-flooring.png")
local interior_general = love.graphics.newImage("assets/tilesheets/interior-general.png")
local interior_misc = love.graphics.newImage("assets/tilesheets/interior-misc.png")
local interior_misc2 = love.graphics.newImage("assets/tilesheets/interior-misc2.png")
local interior_stairs = love.graphics.newImage("assets/tilesheets/interior-stairs.png")
local interior_tables = love.graphics.newImage("assets/tilesheets/interior-tables.png")
local interior_walls = love.graphics.newImage("assets/tilesheets/interior-walls.png")

local outside_buildings = love.graphics.newImage("assets/tilesheets/outside-buildings.png")
local outside_ground = love.graphics.newImage("assets/tilesheets/outside-ground.png")
local outside_items = love.graphics.newImage("assets/tilesheets/outside-items.png")
local outside_misc = love.graphics.newImage("assets/tilesheets/outside-misc.png")
local outside_rocks = love.graphics.newImage("assets/tilesheets/outside-rocks.png")
local outside_vegetation = love.graphics.newImage("assets/tilesheets/outside-vegetation.png")

local tileSheets = {
   ["interior_electronics"] = interior_electronics,
   ["interior_flooring"] = interior_flooring,
   ["interior_general"] = interior_general,
   ["interior_misc"] = interior_misc,
   ["interior_misc2"] = interior_misc2,
   ["interior_stairs"] = interior_stairs,
   ["interior_tables"] = interior_tables,
   ["interior_walls"] = interior_walls,
   ["outside_buildings"] = outside_buildings,
   ["outside_ground"] = outside_ground,
   ["outside_items"] = outside_items,
   ["outside_misc"] = outside_misc,
   ["outside_rocks"] = outside_rocks,
   ["outside_vegetation"] = outside_vegetation
}

tilePalette = Tilepalette:new()
workspaceTileGrid = Tilegrid:new()

Game = {}

function Game:new(o)
   local o = o or {}
   setmetatable(o, self)
   self.__index = self
   return o
end

function Game:init(project, new)
   self.project = project or ""

   if new then
      if self.project == "" then self.project = "New-Project" end
      self:save()
   end

   tilePalette:init(1, 2, 2, 256, 985, tileSheets["outside_buildings"], "outside_buildings")

   workspaceTileGrid:init(2, 260, 50, 1036, 935)
end

function Game:update(dt)
   tilePalette:update(dt)
   workspaceTileGrid:update(dt)
end

function Game:draw()
   love.graphics.draw(background, 0, 0)

   tilePalette:draw(dt)
   workspaceTileGrid:draw(dt)
end

function Game:mousepressed(x, y, button, istouch)
   tilePalette:mousepressed(x, y, button, istouch)
   workspaceTileGrid:mousepressed(x, y, button, istouch)
end

function Game:mousereleased(x, y, button, istouch)
   tilePalette:mousereleased(x, y, button, istouch)
   workspaceTileGrid:mousereleased(x, y, button, istouch)
end

function Game:keypressed(key, code)
   tilePalette:keypressed(key, code)
   workspaceTileGrid:keypressed(key, code)
end

function Game:wheelmoved(x, y)
   tilePalette:wheelmoved(x, y)
   workspaceTileGrid:wheelmoved(x, y)
end

function Game:save()

end