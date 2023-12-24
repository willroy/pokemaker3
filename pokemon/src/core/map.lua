local tileSheetNames = {"interior_electronics","interior_flooring","interior_general","interior_misc","interior_misc2","interior_stairs","interior_tables","interior_walls","outside_buildings","outside_ground","outside_items","outside_misc","outside_rocks","outside_vegetation","text"}
local tileSheets = {
  ["interior_electronics"] = love.graphics.newImage("pokemon/assets/tilesheets/interior-electronics.png"),
  ["interior_flooring"] = love.graphics.newImage("pokemon/assets/tilesheets/interior-flooring.png"),
  ["interior_general"] = love.graphics.newImage("pokemon/assets/tilesheets/interior-general.png"),
  ["interior_misc"] = love.graphics.newImage("pokemon/assets/tilesheets/interior-misc.png"),
  ["interior_misc2"] = love.graphics.newImage("pokemon/assets/tilesheets/interior-misc2.png"),
  ["interior_stairs"] = love.graphics.newImage("pokemon/assets/tilesheets/interior-stairs.png"),
  ["interior_tables"] = love.graphics.newImage("pokemon/assets/tilesheets/interior-tables.png"),
  ["interior_walls"] = love.graphics.newImage("pokemon/assets/tilesheets/interior-walls.png"),
  ["outside_buildings"] = love.graphics.newImage("pokemon/assets/tilesheets/outside-buildings.png"),
  ["outside_ground"] = love.graphics.newImage("pokemon/assets/tilesheets/outside-ground.png"),
  ["outside_items"] = love.graphics.newImage("pokemon/assets/tilesheets/outside-items.png"),
  ["outside_misc"] = love.graphics.newImage("pokemon/assets/tilesheets/outside-misc.png"),
  ["outside_rocks"] = love.graphics.newImage("pokemon/assets/tilesheets/outside-rocks.png"),
  ["outside_vegetation"] = love.graphics.newImage("pokemon/assets/tilesheets/outside-vegetation.png"),
  ["text"] = love.graphics.newImage("pokemon/assets/tilesheets/text.png")
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
  self.layers = {}
  self.collisions = {}
  self.float = {}
  self.floatTiles = {}
end

function Map:update(dt)
end

function Map:draw()
  love.graphics.setColor(1,1,1)
  for k1, layer in pairs(self.layers) do
    for k2, tile in pairs(layer) do
      local tilesheet = tile["tilesheet"]
      local quad = tile["quad"]
      local x = tile["x"]
      local y = tile["y"]
      love.graphics.draw(tileSheets[tilesheet], quad, x+self.x, y+self.y)
    end
  end
end

function Map:drawZIndexes()
  love.graphics.setColor(1,1,1)
  for k, tile in pairs(self.floatTiles) do
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
  self:loadZIndex()
  self:loadTiles()
end

function Map:loadTiles()
  local newLayers = {}

  for i = 1, 10 do
    local file = "/home/will-roy/dev/pokemon3/pokemon/db/tiles-l"..i..".snorlax"
    local f = io.open(file, "r")
    if f then f:close() end
    if f ~= nil then
        newLayers[i] = {}
        for line in io.lines(file) do
          local isInZ = false
          local lineSplit = {}
          for str in string.gmatch(line, "([^,]+)") do
            table.insert(lineSplit, str)
          end

          local newTile = {
            ["id"]=lineSplit[1],
            ["tilesheet"]=lineSplit[2],
            ["quad"]=love.graphics.newQuad(lineSplit[3], lineSplit[4], 32, 32, tileSheets[lineSplit[2]]),
            ["quadX"]=lineSplit[3], 
            ["quadY"]=lineSplit[4],
            ["x"]=lineSplit[5], 
            ["y"]=lineSplit[6]
          }

          for a = 1, #self.float do
            if i == tonumber(self.float[a]["layer"]) then
              local tileXY = {["x"]=tonumber(lineSplit[5]),["y"]=tonumber(lineSplit[6])}
              local zindexXY = {["x"]=tonumber(self.float[a]["x"]),["y"]=tonumber(self.float[a]["y"])}

              if tileXY["x"] == zindexXY["x"] and tileXY["y"] == zindexXY["y"] then
                self.floatTiles[#self.floatTiles+1] = newTile
                isInZ = true
              end
            end
          end

          if not isInZ then
            newLayers[i][#newLayers[i]+1] = newTile
          end
       end
    end
  end

  self.layers = newLayers
end

function Map:loadZIndex()
  local file = "/home/will-roy/dev/pokemon3/pokemon/db/float.snorlax"
  local f = io.open(file, "r")
  if f then f:close() end
  if f == nil then return end

  local newFloatTiles = {}
  for line in io.lines(file) do
    local lineSplit = {}
    for str in string.gmatch(line, "([^,]+)") do
      table.insert(lineSplit, str)
    end

    newFloatTiles[#newFloatTiles+1] = {
      ["layer"]=lineSplit[1],
      ["x"]=lineSplit[2],
      ["y"]=lineSplit[3]
    }
  end

  self.float = newFloatTiles
end

function Map:move(dir)
  self.x = self.x + dir[1]
  self.y = self.y + dir[2]
end

function Map:getPos()
  return {["x"]=self.x,["y"]=self.y}
end