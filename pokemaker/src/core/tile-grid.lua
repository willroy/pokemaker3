require "lfs"

Tilegrid = {}

local grid = love.graphics.newImage("assets/game/grid.png")

function Tilegrid:new(o)
   local o = o or {}
   setmetatable(o, self)
   self.__index = self
   return o
end

function Tilegrid:init(id, x, y, width, height)
   self.id = id or 0
   self.x = x or 0
   self.y = y or 0
   self.width = width or 0
   self.height = height or 0
   self.backColor = {1,1,1}

   self.gridQuad = love.graphics.newQuad(0, 0, self.width, self.height, grid)

   self.tileSheets = {
      ["interior_electronics"] = {["image"]=love.graphics.newImage("assets/tilesheets/interior-electronics.png"), ["tiles"]={}},
      ["interior_flooring"] = {["image"]=love.graphics.newImage("assets/tilesheets/interior-flooring.png"), ["tiles"]={}},
      ["interior_general"] = {["image"]=love.graphics.newImage("assets/tilesheets/interior-general.png"), ["tiles"]={}},
      ["interior_misc"] = {["image"]=love.graphics.newImage("assets/tilesheets/interior-misc.png"), ["tiles"]={}},
      ["interior_misc2"] = {["image"]=love.graphics.newImage("assets/tilesheets/interior-misc2.png"), ["tiles"]={}},
      ["interior_stairs"] = {["image"]=love.graphics.newImage("assets/tilesheets/interior-stairs.png"), ["tiles"]={}},
      ["interior_tables"] = {["image"]=love.graphics.newImage("assets/tilesheets/interior-tables.png"), ["tiles"]={}},
      ["interior_walls"] = {["image"]=love.graphics.newImage("assets/tilesheets/interior-walls.png"), ["tiles"]={}},
      ["outside_buildings"] = {["image"]=love.graphics.newImage("assets/tilesheets/outside-buildings.png"), ["tiles"]={}},
      ["outside_ground"] = {["image"]=love.graphics.newImage("assets/tilesheets/outside-ground.png"), ["tiles"]={}},
      ["outside_items"] = {["image"]=love.graphics.newImage("assets/tilesheets/outside-items.png"), ["tiles"]={}},
      ["outside_misc"] = {["image"]=love.graphics.newImage("assets/tilesheets/outside-misc.png"), ["tiles"]={}},
      ["outside_rocks"] = {["image"]=love.graphics.newImage("assets/tilesheets/outside-rocks.png"), ["tiles"]={}},
      ["outside_vegetation"] = {["image"]=love.graphics.newImage("assets/tilesheets/outside-vegetation.png"), ["tiles"]={}}
   }

   self.lastUpdated = {}
end

function Tilegrid:update(dt)
   self:placeTile()
end

function Tilegrid:placeTile()
   local x, y = love.mouse.getPosition()
   local pressed = love.mouse.isDown(1)

   if not pressed then return false end
   if x < self.x or x > (self.x+self.width) then return false end
   if y < self.y or y > (self.y+self.height) then return false end

   local relativeX = math.floor((x)/32)*32+5
   local relativeY = math.floor((y)/32)*32-14

   if self.lastUpdated[1] == relativeX and self.lastUpdated[2] == relativeY then return false end
   
   local selectedTile = tilePalette:getSelected()
   local tiles = self.tileSheets[selectedTile[1]]["tiles"]
   local tileQuad = love.graphics.newQuad(selectedTile[2]["x"], selectedTile[2]["y"], selectedTile[2]["w"], selectedTile[2]["h"], self.tileSheets[selectedTile[1]]["image"])

   print(selectedTile[2]["x"])
   print(selectedTile[2]["y"])
   print(selectedTile[2]["w"])
   print(selectedTile[2]["h"])

   tiles[#tiles+1] = {
      ["quad"]=tileQuad, 
      ["quadX"]=selectedTile[2]["x"], 
      ["quadY"]=selectedTile[2]["y"],
      ["quadW"]=selectedTile[2]["w"], 
      ["quadH"]=selectedTile[2]["h"], 
      ["x"]=relativeX, 
      ["y"]=relativeY
   }

   self.lastUpdated = {relativeX, relativeY}
   self.tileSheets[selectedTile[1]]["tiles"] = tiles
end

