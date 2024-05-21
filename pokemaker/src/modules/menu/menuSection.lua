MenuSectionM = {}

function MenuSectionM:new(o)
  local o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function MenuSectionM:init(name, weight)
  self.name = name or ""
  self.weight = weight or 0
end

function MenuSectionM:update(dt)
end

function MenuSectionM:draw()
  love.graphics.setColor(0.78,0.78,0.78)
  love.graphics.rectangle("fill", 100*self.weight+6, 4, 95, 30)
  love.graphics.setColor(0,0,0)
  local middleOfBox = (100*self.weight+6)+47.5
  local pos = middleOfBox - (love.graphics.getFont():getWidth(self.name)/2)
  love.graphics.print(self.name, pos, 11)
end

function MenuSectionM:mousepressed(x, y, button, istouch)
  if x > 100*self.weight+6 and x < (100*self.weight+6)+95 then
    if y > 4 and y < 34 then
      print("Clicked "..self.name)
    end
  end
end

function MenuSectionM:mousereleased(x, y, button, istouch)
end

function MenuSectionM:keypressed(key, code)
end

function MenuSectionM:wheelmoved(x, y)
end