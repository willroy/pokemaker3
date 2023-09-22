local mapREQ = require("src/core/map")
local playerREQ = require("src/core/player")

map = Map:new()
player = Player:new()

Core = {}

function Core:new(o)
   local o = o or {}
   setmetatable(o, self)
   self.__index = self
   return o
end

function Core:init()
   map:init(1, 0, 0, 1300, 1000)
   map:load()

   player:init(614, 458)

   self.move = {["busy"]=false, ["dir"]={0,0}, ["tick"]=0, ["startTick"]=0}

   self.collisions = self:loadCollision()

   self.centerPos = {["x"]=math.floor((614)/32)*32+5,["y"]=math.floor((458+32)/32)*32-14}
end

function Core:update(dt)
   self:movement()
   map:update(dt)
   player:update(dt)
end

function Core:movement()
   if     love.keyboard.isDown("w") and not self.move["busy"] then self.move["startTick"] = self.move["startTick"] + 1
   elseif love.keyboard.isDown("s") and not self.move["busy"] then self.move["startTick"] = self.move["startTick"] + 1
   elseif love.keyboard.isDown("a") and not self.move["busy"] then self.move["startTick"] = self.move["startTick"] + 1
   elseif love.keyboard.isDown("d") and not self.move["busy"] then self.move["startTick"] = self.move["startTick"] + 1
   else self.move["startTick"] = 0 end

   local canMove = self.move["startTick"] > 8 and not self.move["busy"] and not self:hitSomething()
   if     love.keyboard.isDown("w") and canMove then self.move = {["busy"]=true, ["dir"]={0,1}, ["tick"]=0, ["startTick"]=0}
   elseif love.keyboard.isDown("s") and canMove then self.move = {["busy"]=true, ["dir"]={0,-1}, ["tick"]=0, ["startTick"]=0}
   elseif love.keyboard.isDown("a") and canMove then self.move = {["busy"]=true, ["dir"]={1,0}, ["tick"]=0, ["startTick"]=0}
   elseif love.keyboard.isDown("d") and canMove then self.move = {["busy"]=true, ["dir"]={-1,0}, ["tick"]=0, ["startTick"]=0} end
   
   if self.move["busy"] then
      local speed = 3
      if self.move["tick"] == 30 then
         self.move["tick"] = 32
         map:move({self.move["dir"][1]*2,self.move["dir"][2]*2})
      else
         self.move["tick"] = self.move["tick"] + (1*speed)
         map:move({self.move["dir"][1]*speed,self.move["dir"][2]*speed})
      end
      if self.move["tick"] == 32 then
         self.move["busy"] = false
         self.move["startTick"] = 10
      end
   end
end

function Core:hitSomething()
   local dir = {0,0}
   if love.keyboard.isDown("w") then dir = {0,-1}
   elseif love.keyboard.isDown("s") then dir = {0,1}
   elseif love.keyboard.isDown("a") then dir = {-1,0}
   elseif love.keyboard.isDown("d") then dir = {1,0} end

   local mapPos = map:getPos()
   local playerPos = player:getPos()

   local relativePos = {["x"]=math.floor(((playerPos["x"]-mapPos["x"]))/32)*32+5,["y"]=math.floor(((playerPos["y"]-mapPos["y"]))/32)*32+18}

   for i = 1, #self.collisions do
      if relativePos["x"]+(dir[1]*32) == tonumber(self.collisions[i]["x"]) then
         if relativePos["y"]+(dir[2]*32) == tonumber(self.collisions[i]["y"]) then
            return true
         end
      end
   end
   return false
end

function Core:draw()
   map:draw(dt)
   player:draw(dt)
   love.graphics.setColor(1,1,1)
end

function Core:mousepressed(x, y, button, istouch)
   map:mousepressed(x, y, button, istouch)
   player:mousepressed(x, y, button, istouch)
end

function Core:mousereleased(x, y, button, istouch)
   map:mousereleased(x, y, button, istouch)
   player:mousereleased(x, y, button, istouch)
end

function Core:keypressed(key, code)
   map:keypressed(key, code)
   player:keypressed(key, code)
end

function Core:wheelmoved(x, y)
   map:wheelmoved(x, y)
   player:wheelmoved(x, y)
end

function Core:loadCollision()
   local file = "/home/will-roy/dev/pokemon3/pokemon/db/cols.snorlax"
   local f = io.open(file, "r")
   if f then f:close() end
   if f == nil then return end
   
   local newCols = {}
   for line in io.lines(file) do
      local lineSplit = {}
      for str in string.gmatch(line, "([^,]+)") do
         table.insert(lineSplit, str)
      end
      newCols[#newCols+1] = {
         ["x"]=lineSplit[1],
         ["y"]=lineSplit[2]
      }
   end

   return newCols
end