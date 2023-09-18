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
end

function Core:update(dt)
   self:movement()
   map:update(dt)
   player:update(dt)
end

function Core:movement()
   if     love.keyboard.isDown("w") and not self.move["busy"] then self.move["startTick"] = self.move["startTick"] + 1
   elseif love.keyboard.isDown("a") and not self.move["busy"] then self.move["startTick"] = self.move["startTick"] + 1
   elseif love.keyboard.isDown("s") and not self.move["busy"] then self.move["startTick"] = self.move["startTick"] + 1
   elseif love.keyboard.isDown("d") and not self.move["busy"] then self.move["startTick"] = self.move["startTick"] + 1
   else self.move["startTick"] = 0 end

   local startMove = self.move["startTick"] > 8 and not self.move["busy"]
   if     love.keyboard.isDown("w") and startMove then self.move = {["busy"]=true, ["dir"]={0,1}, ["tick"]=0, ["startTick"]=0}
   elseif love.keyboard.isDown("s") and startMove then self.move = {["busy"]=true, ["dir"]={0,-1}, ["tick"]=0, ["startTick"]=0}
   elseif love.keyboard.isDown("a") and startMove then self.move = {["busy"]=true, ["dir"]={1,0}, ["tick"]=0, ["startTick"]=0}
   elseif love.keyboard.isDown("d") and startMove then self.move = {["busy"]=true, ["dir"]={-1,0}, ["tick"]=0, ["startTick"]=0} end
   
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

function Core:draw()
   map:draw(dt)
   player:draw(dt)
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