function Tilegrid:draw()
   love.graphics.setColor(1,1,1)
   love.graphics.draw(grid, self.gridQuad, self.x, self.y)

   for sheet, tiles in pairs(self.tileSheets) do
      print(#tiles["tiles"])
      for i = 1, #tiles["tiles"] do
         local quad = tiles["tiles"][i]["quad"]
         local x = tiles["tiles"][i]["x"]
         local y = tiles["tiles"][i]["y"]
         love.graphics.draw(tiles["image"], quad, x, y)
      end 
   end
end

function Tilegrid:mousepressed(x, y, button, istouch)
end

function Tilegrid:mousereleased(x, y, button, istouch)
end

function Tilegrid:keypressed(key, code)
end

function Tilegrid:wheelmoved(x, y)
end

function Tilegrid:save(project)
   if not self:FolderExists("/home/will-roy/pokemon/pokemon3/pokemaker/projects/"..project.."/") then
      lfs.mkdir("/home/will-roy/pokemon/pokemon3/pokemaker/projects/"..project.."/")
   end

   local file = io.open("/home/will-roy/pokemon/pokemon3/pokemaker/projects/"..project.."/tiles.snorlax", "w")

   for sheet, tiles in pairs(self.tileSheets) do
      file:write("= "..sheet.."\n")
      for i = 1, #tiles["tiles"] do
         local quadX = tiles["tiles"][i]["quadX"]
         local quadY = tiles["tiles"][i]["quadY"]
         local quadW = tiles["tiles"][i]["quadW"]
         local quadH = tiles["tiles"][i]["quadH"]
         local x = tiles["tiles"][i]["x"]
         local y = tiles["tiles"][i]["y"]
         file:write(quadX..","..quadY..","..quadW..","..quadH..","..x..","..y.."\n")
      end 
   end

  file:close()
end

function Tilegrid:load(project)
   local file = "/home/will-roy/pokemon/pokemon3/pokemaker/projects/"..project.."/tiles.snorlax"
   local f = io.open(file, "r")
   if f then f:close() end
   if f == nil then return false end

   local newTileSheets = {
      ["interior_electronics"] = {["image"]=love.graphics.newImage("assets/tilesheets/interior-electronics.png"), ["tiles"]={}},
      ["interior_flooring"] = {["image"]=love.graphics.newImage("assets/tilesheets/interior-flooring.png"), ["tiles"]={}},
      ["interior_general"] = {["image"]=love.graphics.newImage("assets/tilesheets/interior-general.png"), ["tiles"]={}},
      ["interior_misc"] = {["image"]=love.graphics.newImage("assets/tilesheets/interior-misc.png"), ["tiles"]={}},
      ["interior_misc2"] = {["image"]=love.graphics.newImage("assets/tilesheets/interior-misc2.png"), ["tiles"]={}},
      ["interior_stairs"] = {["image"]=love.graphics.newImage("assets/tilesheets/interior-stairs.png"), ["tiles"]={}},
      ["interior_tables"] = {["image"]=love.graphics.newImage("assets/tilesheets/interior-tables.png"), ["tiles"]={}},
      ["interior_walls"] = {["image"]=love.graphics.newImage("assets/tilesheets/interior-walls.png"), ["tiles"]={}},
      ["outside_buildings"] = {["image"]=love.graphics.newImage("assets/tilesheets/outside-buildings.png"), ["tiles"]={}},
      ["outside_ground"] = {["image"]=love.graphics.newImage("assets/tilesheets/outside-ground.png"), ["tiles"]={}},
      ["outside_items"] = {["image"]=love.graphics.newImage("assets/tilesheets/outside-items.png"), ["tiles"]={}},
      ["outside_misc"] = {["image"]=love.graphics.newImage("assets/tilesheets/outside-misc.png"), ["tiles"]={}},
      ["outside_rocks"] = {["image"]=love.graphics.newImage("assets/tilesheets/outside-rocks.png"), ["tiles"]={}},
      ["outside_vegetation"] = {["image"]=love.graphics.newImage("assets/tilesheets/outside-vegetation.png"), ["tiles"]={}}
   }

   local currentSheet = ""
   for line in io.lines(file) do
      if string.sub(line, 1, 1) == "=" then
         currentSheet = string.sub(line, 3, line:len())
      else
         local lineSplit = {}
         for str in string.gmatch(line, "([^,]+)") do
            table.insert(lineSplit, str)
         end

         local quadX = lineSplit[1]
         local quadY = lineSplit[2]
         local quadW = lineSplit[3]
         local quadH = lineSplit[4]
         local x = lineSplit[5]
         local y = lineSplit[6]

         newTileSheets[currentSheet]["tiles"][#newTileSheets[currentSheet]["tiles"]+1] = {
            ["quad"]=love.graphics.newQuad(lineSplit[1], lineSplit[2], lineSplit[3], lineSplit[4], newTileSheets[currentSheet]["image"]),
            ["quadX"]=lineSplit[1], 
            ["quadY"]=lineSplit[2],
            ["quadW"]=lineSplit[3], 
            ["quadH"]=lineSplit[4], 
            ["x"]=lineSplit[5], 
            ["y"]=lineSplit[6]
         }
      end
   end

   self.tileSheets = newTileSheets
end

function Tilegrid:FolderExists(folder)
  if lfs.attributes(folder:gsub("\\$",""),"mode") == "directory" then
    return true
  else
    return false
  end
end