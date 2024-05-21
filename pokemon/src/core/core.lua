local mapREQ = require("pokemon/src/core/map")
local playerREQ = require("pokemon/src/core/player")

local wasdIMG = love.graphics.newImage("pokemon/assets/wasd.png")
local wasd = {
  ["w"]={["off"]=love.graphics.newQuad(0,0,32,32,wasdIMG),["on"]=love.graphics.newQuad(0,32,32,32,wasdIMG)},
  ["a"]={["off"]=love.graphics.newQuad(32,0,32,32,wasdIMG),["on"]=love.graphics.newQuad(32,32,32,32,wasdIMG)},
  ["s"]={["off"]=love.graphics.newQuad(64,0,32,32,wasdIMG),["on"]=love.graphics.newQuad(64,32,32,32,wasdIMG)},
  ["d"]={["off"]=love.graphics.newQuad(96,0,32,32,wasdIMG),["on"]=love.graphics.newQuad(96,32,32,32,wasdIMG)}
}

Core = {}

function Core:new(o)
  local o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Core:init(project)
  self.map = Map:new()
  self.player = Player:new()

  self.map:init(1, -32, -32, 1300, 1000)
  if project ~= nil then
    self.map:load(project)
  else
    self.map:load()
  end

  self.player:init(612, 456)

  self.move = {["busy"]=false, ["dir"]={0,0}, ["tick"]=0, ["startTick"]=0}
  self.collisions = self:loadCollision(project)
  self.debug = false
end

function Core:update(dt)
  self:movement()
  self.map:update(dt)
  self.player:update(dt)
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
      self.map:move({self.move["dir"][1]*2,self.move["dir"][2]*2})
    else
      self.move["tick"] = self.move["tick"] + (1*speed)
      self.map:move({self.move["dir"][1]*speed,self.move["dir"][2]*speed})
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

  local mapPos = self.map:getPos()
  local playerPos = self.player:getPos()

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
  self.map:draw(dt)
  self.player:draw(dt)
  self.map:drawFloatTiles()
  love.graphics.setColor(1,1,1)

  if self.debug then self:drawDebug() end
end

function Core:drawDebug()
  local mapPos = self.map:getPos()
  local playerPos = self.player:getPos()

  local relativePos = {["x"]=math.floor(((playerPos["x"]-mapPos["x"]))/32)*32+5,["y"]=math.floor(((playerPos["y"]-mapPos["y"]))/32)*32+18}

  love.graphics.setColor(1,1,1, 0.5)
  for k, tile in pairs(self.collisions) do
    local x = mapPos["x"]+tile["x"]
    local y = mapPos["y"]+tile["y"]
    love.graphics.setColor(1,0.8,0.8, 0.7)
    love.graphics.rectangle("fill", x, y, 32, 32)
    love.graphics.setColor(1,0.8,0.4)
    love.graphics.rectangle("fill", relativePos["x"]+mapPos["x"], relativePos["y"]+mapPos["y"], 32, 32)
  end

  love.graphics.setColor(1,1,1)
  if love.keyboard.isDown("w") then love.graphics.draw(wasdIMG, wasd["w"]["on"], 72, 6)
  else love.graphics.draw(wasdIMG, wasd["w"]["off"], 72, 6) end
  if love.keyboard.isDown("a") then love.graphics.draw(wasdIMG, wasd["a"]["on"], 38, 38)
  else love.graphics.draw(wasdIMG, wasd["a"]["off"], 38, 38) end
  if love.keyboard.isDown("s") then love.graphics.draw(wasdIMG, wasd["s"]["on"], 72, 38)
  else love.graphics.draw(wasdIMG, wasd["s"]["off"], 72, 38) end
  if love.keyboard.isDown("d") then love.graphics.draw(wasdIMG, wasd["d"]["on"], 104, 38)
  else love.graphics.draw(wasdIMG, wasd["d"]["off"], 104, 38) end
end

function Core:mousepressed(x, y, button, istouch)
  self.map:mousepressed(x, y, button, istouch)
  self.player:mousepressed(x, y, button, istouch)
end

function Core:mousereleased(x, y, button, istouch)
  self.map:mousereleased(x, y, button, istouch)
  self.player:mousereleased(x, y, button, istouch)
end

function Core:keypressed(key, code)
  if key == "'" then self.debug = not self.debug end
  self.map:keypressed(key, code)
  self.player:keypressed(key, code)
end

function Core:wheelmoved(x, y)
  self.map:wheelmoved(x, y)
  self.player:wheelmoved(x, y)
end

function Core:loadCollision(project)
  if (project == nil) then project = "/pokemon/db/" end

  local file = project.."cols.snorlax"

  local newCols = {}
  if love.filesystem.getInfo(file) ~= nil then
    for line in love.filesystem.lines(file) do
      local lineSplit = {}
      for str in string.gmatch(line, "([^,]+)") do
        table.insert(lineSplit, str)
      end
      newCols[#newCols+1] = {
        ["x"]=lineSplit[1],
        ["y"]=lineSplit[2]
      }
    end
  end

  return newCols
end