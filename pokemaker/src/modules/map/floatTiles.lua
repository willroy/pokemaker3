local brushes = {
  ["pencil"]={{0,0}},
  ["brush"]={{0,0},{0,1},{1,1},{1,0},{1,-1},{0,-1},{-1,-1},{-1,0},{-1,1}}
}

FloatTilesM = {}

function FloatTilesM:new(o)
  local o = o or {}
  setmetatable(o, self)
  self.__index = self
  self.hasBeenInit = false
  return o
end

function FloatTilesM:init(id, x, y, width, height)
  self.id = id or 0
  self.x = x or 0
  self.y = y or 0
  self.width = width or 0
  self.height = height or 0
  self.backColor = {1,1,1}
  self.floatTiles = {}

  self.lastUpdated = {}
  self.lastDeleted = {}

  self.brush = brushes["pencil"]

  self.project = ""
  self.mapFile = ""

  self.layer = 1

  current:getMap():setOnionSkin(true)
end

function FloatTilesM:update(dt)
  self:removeTile()
  self:placeTile()
end

function FloatTilesM:removeTile()
  local x, y = love.mouse.getPosition()
  x = x - current:getMap().moveX
  y = y - current:getMap().moveY
  local pressed = love.mouse.isDown(2)

  if not pressed then return false end
  if x < self.x or x > (self.x+self.width) then return false end
  if y < self.y or y > (self.y+self.height) then return false end

  local relativeX = math.floor((x)/32)*32+5
  local relativeY = math.floor((y)/32)*32-14

  if self.lastDeleted[1] == relativeX and self.lastDeleted[2] == relativeY then return false end

  local newCols = {}

  for k, col in pairs(self.floatTiles) do
    local found = false
    for i = 1, #self.brush do
      local brushX = relativeX+(self.brush[i][1]*32)
      local brushY = relativeY+(self.brush[i][2]*32)
      local x = tonumber(col["x"])
      local y = tonumber(col["y"])
      if ( x == brushX and y == brushY ) then found = true end
    end
    if not found then
      newCols[#newCols+1] = col
    end
  end

  self.floatTiles = newCols
  self.lastDeleted = {relativeX, relativeY}
end

function FloatTilesM:placeTile()
  local x, y = love.mouse.getPosition()
  x = x - current:getMap().moveX
  y = y - current:getMap().moveY
  local pressed = love.mouse.isDown(1)

  if not pressed then return false end
  if x < self.x or x > (self.x+self.width) then return false end
  if y < self.y or y > (self.y+self.height) then return false end

  local relativeX = math.floor((x)/32)*32+5
  local relativeY = math.floor((y)/32)*32-14

  if self.lastUpdated[1] == relativeX and self.lastUpdated[2] == relativeY then return false end

  for i = 1, #self.brush do
    local newCol = {
    ["layer"]=self.layer, 
    ["x"]=relativeX+(self.brush[i][1]*32), 
    ["y"]=relativeY+(self.brush[i][2]*32)
    }

    local replaced = false
    for k, tile in pairs(self.floatTiles) do
      local x = relativeX+(self.brush[i][1]*32)
      local y = relativeY+(self.brush[i][2]*32)
      local tileX = tonumber(tile["x"])
      local tileY = tonumber(tile["y"])
      if x == tileX and y == tileY then
        self.floatTiles[k] = newCol
        replaced = true
      end
    end

    if not replaced then self.floatTiles[#self.floatTiles+1] = newCol end
  end

  self.lastUpdated = {relativeX, relativeY}
end

function FloatTilesM:draw()
  love.graphics.setColor(1,1,1, 0.5)
  for k, tile in pairs(self.floatTiles) do
    local x = tile["x"]
    local y = tile["y"]
    love.graphics.setColor(1,0.8,0.8, 0.7)
    love.graphics.rectangle("fill", x+current:getMap().moveX, y+current:getMap().moveY, 32, 32)
  end
  love.graphics.setColor(0,0,0)
  love.graphics.print("Layer: "..self.layer, 1200,15)
  love.graphics.setColor(1,1,1)
end

function FloatTilesM:mousepressed(x, y, button, istouch)
end

function FloatTilesM:mousereleased(x, y, button, istouch)
end

function FloatTilesM:keypressed(key, code)
  if key == "escape" then
    current:getMap().mode = "tiles"
    current:getMap():setOnionSkin(false)
    self.hasBeenInit = false
  end

  if key == "[" and self.layer > 1 then
    self.layer = self.layer - 1
    current:getMap():setLayer(self.layer)
  elseif key == "]" then
    self.layer = self.layer + 1
    current:getMap():setLayer(self.layer)
  end
end

function FloatTilesM:wheelmoved(x, y)
end

function FloatTilesM:save(project, mapFile)
  if not self:FolderExists(love.filesystem.getWorkingDirectory().."/pokemaker/projects/"..project.."/maps/"..mapFile.."/") then
    lfs.mkdir(love.filesystem.getWorkingDirectory().."/pokemaker/projects/"..project.."/maps/"..mapFile.."/")
  end

  local file = io.open(love.filesystem.getWorkingDirectory().."/pokemaker/projects/"..project.."/maps/"..mapFile.."/float.snorlax", "w")

  for k, tile in pairs(self.floatTiles) do
    local layer = tile["layer"]
    local x = tile["x"]
    local y = tile["y"]
    file:write(layer..","..x..","..y.."\n")
  end

  file:close()
end

function FloatTilesM:load(project, mapFile)
  self.project = project
  self.mapFile = mapFile
  local file = love.filesystem.getWorkingDirectory().."/pokemaker/projects/"..project.."/maps/"..mapFile.."/float.snorlax"
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
    ["layer"]=lineSplit[1],
    ["x"]=lineSplit[2],
    ["y"]=lineSplit[3]
    }
  end

  self.floatTiles = newTiles
end

function FloatTilesM:FolderExists(folder)
  if love.filesystem.getInfo( folder )["type"] == "directory" then
    return true
  else
    return false
  end
end